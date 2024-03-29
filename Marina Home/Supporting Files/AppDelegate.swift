//
//  AppDelegate.swift
//  Marina Home
//
//  Created by Codilar on 10/04/23.
//

import UIKit
import GoogleSignIn
import Firebase
import Tabby
import KlaviyoSwift
import UserNotifications
import GooglePlaces
import Alamofire
import NewRelic
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import Adjust
//MARK: START MHIOS-1225
import Network
//MARK: END MHIOS-1225
//MARK: START MHIOS-1064
import SmartlookAnalytics
//MARK: END MHIOS-1064
@main
class AppDelegate: UIResponder, UIApplicationDelegate , MessagingDelegate {
    
    var guestCartId:String = ""
    var storeID:Int = 0
    var aboutUs:String = ""
    var faqs: String = ""
    var contactUs:String = ""
    var selectdCard = -1
    var selectdProductTab = 0
    var termsAndCondition:String = ""
    var cachedCartItems: [CartItem]?
    var returnAndExchange:String = ""
    var shippingPolicy: String = ""
    var wishList:[String] = []
    var shipingInfo :ShipingMethod?
    var payementSucces:Bool = true
    var window: UIWindow?
    var deviceTOKEN = ""
    var storeLocator:String = ""
    var deliverReturns:String = ""
    var deviceToken:String = ""
    var devicePushToken:Data?
    //MARK: START MHIOS-1225
    let monitor = NWPathMonitor()
    //MARK: END MHIOS-1225

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity:
                     NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("SANTHOSH SHARE V")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            NotificationCenter.default.post(name: Notification.Name("PushReceve"), object: nil)
        })
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
        else
        {
            return false
        }
        
        guard let path = components.path,
              let params = components.queryItems else
        {
            return false
        }
        
        print("path = \(path)")
        
        //if let albumName = params.
        
        
        //        print("Continue User Activity called: ")
        //        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
        //            let url = userActivity.webpageURL!
        //            print("SANTHOSH SHARE U : \(url)")
        //            print(url.absoluteString)
        //            //handle url and open whatever page you want to open.
        //        }
        return false
    }
    
    //MARK: START MHIOS-1225
    func checkNetwork()
    {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                CrashManager.shared.addKey(key: "is_internet_available", value: true)
                // Perform actions when internet is available
            } else {
                CrashManager.shared.addKey(key: "is_internet_available", value: false)
                // Perform actions when internet is not available
            }
        }
    }
    //MARK: END MHIOS-1225
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("SANTHOSH SHARE B")
        // Override point for customization after application launch.
        ///Thread.sleep(forTimeInterval: -5.0)
        ///
        //MARK: START MHIOS-1064
        Smartlook.instance.preferences.projectKey = AppInfo.shared.smartLookKey
        Smartlook.instance.start()
        //MARK: END MHIOS-1064
        //MARK: END MHIOS-1225
        checkNetwork()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        //MARK: END MHIOS-1225
        // MHIOS-1072
        UserData.shared.previousTab = 0
        // MHIOS-1072

        //adjust
        let adjustConfig = ADJConfig(
            appToken: AppInfo.shared.yourAppToken,
            environment: AppInfo.shared.adjustEnv)
        adjustConfig?.logLevel = ADJLogLevelVerbose
        // Mark MHIOS-1155
        adjustConfig?.attConsentWaitingInterval = 30
        // Mark MHIOS-1155
        Adjust.appDidLaunch(adjustConfig)
        
        NewRelic.start(withApplicationToken:AppInfo.shared.newRelicAppKey)

        //application.applicationIconBadgeNumber = 12
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        FirebaseApp.configure()
        
       /// return true
        
        
