//
//  AlertView.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit
extension AppUIViewController {
    
    
//    func toastView(toastMessage: String, visibleDuration: TimeInterval = 3) {
//        DispatchQueue.main.async {
//            let status = Network.isAvailable()
//            let message = !status ? "No Internet Connection" : toastMessage
//
//            let contentSize = message.boundingRect(with: CGSize(width: (self.view.frame.width * 0.85), height: 300), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: AppFonts.LatoFont.Regular(13)], context: nil)
//
//            let width: CGFloat = self.view.frame.size.width - 40
//            let xPosition: CGFloat = ((self.view.frame.width - width) / 2)
//            let contentWidth = message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).width
//
//            var contentLineCount = 0
//            let widthText = width-74
//            if widthText < contentWidth
//            {
//                let line = Int(contentWidth/widthText)
//                if (CGFloat(line) * widthText) < contentWidth
//                {
//                    contentLineCount = Int(line+1)
//                }
//                else
//                {
//                    contentLineCount = Int(line)
//                }
//            }
//            else
//            {
//                contentLineCount = 1
//            }
//            let contentHeight = (Int(message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).height) * contentLineCount)+20
//            let height: CGFloat = CGFloat(contentHeight)
//            let yPosition: CGFloat = ((self.view.frame.height - height) - 200)
//            let toastTextView = CustomTextView(frame: CGRect(x: xPosition, y: 92, width: width, height: height))
//            toastTextView.font = AppFonts.LatoFont.Regular(13)
//            toastTextView.text = ""+message
//            toastTextView.textColor = AppColors.shared.Color_black_000000
//            toastTextView.isUserInteractionEnabled = false
//            toastTextView.layer.cornerRadius = 8
//            ///toastTextView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9843137255, blue: 0.9607843137, alpha: 1) ///UIColor(red: 0.117, green: 0.117, blue: 0.117, alpha: 0.75)
//            toastTextView.textAlignment = .left
//            toastTextView.alpha = 0
//
//
//            if width < contentWidth
//            {
//                toastTextView.viewHeight = CGFloat(contentHeight)
//                toastTextView.leftPadding = 20
//            }
//            else
//            {
//                toastTextView.viewHeight = CGFloat(contentHeight)
//                toastTextView.leftPadding = ((toastTextView.bounds.width-contentWidth)/2) - 17
//            }
//
//            var image = UIImage(named: "green_tick")
//            switch "success" {
//            case "success":
//                toastTextView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9843137255, blue: 0.9607843137, alpha: 1)
//                image = UIImage(named: "green_tick")
//                break
//            case "error":
//                toastTextView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9294117647, blue: 0.937254902, alpha: 1)
//                image = UIImage(named: "cancelled")
//                break
//            case "warning":
//                toastTextView.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9176470588, alpha: 1)
//                image = UIImage(named: "warning_icon")
//                break
//            default:
//                toastTextView.backgroundColor = UIColor.white
//                image = UIImage(named: "green_tick")
//            }
//
//            toastTextView.leftImage = image
//
//            ///toastTextView.leftViewMode = .always
//            print("Santhosh Lable width :" , toastTextView.bounds.width)
//            print("Santhosh Content width :" , toastTextView.intrinsicContentSize.width)
//            print("Santhosh Content width 2 :" , contentWidth)
//            print("Santhosh Content Height :" , contentHeight)
//            print("Santhosh Left Padding :" , toastTextView.bounds.width-toastTextView.intrinsicContentSize.width)
//            print("Santhosh Left Padding Final :" , (toastTextView.bounds.width-toastTextView.intrinsicContentSize.width)/2)
//
//            //toastTextView.leftPadding = toastTextView.intrinsicContentSize.width //self.view.bounds.width/2
//             //self.view.bounds.width/2
//            let windows = UIApplication.shared.windows.last
//            windows?.addSubview(toastTextView)
//            UIView.animate(withDuration: 0.3, animations: {
//                toastTextView.alpha = 1
//            }, completion: nil)
//            Timer.scheduledTimer(withTimeInterval: visibleDuration, repeats: false, block: { (timer) in
//                timer.invalidate()
//                UIView.animate(withDuration: 0.3, animations: {
//                    toastTextView.alpha = 0
//                }, completion: { (completed) in
//                    if completed {
//                        toastTextView.removeFromSuperview()
//                    }
//                })
//            })
//        }
//    }
    
    func toastView(toastMessage: String, visibleDuration: TimeInterval = 3,type: String) {
        DispatchQueue.main.async {
            let status = Network.isAvailable()
            let message = !status ? "No Internet Connection" : toastMessage
            
            let contentSize = message.boundingRect(with: CGSize(width: (self.view.frame.width * 0.85), height: 100), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: AppFonts.LatoFont.Regular(13)], context: nil)
            
            let width: CGFloat = self.view.frame.size.width ///- 40
            let xPosition: CGFloat = ((self.view.frame.width - width) / 2)
            let contentWidth = message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).width
            
