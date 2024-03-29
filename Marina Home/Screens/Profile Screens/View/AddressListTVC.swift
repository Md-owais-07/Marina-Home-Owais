//
//  AddressListTVC.swift
//  Marina Home
//
//  Created by Codilar on 25/05/23.
//

import UIKit

class AddressListTVC: UITableViewCell {
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var isDefaultLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
