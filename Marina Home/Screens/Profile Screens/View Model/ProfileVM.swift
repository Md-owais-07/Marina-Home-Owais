//
//  ProfileVM.swift
//  Marina Home
//
//  Created by Eljo on 01/06/23.
//
import Foundation
import Alamofire
import DropDown
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
    //MARK:- Translating in Arabic lang.
    func languageSwitching() {
        basicInfo.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "BASIC_KEY", comment: "")
        myOrder.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "MYORDER_KEY", comment: "")
        checkOrder.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "CHECKORDER_KEY", comment: "")
        myWishlist.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "MYWISHLIST_KEY", comment: "")
        favouriteItems.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "FAVOURITEITEMS_KEY", comment: "")
        notificationCenter.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "NOTIFICATIONCENTER_KEY", comment: "")
        viewAllNotification.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "VIEWALLNOTIFICATION_KEY", comment: "")
        pushNotification.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "PUSHNOTIFICATION_KEY", comment: "")
        receivePushNotification.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "RECEIVEPUSHNOTIFICATION_KEY", comment: "")
        myLocation.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "MYLOCATION_KEY", comment: "")
        usa.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "USA_KEY", comment: "")
        language.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "LANGUAGE_KEY", comment: "")
        selectYourLanguage.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SELECTCOUNTRY_KEY", comment: "")
        legacy.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "LEGACY_KEY", comment: "")
        storeLocation.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "STORELOCATION_KEY", comment: "")
        onlineReturns.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ONLINERETURNS_KEY", comment: "")
        privacyPolicy.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "PRIVACYPOLICY_KEY", comment: "")
    }
    func configureDropDown() {
        dropDown.direction = .top
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        dropDown.anchorView = countryNameLabel
        dropDown.bottomOffset = CGPoint(x: 0, y: countryNameLabel.bounds.height)
        dropDown.topOffset = CGPoint(x: 0, y: dropDown.anchorView?.plainView.bounds.height ?? 0)
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.updateSelectedCountry(at: index)
        }
        dropDown.cellNib = UINib(nibName: "MyImagecell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyImagecell else { return }
            cell.logoImageView.image = self.countries[index].image
        }
    }
    func loadCountries() {
        countries = [("India", UIImage(named: "India") ?? UIImage()),
                     ("Japan", UIImage(named: "Japan") ?? UIImage()),
                     ("China", UIImage(named: "China-png") ?? UIImage())]
    }
    
}

