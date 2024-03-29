//
//  CustomTextView.swift
//  Marina Home
//
//  Created by santhosh t on 06/08/23.
//

import UIKit
//MARK:- CustomTextView
class CustomTextView:UITextView{

    /// A UIImage value that set LeftImage to the UITextView
    @IBInspectable open var leftImage:UIImage? {
        didSet {
            if (leftImage != nil) {
                self.applyLeftImage(leftImage!)
            }
        }
    }
    
@IBInspectable var leftPadding: CGFloat = 0
@IBInspectable var viewHeight: CGFloat = 0

fileprivate func applyLeftImage(_ image: UIImage) {
        let icn : UIImage = image
        let imageView = UIImageView(image: icn)
        imageView.frame = CGRect(x: leftPadding, y: (viewHeight/2)-12, width: 24, height: 24)
        imageView.contentMode = UIView.ContentMode.center
        //Where self = UItextView
        self.addSubview(imageView)
        self.textContainerInset = UIEdgeInsets(top: 10, left: leftPadding+30.0 , bottom: 10, right: 20.0)
    }
}
