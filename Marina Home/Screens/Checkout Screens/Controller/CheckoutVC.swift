//
//  CheckoutVC.swift
//  Marina Home
//
//  Created by Codilar on 22/05/23.
//

import UIKit
import Firebase
import FirebaseCrashlytics

class CheckoutVC: AppUIViewController, AddressProtocol,editAdressProtocol {
    //MARK: START MHIOS-1025
    @IBOutlet weak var shareBtnView: UIButton!
    //MARK: END MHIOS-1025
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeSlotLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var orderTotalLbl: UILabel!
    @IBOutlet weak var grandTotalLbl: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var addbutton: UIView!
    @IBOutlet weak var discountView: UILabel!
    @IBOutlet weak var discountIN: UILabel!
    // MARK: START MHIOS-1169
    @IBOutlet weak var btnSecurePayment: AppGrayButton!
    // MARK: END MHIOS-1169
    
    var parameterAdress:[String: Any] = [:]
    var selectedTimeSlot = ""
    var address:Addresses?
    // Mark MHIOS-1146
    var selectedAddress = 0
    // Mark MHIOS-1146
    var cartTotal:GrandTotal?
    let dateFormatter = DateFormatter()
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1025
        if UserData.shared.isLoggedIn
        {
            self.shareBtnView.isHidden = false
        }
        else
        {
            self.shareBtnView.isHidden = true

        }
        //MARK: END MHIOS-1025
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Checkout Started Screen")
        //MARK: END MHIOS-1225
        Analytics.logEvent("begin_checkout", parameters: [
            AnalyticsParameterPrice:self.cartTotal?.baseSubtotal ?? 0
        ])
        //MARK: START MHIOS-1064
        SmartManager.shared.trackEvent(event: "begin_checkout", properties: ["revenue": "\(self.cartTotal?.baseSubtotal ?? 0)"])
        //MARK: END MHIOS-1064
        backActionLink(backButton)
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateFromStr = dateFormatter.date(from: selectedTimeSlot)!
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        var timeFromDate = dateFormatter.string(from: dateFromStr)
        timeSlotLbl.text = timeFromDate
        if let addressData = address{
            fullNameLbl.text = "\(addressData.firstname ?? "") \(addressData.lastname ?? "")"
            var street = ""
            let address2 = (addressData.region?.region ?? "") + " " + (addressData.postcode ?? "")
            for i in addressData.street!{
                street = street + i + " "
            }
            addressLbl.text = "\(street)\n\(address2)"
        }
        if UserData.shared.isLoggedIn == false{
           
            //self.editButton.isHidden = true
            //self.arrow.isHidden = true
            self.addButton.isHidden = true
            self.addbutton.isHidden = true
            fullNameLbl.text = "\(parameterAdress["firstname"] ?? "") \(parameterAdress["lastname"] ?? "")"
            var street = ""
            let address2 = "\(parameterAdress["region"] ?? "")"
            let str: [String] = parameterAdress["street"]  as! [String]
            for i in str{
                street = street + i as String + " "
            }
            addressLbl.text = "\(street)\n\(address2)"
            
        }
        
