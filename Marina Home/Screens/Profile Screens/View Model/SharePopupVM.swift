//
//  SharePopupVM.swift
//  Marina Home
//
//  Created by santhosh t on 24/07/23.
//

import Foundation
import Alamofire
extension SharePopupVC {
    
    func apiShareWishlist(email:String,message:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        print("Bearer \(UserData.shared.currentAuthKey)")
        let api = Api.shared.shareWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url+"?recipient_emails=\(email)&message=\(message)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    ///print(headers)
                    print(response)
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        ///guard let data = response.value as? [WishlistModel] else { return }
                        handler?(true)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do
                        {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        }
                        catch
                        {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiShareWishlist(email: email, message: message)
            }, leftAction: {})
        }
    }
    
}

