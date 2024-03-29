//
//  LoginRegisterVC.swift
//  Marina Home
//
//
//  Created by Codilar on 12/04/23.
////MARK START{MHIOS-1259}
//changed the Country Code style and divider height in UI
////MARK END{MHIOS-1259}
///////MARK START{MHIOS-1249}
//changed the google button border width in UI side
////MARK END{MHIOS-1249}

import UIKit
import GoogleSignIn
import AuthenticationServices
import Firebase
import DropDown
import KlaviyoSwift

import Firebase
import FirebaseMessaging

import Foundation
import Adjust
class LoginRegisterVC: AppUIViewController {
    let dropDown = DropDown()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginView: UIStackView!
    @IBOutlet weak var registerView: UIStackView!
    @IBOutlet weak var loginViewButton: AppSecondaryButton!
    @IBOutlet weak var registerViewButton: AppSecondaryButton!
    @IBOutlet weak var actionTypeLbl1: UILabel!
    @IBOutlet weak var actionTypeLbl2: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var btnApple: UIButton!
    //Login
    @IBOutlet weak var loginMailField: FloatingLabeledTextField!
    @IBOutlet weak var loginPasswordField: FloatingLabeledTextField!
    @IBOutlet var loginErrorView: [UIView]!
    @IBOutlet var loginErrorLbl: [UILabel]!

    //Register
    @IBOutlet weak var registerFirstNameField: FloatingLabeledTextField!
    @IBOutlet weak var registerLastNameField: FloatingLabeledTextField!
    @IBOutlet weak var registerMailField: FloatingLabeledTextField!
    @IBOutlet weak var registerCountryCodeField: FloatingLabeledTextField!
    @IBOutlet weak var registerPhoneNumberField: FloatingLabeledTextField!
    @IBOutlet weak var registerPasswordField: FloatingLabeledTextField!
    @IBOutlet weak var registerConfirmPasswordField: FloatingLabeledTextField!
    @IBOutlet weak var pushNotificationSwitch: UISwitch!
    @IBOutlet var registerErrorView: [UIView]!
    @IBOutlet var registerErrorLbl: [UILabel]!
    var isFromCart:Bool = false
    var isFromOrder:Bool = false
    var myTotal:GrandTotal?
    @IBOutlet var guestButtonview: UIView!
    var currentView:LoginRegisterFlag = .login
    var screenSize: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Login Register Screen")
        //MARK: END MHIOS-1225
        backActionLink(backButton)
        switchView()
        pushNotificationSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        loginPasswordField.textContentType = .oneTimeCode
        registerPasswordField.textContentType = .oneTimeCode
        registerConfirmPasswordField.textContentType = .oneTimeCode
        
        screenSize = UIScreen.main.bounds
        
