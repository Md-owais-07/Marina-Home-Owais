//
//  MenuVM.swift
//  Marina Home
//
//  Created by Codilar on 10/05/23.
//

import UIKit
import Alamofire
extension MenuVC {

    func apiCategories(handler:((MenuModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.categories
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuURL + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            print("SANTHOSH TTTT TOKEN IS : \(AppInfo.shared.adminToken)")
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: MenuModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? MenuModel else { return }
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
                self.apiCategories()
            }, leftAction: {})
        }
    }
    func apiRecentProduct(id:String,url:String, token:String, handler:((YouMightLikeModel) -> Void)? = nil){
        
       
        print(id)
        
        
            self.view.endEditing(true)
        var persons:Array = [Dictionary<String, String>]()

        var dic1 = ["key":"id","value":"34322453430403"]
        var dic2 = ["key": "id","value": "34322423840899"]

        persons.append(dic1)
        persons.append(dic2)
            let param:Parameters = [
                "recordQueries": {
                    [
                        "id": "recsRecentlyViewed",
                        "typeOfRequest": "SEARCH",
                        "settings": [
                            "customANDQuery": "id:(\"34322453430403\" OR \"34322423840899\")",
                            "topIds":persons,
                            "typeOfRecords": {
                                "KLEVU_PRODUCT"
                            }
                        ]
                    ]
                },
                "context": [
                    "apiKeys": {
                        "klevu-162393374404713664"
                    }
                ]
              ]
            if Network.isAvailable() {
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = url
                completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
                var headers: HTTPHeaders = [:]
                headers["Content-Type"] = "application/json"
                headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
                AF.request(completeUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable(of: YouMightLikeModel.self) { response in
                        self.hideActivityIndicator(uiView: self.view)
                        switch response.result {
                        case .success(_):
                            guard let data = response.value as? YouMightLikeModel else { return }
                            handler?(data)
                        case .failure(_):
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
                   
                }, leftAction: {})
            }
        }
    func apiProducts(page:Int, handler:((Products) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.listProductCategory
        let categoryId = "362"
        if Network.isAvailable() {
            let searchCategoryUrl = "searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=\(categoryId)&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[PageSize]=20&searchCriteria[currentPage]=\(page)"
            //self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + searchCategoryUrl
           
            
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Products.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Products else { return }
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
    func apiAddToWishlist(id:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(id)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool else { return }
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
                self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    
    func apiRemoveProduct(id:String,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.removeFromWishlist
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(id)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool else { return }
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
                self.apiRemoveProduct(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    
    func apiNewArrival(recordQueries:[String:AnyObject], handler:((YouMightLikeModel) -> Void)? = nil){
        
       
            
            let parameter:Parameters = [
                "recordQueries": recordQueries["recordQueries"],
                "context": ["apiKeys": [AppInfo.shared.klevuKey]]]
            if Network.isAvailable() {
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = AppInfo.shared.searchUrl
                completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
                var headers: HTTPHeaders = [:]
                headers["Content-Type"] = "application/json"
                headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
                AF.request(completeUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable(of: YouMightLikeModel.self) { response in
                        self.hideActivityIndicator(uiView: self.view)
                        switch response.result {
                        case .success(_):
                            guard let data = response.value as? YouMightLikeModel else { return }
                            handler?(data)
                        case .failure(_):
                            guard let data = response.data else { return }
                            do {
                                let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                                //MARK: START MHIOS-1285
                                SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": apiError.message ])
                                //MARK: END MHIOS-1285
                            } catch {
                                //MARK: START MHIOS-1285
                               SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameter,"response": "Something went wrong. please try again" ])
                               //MARK: END MHIOS-1285
                            }
                        }
                    }
            }else{
                
            }
        }
    func apiGetQueryNewArrivals( handler:((KlebuRecordQueries) -> Void)? = nil){
        
       
            self.view.endEditing(true)
            
            
           
            if Network.isAvailable() {
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = AppInfo.shared.searchQuesryKelbuUrl
                completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
                var headers: HTTPHeaders = [:]
                headers["Content-Type"] = "application/json"
              
                AF.request(completeUrl, method: .post, encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable(of: KlebuRecordQueries.self) { response in
                        self.hideActivityIndicator(uiView: self.view)
                        switch response.result {
                        case .success(_):
                            guard let data = response.value as? KlebuRecordQueries else { return }
                            handler?(data)
                        case .failure(_):
                            guard let data = response.data else { return }
                            do {
                                let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                                //MARK: START MHIOS-1285
                                SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                                //MARK: END MHIOS-1285
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
}



