//
//  DeliveryOptionTVC.swift
//  Marina Home
//
//  Created by Codilar on 17/05/23.
//

import UIKit

class DeliveryOptionTVC: UITableViewCell {
    @IBOutlet var titleView: UIView!
    @IBOutlet var lbldeliveryOption: UILabel!
    @IBOutlet var btnEdit: AppButtonUnderline!
    @IBOutlet var lblRegion: UILabel!
    
    @IBOutlet var lblStreet: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var selectionImage: UIImageView!
    @IBOutlet var lblDesciption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnEdit.contentHorizontalAlignment = .left
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setSelectionStyle(isSelected:Bool){
        selectionImage.image = UIImage(named: isSelected ? AppAssets.radioButtonSelected_icon.rawValue : AppAssets.radioButton_icon.rawValue)
        
    }
}
