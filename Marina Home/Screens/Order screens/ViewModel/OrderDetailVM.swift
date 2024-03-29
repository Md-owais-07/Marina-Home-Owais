//
//  OrderDetailVM.swift
//  Marina Home
//
//  Created by Eljo on 03/07/23.
//

import Foundation
import Alamofire
extension OrderDetailVC
{
    func apigetReturnRequestInfo(orderId:Int,handler:(([String:AnyObject]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.ReturnRequestInfo
        self.showActivityIndicator(uiView: self.view)
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuURL + api.url+"?orderId=\(orderId)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //MARK: START MHIOS-1257
           // headers["Authorization"] = AppInfo.shared.adminToken
            //MARK: END MHIOS-1257
            AF.request(completeUrl, method: .post, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        self.hideActivityIndicator(uiView: self.view)
                        guard let data = response.value else { return }
                        let jsonString = data
                        let data1: Data? = jsonString.data(using: .utf8)
                        
                        let json = (try? JSONSerialization.jsonObject(with: data1!, options: [])) as? [String:AnyObject]
                        handler?(json ?? [:])
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
            self.showAlert(message: "Please check your internet connection", rightAction: {
                
            }, leftAction: {})
        }
    }
    func apiGetOrderDetail( orderId:String, email:String, handler:((OrderDeatil) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.listOrder
        self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "?searchCriteria[filter_groups][0][filters][0][field]=customer_id&searchCriteria[filter_groups][0][filters][0][value]=\(UserData.shared.userId)&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[filter_groups][1][filters][0][field]=increment_id&searchCriteria[filter_groups][1][filters][0][value]=\(orderId)"
            if(self.isFromGuest==true)
            {
                completeUrl =   AppInfo.shared.baseURL + api.url + "?searchCriteria[filter_groups][0][filters][0][field]=customer_email&searchCriteria[filter_groups][0][filters][0][value]=\(email)&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[filter_groups][1][filters][0][field]=increment_id&searchCriteria[filter_groups][1][filters][0][value]=\(orderId)"
            }
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH apiGetOrderDetail \(completeUrl)")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: OrderDeatil.self) { response in
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
    func apiGetOrderTrackingDetail( orderId:String, emailId:String, handler:((OrderTrackingDeatil) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.listOrder
        self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuURL + "order/tracking/details?increment_id=\(orderId)&email=\(emailId)&billing_lastname=\(self.detail?.items?.first?.billing_address?.lastname ?? " ")"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            AF.request(completeUrl, method: .post, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: String.self) {
                    response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                        
                    case .success(_):
                        self.hideActivityIndicator(uiView: self.view)
                        do {
                            let jsonString = (response.value ?? "") as String
                            var dictonary:NSArray?
                                    
                            if let data = jsonString.data(using: String.Encoding(rawValue: NSUTF8StringEncoding) ?? .utf8) {
                                        
                                        do {
                                            
                                            let trackingDetail = try JSONDecoder().decode(OrderTrackingDeatil.self, from: data)
                                            
                                            /*dictonary =  try JSONSerialization.jsonObject(with: data, options: [])  as! NSArray?
                                            let mileStones = self.getMileStones(arr: dictonary!)*/
                                            print(trackingDetail)
                                            handler?(trackingDetail)
                                        } catch let error as NSError {
                                            print(error)
                                        }
                                    }
                            
                           // handler?(json!)
                        } catch {
                            print("errorMsg")
                        }
                        guard let data = response.value else { return }
                        
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                            //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                           
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
    func getMileStones(arr:NSArray)->NSDictionary
    {
        for e in arr
        {
            if (e is Dictionary<String, Any>)
            {
                let k = e as! NSDictionary
            if let drink = k["key_milestones"] {
                if (drink is Dictionary<String, Any>)
                {
                    return drink as! NSDictionary
                }
                
            }
            }
        }
        return [:]
    }
    //MARK: START MHIOS-960
    func getReturnDetails(orderId:String,isLoggedIn:Bool ,handler:((ReturnItemsModel) -> Void)? = nil){
        self.view.endEditing(true)
        var base = AppInfo.shared.baseURL2
        var api = Api.shared.returnDetailsGuest
        if isLoggedIn
        {
            api = Api.shared.returnDetails
            base = AppInfo.shared.baseURL
        }
       
        //mpRMA/mine/requests?
        self.showActivityIndicator(uiView: self.view)
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var completeUrl = base + api.url + "searchCriteria[filter_groups][0][filters][0][field]=order_id&searchCriteria[filter_groups][0][filters][0][value]=\(orderId)&searchCriteria[filter_groups][0][filters][0][condition_type]=eq"
            //MARK: END MHIOS-960
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH ORDER URL IS : \(completeUrl)")
            print("SANTHOSH ORDER TOKEN IS : \(UserData.shared.currentAuthKey)")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            //MARK: START MHIOS-960
            if UserData.shared.isLoggedIn
            {
                headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            }
            //MARK: START MHIOS-960
            AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: ReturnItemsModel.self) { response in
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
                //MARK: START MHIOS-960
                self.getReturnDetails(orderId: orderId, isLoggedIn: UserData.shared.isLoggedIn, handler: handler)
                //MARK: END MHIOS-960
            }, leftAction: {})
        }
    }
}
