//
//  CurrentUser.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/06.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit

class CurrentUser: NSObject {
    
    static let sharedInstance = CurrentUser()
    var authToken: AnyObject?
    
    func saveAuthToken() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(authToken, forKey: "authToken")
        defaults.synchronize()
    }
   
}
