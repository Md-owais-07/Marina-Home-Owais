//
//  OrderListTVC.swift
//  Marina Home
//
//  Created by Eljo on 01/06/23.
//

import UIKit

class OrderListTVC: UITableViewCell {
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnViewDetails: AppButtonUnderlineBlack!
    @IBOutlet var lblNoOfItems: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblAdress: UILabel!
    @IBOutlet weak var dotLineView: UIView!
    @IBOutlet var imgProcessing: UIImageView!
    @IBOutlet var lblOrderId: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dotLineView.createDottedLines(width: 1, color: UIColor.separator.cgColor,view: dotLineView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension UIView {
    func createDottedLines(width: CGFloat, color: CGColor,view:UIView) {
      let caShapeLayer = CAShapeLayer()
      caShapeLayer.strokeColor = #colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1)
      caShapeLayer.lineWidth = width
      caShapeLayer.lineDashPattern = [4,3]
      let cgPath = CGMutablePath()
      let screenWidth = UIScreen.main.bounds.size.width - 72
      let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: screenWidth, y: 0)]
      cgPath.addLines(between: cgPoint)
      caShapeLayer.path = cgPath
      layer.addSublayer(caShapeLayer)
   }
}

