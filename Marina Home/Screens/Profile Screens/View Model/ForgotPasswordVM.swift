//
//  ForgotPasswordVM.swift
//  Marina Home
//
//  Created by santhosh t on 16/06/23.
//

import Foundation
import Alamofire
extension ForgotPasswordVC {
    
    func apiForgotPassword(parameters: Parameters, handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.forgotPassword
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            AF.request(completeUrl, method: api.method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        //print("SANTHOSH ERROR MESSAGE \(response.value)")
                        //print("SANTHOSH ERROR MESSAGE data \(data.)")
                        if response.response?.statusCode == 404
                        {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": "If there is an account associated with \(parameters["email"]!) you will receive an email with a link to reset your password."])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "If there is an account associated with \(parameters["email"]!) you will receive an email with a link to reset your password.",type: "success")
                        }
                        else
                        {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameters,"response": "Something went wrong. please try again"])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }

                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiForgotPassword(parameters: parameters)
            }, leftAction: {})
        }
    }
    
}
