//
//  PeopleTableViewController.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/6/17.
//  Copyright © 2017 seyha. All rights reserved.
//


class PeopleViewController:UIViewController{
  
  //MARK: ========= Propetyies ===================
  var tableNode: ASTableNode!
  var searchController = UISearchController()
  var customSegment: UISegmentedControl!
  var refreshControl:UIRefreshControl!
  var segmentView:UIView!
  
  // Delegate With Presenter
  var people:PeopleAPIPresenter?
  var resultDelegate: PeoplePresenter?
  
  // ========= DATA ===========
  var friends:[[Friend]] = [[]]
  var currentUserLogin:[Friend] = []
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    tableNode = ASTableNode()
  
    tableNode.delegate = self
    tableNode.dataSource = self
    
  }
  
  deinit {
    tableNode.delegate = nil
    tableNode.dataSource = nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // testing =========
    
    // ======== Get Current User ========
//    CurrentUser.shareInstance.email = ""
//    CurrentUser.shareInstance.id = 1
//    CurrentUser.shareInstance.firstName = "Seyha"
//    CurrentUser.shareInstance.password = "Seyha"
//    CurrentUser.shareInstance.profileImage = "https://scontent-hkg3-1.xx.fbcdn.net/v/t31.0-8/15732174_941413352656320_7594404466250029989_o.jpg?oh=f638102ab64addbe807775222798fba7&oe=5957E40C"
//    CurrentUser.shareInstance.username = "Seyha"
    
//    currentUserLogin = [Friend(id: 100, hashCode: "", email: "Seyha", password: "", firstName: "Seyha", lastName: "Seyha", username: "Seyha", profileImage: "", isActive: 1, vartificationCode: 1)]
    
    
    // remove line under navigation controller
    for parent in navigationController!.view.subviews {
      for child in parent.subviews {
        for view in child.subviews {
          if view is UIImageView && view.frame.height == 0.5 {
            view.alpha = 0
          }
        }
      }
    }
    
    // set up searchController
    configurationSearch()
    
    refreshControl = UIRefreshControl()
    tableNode.view.addSubview(refreshControl)
    tableNode.view.tableFooterView = UIView()
    
    
    self.view.addSubnode(tableNode)
    tableNode.view.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
    
    setupSegementControl()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    // remove line under navigation controller
    
    // ===== Request Data =======
    people = PeopleAPIPresenter(delegate: self)
    
    print("ViewWillApear PeopleVC =========", CurrentUser.shareInstance.id!)
    
    people?.getUsers(userID: CurrentUser.shareInstance.id!)

    
    
  }
  
// MARK: ===== Ultilities   =======
  
  func configurationSearch() {
    
    let searchVC = SearchViewController()
    self.searchController = UISearchController(searchResultsController: searchVC)
    self.searchController.searchResultsUpdater = searchVC
    self.searchController.searchBar.delegate = searchVC
    self.searchController.definesPresentationContext = true
    self.searchController.searchBar.sizeToFit()
    self.navigationItem.titleView = self.searchController.searchBar
    self.searchController.hidesNavigationBarDuringPresentation = false
    self.searchController.dimsBackgroundDuringPresentation = false
    changeSearchBarStyleBackground()
    
    // Stay on another
    navigationItem.titleView = searchController.searchBar
    searchController.hidesNavigationBarDuringPresentation = false
    definesPresentationContext = true
    
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if refreshControl.isRefreshing {
      refreshControl.endRefreshing()
    }
  }
  
  // Customize searchbar button
  func changeSearchBarStyleBackground(){

    for subView in searchController.searchBar.subviews {
      
      for subViewOne in subView.subviews {
        
        if let _ = subViewOne as? UITextField {
          subViewOne.backgroundColor = UIColor(hex: "EFEFEF")
        }
      }
    }
  }
  
  func segmentControlAction(sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      
      print("0")
    case 1:
      
      print("1")
    default:
      print("default")
    }
  }
  
  func setupSegementControl(){
    
    let items = ["All","Active"]
   
    customSegment = UISegmentedControl(items: items)
    customSegment.frame = CGRect(x: 0, y: 0, width:300, height: 35)
    customSegment.selectedSegmentIndex = 1
    customSegment.tintColor = UIColor(hex: "0076FF")
    customSegment.backgroundColor = UIColor.white
    
    
    customSegment.addTarget(self, action: #selector(self.segmentControlAction(sender:)), for: .valueChanged)
    customSegment.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(customSegment)
    
    segmentView = UIView()
    segmentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
    segmentView.backgroundColor = UIColor(hex: "EFEFEF")
    self.view.addSubview(segmentView)
    
    segmentView.addSubview(customSegment)
    
    let vConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[segment]-|", options: [], metrics: nil, views: ["segment":customSegment])
    segmentView.addConstraints(vConstraint)
    let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[segment(25)]", options: [], metrics: nil, views: ["segment":customSegment])
    
    segmentView.addConstraints(hConstraint)
 
    
  }
  
  func segmentedValueChanged(_ sender:UISegmentedControl!)
  {
    print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
  }

  
  override func viewWillLayoutSubviews() {
    
    tableNode.frame = self.view.bounds
    segmentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
  
  }
  
}

