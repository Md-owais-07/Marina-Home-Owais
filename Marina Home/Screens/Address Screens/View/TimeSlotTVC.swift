//
//  TimeSlotTVC.swift
//  Marina Home
//
//  Created by Codilar on 18/05/23.
//

import UIKit

class TimeSlotTVC: UITableViewCell {
    @IBOutlet var btnCalender: UIButton!
    @IBOutlet weak var customBGView: UIView!
    @IBOutlet weak var radio: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeCharge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        customBGView.setCornerRadius(radius: 5)
        customBGView.setBoarder(color: AppColors.shared.Color_black_000000, width: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setSelectionStyle(isSelected:Bool){
        radio.image = UIImage(named: isSelected ? AppAssets.radioButtonSelected_icon.rawValue : AppAssets.radioButton_icon.rawValue)
       // time.textColor = isSelected ? AppColors.shared.Color_yellow_AB936B : AppColors.shared.Color_black_000000
        //timeCharge.textColor = isSelected ? AppColors.shared.Color_yellow_AB936B : AppColors.shared.Color_black_000000
        customBGView.layer.borderWidth = isSelected ? 1 : 0.5
    }
    
}
