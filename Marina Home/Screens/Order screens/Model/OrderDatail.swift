//
//  OrderDatail.swift
//  Marina Home
//
//  Created by Eljo on 03/07/23.
//

import Foundation
struct OrderDeatil: Codable {
    let items : [OrderDetailsItems]?
    let totalCount : Int?
    
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case totalCount = "total_count"
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([OrderDetailsItems].self, forKey: .items)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
    }
}

struct OrderDetailsItems : Codable {
    let customer_email : String?
    let created_at : String?
    let increment_id : String?
    let status : String?
    let items : [OrderDetailItems]?
    let billing_address : Billing_address?
    let extensionAttributes: OrderExtenstionAttributes?
    let total_qty_ordered : Int?
    let shipping_incl_tax : Double?
    let discount_amount : Double?
    let grand_total : Double?
    let subtotal_incl_tax : Double?
    
    enum CodingKeys: String, CodingKey {
        case customer_email = "customer_email"
        case created_at = "created_at"
        case increment_id = "increment_id"
        case status = "status"
        case items = "items"
        case billing_address = "billing_address"
        case extensionAttributes = "extension_attributes"
        case total_qty_ordered = "total_qty_ordered"
        case shipping_incl_tax = "shipping_incl_tax"
        case discount_amount = "discount_amount"
        case grand_total = "grand_total"
        case subtotal_incl_tax = "subtotal_incl_tax"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer_email = try values.decodeIfPresent(String.self, forKey: .customer_email)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        increment_id = try values.decodeIfPresent(String.self, forKey: .increment_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        items = try values.decodeIfPresent([OrderDetailItems].self, forKey: .items)
        billing_address = try values.decodeIfPresent(Billing_address.self, forKey: .billing_address)
        extensionAttributes = try values.decodeIfPresent(OrderExtenstionAttributes.self, forKey: .extensionAttributes)
        total_qty_ordered = try values.decodeIfPresent(Int.self, forKey: .total_qty_ordered)
        shipping_incl_tax = try values.decodeIfPresent(Double.self, forKey: .shipping_incl_tax)
        discount_amount = try values.decodeIfPresent(Double.self, forKey: .discount_amount)
        grand_total = try values.decodeIfPresent(Double.self, forKey: .grand_total)
        subtotal_incl_tax = try values.decodeIfPresent(Double.self, forKey: .subtotal_incl_tax)
    }

}

struct OrderExtenstionAttributes: Codable {
    
    let statusLabel: String?

    enum CodingKeys: String, CodingKey {
        case statusLabel = "status_label"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusLabel = try values.decodeIfPresent(String.self, forKey: .statusLabel)
    }
}

struct OrderDetailItems : Codable {
    let item_id : Int?
    let name : String?
    let order_id : Int?
    let original_price : Double?
    let price : Double?
    let price_incl_tax : Double?
    let product_id : Int?
    let product_type : String?
    let qty_canceled : Int?
    let qty_invoiced : Int?
    var qty_ordered : Int?
    let qty_refunded : Int?
    let qty_shipped : Int?
    let sku : String?
    let extensionAttributes: TentacledExtensionAttributes?
    enum CodingKeys: String, CodingKey {

        case item_id = "item_id"
        case name = "name"
        case order_id = "order_id"
        case original_price = "original_price"
        case price = "price"
        case price_incl_tax = "price_incl_tax"
        case product_id = "product_id"
        case product_type = "product_type"
        case qty_canceled = "qty_canceled"
        case qty_invoiced = "qty_invoiced"
        case qty_ordered = "qty_ordered"
        case qty_refunded = "qty_refunded"
        case qty_shipped = "qty_shipped"
        case sku = "sku"
        case extensionAttributes = "extension_attributes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        item_id = try values.decodeIfPresent(Int.self, forKey: .item_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        do {
            let origPrice = try values.decodeIfPresent(Double.self, forKey: .original_price)
            original_price = origPrice;
        }catch{
            let origPrice = try values.decodeIfPresent(Int.self, forKey: .original_price)
            original_price = Double(origPrice ?? 0) 
        }
        
