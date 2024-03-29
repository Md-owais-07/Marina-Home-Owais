//
//  CartCupenTVC.swift
//  Marina Home
//
//  Created by Codilar on 16/05/23.
//

import UIKit

class CartCupenTVC: UITableViewCell {
    
    @IBOutlet var txtCode: UITextField!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var btnExpand: UIButton!
    @IBOutlet var expandView: UIView!
    @IBOutlet weak var btnExpandNew: UIButton!
    
    
    var  couponStatus:Bool?
    //MARK: START MHIOS-1129
    var  isInstantDiscount:Bool = false
    var  isCouponApplied:Bool = false
    var  couponCode:String = ""

    //MARK: END MHIOS-1129
    var couponApply: ((_ status:Bool) -> ()) = {_  in }
    var couponCancel: (() -> ()) = { }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtCode.attributedPlaceholder = NSAttributedString(
            string: "ENTER PROMO CODE",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        // Initialization code
    }
    
    @IBAction func applayAction(_ sender: UIButton) {
        //MARK: START MHIOS-1129
        if isInstantDiscount
        {
            if isCouponApplied{
                
                couponApply(false)
            }
            couponCancel()
        }
        else
        {
            couponApply(couponStatus!)
        }
        //MARK: END MHIOS-1129
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
