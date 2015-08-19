//
//  BagViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/23.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class BagViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var bagName: UILabel!
    @IBOutlet weak var message: UILabel!
   
    let currentUser = CurrentUser.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedBackButton")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        
        bagName.numberOfLines = 0
        bagName.sizeToFit()
        message.numberOfLines = 0
        message.sizeToFit()

        // Do any additional setup after loading the view.
        getBagInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedBackButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getBagInfo() {
        
        Alamofire.request(.GET, "http://localhost:3000/api/users/\(currentUser.id)", parameters: nil, encoding: .URL).responseJSON{ (request, response, JSON, error) in
            
            println("======baginfo======")
            println(JSON)
            
            if error == nil {
                self.name.text = JSON!["name"] as! String!
                self.message.text = JSON!["message"] as! String!
                self.bagName.text = JSON!["bagName"] as! String!
                let urlKey = JSON!["bagImage"] as! Dictionary<String, AnyObject>
                let urlKey2 = urlKey["bagImage"] as! Dictionary<String, AnyObject>
                if let imageURL = urlKey2["url"] as? String {
                    let image = UIImage.convertToUIImageFromImagePass(imageURL)
                    self.bagImage?.image = image
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
