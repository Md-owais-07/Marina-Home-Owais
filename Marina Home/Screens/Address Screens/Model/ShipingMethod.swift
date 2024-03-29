//
//  ShipingMethod.swift
//  Marina Home
//
//  Created by Eljo on 05/06/23.
//

import Foundation
struct ShipingMethod: Codable {
   
        let carrierCode, methodCode: String
        let carrierTitle: String?
        let methodTitle: String
        let amount, baseAmount: Double
        let available: Bool
        let extensionAttributes: ShipingMethodExtensionAttributes?
        let errorMessage: String
        let priceExclTax, priceInclTax: Double?
        enum CodingKeys: String, CodingKey {
            case carrierCode = "carrier_code"
            case methodCode = "method_code"
            case carrierTitle = "carrier_title"
            case methodTitle = "method_title"
            case amount
            case baseAmount = "base_amount"
            case available
            case extensionAttributes = "extension_attributes"
            case errorMessage = "error_message"
            case priceExclTax = "price_excl_tax"
            case priceInclTax = "price_incl_tax"
        }
    }

// MARK: - ExtensionAttributes
struct ShipingMethodExtensionAttributes: Codable {
    let amdeliverydateChannels: [AmdeliverydateChannel]?
    let amdeliverydateChannelConfig: AmdeliverydateChannelConfig?
    let amdeliverydateDateChannelLinks: [AmdeliverydateDateChannelLink]?
    let amdeliverydateDateScheduleItems: [AmdeliverydateDateScheduleItem]
    
    //let amdeliverydateTimeChannelLinks, amdeliverydateTimeScheduleLinks, amdeliverydateTimeIntervalItems, amdeliverydateDisabledDaysByLimit: [JSONAny]
    //let amstartesComment: String
    //MARK: START MHIOS-1010
    let server_time: String?
    let available_dates: [String]
    //MARK: END MHIOS-1010

    enum CodingKeys: String, CodingKey {
        case amdeliverydateChannels = "amdeliverydate_channels"
        case amdeliverydateChannelConfig = "amdeliverydate_channel_config"
        case amdeliverydateDateChannelLinks = "amdeliverydate_date_channel_links"
        case amdeliverydateDateScheduleItems = "amdeliverydate_date_schedule_items"

       // case amdeliverydateTimeChannelLinks = "amdeliverydate_time_channel_links"
      //  case amdeliverydateTimeScheduleLinks = "amdeliverydate_time_schedule_links"
      //  case amdeliverydateTimeIntervalItems = //"amdeliverydate_time_interval_items"
        //case amdeliverydateDisabledDaysByLimit = "amdeliverydate_disabled_days_by_limit"

        //case amstartesComment = "amstartes_comment"
        //MARK: START MHIOS-1010
        case server_time = "server_time"
        case available_dates = "available_dates"
        //MARK: END MHIOS-1010

    }
    //MARK: START MHIOS-1010
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amdeliverydateChannels = try values.decodeIfPresent([AmdeliverydateChannel].self, forKey: .amdeliverydateChannels)
        amdeliverydateChannelConfig = try values.decodeIfPresent(AmdeliverydateChannelConfig.self, forKey: .amdeliverydateChannelConfig)
        amdeliverydateDateChannelLinks = try values.decodeIfPresent([AmdeliverydateDateChannelLink].self, forKey: .amdeliverydateDateChannelLinks)
        amdeliverydateDateScheduleItems = try values.decodeIfPresent([AmdeliverydateDateScheduleItem].self, forKey: .amdeliverydateDateScheduleItems) ?? [AmdeliverydateDateScheduleItem]()
        server_time = try values.decodeIfPresent(String.self, forKey: .server_time)
        available_dates = try values.decodeIfPresent([String].self, forKey: .available_dates) ?? [String]()
    }
    //MARK: END MHIOS-1010

}

// MARK: - AmdeliverydateChannelConfig
struct AmdeliverydateChannelConfig: Codable {
    let id, min, max: Double?
    let isSameDayAvailable: Bool?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id, min, max
        case isSameDayAvailable = "is_same_day_available"
        case name
    }
}

// MARK: - AmdeliverydateChannel
struct AmdeliverydateChannel: Codable {
    let channelID, hasOrderCounter, priority, configID: Int?
    let isActive: Bool
    let name: String

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case hasOrderCounter = "has_order_counter"
        case priority
        case configID = "config_id"
        case isActive = "is_active"
        case name
    }
}

// MARK: - AmdeliverydateDateChannelLink
struct AmdeliverydateDateChannelLink: Codable {
    let relationID, deliveryChannelID, dateScheduleID: Int

    enum CodingKeys: String, CodingKey {
        case relationID = "relation_id"
        case deliveryChannelID = "delivery_channel_id"
        case dateScheduleID = "date_schedule_id"
    }
}

// MARK: - AmdeliverydateDateScheduleItem
struct AmdeliverydateDateScheduleItem: Codable {
    let scheduleID: Int
    let name: String
    let type: Int
    let from, to: String
    let isAvailable: Int

    enum CodingKeys: String, CodingKey {
        case scheduleID = "schedule_id"
        case name, type, from, to
        case isAvailable = "is_available"
    }
}
