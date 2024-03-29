//
//  ActionSheetViewController.swift
//  Marina Home
//
//  Created by codilar on 30/11/23.
//

import UIKit
// Mark MHIOS-1099
// View Controller ActionSheetViewController added in CommonScreens.storyboard

class ActionSheetViewController: UIViewController {

    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var heightConstant: NSLayoutConstraint!
    @IBOutlet weak var btnOptionTwo: AppBorderButton!
    @IBOutlet weak var btnOptionOne: AppPrimaryButton!
    var height : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        height = self.isGoogleMapInstalled() == true ? self.isAppleMapInstalled() == true ? 220 : 180 : 180
        self.heightConstant.constant = self.height
        self.btnOptionTwo.isHidden = self.isGoogleMapInstalled() == true ? false : true
        self.btnOptionOne.isHidden = self.isAppleMapInstalled() == true ? false : true
       
    }
    override func viewWillAppear(_ animated: Bool) {
        openPopup()
    }
    
    func openPopup()
    {
        
        UIView.animate(withDuration: 0.5, delay: 0.2) { [weak self] in
           
            self?.bottomConstant.constant = -10
            self?.view.backgroundColor = .black.withAlphaComponent(0.1)
            self?.view.layoutIfNeeded()

        }
    }
    func closePopup()
    {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.heightConstant.constant = 50
            self.bottomConstant.constant = -100
            self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
                self?.view.removeFromSuperview()
                self?.removeFromParent()
            })
        
    }
    @IBAction func optionOneClicked(_ sender: Any) {
        closePopup()
        UIApplication.shared.open(URL(string:
                                        MapURLs.AppleMapLink)! as URL, options: [:], completionHandler: nil)
    }
    @IBAction func optionTwoClicked(_ sender: Any) {
        closePopup()
        UIApplication.shared.open(URL(string:
                                        MapURLs.GoogleMapLink)! as URL, options: [:], completionHandler: nil)
    }
    @IBAction func close(_ sender: Any) {
       
       closePopup()
       
    }
    
    func isGoogleMapInstalled()->Bool
    {
        if (UIApplication.shared.canOpenURL(URL(string:StringConstants.googleMapLink)!))
        {
            return true
        }
        else
        {
            return false
        }
        
    }

    func isAppleMapInstalled()->Bool
    {
        if (UIApplication.shared.canOpenURL(URL(string:StringConstants.appleMapLink)!))
        {
            return true
        }
        else
        {
            return false
        }
    }
}
// Mark MHIOS-1099
