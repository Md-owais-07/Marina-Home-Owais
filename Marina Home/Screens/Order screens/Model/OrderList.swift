//
//  OrderList.swift
//  Marina Home
//
//  Created by Eljo on 22/06/23.
//

import Foundation
struct OrderList: Codable {
    var items: [OrderListItem]?
    

    enum CodingKeys: String, CodingKey {
        case items
       
    }
}

// MARK: - WelcomeItem
struct OrderListItem: Codable {
    let created_at : String?
    let customer_email : String?
    let customer_firstname : String?
    let customer_lastname : String?
    let entity_id : Int?
    let grand_total : Double?
    let increment_id : String?
    let status : String?
    let total_item_count : Int?
    let total_qty_ordered : Int?
    let billing_address : Billing_address?
    let extensionAttributes: OrderListExtenstionAttributes?
    
    enum CodingKeys: String, CodingKey {

        case created_at = "created_at"
        case customer_email = "customer_email"
        case customer_firstname = "customer_firstname"
        case customer_lastname = "customer_lastname"
        case entity_id = "entity_id"
        case grand_total = "grand_total"
        case increment_id = "increment_id"
        case status = "status"
        case total_item_count = "total_item_count"
        case total_qty_ordered = "total_qty_ordered"
        case billing_address = "billing_address"
        case extensionAttributes = "extension_attributes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        customer_email = try values.decodeIfPresent(String.self, forKey: .customer_email)
        customer_firstname = try values.decodeIfPresent(String.self, forKey: .customer_firstname)
        customer_lastname = try values.decodeIfPresent(String.self, forKey: .customer_lastname)
        entity_id = try values.decodeIfPresent(Int.self, forKey: .entity_id)
        do {
            let total = try values.decodeIfPresent(Double.self, forKey: .grand_total)
            grand_total = total;
        }catch{
            let total = try values.decodeIfPresent(Int.self, forKey: .grand_total)
            grand_total = Double(total ?? 0) 
        }
        increment_id = try values.decodeIfPresent(String.self, forKey: .increment_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        total_item_count = try values.decodeIfPresent(Int.self, forKey: .total_item_count)
        total_qty_ordered = try values.decodeIfPresent(Int.self, forKey: .total_qty_ordered)
        billing_address = try values.decodeIfPresent(Billing_address.self, forKey: .billing_address)
        extensionAttributes = try values.decodeIfPresent(OrderListExtenstionAttributes.self, forKey: .extensionAttributes)
    }

}
struct OrderListExtenstionAttributes: Codable {
    
    let statusLabel: String?

    enum CodingKeys: String, CodingKey {
        case statusLabel = "status_label"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusLabel = try values.decodeIfPresent(String.self, forKey: .statusLabel)
    }
}



struct BillingAddresses : Codable {
       
        let city: String?
        let countryID: String?
        let email: String?
        let entityID: Int?
        let firstname: String?
        let lastname: String?
        let parentID: Int?
        let postcode: String?
        //let region: Region?
        
        let regionID: Int?
        let street: [String]?
        let telephone: String?
        let customerAddressID: Int?

        enum CodingKeys: String, CodingKey {
           
            case city
            case countryID = "country_id"
            case email
            case entityID = "entity_id"
            case firstname, lastname
            case parentID = "parent_id"
            case postcode
           
            case regionID = "region_id"
            case street, telephone
            case customerAddressID = "customer_address_id"
        }
    }

    enum AddressType: String, Codable {
        case billing = "billing"
        case shipping = "shipping"
    }
