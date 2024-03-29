//
//  Cart.swift
//  Marina Home
//
//  Created by Codilar on 17/05/23.
//

import Foundation


// MARK: - Welcome
struct Cart: Codable {
    let id: Int
    let createdAt, image, updatedAt: String?
    let isActive, isVirtual: Bool?
    let items: [CartItem]?
    let itemsCount, itemsQty: Int?
    //let customer: Customer?
    //let billingAddress: Addresses?
    let origOrderID: Int?
    let currency: Currency?
    let customerIsGuest, customerNoteNotify: Bool?
    let customerTaxClassID, storeID: Int?
    let extensionAttributes: WelcomeExtensionAttributes?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case image = "image"
        case updatedAt = "updated_at"
        case isActive = "is_active"
        case isVirtual = "is_virtual"
        case items
        case itemsCount = "items_count"
        case itemsQty = "items_qty"
        //case customer
        //case billingAddress = "billing_address"
        case origOrderID = "orig_order_id"
        case currency
        case customerIsGuest = "customer_is_guest"
        case customerNoteNotify = "customer_note_notify"
        case customerTaxClassID = "customer_tax_class_id"
        case storeID = "store_id"
        case extensionAttributes = "extension_attributes"
    }
}



// MARK: - Currency
struct Currency: Codable {
    let globalCurrencyCode, baseCurrencyCode, storeCurrencyCode, quoteCurrencyCode: String?
    let storeToBaseRate, storeToQuoteRate, baseToGlobalRate, baseToQuoteRate: Int?

    enum CodingKeys: String, CodingKey {
        case globalCurrencyCode = "global_currency_code"
        case baseCurrencyCode = "base_currency_code"
        case storeCurrencyCode = "store_currency_code"
        case quoteCurrencyCode = "quote_currency_code"
        case storeToBaseRate = "store_to_base_rate"
        case storeToQuoteRate = "store_to_quote_rate"
        case baseToGlobalRate = "base_to_global_rate"
        case baseToQuoteRate = "base_to_quote_rate"
    }
}

// MARK: - Customer
struct Customer: Codable {
    let id, groupID: Int
    let defaultBilling, defaultShipping, createdAt, updatedAt: String
    let createdIn, email, firstname, lastname: String
    let storeID, websiteID: Int
    let addresses: [Addresses]
    let disableAutoGroupChange: Int
    let extensionAttributes: CustomerExtensionAttributes
    //let customAttributes: [CustomAttribute]

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case defaultBilling = "default_billing"
        case defaultShipping = "default_shipping"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case createdIn = "created_in"
        case email, firstname, lastname
        case storeID = "store_id"
        case websiteID = "website_id"
        case addresses
        case disableAutoGroupChange = "disable_auto_group_change"
        case extensionAttributes = "extension_attributes"
        //case customAttributes = "custom_attributes"
    }
}



// MARK: - CustomerExtensionAttributes
struct CustomerExtensionAttributes: Codable {
    let isSubscribed: Bool?

    enum CodingKeys: String, CodingKey {
        case isSubscribed = "is_subscribed"
    }
}

// MARK: - WelcomeExtensionAttributes
struct WelcomeExtensionAttributes: Codable {
    //let shippingAssignments: [ShippingAssignment]?
    let isPostpayAvailable: String?
    let isTabbyAvailable: String?

    enum CodingKeys: String, CodingKey {
       // case shippingAssignments = "shipping_assignments"
        case isPostpayAvailable = "is_postpay_available"
        case isTabbyAvailable = "is_tabby_available"
    }
}

// MARK: - ShippingAssignment
struct ShippingAssignment: Codable {
    let shipping: Shipping?
    let items: [CartItem]?
}

// MARK: - Item
struct CartItem: Codable {
    let itemID: Int?
    let sku: String?
    let qty: Int?
    let name: String?
    let price: Double?
    let productType, quoteID: String?
    let extension_attributes: ExtensionAttributes?
    
    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case sku, qty, name, price
        case productType = "product_type"
        case quoteID = "quote_id"
        case extension_attributes = "extension_attributes"
        
    }
    
    struct ExtensionAttributes: Codable {
        let image: String?
        let short_description: String?
        let salable_qty: String?
        let original_price: String?
        let custom_product_id: Int?
        //MARK START{MHIOS-1020 and MHIOS-1090}
        let only_qty_left: String?
        //MARK END{MHIOS-1020 and MHIOS-1090}
        //MARK START{MHIOS-1033}
        let cart_item_warning_message: String?
        let wp_warning_message: String?
        //MARK END{MHIOS-1033}
        enum CodingKeys: String, CodingKey {
            case image = "image"
            case short_description = "short_description"
            case salable_qty = "salable_qty"
            case original_price = "original_price"
            case custom_product_id = "custom_product_id"
            //MARK START{MHIOS-1020 and MHIOS-1090}
            case only_qty_left = "only_qty_left"
            //MARK END{MHIOS-1020 and MHIOS-1090}
            //MARK START{MHIOS-1033}
            case cart_item_warning_message = "cart_item_warning_message"
            case wp_warning_message = "wp_warning_message"
            //MARK END{MHIOS-1033}
        }
    }
}

// MARK: - Shipping
struct Shipping: Codable {
    let address: Addresses?
    let method: String?
}


// MARK: - Encode/decode helpers






