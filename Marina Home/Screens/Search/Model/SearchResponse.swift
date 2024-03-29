//
//  SearchResponse.swift
//  Marina Home
//
//  Created by Eljo on 04/07/23.
//

import Foundation
struct SearchResponse: Codable {
    let meta: SearchMeta
    let suggestionResults: [SuggestionResult]
    let queryResults: [QueryResult]
}

// MARK: - WelcomeMeta
struct SearchMeta: Codable {
    let qTime, responseCode: Int
}

// MARK: - QueryResult
struct QueryResult: Codable {
    let id: String
    let meta: QueryResultMeta
    let records: [RecordsYML]?
    //let filters: [JSONAny]
}

// MARK: - QueryResultMeta
struct QueryResultMeta: Codable {
    let qTime, noOfResults, totalResultsFound: Int?
    let typeOfSearch: String?
    let offset: Int?
    let debuggingInformation: DebuggingInformation
    let notificationCode: Int?
    let searchedTerm, apiKey: String?
    let isPersonalised: Bool
}

// MARK: - DebuggingInformation
struct DebuggingInformation: Codable {
}

// MARK: - Record
struct RecordProducts: Codable {
    let materialF, color, subCategory: String?
    let hideGroupPrices, itemGroupID: String
    let colorF: String?
    let freeShipping, storeBaseCurrency, price, toPrice: String
    let imageURL: String
    let finish: String?
    let inStock, currency, id, imageHover: String
    let sku, basePrice, startPrice: String
    let image: String
    let deliveryInfo, hideAddToCart, salePrice, swatchesInfo: String
    let weight, klevuCategory: String
    let totalVariants: Int
    let groupPrices: String
    let url: String
    let material, categoryMain: String?
    let name, shortDesc, category, typeOfRecord: String

    enum CodingKeys: String, CodingKey {
        case materialF = "material_f"
        case color
        case subCategory = "sub_category"
        case hideGroupPrices
        case itemGroupID = "itemGroupId"
        case colorF = "color_f"
        case freeShipping, storeBaseCurrency, price, toPrice
        case imageURL = "imageUrl"
        case finish, inStock, currency, id, imageHover, sku, basePrice, startPrice, image, deliveryInfo, hideAddToCart, salePrice, swatchesInfo, weight
        case klevuCategory = "klevu_category"
        case totalVariants, groupPrices, url, material
        case categoryMain = "category_main"
        case name, shortDesc, category, typeOfRecord
    }
}

// MARK: - SuggestionResult
struct SuggestionResult: Codable {
    let id: String
    let suggestions: [Suggestion]
}

// MARK: - Suggestion
struct Suggestion: Codable {
    let suggest: String
}
