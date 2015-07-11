//
//  StockUsers.swift
//  
//
//  Created by 根東秀都 on 2015/07/06.
//
//

import UIKit
import Alamofire

class StockUsers: NSObject {
    
    var userArray: Array<User> = []
    static let userInstance = StockUsers()
    
    func addUser(user: User) {
        self.userArray.append(user)
    }
}
