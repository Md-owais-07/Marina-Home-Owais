//
//  AddressModel.swift
//  Marina Home
//
//  Created by Codilar on 22/05/23.
//

import Foundation
struct AddressModel : Codable {
    let id : Int?
    let group_id : Int?
    let default_billing : String?
    let default_shipping : String?
    let created_at : String?
    let updated_at : String?
    let created_in : String?
    let email : String?
    let firstname : String?
    let lastname : String?
    let store_id : Int?
    let website_id : Int?
    let addresses : [Addresses]?
    let disable_auto_group_change : Int?
    let extension_attributes : Extension_attributes?
    let custom_attributes : [Custom_attributes]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case group_id = "group_id"
        case default_billing = "default_billing"
        case default_shipping = "default_shipping"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case created_in = "created_in"
        case email = "email"
        case firstname = "firstname"
        case lastname = "lastname"
        case store_id = "store_id"
        case website_id = "website_id"
        case addresses = "addresses"
        case disable_auto_group_change = "disable_auto_group_change"
        case extension_attributes = "extension_attributes"
        case custom_attributes = "custom_attributes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        group_id = try values.decodeIfPresent(Int.self, forKey: .group_id)
        default_billing = try values.decodeIfPresent(String.self, forKey: .default_billing)
        default_shipping = try values.decodeIfPresent(String.self, forKey: .default_shipping)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        created_in = try values.decodeIfPresent(String.self, forKey: .created_in)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        firstname = try values.decodeIfPresent(String.self, forKey: .firstname)
        lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
        store_id = try values.decodeIfPresent(Int.self, forKey: .store_id)
        website_id = try values.decodeIfPresent(Int.self, forKey: .website_id)
        addresses = try values.decodeIfPresent([Addresses].self, forKey: .addresses)
        disable_auto_group_change = try values.decodeIfPresent(Int.self, forKey: .disable_auto_group_change)
        extension_attributes = try values.decodeIfPresent(Extension_attributes.self, forKey: .extension_attributes)
        custom_attributes = try values.decodeIfPresent([Custom_attributes].self, forKey: .custom_attributes)
    }

}


struct Addresses : Codable {
    let id : Int?
    let customer_id : Int?
    let region : Region?
    let region_id : Int?
    let country_id : String?
    let street : [String]?
    let telephone : String?
    let postcode : String?
    let city : String?
    let firstname : String?
    let lastname : String?
    let default_shipping : Bool?
    let default_billing : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case customer_id = "customer_id"
        case region = "region"
        case region_id = "region_id"
        case country_id = "country_id"
        case street = "street"
        case telephone = "telephone"
        case postcode = "postcode"
        case city = "city"
        case firstname = "firstname"
        case lastname = "lastname"
        case default_shipping = "default_shipping"
        case default_billing = "default_billing"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        customer_id = try values.decodeIfPresent(Int.self, forKey: .customer_id)
        region = try values.decodeIfPresent(Region.self, forKey: .region)
        region_id = try values.decodeIfPresent(Int.self, forKey: .region_id)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        street = try values.decodeIfPresent([String].self, forKey: .street)
        telephone = try values.decodeIfPresent(String.self, forKey: .telephone)
        postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        firstname = try values.decodeIfPresent(String.self, forKey: .firstname)
        lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
        default_shipping = try values.decodeIfPresent(Bool.self, forKey: .default_shipping)
        default_billing = try values.decodeIfPresent(Bool.self, forKey: .default_billing)
    }

}


struct Region : Codable {
    let region_code : String?
    let region : String?
    let region_id : Int?

    enum CodingKeys: String, CodingKey {

        case region_code = "region_code"
        case region = "region"
        case region_id = "region_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        region_code = try values.decodeIfPresent(String.self, forKey: .region_code)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        region_id = try values.decodeIfPresent(Int.self, forKey: .region_id)
    }

}
