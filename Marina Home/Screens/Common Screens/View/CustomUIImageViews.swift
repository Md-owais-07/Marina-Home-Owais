//
//  CustomUIImageViews.swift
//  Marina Home
//
//  Created by Codilar on 11/05/23.
//

import UIKit
class RoundedImageView: UIImageView {
   required init?(coder: NSCoder) {
      super.init(coder: coder)
      self.setCornerRadius(radius: self.frame.height / 2)
      self.clipsToBounds = true
      self.contentMode = .scaleAspectFill
   }
}
