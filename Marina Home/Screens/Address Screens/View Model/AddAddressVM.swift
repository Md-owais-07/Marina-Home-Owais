//
//  AddAddressVM.swift
//  Marina Home
//
//  Created by Codilar on 22/05/23.
//

import UIKit
import Alamofire
extension AddAddressVC {
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
    func apiAddOrUpdateAddress(parameters: Parameters,token:String, handler:((Addresses) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addOrUpdateAddress
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.adressBaseUrl + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Addresses.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Addresses else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": apiError.message ])
                            //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
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
                self.apiAddOrUpdateAddress(parameters: parameters,token:token,
                                           handler: handler)
            }, leftAction: {})
        }
    }
    func apiGetCountry( handler:((Country1) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.mycart
        if Network.isAvailable() {
            
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.countryUrl
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of:Country1.self) { response in
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
    func apiGuestAddShipmentOptions(parameters: Parameters,handler:((CheckoutPaymentModel) -> Void)? = nil){
        
            
            self.view.endEditing(true)
            let api = Api.shared.guestCartbase
            self.showActivityIndicator(uiView: self.view)
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
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error success")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
}

