//
//  MyWishlistVM.swift
//  Marina Home
//
//  Created by Codilar on 26/05/23.
//

import UIKit
import Alamofire
extension MyWishlistVC {

    func apiWishlist(handler:(([WishlistModel]) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.getWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [WishlistModel].self) { response in
                    print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? [WishlistModel] else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
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
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiWishlist(handler: handler)
            }, leftAction: {})
        }
    }
    //MARK START{MHIOS-1029}
    // MARK: - GUEST FLOW
    func apiCreateGuestCart( handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.CreateGuestCart
        if Network.isAvailable() {
            
           // self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        } catch {
                           // self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//
//            }, leftAction: {})
        }
    }
    func apiGuestCarts( handler:((Cart) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
           
           
            var completeUrl = AppInfo.shared.baseURL + api.url+"\(appDelegate.guestCartId)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Cart.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    
                    switch response.result {
                        
                    case .success(_):
                        if(response.response?.statusCode == 404)
                        {
                            self.apiCreateGuestCart(){
                                response in

                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.guestCartId = response
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(response, forKey: "GuestCart")
                                //self.addToCart()
                            }
                        }
                        else
                        {
                            guard let data = response.value else { return }
                            handler?(data)
                        }
                    case .failure(_):
                        if(response.response?.statusCode == 404)
                        {
                            self.apiCreateGuestCart(){
                                response in

                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.guestCartId = response
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(response, forKey: "GuestCart")
                                
                            }
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
    
    func apiAddToGuestCart(parameters: Parameters, handler:((CartItem) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
           
           
            var completeUrl = AppInfo.shared.baseURL + api.url+"\(appDelegate.guestCartId)/items"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CartItem.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        if(response.response?.statusCode == 404)
                        {
                            self.apiCreateGuestCart(){
                                response in

                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.guestCartId = response
                                //self.addToCart()
                            }
                        }
                        else
                        {
                            guard let data = response.value as? CartItem else { return }
                            handler?(data)
                        }
                        
                       
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
                //self.apiAddToCart(parameters: parameters)
            }, leftAction: {})
        }
    }
    
    func apiGuestWishlist(handler:(([WishlistModel]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.getGuestWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            print("SANTHOSH CART GUEST URL \(UserData.shared.wishListIdArray)")
            var productId = "\(UserData.shared.wishListIdArray.map {$0.product_id} )"
            productId = productId.replacingOccurrences(of: " ", with: "")
            productId = productId.replacingOccurrences(of: "[", with: "")
            productId = productId.replacingOccurrences(of: "]", with: "")
            
            var completeUrl = AppInfo.shared.baseURL + api.url + "?searchCriteria[filter_groups][0][filters][0][field]=entity_id&searchCriteria[filter_groups][0][filters][0][value]=\(productId)&searchCriteria[filter_groups][0][filters][0][condition_type]=in"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //headers["Authorization"] = "Bearer \(UserData.shared.guestCartId)"
            print("SANTHOSH GET GUEST URL \(completeUrl)")
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [WishlistModel].self) { response in
                    print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? [WishlistModel] else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        } catch {
                           // self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiWishlist(handler: handler)
            }, leftAction: {})
        }
    }
    func apiGuestMoveProductFromWishlistToCart(quote_id:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.moveGuestWishlistToCart
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var wishListItems = [] as [Any]
            for i in (0..<UserData.shared.wishListIdArray.count)
            {
                let value = UserData.shared.wishListIdArray[i]
                let valueIs = [
                    "sku" :value.sku,
                    "qty": 1.0,
                    "quote_id" : quote_id,
                ] as [String : Any]
                
                wishListItems.append(valueIs)
            }
            let parameters = [
                "cartItems": wishListItems]
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    print("SANTHOSH RESP WISHLIST \(response)")
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        ///guard let data = response.value as? [WishlistModel] else { return }
                        handler?(true)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do
                        {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        }
                        catch
                        {
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiMoveProductFromWishlistToCart()
            }, leftAction: {})
        }
    }
    //MARK END{MHIOS-1029}
    func apiMoveProductFromWishlistToCart(handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.moveWishlistToCArt
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    print("SANTHOSH RESP WISHLIST \(response)")
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        ///guard let data = response.value as? [WishlistModel] else { return }
                        handler?(true)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do
                        {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        }
                        catch
                        {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiMoveProductFromWishlistToCart()
            }, leftAction: {})
        }
    }
    
    func apiShareWishlist(email:String,message:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.shareWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url+"?recipient_emails=\(email)&message=\(message)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    ///print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        ///guard let data = response.value as? [WishlistModel] else { return }
                        handler?(true)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do
                        {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message,type: "error")
                        }
                        catch
                        {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiMoveProductFromWishlistToCart()
            }, leftAction: {})
        }
    }

    func apiMoveWishToCart(id:String,qty:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.moveFromWishToCart
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(id)?qty=\(qty)"
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
                self.apiMoveWishToCart(id: id, qty: qty, handler: handler)
            }, leftAction: {})
        }
    }

    func apiRemoveProduct(id:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.removeFromWishlist
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
                self.apiRemoveProduct(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    
    func apiCarts( handler:((Cart) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.mycart
        if Network.isAvailable() {
            
            //self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Cart.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
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
                
            }, leftAction: {})
        }
    }
    func apiCreateCart( handler:((Int) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.createCart
        if Network.isAvailable() {
            
           // self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Int.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
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
                
            }, leftAction: {})
        }
    }
}



