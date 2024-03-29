//
//  Network.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import SystemConfiguration
import UIKit
import Alamofire
import KlaviyoSwift

class Network{

    class func isAvailable() -> Bool
   {
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)

      let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
         $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
         }
      }

      var flags = SCNetworkReachabilityFlags()
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
         return false
      }
      let isReachable = flags.contains(.reachable)
      let needsConnection = flags.contains(.connectionRequired)
      return (isReachable && !needsConnection)
   }
    
    
    //MARK: START MHIOS-973
    class func enableDisablePushNotification(status:Int, handler:((Bool) -> Void)? = nil){
        var token = ""
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            token = appDelegate.deviceToken
        }
        let api = Api.shared.enableDisablePush
        if Network.isAvailable() {
            var completeUrl = AppInfo.shared.baseURL2 + api.url
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            
            let param:[String:Any] = [
                "customer_id": UserData.shared.isLoggedIn == true ? UserData.shared.userId : "",
                "notificationStatus": status,
                "token": KlaviyoSDK().pushToken ?? token,
                "externalId":UserData.shared.isLoggedIn == true ? "" : KlaviyoSDK().externalId ?? UserData.shared.external_id]
            AF.request(completeUrl, method: api.method,parameters: param, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    
                    switch response.result {
                    case .success(_):
                        guard let data = response.value else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            print(apiError)
                            handler?(false)
                        } catch {
                            
                        }
                    }
                }
        }else{
            
        }

    }
    //MARK: END MHIOS-973
    
}
