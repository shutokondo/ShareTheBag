//
//  ViewController.swift
//  ShareTheBag
//
//  Created by 根東秀都 on 2015/07/04.
//  Copyright (c) 2015年 shuto kondo. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var userName: UILabel!
    
    let backgroundView = UIView()
    let imageView = UIImageView()
    var stockItem = StockItem()
    let currentUser = CurrentUser.sharedInstance
    let item = Item.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //collectionViewの個別ページの処理
        backgroundView.frame = self.view.frame
        backgroundView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.6)
        
        self.userName.text = currentUser.name
    }
    
    override func viewDidLayoutSubviews() {
        mainScroll.contentSize = CGSize(width: 375, height: self.view.frame.size.height + self.collectionView.frame.size.height)
    }
    
    // マイページの追加ボタン
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "追加", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedAddButton")
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        stockItem = StockItem.sharedInstance
        
        
        Alamofire.request(.GET, "http://localhost:3000/api/items",parameters: nil, encoding: .URL)
            .responseJSON { (request, response, JSON, error) in
                println("=========JSON=======")
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
                    self.collectionView.reloadData()
                }
        }
    }
    
    //    func loadDiaries() {
    //        let url = NSURL(string: "http://localhost:4000/diaries.json")
    //        var request = NSMutableURLRequest(URL: url!)
    //
    //        request.HTTPMethod = "GET"
    //
    //        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
    //
    //            if (error == nil) {
    //                self.stockItem.items.removeAll(keepCapacity: false)
    //                var diaries = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! Array<Dictionary<String, AnyObject>>
    //
    //                for diaryInfo in diaries {
    //                    let diary = Diary(attributes: diaryInfo)
    //                    self.diaries.append(diary)
    //                }
    //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //                    self.tableView.reloadData()
    //                })
    //            } else {
    //                // when error
    //            }
    //        })
    //        task.resume()
    //    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if stockItem.items.count == 0 {
            println("まだアイテムはありません")
            return 0
        } else {
            return stockItem.items.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        let item = stockItem.items[indexPath.item]
        cell.titleLabel.text = item.title
        cell.storeLabel.text = item.store
        cell.descriptLabel.text = item.descript
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
    
    
}



