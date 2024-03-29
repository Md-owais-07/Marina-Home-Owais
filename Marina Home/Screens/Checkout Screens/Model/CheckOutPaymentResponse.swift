// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct CheckoutResponse: Codable {
    let id: String?
    let status: String?
//    let amount: Int?
//    let currency: String?
//    let approved: Bool?
//    let status, authCode, responseCode, responseSummary: String?
    let the3Ds: The3Ds?
//    let risk: Risk?
//    let source: Source?
//    let customer: cCustomer?
//    let processedOn: Date?
//    let reference: String?
//    let processing: Processing?
//    let eci, schemeID: String?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id
        case status = "status"
//        case actionID = "action_id"
//        case amount, currency, approved, status
//        case authCode = "auth_code"
//        case responseCode = "response_code"
//        case responseSummary = "response_summary"
        case the3Ds = "3ds"
//        case risk, source, customer
//        case processedOn = "processed_on"
//        case reference, processing, eci
//        case schemeID = "scheme_id"
        case links = "_links"
    }
}

// MARK: - Customer
struct cCustomer: Codable {
    let id, email, name: String?
    let phone: PhoneCheckout?
}

// MARK: - Phone
struct PhoneCheckout: Codable {
    let countryCode, number: String?

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case number
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf,actions,redirect, refund: Action?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case actions, refund,redirect
    }
}

// MARK: - Action
struct Action: Codable {
    let href: String?
}

// MARK: - Processing
struct Processing: Codable {
    let retrievalReferenceNumber, acquirerTransactionID, recommendationCode: String?

    enum CodingKeys: String, CodingKey {
        case retrievalReferenceNumber = "retrieval_reference_number"
        case acquirerTransactionID = "acquirer_transaction_id"
        case recommendationCode = "recommendation_code"
    }
}

// MARK: - Risk
struct Risk: Codable {
    let flagged: Bool?
}

// MARK: - Source
struct Source: Codable {
    let type, id: String?
    let billingAddress: BillingAddress?
    let phone: PhoneCheckout?
    let last4, fingerprint, bin: String?

    enum CodingKeys: String, CodingKey {
        case type, id
        case billingAddress = "billing_address"
        case phone, last4, fingerprint, bin
    }
}

// MARK: - BillingAddress
struct BillingAddress: Codable {
    let addressLine1, addressLine2, city, state: String?
    let zip, country: String?

    enum CodingKeys: String, CodingKey {
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city, state, zip, country
    }
}

// MARK: - The3Ds
struct The3Ds: Codable {
    let downgraded: Bool?
    let enrolled: String?
}
struct OrderUpdateResponse: Codable {
    let message: String
    let status: Bool
    //MARK: START-MHIOS-1167
    let first_order: Bool
    //MARK: END-MHIOS-1167
}
