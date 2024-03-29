//
//  KelebuQueryModel.swift
//  Marina Home
//
//  Created by Eljo on 28/09/23.
//

import Foundation
struct KlebuRecordQueries: Codable {
    
    var search: Search?
    
}



// MARK: - Search
struct Search: Codable {
    var basePath, payload: String?
}
