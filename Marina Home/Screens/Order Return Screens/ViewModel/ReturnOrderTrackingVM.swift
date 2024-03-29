//
//  ReturnOrderTrackingVM.swift
//  Marina Home
//
//  Created by Sooraj R on 27/07/23.
//

import Foundation

import UIKit
import Alamofire
extension ReturnOrderTrackingVC {
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

    func apiGetReturnStatus(statusId:Int,token:String, handler:((ReturnTrackingModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.returnTracking
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "searchCriteria[filter_groups][0][filters][0][field]=status_id&searchCriteria[filter_groups][0][filters][0][value]=\(statusId)&searchCriteria[filter_groups][0][filters][0][condition_type]=eq"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer " + token
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: ReturnTrackingModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? ReturnTrackingModel else { return }
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
                self.apiGetReturnStatus(statusId: statusId, token: token, handler: handler)
            }, leftAction: {})
        }
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

        }//mpRMA/mine/requests?
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
            //MARK: END MHIOS-960
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
                self.getReturnDetails(orderId: orderId, isLoggedIn: isLoggedIn, handler: handler)
                //MARK: END MHIOS-960
            }, leftAction: {})
        }
    }
}