//        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey(AppInfo.shared.googleApiKey)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        let userDefaults = UserDefaults.standard

        // Read/Get Value
        self.guestCartId = userDefaults.string(forKey: "GuestCart") ?? ""
        TabbySDK.shared.setup(withApiKey: AppInfo.shared.tabbyApiKey , forEnv:.prod)
        KlaviyoSDK().initialize(with: AppInfo.shared.klaviyoKey)
       /// UIApplication.shared.registerForRemoteNotifications()
        //MARK: START MHIOS-973
        if UserData.shared.external_id == ""
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let ext_id = "\(Int.random(in: 0..<6000))" + "_" + dateFormatter.string(from: Date())
            
            UserData.shared.external_id = ext_id
        }
        //MARK: END MHIOS-973
        return true
    }
    // Mark MHIOS-710
    func openPushPopup()
    {
        let center = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate // the type casting can be removed once the delegate has been implemented
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        // use the below options if you are interested in using provisional push notifications. Note that using this will not
        // show the push notifications prompt to the user.
        // let options: UNAuthorizationOptions = [.alert, .sound, .badge, .provisional]
        center.requestAuthorization(options: options) {[weak self] granted, error in
            if let error = error {
                // Handle the error here.
                print("error = ", error)
            }
            
            NotificationCenter.default.post(name: Notification.Name("PushPermissionReceive"), object: nil)
            // Enable or disable features based on the authorization status.
        }
        if #available(iOS 10.0, *) {
                let center  = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.sound = UNNotificationSound.default
                center.delegate = self
                UNUserNotificationCenter.current().delegate = self
                center.requestAuthorization(options: [.sound, .alert, .badge])
                { (granted, error) in
                    if error == nil{
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
        } else {
            let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            
        }
            
        UIApplication.shared.registerForRemoteNotifications()
    }
    // Mark MHIOS-710
    
    // Handle deep link URL opening
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            NotificationCenter.default.post(name: Notification.Name("PushReceve"), object: nil)
        })
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("SANTHOSH SHARE D")
        print("SANTHOSH SHARE URL IS : \(url)")
        
        if let host = url.host {
            if host == "marinahomeinteriors.com" {//preprod.marinahome.org
                // Perform any necessary redirection or navigation here
                // For example, open a specific view controller
                if let navigationController = window?.rootViewController as? UINavigationController {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    //                    if let viewController = storyboard.instantiateViewController(withIdentifier: "RedirectViewController") as? UIViewController {
                    //                        navigationController.pushViewController(viewController, animated: true)
                    //                    }
                    
                    return true
                }
            }
            return false
        }
        return false
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("SANTHOSH SHARE E didRegisterForRemoteNotificationsWithDeviceToken")
        Messaging.messaging().apnsToken = deviceToken
        //Messaging.messaging().apnsToken = deviceToken;
        print("SANTHOSH FCM TOKEN : ",deviceToken)
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            print("SANTHOSH FCM TOKEN : \(token)")
        self.deviceToken = token
        self.devicePushToken  = deviceToken
        KlaviyoSDK().set(pushToken: deviceToken)
        if  UserData.shared.emailId != nil
        {
        KlaviyoSDK().set(email: UserData.shared.emailId)
        }
