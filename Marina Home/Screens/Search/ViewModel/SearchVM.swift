//
//  SearchVM.swift
//  Marina Home
//
//  Created by Eljo on 04/07/23.
//

import Foundation
import Alamofire
extension SearchVC{
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
    func apiProducts(page:Int, handler:((Products) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.listProductCategory
        let categoryId = "362"
        if Network.isAvailable() {
            let searchCategoryUrl = "searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=\(categoryId)&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[PageSize]=20&searchCriteria[currentPage]=\(page)"
            self.showActivityIndicator(uiView: self.view)
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
    
    func apiRecentProducts(page:Int, handler:((YouMightLikeModel) -> Void)? = nil){
        self.view.endEditing(true)
        //let url = "https://eucs26v2.ksearchnet.com/cs/v2/search"
       
        ////////////////////////////////////////////
        
//        let topId1 = ["key": "id", "value": "2131"]
//        let topId2 = ["key": "id", "value": "2058"]
//        let topId3 = ["key": "id", "value": "2633"]
//        let topId4 = ["key": "id", "value": "1778"]
//
//        let customANDQuery = "id: (2131 OR 2058 OR 2633 OR 1778)"// OR 2633 OR 1778
//
//        let settings = [
//            "customANDQuery": "id:("+customANDQuery+")",
//            "topIds": [topId1,topId2,topId3,topId4],
//            "typeOfRecords": ["KLEVU_PRODUCT"]
//        ] as [String : Any]
        
        var tempROPArray = [Int]()
        tempROPArray = UserData.shared.recentOpenProduct
        var customANDQuery = ""
        var topIds = [Any]()
        for var index in (0..<tempROPArray.count)
        {
            let idIs = "\(tempROPArray[index])"
            if index==0
            {
                customANDQuery = customANDQuery+idIs
            }
            else
            {
                customANDQuery =  customANDQuery+" OR "+idIs
            }
            let topId = ["key": "id", "value": idIs]
            topIds.append(topId)
        }
        
        let settings = [
            "customANDQuery": "id:("+customANDQuery+")",
            "topIds": topIds,
            "typeOfRecords": ["KLEVU_PRODUCT"]
        ] as [String : Any]


        let recordQuery = [
            "id": "recsRecentlyViewed",
            "typeOfRequest": "SEARCH",
            "settings": settings
        ] as [String : Any]

        let context = [
            "apiKeys": [AppInfo.shared.klevuKey]
        ]

        let parameters: [String: Any] = [
            "recordQueries": [recordQuery],
            "context": context
        ]
        
            print("SANTHOSH SHOW parameters")
            print("SANTHOSH ARRAY OPEN PDP PAGE A \(parameters)")
            
        
            if Network.isAvailable() {
                self.showActivityIndicator(uiView: self.view)
                var completeUrl = AppInfo.shared.recentProductsUrl
                completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
                var headers: HTTPHeaders = [:]
                headers["Content-Type"] = "application/json"
                headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
                print("SANTHOS CART NET : K ")
                AF.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseDecodable(of: YouMightLikeModel.self) { response in
                        self.hideActivityIndicator(uiView: self.view)
                        print("SANTHOS CART Resp : K ")
                        switch response.result {
                        case .success(_):
                            print("SANTHOS CART Resp : success ")
                            guard let data = response.value as? YouMightLikeModel else { return }
                            handler?(data)
                        case .failure(_):
                            print("SANTHOS CART Resp : failure ")
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
                   
                }, leftAction: {})
            }
    }
    
    //MARK START{MHIOS-872}
    func apiGetPopularSearch(handler:((PopularSearches) -> Void)? = nil){
        let api = Api.shared.popularSearch
        //https://marinahome.org/en-uae/rest/V2/popular/searches
        
        if Network.isAvailable() {
            //self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = ""
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: PopularSearches.self) { response in
                    //self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        } catch {
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                //self.apiAddToWishlist(id: id, handler: handler)
            }, leftAction: {})
        }
    }
    //MARK END{MHIOS-872}
    
    func apiGetSearchDetail(text:String ,handler:((SearchResponse) -> Void)? = nil){
        //self.view.endEditing(true)
        let api = Api.shared.listOrder
        //self.showActivityIndicator(uiView: self.view)
        //MARK START{MHIOS-872}
        let jsonString = "{\"context\":{\"apiKeys\":[\"\(AppInfo.shared.klevuKey)\"]},\"suggestions\":[{\"id\":\"suggestionSearch\",\"typeOfQuery\":\"AUTO_SUGGESTIONS\",\"query\":\"\(text)\",\"limit\":3}],\"recordQueries\":[{\"id\":\"productSearch\",\"typeOfRequest\":\"SEARCH\",\"settings\":{\"query\":{\"term\":\"\(text)\"},\"limit\":3,\"typeOfRecords\":[\"KLEVU_PRODUCT\"]}},{\"id\":\"categorySearch\",\"settings\":{\"query\":{\"term\":\"\(text)\"},\"limit\":9,\"typeOfRecords\":[\"KLEVU_CATEGORY\"],}}]}"
        //MARK END{MHIOS-872}
        
        
        if Network.isAvailable() {
            //self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.searchUrl
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH SEARCH URL : \(completeUrl)")
            let parameeters = convertStringToDictionary(text: jsonString)
            var headers: HTTPHeaders = [:]
            //headers["Content-Type"] = api.contentType.rawValue
            
            AF.request(completeUrl, method: .post,parameters: parameeters, encoding: JSONEncoding.default)
                .responseDecodable(of: SearchResponse.self) { response in
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
                            SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameeters ?? "","response": apiError.message ])
                            //MARK: END MHIOS-1285
                        } catch {
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": parameeters ?? "","response": "Something went wrong"])
                            //MARK: END MHIOS-1285
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                
            }, leftAction: {})
        }
    }
func convertStringToDictionary(text: String) -> [String:AnyObject]? {
                                   if let data = text.data(using: .utf8) {
                                       do {
                                           let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                                           return json
                                       } catch {
                                           print("Something went wrong")
                                       }
                                   }
                                   return nil
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
