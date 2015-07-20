//
//  ViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/04.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    let backgroundView = UIView()
    let imageView = UIImageView()
    let photoPicker = UIImagePickerController()
    var stockItem = StockItem.sharedInstance
    let currentUser = CurrentUser.sharedInstance
    let item = Item.sharedInstance
    var items:Array<Item> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        photoPicker.delegate = self
        
        
        //collectionViewの個別ページの処理
        backgroundView.frame = self.view.frame
        backgroundView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.6)
        
        profileButton.layer.borderWidth = 1.0
        profileButton.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.5).CGColor
        profileButton.layer.cornerRadius = 10.0
        
        self.userName.text = currentUser.name
        
//        setImageView()
    }
    
    override func viewDidLayoutSubviews() {
        mainScroll.contentSize = CGSize(width: 375, height: self.view.frame.size.height + self.collectionView.frame.size.height)
    }
    
   
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedAddButton")
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
//        let notificationCenter = NSNotificationCenter.defaultCenter()
//        notificationCenter.addObserver(self, selector: " willShowKeyBoard", name: UIKeyboardWillShowNotification, object: nil)

        
        //HTTP通信いつ終わるかわかんないから終わったタイミング（配列を追加したタイミング）でreloadしたい
        let callBack = { () -> Void in
            self.items = StockItem.sharedInstance.items
            self.collectionView.reloadData()
        }
        
        fetchItems(callBack)
        
        fetchUserInfo()
        
        
        println("呼ばれたああああああああああああああああ")
        
    }

    
