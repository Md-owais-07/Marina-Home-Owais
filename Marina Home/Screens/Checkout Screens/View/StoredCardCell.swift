//
//  StoredCardCell.swift
//  Marina Home
//
//  Created by Eljo on 01/08/23.
//

import UIKit

class StoredCardCell: UITableViewCell {
    @IBOutlet var imgCard: UIImageView!
    
    @IBOutlet var lblExpDate: UILabel!
    @IBOutlet var lblCardNo: UILabel!
    @IBOutlet var radio: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
