//
//  CurrentUser.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/06.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit

class CurrentUser: User {
    
    static let sharedInstance = CurrentUser()
    var authToken: AnyObject?
    
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
   
}