        do {
            let priceIncTax = try values.decodeIfPresent(Double.self, forKey: .price_incl_tax)
            price_incl_tax = priceIncTax;
        }catch{
            let priceIncTax = try values.decodeIfPresent(Int.self, forKey: .price_incl_tax)
            price_incl_tax = Double(priceIncTax ?? 0) 
        }
        
        product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
        product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
        qty_canceled = try values.decodeIfPresent(Int.self, forKey: .qty_canceled)
        qty_invoiced = try values.decodeIfPresent(Int.self, forKey: .qty_invoiced)
        qty_ordered = try values.decodeIfPresent(Int.self, forKey: .qty_ordered)
        qty_refunded = try values.decodeIfPresent(Int.self, forKey: .qty_refunded)
        qty_shipped = try values.decodeIfPresent(Int.self, forKey: .qty_shipped)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        extensionAttributes = try values.decodeIfPresent(TentacledExtensionAttributes.self, forKey: .extensionAttributes)
    }

}

// MARK: - TentacledExtensionAttributes
struct TentacledExtensionAttributes: Codable {
    
    let image, return_possible_date, shortDescription: String?

    enum CodingKeys: String, CodingKey {
       
        case image
        case shortDescription = "short_description"
        case return_possible_date
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        image = try values.decodeIfPresent(String.self, forKey: .image)
        shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
        return_possible_date = try values.decodeIfPresent(String.self, forKey: .return_possible_date)
    }
}
struct Billing_address : Codable {
    let address_type : String?
    let city : String?
    let country_id : String?
    let email : String?
    let entity_id : Int?
    let firstname : String?
    let lastname : String?
    let parent_id : Int?
    let postcode : String?
    let region : String?
    let region_code : String?
    let region_id : Int?
    let street : [String]?
    let telephone : String?

    enum CodingKeys: String, CodingKey {
        case address_type = "address_type"
        case city = "city"
        case country_id = "country_id"
        case email = "email"
        case entity_id = "entity_id"
        case firstname = "firstname"
        case lastname = "lastname"
        case parent_id = "parent_id"
        case postcode = "postcode"
        case region = "region"
        case region_code = "region_code"
        case region_id = "region_id"
        case street = "street"
        case telephone = "telephone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address_type = try values.decodeIfPresent(String.self, forKey: .address_type)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        entity_id = try values.decodeIfPresent(Int.self, forKey: .entity_id)
        firstname = try values.decodeIfPresent(String.self, forKey: .firstname)
        lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
        parent_id = try values.decodeIfPresent(Int.self, forKey: .parent_id)
        postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        region_code = try values.decodeIfPresent(String.self, forKey: .region_code)
        region_id = try values.decodeIfPresent(Int.self, forKey: .region_id)
        street = try values.decodeIfPresent([String].self, forKey: .street)
        telephone = try values.decodeIfPresent(String.self, forKey: .telephone)
    }
}


struct OrderedAddress: Codable {
    let addressType, city, countryID: String?
    let customerAddressID:  Double?
    let email: String?
    let entityID:  Double?
    let firstname, lastname: String?
    let parentID:  Double?
    let postcode: String?
    let region, regionCode: String
    let regionID:  Double?
    let street: [String]?
    let telephone: String?

    enum CodingKeys: String, CodingKey {
        case addressType = "address_type"
        case city
        case countryID = "country_id"
        case customerAddressID = "customer_address_id"
        case email
        case entityID = "entity_id"
        case firstname, lastname
        case parentID = "parent_id"
        case postcode, region
        case regionCode = "region_code"
        case regionID = "region_id"
        case street, telephone
    }
}
struct OrderTrackingDeatil: Codable {
    
    var postShippingInfo: PostShippingInfo?
   
    enum CodingKeys: String, CodingKey {
        
