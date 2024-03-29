//
//  CreditCardTVC.swift
//  Marina Home
//
//  Created by Eljo on 31/07/23.
//

import UIKit

class CreditCardTVC: UITableViewCell {
    @IBOutlet var txtName: UITextField!
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet var btnScan: UIButton!
    @IBOutlet var txtCvv: UITextField!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var txtDate: UITextField!
    @IBOutlet var saveFutureView: UIView!
    @IBOutlet var txtCardNumber: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setSelectionStyle(isSelected:Bool){
        selectionImage.image = UIImage(named: isSelected ? AppAssets.checkboxButton_Selected_icon.rawValue : AppAssets.checkboxButton_icon.rawValue)
        
    }
}
