//
//  UpdateCart.swift
//  Marina Home
//
//  Created by santhosh t on 13/07/23.
//

import Foundation

// MARK: - UpdateCart
struct UpdateCart: Codable {
    
    let itemID: Int?
    let sku: String?
    let qty: Int?
    let name: String?
    let price: Double?
    let productType: String?
    let quoteID: String?
    let message: String?
    //let extensionAttributes: ExtensionAttributes

    enum CodingKeys: String, CodingKey {
            case itemID              = "item_id"
            case sku                 = "sku"
            case qty                 = "qty"
            case name                = "name"
            case price               = "price"
            case productType         = "product_type"
            case quoteID             = "quote_id"
            case message             = "message"
            //case extensionAttributes = "extension_attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        itemID = try values.decodeIfPresent(Int.self, forKey: .itemID)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        productType = try values.decodeIfPresent(String.self, forKey: .productType)
        quoteID = try values.decodeIfPresent(String.self, forKey: .quoteID)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        //extensionAttributes = try values.decodeIfPresent(ExtensionAttributes.self, forKey: .extensionAttributes)!
    }
    
    // MARK: - ExtensionAttributes
//    struct ExtensionAttributes: Codable {
//        let discounts: [Discount]
//        let preorderInfo: PreorderInfo
//        let image, shortDescription: String
//
//        enum CodingKeys: String, CodingKey {
//            case discounts          = "discounts"
//            case preorderInfo       = "preorder_info"
//            case image              = "image"
//            case shortDescription   = "short_description"
//
//        }
//
//        init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//            discounts = try values.decodeIfPresent([Discount].self, forKey: .discounts)!
//            preorderInfo = try values.decodeIfPresent(PreorderInfo.self, forKey: .preorderInfo)!
//            image = try values.decodeIfPresent(String.self, forKey: .image)!
//            shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)!
//
//        }
//
//        // MARK: - PreorderInfo
//        struct PreorderInfo: Codable {
//            let preorder: Bool
//            let note: String
//
//            enum CodingKeys: String, CodingKey {
//                case preorder   = "preorder"
//                case note       = "note"
//            }
//
//            init(from decoder: Decoder) throws {
//                let values = try decoder.container(keyedBy: CodingKeys.self)
//                preorder = try values.decodeIfPresent(Bool.self, forKey: .preorder)!
//                note = try values.decodeIfPresent(String.self, forKey: .note)!
//
//            }
//        }
//
//    }
    
    
}





// MARK: - Discount
struct Discount: Codable {
    let discountData: DiscountData?
    let ruleLabel: String?
    let ruleID: Int?

    enum CodingKeys: String, CodingKey {
        case discountData = "discount_data"
        case ruleLabel    = "rule_label"
        case ruleID       = "rule_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        discountData = try values.decodeIfPresent(DiscountData.self, forKey: .discountData)!
        ruleLabel = try values.decodeIfPresent(String.self, forKey: .ruleLabel)!
        ruleID = try values.decodeIfPresent(Int.self, forKey: .ruleID)!
        
    }
}


// MARK: - DiscountData
struct DiscountData: Codable {
    let amount, baseAmount, originalAmount, baseOriginalAmount: Double?

    enum CodingKeys: String, CodingKey {
        case amount             = "amount"
        case baseAmount         = "base_amount"
        case originalAmount     = "original_amount"
        case baseOriginalAmount = "base_original_amount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        baseAmount = try values.decodeIfPresent(Double.self, forKey: .baseAmount)
        originalAmount = try values.decodeIfPresent(Double.self, forKey: .originalAmount)
        baseOriginalAmount = try values.decodeIfPresent(Double.self, forKey: .baseOriginalAmount)
        
    }
}








