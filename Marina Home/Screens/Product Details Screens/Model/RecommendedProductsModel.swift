//
//  RecommendedProductsModel.swift
//  Marina Home
//
//  Created by Codilar on 25/05/23.
//

import Foundation
struct RecommendedProductsModel : Codable {
    let meta : Meta?
    let queryResults : [QueryResults]?

    enum CodingKeys: String, CodingKey {

        case meta = "meta"
        case queryResults = "queryResults"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        meta = try values.decodeIfPresent(Meta.self, forKey: .meta)
        queryResults = try values.decodeIfPresent([QueryResults].self, forKey: .queryResults)
    }

}

struct Meta : Codable {
    let qTime : Int?
    let noOfResults : Int?
    let totalResultsFound : Int?
    let typeOfSearch : String?
    let offset : Int?
//    let debuggingInformation : DebuggingInformation?
    let notificationCode : Int?
    let searchedTerm : String?
    let apiKey : String?
    let isPersonalised : Bool?
    let idsUsedForPersonalisation : [String]?

    enum CodingKeys: String, CodingKey {

        case qTime = "qTime"
        case noOfResults = "noOfResults"
        case totalResultsFound = "totalResultsFound"
        case typeOfSearch = "typeOfSearch"
        case offset = "offset"
//        case debuggingInformation = "debuggingInformation"
        case notificationCode = "notificationCode"
        case searchedTerm = "searchedTerm"
        case apiKey = "apiKey"
        case isPersonalised = "isPersonalised"
        case idsUsedForPersonalisation = "idsUsedForPersonalisation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        qTime = try values.decodeIfPresent(Int.self, forKey: .qTime)
        noOfResults = try values.decodeIfPresent(Int.self, forKey: .noOfResults)
        totalResultsFound = try values.decodeIfPresent(Int.self, forKey: .totalResultsFound)
        typeOfSearch = try values.decodeIfPresent(String.self, forKey: .typeOfSearch)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
//        debuggingInformation = try values.decodeIfPresent(DebuggingInformation.self, forKey: .debuggingInformation)
        notificationCode = try values.decodeIfPresent(Int.self, forKey: .notificationCode)
        searchedTerm = try values.decodeIfPresent(String.self, forKey: .searchedTerm)
        apiKey = try values.decodeIfPresent(String.self, forKey: .apiKey)
        isPersonalised = try values.decodeIfPresent(Bool.self, forKey: .isPersonalised)
        idsUsedForPersonalisation = try values.decodeIfPresent([String].self, forKey: .idsUsedForPersonalisation)
    }

}


struct QueryResults : Codable {
    let id : String?
    let meta : Meta?
    let records : [Records]?
    let filters : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case meta = "meta"
        case records = "records"
        case filters = "filters"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        meta = try values.decodeIfPresent(Meta.self, forKey: .meta)
        records = try values.decodeIfPresent([Records].self, forKey: .records)
        filters = try values.decodeIfPresent([String].self, forKey: .filters)
    }

}

//struct DebuggingInformation : Codable {
//
//    enum CodingKeys: String, CodingKey {
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }
//
//}


struct Records : Codable {
    let material_f : String?
    let sub_category : String?
    let hideGroupPrices : String?
    let itemGroupId : String?
    let color_f : String?
    let freeShipping : String?
    let storeBaseCurrency : String?
    let price : String?
    let toPrice : String?
    let imageUrl : String?
    let inStock : String?
    let currency : String?
    let id : String?
    let imageHover : String?
    let sku : String?
    let basePrice : String?
    let startPrice : String?
    let image : String?
    let deliveryInfo : String?
    let hideAddToCart : String?
    let salePrice : String?
    let swatchesInfo : String?
    let weight : String?
    let klevu_category : String?
    let totalVariants : Int?
    let groupPrices : String?
    let url : String?
    let category_main : String?
    let name : String?
    let shortDesc : String?
    let category : String?
    let typeOfRecord : String?
    var customAttributes: [productCustomAttribute]?

    enum CodingKeys: String, CodingKey {

        case material_f = "material_f"
        case sub_category = "sub_category"
        case hideGroupPrices = "hideGroupPrices"
        case itemGroupId = "itemGroupId"
        case color_f = "color_f"
        case freeShipping = "freeShipping"
        case storeBaseCurrency = "storeBaseCurrency"
        case price = "price"
        case toPrice = "toPrice"
        case imageUrl = "imageUrl"
        case inStock = "inStock"
        case currency = "currency"
        case id = "id"
        case imageHover = "imageHover"
        case sku = "sku"
        case basePrice = "basePrice"
        case startPrice = "startPrice"
        case image = "image"
        case deliveryInfo = "deliveryInfo"
        case hideAddToCart = "hideAddToCart"
        case salePrice = "salePrice"
        case swatchesInfo = "swatchesInfo"
        case weight = "weight"
        case klevu_category = "klevu_category"
        case totalVariants = "totalVariants"
        case groupPrices = "groupPrices"
        case url = "url"
        case category_main = "category_main"
        case name = "name"
        case shortDesc = "shortDesc"
        case category = "category"
        case typeOfRecord = "typeOfRecord"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        material_f = try values.decodeIfPresent(String.self, forKey: .material_f)
        sub_category = try values.decodeIfPresent(String.self, forKey: .sub_category)
        hideGroupPrices = try values.decodeIfPresent(String.self, forKey: .hideGroupPrices)
        itemGroupId = try values.decodeIfPresent(String.self, forKey: .itemGroupId)
        color_f = try values.decodeIfPresent(String.self, forKey: .color_f)
        freeShipping = try values.decodeIfPresent(String.self, forKey: .freeShipping)
        storeBaseCurrency = try values.decodeIfPresent(String.self, forKey: .storeBaseCurrency)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        toPrice = try values.decodeIfPresent(String.self, forKey: .toPrice)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        inStock = try values.decodeIfPresent(String.self, forKey: .inStock)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        imageHover = try values.decodeIfPresent(String.self, forKey: .imageHover)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        basePrice = try values.decodeIfPresent(String.self, forKey: .basePrice)
        startPrice = try values.decodeIfPresent(String.self, forKey: .startPrice)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        deliveryInfo = try values.decodeIfPresent(String.self, forKey: .deliveryInfo)
        hideAddToCart = try values.decodeIfPresent(String.self, forKey: .hideAddToCart)
        salePrice = try values.decodeIfPresent(String.self, forKey: .salePrice)
        swatchesInfo = try values.decodeIfPresent(String.self, forKey: .swatchesInfo)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        klevu_category = try values.decodeIfPresent(String.self, forKey: .klevu_category)
        totalVariants = try values.decodeIfPresent(Int.self, forKey: .totalVariants)
        groupPrices = try values.decodeIfPresent(String.self, forKey: .groupPrices)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        category_main = try values.decodeIfPresent(String.self, forKey: .category_main)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        shortDesc = try values.decodeIfPresent(String.self, forKey: .shortDesc)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        typeOfRecord = try values.decodeIfPresent(String.self, forKey: .typeOfRecord)
    }
    
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

}
