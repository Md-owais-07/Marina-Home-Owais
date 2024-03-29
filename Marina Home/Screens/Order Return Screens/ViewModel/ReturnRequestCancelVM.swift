//
//  ReturnRequestCancelVM.swift
//  Marina Home
//
//  Created by Sooraj R on 27/07/23.
//

import UIKit
import Alamofire
extension ReturnRequestCancelVC {
    //MARK: START MHIOS-960
    func apiCancelRequest(parameters: Parameters,isLoggedIn:Bool,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        var api = Api.shared.returnReqCancelGuest
        var base = AppInfo.shared.baseURL2
        if isLoggedIn
        {
            api = Api.shared.returnReqCancel
            base = AppInfo.shared.baseURL
        }
        //MARK: END MHIOS-960
        self.showActivityIndicator(uiView: self.view)
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = base + api.url
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
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                //MARK: START MHIOS-960
                self.apiCancelRequest(parameters: parameters, isLoggedIn: isLoggedIn,handler: handler)
                //MARK: END MHIOS-960
            }, leftAction: {})
        }
    }
}

