//
//  User.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/06.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String = ""
    var email: AnyObject = ""
    var password: AnyObject = ""
    var avatar: UIImage!
    var bagImage: UIImage!
    var bagName: String = ""
    var message: String = ""
    var followState: Int = 0
}
