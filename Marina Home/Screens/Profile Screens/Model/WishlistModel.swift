//
//  WishlistModel.swift
//  Marina Home
//
//  Created by Codilar on 26/05/23.
//

import Foundation
struct WishlistModel : Codable {
    let image : String?
    let productName : String?
    let productId : String?
    let wishlistItemId : String?
    let price : Double?
    //Mark MHIOS-1161
    let salePrice : Double?
    //Mark MHIOS-1161
    //MARK START{MHIOS-1029}
    //let qty : String?
    //MARK END{MHIOS-1029}
    let description : String?
    let productSku : String?
    enum CodingKeys: String, CodingKey {
        case productSku = "productSku"
        case image = "image"
        case productName = "productName"
        case productId = "productId"
        case wishlistItemId = "WishlistItemId"
        case price = "price"
        //MARK START{MHIOS-1029}
        //case qty = "qty"
        //MARK END{MHIOS-1029}
        case description = "description"
        //Mark MHIOS-1161
        case salePrice = "salePrice"
        //Mark MHIOS-1161
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        productId = try values.decodeIfPresent(String.self, forKey: .productId)
        wishlistItemId = try values.decodeIfPresent(String.self, forKey: .wishlistItemId)
        //Mark MHIOS-1161
//        do {
//            let origPrice = try values.decodeIfPresent(Double.self, forKey: .price)
//            price = origPrice;
//        }catch{
//            let origPrice = try values.decodeIfPresent(Int.self, forKey: .price)
//            price = Double(origPrice ?? 0)
//        }
      
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        salePrice = try values.decodeIfPresent(Double.self, forKey: .salePrice)
        //Mark MHIOS-1161
        //MARK START{MHIOS-1029}
        //qty = try values.decodeIfPresent(String.self, forKey: .qty)
        //MARK END{MHIOS-1029}
        description = try values.decodeIfPresent(String.self, forKey: .description)
        productSku = try values.decodeIfPresent(String.self, forKey: .productSku)
    }

}



struct NotificationModel: Codable {
    let notificationID: Int?
    let notificationTitle, notificationBody, customerEmail, notificationMessage: String?
    let url,notificationType,iosDeepLInk,messageId: String?
    var hasRead: Int?
    let createdAt: String?
    let websiteID: Int?

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case notificationTitle = "notification_title"
        case notificationBody = "notification_body"
        case customerEmail = "customer_email"
        case notificationMessage = "notification_message"
        case url = "url"
        case hasRead = "has_read"
        case createdAt = "created_at"
        case websiteID = "website_id"
        case notificationType = "notification_type"
        case iosDeepLInk = "iso_deep_link"
        case messageId = "message_id"


    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notificationID = try values.decodeIfPresent(Int.self, forKey: .notificationID)
        notificationTitle = try values.decodeIfPresent(String.self, forKey: .notificationTitle)
        notificationBody = try values.decodeIfPresent(String.self, forKey: .notificationBody)
        customerEmail = try values.decodeIfPresent(String.self, forKey: .customerEmail)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
        notificationMessage = try values.decodeIfPresent(String.self, forKey: .notificationMessage)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        hasRead = try values.decodeIfPresent(Int.self, forKey: .hasRead)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        iosDeepLInk = try values.decodeIfPresent(String.self, forKey: .iosDeepLInk)
        messageId = try values.decodeIfPresent(String.self, forKey: .messageId)
        websiteID = try values.decodeIfPresent(Int.self, forKey: .websiteID)
    }
}
