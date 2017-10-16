//
//  GroupCellNode.swift
//  MessengerUI
//
//  Created by Mean Reaksmey on 4/21/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import Foundation
import AsyncDisplayKit

// class cell
class GroupCellNode: ASCellNode {
    
    //  let imageNode = ASImageNode()
    fileprivate let HorizontalBuffer: CGFloat = 10
    fileprivate var _organizerAvatarImageView: ASNetworkImageNode!
    fileprivate var _organizerNameLabel: ASTextNode!
    fileprivate var _locationLabel: ASTextNode!
    fileprivate var _timeIntervalSincePostLabel: ASTextNode!
    fileprivate let OrganizerImageSize: CGFloat = 80
    fileprivate let SmallFontSize: CGFloat = 10
    fileprivate let FontSize: CGFloat = 15
    fileprivate var _buttonNode: ASButtonNode!
    fileprivate var ASDisplayNode:ASDisplayNode!
    fileprivate var _buttonlabel:ASTextNode!
    fileprivate var _groupNameLabel:ASTextNode!
    fileprivate var _imageGroup = [String]()
    
    var createGroupLabel = ASButtonNode()
    var memberName = ""
    var status = ""
    var nameGroup = ""
    var isHeader = false
    var detailButton: ASNetworkImageNode!
    var getWidth = Float()
    // var _node:ASDisplayNode!
    
