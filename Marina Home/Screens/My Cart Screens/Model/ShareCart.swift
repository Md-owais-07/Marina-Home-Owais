//
//  ShareCart.swift
//  Marina Home
//
//  Created by santhosh t on 16/11/23.
//


import Foundation

struct ShareCart: Codable {

  var error   : Bool?   = nil
  var message : String? = nil
  var quoteId : String? = nil

  enum CodingKeys: String, CodingKey {

    case error   = "error"
    case message = "message"
    case quoteId = "quote_id"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    error   = try values.decodeIfPresent(Bool.self   , forKey: .error   )
    message = try values.decodeIfPresent(String.self , forKey: .message )
    quoteId = try values.decodeIfPresent(String.self , forKey: .quoteId )
 
  }

  init() {

  }

}

