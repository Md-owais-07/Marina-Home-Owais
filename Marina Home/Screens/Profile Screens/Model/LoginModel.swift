//
//  LoginModel.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit
struct errorModel: Decodable{
    var message:String
    //MARK: START MHIOS-1245
    //var trace:String
    //MARK: END MHIOS-1245
}

// MARK: - RegisterModel
struct UserModel: Decodable {
    var id, group_id: Int
    var created_at, updated_at, created_in, email: String
    var firstname, lastname: String
    var store_id, website_id: Int
    var addresses: [Addressess]
    var disable_auto_group_change: Int
    var extension_attributes: ExtensionAttributes
    var custom_attributes: [CustomAttribute]
}

// MARK: - CustomAttribute
struct Addressess: Decodable {
}

// MARK: - CustomAttribute
struct CustomAttribute: Decodable {
    var attribute_code: String
    var value: String?
}

// MARK: - ExtensionAttributes
struct ExtensionAttributes: Decodable {
    var is_subscribed: Bool
}
struct Country1: Codable {
    let id : String?
    let two_letter_abbreviation : String?
    let three_letter_abbreviation : String?
    let full_name_locale : String?
    let full_name_english : String?
    let available_regions : [Available_regions]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case two_letter_abbreviation = "two_letter_abbreviation"
        case three_letter_abbreviation = "three_letter_abbreviation"
        case full_name_locale = "full_name_locale"
        case full_name_english = "full_name_english"
        case available_regions = "available_regions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        two_letter_abbreviation = try values.decodeIfPresent(String.self, forKey: .two_letter_abbreviation)
        three_letter_abbreviation = try values.decodeIfPresent(String.self, forKey: .three_letter_abbreviation)
        full_name_locale = try values.decodeIfPresent(String.self, forKey: .full_name_locale)
        full_name_english = try values.decodeIfPresent(String.self, forKey: .full_name_english)
        available_regions = try values.decodeIfPresent([Available_regions].self, forKey: .available_regions)
    }
}

struct Available_regions : Codable {
    let id : String?
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case code = "code"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