            var contentLineCount = 0
            let widthText = width-54
            print("SANTHOSH TEXT MESSAFGE width MAIN : \(self.view.frame.size.width)")
            print("SANTHOSH TEXT MESSAFGE width : \(width)")
            print("SANTHOSH TEXT MESSAFGE widthText : \(widthText)")
            print("SANTHOSH TEXT MESSAFGE contentWidth : \(contentWidth)")
            
            if widthText <= contentWidth
            {
                let line = Int(contentWidth/widthText)
                if (CGFloat(line) * widthText) < contentWidth
                {
                    contentLineCount = Int(line+2)
                }
                else
                {
                    contentLineCount = Int(line+1)
                }
            }
            else
            {
                contentLineCount = 1
            }
            let contentHeight = (Int(message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).height) * contentLineCount)+20
            let height: CGFloat = CGFloat(contentHeight)
            ///let yPosition: CGFloat = ((self.view.frame.height - height) - 200)
            let toastTextView = ToastMessageView(frame: CGRect(x: 0, y: 0, width: width, height: 100))
            //toastTextView.font = AppFonts.LatoFont.Regular(13)
            //toastTextView.text = ""+message
            //toastTextView.textColor = AppColors.shared.Color_black_000000
            //toastTextView.isUserInteractionEnabled = false
            //toastTextView.layer.cornerRadius = 6
            //toastTextView.textAlignment = .left
            //toastTextView.alpha = 0
            
//            if width < contentWidth
//            {
//                toastTextView.viewHeight = CGFloat(contentHeight)
//                toastTextView.leftPadding = 20
//            }
//            else
//            {
//                toastTextView.viewHeight = CGFloat(contentHeight)
//                toastTextView.leftPadding = ((toastTextView.bounds.width-contentWidth)/2) - 17
//            }
            
//            var image = UIImage(named: "green_tick")
//            switch type {
//            case "success":
//                toastTextView.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
//                toastTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                image = UIImage(named: "green_tick")
//                break
//            case "error":
//                toastTextView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9294117647, blue: 0.937254902, alpha: 1)
//                image = UIImage(named: "error_icon")
//                break
//            case "warning":
//                toastTextView.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9176470588, alpha: 1)
//                image = UIImage(named: "warning_icon")
//                break
//            default:
//                toastTextView.backgroundColor = UIColor.white
//                image = UIImage(named: "green_tick")
//            }
            //toastTextView.leftImage = image
//            self.alignTextVerticalInTextView(textView: toastTextView)
            let windows = UIApplication.shared.windows.last
            windows?.addSubview(toastTextView)
            toastTextView.statusCheck(status: type, message: message,widthis:(self.view.frame.size.width - 40))
            UIView.animate(withDuration: 0.3, animations: {
                toastTextView.alpha = 1
            }, completion: nil)
            Timer.scheduledTimer(withTimeInterval: visibleDuration, repeats: false, block: { (timer) in
                timer.invalidate()
                UIView.animate(withDuration: 0.3, animations: {
                    toastTextView.alpha = 0
                }, completion: { (completed) in
                    if completed {
                        toastTextView.removeFromSuperview()
                    }
                })
            })
        }
    }
        
