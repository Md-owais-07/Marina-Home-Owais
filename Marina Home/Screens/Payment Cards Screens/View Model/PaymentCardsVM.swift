//
//  PaymentCardsVM.swift
//  Marina Home
//
//  Created by Eljo on 18/07/23.
//

import UIKit
import Alamofire
extension PaymentCardsVC {
    func apiGetPaymentCards(handler:(([PaymentCardModel]) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.getPyamentCards
        self.showActivityIndicator(uiView: self.view)
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var completeUrl = AppInfo.shared.baseMenuURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [PaymentCardModel].self) { response in
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
                self.apiGetPaymentCards(handler: handler)
            }, leftAction: {})
        }
    }
}