        setupProviderLoginView()
        if(self.isFromCart==true)
        {
            self.guestButtonview.isHidden = false
        }
        else
        {
            self.guestButtonview.isHidden = true
        }
    }

    @IBAction func continueAsGuest(_ sender: Any) {
        let nextVC = AppController.shared.addAddress
        nextVC.myTotal = self.myTotal
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func HomeLegacy(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.aboutUs
        vc.ScreenTitle = "LEGACY"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func FAQ(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.faqs
        vc.ScreenTitle = "FAQ's"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func privacyPolicy(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.shippingPolicy
        vc.ScreenTitle = "PRIVACY POLICY"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ReturnRefund(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.returnAndExchange
        vc.ScreenTitle = "ONLINE RETURNS"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func loginViewAction(_ sender: UIButton) {
        currentView = .login
        switchView()
    }
    @IBAction func registerVewAction(_ sender: UIButton) {
        currentView = .register
        switchView()
    }
    @IBAction func appleAction(_ sender: UIButton) {
        switch currentView{
        case .login:
            signInWithApple()
        case .register:
            signUpWithApple()
        }
    }
    @IBAction func googleAction(_ sender: UIButton) {
        switch currentView{
        case .login:
            signInWithGoogle()
        case .register:
            ///signUpWithGoogle()
            signInWithGoogle()
        }
    }

    @IBAction func termsAndConditions(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        //MARK: START MHIOS-1216
        vc.hidesBottomBarWhenPushed = true
        //MARK: END MHIOS-1216
        vc.urlString = appDelegate.termsAndCondition
        vc.ScreenTitle = "TERMS AND CONDITIONS"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if loginMailField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter an email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter an email address",type: "error")
            loginErrorLbl[0].text = "Please enter an email address"
            loginErrorView[0].isHidden = false
            loginMailField.setErrorTheme(errorAction: {
                self.loginErrorLbl[0].text = ""
                self.loginErrorView[0].isHidden = true
            })
        }else if loginPasswordField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your password","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your password",type: "error")
            loginErrorLbl[1].text = "Please enter your password"
            loginErrorView[1].isHidden = false
            loginPasswordField.setErrorTheme(errorAction: {
                self.loginErrorLbl[1].text = ""
                self.loginErrorView[1].isHidden = true
            })
        }else if loginPasswordField.text!.count < 6{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter 6 or more characters. Leading and trailing spaces will be ignored.","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter 6 or more characters. Leading and trailing spaces will be ignored.",type: "error")
            loginErrorLbl[1].text = "Please enter 6 or more characters. Leading and trailing spaces will be ignored."
            loginErrorView[1].isHidden = false
            loginPasswordField.setErrorTheme(errorAction: {
                self.loginErrorLbl[1].text = ""
                self.loginErrorView[1].isHidden = true
            })
        }else if !self.checkMailIdFormat(string: loginMailField.text ?? ""){
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid email address",type: "error")
            loginErrorLbl[0].text = "Invalid email address!"
            loginErrorView[0].isHidden = false
            loginMailField.setErrorTheme(errorAction: {
                self.loginErrorLbl[0].text = ""
                self.loginErrorView[0].isHidden = true
            })
        }else{
            print("SANTHOSH LOGIN STATUS IS AAAAAAAA : ")
            self.apiLogin(parameters: ["username": loginMailField.text ?? "", "password": loginPasswordField.text ?? ""]){ response in
                print("SANTHOSH LOGIN STATUS IS A : ")
                DispatchQueue.main.async {
                    UserData.shared.currentAuthKey = response
                    self.apiUser(){ response in
                        print("SANTHOSH LOGIN STATUS IS B : ")
                        DispatchQueue.main.async {
                            ///print(response)
                            print("SANTHOSH LOGIN STATUS IS C : ")
                            self.migrateGuestUserToLoginCart(response: response)
                            //MARK START{MHIOS-1181}
                            self.getWishlist()
                            //MARK END{MHIOS-1181}
//                            if(self.isFromCart==true)
//                            {
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                self.apiMigrateLoginCartToUser(parameters:  ["customerId":response.id , "storeId":appDelegate.storeID ])
//                                { response in
//
//                                    for i in appDelegate.wishList
//                                    {
//                                        self.apiAddToWishlist(id:i ){ responseData in
//                                            DispatchQueue.main.async {
//                                                print(responseData)
//
//                                            }
//                                        }
//                                    }
//                                }
//                            }
                            UserData.shared.isLoggedIn = true
                            UserData.shared.userId = "\(response.id)"
                            UserData.shared.firstName = response.firstname
                            UserData.shared.lastName = response.lastname
                            UserData.shared.emailId = response.email
                            UserData.shared.created_at = response.created_at
                            //self.navigationController?.popToRootViewController(animated: true)
                            self.toastView(toastMessage: "Login success !!!",type: "success")
                            let profile = Profile(email:UserData.shared.emailId , firstName: UserData.shared.firstName, lastName: UserData.shared.lastName)
                            KlaviyoSDK().set(profile: profile)
                            KlaviyoSDK().set(email: UserData.shared.emailId)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            if(appDelegate.devicePushToken != nil)
                            {
                                KlaviyoSDK().set(pushToken: appDelegate.devicePushToken!)
                            }
                            if(self.isFromOrder==true)
                            {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            else
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func registerAction(_ sender: UIButton) {
        if registerFirstNameField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your first name","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your first name",type: "error")
            registerErrorLbl[0].text = "Please enter your first name"
            registerErrorView[0].isHidden = false
            registerFirstNameField.setErrorTheme(errorAction: {
                self.registerErrorLbl[0].text = ""
                self.registerErrorView[0].isHidden = true
            })
        }else if registerLastNameField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your last name","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your last name",type: "error")
            registerErrorLbl[1].text = "Please enter your last name"
            registerErrorView[1].isHidden = false
            registerLastNameField.setErrorTheme(errorAction: {
                self.registerErrorLbl[1].text = ""
                self.registerErrorView[1].isHidden = true
            })
        }else if registerMailField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter an email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter an email address",type: "error")
            registerErrorLbl[2].text = "Please enter an email address"
            registerErrorView[2].isHidden = false
            registerMailField.setErrorTheme(errorAction: {
                self.registerErrorLbl[2].text = ""
                self.registerErrorView[2].isHidden = true
            })
        }else if registerPhoneNumberField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your mobile number","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your mobile number",type: "error")
            registerErrorLbl[3].text = "Please enter your mobile number"
            registerErrorView[3].isHidden = false
            registerPhoneNumberField.setErrorTheme(errorAction: {
                self.registerErrorLbl[3].text = ""
                self.registerErrorView[3].isHidden = true
            })
        }else if  7 > registerPhoneNumberField.text!.count {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid mobile number","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid mobile number",type: "error")
            registerErrorLbl[3].text = "Please enter a valid mobile number"
            registerErrorView[3].isHidden = false
            registerPhoneNumberField.setErrorTheme(errorAction: {
                self.registerErrorLbl[3].text = ""
                self.registerErrorView[3].isHidden = true
            })
        }else if registerPhoneNumberField.text!.count > 10 {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid mobile number","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid mobile number",type: "error")
            registerErrorLbl[3].text = "Please enter a valid mobile number"
            registerErrorView[3].isHidden = false
            registerPhoneNumberField.setErrorTheme(errorAction: {
                self.registerErrorLbl[3].text = ""
                self.registerErrorView[3].isHidden = true
            })
        }
        else if registerPasswordField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a password","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a password",type: "error")
            registerErrorLbl[4].text = "Please enter a password"
            registerErrorView[4].isHidden = false
            registerPasswordField.setErrorTheme(errorAction: {
                self.registerErrorLbl[4].text = ""
                self.registerErrorView[4].isHidden = true
            })
        }else if registerConfirmPasswordField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter confirm password","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter confirm password",type: "error")
            registerErrorLbl[5].text = "Please enter confirm password"
            registerErrorView[5].isHidden = false
            registerConfirmPasswordField.setErrorTheme(errorAction: {
                self.registerErrorLbl[5].text = ""
                self.registerErrorView[5].isHidden = true
            })
        }else if !self.checkMailIdFormat(string: registerMailField.text ?? ""){
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid email address",type: "error")
            registerErrorLbl[2].text = "Please enter a valid email address"
            registerErrorView[2].isHidden = false
            registerMailField.setErrorTheme(errorAction: {
                self.registerErrorLbl[2].text = ""
                self.registerErrorView[2].isHidden = true
            })
        }else if registerPasswordField.text != registerConfirmPasswordField.text{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Confirm password is not matching","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Confirm password is not matching",type: "error")
            registerErrorLbl[5].text = "Confirm password is not matching"
            registerErrorView[5].isHidden = false
            registerConfirmPasswordField.setErrorTheme(errorAction: {
                self.registerErrorLbl[5].text = ""
                self.registerErrorView[5].isHidden = true
            })
        }else if self.isValidPassword(password: registerPasswordField.text ?? "")==false{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Password must be at least 8 characters long and include at least three of the following: lowercase letters, uppercase letters, digits, and special characters. Leading and trailing spaces will be ignored.","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Password must be at least 8 characters long and include at least three of the following: lowercase letters, uppercase letters, digits, and special characters. Leading and trailing spaces will be ignored.",type: "error")
            registerErrorLbl[4].text = "Password must be at least 8 characters long and include at least three of the following: lowercase, uppercase, digits, and special characters. Leading and trailing spaces will be ignored."
            registerErrorView[4].isHidden = false
            registerPasswordField.setErrorTheme(errorAction: {
                self.registerErrorLbl[4].text = ""
                self.registerErrorView[4].isHidden = true
            })
        }
        else{
            self.apiRegister(parameters: ["customer":
                                            ["email": registerMailField.text ?? "", "firstname": registerFirstNameField.text ?? "", "lastname": registerLastNameField.text ?? "","extension_attributes":
                                                ["device_custom_type": "some value"]],
                                          "password": registerPasswordField.text ?? "",
                                          ]){ response in
                DispatchQueue.main.async {
                    print(response)
                    self.apiLogin(parameters: ["username": self.registerMailField.text ?? "", "password": self.registerPasswordField.text ?? ""]){ response in
                        DispatchQueue.main.async {
                            UserData.shared.currentAuthKey = response
                            self.apiUser(){ response in
                                DispatchQueue.main.async {
                                    print(response)
                                    // added to register for regitration as well - start
                                    self.migrateGuestUserToLoginCart(response: response)
                                    //MARK START{MHIOS-1181}
                                    self.getWishlist()
                                    //MARK END{MHIOS-1181}
                                    // end
                                    //MARK START{MHIOS-1181}
                                    self.getWishlist()
                                    //MARK END{MHIOS-1181}
                                    UserData.shared.isLoggedIn = true
                                    UserData.shared.userId = "\(response.id)"
                                    UserData.shared.firstName = response.firstname
                                    UserData.shared.lastName = response.lastname
                                    UserData.shared.emailId = response.email
                                    UserData.shared.created_at = response.created_at
                                    let profile = Profile(email:UserData.shared.emailId , firstName: UserData.shared.firstName, lastName: UserData.shared.lastName)
                                    KlaviyoSDK().set(profile: profile)
                                    KlaviyoSDK().set(email: UserData.shared.emailId)
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    if(appDelegate.devicePushToken != nil)
                                    {
                                        KlaviyoSDK().set(pushToken: appDelegate.devicePushToken!)
                                    }
                                    //self.navigationController?.popToRootViewController(animated: true)
                                    self.toastView(toastMessage: "Registration success !!!",type: "success")
                                    
                                    if(self.isFromCart==true)
                                    {
                                        self.tabBarController?.selectedIndex = 3
                                    }
                                    else
                                    {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    ///self.navigationController?.popViewController(animated: true)
                                   // self.navigationController?.pushViewController(AppController.shared.myProfile, animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Sample list of mobile numbers
    let mobileNumbers = [
        "+14155555555",  // USA
        "+442071234567",  // UK
        "+49123456789",  // Germany
        "+33123456789",  // France
        "+611234567890",  // Australia
    ]


    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
     let forgotVC = AppController.shared.forgotPassword
        self.navigationController?.pushViewController(forgotVC, animated: true)
        
        // Define the country code you want to count (e.g., USA)
       // let desiredCountryCode = "+1"

        // Create a regular expression pattern to match the country code
       // let countryCodePattern = "^\\Q\(desiredCountryCode)\\E"
//
        // Create an NSPredicate to filter numbers with the desired country code
      //  let predicate = NSPredicate(format: "SELF MATCHES %@", countryCodePattern)

        // Use the predicate to filter mobile numbers
       // let filteredNumbers = mobileNumbers.filter { predicate.evaluate(with: $0) }

        // Count the filtered numbers
       // let count = filteredNumbers.count

       // print("Number of mobile numbers with country code \(desiredCountryCode): \(count)")
        
    }

    @objc func signInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func switchView(){
        self.view.endEditing(true)
        switch currentView{
        case .login:
            loginView.isHidden = false
            registerView.isHidden = true
            loginViewButton.setEnabled()
            registerViewButton.setDisabled()
            let boldAttributes: [NSAttributedString.Key: Any] = [
               .font: AppFonts.LatoFont.Bold(15),
               .foregroundColor: AppColors.shared.Color_black_000000
            ]
            let regularAttributes: [NSAttributedString.Key: Any] = [
               .font: AppFonts.LatoFont.Regular(15),
               .foregroundColor: AppColors.shared.Color_black_000000
            ]
            var attributeString = NSMutableAttributedString(
               string: "Hey, ",
               attributes: regularAttributes)
            var attributeString1 = NSMutableAttributedString(
               string: "Welcome",
               attributes: boldAttributes)
             //attributeString.append(attributeString1)
            welcomeLbl.attributedText = attributeString1
            actionTypeLbl1.text = "Log in to continue."
            actionTypeLbl2.text = "Or Login With Email To Continue"
            registerFirstNameField.text = ""
            registerLastNameField.text = ""
            registerMailField.text = ""
            registerCountryCodeField.text = "+971"
            registerPhoneNumberField.text = ""
            registerPasswordField.text = ""
            registerConfirmPasswordField.text = ""
        case .register:
            loginView.isHidden = true
            registerView.isHidden = false
            registerViewButton.setEnabled()
            loginViewButton.setDisabled()
            let boldAttributes: [NSAttributedString.Key: Any] = [
               .font: AppFonts.LatoFont.Bold(15),
               .foregroundColor: AppColors.shared.Color_black_000000
            ]
            let attributeString = NSMutableAttributedString(
               string: "Hello",
               attributes: boldAttributes)
            welcomeLbl.attributedText = attributeString
            actionTypeLbl1.text = "Create an account."
            actionTypeLbl2.text = "Or Register With Email To Continue"
            loginMailField.text = ""
            loginPasswordField.text = ""
        }
    }

    func signInWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(
            withPresenting:self) { signInResult, error in
              guard let result = signInResult else {
                // Inspect error
                return
              }
              // If sign in succeeded, display the app's main content View.
                self.apiGoogleLogin(parameters: ["email":result.user.profile?.email ?? "", "firstname":Name(fullName: result.user.profile?.name ?? "").first, "lastname":Name(fullName: result.user.profile?.name ?? "").last, "identifier":result.user.userID ?? "", "type":"Google","device":"IOS","accessToken" :(result.user.accessToken.tokenString ?? "") as String]){ response in
                    DispatchQueue.main.async {
                        UserData.shared.currentAuthKey = response
                        self.apiUser(){ response in
                            DispatchQueue.main.async {
                                print("GOOGLE LOGIN ")
                                print(response)
                                self.migrateGuestUserToLoginCart(response: response)
                                //MARK START{MHIOS-1181}
                                self.getWishlist()
                                //MARK END{MHIOS-1181}
//                                if(self.isFromCart==true)
//                                {
//                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                    //appDelegate.savePushcredentials(userId: UserData.shared.userId, token: appDelegate.deviceTOKEN)
//                                    self.fcmTokenUpdate()
//                                    self.apiMigrateLoginCartToUser(parameters:  ["customerId":response.id , "storeId":appDelegate.storeID ])
//                                    { response in
//                                        for i in appDelegate.wishList
//                                        {
//                                            self.apiAddToWishlist(id:i ){ responseData in
//                                                DispatchQueue.main.async {
//                                                    print(responseData)
//
//                                                }
//                                            }
//                                        }
//                                        print("CART API CALLING ")
//                                        print(response)
//                                    }
//                                }
//                                else
//                                {
//                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                    //appDelegate.savePushcredentials(userId: UserData.shared.userId, token: appDelegate.deviceTOKEN)
//                                    self.fcmTokenUpdate()
//                                    if(appDelegate.wishList.count>0)
//                                    {
//                                        for i in appDelegate.wishList
//                                        {
//                                            self.apiAddToWishlist(id:i ){ responseData in
//                                                DispatchQueue.main.async {
//                                                    print(responseData)
//
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
                                UserData.shared.isLoggedIn = true
                                UserData.shared.userId = "\(response.id)"
                                UserData.shared.firstName = response.firstname
                                UserData.shared.lastName = response.lastname
                                UserData.shared.emailId = response.email
                                UserData.shared.created_at = response.created_at
                                self.toastView(toastMessage: "Login success !!!",type: "success")
                                let profile = Profile(email:UserData.shared.emailId , firstName: UserData.shared.firstName, lastName: UserData.shared.lastName)
                                KlaviyoSDK().set(profile: profile)
                                KlaviyoSDK().set(email: UserData.shared.emailId)
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                if(appDelegate.devicePushToken != nil)
                                {
                                    KlaviyoSDK().set(pushToken: appDelegate.devicePushToken!)
                                }
                                if(self.isFromOrder==true)
                                {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                else
                                {
                                    self.navigationController?.popViewController(animated: true)
                                   // self.navigationController?.pushViewController(AppController.shared.myProfile, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    
    func fcmTokenUpdate(){
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
              let token = Messaging.messaging().fcmToken
              print("SANTHOSH FCM TOKEN : ",token)
              UserDefaults.standard.set(token, forKey: "fcm_token")
             
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              appDelegate.savePushcredentials(userId: UserData.shared.userId, token: token!)
              //self.navigationController?.view.makeToast(token!, duration: 3.0, position: .bottom)
          }
        }
    }

    func signUpWithApple(){

    }

    func signUpWithGoogle(){

    }
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .continue, style: .whiteOutline)
        
        authorizationButton.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        authorizationButton.backgroundColor = UIColor.white
        self.appleView.addSubview(authorizationButton)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorizationButton.centerYAnchor.constraint(equalTo: self.btnApple.centerYAnchor),
            authorizationButton.widthAnchor.constraint(equalToConstant: self.screenSize!.width-60),
            authorizationButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          let maxLength = 1
          let currentString = (textField.text ?? "") as NSString
          let newString = currentString.replacingCharacters(in: range, with: string)
        print("\(textField.tag)")
        if(textField.tag == 104)
        {
            return newString.count <= 10
        }
        return true
      }
      override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          let nextTag = textField.tag + 1

          if let nextResponder = self.view?.viewWithTag(nextTag) {
              nextResponder.becomeFirstResponder()
          } else {
              textField.resignFirstResponder()
          }
         
          return true
      }
      func isValidPhone(phone: String) -> Bool {
              let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
              let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
              return phoneTest.evaluate(with: phone)
      }
}

extension LoginRegisterVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       print("error",error)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            print("SANTHOSH")
            print(credentials)
            print("santhosh : \(String(describing: credentials.authorizationCode))")
            let tokenstring = NSString(data:credentials.authorizationCode! , encoding: NSUTF8StringEncoding)
            print("applecredential",tokenstring)
            
            let parameters: [String:Any] = ["email":credentials.email ?? "", "firstname": credentials.fullName?.givenName ?? "", "lastname": credentials.fullName?.familyName ?? "", "identifier":credentials.user , "type":"Apple","device":"IOS","accessToken" :tokenstring ?? ""]
            
            print(parameters)
          
            self.apiGoogleLogin(parameters: parameters){ response in
                DispatchQueue.main.async {
                    UserData.shared.currentAuthKey = response
                    self.apiUser(){ response in
                        DispatchQueue.main.async {
                           
                            print(response)
                            self.migrateGuestUserToLoginCart(response: response)
                            //MARK START{MHIOS-1181}
                            self.getWishlist()
                            //MARK END{MHIOS-1181}
//                            if(self.isFromCart==true)
//                            {
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
////                                appDelegate.savePushcredentials(userId: UserData.shared.userId, token: appDelegate.deviceTOKEN)
//                                self.fcmTokenUpdate()
//                                self.apiMigrateLoginCartToUser(parameters:  ["customerId":response.id , "storeId":appDelegate.storeID ])
//                                { response in
//                                    for i in appDelegate.wishList
//                                    {
//                                        self.apiAddToWishlist(id:i ){ responseData in
//                                            DispatchQueue.main.async {
//                                                print(responseData)
//
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            else
//                            {
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                //appDelegate.savePushcredentials(userId: UserData.shared.userId, token: appDelegate.deviceTOKEN)
//                                self.fcmTokenUpdate()
//                                if(appDelegate.wishList.count>0)
//                                {
//                                    for i in appDelegate.wishList
//                                    {
//                                        self.apiAddToWishlist(id:i ){ responseData in
//                                            DispatchQueue.main.async {
//                                                print(responseData)
//
//                                            }
//                                        }
//                                    }
//                                }
//                            }
                            UserData.shared.isLoggedIn = true
                            UserData.shared.userId = "\(response.id)"
                            UserData.shared.firstName = response.firstname
                            UserData.shared.lastName = response.lastname
                            UserData.shared.emailId = response.email
                            UserData.shared.created_at = response.created_at
                            self.toastView(toastMessage: "Login success !!!",type: "success")
                            let profile = Profile(email:UserData.shared.emailId , firstName: UserData.shared.firstName, lastName: UserData.shared.lastName)
                            KlaviyoSDK().set(profile: profile)
                            KlaviyoSDK().set(email: UserData.shared.emailId)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            if(appDelegate.devicePushToken != nil)
                            {
                                KlaviyoSDK().set(pushToken: appDelegate.devicePushToken!)
                            }
                            if(self.isFromCart==true)
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
//            let vc = SuccessAlertViewController()
//            self.present(vc: vc, transStyle: .crossDissolve, presentationStyle: .overFullScreen)
        case let credentials as ASPasswordCredential:
            print(credentials.password)
            
        default:
            print("error")
        }
    }
    
    
    //MARK START{MHIOS-1029}
    func migrateGuestUserToLoginCart(response:UserModel)
    {
        self.fcmTokenUpdate()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.guestCartId != "" && UserData.shared.cartCount>0 )
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.apiMigrateLoginCartToUser(parameters:  ["customerId":response.id , "storeId":appDelegate.storeID ])
            { resp in
                
                if(UserData.shared.wishListIdArray.count>0)
                {
                    self.migrateWishlistToLoginWishlist(response:response)
                }
            }
        }
        else
        {
            if(UserData.shared.wishListIdArray.count>0)
            {
                migrateWishlistToLoginWishlist(response:response)
            }
        }
    }
    
    func migrateWishlistToLoginWishlist(response:UserModel)
    {
        print("SANTHOSH WISHLIST MERGE START OK")
        self.apiMigrateWishlist(id: "\(response.id)"){ responseData in
            DispatchQueue.main.async {
                print("SANTHOSH WISHLIST MERGE WORK OK")
                print(responseData)
                UserData.shared.wishListIdArray.removeAll()
                //MARK START{MHIOS-1181}
                self.getWishlist()
                //MARK END{MHIOS-1181}
            }
        }
    }
    //MARK END{MHIOS-1029}

    //MARK START{MHIOS-1181}
    func getWishlist(){
        self.apiWishlist(){ response in
            DispatchQueue.main.async {
                print(response)
                for w in response
                {
                    //MARK START{MHIOS-1181}
                    UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int(w.productId!) ?? 0,sku: w.productSku!))
                    //MARK END{MHIOS-1181}
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.wishList.append(w.productId! )
                }
            }
        }
    }
    //MARK END{MHIOS-1181}
    
    @IBAction func countyCodePressed(_ sender: Any) {
        let countryCodes = CountryCodes.values()
        var countryText:[String] = []
       /* for item in countryCodes ?? []{
            countryText.append("+\(item.dialCode)" ?? "")
        }*/
        countryText.append("+971")
        dropDown.dataSource = countryText//4
        dropDown.direction = .bottom
        dropDown.anchorView = sender as! any AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
               // (sender as! UIButton).setTitle("Quantity: \(item)", for: .normal) //9
                self?.registerCountryCodeField.text = item
               
                self?.registerCountryCodeField.setDirectText()
                
            }
    }
//    func isValidPhone(phone: String) -> Bool {
//            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
//            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//            return phoneTest.evaluate(with: phone)
//        }
}
extension LoginRegisterVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

