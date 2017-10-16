//
//  ChatViewController.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/10/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import ALTextInputBar
import SocketIO

var shouldRenderInputBar = true

class ChatViewController: UIViewController {

  let textInputBar = ALTextInputBar()
  let keyboardObserver = ALKeyboardObservingView()
  
  //MARK: Property
  var chatCollectionNode:ASCollectionNode!
  var flowLayout:UICollectionViewFlowLayout!
  var viewBottomAchor:NSLayoutConstraint!
  var layout:UICollectionViewFlowLayout!
  
  var chatPresenter:ChatAPIPresenter!
  var refreshControl: UIRefreshControl!
  var roomID:Int!
  
  // Pagination
  var currentPage = 1
  let limitPage = 10
  
  let realm = try? Realm()
  
  // Property Data
  var friend:Friend?
  var messages:[Message] = []
  var whichGetData = false

  // MARK: OUTLET PROPERTY
  @IBOutlet weak var callButton: UIButton!
  @IBOutlet weak var videoCallButton: UIButton!
  @IBOutlet weak var navigationTitle: UINavigationItem!
  
  
  // MARK: IBACTION METHOD
  @IBAction func videoCallButton(_ sender: Any) {
    
  }
    
  @IBAction func callButton(_ sender: Any) {
    
  }
  
  //MARK: Data Propety

  
  // Testing
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // Customize Layout
    layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    layout.scrollDirection = .vertical
    
    // chatCollectionNode Property
    chatCollectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
    chatCollectionNode.dataSource = self
    chatCollectionNode.delegate = self
    chatCollectionNode.backgroundColor = UIColor.red
    
  }
  
  deinit {
    chatCollectionNode.dataSource = nil;
    chatCollectionNode.delegate = nil;
  }

  
  // MARK: ====== System Method on Main Thread =======
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Add line to navigation controller back
    for parent in navigationController!.view.subviews {
      for child in parent.subviews {
        for view in child.subviews {
          if view is UIImageView && view.frame.height == 0.5 {
            view.alpha = 1
          }
        }
      }
    }
    
    // Pull to refresh 
    refreshControl = UIRefreshControl()
    chatCollectionNode.view.addSubview(refreshControl)
    chatCollectionNode.view.alwaysBounceVertical = true
    refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
    chatCollectionNode.view.leadingScreensForBatching = 3.0
    chatCollectionNode.performBatchUpdates({ 
      print("performBatchUpdate")
    }) { (completion) in
      
        print(completion)
    }
    
    // Configuration Collection And InputBar
    configCollectionView()
    configureInputBar()
    
    // Scroll to the last of message chat
    scrollToBottom()
    
    //MAKR: Configuration
    configureIconTopNavigation()
    
    //MARK: InputText Library
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name(rawValue: ALKeyboardFrameDidChangeNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    // Socket Event Listener
    SocketIOManager.sharedInstance.getChatMessage(event: "message") { (data) in
      
      print("getChatMessage viewdidload", data["messages"]!, data["participants_id"]!,(self.friend?.profileImage)!)
      
      guard data["participants_id"] != nil else{
        return
      }
      
      let responseMessage = Message(participantsID: data["participants_id"]! as! Int, userID: (self.friend?.id!)!, messages: data["messages"] as! String, profileImage:(self.friend?.profileImage)!)
      
      self.messages.append(responseMessage)
      
      print("SocketIOManager.sharedInstance.getChatMessage", data["room_id"]!)
      //Save to local database
      self.saveCurrentMessage(message: responseMessage, roomID:data["room_id"]! as! Int)
      
      self.chatCollectionNode.reloadData()
      self.scrollToBottom()
      
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    // Assign delegate to presenter
    chatPresenter = ChatAPIPresenter()
    chatPresenter.delegate = self
    
    if checkRoomID() == 0 {
      
      self.chatPresenter.getMessage(userID: CurrentUser.shareInstance.id!, participantID: (friend?.id)!, page: 1, limit: limitPage)
      
    } else{
      
      getDataFromLocal(roomID: checkRoomID())
    }
    
    scrollToBottom()
    
    //Set title for chating
    showTitleChating(title: (friend?.firstName ?? "")! + (friend?.lastName ?? "")!)
    
    
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    
  }
  
  // Layout Life Cycle
  override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
    textInputBar.frame.size.width = view.bounds.size.width
    view.backgroundColor = UIColor.white
    
    guard shouldRenderInputBar == true else {
      return
    }
    
    configCollectionView()
    configureInputBar()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    shouldRenderInputBar = true
  }
  
}

