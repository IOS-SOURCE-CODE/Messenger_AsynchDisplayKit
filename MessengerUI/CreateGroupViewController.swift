//
//  CreateGroupViewController.swift
//  MessengerUI
//
//  Created by Mean Reaksmey on 4/21/17.
//  Copyright © 2017 seyha. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import KSTokenView
import AlamofireObjectMapper
import Alamofire

class CreateGroupViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UITextFieldDelegate {
    
    var names: Array<String> = []
    var alldata = [People]()
    var parameters: Parameters = [:]
    var arrayId = [Int]()
    var copyAlldata = [People]()
    var availableInsert = false

    
    @IBOutlet weak var nameGroupTextField: UITextField!
    @IBOutlet weak var cameraPickImageView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var headerView: UIView!
    //  @IBOutlet weak var addmemeberView: UIView!
    @IBOutlet weak var tokenView: KSTokenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        setAction()
        
        setToken()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        alamoreFireRequest()
    }
    
    
    @IBAction func createGroupAction(_ sender: Any) {
        
        if (nameGroupTextField.text?.isEqual(""))! || tokenView.tokens()! == []{
            let uiAlert = UIAlertController(title: "Message", message: "Create faile", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
        }else{
            uploadImageToServer()
            let uiAlert = UIAlertController(title: "Message", message: "Create Success", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
                self.dismiss(animated: true, completion: nil)
            }))
        }
        
        
       
        
    }
    
    func setToken(){
        
        tokenView.delegate = self
        tokenView.promptText = "Top: "
        tokenView.placeholder = "Type to search"
        tokenView.descriptionText = "Languages"
        tokenView.maxTokenLimit = -1
        tokenView.minimumCharactersToSearch = 0 // Show all results without without typing anything
        tokenView.style = .squared
        
        /// default is true. token can be deleted with keyboard 'x' button
        tokenView.shouldDeleteTokenOnBackspace = true
        
        /// default is ture. Sorts the search results alphabatically according to title provided by tokenView(_:displayTitleForObject) delegate
        tokenView.shouldSortResultsAlphabatically = true
        
        /// default is true. If false, token can only be added from picking search results. All the text input would be ignored
        tokenView.shouldAddTokenFromTextInput = false
        
    }
    
    //upload imagez
    func uploadImageToServer(){
        if(HttpRequest.checkInternetConnection()){
            
            var imageURL = ""
            let parameters:[String:Data] = [
                "profile_image" : UIImagePNGRepresentation(cameraPickImageView.image!)!
            ]
            
            HttpRequest.upload("image/upload", parameters: parameters) { (success, json, header) -> Void in
                if success {
                    imageURL = "\(json!["path"])"
                    
                }else{
                    print("=====>errimage", json)
                }
                
                self.arrayId = []
                
                for i in self.alldata {
                    a:for j in self.tokenView.tokens()!{
                        if (j.title.isEqual(i.username)){
                            print("====id:\(i.id),name:\(i.username) ")
                            self.arrayId.append(i.id!)
                            break a
                        }
                    }
                }
                
                if (self.cameraPickImageView.image?.isEqual(UIImage(named: "camerafeftfffea00321123")))!{
                    imageURL = ""
                }
                
                let param :Parameters = [
                    "title": self.nameGroupTextField.text!,
                    "user_id":self.arrayId,
                    "type":"room",
                    "profile": imageURL
                    
                ]
                
                self.alamoreFirePost(param: param)
            }
            
        } else{
            
        }
    }
    
    //set action of cameraPickImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        cameraPickImageView.image = selectPhoto
        dismiss(animated: true, completion: nil)
    }
    
    func setAction(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.uploadImage))
        cameraPickImageView.addGestureRecognizer(tapGestureRecognizer)
        cameraPickImageView.isUserInteractionEnabled = true
    }
    
    func uploadImage() {
        let selectProfileAlertController = UIAlertController(title: "select action", message: nil, preferredStyle: .actionSheet)
        
        // Handle for select image from gallery
        let chooseImageGallery = UIAlertAction(title: "choose from phone gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let profileImagePickerController = UIImagePickerController()
            profileImagePickerController.delegate = self
            profileImagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            profileImagePickerController.allowsEditing = true
            
            
            self.present(profileImagePickerController, animated: true, completion: nil)
        })
        
        // Handle when user select to open camera
        let launchCamera = UIAlertAction(title: "launch camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let profileImagePickerController = UIImagePickerController()
                profileImagePickerController.delegate = self
                profileImagePickerController.sourceType = UIImagePickerControllerSourceType.camera;
                
                profileImagePickerController.allowsEditing = true
                
                print("=======>camera")
                
                self.present(profileImagePickerController, animated: true, completion: nil)
                
            }else{
                print("Camera is not available")
            }
            
        })
        
        // Handle when user select on cancel button
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        // Handle for add each item and its action for Alert Controller
        selectProfileAlertController.addAction(chooseImageGallery)
        selectProfileAlertController.addAction(launchCamera)
        selectProfileAlertController.addAction(cancelAction)
        
        self.present(selectProfileAlertController, animated: true, completion: nil)
    }
    
    func customizeView(){
        
        //set cameraview
        cameraView.layer.cornerRadius = cameraView.bounds.width/2
        cameraView.clipsToBounds = true
        cameraView.layer.borderWidth = 0.3
        cameraView.layer.borderColor = UIColor.lightGray.cgColor
        
        //setheaderview border
        headerView.layer.borderWidth = 0.3
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nameGroupTextField.resignFirstResponder()
        //searchNameTextField.resignFirstResponder()
    }
    
    func alamoreFirePost(param:Parameters){
        
        self.alldata = []
        
        
        Alamofire.request(mainURL + "room/add", method: .post, parameters: param, encoding: JSONEncoding.default, headers: head).responseArray(queue: nil, keyPath: "data", context: nil){ (response:DataResponse<[People]>) in
            
            
            if let data = response.result.value {
                self.alldata = data
            } else {
                print("Faild To Loading News")
                print("status===faile: ",response.response)
            }
            
           // self.checkCondition()
            
            for i in self.alldata{
                if i.username != nil{
                    self.names.append(i.username!)
                }
            }
            
            
            
        }
    }
    
    // check condition before insert to server
    func checkCondition(){
        if (nameGroupTextField.text?.isEqual(""))! || tokenView.tokens()! == []{
            let uiAlert = UIAlertController(title: "Message", message: "Create faile", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
        }else{
            let uiAlert = UIAlertController(title: "Message", message: "Create Success", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
        }
    }
    
}

extension CreateGroupViewController: KSTokenViewDelegate {
    
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        
        if (string.characters.isEmpty){
            completion!(names as Array<AnyObject>)
            return
        }
        
        var data: Array<String> = []
        for value: String in names {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        
        var str = "nil"
        
        if object is String{
            str = object as!String
        }else{
            let data = object as! People
            if data.username != nil{
                str =  data.username! + "     "
            }
        }
        
        return str
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {
        
        if token.title == "f" {
            return false
        }
        
        return true
    }
    
    func tokenView(_ token: KSTokenView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tokenView.becomeFirstResponder()
    }
    
    func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken) {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_close")
        
        imageView.frame = CGRect(x: token.bounds.width-20, y: 3, width: 15, height: 15)
        token.addSubview(imageView)
    }
    
    func tokenView(_ tokenView: KSTokenView, didSelectToken token: KSToken) {
        tokenView.deleteSelectedToken()
    }
    
    func alamoreFireRequest(){
        
        Alamofire.request(mainURL + "user", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseArray(queue: nil, keyPath: "data", context: nil){ (response:DataResponse<[People]>) in
            
            debugPrint(response)
            if let data = response.result.value {
                self.alldata = data
                
                for i in self.alldata{
                    if i.username != nil{
                        self.names.append(i.username!)
                    }
                }
                
            } else {
                print("Faild To Loading News")
            }
        }
    }
}



