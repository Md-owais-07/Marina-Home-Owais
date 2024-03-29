//
//  CartVM.swift
//  Marina Home
//
//  Created by Codilar on 17/05/23.
//

import Foundation
import Alamofire
import GoogleSignIn
extension MyCartVC {
    func apiDeliveryOption( handler:(( AddressModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.deliveryOptions
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
                .responseDecodable(of: AddressModel.self) { response in
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
            print("SANTHOSH TOKEN : \(UserData.shared.currentAuthKey)")
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
   
    func apiRemoveItemFromCart(Itemid: Int, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.removeCartItem
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(Itemid)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
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
                
            }, leftAction: {})
        }
    }
    
    //MARK: START MHIOS-1129
    func apiRemoveUserDiscount(cartId: String, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.removeInstantDiscount
        
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
          //  let completeUrl = AppInfo.shared.baseURL2 + api.url
            var completeUrl = AppInfo.shared.baseURL2 + api.url + "/\(cartId)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl,method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    self.hideActivityIndicator(uiView: self.view)
                  
                    switch response.result {
                        case .success(let value):
                            // Check the type of response value
                            if let stringValue = value as? [String: Any] {
                                
                                let message = stringValue["message"] as! String
                                print("String response: \(stringValue)")
                                print("String response message : \(message)")
                                self.toastView(toastMessage:message,type: "error")
                                handler?(false)
                            } else if let boolValue = value as? Bool {
                                // Handle boolean response
                                if boolValue {
                                    //guard let data = boolValue as? Bool else {return }
                                
                                    self.toastView(toastMessage:"Instant discount removed!!!",type: "success")
                                    
                                    handler?(true)
                                } else {
                                    print("Boolean response is false")
                                    handler?(false)
                                }
                            } else {
                                print("Unknown response type")
                                self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                                handler?(false)
                            }
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                            self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                        handler?(false)
                        }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
    func apiRemoveGuestUserDiscount(cartId: String, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        var api = Api.shared.removeGuestInstantDiscount
        
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
           //  var completeUrl = AppInfo.shared.baseURL2 + api.url
            var completeUrl = AppInfo.shared.baseURL2 + api.url + "/\(cartId)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    self.hideActivityIndicator(uiView: self.view)
                  
                    switch response.result {
                        case .success(let value):
                            // Check the type of response value
                            if let stringValue = value as? [String: Any] {
                                
                                let message = stringValue["message"] as! String
                                print("String response: \(stringValue)")
                                print("String response message : \(message)")
                                self.toastView(toastMessage:message,type: "error")
                                handler?(false)
                            } else if let boolValue = value as? Bool {
                                // Handle boolean response
                                if boolValue {
                                    //guard let data = boolValue as? Bool else {return }
                                    
                                    self.toastView(toastMessage:"Instant discount removed!!!",type: "success")
                                    
                                    handler?(true)
                                } else {
                                    print("Boolean response is false")
                                    handler?(false)
                                }
                            } else {
                                print("Unknown response type")
                                self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                                handler?(false)
                            }
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                            self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                        handler?(false)
                        }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
    //MARK: END MHIOS-1129
    
    func apiApplyCoupenCode(Code: String,status: Bool, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        var api = Api.shared.applyCoupenCode
        var CodeValue = ""
        if status
        {
            api = Api.shared.applyCoupenCode
            CodeValue = Code
        }
        else
        {
            api = Api.shared.removeCoupenCode
            CodeValue = ""
        }
        //let api = Api.shared.removeCoupenCode
        //let api = Api.shared.applyCoupenCode
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + CodeValue
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH C CODE IS ")
            print(completeUrl)
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                //.responseDecodable(of: Bool.self) { response in
                .responseJSON { response in
                    self.hideActivityIndicator(uiView: self.view)
                    print("SANTHOSH PROMOCODE ERROR FIRST : \(response)")
                    print("SANTHOSH PROMOCODE result FIRST : \(response.result)")
                    
                    switch response.result {
                        case .success(let value):
                            // Check the type of response value
                            if let stringValue = value as? [String: Any] {
                                
                                let message = stringValue["message"] as! String
                                print("String response: \(stringValue)")
                                print("String response message : \(message)")
                                //MARK: START MHIOS-1285
                               SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": message])
                               //MARK: END MHIOS-1285
                                self.toastView(toastMessage:message,type: "error")
                                handler?(false)
                            } else if let boolValue = value as? Bool {
                                // Handle boolean response
                                if boolValue {
                                    //guard let data = boolValue as? Bool else {return }
                                    print("Boolean response is true")
                                    if status
                                    {
                                        self.toastView(toastMessage:"Promo code applied!!!",type: "success")
                                    }
                                    else
                                    {
                                        self.toastView(toastMessage:"Promo code removed!!!",type: "success")
                                    }
                                    handler?(true)
                                } else {
                                    print("Boolean response is false")
                                    handler?(false)
                                }
                            } else {
                                print("Unknown response type")
                                self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                                handler?(false)
                            }
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        //MARK: START MHIOS-1285
                       SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                       //MARK: END MHIOS-1285
                            self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                        handler?(false)
                        }
                    
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
    func apiDeliveryOption( handler:((Cart) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.deliveryOptions
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
    func apiGrandTotal( handler:((GrandTotal) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.grandTotalMine
        if Network.isAvailable() {
            
           // self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            print("SANTHOSH TOKEN \(UserData.shared.currentAuthKey)")
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: GrandTotal.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            if(response.response?.statusCode==401)
                            {
                                UserData.shared.ClearAllData()
                                UserData.shared.isLoggedIn = false
                                GIDSignIn.sharedInstance.signOut()
                                self.hideActivityIndicator(uiView: self.view)
                                let userDefaults = UserDefaults.standard
                                userDefaults.removeObject(forKey: "GuestCart")
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.guestCartId = ""
                                return
                            }
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
    
    func apiChangeQuantityCart(Itemid: Int,Quantity: Int, sku: String,handler:((Bool,String) -> Void)? = nil){
        
        
        print("SNTHOPSH SKU IS : ","Bearer \(UserData.shared.currentAuthKey)" )
        self.view.endEditing(true)
        let api = Api.shared.chnageCartItemQuntity
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(Itemid)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            let parameter:Parameters = ["cartItem":["sku":sku,"qty":Quantity,"quote_id":Itemid]]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            print("SNTHOPSH Q UPDATE API PARAMS IS : ",parameter )
            AF.request(completeUrl, method: api.method,parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                //.responseDecodable(of: Bool.self) { response in
                .responseDecodable(of: UpdateCart.self) { response in
                    print("SANTHOSH CART UPDATE : SATRT")
                    print("SANTHOSH CART UPDATE : \(response.value)")
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        print("SANTHOSH CART UPDATE : success")
                        //guard let data = true as? Bool else { return }
                        guard let data = response.value as? UpdateCart else
                        {
                            handler?(false,"Requested quantity is not available.Please try again later")
                            return
                        }
                        if data.itemID == nil
                        {
                            handler?(false,data.message!)
                        }
                        else
                        {
                            handler?(true,"")
                        }
                        
                    case .failure(_):
                        print("SANTHOSH CART UPDATE : success")
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                            self.tblCart.reloadData()
                        } catch {
                            print("SANTHOSH CART UPDATE : catch")
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": "Something went wrong. please try again" ])
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
                        if(response.response?.statusCode == 404)
                        {
                            self.apiCreateGuestCart(){
                                response in

                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.guestCartId = response
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(response, forKey: "GuestCart")
                                self.cartStatusCheck()
                            }
                        }
                        guard let data = response.value else { return }
                        handler?(data)
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
                                self.cartStatusCheck()
                            }
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
   
   
    func apiGuestRemoveItemFromCart(Itemid: Int, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestRemoveCartbase
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(self.guestCartId)/items/\(Itemid)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH GUEST REMOVE URL : ")
            print(completeUrl)
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: .delete, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    print("SANTHOSH MAIN REMOVE RESP : ")
                    print(response)
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
                
            }, leftAction: {})
        }
    }
    
    func apiGuestApplyCoupenCode(Code: String,status:Bool, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        var api = Api.shared.guestApplyCoupenCode
        var CodeValue = ""
        var completeUrl = AppInfo.shared.baseURL + api.url + "\(self.guestCartId)/coupons/\(CodeValue)"

        if status
        {
            api = Api.shared.guestApplyCoupenCode
            CodeValue = Code
            completeUrl = AppInfo.shared.baseURL + api.url + "\(self.guestCartId)/coupons/\(CodeValue)"

        }
        else
        {
            api = Api.shared.guestRemoveCoupenCode
            CodeValue = Code
            completeUrl = AppInfo.shared.baseURL + api.url + "\(self.guestCartId)/coupons"
        }
        //let api = Api.shared.guestCartbase
        if Network.isAvailable() {
            print(self.guestCartId)
            self.showActivityIndicator(uiView: self.view)
                        print("URL IS : \(completeUrl)")
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                //.responseDecodable(of: Bool.self) { response in
                .responseJSON { response in
                    self.hideActivityIndicator(uiView: self.view)
                    
                    switch response.result {
                        case .success(let value):
                            // Check the type of response value
                            if let stringValue = value as? [String: Any] {
                                
                                let message = stringValue["message"] as! String
                                print("String response: \(stringValue)")
                                print("String response message : \(message)")
                                //MARK: START MHIOS-1285
                               SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": message])
                               //MARK: END MHIOS-1285
                                self.toastView(toastMessage:message,type: "error")
                                handler?(false)
                            } else if let boolValue = value as? Bool {
                                // Handle boolean response
                                if boolValue {
                                    //guard let data = boolValue as? Bool else {return }
                                    print("Boolean response is true")
                                    if status
                                    {
                                        self.toastView(toastMessage:"Promo code applied!!!",type: "success")
                                    }
                                    else
                                    {
                                        self.toastView(toastMessage:"Promo code removed!!!",type: "success")
                                    }
                                    handler?(true)
                                } else {
                                    print("Boolean response is false")
                                    handler?(false)
                                }
                            } else {
                                print("Unknown response type")
                                //MARK: START MHIOS-1285
                               SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                               //MARK: END MHIOS-1285
                                self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                                handler?(false)
                            }
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        
                        //MARK: START MHIOS-1285
                       SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                       //MARK: END MHIOS-1285
                            self.toastView(toastMessage:  "Something went wrong. please try again",type: "error")
                        handler?(false)
                        }
                    
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
    func apiGuestDeliveryOption( handler:((Cart) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(self.guestCartId)/billing-address"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
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
    func apiGuestGrandTotal( handler:((GrandTotal) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.CreateGuestCart
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url+"/\(self.guestCartId)/totals"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("URL IS : ")
            print(completeUrl)
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: GrandTotal.self) { response in
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            if(response.response?.statusCode==401)
                            {
                                UserData.shared.ClearAllData()
                                UserData.shared.isLoggedIn = false
                                GIDSignIn.sharedInstance.signOut()
                                self.hideActivityIndicator(uiView: self.view)
                                let userDefaults = UserDefaults.standard
                                userDefaults.removeObject(forKey: "GuestCart")
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.guestCartId = ""
                                return
                            }
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
    
    func apiGuestChangeQuantityCart(Itemid: Int,Quantity: Int, handler:((Bool,String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(self.guestCartId)/items/\(Itemid)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            let parameter:Parameters = ["cartItem":["item_id":Itemid,"qty":Quantity]]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: .put,parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: UpdateCart.self) { response in
                    print("SANTHOSH CART UPDATE : SATRT")
                    print("SANTHOSH CART UPDATE : \(response.value)")
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        print("SANTHOSH CART UPDATE : success")
                        //guard let data = true as? Bool else { return }
                        guard let data = response.value as? UpdateCart else
                        {
                            handler?(false,"Something went wrong. please try again")
                            return
                        }
                        if data.itemID == nil
                        {
                            handler?(false,data.message!)
                        }
                        else
                        {
                            handler?(true,"")
                        }
                        
                    case .failure(_):
                        print("SANTHOSH CART UPDATE : success")
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                            self.tblCart.reloadData()
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": "Something went wrong. please try again"])
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
    
func apiProductRecommended(id:[Any],url:String, token:String, handler:((YouMightLikeModel) -> Void)? = nil){
    
    print("SANTHOS CART IDDDDDD : K ")
    print(id)
        self.view.endEditing(true)
        let typeOfRecords:[String] = ["KLEVU_PRODUCT"]
        let apiKeys:[String] = [AppInfo.shared.klevuKey]
    //let records:[Any:Any] = id
        let recentObjects:[String:Any] = ["typeOfRecord": "KLEVU_PRODUCT",
                                          "records": id]
        let recordQueries:[String:Any] = [
            "id": "recsAlsoBought",
            "typeOfRequest": "RECS_ALSO_BOUGHT",
            "settings": ["context": ["recentObjects": [recentObjects]],"limit":5,
                         "typeOfRecords": typeOfRecords]]
        
        let parameter:Parameters = [
            "recordQueries": [recordQueries],
            "context": ["apiKeys": apiKeys]
        ]
        if Network.isAvailable() {
            
            var completeUrl = url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            print("SANTHOSH REC PARAMS NEW : \(parameter)")
            AF.request(completeUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: YouMightLikeModel.self) { response in
                    ///self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? YouMightLikeModel else { return }
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
    
    func apiMoveProductFromCartToWishlist(Itemid: String,qty: Int, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.moveToWishlist
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuURL + api.url + "\(Itemid)?qty=\(qty)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH FULL URL IS : ",completeUrl)
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        self.toastView(toastMessage: "Moved to wishlist successfully",type: "success")
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
                
            }, leftAction: {})
        }
    }
    
    func apiShareCartlistEmail(email:String,message:String,quoteId:Int,handler:((ShareCart) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.shareCartlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            
            let name = "\(UserData.shared.firstName) \(UserData.shared.lastName)"
            
            let parameter:Parameters = [
                "senderName" : "\(name)",
                "senderEmail" : "\(UserData.shared.emailId)",
                "recipientEmail" : email,
                "message" : message,
                "quoteId" : quoteId,
                "customerId" : "\(UserData.shared.userId)",
                "isQuoteRequest" : true
            ]
            
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            print("SNTHOPSH Q UPDATE API PARAMS IS : ",parameter)
            print("SNTHOPSH Q UPDATE API completeUrl IS : ",completeUrl)
            AF.request(completeUrl, method: api.method,parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: ShareCart.self) { response in
                    ///print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        print("SANTHOSH CART SHARE RESP : \(response.value)")
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
                            AppUIViewController().toastView(toastMessage: apiError.message ,type: "error")
                        }
                        catch
                        {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            AppUIViewController().toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            AppUIViewController().showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiShareCartlistEmail(email: email, message: message,quoteId: quoteId)
            }, leftAction: {})
        }
    }
    
    func apiShareCartlistViaUrl(quoteId:Int,handler:((ShareCart) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        
        let api = Api.shared.shareCartlistViaUrl
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            //MARK START{MHIOS-1025} SANTHOSH
            var completeUrl = ""
            var headers: HTTPHeaders = [:]
            var parameter:Parameters = [:]
            if UserData.shared.isLoggedIn
            {
                completeUrl = AppInfo.shared.baseURL2 + Api.shared.shareCartlistViaUrl.url
                let name = "\(UserData.shared.firstName) \(UserData.shared.lastName)"
                parameter = [
                    "senderName" : "\(name)",
                    "senderEmail" : "\(UserData.shared.emailId)",
                    "quoteId" : quoteId,
                    "customerId" : "\(UserData.shared.userId)",
                    "isQuoteRequest" : true
                ]
                headers["Content-Type"] = api.contentType.rawValue
                headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            }
            else
            {
                completeUrl = AppInfo.shared.baseURL2 + Api.shared.shareCartlistGuestViaUrl.url
                parameter = [
                    "quoteId" : quoteId,
                    "isQuoteRequest" : true
                ]
            }
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            //MARK END{MHIOS-1025} SANTHOSH
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            print("SNTHOPSH Q UPDATE API PARAMS IS : ",parameter)
            print("SNTHOPSH Q UPDATE API completeUrl IS : ",completeUrl)
            AF.request(completeUrl, method: api.method,parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: ShareCart.self) { response in
                    ///print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        print("SANTHOSH CART SHARE RESP : \(response.value)")
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
                self.apiShareCartlistViaUrl(quoteId: quoteId)
            }, leftAction: {})
        }
    }
    
    
    func apiShareCartlistViaWhatsApp(quoteId:Int,handler:((ShareCart) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.shareCartlistViaWhatsApp
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            
            let name = "\(UserData.shared.firstName) \(UserData.shared.lastName)"
            
            let parameter:Parameters = [
                "senderName" : "\(name)",
                "senderEmail" : "\(UserData.shared.emailId)",
                "quoteId" : quoteId,
                "customerId" : "\(UserData.shared.userId)",
                "isQuoteRequest" : true
            ]
            
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            print("SNTHOPSH Q UPDATE API PARAMS IS : ",parameter)
            print("SNTHOPSH Q UPDATE API completeUrl IS : ",completeUrl)
            AF.request(completeUrl, method: api.method,parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: ShareCart.self) { response in
                    ///print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        print("SANTHOSH CART SHARE RESP : \(response.value)")
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
                self.apiShareCartlistViaWhatsApp(quoteId: quoteId)
            }, leftAction: {})
        }
    }
    
    
}


