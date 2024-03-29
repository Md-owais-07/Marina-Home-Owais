//
//  InstallmentTVC.swift
//  Marina Home
//
//  Created by Codilar on 17/05/23.
//

import UIKit

class InstallmentTVC: UITableViewCell {

    @IBOutlet var lblTabbyDescription: UILabel!
    @IBOutlet var lblPostpayDescription: UILabel!
    @IBOutlet var btnPostpayInfo: UIButton!
    
    @IBOutlet var btnTabbyInfo: UIButton!
    @IBOutlet var lblOrderTotal: UILabel!
    @IBOutlet var btnExpand: UIButton!
    @IBOutlet var lblSubTotal: UILabel!
    @IBOutlet var installementView: UIStackView!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var discountPriceView: UILabel!
    
    @IBOutlet weak var btnExpandNew: UIButton!
    
    @IBOutlet weak var noInstallmentView: UIView!
    @IBOutlet weak var postpayView: UIView!
    @IBOutlet weak var TabbyView: UIView!
    @IBOutlet weak var installmentMainView: UIView!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var shippingLblView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