//MARK: ======= TABLE DELEGATE METHOD ========
extension PeopleViewController: ASTableDelegate, ASTableDataSource {
  
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    print("======== number of section", friends.count)
    return friends.count
  }
  
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
   
    return friends[section].count
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    
    let myFriend = friends[indexPath.section][indexPath.row]
    
    // Check Logined User
    guard CurrentUser.shareInstance.id != nil else { return { ASCellNode() } }
    
    let cellNodeBlock = { () -> ASCellNode in
      let cellNode = PeopleCellNode(friend: myFriend, currentID:CurrentUser.shareInstance.id!)
      cellNode.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
      return cellNode
    }
    
    return cellNodeBlock
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor(hex: "EFEFEF")
    let headerLabel = UILabel(frame: CGRect(x: 10, y: 8, width:
      tableView.bounds.size.width, height: tableView.bounds.size.height))
    headerLabel.font = UIFont(name: "Verdana", size: 12)
    headerLabel.textColor = UIColor(hex: "424242")
    headerLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerLabel.sizeToFit()
    headerView.addSubview(headerLabel)
    
    return headerView
  }
  
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
  
    guard indexPath.section > 0 else {
      return
    }
   
    let participant = friends[indexPath.section][indexPath.row]
    guard participant.id != nil else {
      return
    }
    
    self.performSegue(withIdentifier: "toChatSegue", sender: participant)
    
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    return section == 0 ? "" : "Active Contacts(0)"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toChatSegue" {
      if let data = sender as? Friend {
        
          print("value === ", data)
        
        let destinationVC = segue.destination as! ChatViewController
        destinationVC.friend = data
       
      }
      
    }
  }

}

//MARK ============ Searching =========


//MARK: ====== Notify From Presenter
extension PeopleViewController: PeopleAPIPresenterProtocol{
  
  func reponseData(data: [Friend]) {
    if !data.isEmpty {
      
      friends = []
      
     currentUserLogin = [Friend(id: CurrentUser.shareInstance.id!, hashCode: "", email: CurrentUser.shareInstance.email!, password: CurrentUser.shareInstance.password! , firstName: CurrentUser.shareInstance.firstName! , lastName: CurrentUser.shareInstance.lastName!, username: CurrentUser.shareInstance.username!, profileImage: CurrentUser.shareInstance.profileImage!, isActive: 1, vartificationCode: 1)]
      
       print("reponseData ==> PeopleVC", currentUserLogin[0].id!)
      
      
      friends.append(currentUserLogin)
      friends.append(data)
      print("Number of section in friend", friends.count)
      
    } else {
      
      self.friends = []
    }
    
    self.tableNode.reloadData()
  }
  
}


// Research Chating

extension PeopleViewController: PeoplePresenterProtocol {
  
  func recieveData(data: Friend) {
    
     print("<<<<<<<<<< reciveDataFromResultSeach")
    
    self.performSegue(withIdentifier: "toChatSegue", sender: data)
    
  }
}



