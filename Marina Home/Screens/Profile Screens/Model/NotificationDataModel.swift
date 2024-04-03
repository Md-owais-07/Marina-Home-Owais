//
//  NotificationDataModel.swift
//  Marina Home
//
//  Created by Mohammad Owais on 29/03/24.
//

import Foundation

struct NotificationDataModel: Codable {
    let notificationType: String
    let notificationId: String?
    let notificationTitle: String
    let notificationBody: String
    let customerEmail: String?
    let notificationMessage: String?
    let url: String?
    let hasRead: Bool?
    let createdAt: String
    let websiteId: String?
    let isoDeepLink: String?
    let messageId: String
    // Add default values to properties
    init(
        notificationType: String,
        notificationId: String? = nil,
        notificationTitle: String,
        notificationBody: String,
        customerEmail: String? = nil,
        notificationMessage: String? = nil,
        url: String? = nil,
        hasRead: Bool? = true,
        createdAt: String,
        websiteId: String? = nil,
        isoDeepLink: String? = nil,
        messageId: String
    ) {
        self.notificationType = notificationType
        self.notificationId = notificationId
        self.notificationTitle = notificationTitle
        self.notificationBody = notificationBody
        self.customerEmail = customerEmail
        self.notificationMessage = notificationMessage
        self.url = url
        self.hasRead = hasRead
        self.createdAt = createdAt
        self.websiteId = websiteId
        self.isoDeepLink = isoDeepLink
        self.messageId = messageId
    }
    enum CodingKeys: String, CodingKey {
        case notificationType = "notification_type"
        case notificationId = "notification_id"
        case notificationTitle = "notification_title"
        case notificationBody = "notification_body"
        case customerEmail = "customer_email"
        case notificationMessage = "notification_message"
        case url
        case hasRead = "has_read"
        case createdAt = "created_at"
        case websiteId = "website_id"
        case isoDeepLink = "iso_deep_link"
        case messageId = "message_id"
    }
}
