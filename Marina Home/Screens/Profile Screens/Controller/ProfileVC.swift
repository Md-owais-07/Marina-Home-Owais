//
//  ProfileVC.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import UIKit
import UserNotifications
import StoreKit
import Alamofire
import KlaviyoSwift
import DropDown

class ProfileVC: AppUIViewController,UIGestureRecognizerDelegate {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var pushNotificationSwitch: UISwitch!
    @IBOutlet var viewOrder: UIView!
    @IBOutlet weak var loginUserLbl: UILabel!
    @IBOutlet weak var wishlistView: UIView!
    @IBOutlet var viewOrderBorder: UIView!
    @IBOutlet var viewOrderBorder1: UIView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    
    let dropDown = DropDown()
    var countries: [(name: String, image: UIImage)] = []
    
    @IBAction func dropDownButton(_ sender: Any) {
        let countryNames = countries.map { $0.name }
        dropDown.dataSource = countryNames
        dropDown.show()
    }
    
    func configureDropDown() {
        dropDown.direction = .top
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        dropDown.anchorView = countryNameLabel
        dropDown.bottomOffset = CGPoint(x: 0, y: countryNameLabel.bounds.height)
        dropDown.topOffset = CGPoint(x: 0, y: dropDown.anchorView?.plainView.bounds.height ?? 0)
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.updateSelectedCountry(at: index)
            
        }
        dropDown.cellNib = UINib(nibName: "MyImagecell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyImagecell else { return }
            cell.logoImageView.image = self.countries[index].image
        }
    }
    
    func loadCountries() {
        countries = [("India", UIImage(named: "India") ?? UIImage()),
                     ("Japan", UIImage(named: "Japan") ?? UIImage()),
                     ("China", UIImage(named: "China-png") ?? UIImage())]
    }
    
    func updateSelectedCountry(at index: Int) {
        let selectedCountry = countries[index]
        countryNameLabel.text = selectedCountry.name
        countryImage.image = selectedCountry.image
    }
    
    
    //MARK: START MHIOS-967
    @IBOutlet weak var iconNotification: UIView!
    var notificationList : [NotificationModel] = [NotificationModel]()
    //MARK: END MHIOS-967
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        pushNotificationSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        pushNotificationSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        self.pushNotificationSwitch.isOn = UserData.shared.isPushEnable == 1 ? true : false
        
        configureDropDown()
        loadCountries()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //MARK: START MHIOS-1213&1314
        NotificationCenter.default.addObserver(self, selector: #selector(self.appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        //MARK: END MHIOS-1213&1314
        checkNotificationStatus()
        //MARK START{MHIOS-1029}
        wishlistView.isHidden = false //!UserData.shared.isLoggedIn
        //MARK END{MHIOS-1029}
        loginUserLbl.text = UserData.shared.isLoggedIn ? "\(UserData.shared.firstName) \(UserData.shared.lastName)".capitalized : "Log In/Register"
        lblTitle.text = UserData.shared.isLoggedIn ? "Hello, \(UserData.shared.firstName.capitalized) \(UserData.shared.lastName)".capitalized : "PROFILE"
        //MARK START{MHIOS-1029}
        if( UserData.shared.isLoggedIn==true)
         {
            self.viewOrder.isHidden = false
            self.viewOrderBorder.isHidden = false
            self.viewOrderBorder1.isHidden = false
        }
        else
        {
             self.viewOrder.isHidden = false
             self.viewOrderBorder.isHidden = false
            //MARK START{MHIOS-1029}
             self.viewOrderBorder1.isHidden = false
            //MARK END{MHIOS-1029}
        }
        //MARK: START MHIOS-967
        getNotification()
        //MARK: END MHIOS-967
    }
    //MARK: START MHIOS-967
   func getNotification()
    {
        self.getAllNotification(){ response in
            DispatchQueue.main.async {
                
                self.notificationList = response
                
                for notification in self.notificationList
                {
                    if notification.hasRead == 0
                    {
                        self.iconNotification.isHidden = false
                        break
                    }
                }
                
            }
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("My Profile Screen")
        //MARK: END MHIOS-1225
    }
    //MARK: END MHIOS-967
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //MARK START{MHIOS-1029}
        wishlistView.isHidden = false //!UserData.shared.isLoggedIn
        //MARK END{MHIOS-1029}
        loginUserLbl.text = UserData.shared.isLoggedIn ? "\(UserData.shared.firstName) \(UserData.shared.lastName)".capitalized : "Log In/Register"
        lblTitle.text = UserData.shared.isLoggedIn ? "Hello, \(UserData.shared.firstName.capitalized) \(UserData.shared.lastName)".capitalized : "PROFILE"
        //MARK START{MHIOS-1029}
        if( UserData.shared.isLoggedIn==true)
         {
            self.viewOrder.isHidden = false
            self.viewOrderBorder.isHidden = false
            self.viewOrderBorder1.isHidden = false
        }
        else
        {
             self.viewOrder.isHidden = false
             self.viewOrderBorder.isHidden = false
            //MARK START{MHIOS-1029}
             self.viewOrderBorder1.isHidden = false
            //MARK END{MHIOS-1029}
        }
        //MARK END{MHIOS-1029}
    
    }
    
    @objc func switchValueDidChange(sender:UISwitch!)
    {
        
        self.showAlert(message: "Are you ok to change preference?", hasleftAction: true,rightactionTitle: "Submit", rightAction: {
        
            //MARK: START MHIOS-1213&1314
            UNUserNotificationCenter.current().getNotificationSettings { [self] settings in
                
            let status = settings.authorizationStatus
            
            if status == .notDetermined
            {
                DispatchQueue.main.async {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.pushPermissionReceived(notification:)), name: Notification.Name("PushPermissionReceive"), object: nil)
                    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.openPushPopup()
                }
            }
            else
            {
                
                DispatchQueue.main.async {
                    UserData.shared.isPushEnable = sender.isOn == true ? 1 : 0
                    Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
                }
            }
                    
         }
        //MARK: END MHIOS-1213&1314
            
        }, leftAction: {
            self.pushNotificationSwitch.isOn = !self.pushNotificationSwitch.isOn
        })
    }
    
    @objc func appWillEnterForeground() {
        //pushNotificationSwitch.isOn = checkNotificationStatus()
    }
    //MARK: START MHIOS-1213&1314
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func pushPermissionReceived(notification: Notification) {
       
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushPermissionReceive"), object: nil)
        checkNotificationStatus()
        
    }
    
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notifications are authorized.")
                UserData.shared.isPushEnable = 1
                Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
                break
            case .denied:
                print("Notifications are denied.")
                UserData.shared.isPushEnable = 0
                Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
                break
            case .notDetermined:
                print("Notification status is not determined.")
                UserData.shared.isPushEnable = 0
                Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
                break
            case .provisional:
                print("Notifications are provisional.")
                UserData.shared.isPushEnable = 0
                Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
                break
            case .ephemeral:
                print("Notification status is not determined.")
                UserData.shared.isPushEnable = 0
                Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
                break
            @unknown default:
                print("Unknown authorization status.")
                UserData.shared.isPushEnable = 0
                Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
            }
        }
        
        DispatchQueue.main.async {
            self.pushNotificationSwitch.isOn = UserData.shared.isPushEnable == 1 ? true : false
        }

    }
    
