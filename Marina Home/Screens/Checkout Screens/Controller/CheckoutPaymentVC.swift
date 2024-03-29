
//
//  CheckoutPaymentVC.swift
//  Marina Home
//
//  Created by Codilar on 23/05/23.
//

import UIKit
import Alamofire
import Frames
import Tabby
import SwiftUI
import PassKit
import WebKit
import CreditCardScanner
import Firebase
import Adjust
import FirebaseAnalytics

class CheckoutPaymentVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource,editAdressProtocol{
    func editedGuestAdress(option: [String : Any]) {
        
    }
    
    @IBOutlet var paymentFailedView: UIView!
    
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var forwardArrow: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var listingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var orderTotalLbl: UILabel!
    @IBOutlet weak var grandTotalLbl: UILabel!
    @IBOutlet weak var payButton: AppPrimaryButton!
    var selectedShippingMethords:ShipingMethod?
    var paymentOptions:[PaymentMethod] = []
    var selectedPayment = -1
    var creditCardPosition = -2
    var selectedTimeSlot = ""
    var orderID = ""
    var incrementID = ""
    var address:Addresses?
    var parameterAdress:[String: Any] = [:]
    var cartTotal:GrandTotal?
    var carrierCode = ""
    var methodCode = ""
    var methodTitle = ""
    var postPaymentID = ""
    var tabbyPaymentID = ""
    var shipping_carrier_code = ""
    var shipping_method_code = ""
    var txtCardName:UITextField?
    var txtCardNumber:UITextField?
    var txtCarddate:UITextField?
    var txtCVV:UITextField?
    var isToSaveCard = false
    var cashedItemsCount = 0
    var paymentCardsArray:[PaymentCardModel] = []
    @IBOutlet weak var discountView: UILabel!
    @IBOutlet weak var discountIN: UILabel!
    
    var isTabbyInstallmentsAvailable:Bool = false
    @State var isTabbyPaylatersAvailable = false
    
    @State var openedProduct: TabbyProductType = .installments
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        
        
        backActionLink(backButton)
        payButton.semanticContentAttribute = .forceRightToLeft
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.payementSucces=true
        self.shipping_method_code =    appDelegate.shipingInfo?.methodCode ?? ""
        self.shipping_carrier_code =    appDelegate.shipingInfo?.carrierCode ?? ""
        self.listingTable.delegate = self
        self.listingTable.dataSource = self
        self.listingTable.register(UINib(nibName: "PaymentOptionsTVC", bundle: nil), forCellReuseIdentifier: "PaymentOptionsTVC_id")
        self.listingTable.register(UINib(nibName: "CreditCardTVC", bundle: nil), forCellReuseIdentifier: "CreditCardTVC")
        self.listingTable.register(UINib(nibName: "StoredCardListingCell", bundle: nil), forCellReuseIdentifier: "StoredCardListingCell")
        
        self.txtCarddate?.delegate = self
        self.txtCVV?.delegate = self
        self.txtCardName?.delegate = self
        self.txtCardNumber?.delegate = self
        
        
        if let addressData = address{
            fullNameLbl.text = "\(addressData.firstname ?? "") \(addressData.lastname ?? "")"
            var street = ""
            let address2 = "\(addressData.region?.region ?? "")  \(addressData.postcode  ?? "")"
            for i in addressData.street!{
                street = street + i + " "
            }
            addressLbl.text = "\(street)\n\(address2)"
        }
        if UserData.shared.isLoggedIn == false{
            self.btnEdit.isHidden = true
            self.forwardArrow.isHidden = true
            fullNameLbl.text = "\(parameterAdress["firstname"] ?? "") \(parameterAdress["lastname"] ?? "")"
            var street = ""
            let address2 = parameterAdress["region"] as! String
            let str: [String] = parameterAdress["street"]  as! [String]
            for i in str{
                street = street + i as String + " "
            }
            addressLbl.text = "\(street)\n\(address2)"
            
        }
        
        if let cartTotalData = cartTotal{
            subTotalLbl.text="\(formatNumberToThousandsDecimal(number:Double(cartTotalData.subtotalInclTax ?? 0.00))) AED"
            
            let deliveryPrice = Double(cartTotalData.shippingInclTax ?? Double(0.00))
            if deliveryPrice == 0
            {
                deliveryLbl.text = "FREE"
            }
                        else
                            {
                    deliveryLbl.text = "\(formatNumberToThousandsDecimal(number:deliveryPrice) ) AED"
                                }
                        
                        let discountAmount = Double(cartTotalData.discountAmount ?? Double(0.00))
                        if discountAmount == 0
                                        {
                                discountView.isHidden = true
                                discountIN.isHidden = true
                            }
                        else
                            {
                                    discountView.isHidden = false
                                    discountIN.isHidden = false
                                    discountIN.text = "\(formatNumberToThousandsDecimal(number:discountAmount) ) AED"
                                }
                        
                        ///deliveryLbl.text = "\(formatNumberToThousandsDecimal(number:Int(cartTotalData.shippingAmount ?? Double(0.0))) ) AED"
                        orderTotalLbl.text="\(formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
                        grandTotalLbl.text="\(formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
            
                        
                    }
        var addressParam:[String:Any] = ["region": self.address?.region?.region ?? "", "region_id": self.address?.region?.region_id ?? ""
                                         ,"country_id": "AE",
                                         "street": self.address?.street,
                                         "firstname": self.address?.firstname,
                                         // MARK: START MHIOS-1112
                                         "lastname": self.address?.lastname?.trimTrailingWhitespace() ?? "",
                                         // MARK: END MHIOS-1112
                                         "telephone": self.address?.telephone,
                                         "postcode": self.address?.postcode,
                                         "city": self.address?.city,"customerAddressId": self.address?.id,
                                         "customerId":UserData.shared.userId ]
        
