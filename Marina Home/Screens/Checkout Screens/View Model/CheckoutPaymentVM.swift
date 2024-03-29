//
//  CheckoutPaymentVM.swift
//  Marina Home
//
//  Created by Codilar on 23/05/23.
//

import UIKit
import Alamofire
import Firebase
import GoogleSignIn
import KlaviyoSwift
import Adjust
extension CheckoutPaymentVC {
    func apiPaymentMethods(handler:(([PaymentMethod]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.paymentMethods
        ///self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of:[PaymentMethod].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? [PaymentMethod] else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                //self.apiPaymentMethods()(handler: handler)
            }, leftAction: {})
        }
    }
    func apiAddShipmentOptions(parameters: Parameters,handler:((CheckoutPaymentModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addShipmentInformations
        //self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CheckoutPaymentModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? CheckoutPaymentModel else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiPaymentOptions(handler: handler)
            }, leftAction: {})
        }
    }
    func apiGetPaymentCards(handler:(([PaymentCardModel]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.getPyamentCards
        //self.showActivityIndicator(uiView: self.view)
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var completeUrl = AppInfo.shared.baseMenuURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [PaymentCardModel].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        self.hideActivityIndicator(uiView: self.view)
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiGetPaymentCards(handler: handler)
            }, leftAction: {})
        }
    }
    func apiPaymentOptions(handler:((CheckoutPaymentModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.paymentOptions
        ///self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CheckoutPaymentModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? CheckoutPaymentModel else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiPaymentOptions(handler: handler)
            }, leftAction: {})
        }
    }
    func apiOrderPlace(parameters: Parameters,handler:(([String]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.placeOrder
       
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [String].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value else { return }
                       
                        if data.count>0
                        {
                            let orderId:String =  data[0]
                            handler?(data)
                           // self.apiGenerateInvoice(orderId: orderId, token: AppInfo.shared.integrationToken, handler: nil)
                           
                           
                        }
                        
                       
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                       
                        appDelegate.guestCartId = ""
                        let userDefaults = UserDefaults.standard
                         userDefaults.removeObject(forKey: "GuestCart")
                        
                        
                        let klaviyo = KlaviyoSDK()

                        let event = Event(name: .CustomEvent("Placed order"), properties: [
                            "OrderCurrencyCode": "AED" ,"Totals":self.cartTotal,"ItemQuantity":appDelegate.cachedCartItems?.count,
                            "Items": appDelegate.cachedCartItems
                        ], value:Double(self.cartTotal?.baseGrandTotal ?? 0))
                        klaviyo.create(event: event)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": "Something Went wrong" ])
                        //MARK: END MHIOS-1285
                        guard let data = response.data else { return }
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if(appDelegate.payementSucces==false)
                        {
                            self.paymentFailedView.isHidden = false
                        }
                    }
                }
        }else{
            
                self.paymentFailedView.isHidden = false
            
        }
    }

    func apiGenerateInvoice(orderId: String,token:String,handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.orderInvoice
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(orderId)/invoice"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer " + token
            ///{ "capture": true, "notify": true }
            let param:[String: Any] = ["capture": true,
                                        "notify": true]
            
            AF.request(completeUrl, method: api.method,parameters: param, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(orderId)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
                        
                        //MARK: START MHIOS-1285
                       SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": "Something went wrong. please try again" ])
                       //MARK: END MHIOS-1285
                    }
                }
        }else{
           // self.paymentFailedView.isHidden = false
        }
    }

    func apiCheckoutPaymentRequest(param:[String:Any],handler:((CheckoutResponse) -> Void)? = nil){
     
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.checkOutPaymentRequestURL
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.checkoutComApiToken
            AF.request(completeUrl, method: api.method,parameters: param ,encoding: JSONEncoding.default, headers:headers)
                .responseDecodable(of: CheckoutResponse.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        if response.response?.statusCode == 201||response.response?.statusCode == 202{
                                   
                            guard let data = response.value  else {
                                
                                return
                                
                            }
                            handler?(data)
                                }
                        else
                        {
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Invalid card. please enter a valid card","Screen" : self.className])
                            //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Invalid card. please enter a valid card",type: "error")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            if(appDelegate.payementSucces==false)
                            {
                                self.paymentFailedView.isHidden = false
                            }
                            else
                            {
                                self.paymentFailedView.isHidden = true
                            }
                        }
                    case .failure(_):
                        
                        //MARK: START MHIOS-1285
                       SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": "Something went wrong. please try again" ])
                       //MARK: END MHIOS-1285
                        self.paymentFailedView.isHidden = false
                        if response.response?.statusCode == 201||response.response?.statusCode == 202{
                           
                            guard let data = response.value  else {
                                
                                
                                return }
                            handler?(data)
                        }
                        else
                        {
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Invalid card. please enter a valid card","Screen" : self.className])
                            //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Invalid card. please enter a valid card",type: "error")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            if(appDelegate.payementSucces==false)
                            {
                                self.paymentFailedView.isHidden = false
                            }
                            else
                            {
                                self.paymentFailedView.isHidden = true
                            }
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                //self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    func apiGetCheckoutPaymentDetails(handler:(([PaymentTrasactionDetail]) -> Void)? = nil){
     
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.checkOutPaymentRequestURL + "/\(self.postPaymentID)/actions"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.checkoutComApiToken
            AF.request(completeUrl, method: .get,encoding: JSONEncoding.default, headers:headers)
                .responseDecodable(of: [PaymentTrasactionDetail].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
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
                //self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    func apiTabbyPaymentCapture(handler:((TabbyCaptureResponse) -> Void)? = nil){
     
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.tabbybaseUrl + "\(self.tabbyPaymentID)/captures"
            let parm = [
                "amount":self.cartTotal?.baseGrandTotal,
                
            ]
       // https://api.tabby.ai/api/v1/payments/{id}/captures
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.checkoutComApiToken
            AF.request(completeUrl, method: .get,parameters: parm,encoding: JSONEncoding.default, headers:headers)
                .responseDecodable(of: TabbyCaptureResponse.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
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
                //self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    func apiGrandTotal( handler:((GrandTotal) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.grandTotalMine
        if Network.isAvailable() {
            
           self.showActivityIndicator(uiView: self.view)
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
    func apiOrderUpdate(param:Parameters,handler:((OrderUpdateResponse) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.orderUpdate
        //self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            AF.request(completeUrl, method: api.method,parameters: param, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of:OrderUpdateResponse.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                       
                    case .success(_):
                        guard let data = response.value as? OrderUpdateResponse else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": apiError.message ])
                            //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                //self.apiPaymentMethods()(handler: handler)
            }, leftAction: {})
        }
    }
    // MARK: - GUEST FLOW
    
    func apiGuestPaymentMethods(parameters:Parameters, handler:(([ShipingMethod]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        //self.showActivityIndicator(uiView: self.view)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(appDelegate.guestCartId)/estimate-shipping-methods"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of:[ShipingMethod].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? [ShipingMethod] else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                //self.apiPaymentMethods()(handler: handler)
            }, leftAction: {})
        }
    }
    func apiGuestAddShipmentOptions(parameters: Parameters,handler:((CheckoutPaymentModel) -> Void)? = nil){
        
            
            self.view.endEditing(true)
            let api = Api.shared.guestCartbase
            //self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if Network.isAvailable() {
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = AppInfo.shared.baseURL + api.url + "\(appDelegate.guestCartId)/shipping-information"
            
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
                AF.request(completeUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CheckoutPaymentModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? CheckoutPaymentModel else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiPaymentOptions(handler: handler)
            }, leftAction: {})
        }
    }
    
    func apiGuestPaymentOptions(handler:((CheckoutPaymentModel) -> Void)? = nil){
       
            self.view.endEditing(true)
            let api = Api.shared.guestCartbase
            //self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if Network.isAvailable() {
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = AppInfo.shared.baseURL + api.url + "\(appDelegate.guestCartId)/payment-information"
            
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
                AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CheckoutPaymentModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? CheckoutPaymentModel else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiPaymentOptions(handler: handler)
            }, leftAction: {})
        }
    }
    func apiGuestOrderPlace(parameters: Parameters,handler:(([String]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestCartbase
        ///self.showActivityIndicator(uiView: self.view)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(appDelegate.guestCartId)/order"
            
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: .put,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [String].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value else { return }
                       
                        if data.count>0
                        {
                            let orderId:String =  data[0]
                           
                           // self.apiGenerateInvoice(orderId: orderId, token: AppInfo.shared.integrationToken, handler: nil)
                          
                        }
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.guestCartId = ""
                        let userDefaults = UserDefaults.standard

                        // Read/Get Value
                         userDefaults.removeObject(forKey: "GuestCart")
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                
            }, leftAction: {})
        }
    }
    func apiGuestCheckoutPaymentRequest(param:[String:Any],handler:((CheckoutResponse) -> Void)? = nil){
     
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.checkOutPaymentRequestURL
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer sk_sbox_7k2dvat6w75rlqzyewp6tueeza*"
            AF.request(completeUrl, method: api.method,parameters: param ,encoding: JSONEncoding.default, headers:headers)
                .responseDecodable(of: CheckoutResponse.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                       
                        guard let data = response.value as? CheckoutResponse else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": apiError.message ])
                            //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                //self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    func apiPostPayPaymentRequest(param:[String:Any],handler:((PostPayChekoutResponse) -> Void)? = nil){
     
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.postPaybaseUrl
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
           
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = AppInfo.shared.postpayToken
            AF.request(completeUrl, method: .post,parameters: param ,encoding: JSONEncoding.default, headers:headers)
                .responseDecodable(of: PostPayChekoutResponse.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": apiError.message ])
                            //MARK: END MHIOS-1285)
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": param,"response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                //self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
   
    func apiAdminToken(parameters: Parameters, handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.adminToken
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
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
                self.apiAdminToken(parameters: parameters)
            }, leftAction: {})
        }
    }
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
    
    // MARK: - GUEST FLOW
    func apiGuestGrandTotal( handler:((GrandTotal) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.CreateGuestCart
        if Network.isAvailable() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url+"/\(appDelegate.guestCartId)/totals"
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
    
    func apiAddPaymentCardDetails(parameters: Parameters,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addPyamentCard
        ///self.showActivityIndicator(uiView: self.view)
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var completeUrl = AppInfo.shared.baseMenuURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        self.hideActivityIndicator(uiView: self.view)
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {

            }, leftAction: {})
        }
    }
    //MARK start MHIOS-1151
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
    //MARK end MHIOS-1151
    //MARK: START MHIOS-1281
    func apiCheckFirstSale(handler:((Bool) -> Void)? = nil){
        
            let api = Api.shared.checkFirstSale
            if Network.isAvailable() {
                var email = ""
                if UserData.shared.isLoggedIn
                {
                    email = UserData.shared.emailId
                }
                else
                {
                    email = self.parameterAdress["email"] as! String
                }
                
                var completeUrl = AppInfo.shared.baseURL2 + api.url
                completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
                var headers: HTTPHeaders = [:]
                headers["Content-Type"] = api.contentType.rawValue
                AF.request(completeUrl, method: api.method,parameters:["customerEmail": email],encoding: JSONEncoding.default, headers:headers)
                    .responseDecodable(of: Bool.self) { response in
                        switch response.result {
                        case .success(_):
                            guard let data = response.value else { return }
                            handler?(data)
                        case .failure(_):
                            handler?(false)
                        }
                    }
            }else{
                self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                    self.apiCheckFirstSale(handler: handler)
                }, leftAction: {})
            }
        
       
    }
   
    func sendFirstSaleEvent()
    {
        
        AdjustAnalytics.shared.createEvent(type: .FirstSale)
        AdjustAnalytics.shared.track()
        
    }
    //MARK: END MHIOS-1281
}

