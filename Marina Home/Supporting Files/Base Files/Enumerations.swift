//
//  Enumerations.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import UIKit

enum AppAssets: String {
    case tabbar_home = "tabbar_home"
    case tabbar_menu = "tabbar_menu"
    case tabbar_profile = "tabbar_profile"
    case tabbar_my_cart = "tabbar_my_cart"
    case tabbar_shadow = "tabbar_shadow"
    case radioButton_icon = "radioButton_icon"
    case radioButtonSelected_icon = "radioButtonSelected_icon"
    case checkboxButton_icon = "checkboxButton_icon"
    case checkboxButton_Selected_icon = "checkboxButton_Selected_icon"
}

enum LoginRegisterFlag {
    case login
    case register
}

enum ApiStatusCode: Int{
   case noInternet  = 000
   case success = 200
   case badRequest = 400
   case unAuthorized = 401
   case sessionExpire = 403
   case unProcessableEntity = 422
   case serverFailure = 500
   case other = 900
}
enum ApiStatus: Int{
   case success = 0
   case noInternet = 1
   case apiError = 2
   case error = 3
}
enum ApiContentType: String {
   case json = "application/json"
   case formData = "application/x-www-form-urlencoded"
   case multipart = "multipart/form-data"
}
