//
//  SearchViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/09.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   
    var stockUser = StockUsers.userInstance
    let currentUser = CurrentUser.sharedInstance
    var currentIndexPath: NSIndexPath!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.placeholder = "ニックネームを入力してください"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        self.view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockUser.userArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as! SearchCell
        let user = stockUser.userArray[indexPath.row]
        cell.nameLabel.text = user.name
        cell.avatar.image = user.avatar
        cell.avatar.layer.cornerRadius = 27
        cell.avatar.layer.masksToBounds = true
        cell.followButton.layer.borderWidth = 1
        cell.followButton.layer.borderColor = UIColor(red: 217/255.0, green: 138/255.0, blue: 4/255.0, alpha: 0.4).CGColor
        cell.followButton.layer.cornerRadius = 5
     
        cell.followButton.tag = indexPath.row
        
       
        cell.followButton.addTarget(self, action: "tapFollowButton:", forControlEvents: UIControlEvents.TouchUpInside)
//        cell.followButton.addTarget(self, action: "tapButton:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }

    func tapGesture(sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
//    func tapButton(sender: UIButton) {
//        sender.setTitle("フォロー解除", forState: UIControlState.Normal)
//        sender.backgroundColor = UIColor.blackColor()
//        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        sender.titleLabel?.font = UIFont(name: "HirakakuProN-W6", size: 13)
//    }
    
    func tapResetFollowButton(sender: UIButton) {
        
    }
    
    //フォローボタン押した時の処理
    func tapFollowButton(sender: UIButton) {
        
        var user = stockUser.userArray[sender.tag]

    
        var params: [String: AnyObject] = [
            "id": currentUser.id,
            "name": user.name,
            "followState": user.followState
            ]
        
        Alamofire.request(.POST, "http://localhost:3000/api/users/follow", parameters: params, encoding: .URL).responseJSON { (request, response, JSON, error) in
            println("=======SEARCHFOLLOW JSON=======")
            println(JSON)
            println("=========ERROR================")
            println(error)
//            println(JSON!["follow"])
            
            var follow_type = JSON?["follow"]
            
            if (follow_type != nil) {
                sender.setTitle("フォロー解除", forState: UIControlState.Normal)
                sender.backgroundColor = UIColor(red: 217/255.0, green: 138/255.0, blue: 4/255.0, alpha: 0.4)
                sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                sender.titleLabel?.font = UIFont(name: "HirakakuProN-W6", size: 13)
                sender.layer.borderColor = UIColor.whiteColor().CGColor
                sender.layer.cornerRadius = 5
            } else {
                sender.setTitle("フォロー", forState: UIControlState.Normal)
                sender.backgroundColor = UIColor.whiteColor()
                sender.setTitleColor(UIColor(red: 217/255.0, green: 138/255.0, blue: 4/255.0, alpha: 0.4)
                    , forState: UIControlState.Normal)
                sender.titleLabel?.font = UIFont(name: "HirakakuProN-W6", size: 15)
                sender.layer.borderColor = UIColor(red: 217/255.0, green: 138/255.0, blue: 4/255.0, alpha: 0.4).CGColor
                sender.layer.borderWidth = 1
                sender.layer.cornerRadius = 5

            }
        }
    }
    
    //キーボードのcancelボタンが押された時のメソッド
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    //キーボードのsearchが押された時のメソッド
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var params: [String: AnyObject] = [
            "name": searchBar.text
        ]
        
        
        Alamofire.request(.GET, "http://localhost:3000/api/users",parameters: params, encoding: .URL)
            .responseJSON { (request, response, JSON, error) in
                println("=========SEARCH JSON=======")
                println(JSON)
                println("=========error=====")
                println(error)
                
                StockUsers.userInstance.userArray = []
                if error == nil {
                    var users = JSON!["users"] as! Array<AnyObject>
                    //JSONで返ってくる値は辞書型の配列なのでusersは配列、userは辞書型
                    for user in users {
                        let myUser = User()
                        //userは辞書型なのでUser型の変数myUserに１個ずつ代入していく
                        myUser.name = user["name"] as! String!
                        let urlAvatarKey = user["avatar"] as! Dictionary<String, AnyObject>
                        let urlAvatarKey2 = urlAvatarKey["avatar"] as! Dictionary<String, AnyObject>
                        if let imageURL = urlAvatarKey2["url"] as? String {
                            let image = UIImage.convertToUIImageFromImagePass(imageURL)
                            myUser.avatar = image
                        }

                        StockUsers.userInstance.addUser(myUser)
                        self.tableView.reloadData()
                    }
                }
        }
        
        
    }



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
