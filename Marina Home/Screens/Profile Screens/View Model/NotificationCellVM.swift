//
//  NotificationCellVM.swift
//  Marina Home
//
//  Created by Mohammad Owais on 01/04/24.
//

import Foundation
import Alamofire

extension NotificationCellVC {
    func fetchData(handler: @escaping (_ apiData:[NotificationDataModel]) -> (Void)) {
        
        var api = URLComponents(string: Constant.shared.apiUrl)!
        api.queryItems = [URLQueryItem(name: "customerEmail", value: Constant.shared.customerEmail)]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(Constant.shared.customerToken)"
        ]
        AF.request(api.url ?? "", method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode([NotificationDataModel].self, from: data!)
                        handler(jsonData)
                        print("JSON DATA WITH: \(jsonData)")
                    } catch {
                        print("ERROR CATCH BLOCK WITH: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("NOTIFICATION API Error WITH: \(error.localizedDescription)")
                }
            }
    }
    
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func orderNotificationApi(customerToken: String, completion: @escaping (Result<NotificationDataModel, Error>) -> Void) {
//        
//        var headers: HTTPHeaders = [:]
//        
//        let parameters: Parameters = [
//            "customerEmail": "mdowais932@gmail.com",
//        ]
//        
//        AF.request(notificationApi, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .responseDecodable(of: String.self) { response in
//                switch response.result {
//                case .success(let notify):
//                    if let apiResponse = notify as? String {
//                        completion(.success(apiResponse))
//                        print("Data")
//                    } else {
//                        completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
//                    }
//                case .failure(let err):
//                    print("Error response with: \(err.localizedDescription)")
//                    
//                    do {
//                        let apiError = try JSONDecoder.decode()
//                    } catch {
//                        
//                    }
//                }
//            }
//    }
