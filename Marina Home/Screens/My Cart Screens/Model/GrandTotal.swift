//
//  GrandTotal.swift
//  Marina Home
//
//  Created by Eljo on 22/05/23.
//

import Foundation
struct GrandTotal: Codable {
    let grandTotal: Double?
    let baseGrandTotal: Double?
    let subtotal, baseSubtotal: Double?
    let discountAmount, baseDiscountAmount: Double?
    let subtotalWithDiscount, baseSubtotalWithDiscount: Double?
    let shippingAmount, baseShippingAmount, shippingDiscountAmount, baseShippingDiscountAmount: Double?
    let taxAmount, baseTaxAmount: Double?
    //let weeeTaxAppliedAmount:Int?
    let shippingTaxAmount, baseShippingTaxAmount, subtotalInclTax, shippingInclTax: Double?
    let baseShippingInclTax: Double?
    let baseCurrencyCode, quoteCurrencyCode: String?
   // let itemsQty: Int?
    //let items: [ItemPrice]
    let totalSegments: [TotalSegment]
    let couponCode: String?
    //MARK: START MHIOS-1129
    let extensionAttributes: CartExtensionAttributes
    //MARK: END MHIOS-1129

    enum CodingKeys: String, CodingKey {
        case grandTotal = "grand_total"
        case baseGrandTotal = "base_grand_total"
        case subtotal = "subtotal"
        case baseSubtotal = "base_subtotal"
        case discountAmount = "discount_amount"
        case baseDiscountAmount = "base_discount_amount"
        case subtotalWithDiscount = "subtotal_with_discount"
        case baseSubtotalWithDiscount = "base_subtotal_with_discount"
        case shippingAmount = "shipping_amount"
        case baseShippingAmount = "base_shipping_amount"
        case shippingDiscountAmount = "shipping_discount_amount"
        case baseShippingDiscountAmount = "base_shipping_discount_amount"
        case taxAmount = "tax_amount"
        case baseTaxAmount = "base_tax_amount"
        //case weeeTaxAppliedAmount = "weee_tax_applied_amount"
        case shippingTaxAmount = "shipping_tax_amount"
        case baseShippingTaxAmount = "base_shipping_tax_amount"
        case subtotalInclTax = "subtotal_incl_tax"
        case shippingInclTax = "shipping_incl_tax"
        case baseShippingInclTax = "base_shipping_incl_tax"
        case baseCurrencyCode = "base_currency_code"
        case quoteCurrencyCode = "quote_currency_code"
        //MARK: START MHIOS-1129
        case extensionAttributes = "extension_attributes"
        //MARK: END MHIOS-1129
        //case itemsQty = "items_qty"
        //case items = "items"
        case totalSegments = "total_segments"
        case couponCode = "coupon_code"
    }
    
