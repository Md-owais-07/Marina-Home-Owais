//
//  FilterSectionsItemsTVC.swift
//  Marina Home
//
//  Created by Codilar on 24/04/23.
//

import UIKit

class FilterSectionsItemsTVC: UITableViewCell {
    @IBOutlet weak var customBG: UIView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var sectionItemImage: UIImageView!
    @IBOutlet weak var sectionItemLbl: UILabel!
    @IBOutlet weak var sectionCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setSelectionStyle(isSelected:Bool){
        selectionImage.image = UIImage(named: isSelected ? AppAssets.checkboxButton_Selected_icon.rawValue : AppAssets.checkboxButton_icon.rawValue)
        sectionItemLbl.textColor = isSelected ? AppColors.shared.Color_yellow_AB936B : AppColors.shared.Color_black_000000
    }
    
}
