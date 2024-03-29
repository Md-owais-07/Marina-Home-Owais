//
//  ReturnTrackingModel.swift
//  Marina Home
//
//  Created by Sooraj R on 02/08/23.
//

import Foundation
struct ReturnTrackingModel : Codable {
    let items : [ReturnTrackingItem]?
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([ReturnTrackingItem].self, forKey: .items)
    }

}


struct ReturnTrackingItem : Codable {
    let status_id : Int?
    let name : String?
    let label : String?
    let comment : String?
    let enable_comment : Int?
    let is_active : Int?
    let description : String?
    let allow_action : String?
    let updated_at : String?
    let created_at : String?
    let label_by_store : [String]?
    let comment_by_store : [String]?

    enum CodingKeys: String, CodingKey {

        case status_id = "status_id"
        case name = "name"
        case label = "label"
        case comment = "comment"
        case enable_comment = "enable_comment"
        case is_active = "is_active"
        case description = "description"
        case allow_action = "allow_action"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case label_by_store = "label_by_store"
        case comment_by_store = "comment_by_store"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status_id = try values.decodeIfPresent(Int.self, forKey: .status_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        enable_comment = try values.decodeIfPresent(Int.self, forKey: .enable_comment)
        is_active = try values.decodeIfPresent(Int.self, forKey: .is_active)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        allow_action = try values.decodeIfPresent(String.self, forKey: .allow_action)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        label_by_store = try values.decodeIfPresent([String].self, forKey: .label_by_store)
        comment_by_store = try values.decodeIfPresent([String].self, forKey: .comment_by_store)
    }

}
