//
//  FollowerTableViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/05.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class FollowerTableViewController: UITableViewController {
    
    let currentUser = CurrentUser.sharedInstance
    var stockFollower = StockFollowers.userInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        fetchFollowers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return stockFollower.userArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FollowerCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("followerCell", forIndexPath: indexPath) as! FollowerCell
        let user = stockFollower.userArray[indexPath.row]
        cell.avatar.image = user.avatar
        cell.name.text = user.name
        cell.avatar.layer.cornerRadius = 28
        cell.avatar.layer.masksToBounds = true
        
        return cell
    }
    
    func fetchFollowers() {
        
        var params: [String: AnyObject] = [
            "auth_token": currentUser.authToken!,
        ]
        
        Alamofire.request(.GET, "http://localhost:3000/api/users/get_followers", parameters: params, encoding: .URL).responseJSON{ (request, response, JSON, error) in
            println("=======followersJSON=========")
            println(JSON)
            
            StockFollowers.userInstance.userArray = []
            
            if error == nil {
            var users = JSON!["users"] as! Array<AnyObject>
                for user in users {
                let follower = User()
                    follower.name = user["name"] as! String!
                    let urlKey = user["avatar"] as! Dictionary<String, AnyObject>
                    let urlKey2 = urlKey["avatar"] as! Dictionary<String, AnyObject>
                    if let imageURL = urlKey2["url"] as? String {
                        let image = UIImage.convertToUIImageFromImagePass(imageURL)
                        follower.avatar = image
                    }
                StockFollowers.userInstance.addUser(follower)
                    println("StockFollowers呼ばれたよ")
                    println(StockFollowers.userInstance.userArray)
                }
            }
            
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
