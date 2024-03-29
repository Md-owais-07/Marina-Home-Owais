//
//  Home.swift
//  Marina Home
//
//  Created by Codilar on 27/04/23.
//

import Foundation
struct Home : Codable {
    var id, category_id, title1_font, title2_font,identifier: String?
        var title3_font, title1, title2, storeID: String?
        var title3, layout, status, image: String?
        var title_1_alignment, title_2_alignment, title_3_alignment: String?
        var video,shopbystyle_description,banner: String?
        var is_shopbystyle_flag, is_shop_room_flag: String?
    //MARK START{MHIOS-1003}
          var category_name: String?
      //MARK END{MHIOS-1003}
}
enum labelAlignment
{
    case left
    case right
    case center
}
struct HomeFooterLink: Codable {
    let id: Int
    let identifier, title, content, creationTime: String
    let updateTime: String
    let active: Bool

    enum CodingKeys: String, CodingKey {
        case id, identifier, title, content
        case creationTime = "creation_time"
        case updateTime = "update_time"
        case active
    }
}
// Mark MHIOS-1158
struct ForceUpdate: Codable {
    let is_force_update: Bool
    let title,description: String
  

    enum CodingKeys: String, CodingKey {
        case is_force_update, title, description
       
    }
}
// Mark MHIOS-1158


// MARK: START MHIOS-1035
struct AdminData: Codable {
    let push_notification_response: PushData
  

    enum CodingKeys: String, CodingKey {
        case push_notification_response
       
    }
}
struct PushData: Codable {
    //MARK: START MHIOS-1304
    let title,description,message,image: String
  

    enum CodingKeys: String, CodingKey {
        case message, title, description,image
       
    }
    //MARK: END MHIOS-1304
}
// MARK: END MHIOS-1035
