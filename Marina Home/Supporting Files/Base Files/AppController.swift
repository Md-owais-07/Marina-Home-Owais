//
//  AppController.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import UIKit

class AppStoryBoard {

    static let shared = AppStoryBoard()
    var common:UIStoryboard {
        UIStoryboard(name: "CommonScreens", bundle: nil)
    }
    var home:UIStoryboard {
        UIStoryboard(name: "HomeScreens", bundle: nil)
    }
    var search:UIStoryboard {
        UIStoryboard(name: "Search", bundle: nil)
    }
    var menu:UIStoryboard {
        UIStoryboard(name: "MenuScreens", bundle: nil)
    }
    var profile:UIStoryboard {
        UIStoryboard(name: "ProfileScreens", bundle: nil)
    }
    var notification:UIStoryboard {
        UIStoryboard(name: "Notification", bundle: nil)
    }
    var mycart:UIStoryboard {
        UIStoryboard(name: "MyCartScreens", bundle: nil)
    }
    var plp:UIStoryboard {
        UIStoryboard(name: "PLP", bundle: nil)
    }
    var web:UIStoryboard {
        UIStoryboard(name: "CommonScreens", bundle: nil)
    }
    var productDetails:UIStoryboard {
        UIStoryboard(name: "ProductDetailsScreens", bundle: nil)
    }
    var address:UIStoryboard {
        UIStoryboard(name: "AddressScreens", bundle: nil)
    }
    var checkout:UIStoryboard {
        UIStoryboard(name: "CheckoutScreens", bundle: nil)
    }
    var order:UIStoryboard {
        UIStoryboard(name: "Order", bundle: nil)
    }
    
    var productDetailsNew:UIStoryboard {
        UIStoryboard(name: "ProductDetailsScreensNew", bundle: nil)
    }
    var paymentCards:UIStoryboard {
        UIStoryboard(name: "PaymentCardsScreens", bundle: nil)
    }
    var orderReturn:UIStoryboard {
        UIStoryboard(name: "OrderReturnScreens", bundle: nil)
    }
    //MARK: START MHIOS-1246
    var push:UIStoryboard {
        UIStoryboard(name: "PushScreen", bundle: nil)
    }
    //MARK: END MHIOS-1246

}

class AppController {

    static let shared = AppController()

    // MARK: - Common
    var alertPopUp: AlertPopUpVC {
        AppStoryBoard.shared.common.instantiateViewController(withIdentifier: "AlertPopUpVC_id") as? AlertPopUpVC ?? AlertPopUpVC()
    }
    
