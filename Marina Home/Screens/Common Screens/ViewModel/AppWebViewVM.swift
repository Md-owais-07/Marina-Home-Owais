//
//  AppWebViewVM.swift
//  Marina Home
//
//  Created by Eljo on 14/07/23.
//

import Foundation
import Alamofire
import Firebase
import Adjust
import FirebaseAnalytics

extension AppWebViewVC
{
    func apiOrderUpdate(param:Parameters,handler:((OrderUpdateResponse) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.orderUpdate
        self.showActivityIndicator(uiView: self.view)
        
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
    func apiPostPayConfirmRequest(handler:((PostPayResponse) -> Void)? = nil){
        
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.postPayCaptureUrl+"orders/\(self.incrementId)/capture"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = AppInfo.shared.postpayToken
            AF.request(completeUrl, method: .post ,encoding: JSONEncoding.default, headers:headers)
                .responseDecodable(of: PostPayResponse.self) { response in
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
    func postPayChekoutConfirm()
    {
        
        self.apiPostPayConfirmRequest(){ response in
            if(response.status == "captured")
            {
                let parm = [
                    "orderId":self.orderId,
                    "authoriseTxnId":self.rference,
                    "capturedTxnId":self.postpayId
                ]
                self.hideActivityIndicator(uiView: self.view)
                Analytics.logEvent("purchase", parameters: [
                    AnalyticsParameterCurrency: "AED",AnalyticsParameterTransactionID:self.incrementId,
                    AnalyticsParameterValue: self.baseGrandTotal ?? 0
                ])
                // Mark MHIOS-1166
                let event1 = ADJEvent(eventToken: AdjustEventType.Sale.rawValue)
                event1?.setTransactionId(self.incrementId)
                event1?.setRevenue(self.baseGrandTotal ?? 0 , currency: "AED")
                Adjust.trackEvent(event1)
                // Mark MHIOS-1166

                //MARK: START MHIOS-1281
                let seconds = 2.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.apiCheckFirstSale(){ response in
                        if response
                        {
                            
                            self.sendFirstSaleEvent()
                            
                        }
                        //MARK: START MHIOS-1064
                        var properties = [String:Any]()
                        properties["revenue"] = "\(self.baseGrandTotal ?? 0)"
                        properties["currency"] = "AED"
                        properties["TransactionID"] = "\(self.incrementId)"
                        SmartManager.shared.trackEvent(event: "purchase", properties: properties)
                        //MARK: END MHIOS-1064
                        let nextVC = AppController.shared.orderSuccess
                        nextVC.isPostPay = false
                        nextVC.orderId = self.orderId
                        nextVC.incrementId = self.incrementId
                        nextVC.selectedTimeSlot = self.selectedTomeSlot
                        nextVC.DeliveryDate = self.selectedTomeSlot
                        nextVC.guestName = self.guestName
                        nextVC.trasactionParam = self.trasactionParam
                        nextVC.hidesBottomBarWhenPushed = true
                        nextVC.trasactionParam = parm
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                    }
                }
                //MARK: END MHIOS-1281
            }
        }
    }
    
    //MARK: START MHIOS-1281
    func sendFirstSaleEvent()
    {
        
        AdjustAnalytics.shared.createEvent(type: .FirstSale)
        AdjustAnalytics.shared.track()
        
    }
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
                email = guestEmail
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
    //MARK: END MHIOS-1281
}

