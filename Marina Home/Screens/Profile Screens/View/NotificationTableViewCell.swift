//
//  NotificationTableViewCell.swift
//  Marina Home
//
//  Created by codilar on 14/02/24.
//
//MARK: START MHIOS-967
import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var iconNotification: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//MARK: END MHIOS-967
