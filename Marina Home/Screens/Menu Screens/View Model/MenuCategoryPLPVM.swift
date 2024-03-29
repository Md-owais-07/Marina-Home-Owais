//
//  MenuCategoryPLPVM.swift
//  Marina Home
//
//  Created by Eljo on 26/05/23.
//

import Foundation
import Alamofire

extension MenuCategoryPLP {
    func apiFilterOptions(categoryId:String,handler:((FilterOptionsModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.filterOptions
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuURL + api.url + "\(categoryId)/products/available-filters?searchCriteria[pageSize]=100"
            if(self.isFromSearch==true){
                completeUrl = AppInfo.shared.baseMenuURL+"search/filters?searchCriteria[requestName]=quick_search_container&searchCriteria[filter_groups][0][filters][0][field]=search_term&searchCriteria[filter_groups][0][filters][0][value]=\(categoryId)&searchCriteria[filter_groups][0][filters][0][condition_type]=like"
            }

            if(selectedItemsArray.count>0)
            {
                var searchOptions = ""
                let selectedGroup = Dictionary(grouping: selectedItemsArray, by: { $0.section })
                for (index,item) in selectedGroup.enumerated(){
                    let nxt = index == (selectedGroup.count - 1) ? "" : "&"
                    var ids = ""
                    for (itemIdIndex,itemId) in item.value.enumerated(){
                        ids += itemIdIndex == (item.value.count - 1) ? itemId.sectionItem : (itemId.sectionItem + ",")
                    }
                    let position = self.isFromSearch ? (index + 1) : index
                    searchOptions += "searchCriteria[filter_groups][\(position)][filters][0][field]=\(item.key)&searchCriteria[filter_groups][\(position)][filters][0][value]=\(ids)&searchCriteria[filter_groups][\(position)][filters][0][condition_type]=in" + nxt
                }
                completeUrl = completeUrl + "&" + searchOptions
            }
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = AppInfo.shared.adminToken
            print("SANTHOSH FILTER URL IS \(completeUrl)")
            print("SANTHOSH FILTER TOKEN IS \(AppInfo.shared.adminToken)")
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: FilterOptionsModel.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? FilterOptionsModel else { return }
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
                self.apiFilterOptions(categoryId: categoryId)
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
    func apiPopularProducts(page:Int, handler:((Products) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.listProductCategory
        if Network.isAvailable() {
            let searchCategoryUrl = "searchCriteria[filter_groups][0][filters][1][field]=sku&searchCriteria[filter_groups][0][filters][1][value]=%25\(self.category_id)%25&searchCriteria[filter_groups][0][filters][1][condition_type]=like&searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[filter_groups][0][filters][0][value]=%25\(self.category_id)%25&searchCriteria[sortOrders][0][field]=personalized&searchCriteria[sortOrders][0][direction]=DESC&searchCriteria[pageSize]=10&searchCriteria[currentPage]=\(page)"
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + searchCategoryUrl
            let urlWithNoSpaces = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(urlWithNoSpaces, method: api.method, encoding: JSONEncoding.default, headers: headers)
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
    func apiProducts(page:Int, handler:((Products) -> Void)? = nil){
        self.view.endEditing(true)
        var api = Api.shared.listProductCategory
       
        if Network.isAvailable() {
            var searchCategoryUrl = "searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=\(self.category_id ?? "")&searchCriteria[filter_groups][0][filters][0][condition_type]=eq&searchCriteria[PageSize]=20&searchCriteria[currentPage]=\(page)"
            if(isFromSearch==true)
            {
                api = Api.shared.searchProducts
                searchCategoryUrl = "searchCriteria[requestName]=quick_search_container&searchCriteria[filter_groups][0][filters][0][field]=search_term&searchCriteria[filter_groups][0][filters][0][value]=\(self.category_id)&searchCriteria[pageSize]=10&searchCriteria[currentPage]=\(page)"
            }
            if(page>1)
            {
                self.paginationLoder.startAnimating()
            }
           
           // self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuProductsURL + api.url + searchCategoryUrl
            if(self.isFromSearch == true)
            {
                completeUrl =  AppInfo.shared.baseMenuURL + api.url + searchCategoryUrl
            }
            if(selectedItemsArray.count>0)
            {
                var searchOptions = ""
                let selectedGroup = Dictionary(grouping: selectedItemsArray, by: { $0.section })
                for (index,item) in selectedGroup.enumerated(){
                    let nxt = index == (selectedGroup.count - 1) ? "" : "&"
                    var ids = ""
                    for (itemIdIndex,itemId) in item.value.enumerated(){
                        ids += itemIdIndex == (item.value.count - 1) ? itemId.sectionItem : (itemId.sectionItem + ",")
                    }
                    let position = index + 1
                    searchOptions += "searchCriteria[filter_groups][\(position)][filters][0][field]=\(item.key)&searchCriteria[filter_groups][\(position)][filters][0][value]=\(ids)&searchCriteria[filter_groups][\(position)][filters][0][condition_type]=in" + nxt
                }
                completeUrl = AppInfo.shared.baseMenuProductsURL + api.url + searchCategoryUrl + "&" + searchOptions
                if(self.isFromSearch == true)
                {
                    completeUrl = AppInfo.shared.baseMenuURL + api.url + searchCategoryUrl + "&" + searchOptions
                }
            }
            var sortOptions = ""
            var url:Urlsort = .Relevence(self.category_id )
            sortOptions = url.rawUrl
            print("SANTHOSH SORT KEY IS : \(sortOptions)")
            if(self.isFromSearch==true)
            {
                switch sortOption {
                case "Relevance":
                    var url:UrlSearchsort = .Relevence(self.category_id )
                    sortOptions = url.rawUrl
                case "New In":
                    var url:UrlSearchsort = .NewIn(self.category_id )
                    sortOptions = url.rawUrl
                case "Price - Low To High":
                    var url:UrlSearchsort = .LowToHight(self.category_id)
                    sortOptions = url.rawUrl
                case "Price - High To Low":
                    var url:UrlSearchsort = .HightToLow(self.category_id )
                    sortOptions = url.rawUrl
                default:
                    var url:UrlSearchsort = .Relevence(self.category_id )
                    sortOptions = url.rawUrl
                }
            }
            else
            {
                switch sortOption {
                case "Relevance":
                    var url:Urlsort = .Relevence(self.category_id )
                    sortOptions = url.rawUrl
                case "New In":
                    var url:Urlsort = .NewIn(self.category_id )
                    sortOptions = url.rawUrl
                case "Price - Low To High":
                    var url:Urlsort = .LowToHight(self.category_id)
                    sortOptions = url.rawUrl
                case "Price - High To Low":
                    var url:Urlsort = .HightToLow(self.category_id )
                    sortOptions = url.rawUrl
                default:
                    var url:Urlsort = .Relevence(self.category_id )
                    sortOptions = url.rawUrl
                }
            }

            let c:String = completeUrl
            completeUrl = c + "&" + sortOptions
            
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            print("SANTHOSH SORT KEY completeUrl IS : \(completeUrl)")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Products.self) { response in
                    self.paginationLoder.stopAnimating()
                    
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Products else { return }
                        handler?(data)
                    case .failure(_):
                        self.hideActivityIndicator(uiView: self.view)
                        self.emptyView.isHidden = false
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
            self.emptyView.isHidden = false
            self.hideActivityIndicator(uiView: self.view)
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
               
            }, leftAction: {})
        }
    }
}
