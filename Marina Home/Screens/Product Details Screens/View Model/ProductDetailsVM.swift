//
//  ProductDetailsVM.swift
//  Marina Home
//
//  Created by Codilar on 16/05/23.
//

import Foundation
import Alamofire
extension ProductDetailsImagesVC {
    func apiProductDetails(productID:String, handler:((ProductDetailsModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.productDetails
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + productID
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: ProductDetailsModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? ProductDetailsModel else { return }
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
                            self.toastView(toastMessage: "Product details are not available at this time. Please try after some time",type: "error")
                            self.navigationController?.popToRootViewController(animated: true)
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Product details are not available at this time. Please try after some time",type: "error")
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {

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
                    print("SANTHOSH RESULT IS ")
                    print(response.result)
                    print(response.data)
                    print(response)
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
    
    func apiCreateCart( handler:((Int) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.createCart
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
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

extension ProductDetailsVC {
    func apiAddToCart(parameters: Parameters, handler:((CartItem) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addToCart
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CartItem.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? CartItem else { return }
                        
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
                self.apiAddToCart(parameters: parameters)
            }, leftAction: {})
        }
    }

    func apiToLogError(parameters: Parameters, handler:(() -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.printError
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default)
                .response { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        handler?()
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
                self.apiToLogError(parameters: parameters)
            }, leftAction: {})
        }
    }
    
    func apiCreateCart( handler:((Int) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.createCart
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
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

    func apiCarts( handler:((Cart) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.mycart
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
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

    func apiProductRecommended(id:Int,url:String, token:String, handler:((RecommendedProductsModel) -> Void)? = nil){
        self.view.endEditing(true)
        let typeOfRecords:[String] = ["KLEVU_PRODUCT"]
        let apiKeys:[String] = [token]
        let records:[String:Any] = ["id": id]
        let recentObjects:[String:Any] = ["typeOfRecord": "KLEVU_PRODUCT","records": [records]]
        let recordQueries:[String:Any] = [
            "id": "recsSimilar",
            "typeOfRequest": "RECS_SIMILAR",
            "settings": ["context": ["recentObjects": [recentObjects]],"typeOfRecords": typeOfRecords]]
        let parameter:Parameters = [
            "recordQueries": [recordQueries],
            "context": ["apiKeys": apiKeys]]
        if Network.isAvailable() {
            ///self.showActivityIndicator(uiView: self.view)
            var completeUrl = url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = "Bearer \(token)"
            AF.request(completeUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: RecommendedProductsModel.self) { response in
                    ///self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? RecommendedProductsModel else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiProductRecommended(id: id, url: url, token: token, handler: handler)
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
    
    // MARK: - GUEST FLOW
    func apiCreateGuestCart( handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.CreateGuestCart
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
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
                                self.addToCart()
                            }
                        }
                        else
                        {
                            guard let data = response.value else { return }
                            handler?(data)
                        }
                    case .failure(_):
                        //MARK: START MHIOS-1285
                       SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                       //MARK: END MHIOS-1285
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
                                self.addToCart()
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
                self.apiAddToCart(parameters: parameters)
            }, leftAction: {})
        }
    }
    
    
}
extension ProductDetailsImagesVC {
    func apiAddToCart(parameters: Parameters, handler:((CartItem) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addToCart
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CartItem.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? CartItem else { return }
                        
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
                self.apiAddToCart(parameters: parameters)
            }, leftAction: {})
        }
    }
    

    func apiCarts( handler:((Cart) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.mycart
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
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

    func apiProductRecommended(id:Int,url:String, token:String, handler:((RecommendedProductsModel) -> Void)? = nil){
        self.view.endEditing(true)
        let typeOfRecords:[String] = ["KLEVU_PRODUCT"]
        let apiKeys:[String] = [token]
        let records:[String:Any] = ["id": id]
        let recentObjects:[String:Any] = ["typeOfRecord": "KLEVU_PRODUCT","records": [records]]
        let recordQueries:[String:Any] = [
            "id": "recsSimilar",
            "typeOfRequest": "RECS_SIMILAR",
            "settings": ["context": ["recentObjects": [recentObjects]],"typeOfRecords": typeOfRecords]]
        let parameter:Parameters = [
            "recordQueries": [recordQueries],
            "conteRecommendedProductsModelxt": ["apiKeys": apiKeys]]
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = "Bearer \(token)"
            AF.request(completeUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: RecommendedProductsModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? RecommendedProductsModel else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiProductRecommended(id: id, url: url, token: token, handler: handler)
            }, leftAction: {})
        }
    }

   /* func apiAddToWishlist(id:String,handler:((Bool) -> Void)? = nil){
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
    }*/
    
    
    
    // MARK: - GUEST FLOW
    func apiCreateGuestCart( handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.CreateGuestCart
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
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
                        guard let data = response.value as? CartItem else { return }
                        
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
                self.apiAddToCart(parameters: parameters)
            }, leftAction: {})
        }
    }
    
     
}
