//
//  ToastMessageView.swift
//  Marina Home
//
//  Created by santhosh t on 14/08/23.
//

import UIKit

class ToastMessageView: UIView {
    
    @IBOutlet weak var toastTextView: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("ToastMessageView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        
    }
    
    func statusCheck(status:String,message:String,widthis:CGFloat)
    {
        mainViewWidth.constant = widthis
        toastTextView.text = message
        var image = UIImage(named: "green_tick")
        switch status {
        case "success":
            mainView.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
            toastTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            image = UIImage(named: "green_tick")
            break
        case "error":
            mainView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9294117647, blue: 0.937254902, alpha: 1)
            image = UIImage(named: "error_icon")
            break
        case "warning":
            mainView.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9176470588, alpha: 1)
            image = UIImage(named: "warning_icon")
            break
        default:
            toastTextView.backgroundColor = UIColor.white
            image = UIImage(named: "green_tick")
        }
        
        leftImage.image = image
        
        
    }

}
