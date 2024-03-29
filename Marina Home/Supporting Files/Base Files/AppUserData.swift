//
//  AppUserData.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import UIKit
class UserData {
   static let shared = UserData()

   private let userDefault = UserDefaults.standard

   var currentAuthKey: String {
      get{
         return userDefault.string(forKey: "currentAuthKey") ?? ""
      }
      set(data) {
         userDefault.set(data, forKey: "currentAuthKey")
      }
   }
    var userId: String {
       get{
          return userDefault.string(forKey: "userId") ?? ""
       }
       set(data) {
          userDefault.set(data, forKey: "userId")
           //MARK: START MHIOS-1225
           CrashManager.shared.setUserID(data)
           //MARK: END MHIOS-1225
       }
        
    }
    //MARK: START MHIOS-1199
    var appVersion: String {
       get{
          return userDefault.string(forKey: "appVersion") ?? "0.0"
       }
       set(data) {
          userDefault.set(data, forKey: "appVersion")
       }
    }
    //MARK: END MHIOS-1199

    var firstName: String {
       get{
          return userDefault.string(forKey: "firstName") ?? ""
       }
       set(data) {
          userDefault.set(data, forKey: "firstName")
       }
    }

    var lastName: String {
       get{
          return userDefault.string(forKey: "lastName") ?? ""
       }
       set(data) {
          userDefault.set(data, forKey: "lastName")
       }
    }
    //MARK: START MHIOS-973
    
    var isPushEnable: Int {
       get{
           return userDefault.integer(forKey: "isPushEnable")
       }
       set(data) {
          userDefault.set(data, forKey: "isPushEnable")
       }
    }
    var external_id: String {
       get{
           return userDefault.string(forKey: "external_id") ?? ""
       }
       set(data) {
          userDefault.set(data, forKey: "external_id")
       }
    }
    //MARK: END MHIOS-973

    var emailId: String {
       get{
          return userDefault.string(forKey: "emailId") ?? ""
       }
       set(data) {
          userDefault.set(data, forKey: "emailId")
       }
    }
    // Mark MHIOS-1072
    var previousTab: Int {
       get{
           return userDefault.integer(forKey: "previousTab")
       }
       set(data) {
          userDefault.set(data, forKey: "previousTab")
       }
    }
    var previousProductId: String {
       get{
           return userDefault.string(forKey: "previousProductId") ?? ""
       }
       set(data) {
          userDefault.set(data, forKey: "previousProductId")
       }
    }
    // Mark MHIOS-1072
    var created_at: String {
       get{
          return userDefault.string(forKey: "created_at") ?? ""
       }
       set(data) {
          userDefault.set(data, forKey: "created_at")
       }
    }
    var cartCount: Int {
       get{
          return userDefault.integer(forKey: "cartCount") ?? 0
       }
       set(data) {
          userDefault.set(data, forKey: "cartCount")
       }
    }
    
    var cartQuoteId: Int {
       get{
          return userDefault.integer(forKey: "quote_id") ?? 0
       }
       set(data) {
          userDefault.set(data, forKey: "quote_id")
       }
    }

   var isLoggedIn : Bool{
      get{
         return userDefault.value(forKey: "isLoggedIn") as? Bool ?? false
      }
      set(status) {
         return userDefault.set(status, forKey: "isLoggedIn")
      }
   }
    //MARK START{MHIOS-1029}
    var guestCartId : String{
      get{
         return userDefault.value(forKey: "guestCartId") as? String ?? ""
      }
      set(data) {
         return userDefault.set(data, forKey: "guestCartId")
      }
   }
    
    var wishListIdArray : [WishlistIDsModel]{
      get{
          if let data = UserDefaults.standard.data(forKey: "wishListArray") {
              do {
                  let decoder = JSONDecoder()
                  let models = try decoder.decode([WishlistIDsModel].self, from: data)
                  return models
              } catch {
                  print("Error decoding models: \(error)")
                  return []
              }
          } else {
              return []
          }
      }
      set(data) {
          do {
                   let encoder = JSONEncoder()
                   let data = try encoder.encode(data)
                   UserDefaults.standard.set(data, forKey: "wishListArray")
          } catch {
              print("Error encoding models: \(error)")
          }
      }
   }
    //MARK END{MHIOS-1029}
    var recentOpenProduct:  [Int] {
       get{
          return userDefault.array(forKey: "recentOpenProduct")   as? [Int] ?? [Int]()
       }
       set(data) {
          userDefault.set(data, forKey: "recentOpenProduct")
       }
    }
    var goTocartStatus: Bool {
    get{
        return userDefault.bool(forKey: "goTocartStatus")
    }
    set(data) {
        userDefault.set(data, forKey: "goTocartStatus")
    }
    }
    func ClearAllData() {
      currentAuthKey = ""
       firstName = ""
       lastName = ""
       emailId = ""
       cartQuoteId = 0
        //MARK START{MHIOS-1181}
        wishListIdArray.removeAll()
        //MARK END{MHIOS-1181}
   }
    //Mark MHIOS-710
    var pushPermission: Bool {
       get{
           return userDefault.bool(forKey: "pushPermission")
       }
       set(data) {
          userDefault.set(data, forKey: "pushPermission")
       }
    }
    //Mark MHIOS-710
    //MARK: START MHIOS-1192
    func getIPAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                // wifi = ["en0"]
                // wired = ["en2", "en3", "en4"]
                // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
    //MARK: END MHIOS-1192
}


