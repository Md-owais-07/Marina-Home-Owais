//
//  PopularSearches.swift
//  Marina Home
//
//  Created by santhosh t on 15/02/24.
//

import Foundation

struct PopularSearches: Codable {
    let popularSearchesArray : [String]?
    
    enum CodingKeys: String, CodingKey {
        case popularSearchesArray = "popular_searches"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        popularSearchesArray = try values.decodeIfPresent([String].self, forKey: .popularSearchesArray)
    }
}
