//
//  OrderSuccessVM.swift
//  Marina Home
//
//  Created by Eljo on 12/09/23.
//

import Foundation
import Alamofire
extension OrderSuccessVC
{
    func apiGenerateInvoice(orderId: String,token:String, isPostpay:Bool,handler:((String) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.orderInvoice
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(orderId)/invoice"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            
            let parm = [
                "capture": isPostpay,
                 "notify": true
            ]
            
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer " + token
            AF.request(completeUrl, method: api.method,parameters: parm, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(orderId)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
                        guard let data = response.data else { return }
                        //self.paymentFailedView.isHidden = false
                    }
                }
        }else{
           // self.paymentFailedView.isHidden = false
        }
    }
    func apiOrderUpdate(param:Parameters,handler:((OrderUpdateResponse) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.orderUpdate
        ///self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            //MARK: START-MHIOS-1167
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            //MARK: END-MHIOS-1167
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
}
