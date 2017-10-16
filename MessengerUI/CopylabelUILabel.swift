//
//  CopylabelUILabel.swift
//  MessengerUI
//
//  Created by Hiem Seyha on 4/19/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class CopyableLabel: UILabel {
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  func sharedInit() {
    isUserInteractionEnabled = true
    addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
  }
  
  func showMenu(sender: AnyObject?) {
    becomeFirstResponder()
    let menu = UIMenuController.shared
    if !menu.isMenuVisible {
      menu.setTargetRect(bounds, in: self)
      menu.setMenuVisible(true, animated: true)
    }
  }
  
  override func copy(_ sender: Any?) {
    let board = UIPasteboard.general
    board.string = text
    let menu = UIMenuController.shared
    menu.setMenuVisible(false, animated: true)
  }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return action == #selector(UIResponderStandardEditActions.copy)
  }
}
