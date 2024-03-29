//
//  AddPaymentCardVC.swift
//  Marina Home
//
//  Created by Eljo on 18/07/23.
//

import UIKit

class AddPaymentCardVC: AppUIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cardTypeField: FloatingLabeledTextField!
    @IBOutlet weak var cardNumberField: FloatingLabeledTextField!
    @IBOutlet weak var expireField: FloatingLabeledTextField!
    @IBOutlet weak var CVVField: FloatingLabeledTextField!
    @IBOutlet var cardErrorView: [UIView]!
    @IBOutlet var cardErrorLbl: [UILabel]!
    var savedClosure: (()->())!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tabBarController?.hideTabBar(isHidden: false)
        self.backActionDismissLink(backButton)
        cardNumberField.delegate = self
        CVVField.delegate = self
        expireField.delegate = self
        cardNumberField.addTarget(self, action: #selector(editingCardField), for: .editingChanged)
        expireField.addTarget(self, action: #selector(editingDateField), for: .editingChanged)
        cardNumberField.becomeFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.hideTabBar(isHidden: true)
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    @IBAction func saveAction(_ sender: UIButton) {
        self.tabBarController?.hideTabBar(isHidden: true)
        /*if cardTypeField.text == ""{
            self.toastView(toastMessage: "Please enter your card type",type: "error")
            cardErrorLbl[1].text = "Please enter your card type"
            cardErrorView[1].isHidden = false
            cardTypeField.setErrorTheme(errorAction: {
                self.cardErrorLbl[1].text = ""
                self.cardErrorView[1].isHidden = true
            })
        }else */
        if cardNumberField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your card number","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your card number",type: "error")
            cardErrorLbl[2].text = "Please enter your card number"
            cardErrorView[2].isHidden = false
            cardNumberField.setErrorTheme(errorAction: {
                self.cardErrorLbl[2].text = ""
                self.cardErrorView[2].isHidden = true
            })
        }else if expireField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter expiry date","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter expiry date",type: "error")
            cardErrorLbl[0].text = "Please enter expiry date"
            cardErrorView[0].isHidden = false
            expireField.setErrorTheme(errorAction: {
                self.cardErrorLbl[0].text = ""
                self.cardErrorView[0].isHidden = true
            })
        }else if CVVField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter CVV number","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter CVV number",type: "error")
            cardErrorLbl[0].text = "Please enter CVV number"
            cardErrorView[0].isHidden = false
            CVVField.setErrorTheme(errorAction: {
                self.cardErrorLbl[0].text = ""
                self.cardErrorView[0].isHidden = true
            })
        }
        else if ((cardNumberField.text?.count ?? 0) != 18) && (self.checkCardType()=="amex"){
            print("\(cardNumberField.text?.count ?? 0)")
                print("\(self.checkCardType())")
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the card number provided","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please verify the card number provided",type: "error")
            cardErrorLbl[2].text = "Please verify the card number provided"
            cardErrorView[2].isHidden = false
            cardNumberField.setErrorTheme(errorAction: {
                self.cardErrorLbl[2].text = ""
                self.cardErrorView[2].isHidden = true
            })
        }else if ((cardNumberField.text?.count ?? 0) != 19 ) && !(self.checkCardType()=="amex"){
        print("\(cardNumberField.text?.count ?? 0)")
            print("\(self.checkCardType())")
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the card number provided","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please verify the card number provided",type: "error")
            cardErrorLbl[2].text = "Please verify the card number provided"
            cardErrorView[2].isHidden = false
            cardNumberField.setErrorTheme(errorAction: {
                self.cardErrorLbl[2].text = ""
                self.cardErrorView[2].isHidden = true
            })
        }   else if(self.checkCardType()=="amex")&&(CVVField.text?.count ?? 0) != 4
        {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the CVV number provided","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please verify the CVV number provided",type: "error")
            cardErrorLbl[0].text = "Please verify the CVV number provided"
            cardErrorView[0].isHidden = false
            CVVField.setErrorTheme(errorAction: {
                self.cardErrorLbl[0].text = ""
                self.cardErrorView[0].isHidden = true
            })
        }
        else if (CVVField.text?.count ?? 0) != 3 && !(self.checkCardType()=="amex"){
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the CVV number provided","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please verify the CVV number provided",type: "error")
            cardErrorLbl[0].text = "Please verify the CVV number provided"
            cardErrorView[0].isHidden = false
            CVVField.setErrorTheme(errorAction: {
                self.cardErrorLbl[0].text = ""
                self.cardErrorView[0].isHidden = true
            })
        }
        else if (expireField.text?.count ?? 0) != 5{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the expiration date provided","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please verify the expiration date provided",type: "error")
            cardErrorLbl[0].text = "Please verify the expiration date provided"
            cardErrorView[0].isHidden = false
            expireField.setErrorTheme(errorAction: {
                self.cardErrorLbl[0].text = ""
                self.cardErrorView[0].isHidden = true
            })
        }else{
            let expiry = (expireField.text ?? "").components(separatedBy: "/")
            let expiryMonth = (expiry.first ?? "").starts(with: "0") ? String((expiry.first ?? "").dropFirst()) : (expiry.first ?? "")
            let expiryYear = "20\(expiry.last ?? "")"
            let expiryDate = makeDate(year: Int(expiryYear) ?? 0, month: Int(expiryMonth) ?? 0, day: 28, hr: 24, min: 59, sec: 59)
            if (Int(expiryMonth) ?? 0) > 12{
                //MARK: START MHIOS-1285
                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the expiration date provided","Screen" : self.className])
                //MARK: END MHIOS-1285
                self.toastView(toastMessage: "Please verify the expiration date provided",type: "error")
                cardErrorLbl[0].text = "Please verify the expiration date provided"
                cardErrorView[0].isHidden = false
                expireField.setErrorTheme(errorAction: {
                    self.cardErrorLbl[0].text = ""
                    self.cardErrorView[0].isHidden = true
                })
            }else if expiryDate < Date(){
                //MARK: START MHIOS-1285
                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Your card has reached its expiration date. Please try using a new card","Screen" : self.className])
                //MARK: END MHIOS-1285
                self.toastView(toastMessage: "Your card has reached its expiration date. Please try using a new card",type: "error")
                cardErrorLbl[0].text = "Your card has reached its expiration date. Please try using a new card"
                cardErrorView[0].isHidden = false
                expireField.setErrorTheme(errorAction: {
                    self.cardErrorLbl[0].text = ""
                    self.cardErrorView[0].isHidden = true
                })
            }else{
                let cardtype = self.checkCardType()
                let params = ["type": (cardtype ?? "").lowercased(),
                              "number": (cardNumberField.text ?? "").replacingOccurrences(of: " ", with: ""),
                              "expiry_month": Int(expiryMonth) ?? 0,
                              "expiry_year": Int(expiryYear) ?? 0,
                              "cvv": CVVField.text ?? ""] as [String : Any]
                self.apiAddPaymentCardDetails(parameters: params){ response in
                    DispatchQueue.main.async {
                        print(response)
                        self.toastView(toastMessage: "Details added successfully!",type: "success")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.savedClosure()
                            self.dismiss(animated: true)
                        })
                    }
                }
            }
        }
    }

    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        var calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)!
    }

    @objc func editingCardField(_ sender: UITextField) {
          if sender.text!.count > 0 && sender.text!.count % 5 == 0 && sender.text!.last! != " " {
             sender.text!.insert(" ", at:sender.text!.index(sender.text!.startIndex, offsetBy: sender.text!.count-1) )
          }
     }

    @objc func editingDateField(_ sender: UITextField) {
          if sender.text!.count > 0 && sender.text!.count % 3 == 0 && sender.text!.last! != "/" {
             sender.text!.insert("/", at:sender.text!.index(sender.text!.startIndex, offsetBy: sender.text!.count-1) )
          }
     }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 20
        switch textField{
        case cardNumberField:
            
            cardTypeField.becomeFirstResponder()
            cardTypeField.text = self.checkCardType()
            maxLength = 19
        case CVVField:
            let cardtype = self.checkCardType()
            if(cardtype=="amex")
            {
                maxLength = 4
            }
            else
            {
                maxLength = 3
            }
        case expireField:
            maxLength = 5
        default:
            maxLength = 20
        }
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    func checkCardType()->String
    {
        if cardNumberField.text?.first == "4" {
            return "visa"
        }
        else if cardNumberField.text?.first == "5"||cardNumberField.text?.first == "2"{
            return "master"
        }
        else if cardNumberField.text?.first == "3"{
            return "amex"
        }
        return "visa"
    }
        
}