//       func toastView(toastMessage: String, visibleDuration: TimeInterval = 3,type: String) {
//        DispatchQueue.main.async {
//            let status = Network.isAvailable()
//            let message = !status ? "No Internet Connection" : toastMessage
//
//            let contentSize = message.boundingRect(with: CGSize(width: (self.view.frame.width * 0.85), height: 300), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: AppFonts.LatoFont.Regular(13)], context: nil)
//
//            let width: CGFloat = self.view.frame.size.width - 40
//            let xPosition: CGFloat = ((self.view.frame.width - width) / 2)
//            let contentWidth = message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).width
//
//            var contentLineCount = 0
//            let widthText = width-54
//            print("SANTHOSH TEXT MESSAFGE width MAIN : \(self.view.frame.size.width)")
//            print("SANTHOSH TEXT MESSAFGE width : \(width)")
//            print("SANTHOSH TEXT MESSAFGE widthText : \(widthText)")
//            print("SANTHOSH TEXT MESSAFGE contentWidth : \(contentWidth)")
//
//            if widthText <= contentWidth
//            {
//                let line = Int(contentWidth/widthText)
//                if (CGFloat(line) * widthText) < contentWidth
//                {
//                    contentLineCount = Int(line+2)
//                }
//                else
//                {
//                    contentLineCount = Int(line+1)
//                }
//            }
//            else
//            {
//                contentLineCount = 1
//            }
//            let contentHeight = (Int(message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).height) * contentLineCount)+20
//            let height: CGFloat = CGFloat(contentHeight)
//            let yPosition: CGFloat = ((self.view.frame.height - height) - 200)
//            let toastTextView = CustomTextView(frame: CGRect(x: xPosition, y: 92, width: width, height: height))
//            toastTextView.font = AppFonts.LatoFont.Regular(13)
//            toastTextView.text = ""+message
//            toastTextView.textColor = AppColors.shared.Color_black_000000
//            toastTextView.isUserInteractionEnabled = false
//            toastTextView.layer.cornerRadius = 6
//            toastTextView.textAlignment = .left
//            toastTextView.alpha = 0
//
//            if width < contentWidth
//            {
//                toastTextView.viewHeight = CGFloat(contentHeight)
//                toastTextView.leftPadding = 20
//            }
//            else
//            {
//                toastTextView.viewHeight = CGFloat(contentHeight)
//                toastTextView.leftPadding = ((toastTextView.bounds.width-contentWidth)/2) - 17
//            }
//
//            var image = UIImage(named: "green_tick")
//            switch type {
//            case "success":
//                toastTextView.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
//                toastTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                image = UIImage(named: "green_tick")
//                break
//            case "error":
//                toastTextView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9294117647, blue: 0.937254902, alpha: 1)
//                image = UIImage(named: "error_icon")
//                break
//            case "warning":
//                toastTextView.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.9176470588, alpha: 1)
//                image = UIImage(named: "warning_icon")
//                break
//            default:
//                toastTextView.backgroundColor = UIColor.white
//                image = UIImage(named: "green_tick")
//            }
//            toastTextView.leftImage = image
//            self.alignTextVerticalInTextView(textView: toastTextView)
//            let windows = UIApplication.shared.windows.last
//            windows?.addSubview(toastTextView)
//            UIView.animate(withDuration: 0.3, animations: {
//                toastTextView.alpha = 1
//            }, completion: nil)
//            Timer.scheduledTimer(withTimeInterval: visibleDuration, repeats: false, block: { (timer) in
//                timer.invalidate()
//                UIView.animate(withDuration: 0.3, animations: {
//                    toastTextView.alpha = 0
//                }, completion: { (completed) in
//                    if completed {
//                        toastTextView.removeFromSuperview()
//                    }
//                })
//            })
//        }
//    }
    
    
    func alignTextVerticalInTextView(textView :UITextView) {

        let size = textView.sizeThatFits(CGSizeMake(CGRectGetWidth(textView.bounds), CGFloat(MAXFLOAT)))

        var topoffset = (textView.bounds.size.height - size.height * textView.zoomScale) / 2.0
        topoffset = topoffset < 0.0 ? 0.0 : topoffset

        textView.contentOffset = CGPointMake(0, -topoffset)
    }

    func showAlert(title: String = "", message: String, hasleftAction: Bool = false, leftactionTitle: String = "Cancel", rightactionTitle: String = "OK", rightAction: @escaping ()->(), leftAction: @escaping ()->()) {
       DispatchQueue.main.async {
          let popUpVC = AppController.shared.alertPopUp
          popUpVC.rightActionClosure = rightAction
          popUpVC.leftActionClosure = leftAction
          popUpVC.message = message
          popUpVC.popUptitle = title
          popUpVC.hasleftAction = hasleftAction
          popUpVC.rightActionTitle = rightactionTitle
          popUpVC.leftActionTitle = leftactionTitle
          popUpVC.modalTransitionStyle = .crossDissolve
          popUpVC.modalPresentationStyle = .overCurrentContext
          UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
       }
    }
    
    
    func errorAlert(type:Int,statusCode:Int,retryAction: @escaping ()->()) {
       DispatchQueue.main.async {
          let errorPopUpVC = AppController.shared.errorPopupVC
           errorPopUpVC.retryActionClosure = retryAction
           errorPopUpVC.type = type
           errorPopUpVC.statusCode = statusCode
           //MARK: START MHIOS-1202&1203
           self.tabBarController?.hideTabBar(isHidden: true)
           //MARK: END MHIOS-1202&1203
//          popUpVC.leftActionClosure = leftAction
//          popUpVC.message = message
//          popUpVC.popUptitle = title
//          popUpVC.hasleftAction = hasleftAction
//          popUpVC.rightActionTitle = rightactionTitle
//          popUpVC.leftActionTitle = leftactionTitle
           errorPopUpVC.modalTransitionStyle = .crossDissolve
           errorPopUpVC.modalPresentationStyle = .overCurrentContext
          UIApplication.shared.keyWindow?.rootViewController?.present(errorPopUpVC, animated: false, completion: nil)
       }
    }
    
    //func errorAlert() {
//       DispatchQueue.main.async {
//
//       }
        //self.tabBarController?.tabBar.isHidden = true
//        let errorPopupVC = ErrorPopupVC(frame: CGRect(x: 0, y: 0, width:(self.view.frame.size.width), height: self.view.frame.size.height))
//           let windows = UIApplication.shared.windows.last
//           windows?.addSubview(errorPopupVC)
//        //self.navigationController?.view.addSubview(errorPopupVC)
//        checkInternetAndServerStatus(errorView: errorPopupVC)
    ///}
    
    func checkInternetAndServerStatus(errorView:UIView) {
        let status = Network.isAvailable()
        if status
        {
            errorView.removeFromSuperview()
        }
        else
        {
            checkInternetAndServerStatus(errorView: errorView)
        }
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