        setAllData()
    }
    
    
    
    func setAllData()
    {
        // MARK: START MHIOS-1169
        btnSecurePayment.backgroundColor = AppColors.shared.Color_darkGray_8C8C8C
        btnSecurePayment.isUserInteractionEnabled = false
        // MARK: END MHIOS-1169
        var addressParam:[String:Any] = ["region": self.address?.region?.region ?? "", "region_id": self.address?.region?.region_id ?? ""
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
        
        
        print("SANTHOSH PARAM : \(parameter)")
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
            
            var parameter3:[String: Any] = ["address":parameter2]
            var parameter4:[String: Any] = self.parameterAdress
            
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
    
    //MARK: START MHIOS-1025
    @IBAction func shareAction(_ sender: UIButton) {
        
        var shareURL = AppInfo.shared.baseURL
        
        
        dispatchGroup.enter()
        self.apiShareCartlistViaUrl(quoteId: UserData.shared.cartQuoteId){ response in
            DispatchQueue.main.async {
                if response.error == false {
                    // write to clipboard
                    shareURL = "\(response.message!)"
                    self.dispatchGroup.leave()
                }
                else
                {
                    AppUIViewController().toastView(toastMessage: "Try again",type: "error")
                }
            }
            
        }
        
        
        dispatchGroup.notify(queue: .main) {
            // Perform task 3
            UIPasteboard.general.string = shareURL
            DispatchQueue.main.async {
                let mysharecart = NSURL(string: shareURL)
                let shareAll = [mysharecart]
                let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
                activityViewController.isModalInPresentation = true
                activityViewController.popoverPresentationController?.sourceView = sender as UIView
                self.present(activityViewController, animated: true)
        }
        
       
        }
    
    }
//MARK: END MHIOS-1025
    func setCartTotal()
    {
        if let cartTotalData = cartTotal{
            // MARK: START MHIOS-1169
            btnSecurePayment.backgroundColor = .black
            btnSecurePayment.isUserInteractionEnabled = true
            // MARK: END MHIOS-1169
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
    
    @IBAction func edit(_ sender: Any) {
        if UserData.shared.isLoggedIn == false{
            let nextVC = AppController.shared.addAddress
            nextVC.parameterEditAdress = self.parameterAdress
            nextVC.editDelegate = self
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else
        {
            let nextVC = AppController.shared.addAddress
            nextVC.SelectedAdress = self.address
            nextVC.editDelegate = self
            nextVC.isFromBilling = true
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func changeAddAdressAction(_ sender: UIButton) {
        let nextVC = AppController.shared.deliveryOptions
        // Mark MHIOS-1146
        nextVC.selectedAddress = self.selectedAddress
        // Mark MHIOS-1146
        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func changeTimeSlotAction(_ sender: UIButton) {
        showTime()
    }
    @IBAction func paymentAction(_ sender: UIButton) {
        let nextVC = AppController.shared.checkoutPayment
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.selectedTimeSlot = selectedTimeSlot
        nextVC.address = address
        nextVC.cartTotal = cartTotal
        nextVC.parameterAdress = self.parameterAdress
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func showTime(){
        let popUpVC = AppController.shared.deliveryTime
        popUpVC.selectedDate = self.selectedTimeSlot
        popUpVC.address = address
        popUpVC.modalTransitionStyle = .crossDissolve
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.proceedClosure = { time in
            self.selectedTimeSlot = time
            self.dateFormatter.dateFormat = "dd-MM-yyyy"
            var dateFromStr =  self.dateFormatter.date(from:  self.selectedTimeSlot)!
            self.dateFormatter.dateFormat = "dd-MMM-yyyy"
            var timeFromDate =  self.dateFormatter.string(from: dateFromStr)
            self.timeSlotLbl.text = timeFromDate
            // MARK: START MHIOS-1169
            self.setAllData()
            // MARK: END MHIOS-1169
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
    }

    func selectedAddress(address: Addresses) {
        fullNameLbl.text = "\(address.firstname ?? "") \(address.lastname ?? "")"
        var street = ""
        let address2 = (address.region?.region ?? "") + " " + (address.postcode ?? "")
        for i in address.street!{
            street = street + i + " "
        }
        addressLbl.text = "\(street)\n\(address2)"
        self.address = address
    }
    // Mark MHIOS-1146
    func selectedAddressIndex(index: Int) {
        self.selectedAddress  = index
    }
    // Mark MHIOS-1146
    func editedAdress(option: Addresses) {
        self.address = option
        if let addressData = address{
            fullNameLbl.text = "\(addressData.firstname ?? "") \(addressData.lastname ?? "")"
            var street = ""
            let address2 = (addressData.region?.region ?? "") + " " + (addressData.postcode ?? "")
            for i in addressData.street!{
                street = street + i + " "
            }
            addressLbl.text = "\(street)\n\(address2)"
        }
    }
    func editedGuestAdress(option: [String : Any]) {
        self.parameterAdress = option
        self.addButton.isHidden = true
        self.addbutton.isHidden = true
        fullNameLbl.text = "\(parameterAdress["firstname"] ?? "") \(parameterAdress["lastname"] ?? "")"
        var street = ""
        let address2 = "\(parameterAdress["region"] ?? "")"
        let str: [String] = parameterAdress["street"]  as! [String]
        for i in str{
            street = street + i as String + " "
        }
        addressLbl.text = "\(street)\n\(address2)"
        
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
