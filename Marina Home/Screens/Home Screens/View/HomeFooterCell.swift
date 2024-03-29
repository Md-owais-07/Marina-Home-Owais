//
//  HomeFooterCell.swift
//  Marina Home
//
//  Created by Codilar on 02/05/23.
//

import UIKit

class HomeFooterCell: UITableViewCell {

    @IBOutlet var btnShipingPolicy: UIButton!
    @IBOutlet var btnReturn: UIButton!
    @IBOutlet var btnTerms: UIButton!
    @IBOutlet var btnContactUs: UIButton!
    @IBOutlet var btnFaq: UIButton!
    @IBOutlet var btnHomelegacy: UIButton!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
