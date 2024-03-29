//
//  AppFonts.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit

final class AppFonts {
    
   static let PlayfairFont = PlayFair()
    static let LatoFont = Lato()
   class PlayFair{
      
      func Bold(_ size: CGFloat) -> UIFont {
          UIFont(name: "PlayfairDisplay-Bold", size: size)!
      }

      func SemiBold(_ size: CGFloat) -> UIFont {
         
          UIFont(name: "PlayfairDisplay-SemiBold", size: size)!
      }

      func Medium(_ size: CGFloat) -> UIFont {
        
          UIFont(name: "PlayfairDisplay-Medium", size: size)!
      }

      func Regular(_ size: CGFloat) -> UIFont {
       
          UIFont(name: "PlayfairDisplay-Regular", size: size)!
      }

  
   }
    class Lato{
       
       func Bold(_ size: CGFloat) -> UIFont {
         
           UIFont(name: "Lato-Bold", size: size)!
       }

       func SemiBold(_ size: CGFloat) -> UIFont {
           UIFont(name: "Lato-Semibold", size: size)!
       }

       func Medium(_ size: CGFloat) -> UIFont {
           UIFont(name: "Lato-Medium", size: size)!
       }

       func Regular(_ size: CGFloat) -> UIFont {
           UIFont(name: "Lato-Regular", size: size)!
       }
        
        func Light(_ size: CGFloat) -> UIFont {
            UIFont(name: "Lato-Light", size: size)!
        }

   
    }
}
struct AppFontPlayFair {
  static let regular = "PlayfairDisplay-Regular"
  static let bold = "PlayfairDisplay-Bold"
  static let semibold = "PlayfairDisplay-Semibold"
  static let medium = "PlayfairDisplay-Medium"
}

struct AppFontLato {
 static let regular = "Lato-Regular"
 static let bold = "Lato-Bold"
 static let medium = "Lato-Medium"
 static let semibold = "Lato-Semibold"
 static let light = "Lato-Light"
}
