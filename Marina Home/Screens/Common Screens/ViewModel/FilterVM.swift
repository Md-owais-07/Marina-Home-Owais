//
//  FilterVM.swift
//  Marina Home
//
//  Created by Codilar on 10/05/23.
//

import UIKit
import Alamofire
extension FilterVC {

    func apiFilterOptions(categoryId:String,handler:((FilterOptionsModel) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.filterOptions
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseMenuURL + api.url + "\(categoryId)/products/available-filters?searchCriteria[pageSize]=100"
            if(self.isfromSearch==true){
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
                    let position = self.isfromSearch ? (index + 1) : index
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
}

