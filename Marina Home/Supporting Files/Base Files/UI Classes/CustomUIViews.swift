//
//  CustomUIViews.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import UIKit

class AppStatusBar: UIView {
   required init?(coder: NSCoder) {
      super.init(coder: coder)
       self.setBackgroundColor(color: UIColor.black)
   }
}

class AppHeaderView: UIView {
   required init?(coder: NSCoder) {
      super.init(coder: coder)
       self.setShadow()
   }
}

class BorderedView: UIView {
   required init?(coder: NSCoder) {
      super.init(coder: coder)
       //MARK START{MHIOS-1180}
       self.setCornerRadius(radius: 4)
       self.setBoarder(color: AppColors.shared.Color_black_000000, width: 1)
       //MARK END{MHIOS-1180}
   }
}
