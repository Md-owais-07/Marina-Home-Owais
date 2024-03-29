//
//  MyWishlistTVC.swift
//  Marina Home
//
//  Created by Codilar on 24/04/23.
//

import UIKit

class MyWishlistTVC: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var prodTitleLbl: UILabel!
    @IBOutlet weak var prodSpecLbl: UILabel!
    @IBOutlet weak var ProdPriceLbl: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var moveToCartButton: AppBorderButton!
    //Mark MHIOS-1161
    @IBOutlet var lblActualPrice: UILabel!
    @IBOutlet var lblOfferPrice: UILabel!
    //Mark MHIOS-1161
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
