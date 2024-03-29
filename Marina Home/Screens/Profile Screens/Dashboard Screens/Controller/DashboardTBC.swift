//
//  DashboardTBC.swift
//  Marina Home
//
//  Created by Codilar on 10/04/23.
//

import UIKit

class DashboardTBC: UITabBarController,UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().backgroundColor = UIColor.black
        UITabBar.appearance().selectionIndicatorImage = UIImage(named: AppAssets.tabbar_shadow.rawValue)
        if UIDevice.current.hasNotch {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        }
        setupTabBar()
    }

    func setupTabBar() {
        let home = AppController.shared.home
        let menu = AppController.shared.menu
        let profile = AppController.shared.profile
        let mycart = AppController.shared.mycart

        let homeBarItem = UITabBarItem(title: "HOME", image: UIImage(named: AppAssets.tabbar_home.rawValue), selectedImage: UIImage(named: AppAssets.tabbar_home.rawValue))
        home.tabBarItem = homeBarItem
        if UIDevice.current.hasNotch {
            home.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        }

        let menueBarItem = UITabBarItem(title: "MENU", image: UIImage(named: AppAssets.tabbar_menu.rawValue), selectedImage: UIImage(named: AppAssets.tabbar_menu.rawValue))
        menu.tabBarItem = menueBarItem
        if UIDevice.current.hasNotch {
            menu.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        }

        let profileBarItem = UITabBarItem(title: "PROFILE", image: UIImage(named: AppAssets.tabbar_profile.rawValue), selectedImage: UIImage(named: AppAssets.tabbar_profile.rawValue))
        profile.tabBarItem = profileBarItem
        if UIDevice.current.hasNotch {
            profile.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        }

        let mycartBarItem = UITabBarItem(title: "MY CART", image: UIImage(named: AppAssets.tabbar_my_cart.rawValue), selectedImage: UIImage(named: AppAssets.tabbar_my_cart.rawValue))
        mycart.tabBarItem = mycartBarItem
        if UIDevice.current.hasNotch {
            mycart.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        }
        mycartBarItem.badgeColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
        if UserData.shared.cartCount == 0
        {
            mycartBarItem.badgeValue = nil
        }
        else
        {
            mycartBarItem.badgeValue = "\(UserData.shared.cartCount)"
        }
        mycart.tabBarItem = mycartBarItem

        let homeWithNav = UINavigationController(rootViewController: home)
        homeWithNav.interactivePopGestureRecognizer!.delegate = self
        homeWithNav.interactivePopGestureRecognizer!.isEnabled = true
        let menuWithNav = UINavigationController(rootViewController: menu)
        menuWithNav.interactivePopGestureRecognizer!.delegate = self
        menuWithNav.interactivePopGestureRecognizer!.isEnabled = true
        let profileWithNav = UINavigationController(rootViewController: profile)
        profileWithNav.interactivePopGestureRecognizer!.delegate = self
        profileWithNav.interactivePopGestureRecognizer!.isEnabled = true
        let mycartWithNav = UINavigationController(rootViewController: mycart)
        mycartWithNav.interactivePopGestureRecognizer!.delegate = self
        mycartWithNav.interactivePopGestureRecognizer!.isEnabled = true
        homeWithNav.isNavigationBarHidden = true
        menuWithNav.isNavigationBarHidden = true
        profileWithNav.isNavigationBarHidden = true
        mycartWithNav.isNavigationBarHidden = true

        viewControllers = [homeWithNav,menuWithNav,profileWithNav,mycartWithNav]
    }
  
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
    {
        if (navigationController.viewControllers.count > 1)
            {
                 self.navigationController?.interactivePopGestureRecognizer?.delegate = self
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
            }
            else
            {
                 self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
                navigationController.interactivePopGestureRecognizer?.isEnabled = false
            }
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self == self.navigationController?.topViewController ? false : true
    }
}


extension UIDevice {
    var hasNotch: Bool {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return false
        }
        return window?.safeAreaInsets.top ?? 0 > 20
    }
}
