//
//  PaymentCardModel.swift
//  Marina Home
//
//  Created by Eljo on 18/07/23.
//

import Foundation
struct PaymentCardModel : Codable {
    let type : String?
    let maskedCC : String?
    let expirationDate : String?
    let public_hash : String?
    let src_id : String?
    enum CodingKeys: String, CodingKey {

        case src_id = "src_id"
        case type = "type"
        case maskedCC = "maskedCC"
        case expirationDate = "expirationDate"
        case public_hash = "public_hash"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        src_id = try values.decodeIfPresent(String.self, forKey: .src_id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        maskedCC = try values.decodeIfPresent(String.self, forKey: .maskedCC)
        expirationDate = try values.decodeIfPresent(String.self, forKey: .expirationDate)
        public_hash = try values.decodeIfPresent(String.self, forKey: .public_hash)
    }

}
