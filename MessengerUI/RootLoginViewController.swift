//
//  RootLoginViewController.swift
//  MessengerUI
//
//  Created by MacBook Pro on 4/19/17.
//  Copyright © 2017 seyha. All rights reserved.
//

class RootLogin: UIViewController, UITextFieldDelegate{
    
    //MARK: ========  Custom UI Constrol ==========
    lazy var logo:UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "messengerLogo")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    //8 MARK - Welcome Label
    lazy var welcomeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to Messenger"
        label.numberOfLines = 4
        label.font = label.font.withSize(30)
        label.textAlignment = .center
        return label
    }()
    
    //7 MARK - Password Underline
    lazy var underlinePwd:UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.gray
        underline.layer.opacity = 0.5
        return underline
    }()
    
    //6 MARK - Email Underline
    lazy var underlineEmail:UIView = {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.gray
        underline.layer.opacity = 0.5
        return underline
    }()
    
    //5 MARK - Email Text Field
    lazy var emailField:UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Email or Phone"
        email.textAlignment = .center
        email.returnKeyType = .next
        email.clearButtonMode = UITextFieldViewMode.whileEditing
        return email
    }()
    
    //4 MARK - Password Text Field
    lazy var passwordField:UITextField = {
        let pwd = UITextField()
        pwd.translatesAutoresizingMaskIntoConstraints = false
        pwd.placeholder = "Password"
        pwd.textAlignment = .center
        pwd.returnKeyType = .done
        pwd.isSecureTextEntry = true
        pwd.clearButtonMode = UITextFieldViewMode.whileEditing
        return pwd
    }()
    
    //3 MARK - Log In Button
    lazy var logInBtn:UIButton = {
        let signUp = UIButton(type: UIButtonType.system)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.setTitle("Log In", for: .normal)
        return signUp
    }()
    
    //2 MARK - Login With Gmail
    lazy var gmailLoginBtn:UIButton = {
        let login = UIButton(type: UIButtonType.system)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitle("Log In with Gmail", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.backgroundColor = UIColor(hex: "0084ff")
        return login
    }()
    
    //1 MARK - Sign Up Button
    lazy var signUpBtn:UIButton = {
        let signUp = UIButton(type: UIButtonType.system)
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.setTitle("Sign Up", for: .normal)
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor(hex: "0084ff").cgColor
        return signUp
    }()
    
    
    
    var presenter:UserPresenter? //Presenter Object
    
    // MARK: ==========  Main Method ===========
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setSignUpButton()       //1
        setGmailLoginBtn()      //2
        setLogInBtn()           //3
        setPassword()           //4
        setEmail()              //5
        setEmailUnderline()     //6
        setPasswordUnderline()  //7
        setWelcomeLabel()       //8
        setLogo()               //9
        
        presenter = UserPresenter()
        presenter?.delegate = self
        
        //setup UITextFieldDelegate's delegate
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let realm = try? Realm() {
            
            let session = realm.objects(RealmSignUpModel.self)
          print("========= Checking Session", session.count)
            if session.count > 0 {
              
                print("inner session")
              
                let userInfo = UserModel()
                userInfo?.userID = session[0].userId
                userInfo?.email = session[0].email
                userInfo?.password = session[0].password
                userInfo?.firstName = session[0].firstName
                userInfo?.lastName = session[0].lastName
                userInfo?.profileImage = session[0].image
                userInfo?.userName = session[0].userName
                self.assignUser(userInfo: userInfo!)
              
              print("loading new view")
                //Navigate to home screen
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let homeScreen = storyBoard.instantiateViewController(withIdentifier: "home")
                self.present(homeScreen, animated: true, completion: nil)
            }
        }
    }
}

//MARK - Setup Interface
extension RootLogin{
    //1 TODO: Setup Sign Up Button
    func setSignUpButton(){
        self.view.addSubview(signUpBtn)
        
        signUpBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        signUpBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        signUpBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        signUpBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        signUpBtn.addTarget(self, action: #selector(self.signUpBtnPressed), for: UIControlEvents.touchUpInside)
    }
    
    //2 TODO: Setup Sign Up With Gmail
    func setGmailLoginBtn(){
        self.view.addSubview(gmailLoginBtn)
        gmailLoginBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        gmailLoginBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        gmailLoginBtn.bottomAnchor.constraint(equalTo: signUpBtn.topAnchor, constant: -20).isActive = true
        gmailLoginBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        gmailLoginBtn.addTarget(self, action: #selector(self.gmailLoginBtnPressed), for: UIControlEvents.touchUpInside)
    }
    
    //3 TODO: Setup Continue Button
    func setLogInBtn(){
        self.view.addSubview(logInBtn)
        logInBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        logInBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        logInBtn.bottomAnchor.constraint(equalTo: gmailLoginBtn.topAnchor, constant: -40).isActive = true
        logInBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        logInBtn.addTarget(self, action: #selector(self.loginBtnPressed), for: UIControlEvents.touchUpInside)
        
    }
    
    //4 TODO: Setup Password Text Field
    func setPassword(){
        self.view.addSubview(passwordField)
        passwordField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        passwordField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        passwordField.bottomAnchor.constraint(equalTo: logInBtn.topAnchor, constant:-20).isActive = true
    }
    
    //5 TODO: Setup Email Text Field
    func setEmail(){
        self.view.addSubview(emailField)
        emailField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        emailField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        emailField.bottomAnchor.constraint(equalTo: passwordField.topAnchor, constant: -20).isActive = true
    }
    
    //6 TODO: Setup Email Underline
    func setEmailUnderline(){
        self.view.addSubview(underlineEmail)
        underlineEmail.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        underlineEmail.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        underlineEmail.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 5.0).isActive = true
        underlineEmail.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    //7 TODO: Setup Password Underline
    func setPasswordUnderline(){
        self.view.addSubview(underlinePwd)
        underlinePwd.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        underlinePwd.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        underlinePwd.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 5.0).isActive = true
        underlinePwd.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    //8 TODO: Setup Welcome Label "Welcome to Messenger"
    func setWelcomeLabel(){
        self.view.addSubview(welcomeLabel)
        welcomeLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 40).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -40).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: emailField.topAnchor, constant: -50).isActive = true
    }
    
