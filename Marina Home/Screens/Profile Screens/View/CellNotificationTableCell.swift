//
//  CellNotificationTableCell.swift
//  Marina Home
//
//  Created by Mohammad Owais on 29/03/24.
//

import UIKit

class CellNotificationTableCell: UITableViewCell {
    
    @IBOutlet weak var boldLabel: UILabel!
    @IBOutlet weak var regularLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var roundView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        roundView.layer.cornerRadius = roundView.frame.size.width / 2
        roundView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func forwardActionBtn(_ sender: Any) {
        print("Forward tapped....")
    }

    
}
