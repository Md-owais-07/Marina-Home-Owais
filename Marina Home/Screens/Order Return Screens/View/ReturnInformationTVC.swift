//
//  ReturnInformationTVC.swift
//  Marina Home
//
//  Created by Sooraj R on 26/07/23.
/////////MARK START{MHIOS-1215}
///Changed the  productDefault image to product_placeholder_img in UI side
/////MARK END{MHIOS-1215}

import UIKit

class ReturnInformationTVC: UITableViewCell {
    @IBOutlet weak var returnInfoView: UIStackView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLbl: UILabel!
    @IBOutlet weak var itemQtyLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var solutionLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
