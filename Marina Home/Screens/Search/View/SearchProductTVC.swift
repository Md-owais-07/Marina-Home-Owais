//
//  SearchProductTVC.swift
//  Marina Home
//
//  Created by Eljo on 04/07/23.
//

import UIKit

class SearchProductTVC: UITableViewCell {
    // MARK START MHIOS_1058
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    // MARK END MHIOS_1058
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
