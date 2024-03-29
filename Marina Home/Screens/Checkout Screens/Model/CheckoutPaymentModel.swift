//
//  CheckoutPaymentModel.swift
//  Marina Home
//
//  Created by Codilar on 23/05/23.
//

import Foundation
struct CheckoutPaymentModel : Codable {
   
        let paymentMethods: [PaymentMethod]
        let totals: Totals

        enum CodingKeys: String, CodingKey {
            case paymentMethods = "payment_methods"
            case totals
        }
    }

    // MARK: - PaymentMethod
    struct PaymentMethod: Codable {
        let code, title: String
    }

    // MARK: - Totals
    struct Totals: Codable {
        let grandTotal: Double
        let baseGrandTotal: Double?
        let subtotal, baseSubtotal: Double?
        let discountAmount, baseDiscountAmount: Double?
        let subtotalWithDiscount, baseSubtotalWithDiscount: Double?
        let shippingAmount, baseShippingAmount, shippingDiscountAmount, baseShippingDiscountAmount: Double?
        let taxAmount, baseTaxAmount: Double?
        let weeeTaxAppliedAmount: Double?
        let shippingTaxAmount, baseShippingTaxAmount, subtotalInclTax, shippingInclTax: Double
        let baseShippingInclTax: Double
        let baseCurrencyCode, quoteCurrencyCode: String
        let itemsQty: Int
        //let items: [Item]
        //let totalSegments: [TotalSegment]

        enum CodingKeys: String, CodingKey {
            case grandTotal = "grand_total"
            case baseGrandTotal = "base_grand_total"
            case subtotal
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
            case weeeTaxAppliedAmount = "weee_tax_applied_amount"
            case shippingTaxAmount = "shipping_tax_amount"
            case baseShippingTaxAmount = "base_shipping_tax_amount"
            case subtotalInclTax = "subtotal_incl_tax"
            case shippingInclTax = "shipping_incl_tax"
            case baseShippingInclTax = "base_shipping_incl_tax"
            case baseCurrencyCode = "base_currency_code"
            case quoteCurrencyCode = "quote_currency_code"
            case itemsQty = "items_qty"
            //case items
            //case totalSegments = "total_segments"
        }
    }

   
struct PaymentTrasactionDetail: Codable {
    let id, type: String
    let processedOn: String?
    let amount: Int?
    let approved: Bool
    let responseCode, responseSummary: String?
    let processing: Processing1?
    //MARK: START MHIOS-1192
   // let metadata: Metadata?
    //MARK: END MHIOS-1192
    let authCode, reference: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case processedOn = "processed_on"
        case amount, approved
        case responseCode = "response_code"
        case responseSummary = "response_summary"
        case processing
        //MARK: START MHIOS-1192
       // , metadata
        //MARK: END MHIOS-1192
        case authCode = "auth_code"
        case reference
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let shippingRef: String

    enum CodingKeys: String, CodingKey {
        case shippingRef = "shipping_ref"
    }
}

// MARK: - Processing
struct Processing1: Codable {
    let acquirerReferenceNumber: String?
    let acquirerTransactionID: String
    let retrievalReferenceNumber: String?

    enum CodingKeys: String, CodingKey {
        case acquirerReferenceNumber = "acquirer_reference_number"
        case acquirerTransactionID = "acquirer_transaction_id"
        case retrievalReferenceNumber = "retrieval_reference_number"
    }
}
struct PostPayChekoutResponse: Codable {
    let token, expires: String
    let redirectURL: String
    let reference: String

    enum CodingKeys: String, CodingKey {
        case token, expires
        case redirectURL = "redirect_url"
        case reference
    }
}
