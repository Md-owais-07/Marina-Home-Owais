//
//  AdjustAnalytics.swift
//  Marina Home
//
//  Created by codilar on 24/11/23.
//

// Mark MHIOS-1130

import Foundation
import Adjust


// MARK: - Stage

enum AdjustEventType : String
{
    case SearchProduct = "euep8m"
    case ShippingDetails = "f05h84"
    case PaymentDetails = "si5jkk"
    case AddtoCart = "3n862a"
    case Login = "wn1uxq"
    case Registration = "2lycew"
    case Sale = "8zs7ar"
    case ViewCart = "bpwddh"
    case ViewListing = "rsconv"
    case ViewProduct = "rcx6he"
    case AddToWishList = "j53a56"
    //MARK: START-MHIOS-1167
    case FirstSale = "gdkz8b"
    //MARK: START-MHIOS-1167
}

// MARK: - Prod

//enum AdjustEventType : String
//{
//    case SearchProduct = "r35z2o"
//    case ShippingDetails = "zi4z6j"
//    case PaymentDetails = "xeza3o"
//    case AddtoCart = "7vid3v"
//    case Login = "39rwvh"
//    case Registration = "wvnwft"
//    case Sale = "ygijtr"
//    case ViewCart = "l6oms5"
//    case ViewListing = "jvld0s"
//    case ViewProduct = "rqpzaq"
//    case AddToWishList = "oe9gh3"
//    //MARK: START-MHIOS-1167
//    case FirstSale = "alprpy"
//    //MARK: START-MHIOS-1167
//}

class AdjustAnalytics
{
    
    static let shared = AdjustAnalytics()
    private var event : ADJEvent?
    private init()
    {}
    
    func createEvent(type:AdjustEventType)
    {
        event = ADJEvent(eventToken: type.rawValue)
    }
    func createParam(key:String,value:String)
    {
        event?.addPartnerParameter(key, value: value)

    }
    func track()
    {
        
        print("Tracking\(event?.eventToken ?? "") with \(event?.partnerParameters ?? ["key":"No Data"]) parameter")
        Adjust.trackEvent(event)
    }
    
}
// Mark MHIOS-1130