        let parameter:[String: Any] = ["addressInformation":
                                        ["shipping_address": addressParam,
                                         "billing_address": addressParam,"shipping_carrier_code": AppInfo.shared.guestCarriercode,
                                         "shipping_method_code": AppInfo.shared.guestShipingCode,
                                         "extension_attributes": [
                                            "amdeliverydate_date": self.selectedTimeSlot,
                                            //MARK START{MHIOS-991}
                                            "payment_method_for_app" : true
                                            //MARK END{MHIOS-991}
                                         ]]]
        if UserData.shared.isLoggedIn{
            self.apiAddShipmentOptions(parameters: parameter){ response in
            self.paymentOptions = response.paymentMethods
            self.apiGrandTotal(){ response in
                self.hideActivityIndicator(uiView: self.view)
                DispatchQueue.main.async {
                    self.cartTotal = response
                    if let cartTotalData = self.cartTotal{
                    self.subTotalLbl.text="\(self.formatNumberToThousandsDecimal(number:Double(cartTotalData.subtotalInclTax ?? 0.00)) ) AED"
                    let deliveryPrice = Double(cartTotalData.shippingInclTax ?? Double(0.00))
                    if deliveryPrice == 0
                      {
                        self.deliveryLbl.text = "FREE"
                      }
                     else
                     {
                        self.deliveryLbl.text = "\(self.formatNumberToThousandsDecimal(number:deliveryPrice)) AED"
                     }
                   let discountAmount = Double(cartTotalData.discountAmount ?? Double(0.00))
                   if discountAmount == 0
                      {
                        self.discountView.isHidden = true
                        self.discountIN.isHidden = true
                       }
                       else
                       {
                         self.discountView.isHidden = false
                         self.discountIN.isHidden = false
                         self.discountIN.text = "\(self.formatNumberToThousandsDecimal(number:discountAmount)) AED"
                       }
                        self.orderTotalLbl.text="\(self.formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
                        self.grandTotalLbl.text="\(self.formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
                           
                       }
                    }
                    DispatchQueue.main.async {
                        print(response)
                        self.hideActivityIndicator(uiView: self.view)
                        // self.paymentOptions = response.paymentMethods ?? []
                        // MARK Start MHIOS-1095
                        //MARK START{MHIOS-991}
                        if self.paymentOptions.count != 0
                        {
                            self.selectedPayment = 0
                            var k:Int = 0
                            for i in self.paymentOptions
                            {
                                if (i.code == "checkoutcom_card_payment")
                                {
                                    self.creditCardPosition = k
                                    
                                    //self.selectedPayment = k
                                }
                                
                                k=k+1
                            }
                            
                            let payementOption = self.paymentOptions[self.selectedPayment]
                            let isApplePay = payementOption.title.uppercased() == "APPLE PAY"
                            if isApplePay{
                                self.payButton.setAttributedTitle(self.getAppleText(), for: .normal)
                            }else{
                                if(payementOption.code == "tabby_installments"||payementOption.code == "postpay")
                                {
                                    self.payButton.setAttributedTitle(nil, for: .normal)
                                    self.payButton.setTitle("PAY IN \(payementOption.title.uppercased())", for: .normal)
                                }
                                else
                                {
                                    self.payButton.setAttributedTitle(nil, for: .normal)
                                    self.payButton.setTitle("PAY WITH \(payementOption.title.uppercased())", for: .normal)
                                }
                                
                            }
                            // MARK End MHIOS-1095
                            
                            // MARK Start MHIOS-1140
                            self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70)
                            if(self.selectedPayment == self.creditCardPosition)
                            {
                                self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70) + 250
                                if(self.paymentCardsArray.count>0)
                                {
                                    let count = self.paymentOptions.count+1
                                    self.listingTableHeight.constant = CGFloat(count*70) + 250
                                }
                            }
                            else
                            {
                                if(self.paymentCardsArray.count>0)
                                {
                                    let count = self.paymentOptions.count+1
                                    self.listingTableHeight.constant = CGFloat(count*70)
                                }
                            }
                            self.listingTable.reloadData()
                            // MARK End MHIOS-1140
                        }
                        //MARK END{MHIOS-991}
                    }
                }

            }
        }
        else
        {
            var parameter2:[String: Any] = self.parameterAdress
            parameter2["same_as_billing"] = 1
            
            let parameter3:[String: Any] = ["address":parameter2]
            let parameter4:[String: Any] = self.parameterAdress
            
            self.apiGuestPaymentMethods(parameters:parameter3 ){ response in
                DispatchQueue.main.async {
                    print(response)
                    //MARK start MHIOS-1151
                    if response.count > 0{
                        self.carrierCode = response[0].carrierCode
                        self.methodCode = response[0].methodCode
                    }else{
                        self.apiLogError(message: "order place response error - missing methodCode and carrierCode - parameters : \(parameter3)")
                    }
                    //MARK end MHIOS-1151
                    let parameter1:[String: Any] = ["addressInformation":
                                                        ["shipping_address":parameter4 ,
                                                         "billing_address": parameter4,
                                                         "shipping_carrier_code": AppInfo.shared.guestCarriercode,
                                                         "shipping_method_code": AppInfo.shared.guestShipingCode,
                                                         "extension_attributes": [
                                                            "amdeliverydate_date": self.selectedTimeSlot,
                                                            //MARK START{MHIOS-991}
                                                            "payment_method_for_app" : true
                                                            //MARK END{MHIOS-991}
                                                         ]]]
                    self.hideActivityIndicator(uiView: self.view)
                    self.apiGuestAddShipmentOptions(parameters: parameter1){ response in
                        
                        self.paymentOptions = response.paymentMethods ?? []
                        self.apiGuestGrandTotal(){ response in
                            self.hideActivityIndicator(uiView: self.view)
                            DispatchQueue.main.async {
                                self.cartTotal = response
                                if let cartTotalData = self.cartTotal{
                                    self.subTotalLbl.text="\(self.formatNumberToThousandsDecimal(number:Double(cartTotalData.subtotalInclTax ?? 0.00)) ) AED"
                                                  
                                                let deliveryPrice = Double(cartTotalData.shippingInclTax ?? Double(0.00))
                                                if deliveryPrice == 0
                                                                {
                                                        self.deliveryLbl.text = "FREE"
                                                    }
                                                else
                                                    {
                                                            self.deliveryLbl.text = "\(self.formatNumberToThousandsDecimal(number:deliveryPrice) ) AED"
                                                        }
                                                
                                                let discountAmount = Double(cartTotalData.discountAmount ?? Double(0.00))
                                                if discountAmount == 0
                                                                {
                                                        self.discountView.isHidden = true
                                                        self.discountIN.isHidden = true
                                                    }
                                                else
                                                    {
                                                            self.discountView.isHidden = false
                                                            self.discountIN.isHidden = false
                                                            self.discountIN.text = "\(self.formatNumberToThousandsDecimal(number:discountAmount) ) AED"
                                                        }
                                                
                                                ///deliveryLbl.text = "\(formatNumberToThousandsDecimal(number:Int(cartTotalData.shippingAmount ?? Double(0.0))) ) AED"
                                                self.orderTotalLbl.text="\(self.formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
                                                self.grandTotalLbl.text="\(self.formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
                                                
                                                
                                            }
                            }
                            DispatchQueue.main.async {
                                self.hideActivityIndicator(uiView: self.view)
                                // MARK Start MHIOS-1095
                                self.selectedPayment = 0
                                var k:Int = 0
                                for i in self.paymentOptions
                                {
                                    if (i.code == "checkoutcom_card_payment")
                                    {
                                        self.creditCardPosition = k
                                    }
                                    
                                    k=k+1
                                }
                                //MARK START{MHIOS-991}
                                if self.paymentOptions.count != 0
                                {
                                    let payementOption = self.paymentOptions[self.selectedPayment]
                                    let isApplePay = payementOption.title.uppercased() == "APPLE PAY"
                                    if isApplePay{
                                        self.payButton.setAttributedTitle(self.getAppleText(), for: .normal)
                                    }else{
                                        if(payementOption.code == "tabby_installments"||payementOption.code == "postpay")
                                        {
                                            self.payButton.setAttributedTitle(nil, for: .normal)
                                            self.payButton.setTitle("PAY IN \(payementOption.title.uppercased())", for: .normal)
                                        }
                                        else
                                        {
                                            self.payButton.setAttributedTitle(nil, for: .normal)
                                            self.payButton.setTitle("PAY WITH \(payementOption.title.uppercased())", for: .normal)
                                        }
                                    }
                                }
                                //MARK END{MHIOS-991}
                                // MARK Start MHIOS-1095
                                self.listingTable.reloadData()
                                self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70)
                                if(self.paymentCardsArray.count>0)
                                {
                                    let count = self.paymentOptions.count+1
                                    self.listingTableHeight.constant = CGFloat(count*70)
                                }
                                if(self.selectedPayment == self.creditCardPosition)
                                {
                                    self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70) + 243
                                }
                                
                                
                            }
                        }
                        
                        
                        
                        
                    }
                    
                }
            }
        }
        

        /*if UserData.shared.isLoggedIn{
         self.apiPaymentOptions(){ response in
         DispatchQueue.main.async {                  print(response)
         self.hideActivityIndicator(uiView: self.view)
         // self.paymentOptions = response.paymentMethods ?? []
         
         var k:Int = 0
         for i in self.paymentOptions
         {
         if (i.code == "checkoutcom_apple_pay")
         {
         self.selectedPayment = k
         }
         k=k+1
         }
         self.listingTable.reloadData()
         self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70)
         if(self.paymentCardsArray.count>0)
         {
         let count = self.paymentOptions.count+1
         self.listingTableHeight.constant = CGFloat(count*70)
         }
         if(self.selectedPayment == self.creditCardPosition)
         {
         self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70) + 243
         }
         
         }
         }
         }
         else
         {
         self.apiGuestPaymentOptions(){ response in
         DispatchQueue.main.async {
         print(response)
         self.hideActivityIndicator(uiView: self.view)
         // self.paymentOptions = response.paymentMethods ?? []
         var k:Int = 0
         for i in self.paymentOptions
         {
         if (i.code == "checkoutcom_apple_pay")
         {
         self.selectedPayment = k
         }
         k=k+1
         }
         self.listingTable.reloadData()
         self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70)
         if(self.paymentCardsArray.count>0)
         {
         let count = self.paymentOptions.count+1
         self.listingTableHeight.constant = CGFloat(count*70)
         }
         if(self.selectedPayment == self.creditCardPosition)
         {
         self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70) + 243
         }
         
         }
         }
         }*/
        
        setAllData()
        
        if UserData.shared.isLoggedIn{
            self.getSavedCards()
        }
    }
    //MARK MHIOS-1101_SANTHOSH EDIT ADDRESS NOT UPDATED THAT ISSUE FIXED
    func setAllData()
    {
        let addressParam:[String:Any] = ["region": self.address?.region?.region ?? "", "region_id": self.address?.region?.region_id ?? ""
                                         ,"country_id": "AE",
                                         "street": self.address?.street ?? "",
                                         "firstname": self.address?.firstname ?? "",
                                         // MARK: START MHIOS-1112
                                         "lastname": self.address?.lastname?.trimTrailingWhitespace() ?? "",
                                         // MARK: END MHIOS-1112
                                         "telephone": self.address?.telephone ?? "",
                                         "postcode": self.address?.postcode ?? "",
                                         "city": self.address?.city ?? "",]
        
        let parameter:[String: Any] = ["addressInformation":
                                        ["shipping_address": addressParam,
                                         "billing_address": addressParam,"shipping_carrier_code": AppInfo.shared.guestCarriercode,
                                         "shipping_method_code": AppInfo.shared.guestShipingCode,
                                         "extension_attributes": [
                                            "amdeliverydate_date": self.selectedTimeSlot,
                                            //MARK START{MHIOS-991}
                                            "payment_method_for_app" : true
                                            //MARK END{MHIOS-991}
                                         ]]]
        
    if UserData.shared.isLoggedIn
        {
            self.apiAddShipmentOptions(parameters: parameter){ response in
                
                //self.paymentOptions = response.paymentMethods ?? []
                self.apiGrandTotal(){ response in
                    self.hideActivityIndicator(uiView: self.view)
                    DispatchQueue.main.async {
                        self.cartTotal = response
                        self.setCartTotal()
                    }
                }
                
            }
            
        }
        else
        {
            var parameter2:[String: Any] = self.parameterAdress
            parameter2["same_as_billing"] = 1
            let parameter4:[String: Any] = self.parameterAdress
            
            let parameter1:[String: Any] = ["addressInformation":
                                                ["shipping_address":parameter4 ,
                                                 "billing_address": parameter4,"shipping_carrier_code": AppInfo.shared.guestCarriercode,
                                                 "shipping_method_code": AppInfo.shared.guestShipingCode,
                                                 "extension_attributes": [
                                                    "amdeliverydate_date": self.selectedTimeSlot,
                                                    //MARK START{MHIOS-991}
                                                    "payment_method_for_app" : true
                                                    //MARK END{MHIOS-991}
                                                 ]]]
            
            self.apiGuestAddShipmentOptions(parameters: parameter1){ response in
                
                self.apiGuestGrandTotal(){ response in
                    self.hideActivityIndicator(uiView: self.view)
                    DispatchQueue.main.async {
                        self.cartTotal = response
                        self.setCartTotal()
                    }
                }
            }
            
        }
    }
    //MARK MHIOS-1101_SANTHOSH EDIT ADDRESS NOT UPDATED THAT ISSUE FIXED
    func setCartTotal()
    {
        if let cartTotalData = cartTotal{
            subTotalLbl.text="\(formatNumberToThousandsDecimal(number:Double(cartTotalData.subtotalInclTax ?? 0.00))) AED"
            let deliveryPrice = Double(cartTotalData.shippingInclTax ?? Double(0.00))
            
            if deliveryPrice == 0
            {
                deliveryLbl.text = "FREE"
            }
            else
            {
                deliveryLbl.text = "\(formatNumberToThousandsDecimal(number:deliveryPrice) ) AED"
            }
            let discountAmount = Double(cartTotalData.discountAmount ?? Double(0.00))
            if discountAmount == 0
            {
                discountView.isHidden = true
                discountIN.isHidden = true
            }
            else
            {
                discountView.isHidden = false
                discountIN.isHidden = false
                discountIN.text = "\(formatNumberToThousandsDecimal(number:discountAmount) ) AED"
            }
            orderTotalLbl.text="\(formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
            grandTotalLbl.text="\(formatNumberToThousandsDecimal(number:Double(cartTotalData.baseGrandTotal ?? 0.00)) ) AED"
        }
    }
    
    func getAppleText()-> NSMutableAttributedString{
        let startString = NSMutableAttributedString(string: "PAY WITH ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "Apple_Pay-White")
        image1Attachment.bounds = CGRect(x: 0, y: 0, width: 13, height: 13)
        let image1String = NSAttributedString(attachment: image1Attachment)
        startString.append(image1String)
        startString.append(NSAttributedString(string: " PAY"))
        return startString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.payementSucces==false)
        {
            self.paymentFailedView.isHidden = false
        }
        else
        {
            self.paymentFailedView.isHidden = true
        }
    }
    @objc func SeveCard(_ sender: UIButton) {
        if (self.isToSaveCard == true)
        {
            self.isToSaveCard = false
        }
        else
        {
            self.isToSaveCard = true
        }
        self.listingTable.reloadData()
    }
    @objc func cardScan(_ sender: UIButton) {
        let creditCardScannerViewController = CreditCardScannerViewController(delegate: self)
        present(creditCardScannerViewController, animated: true)
    }
    func editedAdress(option: Addresses) {
        if UserData.shared.isLoggedIn{
            self.address = option
            if let addressData = address{
                fullNameLbl.text = "\(addressData.firstname ?? "") \(addressData.lastname ?? "")"
                var street = ""
                let address2 = (addressData.region?.region! ?? "") + " " + (addressData.postcode ?? "")
                for i in addressData.street!{
                    street = street + i + " "
                }
                addressLbl.text = "\(street)\n\(address2)"
                setAllData()
            }
        }
    }
    @IBAction func TermsAndCondtions(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let vc = AppController.shared.web
        // Mark MHIOS-533
        vc.hidesBottomBarWhenPushed = true
        // Mark MHIOS-533
        vc.urlString = appDelegate.termsAndCondition
        vc.ScreenTitle = "TERMS AND CONDITIONS"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.payementSucces=true
        self.navigationController?.popToRootViewController(animated: true)
        self.paymentFailedView.isHidden = true
    }
    @IBAction func TryAgain(_ sender: Any) {
        self.paymentFailedView.isHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.cachedCartItems?.count==0)
        {
            PaymentClicked(self.payButton as Any)
        }
        else
        {
            self.addCashedItemsToCart()
           
        }
    }
    @IBAction func editAdress(_ sender: Any) {
        if UserData.shared.isLoggedIn == true{
            let nextVC = AppController.shared.addAddress
            nextVC.SelectedAdress = self.address
            nextVC.editDelegate = self
            nextVC.isFromBilling = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == self.paymentOptions.count)
        {
            if(self.selectedPayment == self.paymentOptions.count)
            {
                return CGFloat((self.paymentCardsArray.count*60)+70)
            }
            return 70
        }
        else
        {
            let cellData = paymentOptions[indexPath.item]
            if cellData.code ==  "checkoutcom_card_payment" {
                return 313
            }
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if(indexPath.row == self.paymentOptions.count)
        {
            if(self.selectedPayment == self.paymentOptions.count)
            {
                return CGFloat((self.paymentCardsArray.count*60)+70)
            }
            return 70
        }
        
        else
        {
            let cellData = paymentOptions[indexPath.item]
            if cellData.code ==  "checkoutcom_card_payment" {
                if(self.selectedPayment == self.creditCardPosition)
                {
                    if(UserData.shared.isLoggedIn==true)
                    {
                        return 320
                    }
                    return 300
                }
            }
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.paymentCardsArray.count>0)
        {
            
            return paymentOptions.count+1
        }
        return paymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == self.paymentOptions.count)
        {
            if(self.selectedPayment == self.paymentOptions.count){
                //cell.itemImage.image = UIImage(named: "Group 1525")
                guard let cardCell = tableView.dequeueReusableCell(withIdentifier: "StoredCardListingCell", for: indexPath) as? StoredCardListingCell else { return UITableViewCell() }
                cardCell.paymentCardsArray = self.paymentCardsArray
                cardCell.tblCards.reloadData()
                cardCell.selectionStyle = .none
                return cardCell
            }
            else
            {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionsTVC_id", for: indexPath) as? PaymentOptionsTVC else { return UITableViewCell() }
                cell.titleLbl.text = "Stored Cards"
                cell.radio.image = UIImage(named: indexPath.item == selectedPayment ? AppAssets.radioButtonSelected_icon.rawValue : AppAssets.radioButton_icon.rawValue)
                
                cell.itemImage.image = UIImage(named: "Group 2969")
                return cell
            }
        }
        else
        {
            let cellData = paymentOptions[indexPath.item]
            
            if (cellData.code == "checkoutcom_card_payment") && (self.selectedPayment == self.creditCardPosition){
                //cell.itemImage.image = UIImage(named: "Group 1525")
                guard let cardCell = tableView.dequeueReusableCell(withIdentifier: "CreditCardTVC", for: indexPath) as? CreditCardTVC else { return UITableViewCell() }
                self.txtCVV = cardCell.txtCvv
                self.txtCardNumber = cardCell.txtCardNumber
                self.txtCarddate = cardCell.txtDate
                self.txtCardName = cardCell.txtName
                self.txtCarddate?.delegate = self
                self.txtCVV?.delegate = self
                self.txtCardNumber?.addTarget(self, action: #selector(editingCardField), for: .editingChanged)
                self.txtCarddate?.addTarget(self, action: #selector(editingDateField), for: .editingChanged)
                
                if(UserData.shared.isLoggedIn==true)
                {
                    cardCell.saveFutureView.isHidden = false
                }
                else
                {
                    cardCell.saveFutureView.isHidden = true
                }
                //self.txtCardName?.delegate = self
                self.txtCardNumber?.delegate = self
                creditCardPosition = indexPath.item
                if (self.isToSaveCard == true)
                {
                    cardCell.setSelectionStyle(isSelected: true)
                }
                else
                {
                    cardCell.setSelectionStyle(isSelected: false)
                }
                cardCell.btnScan.addTarget(self, action: #selector(self.cardScan(_:)), for: .touchUpInside)
                cardCell.btnSelect.addTarget(self, action: #selector(self.SeveCard(_:)), for: .touchUpInside)
                return cardCell
            }
            else
            {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionsTVC_id", for: indexPath) as? PaymentOptionsTVC else { return UITableViewCell() }
                cell.titleLbl.text = cellData.title
                cell.radio.image = UIImage(named: indexPath.item == selectedPayment ? AppAssets.radioButtonSelected_icon.rawValue : AppAssets.radioButton_icon.rawValue)
                if cellData.code == "checkoutcom_apple_pay"{
                    cell.itemImage.image = UIImage(named: "apple_pay_icon")
                    
                }else if cellData.code == "free"{
                    cell.itemImage.image = UIImage(named: "Mask Group 134")
                }
                else if cellData.code == "checkoutcom_card_payment"
                {
                    cell.itemImage.image = UIImage(named: "Group 2967")
                    
                }
                else if  cellData.code == "postpay"
                {
                    cell.itemImage.image = UIImage(named: "Mask Group 134")
                }else{
                    cell.itemImage.image = UIImage(named: "Image 119")
                }
                
                return cell
            }
        }
    }
    func getSavedCards(){
        self.apiGetPaymentCards(){ response in
            DispatchQueue.main.async {
                print(response)
                self.paymentCardsArray = response
                if(self.paymentCardsArray.count>0)
                {
                    let count = self.paymentOptions.count+1
                    self.listingTableHeight.constant = CGFloat(count*70)
                }
                DispatchQueue.main.async {
                    self.listingTable.reloadData()
                }
                
            }
        }
    }
    
    @IBAction func PaymentClicked(_ sender: Any) {
        //MARK: START MHIOS-1225
        //MARK START{MHIOS-991}
        if self.paymentOptions.count != 0
        {
    
        //MARK: START MHIOS-1299
        if selectedPayment < self.paymentOptions.count && selectedPayment != -1
        {
        //MARK: END MHIOS-1299

            CrashManager.shared.log("AdjustAnalytics_PaymentDetails:\(self.paymentOptions[selectedPayment].code),grandTotal:\(self.cartTotal?.baseGrandTotal ?? 0.0)")
        }
        else
        {
            CrashManager.shared.log("AdjustAnalytics_PaymentDetails: Stored Card,grandTotal:\(self.cartTotal?.baseGrandTotal ?? 0.0)")
        }
        //MARK: START MHIOS-1225
        Analytics.logEvent("add_payment_info", parameters: [
            AnalyticsParameterItemID: "add_payment_info",
            AnalyticsParameterItemName: "add_payment_info",
            AnalyticsParameterCurrency: "AED",
            AnalyticsParameterValue: self.cartTotal?.baseGrandTotal
        ])
        // Mark MHIOS-1169
        //MARK: START MHIOS-1064
        SmartManager.shared.trackEvent(event: "add_payment_info", properties: ["revenue": "\(self.cartTotal?.baseGrandTotal ?? 0.0)"])
        //MARK: END MHIOS-1064
        if self.paymentOptions.indices.contains(selectedPayment)
        {
            AdjustAnalytics.shared.createEvent(type: .PaymentDetails)
            AdjustAnalytics.shared.createParam(key: KeyConstants.paymentType, value: self.paymentOptions[selectedPayment].code)
            AdjustAnalytics.shared.track()
        }
        // Mark MHIOS-1169
        // self.makeApplepayment()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        //lf.checkOutPayment()
        if(selectedPayment == self.paymentOptions.count)
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if(appDelegate.selectdCard  == -1)
            {

                //MARK: START MHIOS-1285
                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please select a card.","Screen" : self.className])
                //MARK: END MHIOS-1285
                self.toastView(toastMessage: "Please select a card.",type: "error")
            }
                else
                {
                    if UserData.shared.isLoggedIn{
                        
                        
                        //MARK: START MHIOS-1199

                        let parameters:[String: Any] = ["paymentMethod":[
                            "extension_attributes":[
                                "app_version": UserData.shared.appVersion,
                                "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],
                            "method": "checkoutcom_card_payment"],
                                                        "shippingMethod": ["method_code":self.shipping_method_code,
                                                                           "carrier_code": self.shipping_carrier_code,
                                                                           "additionalProperties": [],
                                                                           "region_id":self.address?.region?.region_id ?? 0 ]]
                        //MARK: START MHIOS-1199
                        appDelegate.payementSucces=false
                        self.apiOrderPlace(parameters: parameters){ response in
                            
                            self.hideActivityIndicator(uiView: self.view)
                            let userDefaults = UserDefaults.standard
                            userDefaults.removeObject(forKey: "GuestCart")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.guestCartId = ""
                            //MARK start MHIOS-1151
                            if response.count > 1{
                                self.orderID = response[0] as String
                                self.incrementID = response[1] as String
                            }else{
                                self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                            }
                            //MARK end MHIOS-1151
                            self.makeStoredPayment(amount: self.cartTotal?.baseGrandTotal ?? 0.0)
                            
                        }
                    }
                    else
                    {
                        //MARK: START MHIOS-1199

                        let parameters:[String: Any] = ["paymentMethod":
                                                            ["extension_attributes":[
                                                                "app_version": UserData.shared.appVersion,
                                                                "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],
                                                             "method": self.paymentOptions[selectedPayment].code],
                                                        "shippingMethod": [
                                                            "method_code": self.methodCode,
                                                            "carrier_code": self.carrierCode,
                                                            "additionalProperties": [],
                                                            "region_id":self.parameterAdress["region_id"] ]]
                        //MARK: END MHIOS-1199
                        
                        appDelegate.payementSucces=false
                        self.apiGuestOrderPlace(parameters: parameters){ response in
                            
                            self.hideActivityIndicator(uiView: self.view)
                            //MARK start MHIOS-1151
                            if response.count > 1{
                                self.orderID = response[0] as String
                                self.incrementID = response[1] as String
                            }else{
                                self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                            }
                            //MARK end MHIOS-1151
                            self.makePayment(token: "", amount: self.cartTotal?.baseGrandTotal ?? 0.0)
                        }
                    }
                }
            }
            else if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
            {
                let paymentNetworks = [PKPaymentNetwork.amex, .maestro, .masterCard, .visa]
                
                
                
                if PKPaymentAuthorizationViewController.canMakePayments() {
                    
                    
                    
                    if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                        
                        
                        
                        if UserData.shared.isLoggedIn{
                            //MARK: START MHIOS-1199
                            let parameters:[String: Any] = ["paymentMethod":
                                                                ["extension_attributes":[
                                                                    "app_version": UserData.shared.appVersion,
                                                                    "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],
                                                                 "method": self.paymentOptions[self.selectedPayment].code],
                                                            "shippingMethod": [
                                                                "method_code": self.shipping_method_code,
                                                                "carrier_code": self.shipping_carrier_code,
                                                                "additionalProperties": [],
                                                                "region_id":self.address?.region?.region_id ?? 0 ]]
                            //MARK: END MHIOS-1199
                            appDelegate.payementSucces=false
                            self.apiOrderPlace(parameters: parameters){ response in
                                
                                self.hideActivityIndicator(uiView: self.view)
                                let userDefaults = UserDefaults.standard
                                userDefaults.removeObject(forKey: "GuestCart")
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.guestCartId = ""
                                //MARK start MHIOS-1151
                                if response.count > 1{
                                    self.orderID = response[0] as String
                                    self.incrementID = response[1] as String
                                }else{
                                    self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                                }
                                //MARK end MHIOS-1151
                                if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
                                {
                                    //applepay
                                    self.makeApplepayment()
                                }
                                
                                else if(self.paymentOptions[self.selectedPayment].code == "postpay")
                                {
                                    
                                    self.postpayAPi()
                                    
                                }
                                else
                                {
                                    //self.payThroughTabby()
                                    self.IntateTabbyPayment()
                                }
                                //checkout.com
                                //  self.checkOutPayment()
                                
                                //applepay
                                //self.makeApplepayment()
                                //tabby
                                //self.payThroughTabby()
                                
                                // let nextVC = AppController.shared.orderSuccess
                                
                                
                                //self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                        else
                        {
                            //MARK: START MHIOS-1199

                            let parameters:[String: Any] = ["paymentMethod":
                                                                ["extension_attributes":[
                                                                    "app_version": UserData.shared.appVersion,
                                                                    "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],"method": self.paymentOptions[selectedPayment].code],
                                                            "shippingMethod": ["method_code": self.methodCode,"carrier_code": self.carrierCode,"additionalProperties": [],"region_id":self.parameterAdress["region_id"] ]]
                            //MARK: END MHIOS-1199

                            appDelegate.payementSucces = false
                            self.apiGuestOrderPlace(parameters: parameters){ response in
                                //MARK start MHIOS-1151
                                if response.count > 1{
                                    self.orderID = response[0] as String
                                    self.incrementID = response[1] as String
                                }else{
                                    self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                                }
                                //MARK end MHIOS-1151
                                self.hideActivityIndicator(uiView: self.view)
                                
                                if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
                                {
                                    //applepay
                                    self.makeApplepayment()
                                }
                                
                                else if(self.paymentOptions[self.selectedPayment].code == "postpay")
                                {
                                    
                                    self.postpayAPiGuest()
                                    
                                }
                                else if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_card_payment")
                                {
                                    
                                    self.checkOutPayment()
                                    
                                }
                                else
                                {

                                    // self.payThroughTabby()
                                    self.IntateTabbyPayment()
                                }
                                //checkout.com
                                //  self.checkOutPayment()
                                
                                //applepay
                                //self.makeApplepayment()
                                //tabby
                                //self.payThroughTabby()
                                
                                // let nextVC = AppController.shared.orderSuccess
                                
                                
                                //self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                        
                        
                        
                    } else {
                        
                        
                        
                        let alert = UIAlertController(title: "Add Card to Apple Pay", message: "Add a card that is accepted by Marina Home", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        
                        alert.addAction(cancelAction)
                        
                        let okAction = UIAlertAction(title: "Add Card", style: .default, handler: { (action) in
                            
                            
                            
                            //Open Wallet app
                            
                            let library = PKPassLibrary()
                            
                            library.openPaymentSetup()
                            
                        })
                        
                        alert.addAction(okAction)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                    }
                    
                }
                
                else {
                    
                    let alert = UIAlertController(title: "", message: "Apple pay is not enabled for this device", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }

            else if(self.selectedPayment == -1)
            {
                //MARK: START MHIOS-1285
                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please select a payment option.","Screen" : self.className])
                //MARK: END MHIOS-1285
                self.toastView(toastMessage: "Please select a payment option.",type: "error")
            }
            
            else
            {
                //self.makeApplepayment()
                
                /* if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
                 {
                 //applepay
                 self.makeApplepayment()
                 }
                 else if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_card_payment")
                 {
                 
                 self.checkOutPayment()
                 
                 }
                 else
                 {
                 self.payThroughTabby()
                 }*/
                
                if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_card_payment")
                {
                    
                    if self.txtCardName?.text == ""{
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your  card name","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Please enter your  card name",type: "error")
                    }else if (self.txtCardNumber!.text?.count ?? 0) != 18 && (self.checkCardType()=="amex") {
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid card number","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Please enter a valid card number",type: "error")
                    }
                    else if (self.txtCardNumber!.text?.count ?? 0) != 19 && !(self.checkCardType()=="amex") {
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid card number","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Please enter a valid card number",type: "error")
                    }else if self.txtCarddate?.text == ""{
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter the expiry date","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Please enter the expiry date",type: "error")
                    }
                    else if(self.checkCardType()=="amex") && (self.txtCVV?.text?.count ?? 0) != 4
                    {
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the CVV number provided","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Please verify the CVV number provided",type: "error")
                        
                    }
                    else if((self.txtCVV?.text?.count ?? 0) != 3 && !(self.checkCardType()=="amex"))
                    {
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please verify the CVV number provided","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Please verify the CVV number provided",type: "error")
                        
                    }
                    else
                    {
                        
                        if UserData.shared.isLoggedIn{
                            if(self.isToSaveCard==true)
                            {
                                let expiry = (self.txtCarddate?.text ?? "").components(separatedBy: "/")
                                let expiryMonth = (expiry.first ?? "").starts(with: "0") ? String((expiry.first ?? "").dropFirst()) : (expiry.first ?? "")
                                let expiryYear = "20\(expiry.last ?? "")"
                                let expiryDate = makeDate(year: Int(expiryYear) ?? 0, month: Int(expiryMonth) ?? 0, day: 28, hr: 24, min: 59, sec: 59)
                                let cardtype = self.checkCardType()
                                let params = ["type": (cardtype ?? "").lowercased(),
                                              "number": (self.txtCardNumber?.text ?? "").replacingOccurrences(of: " ", with: ""),
                                              "expiry_month": Int(expiryMonth) ?? 0,
                                              "expiry_year": Int(expiryYear) ?? 0,
                                              "cvv": self.txtCVV?.text ?? ""] as [String : Any]
                                self.apiAddPaymentCardDetails(parameters: params){ response in
                                    
                                }
                            }
                            //MARK: START MHIOS-1199
                            let parameters:[String: Any] = ["paymentMethod":
                                                                [
                                                                    "extension_attributes":[
                                                                        "app_version": UserData.shared.appVersion,
                                                                        "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],
                                                                    "method": self.paymentOptions[self.selectedPayment].code],
                                                            "shippingMethod": [
                                                                "method_code": self.shipping_method_code,
                                                                "carrier_code": self.shipping_carrier_code,
                                                                "additionalProperties": [],
                                                                "region_id":self.address?.region?.region_id ?? 0 ]]

                            //MARK: END MHIOS-1199
                            appDelegate.payementSucces=false
                            self.apiOrderPlace(parameters: parameters){ response in
                                
                                self.hideActivityIndicator(uiView: self.view)
                                let userDefaults = UserDefaults.standard
                                userDefaults.removeObject(forKey: "GuestCart")
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.guestCartId = ""
                                //MARK start MHIOS-1151
                                if response.count > 1{
                                    self.orderID = response[0] as String
                                    self.incrementID = response[1] as String
                                }else{
                                    self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                                }
                                //MARK end MHIOS-1151
                                if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
                                {
                                    //applepay
                                    self.makeApplepayment()
                                }
                                
                                else if(self.paymentOptions[self.selectedPayment].code == "postpay")
                                {
                                    
                                    self.postpayAPi()
                                    
                                }
                                else if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_card_payment")
                                {
                                    self.makePayment(token: "", amount: self.cartTotal?.baseGrandTotal ?? 0.0)
                                }
                                else
                                {
                                    self.IntateTabbyPayment()
                                }
                                //checkout.com
                                //  self.checkOutPayment()
                                
                                //applepay
                                //self.makeApplepayment()
                                //tabby
                                //self.payThroughTabby()
                                
                                // let nextVC = AppController.shared.orderSuccess
                                
                                
                                //self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                        else
                        {
                            //MARK: START MHIOS-1199
                            let parameters:[String: Any] = ["paymentMethod":
                                                                ["extension_attributes":[
                                                                    "app_version": UserData.shared.appVersion,
                                                                    "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],"method": self.paymentOptions[selectedPayment].code],
                                                            "shippingMethod": ["method_code": self.methodCode,"carrier_code": self.carrierCode,"additionalProperties": [],"region_id":self.parameterAdress["region_id"] ]]
                            //MARK: END MHIOS-1199

                            appDelegate.payementSucces=false
                            self.apiGuestOrderPlace(parameters: parameters){ response in
                                
                                self.hideActivityIndicator(uiView: self.view)
                                //MARK start MHIOS-1151
                                if response.count > 1{
                                    self.orderID = response[0] as String
                                    self.incrementID = response[1] as String
                                }else{
                                    self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                                }
                                //MARK end MHIOS-1151
                                if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
                                {
                                    //applepay
                                    self.makeApplepayment()
                                }
                                else if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_card_payment")
                                {
                                    
                                    self.makePayment(token: "", amount: self.cartTotal?.baseGrandTotal ?? 0.0)
                                    
                                }
                                else if(self.paymentOptions[self.selectedPayment].code == "postpay")
                                {
                                    
                                    self.postpayAPiGuest()
                                    
                                }
                                else
                                {
                                    //self.payThroughTabby()
                                    self.IntateTabbyPayment()
                                }
                                //checkout.com
                                //  self.checkOutPayment()
                                
                                //applepay
                                //self.makeApplepayment()
                                //tabby
                                //self.payThroughTabby()
                                
                                // let nextVC = AppController.shared.orderSuccess
                                
                                
                                //self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                        //self.makePayment(token: "", amount: self.cartTotal?.baseGrandTotal ?? 0.0)
                    }
                    
                }
                else
                {
                    if UserData.shared.isLoggedIn{
                        //MARK: START MHIOS-1199
                        let parameters:[String: Any] = ["paymentMethod":
                                                            ["extension_attributes":[
                                                                "app_version": UserData.shared.appVersion,
                                                                "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],
                                                             "method": self.paymentOptions[self.selectedPayment].code],
                                                        "shippingMethod": ["method_code": self.shipping_method_code,"carrier_code": self.shipping_carrier_code,"additionalProperties": [],"region_id":self.address?.region?.region_id ?? 0 ]]
                        //MARK: END MHIOS-1199
                        appDelegate.payementSucces=false
                        self.apiOrderPlace(parameters: parameters){ response in
                            
                            self.hideActivityIndicator(uiView: self.view)
                            let userDefaults = UserDefaults.standard
                            userDefaults.removeObject(forKey: "GuestCart")
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.guestCartId = ""
                            //MARK start MHIOS-1151
                            if response.count > 1{
                                self.orderID = response[0] as String
                                self.incrementID = response[1] as String
                            }else{
                                self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                            }
                            //MARK end MHIOS-1151
                            if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
                            {
                                //applepay
                                self.makeApplepayment()
                            }
                            
                            else if(self.paymentOptions[self.selectedPayment].code == "postpay")
                            {
                                
                                self.postpayAPi()
                                
                            }
                            else
                            {
                                //self.payThroughTabby()
                                self.IntateTabbyPayment()
                            }
                            //checkout.com
                            //  self.checkOutPayment()
                            
                            //applepay
                            //self.makeApplepayment()
                            //tabby
                            //self.payThroughTabby()
                            
                            // let nextVC = AppController.shared.orderSuccess
                            
                            
                            //self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }
                    else
                    {
                        //MARK: START MHIOS-1199
                        
                        let parameters:[String: Any] = ["paymentMethod":
                                                            ["extension_attributes":[
                                                                "app_version": UserData.shared.appVersion,
                                                                "iphone_model_type": "\(UIDevice.modelName) /\(UIDevice.current.systemVersion)"],
                                                             "method": self.paymentOptions[selectedPayment].code],

                                                        "shippingMethod": ["method_code": self.methodCode,
                                                                           "carrier_code": self.carrierCode,
                                                                           "additionalProperties": [],
                                                                           "region_id":self.parameterAdress["region_id"] ]]
                        //MARK: END MHIOS-1199
                        
                        appDelegate.payementSucces=false
                        self.apiGuestOrderPlace(parameters: parameters){ response in
                            //MARK start MHIOS-1151
                            if response.count > 1{
                                self.orderID = response[0] as String
                                self.incrementID = response[1] as String
                            }else{
                                self.apiLogError(message: "order place response error - missing orderId and incrementId - parameters : \(parameters)")
                            }
                            //MARK end MHIOS-1151
                            self.hideActivityIndicator(uiView: self.view)
                            
                            if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_apple_pay")
                            {
                                //applepay
                                self.makeApplepayment()
                            }
                            
                            else if(self.paymentOptions[self.selectedPayment].code == "postpay")
                            {
                                
                                self.postpayAPiGuest()
                                
                            }
                            else if(self.paymentOptions[self.selectedPayment].code == "checkoutcom_card_payment")
                            {
                                
                                self.checkOutPayment()
                                
                            }
                            else
                            {
                                // self.payThroughTabby()
                                self.IntateTabbyPayment()
                            }
                            //checkout.com
                            //  self.checkOutPayment()
                            
                            //applepay
                            //self.makeApplepayment()
                            //tabby
                            //self.payThroughTabby()
                            
                            // let nextVC = AppController.shared.orderSuccess
                            
                            
                            //self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }

                }
                // self.postPay()
            }
            // self.postPay()
        }

        else
        {
            self.payButton.isEnabled = false
        }

        //MARK END{MHIOS-991}
    }
    func checkCardType()->String
    {
        if self.txtCardNumber?.text?.first == "4" {
            return "visa"
        }
        else if self.txtCardNumber?.text?.first == "5"||self.txtCardNumber?.text?.first == "2"{
            return "master"
        }
        else if self.txtCardNumber?.text?.first == "3"{
            return "amex"
        }
        return "visa"
    }
    func payThroughTabby()
    {
        if(self.isTabbyInstallmentsAvailable==true)
        {
            if #available(iOS 13.0, *) {
                let vc = UIHostingController(
                    rootView:TabbyCheckout(productType: self.openedProduct, onResult: { result in
                        print("TABBY RESULT: \(result)!!!")
                        switch result {
                        case .authorized:
                            /*self.apiTabbyPaymentCapture()
                            { response in
                                
                            }*/
                            let parm = [
                                "orderId":self.incrementID,
                                "authoriseTxnId":self.tabbyPaymentID,
                                "capturedTxnId":""
                            ]
                         //   self.apiOrderUpdate(param:parm ){ response in
                                // self.toastView(toastMessage: "Order placed successfully")
                            Analytics.logEvent("purchase", parameters: [
                                AnalyticsParameterCurrency: "AED",AnalyticsParameterTransactionID:self.incrementID,
                                AnalyticsParameterValue: self.cartTotal?.baseGrandTotal ?? 0.0
                            ])
                            // Mark MHIOS-1166
                            //MARK: START MHIOS-1064
                            var properties = [String:Any]()
                            properties["revenue"] = "\(self.cartTotal?.baseGrandTotal ?? 0.0)"
                            properties["currency"] = "AED"
                            properties["TransactionID"] = "\(self.incrementID)"
                            SmartManager.shared.trackEvent(event: "purchase", properties: properties)
                            //MARK: END MHIOS-1064
                            let event1 = ADJEvent(eventToken: AdjustEventType.Sale.rawValue)
                            event1?.setTransactionId(self.incrementID)

                            event1?.setRevenue(self.cartTotal?.baseGrandTotal ?? 0 , currency: "AED")
                            Adjust.trackEvent(event1)
                            // Mark MHIOS-1166
                                
                            //MARK: START MHIOS-1281
                            let seconds = 2.0
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                self.apiCheckFirstSale(){ response in
                                    if response
                                    {
                                        
                                        self.sendFirstSaleEvent()
                                        
                                    }
                                    
                                    self.hideActivityIndicator(uiView: self.view)
                                    let nextVC = AppController.shared.orderSuccess
                                    nextVC.guestName = "\(self.parameterAdress["firstname"] ?? "")"
                                    nextVC.selectedTimeSlot = self.selectedTimeSlot
                                    nextVC.orderId = self.orderID
                                    nextVC.incrementId = self.incrementID
                                    nextVC.trasactionParam = parm
                                    //nextVC.paymentType = "isTabby"
                                    nextVC.DeliveryDate = self.selectedTimeSlot
                                    nextVC.isFromtabby = true
                                    nextVC.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(nextVC, animated: true)
                                }
                            }
                            //MARK: END MHIOS-1281
                                
                            //}
                            //self.navigationController?.popToRootViewController(animated: true)
                            // Do something else when Tabby authorized customer
                            // probably navigation back to Home screen, refetching, etc.
                            
                            break
                        case .rejected:
                            self.showAlert(message: "Sorry, Tabby is unable to approve this purchase. Please use an alternative payment method for your order",rightactionTitle: "Ok", rightAction: {
                                if self.children.count > 0{
                                    let viewControllers:[UIViewController] = self.children
                                    for viewContoller in viewControllers{
                                        viewContoller.willMove(toParent: nil)
                                        viewContoller.view.removeFromSuperview()
                                        viewContoller.removeFromParent()
                                    }
                                }
                                self.paymentFailedView.isHidden = false
                            }, leftAction: {})
                            
                            break
                        case .close:
                            self.showAlert(message: "You aborted the payment. Please retry or choose another payment method.",rightactionTitle: "Ok", rightAction: {
                                if self.children.count > 0{
                                    let viewControllers:[UIViewController] = self.children
                                    for viewContoller in viewControllers{
                                        viewContoller.willMove(toParent: nil)
                                        viewContoller.view.removeFromSuperview()
                                        viewContoller.removeFromParent()
                                    }
                                }
                                self.paymentFailedView.isHidden = false
                            }, leftAction: {})
                            
                            // self.navigationController?.popToRootViewController(animated: true)
                            // Do something else when customer closed Tabby checkout
                            
                            break
                        case .expired:
                            self.showAlert(message: "Sorry, Tabby session is expired to approve this purchase. Please use an alternative payment method for your order",rightactionTitle: "Ok", rightAction: {
                                if self.children.count > 0{
                                    let viewControllers:[UIViewController] = self.children
                                    for viewContoller in viewControllers{
                                        viewContoller.willMove(toParent: nil)
                                        viewContoller.view.removeFromSuperview()
                                        viewContoller.removeFromParent()
                                    }
                                }
                                self.paymentFailedView.isHidden = false
                            }, leftAction: {})
                            
                            break
                        }
                    })
                )
                self.addChild(vc)
                vc.view.frame = self.view.frame
                self.view.addSubview(vc.view)
                vc.didMove(toParent: self)
            } else {
                // Fallback on earlier versions
            }
        }
        else
        {
            self.showAlert(message: "Sorry, Tabby is unable to approve this purchase. Please use an alternative payment method for your order",rightactionTitle: "Ok", rightAction: {
                if self.children.count > 0{
                    let viewControllers:[UIViewController] = self.children
                    for viewContoller in viewControllers{
                        viewContoller.willMove(toParent: nil)
                        viewContoller.view.removeFromSuperview()
                        viewContoller.removeFromParent()
                    }
                }
                self.paymentFailedView.isHidden = false
            }, leftAction: {})
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPayment = indexPath.item
        
        if(indexPath.row == self.paymentOptions.count)
        {
            let height = (self.paymentCardsArray.count*60)+70
            self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70+height)
            self.payButton.setAttributedTitle(nil, for: .normal)
            self.payButton.setTitle("PAY WITH STORED CARDS", for: .normal)
        }
        else
        {
            let cellData = paymentOptions[indexPath.item]
            if (cellData.code == "checkoutcom_card_payment")
            {
                self.creditCardPosition = indexPath.item
            }
            else
            {
                self.creditCardPosition = -1
            }
            let payementOption = self.paymentOptions[indexPath.item]
            
            let isApplePay = payementOption.title.uppercased() == "APPLE PAY"
            if isApplePay{
                self.payButton.setAttributedTitle(getAppleText(), for: .normal)
            }else{
                if(payementOption.code == "tabby_installments"||payementOption.code == "postpay")
                {
                    self.payButton.setAttributedTitle(nil, for: .normal)
                    self.payButton.setTitle("PAY IN \(payementOption.title.uppercased())", for: .normal)
                }
                else
                {
                    self.payButton.setAttributedTitle(nil, for: .normal)
                    self.payButton.setTitle("PAY WITH \(payementOption.title.uppercased())", for: .normal)
                }
            }
            self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70)
            if(self.selectedPayment == self.creditCardPosition)
            {
                self.listingTableHeight.constant = CGFloat(self.paymentOptions.count*70) + 250
                if(self.paymentCardsArray.count>0)
                {
                    let count = self.paymentOptions.count+1
                    self.listingTableHeight.constant = CGFloat(count*70) + 250
                }
            }
            else
            {
                if(self.paymentCardsArray.count>0)
                {
                    let count = self.paymentOptions.count+1
                    self.listingTableHeight.constant = CGFloat(count*70)
                }
            }
        }
        listingTable.reloadData()
    }
    func IntateTabbyPayment()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var email:String = ""
        var telephone:String = ""
        var createdAt:String = ""
        var fname:String = ""
        var lname:String = ""
        if(UserData.shared.isLoggedIn)
        {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFromStr = dateFormatter.date(from: UserData.shared.created_at ) ?? Date()
            print("\(UserData.shared.created_at)")
            dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
            let dates = dateFormatter.string(from: dateFromStr)
            createdAt = "\(dates)T12:10:12Z"
            email = UserData.shared.emailId
            telephone = self.address?.telephone ?? ""
            fname =  UserData.shared.firstName
            lname = UserData.shared.lastName
            
        }
        else
        {
            let dateFormatter = DateFormatter()
            
           
           
            dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
            let dates = dateFormatter.string(from: Date())
            createdAt = "\(dates)T11:10:12Z"
          
            telephone = self.parameterAdress["telephone"] as! String
            email =  self.parameterAdress["email"] as! String
            fname =   self.parameterAdress["firstname"] as! String
            lname =  self.parameterAdress["lastname"] as! String
        }
        var cartitems:[OrderItem] = []
        for i in appDelegate.cachedCartItems!
        {
            let itemcart =     OrderItem(
                description: nil,
                product_url: nil,
                quantity: i.qty ?? 0,
                reference_id: "\(i.sku ?? "" )",
                title: i.name ?? "",
                unit_price: String(format: "%.2f", i.price ?? 0),
                category: "Furniture"
            )
            cartitems.append(itemcart)
        }
        let customerPayment = Payment(
            amount:String(format: "%.2f", self.cartTotal?.baseGrandTotal ?? 0),
            currency: .AED,
            description: "Marina Home",
            buyer: Buyer(
                email:email,
                phone: telephone,
                name: fname + " " + lname,
                dob: nil
            ),
            buyer_history: BuyerHistory(registered_since:createdAt , loyalty_level: 0),
            order: Order(
                reference_id:self.incrementID,
                items: cartitems,
                shipping_amount:String(format: "%.2f", self.cartTotal?.shippingAmount ?? 0) ,
                tax_amount:String(format: "%.2f", self.cartTotal?.taxAmount ?? 0)
            ),
            order_history: [],
            shipping_address: ShippingAddress(
                address: self.address?.street?.joined(separator: ", ") ?? "",
                city: self.address?.city ?? "",
                zip: self.address?.postcode ?? ""
            )
        )
        
        let myTestPayment = TabbyCheckoutPayload(merchant_code: "MHAPP", lang: .en, payment: customerPayment)
        self.showActivityIndicator(uiView: self.view)
        TabbySDK.shared.configure(forPayment: myTestPayment) { result in
            switch result {
            case .success(let s):
              
                // 1. Do something with sessionId (this step is optional)
                print("sessionId: \(s.sessionId)")
                // 2. Do something with paymentId (this step is optional)
                print("paymentId: \(s.paymentId)")
                self.tabbyPaymentID = s.paymentId
                // 3. Grab avaibable products from session and enable proper
                // payment method buttons in your UI (this step is required)
                // Feel free to ignore products you don't need or don't want to handle in your App
                print("tabby available products: \(s.tabbyProductTypes)")
                // If you want to handle installments product - check for .installments in response
                if (s.tabbyProductTypes.contains(.installments)) {
                    self.isTabbyInstallmentsAvailable = true
                    
                    
                    
                }
                self.hideActivityIndicator(uiView: self.view)
                self.payThroughTabby()
            case .failure(let error):
                self.hideActivityIndicator(uiView: self.view)
                // Do something when Tabby checkout session POST requiest failed
                print(error)
            }
        }
        
        
        
    }
    func checkOutPayment()
    {
        let country = Country( iso3166Alpha2: "AE")
        
        let addressIs = Address(
            addressLine1: self.address?.firstname ?? "",
            addressLine2: self.address?.lastname ?? "",
            //MARK start MHIOS-1151
            city: self.address?.city, state: (self.address?.street?.count ?? 0 > 0 ? self.address?.street?[0] ?? "" : ""),
            //MARK end MHIOS-1151
            zip: self.address?.postcode ?? "",
            country: country)
        
        let phone = Phone(number: "+44 1234567890",
                          country: country)
        
        // Creates a new BillingForm and populates it with the customer data defined above
        let billingFormData = BillingForm(
            name: self.address?.firstname ?? "" + " " + (self.address?.lastname ?? "") ,
            address: addressIs,
            phone: phone)
        
        /* Configures the payment environment. Providing billingFormData is optional,
         but doing so can simplify your customer's checkout experience and improves the
         chances of successful tokenization */
        
        let configuration = PaymentFormConfiguration(
            apiKey: AppInfo.shared.checkoutComApiToken,
            environment: .live,
            supportedSchemes: [.visa, .maestro, .mastercard],
            billingFormData: billingFormData)
        
        // Configures tokenization success and failure states
        let completion: ((Result<TokenDetails, TokenRequestError>) -> Void) = { result in
            switch result {
            case .failure(let failure):
                // self.addCashedItemsToCart()
                self.paymentFailedView.isHidden = false
                if failure == .userCancelled {
                    /* Depending on needs, User Cancelled can be handled as an individual
                     failure to complete, an error, or simply a callback that control is returned */
                    print("User has cancelled")
                } else {
                    print("Failed, received error", failure.localizedDescription)
                }
            case .success(let tokenDetails):
                
                print("Success, received token", tokenDetails.token)
                let tot = Double(String(format: "%.2f", Double(self.cartTotal?.baseGrandTotal ?? 0)*100)) ?? 0.00
                self.makePayment(token:tokenDetails.token,amount:tot)
            }
        }
        
        // Displays the forms to the user to collect payment information
        let framesViewController = PaymentFormFactory.buildViewController(
            configuration: configuration,
            style: PaymentStyle(
                paymentFormStyle: DefaultPaymentFormStyle(),
                billingFormStyle: DefaultBillingFormStyle()),
            completionHandler: completion
        )
        self.navigationController?.pushViewController(framesViewController, animated: true)
    }
    func makePayment(token:String,amount:Double)
    {
        let tot = Double(String(format: "%.2f", Double(self.cartTotal?.baseGrandTotal ?? 0)*100)) ?? 0.00
        let expiry = (self.txtCarddate!.text ?? "").components(separatedBy: "/")
        let expiryMonth = (expiry.first ?? "").starts(with: "0") ? String((expiry.first ?? "").dropFirst()) : (expiry.first ?? "")
        let expiryYear = "20\(expiry.last ?? "")"
        //MARK: START MHIOS-1192
        var phone_Number = ""
        if UserData.shared.isLoggedIn
        {
            phone_Number = self.address?.telephone ?? ""
        }
        else
        {
            phone_Number = self.parameterAdress["telephone"] as? String ?? ""
        }
        
        let phone_code = "+971"
        phone_Number = phone_Number.replacingOccurrences(of: phone_code, with: "")

        var addL1 = ""
        var addL2 = ""
        if UserData.shared.isLoggedIn
        {
            if self.address?.street?.count ?? 0 > 0
            {
                addL2 = (self.address?.street?[0] ?? "")
            }
            if self.address?.street?.count ?? 0 > 1
            {
                addL1 = (self.address?.street?[1] ?? "")
            }
        }
        else
        {
            let street : [String] = self.parameterAdress["street"] as! [String]
            if street.count > 0
            {
                addL2 = street[0]
            }
            if street.count > 1
            {
                addL1 = street[1]
            }
        }
        
        var city = ""
        if UserData.shared.isLoggedIn
        {
            city = self.address?.region?.region ?? ""
        }
        else
        {
            city = self.parameterAdress["region"] as! String
        }
        let  billing_address : [String : Any] = [
            "address_line1": addL1,
            "address_line2":  addL2,
            "city": city,
            "state": city,
            "country": UserData.shared.isLoggedIn == true ? (self.address?.country_id ?? "") : (self.parameterAdress["country_id"] ?? ""),
            "zip": UserData.shared.isLoggedIn == true ? (self.address?.postcode ?? "") : ""
            ]
    
        var method_id = ""
        if self.paymentOptions.count == selectedPayment
       {
            method_id = "checkoutcom_card_payment"
       }
       else
       {
           method_id = self.paymentOptions[selectedPayment].code
       }
        var  meta_data : [String : Any] = [
            "methodId": method_id
        ]
        if UserData.shared.isLoggedIn
        {
            meta_data["saveCard"] =  isToSaveCard
            meta_data["customerId"] = UserData.shared.userId
        }
        var param =   [
            "source": [
                "type": "card",
                "number": (Int((self.txtCardNumber!.text ?? "").replacingOccurrences(of: " ", with: "")) ?? 4242424242424242),
                "expiry_month": expiryMonth,
                "expiry_year": expiryYear,
                "stored": true,
                "billing_address" :billing_address,
                    ],
                "success_url":  AppInfo.shared.checkOutPaymentSuccessURL,
                "failure_url": AppInfo.shared.checkOutPaymentFailureURL,
            "payment_ip" : UserData.shared.getIPAddress() ?? "0.0.0.0",
                "3ds": [
                    "enabled": true
                    ],
             "amount": tot,
             "currency": "AED",
             "metadata": meta_data,
             "reference": "\(self.incrementID)","processing_channel_id": AppInfo.shared.applePayProcessingChannelId
        ] as [String : Any]
        let phone : [String : Any]  =  [
            "country_code": phone_code,
            "number": phone_Number
        ]
        let shipping_address : [String : Any] = [
            "address": [
            "address_line1": addL1,
            "address_line2":  addL2,
            "city": city,
            "state": city ,
            "country": UserData.shared.isLoggedIn == true ? (self.address?.country_id ?? "") : (self.parameterAdress["country_id"] ?? ""),
            "zip": UserData.shared.isLoggedIn == true ? (self.address?.postcode ?? "") : ""
            ],
            "phone": phone
            ]
        param["shipping"] = shipping_address
         let userEmail = UserData.shared.isLoggedIn == true ? UserData.shared.emailId : self.parameterAdress["email"]
        let userID = UserData.shared.isLoggedIn == true ? UserData.shared.userId : "guest_user"
        var user_Name = ""
        
        if (UserData.shared.isLoggedIn)
        {
            user_Name = (self.address?.firstname ?? "") + (self.address?.lastname ?? "")
        }
        else
        {
            user_Name = (self.parameterAdress["firstname"] as? String ?? "") + " " + (self.parameterAdress["lastname"] as? String ?? "")
        }
        param["customer"] = [
            "email": userEmail,
            "id": userID,
            "name": user_Name,
            "phone": phone
            ]
        //MARK: END MHIOS-1192
        self.apiCheckoutPaymentRequest(param: param){ responseData in
            DispatchQueue.main.async {
                print(responseData)
                
                self.postPaymentID = responseData.id ?? ""
                // self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async() {
                    if(responseData.links?.redirect?.href ?? "" == "")
                    {
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Invalid card. please enter a valid card","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Invalid card. please enter a valid card",type: "error")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if(appDelegate.payementSucces==false)
                        {
                            self.paymentFailedView.isHidden = false
                        }
                        else
                        {
                            self.paymentFailedView.isHidden = true
                        }
                        
                    }
                    else
                    {
                        let threeDSWebViewController = ThreedsWebViewController(environment: .live, successUrl:URL(string: AppInfo.shared.checkOutPaymentSuccessURL)! ,
                                                                                failUrl:URL(string:AppInfo.shared.checkOutPaymentFailureURL)!)
                        threeDSWebViewController.modalPresentationStyle = .fullScreen
                        threeDSWebViewController.delegate = self
                        threeDSWebViewController.authURL = URL(string: responseData.links?.redirect?.href ?? "")
                        self.navigationController?.pushViewController(threeDSWebViewController, animated: true)
                    }
                }
            }
            
        }
        
    }
    func makeApplePayPayment(token:String,amount:Double)
    {
        let tot = Double(String(format: "%.2f", Double(self.cartTotal?.baseGrandTotal ?? 0)*100)) ?? 0.00
        //MARK: START MHIOS-1192
        var phone_Number = ""
        if UserData.shared.isLoggedIn
        {
            phone_Number = self.address?.telephone ?? ""
        }
        else
        {
            phone_Number = self.parameterAdress["telephone"] as? String ?? ""
        }
        
        let phone_code = "+971"
        phone_Number = phone_Number.replacingOccurrences(of: phone_code, with: "")
        var addL1 = ""
        var addL2 = ""
        if UserData.shared.isLoggedIn
        {
            if self.address?.street?.count ?? 0 > 0
            {
                addL2 = (self.address?.street?[0] ?? "")
            }
            if self.address?.street?.count ?? 0 > 1
            {
                addL1 = (self.address?.street?[1] ?? "")
            }
        }
        else
        {
            let street : [String] = self.parameterAdress["street"] as! [String]
            if street.count > 0
            {
                addL2 = street[0]
            }
            if street.count > 1
            {
                addL1 = street[1]
            }
        }
        
        var city = ""
        if UserData.shared.isLoggedIn
        {
            city = self.address?.region?.region ?? ""
        }
        else
        {
            city = self.parameterAdress["region"] as! String
        }
        var method_id = ""
        if self.paymentOptions.count == selectedPayment
       {
            method_id = "checkoutcom_card_payment"
       }
       else
       {
           method_id = self.paymentOptions[selectedPayment].code
       }
        var  meta_data : [String : Any] = [
            "methodId": method_id
        ]
        if UserData.shared.isLoggedIn
        {
            meta_data["saveCard"] =  isToSaveCard
            meta_data["customerId"] = UserData.shared.userId
        }
        let  billing_address : [String : Any] = [
            "address_line1": addL1,
            "address_line2":  addL2,
            "city": city,
            "state": city,
            "country": UserData.shared.isLoggedIn == true ? (self.address?.country_id ?? "") : (self.parameterAdress["country_id"] ?? ""),
            "zip": UserData.shared.isLoggedIn == true ? (self.address?.postcode ?? "") : ""
            ]
        
        var param =     ["source": [
            "type": "token",
            "token":token,
            "billing_address" :billing_address,
            ],
                         "success_url":  AppInfo.shared.checkOutPaymentSuccessURL,
                         "failure_url": AppInfo.shared.checkOutPaymentFailureURL,
                         "payment_ip" : UserData.shared.getIPAddress() ?? "0.0.0.0",
                         "3ds": [
                            "enabled": true
                         ],
                         "amount": tot,
                         "currency": "AED",
                         "metadata": meta_data,
                         "reference": "\(self.incrementID)","processing_channel_id": AppInfo.shared.applePayProcessingChannelId
        ] as [String : Any]
        let phone : [String : Any]  =  [
            "country_code": phone_code,
            "number": phone_Number
        ]
        let shipping_address : [String : Any] = [
            "address": [
            "address_line1": addL1,
            "address_line2":  addL2,
            "city": city,
            "state": city ,
            "country": UserData.shared.isLoggedIn == true ? (self.address?.country_id ?? "") : (self.parameterAdress["country_id"] ?? ""),
            "zip": UserData.shared.isLoggedIn == true ? (self.address?.postcode ?? "") : ""
            ],
            "phone": phone
            ]
        param["shipping"] = shipping_address
         let userEmail = UserData.shared.isLoggedIn == true ? UserData.shared.emailId : self.parameterAdress["email"]
        let userID = UserData.shared.isLoggedIn == true ? UserData.shared.userId : "guest_user"
        var user_Name = ""
        
        if (UserData.shared.isLoggedIn)
        {
            user_Name = (self.address?.firstname ?? "") + (self.address?.lastname ?? "")
        }
        else
        {
            user_Name = (self.parameterAdress["firstname"] as? String ?? "") + " " + (self.parameterAdress["lastname"] as? String ?? "")
        }
        
        param["customer"] = [
            "email": userEmail,
            "id": userID,
            "name": user_Name,
            "phone": phone
            ]
        //MARK: END MHIOS-1192
        // pc_2psasyittrfuxor7bnlslwveja
        // pc_55s2ku56mhjudhjfvzwsuyc3nq
        self.apiCheckoutPaymentRequest(param: param){ responseData in
            DispatchQueue.main.async {
                print(responseData)
                if(responseData.status?.lowercased() == "declined")
                {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if(appDelegate.payementSucces==false)
                    {
                        self.paymentFailedView.isHidden = false
                    }
                    else
                    {
                        self.paymentFailedView.isHidden = true
                    }
                }
                else
                {
                    self.postPaymentID = responseData.id ?? ""
                    self.apiGetCheckoutPaymentDetails(){ response in
                        print(response)
                        var authTxn = ""
                        var captureTxn = ""
                        for index in 0..<response.count {
                            if response[index].type == "Authorization"{
                                authTxn = response[index].id
                            }
                            
                            if response[index].type == "Capture" {
                                captureTxn = response[index].id
                            }
                        }
                        let parm = [
                            "orderId":self.orderID,
                            "authoriseTxnId":"\(authTxn)",
                            "capturedTxnId":"\(captureTxn)",
                            "payment_id": self.postPaymentID
                        ]
                        self.hideActivityIndicator(uiView: self.view)
                        Analytics.logEvent("purchase", parameters: [
                            AnalyticsParameterCurrency: "AED",AnalyticsParameterTransactionID:self.incrementID,
                            AnalyticsParameterValue: self.cartTotal?.baseGrandTotal ?? 0
                        ])
                        //MARK: START MHIOS-1064
                        var properties = [String:Any]()
                        properties["revenue"] = "\(self.cartTotal?.baseGrandTotal ?? 0)"
                        properties["currency"] = "AED"
                        properties["TransactionID"] = "\(self.incrementID)"
                        SmartManager.shared.trackEvent(event: "purchase", properties: properties)
                        //MARK: END MHIOS-1064
                        // Mark MHIOS-1166
                        let event1 = ADJEvent(eventToken: AdjustEventType.Sale.rawValue)
                        event1?.setTransactionId(self.incrementID)
                        event1?.setRevenue(self.cartTotal?.baseGrandTotal ?? 0 , currency: "AED")
                        Adjust.trackEvent(event1)
                        // Mark MHIOS-1166
                        //MARK: START MHIOS-1281
                        let seconds = 2.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.apiCheckFirstSale(){ response in
                                if response
                                {
                                    
                                    self.sendFirstSaleEvent()
                                    
                                }
                                let nextVC = AppController.shared.orderSuccess
                                nextVC.guestName = "\(self.parameterAdress["firstname"] ?? "")"
                                nextVC.selectedTimeSlot = self.selectedTimeSlot
                                nextVC.orderId = self.orderID
                                nextVC.incrementId = self.incrementID
                                nextVC.DeliveryDate = self.selectedTimeSlot
                                nextVC.trasactionParam = parm
                                //MARK: START MHIOS-1192
                                nextVC.isFromCheckout = true
                                //MARK: END MHIOS-1192
                                // nextVC.paymentType = "other"
                                nextVC.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                        }
                        //MARK: END MHIOS-1281
                        
                    }
                }
                
            }
        }
    }
    func makeStoredPayment(amount:Double)
    {
        let tot = Double(String(format: "%.2f", Double(self.cartTotal?.baseGrandTotal ?? 0)*100)) ?? 0.00
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let card:PaymentCardModel = self.paymentCardsArray[appDelegate.selectdCard]
        //MARK: START MHIOS-1192
        var phone_Number = ""
        if UserData.shared.isLoggedIn
        {
            phone_Number = self.address?.telephone ?? ""
        }
        else
        {
            phone_Number = self.parameterAdress["telephone"] as? String ?? ""
        }
        
        let phone_code = "+971"
        phone_Number = phone_Number.replacingOccurrences(of: phone_code, with: "")

        var addL1 = ""
        var addL2 = ""
        if UserData.shared.isLoggedIn
        {
            if self.address?.street?.count ?? 0 > 0
            {
                addL2 = (self.address?.street?[0] ?? "")
            }
            if self.address?.street?.count ?? 0 > 1
            {
                addL1 = (self.address?.street?[1] ?? "")
            }
        }
        else
        {
            let street : [String] = self.parameterAdress["street"] as! [String]
            if street.count > 0
            {
                addL2 = street[0]
            }
            if street.count > 1
            {
                addL1 = street[1]
            }
        }
        
        var city = ""
        if UserData.shared.isLoggedIn
        {
            city = self.address?.region?.region ?? ""
        }
        else
        {
            city = self.parameterAdress["region"] as! String
        }
        let  billing_address : [String : Any] = [
            "address_line1": addL1,
            "address_line2":  addL2,
            "city": city,
            "state": city,
            "country": UserData.shared.isLoggedIn == true ? (self.address?.country_id ?? "") : (self.parameterAdress["country_id"] ?? ""),
            "zip": UserData.shared.isLoggedIn == true ? (self.address?.postcode ?? "") : ""
            ]
        
        var method_id = ""
        if self.paymentOptions.count == selectedPayment
       {
            method_id = "checkoutcom_card_payment"
       }
       else
       {
           method_id = self.paymentOptions[selectedPayment].code
       }
        var  meta_data : [String : Any] = [
            "methodId": method_id
        ]
        if UserData.shared.isLoggedIn
        {
            meta_data["saveCard"] =  isToSaveCard
            meta_data["customerId"] = UserData.shared.userId
        }
        var param =     ["source": [
            "type": "id",
            "id":card.src_id,
            "billing_address" :billing_address,
        ],
                         "success_url":  AppInfo.shared.checkOutPaymentSuccessURL,
                         "failure_url": AppInfo.shared.checkOutPaymentFailureURL,
                         "payment_ip" : UserData.shared.getIPAddress() ?? "0.0.0.0",
                         "3ds": [
                            "enabled": true
                         ],
                         "amount": tot,
                         "currency": "AED",
                         "metadata": meta_data,
                         "reference": "\(self.incrementID)","processing_channel_id": AppInfo.shared.applePayProcessingChannelId
        ] as [String : Any]
        let phone : [String : Any]  =  [
            "country_code": phone_code,
            "number": phone_Number
        ]
        let shipping_address : [String : Any] = [
            "address": [
            "address_line1": addL1,
            "address_line2":  addL2,
            "city": city,
            "state": city ,
            "country": UserData.shared.isLoggedIn == true ? (self.address?.country_id ?? "") : (self.parameterAdress["country_id"] ?? ""),
            "zip": UserData.shared.isLoggedIn == true ? (self.address?.postcode ?? "") : ""
            ],
            "phone": phone
            ]
        param["shipping"] = shipping_address
         let userEmail = UserData.shared.isLoggedIn == true ? UserData.shared.emailId : self.parameterAdress["email"]
        let userID = UserData.shared.isLoggedIn == true ? UserData.shared.userId : "guest_user"
        var user_Name = ""
        
        if (UserData.shared.isLoggedIn)
        {
            user_Name = (self.address?.firstname ?? "") + (self.address?.lastname ?? "")
        }
        else
        {
            user_Name = (self.parameterAdress["firstname"] as? String ?? "") + " " + (self.parameterAdress["lastname"] as? String ?? "")
        }
        
        param["customer"] = [
            "email": userEmail,
            "id": userID,
            "name": user_Name,
            "phone": phone
            ]
        //MARK: END MHIOS-1192
        self.apiCheckoutPaymentRequest(param: param){ responseData in
            DispatchQueue.main.async {
                print(responseData)
                
                
                self.postPaymentID = responseData.id ?? ""
                // self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async() {
                    let threeDSWebViewController = ThreedsWebViewController(environment: .live, successUrl:URL(string: AppInfo.shared.checkOutPaymentSuccessURL)! ,
                                                                            failUrl:URL(string:AppInfo.shared.checkOutPaymentFailureURL)!)
                    threeDSWebViewController.modalPresentationStyle = .fullScreen
                    threeDSWebViewController.delegate = self
                    threeDSWebViewController.authURL = URL(string: responseData.links?.redirect?.href ?? "")
                    self.navigationController?.pushViewController(threeDSWebViewController, animated: true)
                }
                
                
            }
        }
    }
    @IBAction func FAQ(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        vc.urlString = appDelegate.faqs
        vc.ScreenTitle = "FAQ's"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func TermsAndConditions(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let vc = AppController.shared.web
        vc.urlString = appDelegate.deliverReturns
        vc.ScreenTitle = "DELIVERY & RETURNS"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
        let calendar = Calendar.current
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
        case self.txtCardNumber:
            maxLength = 19
        case self.txtCVV:
            let cardtype = self.checkCardType()
            if(cardtype=="amex")
            {
                maxLength = 4
            }
            else
            {
                maxLength = 3
            }
        case self.txtCarddate:
            maxLength = 5
        default:
            maxLength = 20
        }
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    //MARK start MHIOS-1151
    func apiLogError(message:String){
        self.apiToLogError(parameters: [
            "api_end_point":"rest/V2/print/message",
            "area":"frontend",
            "time": DateToString(),
            "message" : "CheckoutPaymentVC - \(message)"
            ]){
        }
    }

    func DateToString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    //MARK end MHIOS-1151
}
extension CheckoutPaymentVC: ThreedsWebViewControllerDelegate {
    
    func threeDSWebViewControllerAuthenticationDidSucceed(_ threeDSWebViewController: ThreedsWebViewController, token: String?) {
        threeDSWebViewController.dismiss(animated: true)
        self.apiGetCheckoutPaymentDetails(){ response in
            var authTxn = ""
            var captureTxn = ""
            for index in 0..<response.count {
                if response[index].type == "Authorization"{
                    authTxn = response[index].id
                }
                
                if response[index].type == "Capture" {
                    captureTxn = response[index].id
                }
            }
            let parm = [
                "orderId":self.orderID,
                "authoriseTxnId":"\(authTxn)",
                "capturedTxnId":"\(captureTxn)",
                "payment_id": self.postPaymentID
            ]
            Analytics.logEvent("purchase", parameters: [
                AnalyticsParameterCurrency: "AED",AnalyticsParameterTransactionID:self.incrementID,
                AnalyticsParameterValue: self.cartTotal?.baseGrandTotal ?? 0.0
            ])
            //MARK: START MHIOS-1064
            var properties = [String:Any]()
            properties["revenue"] = "\(self.cartTotal?.baseGrandTotal ?? 0)"
            properties["currency"] = "AED"
            properties["TransactionID"] = "\(self.incrementID)"
            SmartManager.shared.trackEvent(event: "purchase", properties: properties)
            //MARK: END MHIOS-1064
            // Mark MHIOS-1166
            let event1 = ADJEvent(eventToken: AdjustEventType.Sale.rawValue)
            event1?.setTransactionId(self.incrementID)
            event1?.setRevenue(self.cartTotal?.baseGrandTotal ?? 0 , currency: "AED")
            Adjust.trackEvent(event1)
            // Mark MHIOS-1166
            //MARK: START MHIOS-1281
            let seconds = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.apiCheckFirstSale(){ response in
                    if response
                    {
                        
                        self.sendFirstSaleEvent()
                        
                    }
                    self.hideActivityIndicator(uiView: self.view)
                    let nextVC = AppController.shared.orderSuccess
                    nextVC.guestName = "\(self.parameterAdress["firstname"] ?? "")"
                    nextVC.selectedTimeSlot = self.selectedTimeSlot
                    nextVC.orderId = self.orderID
                    nextVC.incrementId = self.incrementID
                    nextVC.DeliveryDate = self.selectedTimeSlot
                    nextVC.trasactionParam = parm
                    //MARK: START MHIOS-1192
                    nextVC.isFromCheckout = true
                    //MARK: END MHIOS-1192
                    //nextVC.paymentType = "other"
                    nextVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            //MARK: END MHIOS-1281
            
        }
        
        // Handle successful 3DS.
    }
    
    func threeDSWebViewControllerAuthenticationDidFail(_ threeDSWebViewController: ThreedsWebViewController) {
        //threeDSWebViewController.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
        print("payment 3DS failure")
        //self.addCashedItemsToCart()
        // Handle failed 3DS.
    }
    
}
extension CheckoutPaymentVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        
        controller.dismiss(animated: true)
        
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
       
        
           self.handle(payment: payment)
      
        controller.dismiss(animated: true)
    }
    func handle(payment: PKPayment) {
        // Get the data containing the encrypted payment information.
        let paymentData = payment.token.paymentData
        //MARK: MHIOS-848
        let checkoutAPIService = CheckoutAPIService(publicKey: AppInfo.shared.applePayPublicKey, environment: .sandbox)
        //MARK: MHIOS-848
        // "pk_xnqtfvknghjv57wngg6fobnrdam"
        // Request an Apple Pay token.
        
        checkoutAPIService.createToken(.applePay(ApplePay(tokenData: paymentData))) { result in
            switch result {
            case .success(let tokenDetails):
                print(tokenDetails)
                let tot = Double(self.cartTotal?.baseGrandTotal ?? 0)*100
                self.makeApplePayPayment(token:tokenDetails.token,amount:tot)
                
                // Congratulations, payment token is available
            case .failure(let error):
                print(error)
                //self.displayDefaultAlert(title: "Error", message: "Apple tokenization error.,\(error.localizedDescription)")
                //self.addCashedItemsToCart()
                // Ooooops, an error ocurred. Check `error.localizedDescription` for hint to what went wrong
            }
        }
        
    }
    func makeApplepayment()
    {
        let paymentNetworks = [PKPaymentNetwork.amex, .maestro, .masterCard, .visa]
        
        
        
        if PKPaymentAuthorizationViewController.canMakePayments() {
            
            
            
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                
                
                
                //Create PKPaymentRequest here
                let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
                
                let paymentItem = PKPaymentSummaryItem.init(label: "Marina Home", amount: NSDecimalNumber(value: Double(String(format: "%.2f", Double(self.cartTotal?.baseGrandTotal ?? 0))) ?? 0.00))
                let request = PKPaymentRequest()
                request.currencyCode = "AED"
                request.countryCode = "AE"
                request.merchantIdentifier = AppInfo.shared.applePayMerchantId
                //request.merchantIdentifier = "merchant.comheckoutSabdbox.com"
                request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
                request.supportedNetworks = paymentNetworks // 5
                request.paymentSummaryItems = [paymentItem] // 6
                
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                    
                    guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                        displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                        //self.addCashedItemsToCart()
                        return
                    }
                    paymentVC.delegate = self
                    self.present(paymentVC, animated: true, completion: nil)
                }
                
            } else {
                
                
                
                let alert = UIAlertController(title: "Add Card to Apple Pay", message: "Add a card that is accepted by Marina Home", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(cancelAction)
                
                let okAction = UIAlertAction(title: "Add Card", style: .default, handler: { (action) in
                    
                    
                    
                    //Open Wallet app
                    
                    let library = PKPassLibrary()
                    
                    library.openPaymentSetup()
                    
                })
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
            
        }
        
        else {
            
            let alert = UIAlertController(title: "", message: "Apple pay is not enabled for this device", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
        ///
        
        
        
    }
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func postPay()
    {
        let webV:UIWebView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        
        //webV.delegate = self;
        self.view.addSubview(webV)
        webV.loadHTMLString("<html><body><script>window.postpayAsyncInit = function() {postpay.init({merchantId: 'id_1b9072e0100√ø4d52b√øc54√ø367b568c28',sandbox: true,theme: 'light',locale: 'en'});};</script><script async src=\"https://cdn.postpay.io/v1/js/postpay.js\"></script><div class=\"postpay-widget\"data-type=\"cart\"data-environment=\"sand\"data-amount=\"100\"data-currency=\"AED\"data-num-instalments=\"5\"data-locale=\"en\"></div></body></html>", baseURL: nil)
        
        
        self.view.addSubview(webV)
    }
    
    func postpayAPi()
    {
        var cartitems:[[String:Any]] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for i in appDelegate.cachedCartItems!
        {
            let itemcart =     [
                "reference": i.sku ?? "",
                "name": i.name ?? "",
                "description": "",
                "url": "",
                "image_url": "",
                "unit_price": Double(i.price ?? 0)*100,
                "qty": i.qty ?? 0
            ] as [String : Any]
            
            cartitems.append(itemcart)
        }
        var param:[String:Any] = [
            "order_id": self.incrementID,
            "total_amount":Double(String(format: "%.2f", Double(self.cartTotal?.baseGrandTotal ?? 0)*100)) ?? 0.00 ,
            "tax_amount":Double(String(format: "%.2f", Double(self.cartTotal?.taxAmount ?? 0)*100)) ?? 0.00,
            "currency": "AED",
            "items": cartitems,
            "discounts": [
                [
                    "code": "return-10",
                    "name": "Returning customer 10% discount",
                    "amount":Double(String(format: "%.2f", Double(self.cartTotal?.discountAmount ?? 0)*100)) ?? 0.00
                ]
            ],
            "merchant": [
                "confirmation_url": AppInfo.shared.checkOutPaymentSuccessURL,
                "cancel_url": AppInfo.shared.checkOutPaymentFailureURL
            ]
        ]
         param["customer"] = [
            "id": UserData.shared.userId,
            "email": UserData.shared.emailId,
            "first_name": self.address?.firstname,
            "last_name": self.address?.lastname,
            "gender": "male",
            "account": "guest",
            "date_of_birth": "1990-01-20",
            "date_joined": "2019-08-26T09:28:14.790Z"
        ]
        param["billing_address"] = [
            "first_name": self.address?.firstname,
            "last_name": self.address?.lastname,
            "phone": self.address?.telephone,
            "alt_phone": "800 239",
            "line1": "The Gate District, DIFC",
            "line2": "Level 4, Precinct Building 5",
            "city": self.address?.city,
            "state": self.address?.country_id,
            "country": "AE",
            "postal_code": "00000"
        ]
        var shippingAddr :[String:Any] = [
            "id": "shipping-01",
            "name": "Express Delivery",
            "amount":Double(String(format: "%.2f", Double(self.cartTotal?.shippingAmount ?? 0)*100)) ?? 0.00,
        ]
        shippingAddr["address"] = [
            "first_name": self.address?.firstname ?? "",
            "last_name": self.address?.lastname ?? "",
            "phone": self.address?.telephone ?? "",
            "alt_phone": "800 239",
            "line1": "The Gate District, DIFC",
            "line2": "Level 4, Precinct Building 5",
            "city": self.address?.city ?? "",
            "state": self.address?.country_id ?? "",
            "country": "AE",
            "postal_code": "00000"
        ]
        param["shipping"] = shippingAddr
        
        self.apiPostPayPaymentRequest(param: param){ response in
            if(response.redirectURL != "")
            {
                let vc = AppController.shared.web
                vc.hidesBottomBarWhenPushed = true
                vc.urlString = response.redirectURL
                vc.guestName = "\(self.parameterAdress["firstname"] ?? "")"
                //MARK: START MHIOS-1281
                vc.guestEmail = "\(self.parameterAdress["email"] ?? "")"
                //MARK: START MHIOS-1281
                vc.orderId = self.orderID
                vc.incrementId = self.incrementID
                vc.rference = response.reference
                vc.postpayId = response.token
                vc.selectedTomeSlot = self.selectedTimeSlot
                vc.ScreenTitle = "Postpay"
                vc.baseGrandTotal = self.cartTotal?.baseGrandTotal
                vc.isfromPostpay = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func postpayAPiGuest()
    {
        
        if UserData.shared.isLoggedIn == false{
            
            fullNameLbl.text = "\(parameterAdress["firstname"] ?? "") \(parameterAdress["lastname"] ?? "")"
            var street = ""
            let address2 = parameterAdress["region"] as! String
            let str: [String] = parameterAdress["street"]  as! [String]
            for i in str{
                street = street + i as String + " "
            }
            addressLbl.text = "\(street)\n\(address2)"
            
        }
        var cartitems:[[String:Any]] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for i in appDelegate.cachedCartItems!
        {
            let itemcart =     [
                "reference": i.sku ?? "",
                "name": i.name ?? "",
                "description": "",
                "url": "",
                "image_url": "",
                "unit_price": Double(i.price ?? 0)*100,
                "qty": i.qty ?? 0
            ] as [String : Any]
            
            cartitems.append(itemcart)
        }
        let param:[String:Any] = [
            "order_id": self.incrementID,
            "total_amount":Double(String(format: "%.2f", Double(self.cartTotal?.baseGrandTotal ?? 0)*100)) ?? 0.00 ,
            "tax_amount":Double(String(format: "%.2f", Double(self.cartTotal?.taxAmount ?? 0)*100)) ?? 0.00,
            "currency": "AED",
            "shipping": [
                "id": "shipping-01",
                "name": "Express Delivery",
                "amount":Double(String(format: "%.2f", Double(self.cartTotal?.shippingAmount ?? 0)*100)) ?? 0.00,
                "address": [
                    "first_name": "\(parameterAdress["firstname"] ?? "")",
                    "last_name": "\(parameterAdress["lastname"] ?? "")",
                    "phone": "\(parameterAdress["telephone"] ?? "")",
                    "alt_phone": "800 239",
                    "line1": "The Gate District, DIFC",
                    "line2": "Level 4, Precinct Building 5",
                    "city": "\(parameterAdress["city"] ?? "")",
                    "state": "\(parameterAdress["city"] ?? "")",
                    "country": "AE",
                    "postal_code": "00000"
                ]
            ],
            "billing_address": [
                "first_name": "\(parameterAdress["firstname"] ?? "")",
                "last_name": "\(parameterAdress["lastname"] ?? "")",
                "phone": "\(parameterAdress["telephone"] ?? "")",
                "alt_phone": "800 239",
                "line1": "The Gate District, DIFC",
                "line2": "Level 4, Precinct Building 5",
                "city": "\(parameterAdress["city"] ?? "")",
                "state": "\(parameterAdress["city"] ?? "")",
                "country": "AE",
                "postal_code": "00000"
            ],
            "customer": [
                "id": "customer-01",
                "email":  "\(parameterAdress["email"] ?? "")",
                "first_name": "\(parameterAdress["firstname"] ?? "")",
                "last_name": "\(parameterAdress["lastname"] ?? "")",
                "gender": "male",
                "account": "guest",
                "date_of_birth": "1990-01-20",
                "date_joined": "2019-08-26T09:28:14.790Z"
            ],
            "items": cartitems,
            "discounts": [
                [
                    "code": "return-10",
                    "name": "Returning customer 10% discount",
                    "amount":Double(String(format: "%.2f", Double(self.cartTotal?.discountAmount ?? 0)*100)) ?? 0.00
                ]
            ],
            "merchant": [
                "confirmation_url": AppInfo.shared.checkOutPaymentSuccessURL,
                "cancel_url": AppInfo.shared.checkOutPaymentFailureURL
            ]
        ]
        
        
        
        self.apiPostPayPaymentRequest(param: param){ response in
            if(response.redirectURL != "")
            {
                let vc = AppController.shared.web
                vc.hidesBottomBarWhenPushed = true
                vc.urlString = response.redirectURL
                vc.guestName = "\(self.parameterAdress["firstname"] ?? "")"
                //MARK: START MHIOS-1281
                vc.guestEmail = "\(self.parameterAdress["email"] ?? "")"
                //MARK: START MHIOS-1281
                vc.orderId = self.orderID
                vc.incrementId = self.incrementID
                vc.selectedTomeSlot  =  self.selectedTimeSlot
                vc.rference = response.reference
                vc.postpayId = response.token
                // Mark MHIOS-1166
                vc.baseGrandTotal = self.cartTotal?.baseGrandTotal
                // Mark MHIOS-1166
                vc.ScreenTitle = "Postpay"
                vc.isfromPostpay = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func addCashedItemsToCart()
    {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for i in appDelegate.cachedCartItems!
        {
            if UserData.shared.isLoggedIn
            {
                self.apiCreateCart()
                { response in
                    DispatchQueue.main.async {
                        self.apiCarts(){ response in
                            DispatchQueue.main.async {
                                print(response)
                                self.apiAddToCart(parameters: ["cartItem":
                                                                ["sku": i.sku ?? "",
                                                                 "qty": i.qty ?? 0,
                                                                 "quote_id": "\(response.id)"]]){ responseData in
                                    DispatchQueue.main.async {
                                        self.cashedItemsCount = self.cashedItemsCount + 1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                            appDelegate.cachedCartItems?.removeAll()
                                            appDelegate.payementSucces=true
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                if(appDelegate.guestCartId == "")
                {
                    self.apiCreateGuestCart()
                    { response in
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.guestCartId = response
                        DispatchQueue.main.async {
                            self.apiGuestCarts{ response in
                                DispatchQueue.main.async {
                                    print(response)
                                    self.apiAddToGuestCart(parameters: ["cartItem":["sku": i.sku ?? "", "qty": i.qty, "quote_id": "\(response.id)"]]){ responseData in
                                        DispatchQueue.main.async {
                                            self.cashedItemsCount = self.cashedItemsCount + 1
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                appDelegate.cachedCartItems?.removeAll()
                                                appDelegate.payementSucces=true
                                                self.navigationController?.popToRootViewController(animated: true)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    self.apiGuestCarts{ response in
                        DispatchQueue.main.async {
                            print(response)
                            self.apiAddToGuestCart(parameters: ["cartItem":
                                                                    [
                                                                        "sku": i.sku ?? "",
                                                                        "qty": i.qty ?? 0,
                                                                        "quote_id": "\(response.id)"]])
                            { responseData in
                                DispatchQueue.main.async {
                                    self.cashedItemsCount = self.cashedItemsCount + 1
                                    print(responseData)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.cachedCartItems?.removeAll()
                                        appDelegate.payementSucces=true
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func formatNumberToThousandNew2(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.minimumFractionDigits = 2
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? ""
    }
}
extension CheckoutPaymentVC:CreditCardScannerViewControllerDelegate
{
    func creditCardScannerViewController(_ viewController: CreditCardScanner.CreditCardScannerViewController, didErrorWith error: CreditCardScanner.CreditCardScannerError) {
        
    }
    
    func creditCardScannerViewController(_ viewController: CreditCardScanner.CreditCardScannerViewController, didFinishWith card: CreditCardScanner.CreditCard) {
        
        self.txtCardNumber?.text = card.number
        self.txtCarddate?.text = "\(card.expireDate?.month ?? 0)/\((card.expireDate?.year ?? 0)%100 )"
        self.txtCardName?.text = card.name
        self.dismiss(animated: true)
    }
    
    
}





