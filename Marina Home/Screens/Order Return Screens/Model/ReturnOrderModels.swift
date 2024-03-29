//
//  ReturnOrderModels.swift
//  Marina Home
//
//  Created by Sooraj R on 25/07/23.
//

import Foundation
struct ReturnOrderInfoList : Codable {
    let reason : [Reason]?
    let solution : [Solution]?
    let additional_field : [Additional_field]?

    enum CodingKeys: String, CodingKey {

        case reason = "reason"
        case solution = "solution"
        case additional_field = "additional_field"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        reason = try values.decodeIfPresent([Reason].self, forKey: .reason)
        solution = try values.decodeIfPresent([Solution].self, forKey: .solution)
        additional_field = try values.decodeIfPresent([Additional_field].self, forKey: .additional_field)
    }

}

struct Content : Codable {
    let title : String?
    let type : String?
    let validation : String?
    let sort : Int?
    let is_require : Int?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case type = "type"
        case validation = "validation"
        case sort = "sort"
        case is_require = "is_require"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        validation = try values.decodeIfPresent(String.self, forKey: .validation)
        sort = try values.decodeIfPresent(Int.self, forKey: .sort)
        is_require = try values.decodeIfPresent(Int.self, forKey: .is_require)
    }

}

struct Additional_field : Codable {
    let value : String?
    let content : Content?

    enum CodingKeys: String, CodingKey {

        case value = "value"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        content = try values.decodeIfPresent(Content.self, forKey: .content)
    }

}

struct Reason : Codable {
    let value : String?
    let content : String?

    enum CodingKeys: String, CodingKey {

        case value = "value"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }

}

struct Solution : Codable {
    let value : String?
    let content : String?

    enum CodingKeys: String, CodingKey {

        case value = "value"
        case content = "content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }

}


struct OrderRequestModel : Codable {
    let request_id : Int?
    let order_id : Int?
    let order_increment_id : String?
    let increment_id : String?
    let status_id : Int?
    let is_canceled : Int?
    let store_id : Int?
    let comment : String?
    let files : [String]?
    let last_responded_by : String?
    let customer_email : String?
    let updated_at : String?
    let created_at : String?
    
    let request_item : [RequestItem]?
    let request_reply : [RequestReply]?
    let request_shipping_label : [RequestShippingLabel]?
    
    let reason : String?
    let solution : String?
    let additional_fields : String?

    
    enum CodingKeys: String, CodingKey {

        case request_id = "request_id"
        case order_id = "order_id"
        case order_increment_id = "order_increment_id"
        case increment_id = "increment_id"
        case status_id = "status_id"
        case is_canceled = "is_canceled"
        case store_id = "store_id"
        case comment = "comment"
        case files = "files"
        case last_responded_by = "last_responded_by"
        case customer_email = "customer_email"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case request_item = "request_item"
        case request_reply = "request_reply"
        case request_shipping_label = "request_shipping_label"
        case reason = "reason"
        case solution = "solution"
        case additional_fields = "additional_fields"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        request_id = try values.decodeIfPresent(Int.self, forKey: .request_id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        order_increment_id = try values.decodeIfPresent(String.self, forKey: .order_increment_id)
        increment_id = try values.decodeIfPresent(String.self, forKey: .increment_id)
        status_id = try values.decodeIfPresent(Int.self, forKey: .status_id)
        is_canceled = try values.decodeIfPresent(Int.self, forKey: .is_canceled)
        store_id = try values.decodeIfPresent(Int.self, forKey: .store_id)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        files = try values.decodeIfPresent([String].self, forKey: .files)
        last_responded_by = try values.decodeIfPresent(String.self, forKey: .last_responded_by)
        customer_email = try values.decodeIfPresent(String.self, forKey: .customer_email)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        request_item = try values.decodeIfPresent([RequestItem].self, forKey: .request_item)
        request_reply = try values.decodeIfPresent([RequestReply].self, forKey: .request_reply)
        request_shipping_label = try values.decodeIfPresent([RequestShippingLabel].self, forKey: .request_shipping_label)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        solution = try values.decodeIfPresent(String.self, forKey: .solution)
        additional_fields = try values.decodeIfPresent(String.self, forKey: .additional_fields)
    }

}


struct Request_item : Codable {
    let item_id : Int?
    let request_id : Int?
    let product_id : Int?
    let order_item_id : Int?
    let name : String?
    let sku : String?
    let qty_rma : Int?
    let price : Double?
    let price_returned : Double?
    let reason : String?
    let solution : String?
    let additional_fields : String?
    
    enum CodingKeys: String, CodingKey {

        case item_id = "item_id"
        case request_id = "request_id"
        case product_id = "product_id"
        case order_item_id = "order_item_id"
        case name = "name"
        case sku = "sku"
        case qty_rma = "qty_rma"
        case price = "price"
        case price_returned = "price_returned"
        case reason = "reason"
        case solution = "solution"
        case additional_fields = "additional_fields"
        
    }
   
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        item_id = try values.decodeIfPresent(Int.self, forKey: .item_id)
        request_id = try values.decodeIfPresent(Int.self, forKey: .request_id)
        product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
        order_item_id = try values.decodeIfPresent(Int.self, forKey: .order_item_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        qty_rma = try values.decodeIfPresent(Int.self, forKey: .qty_rma)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        price_returned = try values.decodeIfPresent(Double.self, forKey: .price_returned)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        solution = try values.decodeIfPresent(String.self, forKey: .solution)
        additional_fields = try values.decodeIfPresent(String.self, forKey: .additional_fields)
        
    }

}