    //9 TODO: Setup Messenger Logo
    func setLogo(){
        self.view.addSubview(logo)
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -40).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

//MARK - Setup View Functionallities
extension RootLogin{
    
    //TODO: Sign Up Button
    func signUpBtnPressed(){
        print("SignUp Btn Pressed")
        let signUpVC = SignUpScreen()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    //TODO: Login With Gmail
    func gmailLoginBtnPressed(){
        //GIDSignIn.sharedInstance().signIn()
        print("Gmail Sign In Pressed")
    }
    
    // TODO: Hide Keyboard when user tap outside textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // TODO: Keyboard Return - Customize Keyboard behavior (Next, Done)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else{
            passwordField.resignFirstResponder()
            loginBtnPressed()
        }
        return true
    }
    
    // TODO: For Alert Message
    func alertMessage(Message:String){
        let alertController = UIAlertController(title: "Attention", message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (ACTION) in
            if (self.emailField.text?.isEmpty)!{
                self.emailField.becomeFirstResponder()
            } else if (self.passwordField.text?.isEmpty)!{
                self.passwordField.becomeFirstResponder()
            } else{
                self.emailField.becomeFirstResponder()
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK - Implement Login Button
extension RootLogin{
    
    func loginBtnPressed(){
        print("Login Btn Pressed")
        
        let email = emailField.text
        let password = passwordField.text
        
        if (email?.isEmpty)! || (password?.isEmpty)!{
            if (email?.isEmpty)!{
                alertMessage(Message: "Please enter your email address to login")
            }else if (password?.isEmpty)!{
                alertMessage(Message: "Please enter password")
            }
        }else if isValidEmailAddress(emailAddressString: email!){
            print("Valid")
            loginData()
        }else {
            alertMessage(Message: "Email address is invalid")
        }
        
    }
    //TODO: Preparing data for server
    func loginData(){
        
        let user = UserModel()
        user?.email = emailField.text!
        user?.password = passwordField.text!
        self.presenter?.loginData(data: user!)
    }
}

extension RootLogin:PresenterProtocol{
    
    //====Login Success====
    func didLoginSuccess(result: String, data: [UserModel]) {
        print("===Success in View==",data[0].userID)
        print("====Data Response===",data[0].email, data.count)
        
        guard data.count > 0  else {
            return
        }
        
        let realm = try! Realm()
        
        print("======== Data Model =========")
        print(data[0].email)
        
        // check existing data
        let rm = realm.objects(RealmSignUpModel.self)
        
        if rm.count > 0 {
            
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        //=== Working with realm ===
        let userModel = RealmSignUpModel()
        userModel.userId = data[0].userID
        userModel.email = data[0].email
        userModel.password = data[0].password
        userModel.firstName = data[0].firstName
        userModel.lastName = data[0].lastName
        userModel.userName = data[0].userName
        userModel.image = data[0].profileImage
        
        try! realm.write {
            realm.add(userModel)
        }
        
        let wrm = realm.objects(RealmSignUpModel.self)
        print("=====Realm=====",wrm)
        
        // assign user info
        
        assignUser(userInfo: data[0])
        
        
        let alert = UIAlertController(title: "Success", message: "Logged In successfully", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:{ (Action) in

            //Navigate to home screen
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let homeScreen = storyBoard.instantiateViewController(withIdentifier: "home")
            //self.navigationController?.pushViewController(homeScreen, animated: true)
          
            self.present(homeScreen, animated: true, completion: nil)
          
          print("=======Go HomeScreen========")
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //====Login Fail====
    func didLoginFail(result: String) {
        
        let alert = UIAlertController(title: "Failed!", message: "Incorrect Email or Password", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Assign value user to another screen
    
    func assignUser(userInfo: UserModel) {
      
      // set User Singleton Partern
      CurrentUser.shareInstance.id = userInfo.userID
      CurrentUser.shareInstance.email = userInfo.email
      CurrentUser.shareInstance.password = userInfo.password
      CurrentUser.shareInstance.firstName = userInfo.firstName
      CurrentUser.shareInstance.lastName = userInfo.lastName
      CurrentUser.shareInstance.profileImage = userInfo.profileImage
      CurrentUser.shareInstance.username  = userInfo.userName
      
      print("========   assignUser  ============", userInfo.id)
       print("========   assignUser  ============", CurrentUser.shareInstance.id)
      

    }
}

class RealmSignUpModel:Object{
    
    dynamic var id  = 0
    dynamic var userId = 0
    dynamic var email = ""
    dynamic var password = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var userName = ""
    dynamic var image = ""
    
    
}

