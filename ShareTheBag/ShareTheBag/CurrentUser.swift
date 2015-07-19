//
//  CurrentUser.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/06.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class CurrentUser: User {
    
    static let sharedInstance = CurrentUser()
    var authToken: AnyObject?
    var id: Int!
    
    func saveAuthToken() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(authToken, forKey: "authToken")
        defaults.setObject(name, forKey: "userName")
        defaults.synchronize()
    }
    
    func removeAuthToken() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("authToken")
        defaults.synchronize()
    }
    
    func fetchCurrentUser(callBack: () -> Void) {
        
        var params: [String: AnyObject] = ["auth_token": self.authToken!]
        Alamofire.request(.GET, "http://localhost:3000/api/users/fetch_current_user", parameters: params, encoding: .URL).responseJSON { (request, response, JSON, error) in
            
            if error == nil {
            }
            callBack()
        }
    }
    
    
    
//    class func editMyBagImage(image: UIImageView!) {
//        
////        var params: [String: AnyObject] = [
////            "bagImage": image.image
////        ]
//        
//        let httpMethod = Alamofire.Method.POST.rawValue
//        
//        
//        let urlRequest = NSData.urlRequestWithComponents(httpMethod, urlString: "http://localhost:3000/api/users/add_bag_image", parameters: nil, image: image.image!)
//        Alamofire.upload(urlRequest.0, urlRequest.1).responseJSON{ (request, response, JSON, error) in
//            println("=======JSON=======")
//            println(JSON)
//            println("=======error=======")
//            println(error)
//        }
//    }
//
}
