//
//  CustomUIButtons.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit
class AppPrimaryButton: UIButton {

   override func awakeFromNib() {
      super.awakeFromNib()
      self.clipsToBounds = true
      self.setCornerRadius(radius: 5)
      self.setBackgroundColor(color: AppColors.shared.Color_black_000000)
      self.setFontColor(color: AppColors.shared.Color_white_FFFFFF)
      self.setFont(font: AppFonts.LatoFont.Bold(13))
   }
}
//MARK: START MHIOS-1169
class AppGrayButton: UIButton {

   override func awakeFromNib() {
      super.awakeFromNib()
      self.clipsToBounds = true
      self.setCornerRadius(radius: 5)
      self.setBackgroundColor(color: AppColors.shared.Color_darkGray_8C8C8C)
      self.setFontColor(color: AppColors.shared.Color_white_FFFFFF)
      self.setFont(font: AppFonts.LatoFont.Bold(13))
   }
}
//MARK: START MHIOS-1169
class AppSecondaryButton: UIButton {

   override func awakeFromNib() {
      super.awakeFromNib()
      self.clipsToBounds = true
      self.setCornerRadius(radius: 5)
      self.setBackgroundColor(color: AppColors.shared.Color_grey_F6F6F6)
      self.setFontColor(color: AppColors.shared.Color_black_000000)
      self.setFont(font: AppFonts.LatoFont.Bold(13))
   }

   func setEnabled() {
       //MARK START{MHIOS-1249}
       self.setBoarder(color: AppColors.shared.Color_black_000000, width: 1)
       //MARK END{MHIOS-1249}
       self.setFont(font: AppFonts.LatoFont.Bold(13))
   }

   func setDisabled() {
       self.setBoarder(color: AppColors.shared.Color_black_000000, width: 0)
       self.setFont(font: AppFonts.LatoFont.Regular(13))
   }

}

class AppBorderButton: UIButton {

   override func awakeFromNib() {
       super.awakeFromNib()
       self.clipsToBounds = true
       self.setCornerRadius(radius: 4)
       self.setBackgroundColor(color: AppColors.shared.Color_white_FFFFFF)
       self.setFontColor(color: AppColors.shared.Color_black_000000)
       self.setFont(font: AppFonts.LatoFont.Bold(13))
        //MARK START{MHIOS-1249}
        self.setBoarder(color: AppColors.shared.Color_black_000000, width: 1)
        //MARK END{MHIOS-1249}
    }

}

class AppButtonUnderline: UIButton {
   let textAttributes: [NSAttributedString.Key: Any] = [
      .font: AppFonts.LatoFont.Bold(13),
      .foregroundColor: AppColors.shared.Color_yellow_AB936B,
      .underlineStyle: NSUnderlineStyle.single.rawValue
   ]
    //Color_yellow_AB936B
   override func awakeFromNib() {
      super.awakeFromNib()
      let attributeString = NSMutableAttributedString(
         string: self.titleLabel?.text ?? "",
         attributes: textAttributes)
      self.setAttributedTitle(attributeString, for: .normal)
   }

   func setCustomText(text: String) {
      let attributeString = NSMutableAttributedString(
         string: text,
         attributes: textAttributes)
      self.setAttributedTitle(attributeString, for: .normal)
   }

}

class AppButtonUnderlineBlack: UIButton {
   let textAttributes: [NSAttributedString.Key: Any] = [
      .font: AppFonts.LatoFont.Bold(13),
      .foregroundColor: AppColors.shared.Color_black_000000,
      .underlineStyle: NSUnderlineStyle.single.rawValue
   ]
   override func awakeFromNib() {
      super.awakeFromNib()
      let attributeString = NSMutableAttributedString(
         string: self.titleLabel?.text ?? "",
         attributes: textAttributes)
      self.setAttributedTitle(attributeString, for: .normal)
   }

   func setCustomText(text: String) {
      let attributeString = NSMutableAttributedString(
         string: text,
         attributes: textAttributes)
      self.setAttributedTitle(attributeString, for: .normal)
   }

}

