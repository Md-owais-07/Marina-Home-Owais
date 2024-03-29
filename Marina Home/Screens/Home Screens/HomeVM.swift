//
//  HomeVM.swift
//  Marina Home
//
//  Created by Codilar on 27/04/23.
//

import Foundation
import Alamofire
import GoogleSignIn
import KlaviyoSwift
extension HomeVC {
    
    ///MARK START{MHIOS-1005}
    struct dataResult {
        let data: Result<Data, Error>
        let resp: Int
    }
    ///MARK END{MHIOS-1005}
    
    func GetHomeItems(fromURLString urlString: String,
                      completion: @escaping (dataResult) -> Void) { //,URLResponse
        if Network.isAvailable() {
            if let url = URL(string: urlString) {
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                config.urlCache = nil
                
                let urlSession = URLSession(configuration: config).dataTask(with: url) { (data, response, error) in
                    
                    guard let httpResponse = response as? HTTPURLResponse
                    else {
                        ///MARK START{MHIOS-1005}
                        let respp = response
                        print("Invalid response : \(response)")
                        
                        if let error = error {
                            let result = dataResult(data: .failure(error), resp: 404)
                            completion(result)
                            //completion(.failure(error),response)//
                        }
                        ///MARK END{MHIOS-1005}
                        
                            return
                    }
                    ///MARK START{MHIOS-1005}
                    let statusCode = httpResponse.statusCode
                    
                    
                    if let error = error {
                        let result = dataResult(data: .failure(error), resp: httpResponse.statusCode)
                        completion(result)
                        //completion(.failure(error),response)//
                    }
                    
                    if let data = data {
                        let result = dataResult(data: .success(data), resp: httpResponse.statusCode)
                        completion(result)
                        
                        //completion(.success(data),)//,response
                    }
                    
                    //MARK END{MHIOS-1005}
                }
                
                urlSession.resume()
            }
        }
        else
        {
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//                self.GetHomeItems(fromURLString: AppInfo.shared.homeURL) { (result) in
//
//                    DispatchQueue.main.async {
//                        switch result {
//                        case .success(let data):
//                            self.parse(jsonData: data)
//                            //self.splashView.isHidden = true
//                        case .failure(let error):
//                            print(error)
//                            self.splashView.isHidden = true
//                        }
//                    }
//
//
//
//                }
//            }, leftAction: {})
        }
        
    }
    func apiGetFooterLink(id:String, handler:((HomeFooterLink) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.cmsPage
        if Network.isAvailable() {
           
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "/\(id)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: HomeFooterLink.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? HomeFooterLink else { return }
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
                            
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                        }
                    }
                }
        }else{

        }
    }
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
                                GIDSignIn.sharedInstance.signOut()
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
//
//            }, leftAction: {})
        }
    }
    func apiGuestCarts( handler:((Cart) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        if Network.isAvailable() {
            
           // self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url+"\(self.guestCartId)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH GET CART DATA IS ")
            print(completeUrl)
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
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
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                        }
                    }
                }
        }else{
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//
//            }, leftAction: {})
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
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                        }
                    }
                }
        }else{
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//
//            }, leftAction: {})
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
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//
//            }, leftAction: {})
        }
    }
    
    func apiMergeCartItems(quoteId:Int,uniqueId:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.shareCartlistMerge
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            
            let name = "\(UserData.shared.firstName) \(UserData.shared.lastName)"
            
            let parameter:Parameters = [
                "current_quote_id" : quoteId,
                "unique_id" : uniqueId
            ]
            
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method,parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    ///print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do
                        {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        }
                        catch
                        {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiMergeCartItems(quoteId: quoteId, uniqueId: uniqueId)
            }, leftAction: {})
        }
    }
    // Mark MHIOS-1158
    func apiForceUpdateStatus(id:String, handler:((ForceUpdate) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.forceUpdate
        if Network.isAvailable() {
            var completeUrl = AppInfo.shared.baseURL2 + api.url + "customerAppVersion=\(id)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: ForceUpdate.self) { response in
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
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                          
                        }
                    }
                }
        }else{

        }
    }
    // Mark MHIOS-1158
    
    
    // MARK: START MHIOS-1035
    func apiAdminMetadata(handler:((AdminData) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.adminData
        //MARK: START MHIOS-1312
        self.showActivityIndicator(uiView: self.view)
        //MARK: END MHIOS-1312

        if Network.isAvailable() {
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: AdminData.self) { response in
                    //MARK: START MHIOS-1312
                    self.hideActivityIndicator(uiView: self.view)
                    //MARK: END MHIOS-1312
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
                        } catch {
                          
                        }
                    }
                }
        }else{
//            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
//
//            }, leftAction: {})
        }
    }

    // Mark MHIOS-1158

    
}
