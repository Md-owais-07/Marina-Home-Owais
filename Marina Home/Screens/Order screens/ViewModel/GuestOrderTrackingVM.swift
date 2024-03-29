//
//  GuestOrderTrackingVM.swift
//  Marina Home
//
//  Created by Eljo on 28/07/23.
//

import Foundation
import Alamofire
extension GuestOrderTrackingVC {
    func apiGetOrderDetail( orderId:String, email:String, billingLastName: String, handler:((OrderDeatil) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.guestOrders
        self.showActivityIndicator(uiView: self.view)

        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "?searchCriteria[filter_groups][0][filters][0][field]=customer_email&searchCriteria[filter_groups][0][filters][0][value]=\(email)&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[filter_groups][1][filters][0][field]=increment_id&searchCriteria[filter_groups][1][filters][0][value]=\(orderId)&searchCriteria[filter_groups][2][filters][0][field]=billing_lastname&searchCriteria[filter_groups][2][filters][0][value]=\(billingLastName)"
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
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
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
