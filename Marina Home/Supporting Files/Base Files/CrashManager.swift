//
//  Crashlytics.swift
//  Marina Home
//
//  Created by codilar on 29/12/23.
//

import Foundation
import FirebaseCrashlytics

final class CrashManager
{
    static let shared = CrashManager()
    private init() {}
    
    func setUserID(_ id:String)
    {
        
        Crashlytics.crashlytics().setUserID(id)
        
    }
    
    func log(_ message: String)
    {
        Crashlytics.crashlytics().log(message)
    }
    func addKey(key:String,value:Any)
    {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
}