    /*init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        grandTotal = try values.decodeIfPresent(Double.self, forKey: .grandTotal)
        baseGrandTotal = try values.decodeIfPresent(Double.self, forKey: .baseGrandTotal)
        subtotal = try values.decodeIfPresent(Double.self, forKey: .subtotal)
        baseSubtotal = try values.decodeIfPresent(Double.self, forKey: .baseSubtotal)
        discountAmount = try values.decodeIfPresent(Double.self, forKey: .discountAmount)
        baseDiscountAmount = try values.decodeIfPresent(Double.self, forKey: .baseDiscountAmount)
        subtotalWithDiscount = try values.decodeIfPresent(Double.self, forKey: .subtotalWithDiscount)
        baseSubtotalWithDiscount = try values.decodeIfPresent(Double.self, forKey: .baseSubtotalWithDiscount)
        shippingAmount = try values.decodeIfPresent(Double.self, forKey: .shippingAmount)!
        baseShippingAmount = try values.decodeIfPresent(Double.self, forKey: .baseShippingAmount)
        shippingDiscountAmount = try values.decodeIfPresent(Double.self, forKey: .shippingDiscountAmount)!
        baseShippingDiscountAmount = try values.decodeIfPresent(Double.self, forKey: .baseShippingDiscountAmount)
        taxAmount = try values.decodeIfPresent(Double.self, forKey: .taxAmount)
        baseTaxAmount = try values.decodeIfPresent(Double.self, forKey: .baseTaxAmount)
        //weeeTaxAppliedAmount = try values.decodeIfPresent(Int.self, forKey: .weeeTaxAppliedAmount)!
        shippingTaxAmount = try values.decodeIfPresent(Double.self, forKey: .shippingTaxAmount)
        baseShippingTaxAmount = try values.decodeIfPresent(Double.self, forKey: .baseShippingTaxAmount)
        subtotalInclTax = try values.decodeIfPresent(Double.self, forKey: .subtotalInclTax)!
        shippingInclTax = try values.decodeIfPresent(Double.self, forKey: .shippingInclTax)!
        baseShippingInclTax = try values.decodeIfPresent(Double.self, forKey: .baseShippingInclTax)!
        baseCurrencyCode = try values.decodeIfPresent(String.self, forKey: .baseCurrencyCode)!
        quoteCurrencyCode = try values.decodeIfPresent(String.self, forKey: .quoteCurrencyCode)!
      //  itemsQty = try values.decodeIfPresent(Int.self, forKey: .itemsQty)!
      //  items = try values.decodeIfPresent([ItemPrice].self, forKey: .items)!
      //  totalSegments = try values.decodeIfPresent([TotalSegment].self, forKey: .totalSegments)!
        couponCode = try values.decodeIfPresent(String.self, forKey: .couponCode)
    }*/
}
//MARK: START MHIOS-1129
struct CartExtensionAttributes: Codable {
    let instantCouponApplied: Bool

    enum CodingKeys: String, CodingKey {
        case instantCouponApplied = "instant_coupon_applied"
    }
}
//MARK: START MHIOS-1129
// MARK: - Item
struct ItemPrice: Codable {
    let itemID: Int
    let price, basePrice: Double
    let qty: Int
    let rowTotal, baseRowTotal: Double
    let rowTotalWithDiscount: Double
    let taxAmount, baseTaxAmount: Double
    let taxPercent, discountAmount, baseDiscountAmount, discountPercent: Double
    let priceInclTax, basePriceInclTax, rowTotalInclTax, baseRowTotalInclTax: Double
    let options: String
    //let weeeTaxAppliedAmount: Double?
    let weeeTaxApplied: Double?
    let name: String

    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case price = "price"
        case basePrice = "base_price"
        case qty = "qty"
        case rowTotal = "row_total"
        case baseRowTotal = "base_row_total"
        case rowTotalWithDiscount = "row_total_with_discount"
        case taxAmount = "tax_amount"
        case baseTaxAmount = "base_tax_amount"
        case taxPercent = "tax_percent"
        case discountAmount = "discount_amount"
        case baseDiscountAmount = "base_discount_amount"
        case discountPercent = "discount_percent"
        case priceInclTax = "price_incl_tax"
        case basePriceInclTax = "base_price_incl_tax"
        case rowTotalInclTax = "row_total_incl_tax"
        case baseRowTotalInclTax = "base_row_total_incl_tax"
        case options = "options"
        ///case weeeTaxAppliedAmount = "weee_tax_applied_amount"
        case weeeTaxApplied = "weee_tax_applied"
        case name = "name"
    }
}

// MARK: - TotalSegment
struct TotalSegment: Codable {
    let code, title: String
    let value: Double
    //let extensionAttributes: ExtensionAttributes?
    //let area: String?

    enum CodingKeys: String, CodingKey {
        case code, title, value
        //case extensionAttributes = "extension_attributes"
        //case area
    }
}

// MARK: - TaxGrandtotalDetail
struct TaxGrandtotalDetail: Codable {
    let amount: Double
    let rates: [Rate]
    let groupID: Int

    enum CodingKeys: String, CodingKey {
        case amount, rates
        case groupID = "group_id"
    }
}

// MARK: - Rate
struct Rate: Codable {
    let percent, title: String
}
