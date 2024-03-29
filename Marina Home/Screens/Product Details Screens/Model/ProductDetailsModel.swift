//
//  ProductDetailsModel.swift
//  Marina Home
//
//  Created by Codilar on 16/05/23.
//

import Foundation
struct ProductDetailsModel : Codable {
    let id : Int?
    let sku : String?
    let name : String?
    let attribute_set_id : Int?
    let price : Double?
    let status : Int?
    let visibility : Int?
    let type_id : String?
    let created_at : String?
    let updated_at : String?
    let weight : Double?
    let extension_attributes : Extension_attributes?
    let product_links : [String]?
    let options : [String]?
    let media_gallery_entries : [Media_gallery_entries_2]?
    let tier_prices : [String]?
    let custom_attributes : [Custom_attributes]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case sku = "sku"
        case name = "name"
        case attribute_set_id = "attribute_set_id"
        case price = "price"
        case status = "status"
        case visibility = "visibility"
        case type_id = "type_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case weight = "weight"
        case extension_attributes = "extension_attributes"
        case product_links = "product_links"
        case options = "options"
        case media_gallery_entries = "media_gallery_entries"
        case tier_prices = "tier_prices"
        case custom_attributes = "custom_attributes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        attribute_set_id = try values.decodeIfPresent(Int.self, forKey: .attribute_set_id)
        do {
            let origPrice = try values.decodeIfPresent(Double.self, forKey: .price)
            price = origPrice;
        }catch{
            let origPrice = try values.decodeIfPresent(Int.self, forKey: .price)
            price = Double(origPrice ?? 0)
        }
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
        type_id = try values.decodeIfPresent(String.self, forKey: .type_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        weight = try values.decodeIfPresent(Double.self, forKey: .weight)
        extension_attributes = try values.decodeIfPresent(Extension_attributes.self, forKey: .extension_attributes)
        product_links = try values.decodeIfPresent([String].self, forKey: .product_links)
        options = try values.decodeIfPresent([String].self, forKey: .options)
        media_gallery_entries = try values.decodeIfPresent([Media_gallery_entries_2].self, forKey: .media_gallery_entries)
        tier_prices = try values.decodeIfPresent([String].self, forKey: .tier_prices)
        custom_attributes = try values.decodeIfPresent([Custom_attributes].self, forKey: .custom_attributes)
    }

}


struct Extension_attributes : Codable {
    let website_ids : [Int]?
    let category_links : [Category_links]?
    let is_postpay_available : String?
    let is_tabby_available : String?
    let only_qty_left : String?
    let klevu_search_url : String?
    let klevu_api_key : String?
    //let mp_label_data : [String]?
    let pdp_description : String?
    let wp_warning_message : String?
    let is_subscribed: Bool?
    let available_stock : String?

    enum CodingKeys: String, CodingKey {

        case website_ids = "website_ids"
        case category_links = "category_links"
        case is_postpay_available = "is_postpay_available"
        case is_tabby_available = "is_tabby_available"
        case only_qty_left = "only_qty_left"
        case klevu_search_url = "klevu_search_url"
        case klevu_api_key = "klevu_api_key"
      //  case mp_label_data = "mp_label_data"
        case pdp_description = "pdp_description"
        case is_subscribed = "is_subscribed"
        case wp_warning_message = "wp_warning_message"
        case available_stock = "available_stock"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        website_ids = try values.decodeIfPresent([Int].self, forKey: .website_ids)
        category_links = try values.decodeIfPresent([Category_links].self, forKey: .category_links)
        is_postpay_available = try values.decodeIfPresent(String.self, forKey: .is_postpay_available)
        is_tabby_available = try values.decodeIfPresent(String.self, forKey: .is_tabby_available)
        is_subscribed = try values.decodeIfPresent(Bool.self, forKey: .is_subscribed)
        only_qty_left = try values.decodeIfPresent(String.self, forKey: .only_qty_left)
        klevu_search_url = try values.decodeIfPresent(String.self, forKey: .klevu_search_url)
        klevu_api_key = try values.decodeIfPresent(String.self, forKey: .klevu_api_key)
        //mp_label_data = try values.decodeIfPresent([String].self, forKey: .mp_label_data)
        pdp_description = try values.decodeIfPresent(String.self, forKey: .pdp_description)
        wp_warning_message = try values.decodeIfPresent(String.self, forKey: .wp_warning_message)
        available_stock = try values.decodeIfPresent(String.self, forKey: .available_stock)
    }

}

struct Media_gallery_entries_2 : Codable {
    let id : Int?
    let media_type : String?
    let label : String?
    let position : Int?
    let disabled : Bool?
    let types : [String]?
    let file : String?
    let extensionAttributesVideo: MediaGalleryEntryExtensionAttributes?
    

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case media_type = "media_type"
        case label = "label"
        case position = "position"
        case disabled = "disabled"
        case types = "types"
        case file = "file"
        case extensionAttributesVideo = "extension_attributes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        position = try values.decodeIfPresent(Int.self, forKey: .position)
        disabled = try values.decodeIfPresent(Bool.self, forKey: .disabled)
        types = try values.decodeIfPresent([String].self, forKey: .types)
        file = try values.decodeIfPresent(String.self, forKey: .file)
        extensionAttributesVideo = try values.decodeIfPresent(MediaGalleryEntryExtensionAttributes.self, forKey: .extensionAttributesVideo)
    }

}

struct Custom_attributes : Codable {
    let attribute_code : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case attribute_code = "attribute_code"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attribute_code = try values.decodeIfPresent(String.self, forKey: .attribute_code)
        do {
            value = try values.decodeIfPresent(String.self, forKey: .value)
        }catch{
            let values = try values.decodeIfPresent([String].self, forKey: .value)
            if values?.count == 0
            {
                value = ""
            }
            else
            {
                value = values?[0]
            }
        }
    }

}

struct Category_links : Codable {
    let position : Int?
    let category_id : String?

    enum CodingKeys: String, CodingKey {

        case position = "position"
        case category_id = "category_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        position = try values.decodeIfPresent(Int.self, forKey: .position)
        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
    }

}

// MARK: - MediaGalleryEntryExtensionAttributes
struct MediaGalleryEntryExtensionAttributes  : Codable {
    let videoContent: VideoContent?
    
    enum CodingKeys: String, CodingKey {
        case videoContent = "video_content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        videoContent = try values.decodeIfPresent(VideoContent.self, forKey: .videoContent)
    }
    
}


// MARK: - VideoContent
struct VideoContent  : Codable {
    let mediaType, videoProvider: String?
    let videoURL: String?
    let videoTitle, videoDescription, videoMetadata: String?
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case videoProvider = "video_provider"
        case videoURL = "video_url"
        case videoTitle = "video_title"
        case videoDescription = "video_description"
        case videoMetadata = "video_metadata"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        videoProvider = try values.decodeIfPresent(String.self, forKey: .videoProvider)
        videoURL = try values.decodeIfPresent(String.self, forKey: .videoURL)
        videoTitle = try values.decodeIfPresent(String.self, forKey: .videoTitle)
        videoDescription = try values.decodeIfPresent(String.self, forKey: .videoDescription)
        videoMetadata = try values.decodeIfPresent(String.self, forKey: .videoMetadata)
    }
}