//MARK: ============ Utilities method ==================
extension ChatViewController {
  
  func showTitleChating(title:String) {
    guard !(title.isEmpty) else {
      return
    }
    navigationTitle.title = title
  }
  
  func scrollToBottom(){
    let section = 0
    let lastItemIndex = self.chatCollectionNode.numberOfItems(inSection: section) - 1
    let indexPath:IndexPath = IndexPath.init(item: lastItemIndex, section: section)
    self.chatCollectionNode.scrollToItem(at: indexPath, at:.bottom, animated: false)
    
  }
  
  //MARK: Loading more message base on page
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let offsetY = scrollView.contentOffset.y
//    let contentHeight = scrollView.contentSize.height
    if offsetY <= 0 {
      
    }
  }
  
  // ========== Send Message ============
  func sendMessage(){
    
    guard !(textInputBar.text.isEmpty) else {
      return
    }
    
    guard roomID != nil else {
      return
    }
    
    print("==========>Send Message roomID", roomID)
    print("==========>Send Message participant id", CurrentUser.shareInstance.id!)
    print("==========>Send Message message", textInputBar.text!)
    
    SocketIOManager.sharedInstance.sendMessage(event: "message", message: textInputBar.text!, pariticipantID: CurrentUser.shareInstance.id!, roomID: roomID)
    
    scrollToBottom()
    textInputBar.text = ""

  }
  
  // ====== Load More Message Chating ========
  func loadMoreData() {
    
    let paginations = realm?.objects(StorePagination.self).toArray()
    var pageCount = 0
    
    for pagination in paginations! {
      
      currentPage = pagination.page
      pageCount = pagination.pageCount
      print("currentPage ======> loadmore data", currentPage)
    }
    
    currentPage += 1
    
    guard currentPage <= pageCount else {
      
      self.refreshControl.endRefreshing()
      return
    }
    
    self.chatPresenter.getMessage(userID: CurrentUser.shareInstance.id!, participantID: (friend?.id)!, page: currentPage, limit: limitPage)
    
//    print("No Condition LoadMoreData",Pagination.shareInstance.page )
//    
//    guard Pagination.shareInstance.page != nil else {
//      
//      self.refreshControl.endRefreshing()
//      return
//    }
//    
//    
//    
//    if currentPage <= Pagination.shareInstance.pageCount! {
//      
//      print("Load more data on page ",Pagination.shareInstance.page!)
//    
//      
//      
//    } else {
//      
//      self.refreshControl.endRefreshing()
//      print("loadMoreData Over")
//    }
//    
  }
  
}

// MARK: ======== Exenstion ASCollection Node =======
extension ChatViewController: ASCollectionDataSource, ASCollectionDelegate, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return 1
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    
    return messages.count
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    
    let chat = messages[indexPath.row]
    
    let celNodeBlock = { () -> ASCellNode in
      let cellNode = ChatCellNode(chat: chat, currentUserID: CurrentUser.shareInstance.id!)
      return  cellNode
    }
    
    return celNodeBlock
  }

  
  func collectionNode(_ collectionNode: ASCollectionNode, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, canPerformAction action: Selector, forItemAt indexPath: IndexPath, sender: Any?) -> Bool {
    return action == NSSelectorFromString("copyCollection")
  }
  
  func collectionNode(_ collectionNode: ASCollectionNode, performAction action: Selector, forItemAt indexPath: IndexPath, sender: Any?) {
    print("action:\(action.description)")
  }
  
  func collectionView(_ collectionView: ASCollectionView, constrainedSizeForSupplementaryNodeOfKind: String, at atIndexPath: IndexPath) -> ASSizeRange
  {
    
    return ASSizeRange.init(min: CGSize(width:200, height:200), max: CGSize(width:200,height:200))
  }
  
}

