import UIKit
import KlaviyoSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        ///guard let _ = (scene as? UIWindowScene) else { return }
//        guard let _ = (scene as? UIWindowScene) else { return }
////                let storyboard = UIStoryboard(name: "HomeScreens", bundle: nil)
////                guard let rootVC = storyboard.instantiateViewController(identifier: "HomeVC_id") as? HomeVC else {
////                    print("ViewController not found")
////                    return
////                }
////                let rootNC = UINavigationController(rootViewController: rootVC)
////                self.window?.rootViewController = rootNC
////                self.window?.makeKeyAndVisible()
//    }
    


    func sceneWillEnterForeground(_ scene: UIScene) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("User is Entering Foreground from Background")
        //MARK: END MHIOS-1225
            UIApplication.shared.applicationIconBadgeNumber = 0
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            NotificationCenter.default.post(name: Notification.Name("ReloadHome"), object: nil,userInfo: nil)
        })
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
            let klaviyo = KlaviyoSDK()
            
            let event = Event(name: .CustomEvent("Active on app"), properties: [
                "time":Date()
            ], value: 0)
            klaviyo.create(event: event)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first {
        if let url = userActivity.webpageURL {
            //MARK: START MHIOS-1145
            redirectUser(url: url)
            //MARK: END MHIOS-1145
        }
    }
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        //MARK: START MHIOS-1145
        if let url = userActivity.webpageURL {
            redirectUser(url: url)
        }
        //MARK: END MHIOS-1145
    }
    
    //MARK: START MHIOS-1145
    func redirectUser(url: URL)
    {
        //MARK: START MHIOS-1173
        if !url.absoluteString.contains(AppInfo.shared.smartAppLink)
        {
         //MARK: END MHIOS-1173
            
            var urlStr = url.absoluteString //1
            
            if urlStr.contains("product/")
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
                        NotificationCenter.default.post(name: Notification.Name("PushReceve"), object: nil,userInfo: dic)
                    })
                }
            }
            else if urlStr.contains("wishlist")
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    NotificationCenter.default.post(name: Notification.Name("PushReceveWishlist"), object: nil,userInfo: nil)
                })
            }
            else if urlStr.contains("/share_cart/action/restore/unique_id")
            {
                let component = urlStr.components(separatedBy: "/")
                if let index = component.firstIndex(of: "unique_id") {
                    if (index+1) < component.count
                    {
                        let uniqueID = component[index+1] as? String
                        let dic = ["unique_id":uniqueID]
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            NotificationCenter.default.post(name: Notification.Name("PushReceveShareCart"), object: nil,userInfo: dic)
                        })
                    }
                }
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
                if sku != ""
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        NotificationCenter.default.post(name: Notification.Name("PushReceveCatgory"), object: nil,userInfo: dic)
                    })
                }
                
                
            }
        else if urlStr.contains("sociallogin")
        {
          
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                NotificationCenter.default.post(name: Notification.Name("PushReceveLogin"), object: nil,userInfo: nil)
            })
               
        }
        //MARK: START MHIOS-1236
        else if urlStr.contains("contact")
        {

            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                NotificationCenter.default.post(name: Notification.Name("PushReceveContactUs"), object: nil,userInfo: nil)
            })

        }
        //MARK: END MHIOS-1236
        else if urlStr != AppInfo.shared.shareBaseURL{
            let component = urlStr.components(separatedBy: "/")
            let splitURL = component.last!
            let productName = splitURL.components(separatedBy: ".").first
            let sku = productName!.components(separatedBy: "-").last
                let dic = ["sku":sku]
                if sku != ""
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        NotificationCenter.default.post(name: Notification.Name("PushReceve"), object: nil,userInfo: dic)
                    })
                }
            }
        //MARK: START MHIOS-1173
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                NotificationCenter.default.post(name: Notification.Name("PushReceveHome"), object: nil,userInfo: nil)
            })
        }
        //MARK: END MHIOS-1173
    }
    //MARK: END MHIOS-1145
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //MARK: START MHIOS-1145
        if let url = URLContexts.first?.url {
            redirectUser(url: url)
        }
        //MARK: END MHIOS-1145
    }
    func redirectUserToMain(){
            //user is logged in, redirect to main View

//            let storyboard = UIStoryboard(name: "ProductDetailsScreens", bundle: nil)
//            let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "") as! ProductDetailsImagesVC
//            navigationController?.pushViewController(mainTabBarController, animated: true)
        
            let mainStoryBoard = UIStoryboard(name: "ProductDetailsScreens", bundle: nil)
            let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "ProductDetailsImagesVC_id")
            window?.rootViewController = viewController
       }

//    func sceneDidDisconnect(_ scene: UIScene) {
//        // Called as the scene is being released by the system.
//        // This occurs shortly after the scene enters the background, or when its session is discarded.
//        // Release any resources associated with this scene that can be re-created the next time the scene connects.
//        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
//    }

//    func sceneDidBecomeActive(_ scene: UIScene) {
//        // Called when the scene has moved from an inactive state to an active state.
//        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//    }
//
//    func sceneWillResignActive(_ scene: UIScene) {
//        // Called when the scene will move from an active state to an inactive state.
//        // This may occur due to temporary interruptions (ex. an incoming phone call).
//    }
//
//    func sceneWillEnterForeground(_ scene: UIScene) {
//        // Called as the scene transitions from the background to the foreground.
//        // Use this method to undo the changes made on entering the background.
//    }
//
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        NotificationCenter.default.post(name: Notification.Name("stopPlayer"), object: nil,userInfo: nil)
        //MARK: START MHIOS-1225
        CrashManager.shared.log("User is Entering Background from Foreground")
        //MARK: END MHIOS-1225
    }


}