        case postShippingInfo = "post_shipping_info"
        
    }
}
// MARK: - PostShippingInfo
struct PostShippingInfo: Codable {
    var status: String?
    var manualStatus: Bool?
    var carriyoTrackingURL, carriyoPinpointURL, carriyoFeedbackURL: String?
    var trackingNo: String?
    var awb, defaultLabelURL, carriyoPDFLabelURL, carriyoZPLLabelURL: String?
   var keyMilestones: KeyMilestones?
    var asyncStatuses: AsyncStatuses?

    enum CodingKeys: String, CodingKey {
        case status
        case manualStatus = "manual_status"
        case carriyoTrackingURL = "carriyo_tracking_url"
        case carriyoPinpointURL = "carriyo_pinpoint_url"
        case carriyoFeedbackURL = "carriyo_feedback_url"
        case trackingNo = "tracking_no"
        case awb
        case defaultLabelURL = "default_label_url"
        case carriyoPDFLabelURL = "carriyo_pdf_label_url"
        case carriyoZPLLabelURL = "carriyo_zpl_label_url"
        case keyMilestones = "key_milestones"
        case asyncStatuses = "async_statuses"
    }
}

// MARK: - AsyncStatuses
struct AsyncStatuses: Codable {
    var label: String?
}

// MARK: - KeyMilestones
struct KeyMilestones: Codable {
    var booked: String?
    var shipped: String?
    var ready_to_ship: String?
    var delivered: String?
    var out_for_delivery: String?
}


// MARK: - RETURN ITEMS IN ORDER DETAILS
struct ReturnItemsModel : Codable {
    let items : [ReturnItems]?
    let totalCount : Int?
    enum CodingKeys: String, CodingKey {

        case items = "items"
        case totalCount = "total_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([ReturnItems].self, forKey: .items)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
    }

}


struct ReturnItems : Codable {
    let request_id : Int?
    let order_id : Int?
    let order_increment_id : String?
    let increment_id : String?
    let status_id : Int?
    let is_canceled : Int?
    let store_id : Int?
    let comment : String?
    let files : [String]?
    let last_responded_by : String?
    let customer_email : String?
    let phone_number : String?
    let rma_status:String?
    let updated_at : String?
    let created_at : String?
    //MARK: START MHIOS-1218
    let isReturnRequestEligible : Bool
    //MARK: END MHIOS-1218
    let request_item : [RequestItem]?
    let request_reply : [RequestReply]?
    let request_shipping_label : [RequestShippingLabel]?
    
    let reason : String?
    let solution : String?
    let additional_fields : String?

    
    enum CodingKeys: String, CodingKey {

        case request_id = "request_id"
        case order_id = "order_id"
        case order_increment_id = "order_increment_id"
        case increment_id = "increment_id"
        case status_id = "status_id"
        case is_canceled = "is_canceled"
        case store_id = "store_id"
        case comment = "comment"
        case files = "files"
        case last_responded_by = "last_responded_by"
        case customer_email = "customer_email"
        case phone_number = "phone_number"
        case rma_status = "rma_status"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case request_item = "request_item"
        case request_reply = "request_reply"
        case request_shipping_label = "request_shipping_label"
        case reason = "reason"
        case solution = "solution"
        case additional_fields = "additional_fields"
        //MARK: START MHIOS-1218
        case isReturnRequestEligible = "is_return_request_eligible"
        //MARK: END MHIOS-1218

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        request_id = try values.decodeIfPresent(Int.self, forKey: .request_id)
        order_id = try values.decodeIfPresent(Int.self, forKey: .order_id)
        order_increment_id = try values.decodeIfPresent(String.self, forKey: .order_increment_id)
        increment_id = try values.decodeIfPresent(String.self, forKey: .increment_id)
        status_id = try values.decodeIfPresent(Int.self, forKey: .status_id)
        is_canceled = try values.decodeIfPresent(Int.self, forKey: .is_canceled)
        store_id = try values.decodeIfPresent(Int.self, forKey: .store_id)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        files = try values.decodeIfPresent([String].self, forKey: .files)
        last_responded_by = try values.decodeIfPresent(String.self, forKey: .last_responded_by)
        customer_email = try values.decodeIfPresent(String.self, forKey: .customer_email)
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
        rma_status = try values.decodeIfPresent(String.self, forKey: .rma_status)
        //MARK: START MHIOS-1218
        isReturnRequestEligible = try values.decodeIfPresent(Bool.self, forKey: .isReturnRequestEligible) ?? false
        //MARK: END MHIOS-1218
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        request_item = try values.decodeIfPresent([RequestItem].self, forKey: .request_item)
        request_reply = try values.decodeIfPresent([RequestReply].self, forKey: .request_reply)
        request_shipping_label = try values.decodeIfPresent([RequestShippingLabel].self, forKey: .request_shipping_label)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        solution = try values.decodeIfPresent(String.self, forKey: .solution)
        additional_fields = try values.decodeIfPresent(String.self, forKey: .additional_fields)
    }

}

