//
//  LoginRegisterVM.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit
import Alamofire
import Adjust
extension LoginRegisterVC {

    func apiLogin(parameters: Parameters, handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.authenticate
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH LOGIN STATUS IS MAIN URL : \(completeUrl)")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        // Mark MHIOS-1130
                        let event1 = ADJEvent(eventToken: AdjustEventType.Login.rawValue)
                        Adjust.trackEvent(event1)
                        // Mark MHIOS-1130
                        print("SANTHOSH LOGIN STATUS IS MAIN success : ")
                        guard let data = response.value as? String else { return }
                        handler?(data)
                    case .failure(_):
                        print("SANTHOSH LOGIN STATUS IS MAIN failure : ")
                        guard let data = response.data else { return }
                        
                        do {
                            let apiError = try JSONDecoder().decode(errorMesgModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "\(apiError.message)",type: "error")
          
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            print("SANTHOSH LOGIN STATUS IS MAIN catch : ")
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiLogin(parameters: parameters)
            }, leftAction: {})
        }
    }

    func apiRegister(parameters: Parameters, handler:((UserModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.register
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: UserModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        // Mark MHIOS-1130
                        let event1 = ADJEvent(eventToken: AdjustEventType.Registration.rawValue)
                        Adjust.trackEvent(event1)
                        // Mark MHIOS-1130
                        guard let data = response.value as? UserModel else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorMesgModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "\(apiError.message)",type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiRegister(parameters: parameters)
            }, leftAction: {})
        }
    }

    func apiUser(handler:((UserModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.user
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: UserModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? UserModel else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiUser()
            }, leftAction: {})
        }
    }

//    func apiForgotPassword(parameters: Parameters, handler:((Bool) -> Void)? = nil){
//        self.view.endEditing(true)
//        let api = Api.shared.forgotPassword
//        if Network.isAvailable() {
//            self.showActivityIndicator(uiView: self.view)
//            var completeUrl = AppInfo.shared.baseURL + api.url
//            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
//            var headers: HTTPHeaders = [:]
//            headers["Content-Type"] = api.contentType.rawValue
//            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//                .responseDecodable(of: Bool.self) { response in
//                    self.hideActivityIndicator(uiView: self.view)
//                    switch response.result {
//                    case .success(_):
//                        guard let data = response.value as? Bool else { return }
//                        handler?(data)
//                    case .failure(_):
//                        guard let data = response.data else { return }
//                        do {
//                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
//                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
//                            print(String(data: data, encoding: String.Encoding.utf8))
//                        } catch {
//                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
//                        }
//                    }
//                }
//        }else{
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//                self.apiForgotPassword(parameters: parameters)
//            }, leftAction: {})
//        }
//    }

    func apiGoogleLogin(parameters: Parameters, handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        //social/login
        print("SANTHOSH parameters")
        print(parameters)
        let api = Api.shared.googleLogin
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    print("SANTHOSH MAIAN RESP : ")
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        // Mark MHIOS-1130
                        let event1 = ADJEvent(eventToken: AdjustEventType.Login.rawValue)
                        Adjust.trackEvent(event1)
                        // Mark MHIOS-1130
                        guard let data = response.value as? String else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiGoogleLogin(parameters: parameters)
            }, leftAction: {})
        }
    }
    func apiMigrateLoginCartToUser(parameters: Parameters, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(appDelegate.guestCartId)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiLogin(parameters: parameters)
            }, leftAction: {})
        }
    }
    func apiAddToWishlist(id:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(id)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    //MARK START{MHIOS-1029}
    func apiMigrateWishlist(id:String,handler:((Bool) -> Void)? = nil){
        print("SANTHOSH WISHLIST MERGE START VM OK")
        self.view.endEditing(true)
        let api = Api.shared.migrateWishlist ////V2/wishlist/:customerId/items/add
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL2 + api.url + "\(id)/items/add"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            
            var wishListItems = [] as [Any]
            for i in (0..<UserData.shared.wishListIdArray.count)
            {
                let value = UserData.shared.wishListIdArray[i]
                let valueIs = [
                    "id": "\(value.product_id)",
                    "sku" :value.sku,
                    "quantity": 1.0,
                    "parentSku" : "",
                    "description": ""
                ] as [String : Any]
                
                wishListItems.append(valueIs)
            }
            let parameters = [
                "wishListItems": wishListItems]
            
            print("SANTHOSH WISHLIST PARAM OK : \(parameters)")
            print("SANTHOSH WISHLIST URL OK : \(completeUrl)")
            print(parameters)
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    print("SANTHOSH WISHLIST response OK : \(response.value)")
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        } catch {
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    //MARK END{MHIOS-1029}
    //MARK START{MHIOS-1181}
    func apiWishlist(handler:(([WishlistModel]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.getWishlist
        if Network.isAvailable() {
            //self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [WishlistModel].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? [WishlistModel] else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            if(response.response?.statusCode==401)
                            {
                                self.hideActivityIndicator(uiView: self.view)
                                UserData.shared.ClearAllData()
                                UserData.shared.isLoggedIn = false
                                //GIDSignIn.sharedInstance.signOut()
                                let userDefaults = UserDefaults.standard
                                userDefaults.removeObject(forKey: "GuestCart")
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.guestCartId = ""
                                return
                            }
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                           //MARK: END MHIOS-1285
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                        }
                    }
                }
        }else{
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//                self.apiWishlist(handler: handler)
//            }, leftAction: {})
        }
    }
    //MARK END{MHIOS-1181}

}
