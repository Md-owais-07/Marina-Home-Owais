//
//  CartShareScreen.swift
//  Marina Home
//
//  Created by santhosh t on 15/11/23.
//

import UIKit

protocol CartShareScreenDelegate {
    func closePopup()
    func shareEmailAPICall(email:String,message:String,quoteId:Int)
    func shareCopyLinkAPICall(quoteId:Int)
    func shareWhatsAppAPICall(quoteId:Int)
}

class CartShareScreen: UIView {

    @IBOutlet weak var emailRoundView: UIView!
    @IBOutlet weak var emailImgView: UIImageView!
    @IBOutlet weak var mailContentView: UIView!
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    
    @IBOutlet weak var emailIn: UITextField!
    @IBOutlet weak var messageIn: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    var cartShareScreenDelegate : CartShareScreenDelegate?
    var quoteId : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("CartShareScreen", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        tabSelection(tabIndex: 0)
    }
    
    func tabSelection(tabIndex:Int)
    {
        emailIn.text = ""
        messageIn.text = ""
        switch tabIndex {
        case 0:
            mailContentView.isHidden = true
            emailImgView.image = UIImage(named: "email")
            emailRoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            emailRoundView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
            emailRoundView.layer.borderWidth = 1
            mainHeight.constant = 188
            break
        case 1:
            mailContentView.isHidden = false
            emailImgView.image = UIImage(named: "email_white")
            emailRoundView.backgroundColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
            emailRoundView.layer.borderColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
            emailRoundView.layer.borderWidth = 1
            mainHeight.constant = 450
            break
        case 2:
            mailContentView.isHidden = true
            emailImgView.image = UIImage(named: "email")
            emailRoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            emailRoundView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
            emailRoundView.layer.borderWidth = 1
            mainHeight.constant = 188
            break
        case 3:
            mailContentView.isHidden = true
            emailImgView.image = UIImage(named: "email")
            emailRoundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            emailRoundView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
            emailRoundView.layer.borderWidth = 1
            mainHeight.constant = 188
            break
        default:
            print("not")
        }
    }

    @IBAction func emailBtnAction(_ sender: UIButton) {
        tabSelection(tabIndex: 1)
        
    }
    
    @IBAction func linkBtnAction(_ sender: UIButton) {
        tabSelection(tabIndex: 2)
        self.cartShareScreenDelegate?.shareCopyLinkAPICall(quoteId: quoteId)
    }
    
    @IBAction func whatsaooBtnAction(_ sender: UIButton) {
        tabSelection(tabIndex: 3)
        self.cartShareScreenDelegate?.shareWhatsAppAPICall(quoteId: quoteId)
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        ///Validatin the Email field
        if(emailIn.text == "")
        {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter email","Screen" : self.className])
            //MARK: END MHIOS-1285
            AppUIViewController().toastView(toastMessage: "Please enter email",type: "error")
        }
        else if AppUIViewController().validateEmail(email: emailIn.text ?? "") == false {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Email address is invalid.","Screen" : self.className])
            //MARK: END MHIOS-1285
            AppUIViewController().toastView(toastMessage: "Email address is invalid.",type: "error")
        }
        else
        {
            self.cartShareScreenDelegate?.shareEmailAPICall(email: emailIn.text!, message: messageIn.text!,quoteId: quoteId)
        }
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.cartShareScreenDelegate?.closePopup()
    }
    
}
