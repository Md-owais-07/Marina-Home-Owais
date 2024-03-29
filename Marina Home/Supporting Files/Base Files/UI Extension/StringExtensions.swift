//
//  StringExtensions.swift
//  Marina Home
//
//  Created by Codilar on 18/04/23.
//

import UIKit
struct Name {
   let first: String
   let last: String

   init(first: String, last: String) {
      self.first = first
      self.last = last
   }
}

extension Name {
   init(fullName: String) {
      var names = fullName.components(separatedBy: " ")
      let first = names.removeFirst()
      let last = names.joined(separator: " ")
      self.init(first: first, last: last)
   }
}

extension Name: CustomStringConvertible {
   var description: String { return "\(first) \(last)" }
}



extension String {
    
        func htmlToAttributedString(fontName: String = AppFontLato.regular, fontSize: Float = 15) -> NSAttributedString? {
            let style = "<style>body { font-family: '\(fontName)'; font-size:\(fontSize)px; }</style>"
            guard let data = (self + style).data(using: .utf8) else {
                return nil
            }
            return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
    
   
}
extension NSMutableAttributedString {
    
    /// Changes just the font size of an attributed string, while keeping all other attributes.
    func changFontSizeTo(fontSize: Int) {
        let attributes = self.attributes(at: 0, effectiveRange: nil)
        
        guard let font = attributes[NSAttributedString.Key.font] as? UIFont else { return }
        let newFont = font.withSize(CGFloat(fontSize))
        
        self.addAttributes([NSAttributedString.Key.font: newFont], range: NSRange(location: 0, length: self.string.count))
    }
}
extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
// MARK: START MHIOS-1112
extension String {
    func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
}
// MARK: END MHIOS-1112
