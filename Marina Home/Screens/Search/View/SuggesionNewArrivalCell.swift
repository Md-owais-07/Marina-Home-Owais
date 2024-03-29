//
//  SuggesionNewArrivalCell.swift
//  Marina Home
//
//  Created by Eljo on 13/07/23.
//

import UIKit

class SuggesionNewArrivalCell: UITableViewCell {
    @IBOutlet weak var newArrivalsProductsCV: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ProductCVC.register(for: newArrivalsProductsCV)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
