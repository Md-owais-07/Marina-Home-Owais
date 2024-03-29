//
//  SmartLook.swift
//  Marina Home
//
//  Created by codilar on 15/01/24.
//
// MARK: START MHIOS-1064
import Foundation
import SmartlookAnalytics


final class SmartManager
{
    static let shared = SmartManager()
    private init() {}
    
    func trackEvent(event: String)
    {
        Smartlook.instance.track(event: event)
    }
    func trackEvent(event : String, properties : [String:Any])
    {
        var property = Properties()
        for (key, value) in properties
        {
            property[key] = "\(value)"
        }
        
        Smartlook.instance.track(event: event, properties: property)
        
    }
    func addUser(userId:String,userName:String,userEmail:String)
    {
        Smartlook.instance.user.identifier = userId
        Smartlook.instance.user.name = userName
        Smartlook.instance.user.email = userEmail
    }
    
}
// MARK: START MHIOS-1064
