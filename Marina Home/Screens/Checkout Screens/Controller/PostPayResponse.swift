//
//  PostPayResponse.swift
//  Marina Home
//
//  Created by Eljo on 14/07/23.
//

import Foundation
struct PostPayResponse: Codable {
    let orderID, status, statusChanged: String?
    let totalAmount, taxAmount: Int?
    let currency, created: String?
    let shipping: postPayShipping?
    let billingAddress: postPayAddress?
    let customer: postPayCustomer?
    let items: [postPayItem]?
    let discounts: [postPayDiscount]?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case status
        case statusChanged = "status_changed"
        case totalAmount = "total_amount"
        case taxAmount = "tax_amount"
        case currency, created, shipping
        case billingAddress = "billing_address"
        case customer, items, discounts
    }
}

// MARK: - Address
struct postPayAddress: Codable {
    let firstName, lastName, phone, altPhone: String?
    let line1, line2, city, state: String?
    let country, postalCode: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case altPhone = "alt_phone"
        case line1, line2, city, state, country
        case postalCode = "postal_code"
    }
}

// MARK: - Customer
struct postPayCustomer: Codable {
    let id, email, firstName, lastName: String?
    let gender, account, dateOfBirth, dateJoined: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case gender, account
        case dateOfBirth = "date_of_birth"
        case dateJoined = "date_joined"
    }
}

// MARK: - Discount
struct postPayDiscount: Codable {
    let code, name: String?
    let amount: Int?
}

// MARK: - Item
struct postPayItem: Codable {
    let reference, name, description: String?
    let url: String?
    let imageURL: String?
    let unitPrice, qty: Int?

    enum CodingKeys: String, CodingKey {
        case reference, name, description, url
        case imageURL = "image_url"
        case unitPrice = "unit_price"
        case qty
    }
}

// MARK: - Shipping
struct postPayShipping: Codable {
    let id, name: String
    let amount: Int
    let address: postPayAddress
}
