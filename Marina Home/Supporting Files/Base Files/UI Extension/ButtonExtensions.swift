//
//  ButtonExtensions.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit

extension UIButton {
   func setFontColor(color: UIColor) {
      self.setTitleColor(color, for: .normal)
   }
   func setDisabledFontColor(color: UIColor) {
      self.setTitleColor(color, for: .disabled)
   }
   func setFont(font: UIFont) {
      self.titleLabel?.font = font
   }
   func setUnderlineForTitle(title: String) {
      let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.underlineStyle :NSUnderlineStyle.single.rawValue])
      self.setAttributedTitle(attributedString, for: .normal)
   }
}