//        if(UserData.shared.isLoggedIn)
//        {
//            //self.savePushcredentials(userId: UserData.shared.userId, token: deviceToken.hexString)
//            self.deviceTOKEN = deviceToken.hexString
//        }
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("SANTHOSH SHARE F")
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("SANTHOSH SHARE G")
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //    func application(_ app: UIApplication,
    //                     open url: URL,
    //                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    //
    //        ///return GIDSignIn.sharedInstance.handle(url)
    //        print(url)
    //
    //        return true
    //    }
    func addCachedItemsToCart()
    {
        
    }
    func savePushcredentials(userId: String,token:String){
        
        let api = Api.shared.storePushToken
        if Network.isAvailable() {
            
            var completeUrl = AppInfo.shared.baseMenuURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            // headers["Authorization"] = AppInfo.shared.integrationToken
            let params = ["customerId":UserData.shared.userId,
                          "deviceToken": token,
            ]
            AF.request(completeUrl, method: api.method,parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        
                    case .failure(_):
                        
                        guard let data = response.data else { return }
                        //MARK: START MHIOS-1285
                       SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                       //MARK: END MHIOS-1285
                    }
                }
        }else{

        }
    }
   
    
    private func coordinateToSomeVC(rootNAmes:String)
    {
        
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let yourVC = storyboard.instantiateViewController(identifier: rootNAmes)
        
        let navController = UINavigationController(rootViewController: yourVC)
        navController.modalPresentationStyle = .fullScreen
        
        // you can assign your vc directly or push it in navigation stack as follows:
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the\\ notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let aps = userInfo["aps"] as? NSDictionary
        if let aps = aps {
            let alert = aps["alert"] as! NSDictionary
            let body = alert["body"] as! String
            let title = alert["title"] as! String
            print("SANTHOSH TITLE FCM : \(title)")
        }
        
        ///No RSULT
        //        adgeNumber = adgeNumber+1
        //        UIApplication.shared.applicationIconBadgeNumber = adgeNumber
        
        print("C")
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        
        
        // Print full message.
        print(userInfo)
        
        
        
        
        
        completionHandler(UIBackgroundFetchResult.newData)
        ///UIApplication.shared.applicationIconBadgeNumber = 8
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        print(fcmToken)
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")

     }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")
//
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        NotificationCenter.default.post(
//            name: Notification.Name("FCMToken"),
//            object: nil,
//            userInfo: dataDict
//        )
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
    
}


@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("SANTHOSH SHARE H")
        
       
            let userInfo = response.notification.request.content.userInfo
            print("SANTHOSH SHARE HDDD \(userInfo)")
        /*self.showAlert(message: "\(userInfo)", rightAction: {
            
        }, leftAction: {})*/
            let handled = KlaviyoSDK().handle(notificationResponse: response, withCompletionHandler: completionHandler)
            if !handled {
                
                // not a klaviyo notification should be handled by other app code
                print("SANTHOSH SHARE NOT KlaviyoSDK")
                if userInfo["type"] as? String != nil
                {
                    let type = userInfo["type"] as? String ?? ""
                    switch type {
                    case "order":
                        let entity_id = userInfo["order_entity_id"] as! String
                        let order_id = userInfo["order_increment_id"] as! String
                        let email_d = userInfo["customer_email"] as! String
                        let dic = ["order_id":order_id
                                   ,"email_d":email_d
                                   ,"entity_id":entity_id]
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            NotificationCenter.default.post(name: Notification.Name("PushReceveOrder"), object: nil,userInfo: dic)
                        })
                        break
                    default:
                        print("NO DATA")
                    }
                }
                else  
                {
                   
                  
                    guard let parsedDictionary = userInfo["aps"] as? [String: Any]else {return}
                            
                            guard let alert = parsedDictionary ["alert"]  as? [String: Any] else {return}
                    guard let Str = alert["body"] as? String else {return}
                    var urlStr = Str.lowercased()
                    if urlStr.contains("wishlist")
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            NotificationCenter.default.post(name: Notification.Name("PushReceveWishlist"), object: nil,userInfo: nil)
                        })
                    }
                    else if urlStr.contains("cart")
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            NotificationCenter.default.post(name: Notification.Name("PushReceveCart"), object: nil,userInfo: nil)
                        })
                    }
                    else if urlStr.contains("category")
                    {
                        
                        if urlStr.hasSuffix("/") {
                            urlStr = String(urlStr.dropLast())
                        }
                        let component = urlStr.components(separatedBy: "/")
                        let sku = component.last!
                        let dic = ["sku":sku]
                        print("SANTHOSH URL SKU CASE : \(sku)")
                        if sku != ""
                        {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                NotificationCenter.default.post(name: Notification.Name("PushReceveCatgory"), object: nil,userInfo: dic)
                            })
                        }
                        
                        
                    }
                }
                
                //print("SANTHOSH NO type DATA \(type)")
