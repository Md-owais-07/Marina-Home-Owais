//
//  OrderListVM.swift
//  Marina Home
//
//  Created by Eljo on 22/06/23.
//

import Foundation
import Alamofire
extension OrderListVC
{
    func apiGetOrderList(page:Int,handler:((OrderList) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.listOrder
        self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            //MARK START{MHIOS-1122}
            var completeUrl = AppInfo.shared.baseURL + api.url + "?searchCriteria[filter_groups][0][filters][0][field]=customer_id&searchCriteria[filter_groups][0][filters][0][value]=\(UserData.shared.userId)&searchCriteria[filter_groups][1][filters][0][condition_type]=neq&searchCriteria[filter_groups][1][filters][0][value]=pending&searchCriteria[filter_groups][1][filters][0][field]=status&searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC&searchCriteria[currentPage]=\(page)&searchCriteria[pageSize]=30"
            //MARK END{MHIOS-1122}
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: OrderList.self) { response in
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
    func apiGetGuestOrderList(handler:((OrderList) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.listOrder
        self.showActivityIndicator(uiView: self.view)
        
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "?searchCriteria[pageSize]=5&searchCriteria[currentPage]=1&searchCriteria[filter_groups][0][filters][0][field]=customer_email&searchCriteria[filter_groups][0][filters][0][value]=deepak.n@codilar.com" //\(UserData.shared.emailId)
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: OrderList.self) { response in
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
}
