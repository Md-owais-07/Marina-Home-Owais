//
//  ViewExtensions.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import UIKit

extension UIView{
   func setCornerRadius(radius: CGFloat) {
      self.layer.cornerRadius = radius
   }
   func setBackgroundColor(color: UIColor) {
      self.backgroundColor = color
   }
   func setBoarder(color: UIColor,width: CGFloat) {
      self.layer.borderWidth = width
      self.layer.borderColor = color.cgColor
   }
   func setShadow(radius: CGFloat = 5,opacity: Float = 0.5,color: UIColor = UIColor.lightGray,offset: CGSize = CGSize.zero) {
      self.layer.shadowRadius = radius
      self.layer.shadowOpacity = opacity
      self.layer.shadowOffset = offset
      self.layer.shadowColor = color.cgColor
   }
   func removeShadow() {
      self.setShadow(radius: 0, opacity: 0, color: UIColor.white, offset: CGSize.zero)
   }
    func animShow(){
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.center.y -= self.bounds.height
                            self.layoutIfNeeded()
            }, completion: nil)
            self.isHidden = false
        }
}
extension UIView {
   
    @IBInspectable
    var IBcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var IBborderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var IBborderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var bottomMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    @IBInspectable
    var leftMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable
    var topMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable
    var rightMaskedCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable
    var leftTopRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    
    @IBInspectable
    var rightTopRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable
    var leftBottomRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable
    var rightBottomRadius: CGFloat {
        get {
            clipsToBounds = true
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable
    var topLeftBottomRight: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @IBInspectable var addBezierShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addBezierShadowMethod()
            }
        }
    }
    
    @IBInspectable var addNormalShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addNormalShadowMethod()
            }
        }
    }
    
    @IBInspectable var rotationDegrees: Float {
        get {
            return 0
        }
        set {
            let angle = NSNumber(value: newValue / 180.0 * Float.pi)
            layer.setValue(angle, forKeyPath: "transform.rotation.z")
        }
    }
    
    func addTopOrDownShadow(color: UIColor = .lightGray, offset: CGSize = CGSize(width: 0, height: -10), radius: CGFloat = 15) {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func addBezierShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 11
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    func addNormalShadowMethod() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
    }
}
