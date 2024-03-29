//
//  MyProfileVC.swift
//  Marina Home
//
//  Created by Codilar on 17/04/23.
//
//MARK START{MHIOS-403}
//the email Text Field disabled in the UI
//MARK END{MHIOS-403}
import UIKit
import GoogleSignIn
import Alamofire
class MyProfileVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstNameField: FloatingLabeledTextField!
    @IBOutlet weak var lastNameField: FloatingLabeledTextField!
    @IBOutlet weak var mailField: FloatingLabeledTextField!
    @IBOutlet weak var updateDetailsButton: AppBorderButton!
    @IBOutlet weak var newsletterSubscriptionSwitch: UISwitch!
    @IBOutlet weak var addressListingTable: UITableView!
    @IBOutlet weak var addressListingTableHeight: NSLayoutConstraint!
    @IBOutlet var loginErrorView: [UIView]!
    @IBOutlet var loginErrorLbl: [UILabel]!
    @IBOutlet weak var mainScrollView: UIScrollView!
    var isfromLogin:Bool = false
    var address:[Addresses] = []
    var guestCartId = ""
    var listHeight = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.guestCartId = appDelegate.guestCartId
        backActionLink(backButton)
        newsletterSubscriptionSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        firstNameField.text = UserData.shared.firstName
        lastNameField.text = UserData.shared.lastName
        mailField.text = UserData.shared.emailId
        firstNameField.setDirectText()
        lastNameField.setDirectText()
        mailField.setDirectText()
        firstNameField.addTarget(self, action: #selector(checkPersonalInfoChanges), for: .editingChanged)
        lastNameField.addTarget(self, action: #selector(checkPersonalInfoChanges), for: .editingChanged)
        mailField.addTarget(self, action: #selector(checkPersonalInfoChanges), for: .editingChanged)
        self.addressListingTable.delegate = self
        self.addressListingTable.dataSource = self
        self.addressListingTable.register(UINib(nibName: "AddressListTVC", bundle: nil), forCellReuseIdentifier: "AddressListTVC_id")
        checkPersonalInfoChanges()
        getCartCount()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        //listHeight = 0
//        self.apiUserDetails(){ response in
//            DispatchQueue.main.async {
//                print(response)
//                if(response.extension_attributes?.is_subscribed == true)
//                {
//                    self.newsletterSubscriptionSwitch.isOn = true
//                }
//                self.address = response.addresses ?? []
//                self.addressListingTableHeight.constant = CGFloat((self.address.count*190))
//                self.addressListingTable.reloadData()
//                //self.addressListingTableHeight.constant = CGFloat((self.address.count*190))
//                
//            }
//            //self.addressListingTableHeight.constant = CGFloat(self.listHeight)
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        //MARK START{MHIOS-962}
        getUserAddress()
        //MARK END{MHIOS-962}
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Profile Screen")
        //MARK: END MHIOS-1225
    }
    //MARK START{MHIOS-962}
    func getUserAddress()
    {
        self.apiUserDetails(){ response in
            DispatchQueue.main.async {
                print(response)
                if(response.extension_attributes?.is_subscribed == true)
                {
                    self.newsletterSubscriptionSwitch.isOn = true
                }
                self.address = response.addresses ?? []
                self.updateUI()
            }
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Profile Screen")
        //MARK: END MHIOS-1225
    }
    //MARK END{MHIOS-962}
    override func viewWillDisappear(_ animated: Bool) {
        self.hideActivityIndicator(uiView: self.view)
    }

    @IBAction func updateDetailsAction(_ sender: UIButton) {
        if firstNameField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your first name","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your first name",type: "error")
            loginErrorLbl[0].text = "Please enter your first name"
            loginErrorView[0].isHidden = false
            firstNameField.setErrorTheme(errorAction: {
                self.loginErrorLbl[0].text = ""
                self.loginErrorView[0].isHidden = true
            })
        }else if lastNameField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your last name","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your last name",type: "error")
            loginErrorLbl[1].text = "Please enter your last name"
            loginErrorView[1].isHidden = false
            lastNameField.setErrorTheme(errorAction: {
                self.loginErrorLbl[1].text = ""
                self.loginErrorView[1].isHidden = true
            })
        }else if mailField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter an email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter an email address",type: "error")
            loginErrorLbl[2].text = "Please enter an email address"
            loginErrorView[2].isHidden = false
            mailField.setErrorTheme(errorAction: {
                self.loginErrorLbl[2].text = ""
                self.loginErrorView[2].isHidden = true
            })
        }else if !self.checkMailIdFormat(string: mailField.text ?? ""){
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid email address",type: "error")
            loginErrorLbl[2].text = "Please enter a valid email address"
            loginErrorView[2].isHidden = false
            mailField.setErrorTheme(errorAction: {
                self.loginErrorLbl[2].text = ""
                self.loginErrorView[2].isHidden = true
            })
        }else{
            //MARK START{MHIOS-403}
            let parameter:Parameters = ["customer":
                                            [
                                             "email": mailField.text ?? "",
                                             "firstname":firstNameField.text ?? "",
                                             // MARK: START MHIOS-1112
                                             "lastname":lastNameField.text?.trimTrailingWhitespace() ?? ""
                                             // MARK: END MHIOS-1112
                                             ]]
            //MARK END{MHIOS-403}
            self.apiUpdateUser(parameters: parameter){ response in
                DispatchQueue.main.async {
                    print(response)
                    UserData.shared.firstName = self.firstNameField.text ?? ""
                    UserData.shared.lastName = self.lastNameField.text ?? ""
                    UserData.shared.emailId = self.mailField.text ?? ""
                    self.toastView(toastMessage:"Profile updated successfully!",type: "success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }

    @IBAction func newsLetterChanged(_ sender: Any) {
      if(  self.newsletterSubscriptionSwitch.isOn == true)
        {
            let parameter:Parameters = [ "customer": [ "extension_attributes": [ "is_subscribed": true ] ] ]
            self.apiSubscribeNewsLetter(parameters: parameter){ response in
                DispatchQueue.main.async {
                    print(response)
                    
                }
            }
        }
        else
        {
            let parameter:Parameters = [ "customer": [ "extension_attributes": [ "is_subscribed": false ] ] ]
            self.apiSubscribeNewsLetter(parameters: parameter){ response in
                DispatchQueue.main.async {
                    print(response)
                    
                }
            }
        }
    }
    @IBAction func addAddressAction(_ sender: UIButton) {
        let nextVC = AppController.shared.addAddress
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func ChangePasswordAction(_ sender: UIButton) {
        self.tabBarController?.hideTabBar(isHidden: false)
        let controller = AppController.shared.changepassword
        addChild(controller)
        self.view.addSubview(controller.view)
        controller.view.frame = self.view.frame
        controller.didMove(toParent: self)
       
    }
    @IBAction func addPaymentCardsAction(_ sender: UIButton) {
        let nextVC = AppController.shared.paymentCards
        //nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
       
    }
    @IBAction func deleteAction(_ sender: UIButton) {
        self.showAlert(message: "Do you want to delete this account?", hasleftAction: true,rightactionTitle: "Yes", rightAction: {
//            self.apiAdminToken(parameters: ["username":"sandesh","password":"sandesh1234"]){ response in
//                DispatchQueue.main.async {
//                    self.apiRevokeApple(Token: ""){ response in
//
//                    }
//
//                }
            self.apiDeleteAccount(adminToken: AppInfo.shared.integrationToken){ response in
                print(response)
                DispatchQueue.main.async {
                    UserData.shared.ClearAllData()
                    UserData.shared.isLoggedIn = false
                    GIDSignIn.sharedInstance.signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }, leftAction: {})
    }

    @IBAction func logoutAction(_ sender: UIButton) {
        self.showAlert(message: "Do you want to logout?", hasleftAction: true,rightactionTitle: "Yes", rightAction: {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.wishList.removeAll()
            
            UserData.shared.ClearAllData()
            UserData.shared.isLoggedIn = false
            UserData.shared.recentOpenProduct = []
            appDelegate.guestCartId = ""
            UserData.shared.cartCount = 0
            self.tabBarController?.tabBar.items?.last?.badgeValue = nil
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: "GuestCart")
            GIDSignIn.sharedInstance.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }, leftAction: {})
    }

    @objc func checkPersonalInfoChanges(){
        let isChanged = firstNameField.text ?? "" != UserData.shared.firstName || lastNameField.text ?? "" != UserData.shared.lastName || mailField.text ?? "" != UserData.shared.emailId
        updateDetailsButton.isEnabled = isChanged
        updateDetailsButton.alpha = isChanged ? 1 : 0.5
    }

    @objc func edit(_ sender: UIButton) {
        let nextVC = AppController.shared.addAddress
        nextVC.SelectedAdress = self.address[sender.tag]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    @objc func removeAdress(_ sender: UIButton) {
        self.showAlert(message: "Do you want to delete this address?", hasleftAction: true,rightactionTitle: "Yes", rightAction: {
            self.apiDeleteAddress(adressId: self.address[sender.tag].id ?? 0,adminToken: AppInfo.shared.integrationToken){ response in
                DispatchQueue.main.async { [self] in
                    address.remove(at: sender.tag)
                    
//                    self.addressListingTableHeight.constant = CGFloat((self.address.count*190))
//                    self.addressListingTable.reloadData()
                    self.hideActivityIndicator(uiView: self.view)
                    //MARK START{MHIOS-962}
                    //updateUI()
                    getUserAddress()
                    //MARK END{MHIOS-962}
                }
            }
//            self.apiAdminToken(parameters: ["username":"sandesh","password":"sandesh1234"]){ response in
//                DispatchQueue.main.async {
//                    self.apiDeleteAddress(adressId: self.address[sender.tag].id ?? 0,adminToken: response){ response in
//                        DispatchQueue.main.async { [self] in
//                            address.remove(at: sender.tag)
//                            self.addressListingTableHeight.constant = CGFloat((self.address.count*180))
//                            self.addressListingTable.reloadData()
//                            self.hideActivityIndicator(uiView: self.view)
//                        }
//                    }
//                }
//            }
           
        }, leftAction: {})
        
       
    }
    // MARK: - TABLEVIEW
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//       return 190
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lineCount = makeAddressText(addresse: address[indexPath.item])
        let cellHeight = (lineCount*16)+151
        return CGFloat(cellHeight)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return address.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListTVC_id", for: indexPath) as? AddressListTVC else { return UITableViewCell()}
        let cellData = address[indexPath.item]
        cell.fullNameLbl.text = "\(cellData.firstname ?? "") \(cellData.lastname ?? "")"
        var street = ""
        let address2 = (cellData.region?.region ?? "") + " " + (cellData.postcode ?? "")
        for i in cellData.street!{
            street = street + i + " "
        }
        cell.addressLbl.text = "\(street) \n\(address2)"
        cell.isDefaultLbl.isHidden = !((cellData.default_shipping ?? false) || (cellData.default_billing ?? false))
        cell.editButton.tag = indexPath.item
        cell.editButton.addTarget(self, action: #selector(self.edit(_:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(self.removeAdress(_:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateUI()
    {
        self.listHeight = 0
        for i in 0 ..< self.address.count {
            let cellData = self.address[i]
            let lineCount = makeAddressText(addresse: cellData)
            let cellHeight = (lineCount*16)+151
            self.listHeight = self.listHeight+cellHeight
        }
        self.addressListingTable.reloadData()
        self.addressListingTableHeight.constant = CGFloat(self.listHeight)
    }
    
    func getCartCount()
    {
        if UserData.shared.isLoggedIn{
            self.apiCreateCart(){ response in
                DispatchQueue.main.async {
                    print("SANTHOSH response AAAA")
                    print(response)
                    self.apiCarts(){ response in
                        DispatchQueue.main.async {
                            print(response)
                            let mycart = response as Cart
                            let cartCountIs = mycart.itemsQty!
                            UserData.shared.cartCount = cartCountIs
                            let cartQuoteId = mycart.id
                            UserData.shared.cartQuoteId = cartQuoteId
                            if cartCountIs == 0
                            {
                                self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                            }
                            else
                            {
                                self.tabBarController?.tabBar.items?.last?.badgeValue = "\(cartCountIs)"
                            }
                        }
                    }
                }
            }
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if(appDelegate.guestCartId == "")
            {
                print("SANTHOSH apiCreateGuestCart : Come")
                self.apiCreateGuestCart(){ response in
                    DispatchQueue.main.async {
                        print("SANTHOSH apiCreateGuestCart : OK")
                        print(response)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.guestCartId = response
                        self.guestCartId = response
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(response, forKey: "GuestCart")
                        print("SANTHOSH apiGuestCarts : Come")
                        self.apiGuestCarts(){ response in
                            appDelegate.storeID = response.storeID ?? 0
                            DispatchQueue.main.async {
                                print("SANTHOSH apiGuestCarts : OK")
                                print(response)
                                let mycart = response as Cart
                                let cartCountIs = mycart.itemsQty!
                                UserData.shared.cartCount = cartCountIs
                                if cartCountIs == 0
                                {
                                    self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                                }
                                else
                                {
                                    self.tabBarController?.tabBar.items?.last?.badgeValue = "\(cartCountIs)"
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                self.guestCartId =  appDelegate.guestCartId
                self.apiGuestCarts(){ response in
                    appDelegate.storeID = response.storeID ?? 0
                    DispatchQueue.main.async {
                        print(response)
                        let mycart = response as Cart
                        let cartCountIs = mycart.itemsQty!
                        UserData.shared.cartCount = cartCountIs
                        if cartCountIs == 0
                        {
                            self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                        }
                        else
                        {
                            self.tabBarController?.tabBar.items?.last?.badgeValue = "\(cartCountIs)"
                        }
                        
                    }
                }
            }
            
        }
    }
   
}

