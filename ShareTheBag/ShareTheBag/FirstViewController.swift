//
//  FirstViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/04.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var newAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //FBSDKAccessTokenはクラス、currentAccessToken()はクラスメソッド
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            //すでにログインしているので画面遷移
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            let loginView: FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center.x = self.view.center.x
            loginView.center.y = 500
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tapGesture:")
        self.view.addGestureRecognizer(tapRecognizer)
        userName.delegate = self
        email.delegate = self
        password.delegate = self
        
        newAccountButton.addTarget(self, action: "tapAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        userName.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    //        if count(userName.text) == 0  {
    //            let alertView = UIAlertController(title: "エラー", message: "ユーザー名が記述されていません", preferredStyle: .Alert)
    //            alertView.addAction(UIAlertAction(title: "ほんまや！", style: .Default, handler: nil))
    //            self.presentViewController(alertView, animated: true, completion: nil)
    //        } else if count(password.text) == 0 {
    //            let alertView = UIAlertController(title: "エラー", message: "passwordが記述されていません", preferredStyle: .Alert)
    //            alertView.addAction(UIAlertAction(title: "ほんまや！", style: .Default, handler: nil))
    //            self.presentViewController(alertView, animated: true, completion: nil)
    //        } else {
    //
    //            var params: [String: AnyObject] = [
    //                "name": userName.text,
    //                "password": password.text
    //            ]
    //
    //            Alamofire.request(.POST, "http://localhost:3000/api/users", parameters: params, encoding: .URL).responseJSON { (request, response, JSON, error) in
    //                println("=========JSON=======")
    //                println(JSON)
    //                println("=========error=====")
    //                println(error)
    //            }
    //        }
    
    func tapAction(sender: UIButton) {
        
        
        if count(userName.text) == 0  {
            let alertView = UIAlertController(title: "エラー", message: "ユーザー名が記述されていません", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "ほんまや！", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        } else if count(password.text) == 0 {
            let alertView = UIAlertController(title: "エラー", message: "passwordが記述されていません", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "ほんまや！", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            
            let user = User()
            user.name = userName.text
            user.email = email.text
            user.password = password.text
            
            var callback = {(params: Dictionary<String, AnyObject>) -> Void in
              
                var errorMessage = params["error_message"] as! Array<AnyObject>
                
                if errorMessage.isEmpty {
                    self.performSegueWithIdentifier("tapButtonSegue", sender: nil)
                } else {
                    let alertController = UIAlertController(title: "エラー", message: "User登録が上手くできませんでした", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "ほんまや！", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            SessionUser.signUp(user, callBackClosure: callback)
        }
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("Userログイン")
        
        
        self.performSegueWithIdentifier("LoginSegue", sender: self)
        
        if ((error) != nil)
        {
            //エラー処理
        }
        else if result.isCancelled {
            //キャンセル処理
        }
        else {
            //もし複数の認証を一度に尋ねられたら、特定の認証が抜けていないかを確認しましょう
            
            if result.grantedPermissions.contains("email")
            {
                
                //                var params: [String: AnyObject] = [
                //                    "email": itemName.text,
                //                    "password": itemStore.text,
                //                    ]
                //
                //
                //                Alamofire.request(.POST, "http://localhost:3000/api/users", parameters: params, encoding: .URL).responseJSON { (request, response, JSON, error) in
                //                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("Userログアウト")
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