struct RequestItem : Codable {
    let item_id : Int?
    let request_id : Int?
    let product_id : Int?
    let order_item_id : Int?
    let name : String?
    let sku : String?
    let qty_rma : Int?
    let price : Double?
    let price_returned : Double?
    let reason : String?
    let solution : String?
    let additional_fields : String?
    let image : String?
    let created_at : String?
    
    enum CodingKeys: String, CodingKey {

        case item_id = "item_id"
        case request_id = "request_id"
        case product_id = "product_id"
        case order_item_id = "order_item_id"
        case name = "name"
        case sku = "sku"
        case qty_rma = "qty_rma"
        case price = "price"
        case price_returned = "price_returned"
        case reason = "reason"
        case solution = "solution"
        case additional_fields = "additional_fields"
        case image = "image"
        case created_at = "created_at"
    }
   
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        item_id = try values.decodeIfPresent(Int.self, forKey: .item_id)
        request_id = try values.decodeIfPresent(Int.self, forKey: .request_id)
        product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
        order_item_id = try values.decodeIfPresent(Int.self, forKey: .order_item_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        qty_rma = try values.decodeIfPresent(Int.self, forKey: .qty_rma)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        price_returned = try values.decodeIfPresent(Double.self, forKey: .price_returned)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        solution = try values.decodeIfPresent(String.self, forKey: .solution)
        additional_fields = try values.decodeIfPresent(String.self, forKey: .additional_fields)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }
}

struct RequestReply: Codable {

  var replyId            : Int?
  var requestId          : Int?
  var isCustomerNotified : Int?
  var isVisibleOnFront   : Int?
  var authorName         : String?
  var type               : Int?
  var content            : String?
  var files              : String?
  var createdAt          : String?

  enum CodingKeys: String, CodingKey {

    case replyId            = "reply_id"
    case requestId          = "request_id"
    case isCustomerNotified = "is_customer_notified"
    case isVisibleOnFront   = "is_visible_on_front"
    case authorName         = "author_name"
    case type               = "type"
    case content            = "content"
    case files              = "files"
    case createdAt          = "created_at"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    replyId            = try values.decodeIfPresent(Int.self    , forKey: .replyId            )
    requestId          = try values.decodeIfPresent(Int.self    , forKey: .requestId          )
    isCustomerNotified = try values.decodeIfPresent(Int.self    , forKey: .isCustomerNotified )
    isVisibleOnFront   = try values.decodeIfPresent(Int.self    , forKey: .isVisibleOnFront   )
    authorName         = try values.decodeIfPresent(String.self , forKey: .authorName         )
    type               = try values.decodeIfPresent(Int.self    , forKey: .type               )
    content            = try values.decodeIfPresent(String.self , forKey: .content            )
    files              = try values.decodeIfPresent(String.self , forKey: .files              )
    createdAt          = try values.decodeIfPresent(String.self , forKey: .createdAt          )
 
  }
}

struct RequestShippingLabel: Codable {

  var shippingLabelId : String?

  enum CodingKeys: String, CodingKey {

    case shippingLabelId = "shipping_label_id"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    shippingLabelId = try values.decodeIfPresent(String.self , forKey: .shippingLabelId )
 
  }


}
