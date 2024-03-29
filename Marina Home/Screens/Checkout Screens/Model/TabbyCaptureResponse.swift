//
//  TabbyCaptureResponse.swift
//  Marina Home
//
//  Created by Eljo on 17/09/23.
//

import Foundation
struct TabbyCaptureResponse: Codable {
    let amount, taxAmount, shippingAmount, discountAmount: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case taxAmount = "tax_amount"
        case shippingAmount = "shipping_amount"
        case discountAmount = "discount_amount"
        case createdAt = "created_at"
    }
}
