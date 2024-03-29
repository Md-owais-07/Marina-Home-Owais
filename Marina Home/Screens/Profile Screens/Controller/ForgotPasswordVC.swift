//
//  ForgotPasswordVC.swift
//  Marina Home
//
//  Created by santhosh t on 16/06/23.
//

import UIKit

class ForgotPasswordVC: AppUIViewController {
    
    @IBOutlet weak var forgotPasswordBtnView: AppBorderButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginMailField: FloatingLabeledTextField!
    @IBOutlet weak var loginErrorView: UIView!
    @IBOutlet weak var loginErrorLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Forgot password Screen")
        //MARK: END MHIOS-1225
        backActionLink(backButton)
    }

    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
        
        if loginMailField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter an email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter an email address",type: "error")
            loginErrorLbl.text = "Please enter an email address"
            loginErrorView.isHidden = false
            loginMailField.setErrorTheme(errorAction: {
                self.loginErrorLbl.text = ""
                self.loginErrorView.isHidden = true
            })
        }else if !self.checkMailIdFormat(string: loginMailField.text ?? ""){
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid email address",type: "error")
            loginErrorLbl.text = "Please enter a valid email address"
            loginErrorView.isHidden = false
            loginMailField.setErrorTheme(errorAction: {
                self.loginErrorLbl.text = ""
                self.loginErrorView.isHidden = true
            })
        }else{
            self.apiForgotPassword(parameters: ["email": loginMailField.text ?? "", "template": "email_reset"]){ response in
                DispatchQueue.main.async {
                    if response{
                        self.toastView(toastMessage: "Please check your email for reset link",type: "success")
                        //self.backActionLink(self.backButton)
                    }else{
                        self.toastView(toastMessage: "Couldn't able to send reset link to your email!. please try again",type: "success")
                    }
                }
            }
        }
        
    }
    
    
}
