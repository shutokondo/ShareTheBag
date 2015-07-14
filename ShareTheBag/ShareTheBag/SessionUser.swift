//
//  SessionUser.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/08.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class SessionUser: NSObject {
   
    class func signUp(user: User, callBackClosure:(Dictionary<String, AnyObject>) -> Void) {
        
        var params: [String: AnyObject] = [
            "name": user.name,
            "email": user.email,
            "password": user.password,
            ]
        
        var returnParams: Dictionary<String, AnyObject> = [:]
        
        Alamofire.request(.POST, "http://localhost:3000/api/users",parameters: params, encoding: .URL)
            
            .responseJSON { (request, response, JSON, error) in
                
                println("========request=============")
                println(request)
                println("========response============")
                println(response)
                println("========JSON===========")
                println(JSON)
                println("========error===========")
                println(error)
                println("=====================")
                
                
                var messageArray = JSON!["error_message"] as! Array<AnyObject>
                
                if messageArray.isEmpty {
                    
                    returnParams["error_message"] = []
                    returnParams["auth_token"] = JSON!["auth_token"]
                    returnParams["email"] = JSON!["email"]
                                       
                    let currentUser = CurrentUser.sharedInstance
                    currentUser.authToken = JSON!["auth_token"]
                    currentUser.name = JSON!["name"] as! String
                    currentUser.id = JSON!["id"] as! Int
                    currentUser.saveAuthToken()
                    
                    
                } else {
                    var messages = messageArray[0] as! Array<AnyObject>
                    returnParams["error_message"] = messages
                    
                }
                println(returnParams)
                callBackClosure(returnParams)
        }
    }
    
    
    
    class func login(user: User, callBackClosure: (Dictionary<String, AnyObject>) -> Void) {
        
        var params: [String: AnyObject] = [
            "email": user.email,
            "password": user.password,
        ]
        
        var returnParams: Dictionary<String, AnyObject> = [:]
        
        Alamofire.request(.POST, "http://localhost:3000/api/sessions", parameters: params, encoding: .URL)
            .responseJSON { (request, response, JSON, error) in
                
                println("====ログイン=====request=============")
                println(request)
                println("====ログイン=====response============")
                println(response)
                println("====ログイン=====JSON===========")
                println(JSON)
                println("====ログイン=====error===========")
                println(error)
                println("====ログイン================")
                
                var messageArray = JSON!["error_message"] as! Array<AnyObject>
                
                if messageArray.isEmpty {
                    
                    let currentUser = CurrentUser.sharedInstance
                    currentUser.authToken = JSON!["auth_token"]
                    currentUser.name = JSON!["name"] as! String
                    currentUser.saveAuthToken()
                    
                } else {
                    returnParams["error_message"] = messageArray
                }
                
                callBackClosure(returnParams)
        }
    }
}
