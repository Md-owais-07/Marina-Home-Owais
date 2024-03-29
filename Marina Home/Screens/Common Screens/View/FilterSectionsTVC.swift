//
//  FilterSectionsTVC.swift
//  Marina Home
//
//  Created by Codilar on 24/04/23.
//

import UIKit

class FilterSectionsTVC: UITableViewCell {
    @IBOutlet weak var customBG: UIView!
    @IBOutlet weak var sectionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setSelectionStyle(isSelected:Bool){
        customBG.setBackgroundColor(color: isSelected ? AppColors.shared.Color_black_000000 : AppColors.shared.Color_grey_F6F6F6)
        sectionLbl.textColor = isSelected ? AppColors.shared.Color_white_FFFFFF : AppColors.shared.Color_black_000000
    }
}
