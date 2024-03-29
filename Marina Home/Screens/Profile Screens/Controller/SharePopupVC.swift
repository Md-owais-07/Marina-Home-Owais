//
//  SharePopupVC.swift
//  Marina Home
//
//  Created by santhosh t on 24/07/23.
//

import UIKit

class SharePopupVC: AppUIViewController {

    @IBOutlet weak var emailIn: UITextField!
    @IBOutlet weak var messageIn: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @IBAction func shareAction(_ sender: Any) {
        if(emailIn.text == "")
        {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter email","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter email",type: "error")
        }
        else if validateMultipleEmails(emails: emailIn.text ?? "") {
            print("At least one email address is invalid.")
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "At least one email address is invalid.","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "At least one email address is invalid.",type: "error")
        }
        else if (messageIn.text == "")
        {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter message","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter message",type: "error")
        }
        else
        {
            print("OK")
            self.apiShareWishlist(email: emailIn.text!, message: messageIn.text!){ response in
                DispatchQueue.main.async {
                    print(response)
                    if response{
                        self.toastView(toastMessage: "Successfully Shared",type: "success")
                        self.view.removeFromSuperview()
                        self.removeFromParent()
                    }
                    else
                    {
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Try again","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Try again",type: "error")
                    }
                }
            }
        }
    }
    
    
//    func validateEmail(email: String) -> Bool {
//        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: email)
//    }

    func validateMultipleEmails(emails: String) -> Bool {
        var returnStatus = false
        let emailWithoutSpaces = emails.replacingOccurrences(of: " ", with: "")
        emailIn.text = emailWithoutSpaces
        let emailArray = emailWithoutSpaces.components(separatedBy: ",")
        print("SANTHOSH ARRAY VALUE IS : \(emailArray)")
        for email in emailArray {
                if !validateEmail(email: email) {
                    returnStatus = true
                    break
                }
        }
        return returnStatus
    }

}