extension CheckoutVC
{
    //MARK: START MHIOS-1025
    func apiShareCartlistViaUrl(quoteId:Int,handler:((ShareCart) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.shareCartlistViaUrl
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
                self.apiShareCartlistViaUrl(quoteId: quoteId)
            }, leftAction: {})
        }
    }
    //MARK: END MHIOS-1025
    func apiAddShipmentOptions(parameters: Parameters,handler:((CheckoutPaymentModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addShipmentInformations
        //self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CheckoutPaymentModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? CheckoutPaymentModel else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiPaymentOptions(handler: handler)
            }, leftAction: {})
        }
    }
    
    func apiPaymentOptions(handler:((CheckoutPaymentModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.paymentOptions
        ///self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CheckoutPaymentModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? CheckoutPaymentModel else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiPaymentOptions(handler: handler)
            }, leftAction: {})
        }
    }
    
    func apiGrandTotal( handler:((GrandTotal) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.grandTotalMine
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
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
    
    func apiGuestAddShipmentOptions(parameters: Parameters,handler:((CheckoutPaymentModel) -> Void)? = nil){
        
            
            self.view.endEditing(true)
            let api = Api.shared.guestCartbase
            ///self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if Network.isAvailable() {
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = AppInfo.shared.baseURL + api.url + "\(appDelegate.guestCartId)/shipping-information"
            
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
           // headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
                AF.request(completeUrl, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CheckoutPaymentModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        guard let data = response.value as? CheckoutPaymentModel else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
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
                self.apiPaymentOptions(handler: handler)
            }, leftAction: {})
        }
    }
    
    // MARK: - GUEST FLOW
    func apiGuestGrandTotal( handler:((GrandTotal) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.CreateGuestCart
        if Network.isAvailable() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url+"/\(appDelegate.guestCartId)/totals"
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
    
   
}









