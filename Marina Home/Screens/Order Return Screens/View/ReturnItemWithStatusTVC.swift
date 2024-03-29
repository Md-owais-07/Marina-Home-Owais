//
//  ReturnItemWithStatusTVC.swift
//  Marina Home
//
//  Created by Sooraj R on 26/07/23.
/////////MARK START{MHIOS-1215}
///Changed the  productDefault image to product_placeholder_img in UI side
/////MARK END{MHIOS-1215}

import UIKit

class ReturnItemWithStatusTVC: UITableViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLbl: UILabel!
    @IBOutlet weak var itemQtyLbl: UILabel!
    @IBOutlet weak var itemDateLbl: UILabel!
    @IBOutlet weak var itemStatusTextLbl: UILabel!
    @IBOutlet weak var itemStatusIconView: UIImageView!
    @IBOutlet weak var seperateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = AppColors.shared.getColor(R: 226, G: 226, B: 226).cgColor
        seperateLbl.textColor = AppColors.shared.getColor(R: 226, G: 226, B: 226)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