    var errorPopupVC: ErrorPopupVC {
        AppStoryBoard.shared.common.instantiateViewController(withIdentifier: "ErrorPopupVC_id") as? ErrorPopupVC ?? ErrorPopupVC()
    }
    // MARK: - Home
    var home: HomeVC {
        AppStoryBoard.shared.home.instantiateViewController(withIdentifier: "HomeVC_id") as? HomeVC ?? HomeVC()
    }
    var search: SearchVC {
        AppStoryBoard.shared.search.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC ?? SearchVC()
    }
    var changepassword: ChangePasswordVC {
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "ChangePasswordVC_id") as? ChangePasswordVC ?? ChangePasswordVC()
    }
    
    var shareWishlist: SharePopupVC {
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "SharePopupVC_id") as? SharePopupVC ?? SharePopupVC()
    }
    
    var forgotPassword: ForgotPasswordVC {
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "ForgotPasswordVC_id") as? ForgotPasswordVC ?? ForgotPasswordVC()
    }
    var menu: MenuVC {
        AppStoryBoard.shared.menu.instantiateViewController(withIdentifier: "MenuVC_id") as? MenuVC ?? MenuVC()
    }
    var menuPLP: MenuCategoryPLP {
        AppStoryBoard.shared.menu.instantiateViewController(withIdentifier: "MenuCategoryPLP_id") as? MenuCategoryPLP ?? MenuCategoryPLP()
    }
    // MARK: - Profile
    var profile: ProfileVC {
        
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "ProfileVC_id") as? ProfileVC ?? ProfileVC()
    }
    var filter: FilterVC {
        AppStoryBoard.shared.common.instantiateViewController(withIdentifier: "FilterVC_id") as? FilterVC ?? FilterVC()
    }
    var sort: SortVC {
        AppStoryBoard.shared.common.instantiateViewController(withIdentifier: "SortVC_id") as? SortVC ?? SortVC()
    }
    var loginRegister: LoginRegisterVC {
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "LoginRegisterVC_id") as? LoginRegisterVC ?? LoginRegisterVC()
    }
    var myProfile: MyProfileVC {
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "MyProfileVC_id") as? MyProfileVC ?? MyProfileVC()
    }
    var mycart: MyCartVC {
        AppStoryBoard.shared.mycart.instantiateViewController(withIdentifier: "MyCartVC_id") as? MyCartVC ?? MyCartVC()
    }
    var deliveryOptions: AdressListVC {
        AppStoryBoard.shared.mycart.instantiateViewController(withIdentifier: "AdressListVC_id") as? AdressListVC ?? AdressListVC()
    }
    var Room: RoomVC {
        AppStoryBoard.shared.home.instantiateViewController(withIdentifier: "RoomVC_id") as? RoomVC ?? RoomVC()
    }
    var myWishlist: MyWishlistVC {
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "MyWishlistVC_id") as? MyWishlistVC ?? MyWishlistVC()
    }
    var myNotification: NotificationViewController {
        AppStoryBoard.shared.notification.instantiateViewController(withIdentifier: "NotificationViewController_id") as? NotificationViewController ?? NotificationViewController()
    }
    var cellNotification: NotificationCellVC {
        AppStoryBoard.shared.profile.instantiateViewController(withIdentifier: "NotificationCellVC") as? NotificationCellVC ?? NotificationCellVC()
    }
    var myPlp: PLPController{
        AppStoryBoard.shared.plp.instantiateViewController(withIdentifier: "PLPController") as? PLPController ?? PLPController()
    }
    var web: AppWebViewVC{
        AppStoryBoard.shared.web.instantiateViewController(withIdentifier: "AppWebViewVC_id") as? AppWebViewVC ?? AppWebViewVC()
        
    }
    
    var productDetailsImages: ProductDetailsImagesVC {
        AppStoryBoard.shared.productDetails.instantiateViewController(withIdentifier: "ProductDetailsImagesVC_id") as? ProductDetailsImagesVC ?? ProductDetailsImagesVC()
    }
    var productDetails: ProductDetailsVC {
        AppStoryBoard.shared.productDetails.instantiateViewController(withIdentifier: "ProductDetailsVC_id") as? ProductDetailsVC ?? ProductDetailsVC()
    }
    var homePdp: HomePdpVC {
        AppStoryBoard.shared.productDetails.instantiateViewController(withIdentifier: "HomePdpVC_id") as?
        HomePdpVC ?? HomePdpVC()
    }
    var productDetailsNew: ProductDetailsNewVC {
        AppStoryBoard.shared.productDetails.instantiateViewController(withIdentifier: "ProductDetailsNewVC_id") as? ProductDetailsNewVC ?? ProductDetailsNewVC()
    }
    var addCartSucces: AddToCartSuccessPopUpVC {
        AppStoryBoard.shared.productDetails.instantiateViewController(withIdentifier: "AddToCartSuccessPopUpVC") as? AddToCartSuccessPopUpVC ?? AddToCartSuccessPopUpVC()
    }
    // Mark MHIOS-1099
    var openActionSheet: ActionSheetViewController {
        AppStoryBoard.shared.web.instantiateViewController(withIdentifier: "ActionSheetViewController") as? ActionSheetViewController ?? ActionSheetViewController()
    }
    // Mark MHIOS-1099
    var addAddress: AddAddressVC {
        AppStoryBoard.shared.address.instantiateViewController(withIdentifier: "AddAddressVC_id") as? AddAddressVC ?? AddAddressVC()
    }
    var deliveryTime: DeliveryTimeVC {
        AppStoryBoard.shared.address.instantiateViewController(withIdentifier: "DeliveryTimeVC_id") as? DeliveryTimeVC ?? DeliveryTimeVC()
    }
    var checkout: CheckoutVC {
        AppStoryBoard.shared.checkout.instantiateViewController(withIdentifier: "CheckoutVC_id") as? CheckoutVC ?? CheckoutVC()
    }
    var checkoutPayment: CheckoutPaymentVC {
        AppStoryBoard.shared.checkout.instantiateViewController(withIdentifier: "CheckoutPaymentVC_id") as? CheckoutPaymentVC ?? CheckoutPaymentVC()
    }
    var orderSuccess: OrderSuccessVC {
        AppStoryBoard.shared.checkout.instantiateViewController(withIdentifier: "OrderSuccessVC_id") as? OrderSuccessVC ?? OrderSuccessVC()
    }
    var orderList: OrderListVC {
        AppStoryBoard.shared.order.instantiateViewController(withIdentifier: "OrderListVC_id") as? OrderListVC ?? OrderListVC()
    }
    var guestOrdertrack: GuestOrderTrackingVC {
        AppStoryBoard.shared.order.instantiateViewController(withIdentifier: "GuestOrderTrackingVC") as? GuestOrderTrackingVC ?? GuestOrderTrackingVC()
    }
    var orderDetail: OrderDetailVC {
        AppStoryBoard.shared.order.instantiateViewController(withIdentifier: "OrderDetailVC_id") as?  OrderDetailVC ??  OrderDetailVC()
    }
    var paymentCards: PaymentCardsVC {
        AppStoryBoard.shared.paymentCards.instantiateViewController(withIdentifier: "PaymentCardsVC_id") as?  PaymentCardsVC ??  PaymentCardsVC()
    }
    var addPaymentCard: AddPaymentCardVC {
        AppStoryBoard.shared.paymentCards.instantiateViewController(withIdentifier: "AddPaymentCardVC_id") as?  AddPaymentCardVC ??  AddPaymentCardVC()
    }
    var paymentCardDelete: PaymentCardDeleteVC {
        AppStoryBoard.shared.paymentCards.instantiateViewController(withIdentifier: "PaymentCardDeleteVC_id") as?  PaymentCardDeleteVC ??  PaymentCardDeleteVC()
    }
    var orderReturn: ReturnRequestVC {
        AppStoryBoard.shared.orderReturn.instantiateViewController(withIdentifier: "ReturnRequestVC_id") as?  ReturnRequestVC ??  ReturnRequestVC()
    }
    var returnRequestResponse: ReturnRequestResponseVC {
        AppStoryBoard.shared.orderReturn.instantiateViewController(withIdentifier: "ReturnRequestResponseVC_id") as?  ReturnRequestResponseVC ??  ReturnRequestResponseVC()
    }
    var returnOrderTracking: ReturnOrderTrackingVC {
        AppStoryBoard.shared.orderReturn.instantiateViewController(withIdentifier: "ReturnOrderTrackingVC_id") as?  ReturnOrderTrackingVC ??  ReturnOrderTrackingVC()
    }
    var threeDee:ThreeDeeVC {
        AppStoryBoard.shared.productDetails.instantiateViewController(withIdentifier: "ThreeDeeVC_id") as?  ThreeDeeVC ??  ThreeDeeVC()
    }
    var returnRequestCancel: ReturnRequestCancelVC {
        AppStoryBoard.shared.orderReturn.instantiateViewController(withIdentifier: "ReturnRequestCancelVC_id") as?  ReturnRequestCancelVC ??  ReturnRequestCancelVC()
    }
    //Mark MHIOS-1158
    var forceUpdate: ForceUpdateViewController {
        AppStoryBoard.shared.home.instantiateViewController(withIdentifier: "ForceUpdateViewController") as?  ForceUpdateViewController ??  ForceUpdateViewController()
    }
    //Mark MHIOS-1158
    // Mark MHIOS-710
    var pushVC: PushNotificationPopupVC {
        AppStoryBoard.shared.push.instantiateViewController(withIdentifier: "PushNotificationPopupVC") as? PushNotificationPopupVC ?? PushNotificationPopupVC()
    }
    // Mark MHIOS-710
//    var productDetailsNew: ProductDetailsNewVC {
//        AppStoryBoard.shared.order.instantiateViewController(withIdentifier: "ProductDetailsNewVC_id") as?  ProductDetailsNewVC ?? ProductDetailsNewVC()
//    }
    
//    var productDetailsNew: ProductDetailsNewVC {
//        AppStoryBoard.shared.productDetails.instantiateViewController(withIdentifier: "ProductDetailsNewVC_id") as? ProductDetailsNewVC ?? ProductDetailsNewVC(coder: <#NSCoder#>)!
//    }
}


