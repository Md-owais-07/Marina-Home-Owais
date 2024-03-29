//
//  PaymentOptionsTVC.swift
//  Marina Home
//
//  Created by Codilar on 23/05/23.
//

import UIKit

class PaymentOptionsTVC: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var radio: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
