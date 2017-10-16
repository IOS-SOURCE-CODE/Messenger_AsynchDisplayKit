//
//  PeopleCustomTableViewCell.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/6/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import AsyncDisplayKit

fileprivate let SmallFontSize: CGFloat = 12
fileprivate let FontSize: CGFloat = 12
fileprivate let OrganizerImageSize: CGFloat = 40
fileprivate let HorizontalBuffer: CGFloat = 5

final class PeopleCellNode: ASCellNode {
  
  fileprivate var userProfile: ASNetworkImageNode!
  fileprivate var userName: ASTextNode!
  fileprivate var iconIsActive:ASImageNode!
  fileprivate var isActive = false
  fileprivate var switchImage:ASImageNode!

  init(friend: Friend, currentID:Int) {
    super.init()
    
    self.selectionStyle = .none
    
    print("Friend cell id", friend.id!)
    print("Share Current user",CurrentUser.shareInstance.id!)
    
    if friend.id == currentID {
      
      
      print("Current User should displa")
      isActive = true
      switchImage = ASImageNode()
      switchImage.image = UIImage(named: "On Switch")
      switchImage.contentMode = .scaleAspectFit
      switchImage.addTarget(self, action: #selector(self.changeStateActive), forControlEvents: .touchUpInside)
    }

    
    userProfile = ASNetworkImageNode()
    userProfile.cornerRadius = OrganizerImageSize/2
    userProfile.clipsToBounds = true
    
    // Change This when data existing
  
    if (friend.profileImage) == nil || (friend.profileImage?.isEmpty)! {
      friend.profileImage = "https://scontent-hkg3-1.xx.fbcdn.net/v/t31.0-8/15732174_941413352656320_7594404466250029989_o.jpg?oh=f638102ab64addbe807775222798fba7&oe=5957E40C"
    } else {
      
      friend.profileImage = URL_CHAT + friend.profileImage!
    }
    
    
    
    userProfile.url = URL(string: friend.profileImage!)
    
    iconIsActive = ASImageNode()
    iconIsActive.style.preferredSize = CGSize(width: 15, height: 15)
    iconIsActive.style.layoutPosition = CGPoint(x: 40, y: 30)
    iconIsActive.image = UIImage(named: "onlineIcon")
    
    if friend.lastName == nil {
      friend.lastName = ""
    }
    
    if friend.firstName == nil {
      friend.firstName = ""
    }
    
    userName = createLayerBackedTextNode(attributedString: NSAttributedString(string: (friend.lastName)! + (friend.firstName)!, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: FontSize)!, NSForegroundColorAttributeName: UIColor.darkGray]))
    
    automaticallyManagesSubnodes = true
  }
  
  @objc fileprivate func changeStateActive(){
    if isActive {
      switchImage.image = UIImage(named: "Off Switch")
      isActive = false
    } else {
      switchImage.image = UIImage(named: "On Switch")
      isActive = true
    }
  }
  
  fileprivate func createLayerBackedTextNode(attributedString: NSAttributedString) -> ASTextNode {
    let textNode = ASTextNode()
    textNode.isLayerBacked = true
    textNode.attributedText = attributedString
    
    return textNode
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
    userName.style.flexShrink = 1.0
    
   userProfile.style.preferredSize = CGSize(width: OrganizerImageSize, height: OrganizerImageSize)
    
    let imageInsets = UIEdgeInsets(top: HorizontalBuffer, left: 10, bottom: HorizontalBuffer, right: 10)
    let imageInset = ASInsetLayoutSpec(insets: imageInsets, child: userProfile)
    
    let absoluteSpec = ASAbsoluteLayoutSpec(children: [imageInset, iconIsActive])
    
    let headerStack = ASStackLayoutSpec.horizontal()

    headerStack.alignItems = ASStackLayoutAlignItems.center
    headerStack.justifyContent = ASStackLayoutJustifyContent.start
    headerStack.children = [absoluteSpec, userName]
    
    if isActive == true {
      
      switchImage.style.preferredSize = CGSize(width: 40, height: 24)
      let switchImageInsets = UIEdgeInsets(top: HorizontalBuffer, left: 0, bottom: HorizontalBuffer, right: 10)
      let switchImageInset = ASInsetLayoutSpec(insets: switchImageInsets, child: switchImage)
      let activeStack = ASStackLayoutSpec.horizontal()
      activeStack.alignItems = ASStackLayoutAlignItems.center
      activeStack.justifyContent = ASStackLayoutJustifyContent.spaceBetween
      activeStack.children = [headerStack,switchImageInset]
      return activeStack
      
    }
    
     return headerStack
  }
}
