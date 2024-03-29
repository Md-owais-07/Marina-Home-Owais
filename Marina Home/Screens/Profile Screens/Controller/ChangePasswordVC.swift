//
//  ChangePasswordVC.swift
//  Marina Home
//
//  Created by Eljo on 07/06/23.
//

import UIKit
import Alamofire
class ChangePasswordVC: AppUIViewController {
    @IBOutlet var txtNewPasword: FloatingLabeledTextField!
    @IBOutlet var txtConfirempassword: FloatingLabeledTextField!
    @IBOutlet var txtOldPasword: FloatingLabeledTextField!
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var passwordErrorLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Change Password Screen")
        //MARK: END MHIOS-1225
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        // Do any additional setup after loading the view.
    }
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
                self.view.frame.origin.y = -keyboardSize.height
            
        }
    }
    @IBAction func close(_ sender: Any) {
        self.tabBarController?.hideTabBar(isHidden: true)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @IBAction func ChnagePassword(_ sender: Any) {
        if(txtNewPasword.text == txtConfirempassword.text)
        {
            let parameter:Parameters = ["currentPassword":txtOldPasword.text ?? "","newPassword":txtNewPasword.text ?? ""]
            self.apiChangePasword(parameters: parameter){ response in
                self.toastView(toastMessage: "Password changed successfully!" ,type: "success")
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
        else
        {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Passwords does not match!","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Passwords does not match!" ,type: "error")
            passwordErrorLbl.text = "Passwords does not match!"
            passwordErrorView.isHidden = false
            txtConfirempassword.setErrorTheme(errorAction: {
                self.passwordErrorLbl.text = ""
                self.passwordErrorView.isHidden = true
            })
            self.txtNewPasword.text = ""
            self.txtConfirempassword.text = ""
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
