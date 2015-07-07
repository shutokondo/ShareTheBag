//
//  StockItem.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/04.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit

class StockItem: NSObject {
    
    var items:Array<Item> = []
    static let sharedInstance = StockItem()
    
    func addItem(item: Item){
        self.items.append(item)
    }
    
    
    //    class func fetchItems() -> Array<Item> {
    //        var itemLists: Array<AnyObject> = []
    //        for item in items {
    //            var itemDic = item
    //            itemLists.append(itemDic)
    //
    //            return itemLists
    //        }
    //    }
}

