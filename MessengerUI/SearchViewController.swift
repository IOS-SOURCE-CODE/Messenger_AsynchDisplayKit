//
//  SearchResultTableViewController.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/26/17.
//  Copyright © 2017 seyha. All rights reserved.
//

class SearchViewController: ASViewController<ASDisplayNode> {

  var tableNode: ASTableNode!
  
  
  // Delegate With Presenter
  var people:PeopleAPIPresenter?
  
  // ========= DATA ===========
  var friends:[Friend] = []
  
  init() {
    
    tableNode = ASTableNode()
    super.init(node: tableNode)
    tableNode.delegate = self
    tableNode.dataSource = self
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  deinit {
    tableNode.delegate = nil
    tableNode.dataSource = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableNode.view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    people = PeopleAPIPresenter(delegate: self)
    
    tableNode.view.tableFooterView = UIView()
  
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    
  }
  
}

//MARK: ======= TABLE DELEGATE METHOD ========
extension SearchViewController: ASTableDelegate, ASTableDataSource {
  
  func numberOfSections(in tableNode: ASTableNode) -> Int {
    
    return 1
  }
  
  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    
    return friends.count
  }
  
  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    
    let myFriend = friends[indexPath.row]
    
    let cellNodeBlock = { () -> ASCellNode in
      let cellNode = PeopleCellNode(friend: myFriend, currentID:0)
      cellNode.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
      return cellNode
    }
    
    return cellNodeBlock
  }
  
  
  
  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
   
    let participant = friends[indexPath.row]
    guard participant.id != nil else {
      return
    }
    
    
    dismiss(animated: false) {
      
      let people = PeoplePresenter()
      people.reciveDataFromResultSeach(data: participant)
      
    }
    
    //self.performSegue(withIdentifier: "toChatSegue", sender: participant)
    
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "People"
  }
  
  
//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let headerView = UIView()
//    headerView.backgroundColor = UIColor(hex: "EFEFEF")
//    let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:
//      tableView.bounds.size.width, height: tableView.bounds.size.height))
//    headerLabel.font = UIFont(name: "Verdana", size: 12)
//    headerLabel.textColor = UIColor.red//UIColor(hex: "424242")
//    headerLabel.sizeToFit()
//    headerView.addSubview(headerLabel)
//    
//    return headerView
//  }

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toChatSegue" {
      if let data = sender as? Friend {
        let destinationVC = segue.destination as! ChatViewController
        destinationVC.friend = data
      }
      
    }
  }
  
}

// MRAK: SEARCHING
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
  
  func updateSearchResults(for searchController: UISearchController) {
    
    searchController.searchResultsController?.view.isHidden = false
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    print("textDidChange", searchText)
    people?.searchPeople(name: searchText)
    
  }
  
}


//MARK: ====== Notify From Presenter
extension SearchViewController: PeopleAPIPresenterProtocol{
  
  func responseDataPeopleSearch(data: [Friend]) {
    
    print("responseDatafriendsearch")
    
    if !data.isEmpty {
      
      print("responseDatafriendsearch")
      
      self.friends = []
      self.friends = data
      
    } else {
      
      self.friends = []
    }
    
    self.tableNode.reloadData()
  }
  
}


























