//
//  HomeBannerCell.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit

class HomeBannerCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var imgBanner: UIImageView!
    //MARK: START MHIOS-1179
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var bannerTopHeight : NSLayoutConstraint!
    //MARK: END MHIOS-1179
    @IBOutlet weak var lblTitle3: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
