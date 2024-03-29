//
//  MenuCategoriesTVC.swift
//  Marina Home
//
//  Created by Codilar on 10/05/23.
//

import UIKit

class MenuCategoriesTVC: UITableViewCell {
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var subViewHeight: NSLayoutConstraint!
    @IBOutlet weak var divaiderView: UIView!
    
    var selectSubView: ((_ intx:Int) -> ()) = {_  in }
    var indexValue:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func subViewAction(_ sender: UIButton) {
        selectSubView(indexValue!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
