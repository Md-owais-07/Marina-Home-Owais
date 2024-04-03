//
//  ApiList.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import Foundation
final class Api {

    static let shared = Api()

    // MARK: - ONBOARDING SCREENS
    var authenticate: ApiModel {
        return ApiModel(method: .post, url: "integration/customer/token")
    }
    var logOut: ApiModel {
        return ApiModel(method: .get, url: "eflp4e")
    }
    var storePushToken: ApiModel {
        return ApiModel(method: .post, url: "pushnotifications/register")
    }
    var categories: ApiModel {
        return ApiModel(method: .get, url: "categories")
    }
    var register: ApiModel {
        return ApiModel(method: .post, url: "customers")
    }
    var newsletterSubscribe: ApiModel {
        return ApiModel(method: .put, url: "customers/")
    }
    var chnagePasswod: ApiModel {
        return ApiModel(method: .put, url: "customers/me/password")
    }
    
    var googleLogin: ApiModel {
        return ApiModel(method: .post, url: "social/login")
    }
    var user: ApiModel {
        return ApiModel(method: .get, url: "customers/me")
    }
    var revokeApple: ApiModel {
        return ApiModel(method: .post, url: "revoke/apple/code")
    }
    var forgotPassword: ApiModel {
        return ApiModel(method: .put, url: "customers/password")
    }
    var listProduct: ApiModel {
        return ApiModel(method: .get, url: "products?searchCriteria")
    }
    var listProductCategory: ApiModel {
        return ApiModel(method: .get, url: "products?")
    }
    var searchProducts: ApiModel {
        return ApiModel(method: .get, url: "product/search?")
    }
    //MARK: START MHIOS-967
    var getAllNotification: ApiModel {
        return ApiModel(method: .get, url: "customer/notification/all?")
    }
    var getAllguestNotification: ApiModel {
        return ApiModel(method: .get, url: "klaviyo/customer/notifications?")
    }
    //MARK: END MHIOS-967
    var adminToken: ApiModel {
        return ApiModel(method: .post, url: "integration/admin/token")
    }
    var deleteAccout: ApiModel {
        return ApiModel(method: .delete, url: "customers/")
    }
    var filterOptions: ApiModel {
        return ApiModel(method: .get, url: "category/")
    }
    var cmsPage: ApiModel {
        return ApiModel(method: .get, url: "cmsPage")
    }
    var productDetails: ApiModel {
        return ApiModel(method: .get, url: "products/")
    }
    var addToCart: ApiModel {
        return ApiModel(method: .post, url: "carts/mine/items")
    }
    var mycart: ApiModel {
        return ApiModel(method: .get, url: "carts/mine")
    }
    var createCart: ApiModel {
        return ApiModel(method: .post, url: "carts/mine")
    }
    var deliveryTimes: ApiModel {
        return ApiModel(method: .get, url: "carts/mine/shipping-methods")
    }
    //MARK START{MHIOS-403}
    var updateUserDetails: ApiModel {
        return ApiModel(method: .put, url: "customers/me")
    }
    //MARK END{MHIOS-403}
    var deliveryOptions: ApiModel {
        return ApiModel(method: .get, url: "customers/me")
    }
    var removeCartItem: ApiModel {
        return ApiModel(method: .delete, url: "carts/mine/items/")
    }
    var chnageCartItemQuntity: ApiModel {
        return ApiModel(method: .put, url: "carts/mine/items/")
    }
    
    var applyCoupenCode: ApiModel {

           return ApiModel(method: .put, url: "carts/mine/coupons/")

       }
    //MARK: START MHIOS-1129
    var removeInstantDiscount: ApiModel {

           return ApiModel(method: .delete, url: "cart/instant_discount")

       }
    var removeGuestInstantDiscount: ApiModel {

           return ApiModel(method: .delete, url: "guest_cart/instant_discount")

       }
    //MARK: END MHIOS-1129
       var guestApplyCoupenCode: ApiModel {

           return ApiModel(method: .put, url: "guest-carts/")

       }

       var guestRemoveCoupenCode: ApiModel {

           return ApiModel(method: .delete, url: "guest-carts/")

       }

