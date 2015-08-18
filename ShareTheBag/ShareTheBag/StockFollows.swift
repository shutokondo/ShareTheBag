//
//  StockFollows.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/21.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit

class StockFollows: NSObject {
    
    var userArray: Array<User> = []
    static let userInstance = StockFollows()
    
    func addUser(user: User) {
        self.userArray.append(user)
    }
   
}
