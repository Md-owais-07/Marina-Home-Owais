//

//  Product.swift

//  Marina Home

//

//  Created by Codilar on 25/04/23.

//



import Foundation

struct Products: Codable {

    var items: [Item]?

    var searchCriteria: SearchCriteria?

    var totalCount: Int?

}



// MARK: - Item

struct Item : Codable{
    var product_id: Int?
    
    var id: Int?

    var sku, name: String?

    var attributeSetID, price,specialPrice, status, visibility: Double?

    var typeID: String?

    var createdAt: String?

    var updatedAt: String?

    var weight: Double?

    var extensionAttributes: ProductExtensionAttributes?

    //var productLinks, options: [Any?]?

    let media_gallery_entries : [Media_gallery_entries]?

    //var tierPrices: [Any?]?

    var customAttributes: [productCustomAttribute]?
    
    var image : String?

    enum CodingKeys: String, CodingKey {



        case id = "id"

        case product_id = "product_id"

        case sku = "sku"

        case name = "name"

        case attributeSetID = "attribute_set_id"

        case price = "price"

        case specialPrice = "special_price"

        case status = "status"

        case visibility = "visibility"

        case typeID = "type_id"

        case createdAt = "created_at"

        case updatedAt = "updated_at"

        case weight = "weight"

       // case extensionAttributes = "extension_attributes"

        //case productLinks = "product_links"

        //case options = "options"

        case media_gallery_entries = "media_gallery_entries"

        //case tierPrices = "tier_prices"

        case customAttributes = "custom_attributes"

        case image = "image"
    }

}



enum CreatedAt: Codable {

    case the20210627054434

}



//// MARK: - CustomAttribute

//struct productCustomAttribute : Codable{

//    var attributeCode: String?

//    var value: Value?

//}

//

//enum Value: Codable {

//    case string(String)

//    case stringArray([String])

//}



///////

///

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



// MARK: - ExtensionAttributes

struct ProductExtensionAttributes: Codable {

    var websiteIDS: [Int]?

    var categoryLinks: [CategoryLink]?

    var preorderInfo: PreorderInfo?

   // var mpLabelData: [Any?]?

}



// MARK: - CategoryLink

struct CategoryLink : Codable{

    var position: Int?

    var categoryID: String?

}



// MARK: - PreorderInfo

struct PreorderInfo: Codable {

    var preorder: Bool?

    var note: Note?

    var cartLabel: CartLabel?

}



enum CartLabel: Codable {

    case cartLabelPreOrder

    case preOrder

    case preOrderNow

}



enum Note : Codable{

    case expectedArrivalDate03FEB2023

    case preOrderNowToGetItBy1StOfFeb

    case preOrderNowToGetItBy1StOfJune

    case preOrderWillBeDeliverIn15Days

}



// MARK: - MediaGalleryEntry

struct Media_gallery_entries : Codable {

    let id : Int?

    let media_type : String?

    let label : String?

    let position : Int?

    let disabled : Bool?

    let types : [String]?

    var file : String?

    

    enum CodingKeys: String, CodingKey {

        

        case id = "id"

        case media_type = "media_type"

        case label = "label"

        case position = "position"

        case disabled = "disabled"

        case types = "types"

        case file = "file"

    }

}



enum MediaTypeEnum: Codable {

    case image

    case smallImage

    case swatchImage

    case thumbnail

}



enum TypeID : Codable{

    case simple

}



// MARK: - SearchCriteria

struct SearchCriteria : Codable{

    //var filterGroups: [Any?]?

    var pageSize: Int?

}