       var removeCoupenCode: ApiModel {

           return ApiModel(method: .delete, url: "carts/mine/coupons/")

       }
    var grandTotalMine: ApiModel {
        return ApiModel(method: .get, url: "carts/mine/totals")
    }
    var addOrUpdateAddress: ApiModel {
        return ApiModel(method: .post, url: "addresses")
    }
    var deleteAddress: ApiModel {
        return ApiModel(method: .delete, url: "addresses/")
    }
    var addShipmentInformations: ApiModel {
        return ApiModel(method: .post, url: "carts/mine/shipping-information")
    }
    var addBillingAddress: ApiModel {
        return ApiModel(method: .post, url: "carts/mine/billing-address")
    }
    var placeOrder: ApiModel {
        return ApiModel(method: .put, url: "carts/mine/order")
    }
    var orderInvoice: ApiModel {
        return ApiModel(method: .post, url: "order/")
    }
    var paymentOptions: ApiModel {
        return ApiModel(method: .get, url: "carts/mine/payment-information")
    }
    var paymentMethods: ApiModel {
        return ApiModel(method: .get, url: "carts/mine/shipping-methods")
    }
    var orderUpdate: ApiModel {
        return ApiModel(method: .post, url: "sales/add/transaction")
    }
    var getWishlist: ApiModel {
        return ApiModel(method: .get, url: "wishlist/product")
    }
    //MARK START{MHIOS-1029}
    var getGuestWishlist: ApiModel {
        return ApiModel(method: .get, url: "wishlist/guest/product")
    }
    var migrateWishlist: ApiModel {
        return ApiModel(method: .post, url: "wishlist/")
    }
    var moveGuestWishlistToCart: ApiModel {
        return ApiModel(method: .post, url: "wishlist/add/items/guest/cart")
    }
    //MARK END{MHIOS-1029}
    var moveWishlistToCArt: ApiModel {
        return ApiModel(method: .post, url: "wishlist/add/all/cart")
    }
    var shareWishlist: ApiModel {
        return ApiModel(method: .post, url: "share/wishlist-details")
    }
    var shareCartlist: ApiModel {
        return ApiModel(method: .post, url: "app/share_cart/via/email")
    }
    var shareCartlistViaUrl: ApiModel {
        return ApiModel(method: .post, url: "app/share_cart/via/url")
    }
    //MARK START{MHIOS-1025} SANTHOSH
    var shareCartlistGuestViaUrl: ApiModel {
        return ApiModel(method: .post, url: "app/guest/share_cart/via/url")
    }
    //MARK END{MHIOS-1025} SANTHOSH
    var shareCartlistViaWhatsApp: ApiModel {
        return ApiModel(method: .post, url: "app/share_cart/via/whatsApp")
    }
    var shareCartlistMerge: ApiModel {
        return ApiModel(method: .post, url: "share_cart/via/url/cart/items")//rest/V2/share_cart/via/url/cart/items
    }
    var addToWishlist: ApiModel {
        return ApiModel(method: .post, url: "wishlist/product/")
    }
    var removeFromWishlist: ApiModel {
        return ApiModel(method: .delete, url: "wishlist/product/")
    }
    var removeAllWishlist: ApiModel {
        return ApiModel(method: .delete, url: "wishlist")
    }
    var moveFromWishToCart: ApiModel {
        return ApiModel(method: .post, url: "wishlist/move/cart/")
    }
    // MARK: - GUEST APIS
    var CreateGuestCart: ApiModel {
        return ApiModel(method: .post, url: "guest-carts")
    }
    var guestCartbase: ApiModel {
        return ApiModel(method: .post, url: "guest-carts/")
    }
    
    var guestRemoveCartbase: ApiModel {
        return ApiModel(method: .delete, url: "guest-carts/")
        //https://marina-dev.codilar.in/en-uae/rest/V1/guest-carts/DZUBi6LwsNpeAQC9gnRXn0obwHfJwBsG/items/46500
    }
    //MARK: START MHIOS-967
    var readNotification: ApiModel {
        return ApiModel(method: .post , url: "customer/notification/read?")
    }
    //MARK: END MHIOS-967
    var listOrder: ApiModel {
        return ApiModel(method: .get, url: "orders")
    }
    //MARK START{MHIOS-872}
    var popularSearch: ApiModel {
        return ApiModel(method: .get, url: "popular/searches")
    }
    //MARK END{MHIOS-872}
    //MARK: START MHIOS-1281
    var checkFirstSale: ApiModel {
        return ApiModel(method: .post, url: "check/first_order")
    }
    //MARK: END MHIOS-1281
    var guestOrders: ApiModel {
        return ApiModel(method: .get, url: "fetch/guest-order")
    }
    
