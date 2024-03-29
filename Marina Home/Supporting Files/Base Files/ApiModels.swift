//
//  ApiModels.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit
import Alamofire

class ApiModel {
   var method: HTTPMethod
   var url: String
   var takingToken: Bool
   var contentType: ApiContentType
   init(method: HTTPMethod,url: String,takingToken: Bool = false,contentType: ApiContentType = .json) {
      self.method = method
      self.url = url
      self.takingToken = takingToken
      self.contentType = contentType
   }
}

class ApiResponse{
   var status:ApiStatus
   var code:ApiStatusCode
   var message: String
   var data:Any?
   init(_ status:ApiStatus,code: Int = 900,message: String = "Something went wrong, please try again!",data:Any? = nil) {
      self.status = status
      self.code = ApiStatusCode(rawValue: code) ?? .other
      self.message = message
      self.data = data
   }
}