// MARK: ======== Helper Function =======
extension ChatViewController {
  
  fileprivate func estimateFrameForText(text:String) -> CGRect {
    
    let size = CGSize(width: 200, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)], context: nil)
  }
  
}

// MARK: ========= Configuration All Views ============
extension ChatViewController {
  
  func configureIconTopNavigation() {
    let callImage = UIImage(named: "phone-call")?.withRenderingMode(.alwaysTemplate)
    callButton.setImage(callImage, for: .normal)
    callButton.tintColor = UIColor(hex: "0076FF")
    
    let videoImage = UIImage(named: "video-call")?.withRenderingMode(.alwaysTemplate)
    videoCallButton.setImage(videoImage, for: .normal)
    videoCallButton.tintColor = UIColor(hex: "0076FF")
  }
}

// MARK: ========= TextInputBar Library ============
extension ChatViewController {
  
  override var inputAccessoryView: UIView? {
    get {
      return keyboardObserver
    }
  }
  
  // This is also required
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  func configureInputBar() {
    
    // configura button
    let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
    sendButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    let leftButton  = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    leftButton.setImage(#imageLiteral(resourceName: "plusButton"), for: .normal)
    leftButton.clipsToBounds = true
    sendButton.setImage(#imageLiteral(resourceName: "sendButton-1"), for: .normal)
    sendButton.addTarget(self, action:#selector(sendMessage), for: .touchUpInside)
    
    keyboardObserver.isUserInteractionEnabled = false
    
    // Customzie textInputBar
    textInputBar.showTextViewBorder = true
    
    
    
    textInputBar.leftView = leftButton
    textInputBar.rightView = sendButton
    textInputBar.textViewCornerRadius = 15
    textInputBar.textView.font = UIFont.systemFont(ofSize: 12)
    textInputBar.textView.textColor = UIColor.black
    textInputBar.textViewBorderPadding = UIEdgeInsets(top: 5, left: 3, bottom: 3, right: 3)
    textInputBar.textViewBackgroundColor = UIColor(white: 0.95, alpha: 0.5)
    textInputBar.frame = CGRect(x: 0, y: view.frame.size.height - textInputBar.defaultHeight, width: view.frame.size.width, height: textInputBar.defaultHeight)
    textInputBar.backgroundColor = UIColor.white
    textInputBar.keyboardObserver = keyboardObserver
    
    view.addSubview(textInputBar)
  
    shouldRenderInputBar = false

  }
  
  func configCollectionView(){
    
    view.addSubnode(chatCollectionNode)
    
    let contentView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height - textInputBar.defaultHeight))
    
    chatCollectionNode.view.frame = contentView.frame
    chatCollectionNode.view.keyboardDismissMode = .interactive
    chatCollectionNode.view.backgroundColor = UIColor.white
    chatCollectionNode.view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    chatCollectionNode.view.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
    
  }
  
  // ============= Keyboard Offset =========
  func keyboardFrameChanged(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
      
      textInputBar.frame.origin.y = frame.origin.y - (textInputBar.defaultHeight + textInputBar.defaultHeight / 2 - 5)
     
      chatCollectionNode.frame.size.height = frame.origin.y -  (textInputBar.defaultHeight + textInputBar.defaultHeight / 2 - 5)
    }
  }
  
  //============ Keyboard Show/Hide =========
  func keyboardWillShow(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
      textInputBar.frame.origin.y = view.frame.height - frame.height
      chatCollectionNode.frame.size.height = view.frame.height - frame.height
     
      scrollToBottom()
     
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let _ = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
      textInputBar.frame.origin.y = view.frame.height - textInputBar.bounds.height
      chatCollectionNode.view.frame.size.height = view.frame.height - textInputBar.frame.height
      
      scrollToBottom()
     
    }
  }
  
}
//========= Notify From Presenter ==========
extension ChatViewController: ChatAPIPresenterProtocol {
  
