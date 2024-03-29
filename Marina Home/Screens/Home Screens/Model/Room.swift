//
//  Room.swift
//  Marina Home
//
//  Created by Codilar on 08/05/23.
//

import Foundation

struct Room: Codable {
    let id, status, main_title: String
    let shop_by_room: [ShopByRoom]
    let store_id,identifier: String

    
}

// MARK: - ShopByRoom
struct ShopByRoom: Codable {
    let sub_title, record_id, image : String
    let products: [Product]

    
}
struct Product: Codable {
    let id, image, price, name,sku , special_price, special_from_date ,special_to_date : String? //
    var customAttributes: [productCustomAttribute]?
    
    struct productCustomAttribute : Codable {
        let attribute_code : String?
        var value: Value?

        enum CodingKeys: String, CodingKey {

            case attribute_code = "attribute_code"
            case value = "value"
        }
        
        enum Value: Codable {
            
            case string(String)
            case stringArray([String])
            init(from decoder: Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    if let x = try? container.decode([String].self) {
                        self = .stringArray(x)
                        return
                    }
                    if let x = try? container.decode(String.self) {
                        self = .string(x)
                        return
                    }
                    throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
                }
        }

    }
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case image = "image"
        case price = "price"
        case name = "name"
        case sku = "sku"
        case special_price = "special_price"
        case special_from_date = "special_from_date"
        case special_to_date = "special_to_date"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        special_price = try values.decodeIfPresent(String.self, forKey: .special_price)
        special_from_date = try values.decodeIfPresent(String.self, forKey: .special_from_date)
        special_to_date = try values.decodeIfPresent(String.self, forKey: .special_to_date)
        
    }
}



