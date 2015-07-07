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
    
    // ボタンが押されたときに呼ばれるメソッドを定義
    class func createUser(user: User, callback: (NSError?, AnyObject?) -> Void) {
        
        var params: [String: AnyObject] = [
            "name": user.name
        ]
        
        // HTTP通信
        Alamofire.request(.POST, "http://localhost:3000/api/users", parameters: params, encoding: .URL)
            .responseJSON { (request, response, JSON, error) in
                
                println("=============request=============")
                println(request)
                println("=============response============")
                println(response)
                println("=============JSON================")
                println(JSON)
                println("=============error===============")
                println(error)
                println("=================================")
                
                callback(error, JSON)
        }
    }
   
}
