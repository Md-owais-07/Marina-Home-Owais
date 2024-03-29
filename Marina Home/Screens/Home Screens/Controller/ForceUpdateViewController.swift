//
//  ForceUpdateViewController.swift
//  Marina Home
//
//  Created by codilar on 08/12/23.
//
//Mark MHIOS-1158
// ForceUpdateViewController added in HomeScreens.storyboard

import UIKit

class ForceUpdateViewController: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnUpdateNow: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var updateTitle : String = "Elevate Your Experience!"
    var updateDescription: String =  "Update the app now for elevated user experience and exclusive features!"
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = updateTitle
        lblDescription.text = updateDescription
    }
    
    @IBAction func onClickUpdateNow(_ sender: Any) {
        
        if let url = URL(string:AppInfo.shared.appLink) {
            UIApplication.shared.open(url)
        }
    }
    
   

}
//Mark MHIOS-1158
