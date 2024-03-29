//
//  AlertPopUpVC.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit

class AlertPopUpVC: AppUIViewController {

   @IBOutlet weak var customBGView: UIView!
   @IBOutlet weak var contentBGView: UIView!
   @IBOutlet var buttonPaddingViews: [UIView]!
   @IBOutlet weak var titleLbl: UILabel!
   @IBOutlet weak var messageLbl: UILabel!
   @IBOutlet weak var rightButton: UIButton!
   @IBOutlet weak var leftButton: UIButton!

   var popUptitle = ""
   var message = ""
   var rightActionTitle = "OK"
   var leftActionTitle = "CANCEL"
   var hasleftAction = false
   var rightActionClosure: (()->())!
   var leftActionClosure: (()->())!

   override func viewDidLoad() {
      super.viewDidLoad()
       //MARK: START MHIOS-1225
       CrashManager.shared.log("AlertPopUpVC_Title: \(popUptitle),Message:\(message)")
       //MARK: START MHIOS-1225
      self.customBGView.alpha = 0
      self.contentBGView.alpha = 0
      self.leftButton.isHidden = !hasleftAction
      self.contentBGView.clipsToBounds = true
      self.contentBGView.setCornerRadius(radius: 10)
      self.rightButton.setTitle(rightActionTitle, for: .normal)
      self.leftButton.setTitle(leftActionTitle, for: .normal)
      leftButton.isHidden = !hasleftAction
      for item in buttonPaddingViews {
         item.isHidden = hasleftAction
      }
      titleLbl.text = popUptitle
      messageLbl.text = message
   }


   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      UIView.animate(withDuration: 0.3) {
         self.customBGView.alpha = 0.3
         self.contentBGView.alpha = 1.0
         self.view.layoutIfNeeded()
      }
   }

   @IBAction private func rightAction(_ sender: UIButton) {
      dismiss(completion: {
         self.rightActionClosure()
      })
   }

   @IBAction private func leftAction(_ sender: UIButton) {
      dismiss(completion: {
         self.leftActionClosure()
      })
   }

   func dismiss(completion:(()->())? = nil) {
      UIView.animate(withDuration: 0.3, animations: {
         self.customBGView.alpha = 0
         self.contentBGView.alpha = 0
         self.view.layoutIfNeeded()
      }) { (complete) in
         if complete {
            self.dismiss(animated: false) {
               DispatchQueue.main.async {
                  completion?()
               }
            }
         }
      }
   }
}

