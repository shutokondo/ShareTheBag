//
//  Extension+UIImage.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/13.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    class func convertToUIImageFromImagePass(imagePath: String) -> UIImage! {
        let imageLink = "http://localhost:3000" + imagePath
        let url = NSURL(string: imageLink)
        let imageData = NSData(contentsOfURL: url!)
        let image = UIImage(data: imageData!)
        return image
    }
    
//    func convertToString() -> String {
//        let imageData = UIImagePNGRepresentation(self)
//        let encodeString = imageData.base64EncodedDataWithOptions(NSDataBase64DecodingOptions.Encoding64CharacterLineLength)
//        return encodeString
//    }
}
