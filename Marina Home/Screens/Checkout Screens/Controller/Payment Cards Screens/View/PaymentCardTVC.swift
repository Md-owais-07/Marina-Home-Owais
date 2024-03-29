//
//  PaymentCardTVC.swift
//  Marina Home
//
//  Created by Eljo on 18/07/23.
//

import UIKit

class PaymentCardTVC: UITableViewCell {
    @IBOutlet weak var cardTypeImage: UIImageView!
    @IBOutlet weak var expiryDateLbl: UILabel!
    @IBOutlet weak var cardEndingLbl: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
