//
//  AdditionalViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/04.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class AdditionalViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemStore: UITextField!
    @IBOutlet weak var itemMemo: UITextView!
    @IBOutlet weak var addScroll: UIScrollView!
    
    var item: Item!
    var txtActiveField: UITextField? = UITextField()
    var txtActiveView: UITextView? = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        item = Item()
        addImage.image = UIImage(named: "pug.png")
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        self.view.addGestureRecognizer(tapRecognizer)
        
        itemName.delegate = self
        itemStore.delegate = self
        itemMemo.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        addScroll.contentSize = CGSize(width: 375, height: 1000)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // ナビゲーションバー
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "作成", style: UIBarButtonItemStyle.Plain, target: self, action: "create")
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    // 閉じる
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // 作成機能
    func create() {
        
        if count(itemName.text) == 0 {
            let alertView = UIAlertController(title: "エラー", message: "アイテム名が記述されていません", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "ほんまや！", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            
            //            let stockItem = StockItem.sharedInstance
            
            var params: [String: AnyObject] = [
                "title": itemName.text,
                "store": itemStore.text,
                "description":itemMemo.text
            ]
            
            Alamofire.request(.POST, "http://localhost:3000/api/items", parameters: params, encoding: .URL).responseJSON { (request, response, JSON, error) in
                println("=========JSON=======")
                println(JSON)
                println("=========error=====")
                println(error)
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //タップした時に閉じる処理
    func tapGesture(sender: UITapGestureRecognizer) {
        itemName.resignFirstResponder()
        itemStore.resignFirstResponder()
        itemMemo.resignFirstResponder()
        
    }
    
    //Returnを押したと時にキーボードを閉じる処理
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        itemName.resignFirstResponder()
        itemStore.resignFirstResponder()
        return true
    }
    
    //    func textFieldShouldReturn(textField: UITextView) -> Bool {
    //        itemMemo.resignFirsstResponder()
    //        return true
    //    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        txtActiveView = textView
        return true
    }
    
    //キーボードが表示された時
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        //郵便入れみたいなもの
        let userInfo = notification.userInfo!
        //キーボードの大きさ取得
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        var txtLimit = txtActiveField!.frame.origin.y + txtActiveField!.frame.height + 10
        var textLimit = txtActiveView!.frame.origin.y + txtActiveView!.frame.height + 10
        //        var txtLimit: CGFloat = 0
        let kbdLimit = myBoundSize.height - keyboardRect.size.height
        
        
        println("テキストフィールドの下辺：(\(txtLimit))")
        println("キーボードの上辺：(\(kbdLimit))")
        
        //スクロールビューの移動距離設定
        if txtLimit >= kbdLimit {
            addScroll.contentOffset.y = txtLimit - kbdLimit
            //            addScroll.contentOffset.y = keyboardRect.size.height
        }
        if textLimit >= kbdLimit {
            addScroll.contentOffset.y = textLimit - kbdLimit
        }
    }
    
    //ずらした分を戻す処理
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        addScroll.contentOffset.y = 0
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}