//
//  ProfileVM.swift
//  Marina Home
//
//  Created by Eljo on 01/06/23.
//
import Foundation
import Alamofire
extension ProfileVC{
    //MARK: START MHIOS-967
    func getAllNotification(handler:(([NotificationModel]) -> Void)? = nil){
        self.view.endEditing(true)
        var api = Api.shared.getAllguestNotification
        if UserData.shared.isLoggedIn
        {
             api = Api.shared.getAllNotification
        }
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url
            if UserData.shared.isLoggedIn
            {
                completeUrl = completeUrl + "customerEmail=\(UserData.shared.emailId)"
            }
            else
            {
                
                completeUrl = AppInfo.shared.baseURL + api.url + "externalId=\(UserData.shared.external_id)&profileId="
            }
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            if UserData.shared.isLoggedIn
            {
                headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            }
            
            AF.request(completeUrl, method: api.method, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: [NotificationModel].self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value
                        else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            self.toastView(toastMessage: apiError.message ,type: "error")
                        } catch {
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.getAllNotification()
            }, leftAction: {})
        }
    }
    //MARK: END MHIOS-967

        func apiGetFooterLink(id:String, handler:((HomeFooterLink) -> Void)? = nil){
            self.view.endEditing(true)
            let api = Api.shared.cmsPage
            if Network.isAvailable() {
                
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = AppInfo.shared.baseURL + api.url + "/\(id)"
                completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
                var headers: HTTPHeaders = [:]
                headers["Content-Type"] = api.contentType.rawValue
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable(of: HomeFooterLink.self) { response in
                        self.hideActivityIndicator(uiView: self.view)
                        switch response.result {
                        case .success(_):
                            guard let data = response.value as? HomeFooterLink else { return }
                            handler?(data)
                        case .failure(_):
                            guard let data = response.data else { return }
                            do {
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
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
