//
//  HomeVC.swift
//  Marina Home
//
//   Created by Codilar on 11/04/23.
//

import UIKit
import Firebase
import FirebaseMessaging
import KlaviyoSwift
import Adjust

class HomeVC: AppUIViewController,HomeCellProtocol ,UIGestureRecognizerDelegate{
    func OpenDetail(Room: Home) {
        let Vc = AppController.shared.Room
        Vc.identifer = Room.identifier
        if((Room.title1 != nil)&&(Room.title2 != nil)&&(Room.title3 != nil))
        {
            let titleString = (Room.title1 ?? "")+" "+(Room.title2 ?? "")+" "+(Room.title3 ?? "")
            Vc.roomtite = titleString.uppercased()
        }
        else
        {
            Vc.roomtite = Room.title1?.uppercased() ?? ""
        }
       
        self.navigationController?.pushViewController(Vc, animated: true)
        
    }
    func OpenDetailPlp(Room: Home) {
        var vc = AppController.shared.myPlp
        vc.category = Room
        if((Room.title1 != nil)&&(Room.title2 != nil)&&(Room.title3 != nil))
        {
            let titleString = (Room.title1 ?? "")+" "+(Room.title2 ?? "")+" "+(Room.title3 ?? "")
            vc.roomtite = titleString.uppercased()
        }
        //MARK START{MHIOS-1003}
       else if (Room.category_name != nil)
       {
           vc.roomtite = Room.category_name?.uppercased() ?? ""
       }
       else
       {
           vc.roomtite = Room.title1?.uppercased() ?? ""
       }
        //MARK END{MHIOS-1003}
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func OpenMenuPlp(Room:Home)
    {
        let vc = AppController.shared.menuPLP
        vc.category_id =  Room.category_id ?? ""
        if((Room.title1 != nil)&&(Room.title2 != nil)&&(Room.title3 != nil))
        {
            let titleString = (Room.title1 ?? "")+" "+(Room.title2 ?? "")+" "+(Room.title3 ?? "")
            vc.roomtite = titleString.uppercased()
        }
        //MARK START{MHIOS-1003}
       else if (Room.category_name != nil)
       {
           vc.roomtite = Room.category_name?.uppercased() ?? ""
       }
       else
       {
           vc.roomtite = Room.title1?.uppercased() ?? ""
       }
        //MARK END{MHIOS-1003}
        self.navigationController?.pushViewController(vc, animated: true)
    }
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

    @IBOutlet weak var verticalPageControl: UIPageControl!
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var splashView: UIView!
    
    var homeCatArray:[ [Home]] = []
    var footer_heading:String = ""
    var footer_description:String = ""
    var aboutUs:String = ""
    var storeLocator:String = ""
    var deliverReturns:String = ""
    var faqs: String = ""
    var contactUs:String = ""
    var termsAndCondition:String = ""
    var returnAndExchange:String = ""
    var shippingPolicy: String = ""
    
    var uniqueID: String = ""
    var isFromShareCart: Bool = false
    //var mycart:Cart?
    var guestCartId = ""
    var pageCurrentCountIs = 0
    let inetReachability = InternetReachability()!

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1236
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateContactUsPage(notification:)), name: Notification.Name("PushReceveContactUs"), object: nil)
        //MARK: END MHIOS-1236
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePush(notification:)), name: Notification.Name("PushReceve"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePushWishlist(notification:)), name: Notification.Name("PushReceveWishlist"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePushOrder(notification:)), name: Notification.Name("PushReceveOrder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePushCart(notification:)), name: Notification.Name("PushReceveCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePushShareCart(notification:)), name: Notification.Name("PushReceveShareCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePushCategory(notification:)), name: Notification.Name("PushReceveCatgory"), object: nil)
        //MARK: START MHIOS-1145
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePushLogin(notification:)), name: Notification.Name("PushReceveLogin"), object: nil)
        //MARK: END MHIOS-1145
        //MARK: START MHIOS-1173
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigatePushHome(notification:)), name: Notification.Name("PushReceveHome"), object: nil)
        //MARK: END MHIOS-1173
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadHome(notification:)), name: Notification.Name("ReloadHome"), object: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.guestCartId = appDelegate.guestCartId
        //tblHome.register(cellType: HomeCell.self)
        configureCustomView()
        self.tblHome.reloadData()
        let angle = CGFloat.pi/2
        let scale = CGAffineTransformMakeScale(0.7,0.7)
        let translation = CGAffineTransform(rotationAngle: angle)
        let concat = CGAffineTransformConcat(translation, scale)
        self.verticalPageControl.transform = concat
        // Mark MHIOS-710
       
        // Mark MHIOS-710
        getAdminData()
        getHomeData()
        //MARK: START MHIOS-1225
        if UserData.shared.isLoggedIn
        {
            CrashManager.shared.setUserID(UserData.shared.userId)
            SmartManager.shared.addUser(userId: UserData.shared.userId, userName: UserData.shared.firstName + " " + UserData.shared.lastName, userEmail: UserData.shared.emailId)
        }
        else
        {
            CrashManager.shared.setUserID("Guest_User")
            
        }
        
        CrashManager.shared.log("HomeVC")
        //MARK: START MHIOS-1225
    }
    // Mark MHIOS-710
    func openPushNotificationPopUp(pushData:PushData)
    {
        self.tabBarController?.tabBar.isHidden = true
        let screen = AppController.shared.pushVC
        screen.pushData = pushData
        screen.onDoneBlock = { [weak self] result in
            self?.tabBarController?.tabBar.isHidden = false
            self?.checkNotificationStatus()
            
        }
        self.present(screen, animated: true, completion: nil)
       
    }
    
    func getAdminData()
    {
        
        self.apiAdminMetadata() {  [weak self] resp in
            
           
                if !UserData.shared.pushPermission
                {
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: { [unowned self] in
                        
                        self?.openPushNotificationPopUp(pushData: resp.push_notification_response)
                    })
                }
            
            
        }
        
    }
    
    
    // Mark MHIOS-710
    
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
    }
    
    
    func getHomeData()
    {
        //Mark MHIOS-1158
       if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        {
           //MARK: START MHIOS-1199
           UserData.shared.appVersion = appVersion
           //MARK: END MHIOS-1199

           self.apiForceUpdateStatus(id:appVersion) {  [weak self] resp in
               
               if resp.is_force_update
               {
                   self?.tabBarController?.tabBar.isHidden = true
                   let screen = AppController.shared.forceUpdate
                   screen.updateTitle = resp.title
                   screen.updateDescription = resp.description
                   self?.present(screen, animated: true, completion: nil)
               }
               
               
           }
       }
        //Mark MHIOS-1158
        self.GetHomeItems(fromURLString: AppInfo.shared.homeURL) { resp in
            
            DispatchQueue.main.async {
                switch resp.data {
                case .success(let data):
                    self.parse(jsonData: data)
                    let ststusCode = resp.resp
                    //MARK START{MHIOS-1005}
                    if ststusCode != 200
                    {
                        self.errorAlert(type:1,statusCode: 404,retryAction: {
                            self.viewDidLoad()
                            self.viewWillAppear(true)
                        })
                    }
                    ///MARK END{MHIOS-1005}
                    //self.splashView.isHidden = true
                case .failure(let error):
                    print(error)
                    let ststusCode = resp.resp
                    self.splashView.isHidden = true
                    ///MARK START{MHIOS-1005}
                    self.errorAlert(type:1,statusCode: ststusCode,retryAction: {
                        self.viewDidLoad()
                        self.viewWillAppear(true)
                    })
                    ///MARK END{MHIOS-1005}
                }
            }
        }
    }

    func internetStatusCheck()
    {
        inetReachability.whenReachable = { _ in
            DispatchQueue.main.async {
             self.inetAlert(stsusNet: true)
                //self.view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                print("Internet is OK!")
            }
        }
        
        inetReachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
               self.inetAlert(stsusNet: false)
                //self.view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
                    print("Internet connection FAILED!")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: inetReachability)
        
        do {
            try inetReachability.startNotifier()
        } catch {
            print("Could not start notifier")
        }
    }
    
    func inetAlert(stsusNet:Bool) {
        print("SANTHOSH INTERNET STATUS IS \(stsusNet)")
        if stsusNet == false
        {
            print("NO INTERNET")
            ///self.showActivityIndicator(uiView: self.view)
            self.errorAlert(type:0,statusCode: 0 ,retryAction: {
                print("SANTHOSH ACTION TEST")
            })
        }
    }
    
    @objc func internetChanged(note:Notification) {
        
        let reachability =  note.object as! InternetReachability
        
        //reachability.isReachable is deprecated, right solution --> connection != .none
        if reachability.connection != .none {
            
            self.inetAlert(stsusNet: true)
            
        } else {
            
            inetAlert(stsusNet: false)
        }
    }
    
    //Mark MHIOS-1120(Sooraj)
    @objc func ReloadHome(notification: Notification) {
        DispatchQueue.main.async {
            if self.tblHome.numberOfSections > 0{
                if self.tblHome.numberOfRows(inSection: 0) > 0{
                    if let cell = self.tblHome.cellForRow(at: IndexPath(item: 0, section: 0)) as? HomeCell{
                        cell.collectionBanner.reloadData()
                    }
                }
                
            }
        }
    }
    //Mark MHIOS-1120(Sooraj)
    @objc func navigatePushWishlist(notification: Notification) {
      // Take Action on Notification
        let Controller = AppController.shared.myWishlist
        let thirdTabNavController = self.tabBarController?.viewControllers?[self.tabBarController?.selectedIndex ?? 0] as! UINavigationController
        
        thirdTabNavController.pushViewController(Controller, animated: false)
    }
    @objc func navigatePushCart(notification: Notification) {
      // Take Action on Notification
        let Controller = AppController.shared.mycart
        let thirdTabNavController = self.tabBarController?.viewControllers?[3] as! UINavigationController
        self.tabBarController?.selectedIndex = 3
        thirdTabNavController.popToRootViewController(animated: false)
    }
    
    @objc func navigatePushShareCart(notification: Notification) {
        // Merge the share cart items
        isFromShareCart = true
        uniqueID = notification.userInfo!["unique_id"] as! String
        if uniqueID != ""
        {
            if UserData.shared.cartQuoteId != 0
            {
                mergeCartItems()
            }
            else
            {
                self.getCartCount()
            }
        }
        
    }
    @objc func navigatePush(notification: Notification) {
      // Take Action on Notification
        let sideMenuController = (UIStoryboard(name: "ProductDetailsScreens", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsImagesVC_id") as? ProductDetailsImagesVC)!
        sideMenuController.productId = notification.userInfo!["sku"] as! String
        let thirdTabNavController = self.tabBarController?.viewControllers?[self.tabBarController?.selectedIndex ?? 0] as! UINavigationController
        thirdTabNavController.pushViewController(sideMenuController, animated: false)
    }
    @objc func navigatePushOrder(notification: Notification) {
      // Take Action on Notification
        let sideMenuController = (UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailVC_id") as? OrderDetailVC)!
        sideMenuController.orderId = notification.userInfo!["order_id"] as! String
        sideMenuController.emailId = notification.userInfo!["email_d"] as! String
        sideMenuController.entityId = notification.userInfo!["entity_id"] as! String
        let thirdTabNavController = self.tabBarController?.viewControllers?[self.tabBarController?.selectedIndex ?? 0] as! UINavigationController
        thirdTabNavController.pushViewController(sideMenuController, animated: false)
    }
    //MARK: START MHIOS-1145
    @objc func navigatePushLogin(notification: Notification) {
      // Take Action on Notification
        let sideMenuController = (UIStoryboard(name: "ProfileScreens", bundle: nil).instantiateViewController(withIdentifier: "LoginRegisterVC_id") as? LoginRegisterVC)!
        let thirdTabNavController = self.tabBarController?.viewControllers?[self.tabBarController?.selectedIndex ?? 0] as! UINavigationController
        thirdTabNavController.pushViewController(sideMenuController, animated: false)
    }
    //MARK: END MHIOS-1145
    //MARK: START MHIOS-1173
    @objc func navigatePushHome(notification: Notification) {
      // Take Action on Home
        self.tabBarController?.selectedIndex = 0
    }
    //MARK: END MHIOS-1173
    @objc func navigatePushCategory(notification: Notification) {
      // Take Action on Notification
        let Controller = AppController.shared.menuPLP
        Controller.category_id = notification.userInfo!["sku"] as! String
        let thirdTabNavController = self.tabBarController?.viewControllers?[self.tabBarController?.selectedIndex ?? 0] as! UINavigationController
        thirdTabNavController.pushViewController(Controller, animated: false)
    }
        //MARK: START MHIOS-1236
        @objc func navigateContactUsPage(notification: Notification) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let vc = AppController.shared.web
            vc.hidesBottomBarWhenPushed = true
            vc.urlString = appDelegate.contactUs
            vc.ScreenTitle = "CONTACT US"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //MARK: END MHIOS-1236
    func mergeCartItems()
    {
        self.apiMergeCartItems(quoteId: UserData.shared.cartQuoteId, uniqueId: uniqueID ){ response in
            DispatchQueue.main.async {
                print(response)
                if response {
                    //AppUIViewController().toastView(toastMessage: "Link Copied",type: "success")
                    let dic = ["cc":"tt"]
                    NotificationCenter.default.post(name: Notification.Name("ShareCartReloadData"), object: nil,userInfo: dic)
                    let Controller = AppController.shared.mycart
                    let thirdTabNavController = self.tabBarController?.viewControllers?[3] as! UINavigationController
                    self.tabBarController?.selectedIndex = 3
                    thirdTabNavController.popToRootViewController(animated: false)
                }
                else
                {
                    //MARK: START MHIOS-1285
                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Try again","Screen" : self.className])
                    //MARK: END MHIOS-1285
                    AppUIViewController().toastView(toastMessage: "Try again",type: "error")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("stopPlayer"), object: nil,userInfo: nil)
        self.isFromShareCart = false
        self.hideActivityIndicator(uiView: self.view)
    }
    
    //MARK START{MHIOS-1005}
    override func viewWillAppear(_ animated: Bool) {
        internetStatusCheck()
        UserData.shared.goTocartStatus = false
        DispatchQueue.main.async {
            if(self.homeCatArray.count>1)
            {
                // Mark MHIOS-1114
                let indexPath = IndexPath(item: 0, section: 0)
            //  self.tblHome.reloadRows(at: [indexPath], with: .none)
                if let cell = self.tblHome.cellForRow(at: indexPath) as? HomeCell
                {
                    cell.player?.play()
                }
                // Mark MHIOS-1114
            }
            //MARK START{MHIOS-1181}
            self.setProfile()
            //MARK END{MHIOS-1181}
        }
        if(Network.isAvailable()==false)
        {
            self.errorAlert(type:0,statusCode: 0 ,retryAction: {
                print("SANTHOSH ACTION TEST")
                self.getHomeData()
                self.setProfile()
            })
        }
    }
    
    func setProfile()
    {
        if UserData.shared.isLoggedIn{
            self.getWishlist()
            let profile = Profile(email:UserData.shared.emailId , firstName: UserData.shared.firstName, lastName: UserData.shared.lastName)
            
            KlaviyoSDK().set(profile: profile)
        }
        else
        {
            //MARK: START MHIOS-973
            let profile = Profile(externalId: UserData.shared.external_id)
            KlaviyoSDK().set(profile: profile)
            //MARK: END MHIOS-973

        }
        self.isFromShareCart = false
        self.getCartCount()
        Network.enableDisablePushNotification(status: UserData.shared.isPushEnable)
    }
    //MARK END{MHIOS-1005}
    
    
    func getCartCount()
    {
        if UserData.shared.isLoggedIn{
            print("SANTHOSH CART Share LOGIN")
            self.apiCreateCart(){ response in
                print("SANTHOSH CART Share apiCreateCart")
                DispatchQueue.main.async {
                    print(response)
                    self.apiCarts(){ response in
                        print("SANTHOSH CART Share apiCarts")
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
                            
                            if self.isFromShareCart
                            {
                                
                                self.mergeCartItems()
                            }
                        }
                    }
                }
            }
        }
        else
        {
            print("SANTHOSH CART Share GUEST")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if(appDelegate.guestCartId == "")
            {
                self.apiCreateGuestCart(){ response in
                    DispatchQueue.main.async {
                        print("SANTHOSH CART apiCreateGuestCart : OK")
                        print(response)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.guestCartId = response
                        self.guestCartId = response
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(response, forKey: "GuestCart")
                        print("SANTHOSH CART apiGuestCarts : Come")
                        self.apiGuestCarts(){ response in
                            appDelegate.storeID = response.storeID ?? 0
                            DispatchQueue.main.async {
                                print("SANTHOSH CART apiGuestCarts : OK")
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
                                
                                if self.isFromShareCart
                                {
                                    
                                    self.mergeCartItems()
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
     
    func parse(jsonData: Data) {
       do {
           let movieData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String: Any]
          // let decodedData = try JSONDecoder().decode([[Home]].self,
           self.footer_heading = movieData["footer_heading"] as! String
           self.footer_description = movieData["footer_description"] as! String
           self.contactUs = movieData["contact_us"] as! String  // from: jsonData)
           self.returnAndExchange = movieData["return_and_exchange"] as! String  // from: jsonData)
           self.shippingPolicy = movieData["shipping_policy"] as! String  // from: jsonData)
           self.faqs = movieData["faqs"] as! String  // from: jsonData)
           self.termsAndCondition = movieData["terms_and_condition"] as! String
           self.aboutUs = movieData["about_us"] as! String // from: jsonData)
           self.storeLocator = movieData["store_locator"] as! String // from: jsonData)
           self.deliverReturns = movieData["deliver_returns"] as! String // from: jsonData)
           DispatchQueue.main.async {
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               appDelegate.shippingPolicy = self.shippingPolicy
               appDelegate.faqs = self.faqs
               appDelegate.aboutUs = self.aboutUs
               appDelegate.contactUs = self.contactUs
               appDelegate.returnAndExchange = self.returnAndExchange
               appDelegate.termsAndCondition = self.termsAndCondition
               appDelegate.deliverReturns = self.deliverReturns
               appDelegate.storeLocator = self.storeLocator
           }
           //self.homeCatArray = decodedData
           for i in 0...movieData.keys.count {
             let session = movieData["\(i)"]
               if(session != nil)
               {
                   guard let data = try? JSONSerialization.data(withJSONObject: session, options: []) else {
                       return
                   }
                   let decodedData = try JSONDecoder().decode([Home].self,
                                                              from: data)
                   self.homeCatArray.append(decodedData)
               }
                                                        
            print(session)
           }
           DispatchQueue.main.async {
               self.tblHome.reloadData()
               self.tblHome.layoutIfNeeded()
               self.splashView.isHidden = true
           }
       } catch {
           print("decode error")
       }
   }
    private func configureCustomView() {
        self.tblHome.translatesAutoresizingMaskIntoConstraints = false
        self.tblHome.contentInsetAdjustmentBehavior = .never
       // self.tblHome.backgroundColor = .systemPurple

            NSLayoutConstraint.activate([
                self.tblHome.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                self.tblHome.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                self.tblHome.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                self.tblHome.heightAnchor.constraint(equalToConstant: 200)
            ])
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
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tblHome.frame.size.height;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.verticalPageControl.numberOfPages = self.homeCatArray.count+1
        return self.homeCatArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case self.homeCatArray.count:
            let cell = tableView.dequeueReusableCell(with: HomeFooterCell.self, for: indexPath)
            cell.lblDescription.text = self.footer_description
            cell.lblTitle.text = self.footer_heading
            cell.btnTerms.addTarget(self, action: #selector(self.LoadWebAction(_:)), for: .touchUpInside)
            cell.btnFaq.addTarget(self, action: #selector(self.LoadWebAction(_:)), for: .touchUpInside)
            cell.btnContactUs.addTarget(self, action: #selector(self.LoadWebAction(_:)), for: .touchUpInside)
            cell.btnShipingPolicy.addTarget(self, action: #selector(self.LoadWebAction(_:)), for: .touchUpInside)
            cell.btnHomelegacy.addTarget(self, action: #selector(self.LoadWebAction(_:)), for: .touchUpInside)
            cell.btnReturn.addTarget(self, action: #selector(self.LoadWebAction(_:)), for: .touchUpInside)
            return cell
            break
            
        default:
            let cell = tableView.dequeueReusableCell(with: HomeCell.self, for: indexPath)
            if(indexPath.row != 0)
            {
                cell.imgLogo.isHidden = true
            }
            else
            {
                cell.imgLogo.isHidden = false
            }
            cell.category = self.homeCatArray[indexPath.row]
            cell.detailDelegate = self
            if(self.homeCatArray[indexPath.row].count>1)
            {
                cell.pageControl.numberOfPages = self.homeCatArray[indexPath.row].count
            }
            else
            {
                cell.pageControl.numberOfPages = 0
            }
           // cell.collectionBanner.register(HomeBannerCell.self, forCellWithReuseIdentifier: "HomeBannerCell")
            //cell.collectionBanner.translatesAutoresizingMaskIntoConstraints = false
            //cell.collectionBanner.contentInsetAdjustmentBehavior = .never
            
               
            
            cell.collectionBanner.reloadData()
           // cell.btnDetail.addTarget(self, action: #selector(self.DetailAction(_:)), for: .touchUpInside)
            //cell.collectionBanner.backgroundColor = .systemPurple

                
            return cell
        }
        
        
    }
    
    
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.verticalPageControl.currentPage = indexPath.row
        pageCurrentCountIs = indexPath.row
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.tblHome.rowHeight
    }
    
   

        
    @objc func LoadWebAction(_ sender: UIButton) {
        var id:String = ""
        var pagetitle = ""
        switch sender.tag {
           
        case 0:
            id = self.aboutUs
            pagetitle = "LEGACY"
        case 1:
            id = self.storeLocator
            pagetitle = "STORE LOCATOR"
        case 2:
            id = self.contactUs
            pagetitle = "CONTACT US"
        case 3:
            id = self.termsAndCondition
            pagetitle = "TERMS AND CONDITIONS"
        case 4:
            id = self.returnAndExchange
            pagetitle = "RETURN  AND REFUNDS"
        case 5:
            id = self.shippingPolicy
            pagetitle = "PRIVACY POLICY"
        default:
            id = self.aboutUs
        }
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = id
    vc.ScreenTitle = pagetitle
        self.navigationController?.pushViewController(vc, animated: true)
       /* self.apiGetFooterLink(id: id) { response in
           
                
                
                let vc = AppController.shared.web
                vc.htmlContent = response.content
            vc.ScreenTitle = response.title
                self.navigationController?.pushViewController(vc, animated: true)
                
           
        }*/
        
    }
    
}

