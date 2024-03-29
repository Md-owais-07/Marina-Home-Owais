//
//  GuestOrderTrackingVC.swift
//  Marina Home
//
//  Created by Eljo on 28/07/23.
//

import UIKit

class GuestOrderTrackingVC: AppUIViewController {
    @IBOutlet var loginView: UIView!
    @IBOutlet var txtBillingName: FloatingLabeledTextField!
    @IBOutlet var btnback: UIButton!
    @IBOutlet var txtOrderid: FloatingLabeledTextField!
    @IBOutlet var txtEmail: FloatingLabeledTextField!
    @IBOutlet var guestErrorView: [UIView]!
    @IBOutlet var guestErrorLbl: [UILabel]!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainViewConst: NSLayoutConstraint!
    
    var statusBarHeight:CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backActionLink(self.btnback)
        
        statusBarHeight = UIApplication.shared.statusBarFrame.height+72
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
      {
      //MARK: START MHIOS-1225
      CrashManager.shared.log("Guest Order Tracking Screen with values")
      //MARK: END MHIOS-1225
        if UserData.shared.isLoggedIn{
            self.loginView.isHidden = true
        }
    }
    @objc func keyboardWillHide() {
        //mainView.frame.origin.y = 0
        mainViewConst.constant = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            //mainView.frame.origin.y = -keyboardSize.height
            mainViewConst.constant = -keyboardSize.height/2
        }
    }
    
    
    @IBAction func trackAction(_ sender: Any) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("OrderId: \(txtOrderid.text ?? "")")
        CrashManager.shared.log("EmailId:  \(txtEmail.text ?? "")")
        CrashManager.shared.log("Billing Name:  \(txtBillingName.text ?? "")")
        //MARK: END MHIOS-1225
        if self.txtOrderid.text == ""{
            self.toastView(toastMessage: "Please enter an Order Id",type: "error")
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter an Order Id","Screen" : self.className])
            //MARK: END MHIOS-1285
            guestErrorLbl[0].text = "Please enter an Order Id"
            guestErrorView[0].isHidden = false
            txtOrderid.setErrorTheme(errorAction: {
                self.guestErrorLbl[0].text = ""
                self.guestErrorView[0].isHidden = true
            })
        }else if self.txtEmail.text == ""{
            self.toastView(toastMessage: "Please enter an email address",type: "error")
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter an email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            guestErrorLbl[1].text = "Please enter an email address"
            guestErrorView[1].isHidden = false
            txtEmail.setErrorTheme(errorAction: {
                self.guestErrorLbl[1].text = ""
                self.guestErrorView[1].isHidden = true
            })
        }else if self.txtBillingName.text == ""{
            self.toastView(toastMessage: "Please enter your billing last name",type: "error")
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your billing last name" ])
            //MARK: END MHIOS-1285
            guestErrorLbl[2].text = "Please enter your billing last name"
            guestErrorView[2].isHidden = false
            txtBillingName.setErrorTheme(errorAction: {
                self.guestErrorLbl[2].text = ""
                self.guestErrorView[2].isHidden = true
            })
        }else if !self.checkMailIdFormat(string: self.txtEmail.text ?? ""){
            self.toastView(toastMessage: "Please enter a valid email address",type: "error")
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid email address","Screen" : self.className ])
            //MARK: END MHIOS-1285
            guestErrorLbl[1].text = "Please enter a valid email address"
            guestErrorView[1].isHidden = false
            txtEmail.setErrorTheme(errorAction: {
                self.guestErrorLbl[1].text = ""
                self.guestErrorView[1].isHidden = true
            })
        }else{
            self.apiGetOrderDetail(orderId: self.txtOrderid.text ?? "", email: self.txtEmail.text ?? "", billingLastName: self.txtBillingName.text ?? ""){response in
                DispatchQueue.main.async {
                    if (response.items?.count ?? 0) > 0{
                        let nextVC = AppController.shared.orderDetail
                        nextVC.orderId = self.txtOrderid.text ?? ""
                        nextVC.emailId = self.txtEmail.text ?? ""
                        nextVC.isFromGuest = true
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }else{
                        self.toastView(toastMessage: "Order not found please check the details", type: "error")
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Order not found please check the details","Screen" : self.className ])
                        //MARK: END MHIOS-1285
                    }
                }
            }
        }
        
    }
    override func checkMailIdFormat(string: String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: string)
    }
    @IBAction func login(_ sender: Any) {
        var vc = AppController.shared.loginRegister
        vc.isFromOrder = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