    required init(with image : [String],sizeWidth:Float) {
        super.init()
        
        _imageGroup = image
        detailButton = ASNetworkImageNode()
        getWidth = sizeWidth
        _organizerAvatarImageView = ASNetworkImageNode()
        _organizerAvatarImageView.cornerRadius = OrganizerImageSize/2
        _organizerAvatarImageView.clipsToBounds = true
        _organizerAvatarImageView?.image = UIImage(named: "")
        _buttonNode = ASButtonNode()
        
        // set buttona
        _buttonlabel = ASTextNode()
        _buttonNode.setTitle("this is ", with: nil, with: .blue, for: .normal)
        
        _buttonNode.contentVerticalAlignment = .top
        _buttonNode.contentHorizontalAlignment = .middle
        _buttonNode.addTarget(self, action: #selector(buttPress), forControlEvents: .touchUpInside)
        
        _groupNameLabel = ASTextNode()
        
        _timeIntervalSincePostLabel = createLayerBackedTextNode(attributedString: NSAttributedString(string: "interval test", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: FontSize)!, NSForegroundColorAttributeName: UIColor.lightGray]))
        automaticallyManagesSubnodes = true
        
    }
    
    func buttPress(){
        print("this is my test")
    }
    
    fileprivate func createLayerBackedTextNode(attributedString: NSAttributedString) -> ASTextNode {
        let textNode = ASTextNode()
        textNode.isLayerBacked = true
        textNode.attributedText = attributedString
        
        return textNode
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        switch _imageGroup.count {
        case 1:
            
            let image1 = ASNetworkImageNode()
            
            print("data>>: ",imageURL)
            
            image1.url = URL(string:imageURL + _imageGroup[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            image1.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            _organizerAvatarImageView.addSubnode(image1)
        case 2:
            let image1 = ASNetworkImageNode()
            image1.url = URL(string:imageURL +  _imageGroup[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            image1.frame = CGRect(x: 0, y: 0, width: 40, height: 80)
            
            //image view2
            let image2 = ASNetworkImageNode()
            image2.url = URL(string:imageURL +  _imageGroup[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            image2.frame = CGRect(x: 41, y:0 , width: 40, height: 80)
            
            //add image to view
            _organizerAvatarImageView.addSubnode(image2)
            _organizerAvatarImageView.addSubnode(image1)
            
        case 3:
            
            //image view1
            let image1 = ASNetworkImageNode()
            image1.url = URL(string:imageURL +  _imageGroup[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            image1.frame = CGRect(x: 0, y: 0, width: 40, height: 80)
            
            //image view2
            let image2 = ASNetworkImageNode()
            image2.url = URL(string:imageURL +  _imageGroup[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            image2.frame = CGRect(x: 41, y:0 , width: 40, height: 38)
            
            //image view3
            let image3 = ASNetworkImageNode()
            image3.url = URL(string:imageURL +  _imageGroup[2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            image3.frame = CGRect(x: 41, y: 39, width: 40, height: 41)
            
            //main view
            _organizerAvatarImageView.addSubnode(image3)
            _organizerAvatarImageView.addSubnode(image2)
            _organizerAvatarImageView.addSubnode(image1)
        default:
            break
        }
        
        //initialize variable
        _organizerNameLabel = createLayerBackedTextNode(attributedString: NSAttributedString(string: nameGroup, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: FontSize)!, NSForegroundColorAttributeName: UIColor.black]))
        _organizerNameLabel.maximumNumberOfLines = 1
        _locationLabel = createLayerBackedTextNode(attributedString: NSAttributedString(string: status, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: SmallFontSize)!, NSForegroundColorAttributeName: UIColor.lightGray]))
        _locationLabel.maximumNumberOfLines = 1
        
        // add label location
        _locationLabel.style.flexShrink = 1.0
        _organizerNameLabel.style.flexShrink = 1.0
        
        // add label to cell
        let headerSubStack = ASStackLayoutSpec.vertical()
        headerSubStack.children = [_organizerNameLabel, _locationLabel]
        headerSubStack.alignItems = ASStackLayoutAlignItems.center
        let headerSubStackInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let headerSubStackInset = ASInsetLayoutSpec(insets: headerSubStackInsets, child: headerSubStack)
        
        // add space between below label
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        _organizerAvatarImageView.style.flexShrink = 1.0
        
        // image view  & image sizes
        _organizerAvatarImageView.style.preferredSize = CGSize(width: OrganizerImageSize, height: OrganizerImageSize)
        let avatarInsets = UIEdgeInsets(top: HorizontalBuffer, left: 0, bottom: HorizontalBuffer, right: HorizontalBuffer)
        let avatarInset = ASInsetLayoutSpec(insets: avatarInsets, child: _organizerAvatarImageView)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        // set button label
        _buttonlabel = createLayerBackedTextNode(attributedString: NSAttributedString(string: "",  attributes: [ NSParagraphStyleAttributeName: style ]))
        _buttonlabel.style.preferredSize = CGSize(width:Int(getWidth/2),height:100)
        _buttonlabel.backgroundColor = UIColor(hex: "0xF9F9F9")
        _buttonlabel.borderWidth = 0.2
        _buttonlabel.borderColor = UIColor.lightGray.cgColor
        
        //set label group name member
        _groupNameLabel = createLayerBackedTextNode(attributedString: NSAttributedString(string: memberName, attributes: [ NSParagraphStyleAttributeName: style,NSForegroundColorAttributeName: UIColor.lightGray]))
        _groupNameLabel.style.layoutPosition = CGPoint(x: 0, y: 17)
        _groupNameLabel.style.preferredSize = CGSize(width:Int(getWidth/2),height:50)
        _groupNameLabel.maximumNumberOfLines = 1
        
        let absoluteSpec = ASAbsoluteLayoutSpec(children: [ _buttonlabel,_groupNameLabel])
        let mainHeaderStack = ASStackLayoutSpec.vertical()
        mainHeaderStack.alignItems = .center
        mainHeaderStack.justifyContent = .spaceBetween
        mainHeaderStack.children = [avatarInset,headerSubStackInset,absoluteSpec]
        
        // set name group label
        detailButton.style.preferredSize = CGSize(width: 10, height: 20)
        detailButton.backgroundColor = UIColor.white
        detailButton.image = UIImage(named: "button_group")
   
        
        detailButton.style.layoutPosition = CGPoint(x: Int(getWidth/2-30), y: 10)
        
        //check condition to create header
        if isHeader {
            let yourGroup = createLayerBackedTextNode(attributedString: NSAttributedString(string: "Your Groups", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: FontSize)!, NSForegroundColorAttributeName: UIColor.black]))
            yourGroup.style.layoutPosition = CGPoint(x: Int(10), y: 0)
            //create group label
            createGroupLabel.setTitle("Create", with:  UIFont(name: "Avenir-Medium", size: FontSize), with: UIColor(hex: "0x157EFB"), for: .normal)
            createGroupLabel.style.layoutPosition = CGPoint(x: Int(getWidth-80), y: 0)
            
            isHeader = false
            return ASAbsoluteLayoutSpec(children: [yourGroup,createGroupLabel])
        }
        
        return ASAbsoluteLayoutSpec(children: [mainHeaderStack,detailButton])
        
    }
}
