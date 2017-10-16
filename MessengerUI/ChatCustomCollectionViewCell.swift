//
//  ChatCustomCollectionViewCell.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/10/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

fileprivate let FontSize:CGFloat = 12
fileprivate let maxLines = 3
fileprivate let originalImageSize:CGFloat = 30

final class ChatCellNode: ASCellNode, ASTextNodeDelegate {
  
  //MARK: Propety
  var messageChat:ASTextNode!
  var messageChatting:Message!
  var partnerImage: ASNetworkImageNode!
  
  init(chat:Message?, currentUserID:Int){
    super.init()
    
    // Assignment Partner Chatting Default
    partnerImage = ASNetworkImageNode()
    
    if ((chat?.profileImage?.range(of: "http")) != nil) {
      
      partnerImage.url = URL(string: (chat?.profileImage!)!)
      
    } else {
      
      if let profile = chat?.profileImage {
        
        partnerImage.url = URL(string: URL_CHAT + profile)
        
      }

    }
    
    
    partnerImage.cornerRadius = originalImageSize / 2
    partnerImage.clipsToBounds = true
    
    guard let chatting = chat else {
      return
    }
    // Assign Value
    messageChatting = chatting
        
    // Change color base on user chatting
    let textColor = messageChatting.participantsID != currentUserID ? UIColor.black : UIColor.white
    
    messageChat = createLayerBackedtextNode(attributedString: NSAttributedString(string: (messageChatting.messages)!, attributes: [
                                    NSFontAttributeName: UIFont(name: "Avenir-Medium",
                                    size: FontSize)!,
                                    NSForegroundColorAttributeName: textColor
                                ]))
   
    messageChat.delegate = self
    // Automatically Add Subnodes
    automaticallyManagesSubnodes = true
    
  }
  
    
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    messageChat.style.flexShrink = 1.0
   
    let messageChatInsets = UIEdgeInsets(top: 5, left: messageChatting.participantsID != CurrentUser.shareInstance.id ? originalImageSize + 15 : 50 , bottom: 5, right: messageChatting.participantsID != CurrentUser.shareInstance.id ? 50 : 10)
    let messageChatInset = ASInsetLayoutSpec(insets: messageChatInsets, child: messageChat)
    
    // User chating
    partnerImage.style.preferredSize = CGSize(width: originalImageSize, height: originalImageSize)
    let partnerImageInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
    let partnerImageInset = ASInsetLayoutSpec(insets: partnerImageInsets, child: partnerImage)
    
    
    let spacer = ASLayoutSpec()
    spacer.style.flexGrow = 1
    spacer.style.flexShrink = 1
    
    // Relative LayoutSpec
    let relativeSpec = ASRelativeLayoutSpec(
      horizontalPosition: messageChatting.participantsID != CurrentUser.shareInstance.id ? .start : .end,
                            verticalPosition: .end,
                            sizingOption: [], child: messageChatInset)
    
    // Absolute LayoutSpec Partner Chat
    let absoluteLayoutSpec = ASAbsoluteLayoutSpec()
    absoluteLayoutSpec.sizing = .sizeToFit
    absoluteLayoutSpec.children = [partnerImageInset,relativeSpec]
    
    return messageChatting.participantsID != CurrentUser.shareInstance.id ? absoluteLayoutSpec : relativeSpec
  }
  
  fileprivate func createLayerBackedtextNode(attributedString: NSAttributedString) -> ASTextNode {
  
    let textNode = ASTextNode()
    
    textNode.cornerRadius = 5
    textNode.clipsToBounds = true
    textNode.attributedText = attributedString
    textNode.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right:7)
    
    // Change background color base user
    textNode.backgroundColor = messageChatting.participantsID !=  CurrentUser.shareInstance.id ? UIColor(hex:"EFEFF4") : UIColor(hex: "0076FF")
    
    textNode.onDidLoad { (_) in
      
      textNode.isUserInteractionEnabled = true
      let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu(sender:)))
      textNode.view.addGestureRecognizer(longPress)
    
    }
    
    return textNode
  }
  
  open override func becomeFirstResponder() -> Bool {
    return true
  }
  
  func showMenu(sender: AnyObject?) {
    print("Long Press Me")
    messageChat.becomeFirstResponder()
    let menu = UIMenuController.shared
    if !menu.isMenuVisible {
      menu.setTargetRect(messageChat.view.bounds, in: messageChat.view)
      menu.setMenuVisible(true, animated: true)
      print("-------------------------",messageChat.view.bounds)
    }
  }

  override open func copy() -> Any {
    
    let board = UIPasteboard.general
    board.string = messageChat.attributedText?.string
    let menu = UIMenuController.shared
    menu.setMenuVisible(false, animated: true)
    
    return menu
  }
//
//  override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//    return action == #selector(UIResponderStandardEditActions.copy)
//  }
  

  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
    
  }
}