//                let type = userInfo["type"] as? String ?? ""
//                if type != ""
//                {
//                    switch type {
//                    case "order":
//                        let entity_id = userInfo["order_entity_id"] as! String
//                        let order_id = userInfo["order_increment_id"] as! String
//                        let email_d = userInfo["customer_email"] as! String
//                        let dic = ["order_id":order_id
//                                   ,"email_d":email_d
//                                   ,"entity_id":entity_id]
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                            NotificationCenter.default.post(name: Notification.Name("PushReceveOrder"), object: nil,userInfo: dic)
//                        })
//                        break
//                    default:
//                        print("NO DATA")
//                    }
//                }
                
                
            }
        
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        ///let userInfo = response.notification.request.content.userInfo
        
        print("SANTHOSH SHARE HHHHH")
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        print("SANTHOSH SHARE STATUS \(notificationsEnabled)")
        
            var options: UNNotificationPresentationOptions =  [.alert]
            if #available(iOS 14.0, *) {
                options = [.list, .banner]
            }
            completionHandler(options)
        
            
        
    }
    func showAlert(title: String = "", message: String, hasleftAction: Bool = false, leftactionTitle: String = "Cancel", rightactionTitle: String = "OK", rightAction: @escaping ()->(), leftAction: @escaping ()->()) {
       DispatchQueue.main.async {
          let popUpVC = AppController.shared.alertPopUp
          popUpVC.rightActionClosure = rightAction
          popUpVC.leftActionClosure = leftAction
          popUpVC.message = message
          popUpVC.popUptitle = title
          popUpVC.hasleftAction = hasleftAction
          popUpVC.rightActionTitle = rightactionTitle
          popUpVC.leftActionTitle = leftactionTitle
          popUpVC.modalTransitionStyle = .crossDissolve
          popUpVC.modalPresentationStyle = .overCurrentContext
          UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
       }
    }

}

//@available(iOS 10, *)
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    // Receive displayed notifications for iOS 10 devices.
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
//                                -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        print("A")
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        //adgeNumber = adgeNumber+1
//        //UIApplication.shared.applicationIconBadgeNumber = adgeNumber
//        // Print full message.
//        print(userInfo)
//
//
//        // Change this to your preferred presentation option
//        //completionHandler([[.alert, .sound]])
//        completionHandler([[.badge,.alert, .sound]])
//    }
//
//
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//
//
//
//        print("B")
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        //        adgeNumber = adgeNumber+1
//        //        UIApplication.shared.applicationIconBadgeNumber = adgeNumber
//
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print full message.
//        print(userInfo)
//
//
//
////        typeValue = userInfo["type"] as! String
////        let idValue = userInfo["id"]
////        print("SANTHU TYPE ID : ",typeValue)
////        print("SANTHU NTI ID IS : ",idValue)
//
//
//
////        if typeValue=="attendance"
////        {
////            rootName = "AttendenceListViewController"
////            UserDefaults.standard.set(false, forKey: "rootStatusPop")
////            UserDefaults.standard.set(idValue, forKey: "notificationId")
////        }
////        else if typeValue=="employee_request"
////        {
////            rootName = "RequestsDetailsVC"
////            UserDefaults.standard.set(false, forKey: "rootStatusPop")
////            UserDefaults.standard.set(idValue, forKey: "notificationId")
////            UserDefaults.standard.set(idValue, forKey: "request_id")
////        }
////        else
////        {
////            rootName = "NotificationVc"
////            UserDefaults.standard.set(true, forKey: "rootStatusPop")
////            UserDefaults.standard.set(idValue, forKey: "notificationId")
////        }
//
//
//        //print("SANTHU ROOT : ",rootName)
//
//        coordinateToSomeVC(rootNAmes: "ProductDetailsImagesVC")
//
//        completionHandler()
//    }
//
//
//}