//    func setImageView() {
//        bagImage.userInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target: self, action: "openCameraRoll")
//        bagImage.addGestureRecognizer(gesture)
//    }
//    
//    
//    //カメラロールから画像選択
//    func openCameraRoll() {
//        self.photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        self.presentViewController(photoPicker, animated: true, completion: nil)
//    }
//    
//    //ライブラリで写真を選択した時にimageに画像が渡される
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        bagImage.image = image
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func photoSelectButtonTouchDown(sender: AnyObject) {
//        var imagePickerController = UIImagePickerController()
//        
//        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        imagePickerController.delegate = self
//    }
    
    
    func fetchUserInfo() {
        
        Alamofire.request(.GET, "http://localhost:3000/api/users/\(currentUser.id)", parameters: nil, encoding: .URL).responseJSON { (request, response, JSON, error) in
            println("======GET userInfoJSON=====")
            println(JSON)
            
            if error == nil {
                    let myUser = User()
                    self.userName.text = JSON!["name"] as! String!
                    self.message.text = JSON!["message"] as! String!
                    let urlKey = JSON!["bagImage"] as! Dictionary<String, AnyObject>
                    let urlKey2 = urlKey["bagImage"] as! Dictionary<String, AnyObject>
                    if let imageURL = urlKey2["url"] as? String {
                        let image = UIImage.convertToUIImageFromImagePass(imageURL)
                        self.bagImage?.image = image
                    }
                    let urlAvatarKey = JSON!["avatar"] as! Dictionary<String, AnyObject>
                    let urlAvatarKey2 = urlAvatarKey["avatar"] as! Dictionary<String, AnyObject>
                    if let imageURL = urlAvatarKey2["url"] as? String {
                        let image = UIImage.convertToUIImageFromImagePass(imageURL)
                        self.profileImage?.image = image
                    }
            }
        }
    }
    

    
    func fetchItems(callBack: () -> Void) {
        
        var params: [String: AnyObject] = [
            "authToken": currentUser.authToken!
        ]
        
        
        Alamofire.request(.GET, "http://localhost:3000/api/items/fetch_current_user_items",parameters: params, encoding: .URL)
            .responseJSON { (request, response, JSON, error) in
                println("=========GET itemInfoJSON=======")
                println(JSON)
                println("=========error=====")
                println(error)
                
                StockItem.sharedInstance.items = []
                if error == nil {
                    var items = JSON!["items"] as! Array<AnyObject>
                    for item in items {
                        let myItem = Item()
                        myItem.title = item["title"] as! String!
                        myItem.store = item["store"] as! String!
                        myItem.descript = item["description"] as! String!
                        let urlKey = item["avatar"] as! Dictionary<String, AnyObject>
                        let urlKey2 = urlKey["avatar"] as! Dictionary<String, AnyObject>
                        if let imageURL = urlKey2["url"] as? String {
                            let image = UIImage.convertToUIImageFromImagePass(imageURL)
                            myItem.image = image
                        }
                        StockItem.sharedInstance.items.insert(myItem, atIndex: 0)
                    }
                }
                callBack()
        }

    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        let item = items[indexPath.item]
        cell.image.image = item.image
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 3
        return cell
    }
    
    //セルがタップされた時に呼ばれる
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("セル番号：\(indexPath.item)をタップしました")
        
        self.view.addSubview(backgroundView)
        
        let item = StockItem.sharedInstance.items[indexPath.item]
        
        let cellView = makeCellView()
        backgroundView.addSubview(cellView)
        
        let itemLabel = makeItemLabel()
        backgroundView.addSubview(itemLabel)
        
        let itemName = makeItemName(item)
        backgroundView.addSubview(itemName)
        
        let storeLabel = makeStoreLabel()
        backgroundView.addSubview(storeLabel)
        
        let storeName = makeStoreName(item)
        backgroundView.addSubview(storeName)
        
        let memoLabel = makeMemoLabel()
        backgroundView.addSubview(memoLabel)
        
        let memoName = makeMemoName(item)
        backgroundView.addSubview(memoName)
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapBackgroundView")
        backgroundView.addGestureRecognizer(gesture)
        
        var editButton = UIButton()
        editButton.setTitle("編集", forState: UIControlState.Normal)
        editButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        editButton.center = CGPoint(x: 50, y: 42)
        editButton.frame.size = CGSize(width: 100, height: 100)
        editButton.titleLabel!.font = UIFont(name: "HirakakuProN-W6", size: 20)
        backgroundView.addSubview(editButton)
        
        var deleteButton = UIButton()
        deleteButton.setTitle("削除", forState: UIControlState.Normal)
        deleteButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        deleteButton.frame.size = CGSize(width: 100, height: 100)
        deleteButton.center = CGPoint(x: 271, y: 93)
        deleteButton.titleLabel!.font = UIFont(name: "HirakakuProN-W6", size: 20)
        backgroundView.addSubview(deleteButton)
        
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width:300, height:200)
        imageView.center = CGPoint(x: self.view.center.x, y: 210)
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.image = item.image
        backgroundView.addSubview(imageView)
        
        self.collectionView.reloadData()

    }
    
    func tapBackgroundView() {
        backgroundView.removeFromSuperview()
    }
    
    //cellView(各アイテムページの背景)
    func makeCellView() -> UIView {
        let cellView = UIView()
        cellView.backgroundColor = UIColor.whiteColor()
        cellView.frame.size = CGSize(width: 300, height: 530)
        cellView.center.x = self.view.center.x
        cellView.center.y = 340
        cellView.layer.cornerRadius = 15
        return cellView
    }
    //label（アイテム名）
    func makeItemLabel() -> UILabel{
        let itemLabel = UILabel()
        itemLabel.textColor = UIColor(red: 237/255, green: 81/255, blue: 19/255, alpha: 0.5)
        itemLabel.frame.size = CGSize(width: 200, height: 200)
        itemLabel.center.x = self.view.center.x
        itemLabel.center.y = 340
        itemLabel.text = "アイテム名"
        itemLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        itemLabel.numberOfLines = 0
        return itemLabel
    }
    //アイテム名
    func makeItemName(item: Item) -> UILabel{
        let itemName = UILabel()
        itemName.text = item.title
        itemName.frame.size = CGSize(width: 200, height: 200)
        itemName.textColor = UIColor.blackColor()
        itemName.center.x = self.view.center.x
        itemName.center.y = 360
        itemName.font = UIFont(name: "HirakakuProN-W6", size: 15)
        itemName.numberOfLines = 0
        return itemName
    }
    
    //label（店の名前）
    func makeStoreLabel() -> UILabel {
        let storeLabel = UILabel()
        storeLabel.textColor = UIColor(red: 237/255, green: 81/255, blue: 19/255, alpha: 0.5)
        storeLabel.frame.size = CGSize(width: 200, height: 200)
        storeLabel.center.x = self.view.center.x
        storeLabel.center.y = 400
        storeLabel.text = "買ったお店"
        storeLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        storeLabel.numberOfLines = 0
        return storeLabel
    }
    //店の名前
    func makeStoreName(item: Item) -> UILabel {
        let storeName = UILabel()
        storeName.textColor = UIColor.blackColor()
        storeName.text = item.store
        storeName.font = UIFont(name: "HirakakuProN-W6", size: 15)
        storeName.frame.size = CGSize(width: 200, height: 200)
        storeName.numberOfLines = 0
        storeName.center.x = self.view.center.x
        storeName.center.y = 420
        return storeName
    }
    //label（アイテムメモ）
    func makeMemoLabel() -> UILabel {
        let memoLabel = UILabel()
        memoLabel.textColor = UIColor(red: 237/255, green: 81/255, blue: 19/255, alpha: 0.5)
        memoLabel.frame.size = CGSize(width: 200, height: 200)
        memoLabel.center.x = self.view.center.x
        memoLabel.center.y = 460
        memoLabel.text = "アイテムmemo"
        memoLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        memoLabel.numberOfLines = 0
        return memoLabel
    }
    //アイテムメモ
    func makeMemoName(item: Item) -> UILabel {
        let memoName = UILabel()
        memoName.text = item.descript
        memoName.frame.size = CGSize(width: 200, height: 200)
        memoName.center.x = self.view.center.x
        memoName.center.y = 480
        memoName.textColor = UIColor.blackColor()
        memoName.font = UIFont(name: "HirakakuProN-W6", size: 15)
        memoName.numberOfLines = 0
        return memoName
    }
    //編集ボタン
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedAddButton() {
        self.performSegueWithIdentifier("addSegue", sender: self)
    }
    @IBAction func favoriteButton(sender: UIButton) {
        self.performSegueWithIdentifier("FavoriteSegue", sender: nil)
    }
    @IBAction func followButton(sender: UIButton) {
        self.performSegueWithIdentifier("FollowSegue", sender: nil)
    }
    @IBAction func followerButton(sender: UIButton) {
        self.performSegueWithIdentifier("FollowerSegue", sender: nil)
    }
    @IBAction func profileButton(sender: UIButton) {
        self.performSegueWithIdentifier("profileSegue", sender: nil)
    }
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
    }
    
    
}



