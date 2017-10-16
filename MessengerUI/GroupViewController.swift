////
////  PeopleTableViewController.swift
////  MessengerUI
////
////  Created by Hiem Seyha on 4/6/17.
////  Copyright © 2017 seyha. All rights reserved.
////
//
//import UIKit
//import AsyncDisplayKit
//import Alamofire
//import RealmSwift
//
//class GroupViewController:UIViewController,MosaicCollectionViewLayoutDelegate,UITextFieldDelegate,UISearchControllerDelegate,UISearchResultsUpdating{
//    
//    let _layoutInspector = MosaicCollectionViewLayoutInspector()
//    var _sections = [[UIImage]]()
//    var collectionNode: ASCollectionNode!
//    var searchController = UISearchController()
//    var refreshControl:UIRefreshControl!
//    var getWidth = Float()
//    var myValue = Int()
//    var alldata = [GroupModelMapper]()
//    
//    @IBOutlet weak var mainSubView: UIView!
//    
//    var friends:[[Friends]] = [UserActive.getUserActive(), Friends.getFirends()]
//    
//    required init?(coder aDecoder: NSCoder) {
//        
//        let layout = MosaicCollectionViewLayout()
//        layout.numberOfColumns = 2
//        layout.headerHeight = 40
//        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
//        super.init(coder: aDecoder)
//        
//        layout.delegate = self
//        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
//        collectionNode.view.layoutInspector = _layoutInspector
//        collectionNode.delegate = self
//        collectionNode.dataSource = self
//        
//        self.searchController = UISearchController(searchResultsController: nil)
//        self.searchController.searchResultsUpdater = self
//        self.searchController.searchBar.sizeToFit()
//        self.navigationItem.titleView = self.searchController.searchBar
//        self.searchController.hidesNavigationBarDuringPresentation = false
//        self.searchController.dimsBackgroundDuringPresentation = false
//        
//        changeSearchBarStyleBackground()
//        refreshControl = UIRefreshControl()
//        collectionNode.view.addSubview(refreshControl)
//        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
//        
//    }
//    
//    func action(){
//        
//        print("===>a ", searchController.searchBar.text)
//        
//    }
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        print("===>a ", searchController.searchBar.text)
//    }
//    
//    
//    deinit {
//        collectionNode.delegate = nil
//        collectionNode.dataSource = nil
//    }
//    
//    fileprivate func createLayerBackedTextNode(attributedString: NSAttributedString) -> ASTextNode {
//        let textNode = ASTextNode()
//        textNode.isLayerBacked = true
//        textNode.attributedText = attributedString
//        
//        return textNode
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var _groupNameLabel = ASTextNode()
//        let style = NSMutableParagraphStyle()
//        style.alignment = NSTextAlignment.center
//        
//        _groupNameLabel = createLayerBackedTextNode(attributedString: NSAttributedString(string: "hellow", attributes: [ NSParagraphStyleAttributeName: style,NSForegroundColorAttributeName: UIColor.lightGray]))
//        _groupNameLabel.style.layoutPosition = CGPoint(x: 0, y: 0)
//        _groupNameLabel.style.preferredSize = CGSize(width:Int(getWidth/2),height:110)
//        _groupNameLabel.backgroundColor = UIColor.red
//        
//        collectionNode.addSubnode(_groupNameLabel)
//        
//        self.mainSubView.addSubnode(collectionNode)
//        
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if refreshControl.isRefreshing {
//            refreshControl.endRefreshing()
//        }
//    }
//    
//    func changeSearchBarStyleBackground(){
//        for subView in searchController.searchBar.subviews {
//            for subViewOne in subView.subviews {
//                
//                if let _ = subViewOne as? UITextField {
//                    subViewOne.backgroundColor = UIColor(hex: "EFEFEF")
//                }
//            }
//        }
//    }
//    
//    
//    override func loadView() {
//        super.loadView()
//    }
//    
//    @IBAction func actionGroup(_ sender: Any) {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
//        let nvc = UINavigationController(rootViewController: vc)
//        navigationController?.present(nvc, animated: true, completion: nil)
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        alamoreFireRequest()
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
//        // check portrait screen change postion detail button
//        
//        self.collectionNode.frame = mainSubView.bounds
//        
//        
//        collectionNode.reloadData()
//        self.view.setNeedsDisplay()
//        getWidth = Float(self.view.bounds.width)
//        print("get screen",getWidth)
//    }
//    
//    internal func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: self.view.layer.frame.size.width/2, height: 200)
//    }
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        
//        
//        if searchController.searchBar.text != "" {
//            alamoreFireRequest(text: searchController.searchBar.text!)
//        }else{
//            alamoreFireRequest()
//        }
//        
//    }
//    
//    //search group
//    func alamoreFireRequest(text:String){
//        Alamofire.request(mainURL + "room/search/1/" + text, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseArray(queue: nil, keyPath: "data", context: nil){ (response:DataResponse<[GroupModelMapper]>) in
//            
//            debugPrint(response)
//            self.alldata = []
//            if let data = response.result.value {
//                self.alldata = data
//                self.collectionNode.reloadData()
//                
//            } else {
//                
//                print("Faild To Loading News")
//                
//            }
//        }
//    }
//    
//}
//
//extension GroupViewController: ASCollectionDelegate, ASCollectionDataSource {
//    
//    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
//        return 1
//    }
//    
//    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
//        return alldata.count
//    }
//    
//    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
//        
//        //  let data = GroupModel(json: self.dataJson[indexPath.row])
//        var data = alldata[indexPath.row]
//        
//        let cellNodeBlock = { () -> ASCellNode in
//            let cellNode = GroupCellNode(with: data.images,sizeWidth:self.getWidth)
//            //set border
//            cellNode.detailButton.addTarget(self, action: #selector(self.actionUnpin), forControlEvents: .touchUpInside)
//            
//            self.myValue = indexPath.row
//            
//            cellNode.memberName = data.members
//            cellNode.nameGroup = data.title
//            cellNode.status = "active \(data.day)"
//            cellNode.cornerRadius = 7
//            cellNode.borderWidth = 0.2
//            cellNode.borderColor = UIColor.lightGray.cgColor
//            return cellNode
//        }
//        
//        return cellNodeBlock
//    }
//    
//    func actionUnpin(){
//        print("unpin data:",myValue)
//    }
//    
//    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
//        
//        
//        
//        let cellNodeBlock = { () -> ASCellNode in
//            let cellNode = GroupCellNode(with: [""],sizeWidth:self.getWidth)
//            //set border
//            cellNode.detailButton.addTarget(self, action: #selector(self.actionUnpin), forControlEvents: .touchUpInside)
//            
//            self.myValue = indexPath.row
//            //  cellNode.memberName = data.member
//            cellNode.isHeader = true
//            
//            cellNode.createGroupLabel.addTarget(self, action: #selector(self.handleTap), forControlEvents: .touchUpInside)
//            return cellNode
//        }
//        
//        return cellNodeBlock()
//        
//    }
//    
//    func handleTap() {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
//        let nvc = UINavigationController(rootViewController: vc)
//        navigationController?.present(nvc, animated: true, completion: nil)
//        
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: self.view.bounds.width, height: 1000)
//        
//    }
//    
//    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        
//        searchController.searchBar.resignFirstResponder()
//    }
//    
//    func alamoreFireRequest(){
//        
//        self.alldata = []
//        Alamofire.request(mainURL + "room/\(1)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseArray(queue: nil, keyPath: "data", context: nil){ (response:DataResponse<[GroupModelMapper]>) in
//            
//            debugPrint(response)
//            self.alldata = []
//            if let data = response.result.value {
//                self.alldata = data
//               // self.addRealm(groupObjs: self.alldata)
//                
//                self.collectionNode.reloadData()
//                
//            } else {
//                
//                print("Faild To Loading News")
//                
//            }
//        }
//        
//        if !HttpRequest.checkInternetConnection(){
//            readData()
//        }
//        
//    }
//    
//    // read data from realm
//    func readData(){
//        
//        let realm = try! Realm()
//        let objects = realm.objects(StoreGroupModel.self)
//        
//        alldata = []
//        
//        for object in objects {
//            
//            let group = GroupModelMapper()
//            group?.id = Int(object.id)!
//            group?.userID = object.userID
//            group?.status = object.status
//            group?.title = object.title
//            group?.createAt = object.createAt
//            group?.updatedAt = object.updatedAt
//            group?.images = object.images
//            group?.members = object.members
//            group?.day = object.day
//            group?.profile = object.profile
//            
//            alldata.insert(group!, at: 0)
//            collectionNode.reloadData()
//        }
//    }
//    
//    //insert into realm
//    func addRealm(groupObjs:[GroupModelMapper]){
//        
//        
//        for groupObj in groupObjs {
//            let data = StoreGroupModel()
//            
//            data.id = "\(groupObj.id)"
//            data.userID = groupObj.userID
//            data.status = groupObj.status
//            data.title = groupObj.title
//            data.createAt = groupObj.createAt!
//            data.updatedAt = groupObj.updatedAt!
//            data.images = groupObj.images
//            data.members = groupObj.members
//            data.day = groupObj.day
//            data.profile = groupObj.profile
//            
//            let realm = try! Realm()
//            try! realm.write {
//                realm.add(data)
//            }
//            
//        }
//        
//    }
//}
//
