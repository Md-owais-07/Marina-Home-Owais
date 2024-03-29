//
//  SortTVC.swift
//  Marina Home
//
//  Created by Codilar on 04/05/23.
//

import UIKit

class SortTVC: UITableViewCell {

    
    @IBOutlet var selectionImage: UIImageView!
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setSelectionStyle(isSelected:Bool){
        selectionImage.image = UIImage(named: isSelected ? AppAssets.radioButtonSelected_icon.rawValue : AppAssets.radioButton_icon.rawValue)
        lblName.textColor = isSelected ? AppColors.shared.Color_yellow_AB936B : AppColors.shared.Color_black_000000
    }
}
