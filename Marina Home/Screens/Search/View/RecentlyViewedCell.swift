//
//  RecentlyViewedCell.swift
//  Marina Home
//
//  Created by santhosh t on 22/08/23.
//

import UIKit

class RecentlyViewedCell: UITableViewCell {
    
    
    @IBOutlet weak var recentlyViewedProductsCV: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ProductCVC.register(for: recentlyViewedProductsCV)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
