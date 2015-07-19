//
//  ProfileViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/17.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var message: UITextView!
    
    let currentUser = CurrentUser.sharedInstance
    let photoPicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.tag = 1
        bagImage.tag = 2
        setImageView(bagImage)
        setImageView(profileImage)
//        setImageView2()
        
        //textFieldの枠線を消す
        nameField.borderStyle = UITextBorderStyle.None
        
        photoPicker.delegate = self
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "更新", style: UIBarButtonItemStyle.Plain, target: self, action: "edit")
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImageView(image: UIImageView!) {
        image.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: "openCameraRoll:")
        image.addGestureRecognizer(gesture)
    }
    
    
    //カメラロールから画像選択
    func openCameraRoll(sender: UITapGestureRecognizer) {
        self.photoPicker.view.tag = sender.view!.tag
        self.photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    //ライブラリで写真を選択した時にimageに画像が渡される
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        switch(picker.view.tag) {
            case 1:
            profileImage.image = image
            case 2:
            bagImage.image = image
            default:
            println("画像なし")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func photoSelectButtonTouchDown(sender: AnyObject) {
        var imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
    }

    
    func fetchProfileImage() {
      
    }
    
    func edit() {
        
        var params: [String: AnyObject] = [
            "name": nameField.text,
            "message": message.text,
            "id": currentUser.id,
        ]
        let httpMethod = Alamofire.Method.PUT.rawValue
        
        let urlRequest = NSData.urlRequestWithComponents(httpMethod, urlString: "http://localhost:3000/api/users/\(currentUser.id)", parameters: params, avatar: profileImage.image!, bagImage: bagImage.image!)
        Alamofire.upload(urlRequest.0, urlRequest.1).responseJSON{ (request, response, JSON, error) in
    
            println("=======POST JSON BEGIN=======")
            println(JSON)
            println("=======POST JSON END=======")
//            println("=======error=======")
//            println(error)
            
             //navigationControllerからnavigationControllerの階層のため２回続
            self.navigationController!.navigationController?.popViewControllerAnimated(true)
 
        }
        println("post owattayo")
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