  func responseData(data: [Message], roomID:Int) {
    
    refreshControl.endRefreshing()
    
    print("response ========>", roomID)
    
    if roomID != 0 {
      
      self.roomID = roomID
      
      //save room id
      let temp = RoomID()
      temp.roomID = roomID
      
      try! realm?.write {
        realm?.add(temp)
      }
      
    }
    
    if !data.isEmpty {
      
//      if Pagination.shareInstance.page != nil {
//        
//         currentPage = Pagination.shareInstance.page!
//      }
      print("Sending roomID========>", roomID)
      
      // Save data to local
      saveDataToLocal(data: data, completion: { 
  
        // Get Data from local
        getDataFromLocal(roomID: roomID)
        
      })

    } else {
      
      messages = []
    }

  }
  
  // check Data existing
  func getDataFromLocal(roomID:Int) {
    
    print("getDataFromLocal")
  
      let objects = realm?.objects(StoreMessage.self).toArray()
    
      //check data
    if (objects?.count)! > 0  {
      
      for object in objects!.reversed() {
        print("getDataFromLocal", roomID)
        if roomID != object.roomID {
          continue
        }
        
        let message = Message()
        message.messages = object.messages
        message.participantsID = object.participantsID
        message.userID = object.userID
        message.roomID = object.roomID
        message.profileImage = object.profileImage
        
        
        messages.insert(message, at: 0)
        
      }
      
      self.chatCollectionNode.reloadData()
      
      print("message====================> ", messages.count)

      
    }else {
      
      messages = []
    }
    
    self.chatCollectionNode.reloadData()
    
  }// end getDataFromLocal
  
  // Save Data to local data
  func saveDataToLocal(data:[Message], completion: () -> ()) {
    
    print("saveDataToLocal")
//    guard let limit = Pagination.shareInstance.limit else {
//      return
//    }
    
//    if currentPage == Pagination.shareInstance.page {
//      
//      // Reset Old data
//      if (realm?.objects(StoreMessage.self).count)! > 0 {
//        try! realm?.write {
//          realm?.deleteAll()
//        }
//      }
//    }
    
    guard data.count > 0 else {
      return
    }
    
    for (index,message) in data.reversed().enumerated() {
//      if index == limit {
//        break
//      }
      
      let temp = StoreMessage()
      temp.messages = message.messages!
      temp.participantsID = message.participantsID!
      temp.userID = message.userID!
      temp.profileImage = message.profileImage!
      temp.roomID = message.roomID!
      
      
      // Sava Data to local datbase
      try! realm?.write {
        realm?.add(temp, update: true)
      }
      
      print("after save ==========")
      let result = realm?.objects(StoreMessage.self).toArray()
      print(result)
      
    }// end for
    
    completion()
    
  }
  
  func saveCurrentMessage(message:Message?, roomID:Int){
    
    guard message != nil else {
      return
    }
    
    let temp = StoreMessage()
    temp.messages = (message?.messages!)!
    temp.participantsID = (message?.participantsID!)!
    temp.userID = (message?.userID!)!
    temp.profileImage = (message?.profileImage!)!
    
    print("saveCurrentMessage id", self.roomID)
    
    temp.roomID = roomID
    
    // Sava Data to local datbase
    try! realm?.write {
      realm?.add(temp)
    }
  }
  
  //Check roomID 
  func checkRoomID() -> Int {
    
    if let userRoomID = realm?.objects(RoomID.self), userRoomID.count > 0 {
    
      for result in userRoomID {
        
        print("checkRoomID()", result.roomID)
        return result.roomID
      }
    }
    
    return 0
  }
  
}
//Covert Result to Array Object
extension Results {
  
  func toArray() -> [T] {
    return self.map{$0}
  }
}

extension RealmSwift.List {
  func toArray() -> [T] {
    return self.map{$0}
  }
}


