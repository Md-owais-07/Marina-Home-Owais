//
//  OrderItemCell.swift
//  Marina Home
//
//  Created by Eljo on 03/07/23.
//

import UIKit

class OrderItemCell: UITableViewCell {

    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgItem: UIImageView!
    
    @IBOutlet var lblQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