//MARK: END MHIOS-1213&1314
    
    func open(url: URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open \(url): \(success)")
            })
        } else if UIApplication.shared.openURL(url) {
                print("Open \(url)")
        }
    }
    
    
    @IBAction func notificationAction(_ sender: UIButton) {
        stopReceivingPushNotifications()
    }
    
    func stopReceivingPushNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    
    @IBAction func rateAppAction(_ sender: UIButton) {
        if #available(iOS 14.0, *) {
          if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
             SKStoreReviewController.requestReview(in: scene)
           }
              } else {
                 SKStoreReviewController.requestReview()
                     }
    }
    

    @IBAction func loginRegisterAction(_ sender: UIButton) {
        if !UserData.shared.isLoggedIn{
            self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
        }else{
            self.navigationController?.pushViewController(AppController.shared.myProfile, animated: true)
        }
    }

    @IBAction func wishlistAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(AppController.shared.myWishlist, animated: true)
    }
    @IBAction func onClickNotification(_ sender: UIButton) {
        
       
        let vc = AppController.shared.myNotification
        vc.hidesBottomBarWhenPushed = true
        vc.notificationList = self.notificationList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ordersAction(_ sender: UIButton) {
        if !UserData.shared.isLoggedIn{
            self.navigationController?.pushViewController(AppController.shared.guestOrdertrack, animated: true)
        }
        else
        {
            self.navigationController?.pushViewController(AppController.shared.orderList, animated: true)
        }
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
        vc.urlString = appDelegate.storeLocator
        vc.ScreenTitle = "STORE LOCATOR"
        self.navigationController?.pushViewController(vc, animated: true)
         
    }
    @IBAction func ReturnAndRefund(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.returnAndExchange
        vc.ScreenTitle = "ONLINE RETURNS"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func PrivacyPolicy(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.shippingPolicy
        vc.ScreenTitle = "PRIVACY POLICY"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Navigation
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(self.navigationController?.viewControllers.count==1)
        {
            return false
        }
        else
        {
            return true
        }
    }
}
