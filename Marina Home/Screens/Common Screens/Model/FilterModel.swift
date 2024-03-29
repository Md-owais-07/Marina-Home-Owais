//
//  FilterModel.swift
//  Marina Home
//
//  Created by Codilar on 08/05/23.
//

import UIKit

struct FilterModel{
    var section:String
    var sectionItem:String
    var displayTitle:String
    var itemCount:String
}

struct FilterOptionsModel : Decodable {
    let available_filters : [Available_filters]
//    let child_categories : [String]?
//    let items : [String]?
//    let search_criteria : Search_criteria?
//    let total_count : String?

    enum CodingKeys: String, CodingKey {

        case available_filters = "available_filters"
//        case child_categories = "child_categories"
//        case items = "items"
//        case search_criteria = "search_criteria"
//        case total_count = "total_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        available_filters = try values.decodeIfPresent([Available_filters].self, forKey: .available_filters) ?? []
//        child_categories = try values.decodeIfPresent([String].self, forKey: .child_categories)
//        items = try values.decodeIfPresent([String].self, forKey: .items)
//        search_criteria = try values.decodeIfPresent(Search_criteria.self, forKey: .search_criteria)
//        total_count = try values.decodeIfPresent(String.self, forKey: .total_count)
    }

}

struct Available_filters : Codable {
//    let filter : Filter?
    let attribute_code : String?
    let name : String?
    var options : [Options]
//    let attribute_type : String?

    enum CodingKeys: String, CodingKey {

//        case filter = "filter"
        case attribute_code = "attribute_code"
        case name = "name"
        case options = "options"
//        case attribute_type = "attribute_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        filter = try values.decodeIfPresent(Filter.self, forKey: .filter)
        attribute_code = try values.decodeIfPresent(String.self, forKey: .attribute_code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        options = try values.decodeIfPresent([Options].self, forKey: .options) ?? []
//        attribute_type = try values.decodeIfPresent(String.self, forKey: .attribute_type)
    }

}


struct Filter_groups : Codable {
    let filters : [Filters]?

    enum CodingKeys: String, CodingKey {

        case filters = "filters"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filters = try values.decodeIfPresent([Filters].self, forKey: .filters)
    }

}


struct Filter : Codable {

//    enum CodingKeys: String, CodingKey {
//
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//    }

}


struct Filters : Codable {
    let field : String?
    let value : String?
    let condition_type : String?

    enum CodingKeys: String, CodingKey {

        case field = "field"
        case value = "value"
        case condition_type = "condition_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        field = try values.decodeIfPresent(String.self, forKey: .field)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        condition_type = try values.decodeIfPresent(String.self, forKey: .condition_type)
    }

}


struct Options : Codable {
//    let count : Int?
    var label : String?
    var value : String?
    let swatch_value : String?
    var isSelected = false
    let min : Int?
    let max : Int?
    let count : String?

    enum CodingKeys: String, CodingKey {

//        case count = "count"
        case label = "label"
        case value = "value"
        case swatch_value = "swatch_value"
        case min = "min"
        case max = "max"
        case count = "count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        count = try values.decodeIfPresent(Int.self, forKey: .count)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        do{
            let valueInt = try values.decodeIfPresent(Int.self, forKey: .value)
            value = "\(valueInt ?? 0)"
        }catch{
            value = try values.decodeIfPresent(String.self, forKey: .value)
        }
        
        do{
            let countInt = try values.decodeIfPresent(Int.self, forKey: .count)
            count = "\(countInt ?? 0)"
        }catch{
            count = try values.decodeIfPresent(String.self, forKey: .count)
        }
        swatch_value = try values.decodeIfPresent(String.self, forKey: .swatch_value)
        min = try values.decodeIfPresent(Int.self, forKey: .min)
        max = try values.decodeIfPresent(Int.self, forKey: .max)
        if min != nil && max != nil{
            value = "\(max ?? 0)"
            label = "\(min ?? 0) AED - \(max ?? 0) AED"
        }
    }

}


struct Search_criteria : Codable {
    let filter_groups : [Filter_groups]?
    let page_size : Int?

    enum CodingKeys: String, CodingKey {

        case filter_groups = "filter_groups"
        case page_size = "page_size"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filter_groups = try values.decodeIfPresent([Filter_groups].self, forKey: .filter_groups)
        page_size = try values.decodeIfPresent(Int.self, forKey: .page_size)
    }

}

