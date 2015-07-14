//
//  Item.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/04.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit

class Item: NSObject {
    
    static let sharedInstance = Item()
    
    var image:UIImage!
    var title = ""
    var store = ""
    var descript = ""
    var user_id = ""
    
    
}
