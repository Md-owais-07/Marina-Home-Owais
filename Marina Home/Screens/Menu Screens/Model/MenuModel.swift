//
//  MenuModel.swift
//  Marina Home
//
//  Created by Codilar on 10/05/23.
//

import Foundation

struct MenuModel: Decodable {
    let id, parentID: Int
    let name: String
    let isActive: Bool
    let position, level, productCount: Int
    let image: String?
    let includeInMenu: Bool
    let childrenData: [MenuModel]
    enum CodingKeys: String, CodingKey {
            case id
            case parentID = "parent_id"
            case name
            case isActive = "is_active"
            case position, level
            case productCount = "product_count"
            case image
            case includeInMenu = "include_in_menu"
            case childrenData = "children_data"
        }
}
