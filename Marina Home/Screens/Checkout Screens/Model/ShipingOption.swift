//
//  ShipingOption.swift
//  Marina Home
//
//  Created by Eljo on 30/06/23.
//

import Foundation
struct ShipingOption: Codable {
    let carrierCode, methodCode, methodTitle: String
    let amount, baseAmount: Int
    let available: Bool
    
    let errorMessage: String
    let priceExclTax, priceInclTax: Int

    enum CodingKeys: String, CodingKey {
        case carrierCode = "carrier_code"
        case methodCode = "method_code"
        case methodTitle = "method_title"
        case amount
        case baseAmount = "base_amount"
        case available
        
        case errorMessage = "error_message"
        case priceExclTax = "price_excl_tax"
        case priceInclTax = "price_incl_tax"
    }
}