    var moveToWishlist: ApiModel {
        return ApiModel(method: .post, url: "carts/mine/move-to-wishlist/")
    }
    var addPyamentCard: ApiModel {
        return ApiModel(method: .post, url: "store/card/details")
    }

    var getPyamentCards: ApiModel {
        return ApiModel(method: .get, url: "fetch/card/details")
    }

    var deletePyamentCard: ApiModel {
        return ApiModel(method: .delete, url: "delete/card?hashValue=")
    }
    var returnReasons: ApiModel {
        return ApiModel(method: .get, url: "mpRMA/config/rma-information")
    }

    var submitReturn: ApiModel {
        return ApiModel(method: .post, url: "mpRMA/mine/requests")
    }
    //MARK: START MHIOS-960
    var submitReturnGuest: ApiModel {
        return ApiModel(method: .post, url: "mpRMA/guest/requests")
    }
    //MARK: END MHIOS-960

    var ReturnRequestInfo: ApiModel {
        return ApiModel(method: .post, url: "order/return/info")
    }
    
    var returnDetails: ApiModel {
        return ApiModel(method: .get, url: "mpRMA/mine/requests?")
    }
    //MARK: START MHIOS-960
    var returnDetailsGuest: ApiModel {
        return ApiModel(method: .get, url: "mpRMA/guest/requests?")
    }
    //MARK: END MHIOS-960
    var returnReqCancel: ApiModel {
        return ApiModel(method: .post, url: "mpRMA/mine/requests/cancel")
    }
    //MARK: START MHIOS-960
    var returnReqCancelGuest: ApiModel {
        return ApiModel(method: .post, url: "mpRMA/guest/requests/cancel")
    }
    //MARK: END MHIOS-960
    var returnTracking: ApiModel {
        return ApiModel(method: .get, url: "mpRMA/status/?")
    }
    var printError: ApiModel {
        return ApiModel(method: .post, url: "print/message")
    }
    // Mark MHIOS-1158
    var forceUpdate: ApiModel {
        return ApiModel(method: .get, url: "app/update?")
    }
    // Mark MHIOS-1158
    // MARK: START MHIOS-1035
    var adminData: ApiModel {
        return ApiModel(method: .get, url: "adminpanel_metadata")
    }
    // MARK: END MHIOS-1035
    //MARK: START MHIOS-973
    var enableDisablePush: ApiModel {
        return ApiModel(method: .post, url: "notification/status")
    }
    //MARK: END MHIOS-973

}
enum Urlsort {
    case HightToLow(String)
    case LowToHight(String)
    case NewIn(String)
    case Relevence(String)
    
    
    var rawUrl: String {
        switch self {
        case .LowToHight(let id):
            return "searchCriteria[sortOrders][0][field]=price&searchCriteria[sortOrders][0][direction]=ASC"
        case .HightToLow(let id):
            return "searchCriteria[sortOrders][0][field]=price&searchCriteria[sortOrders][0][direction]=DESC"
        case .NewIn(let id):
            return "searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC"
        case .Relevence(let id):
            return "searchCriteria[sortOrders][0][field]=personalized&searchCriteria[sortOrders][0][direction]=DESC"
 
        }
    }

   
   
}

enum UrlSearchsort {
    case HightToLow(String)
    case LowToHight(String)
    case NewIn(String)
    case Relevence(String)
    
    
    var rawUrl: String {
        switch self {
        case .LowToHight(let id):
            return "searchCriteria[sortOrders][0][field]=price&searchCriteria[sortOrders][0][direction]=ASC"
        case .HightToLow(let id):
            return "searchCriteria[sortOrders][0][field]=price&searchCriteria[sortOrders][0][direction]=DESC"
        case .NewIn(let id):
            return "searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC"
        case .Relevence(let id):
            return "searchCriteria[sortOrders][0][field]=personalized&searchCriteria[sortOrders][0][direction]=DESC"
 
        }
    }

   
   
}

