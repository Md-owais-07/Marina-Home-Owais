//
//  AddAddressVC.swift
//  Marina Home
//
//  Created by Codilar on 18/05/23.
//
////MARK START{MHIOS-962}
///Add the defualt check box in UI side
/////MARK EEND{MHIOS-962}
/////MARK START{MHIOS-1190}
///chenged the change phone text style
/////MARK END{MHIOS-1190}
import UIKit
import Alamofire
import DropDown
import GooglePlaces
protocol editAdressProtocol {
   
    func editedAdress(option:Addresses)
    func editedGuestAdress(option:[String: Any])
    
}
class AddAddressVC: AppUIViewController {
    var SelectedAdress:Addresses?
    var isFromBilling:Bool = false
    var myTotal:GrandTotal?
    var countryList:Country1?
    var countrySelectedPos = 0
    var citySelectedPos = 0
    var isadressSelectd:Bool = false
    var selectedTimeSlot = ""
    var parameterAdress:[String: Any] = [:]
    var parameterEditAdress:[String: Any] = [:]
    @IBOutlet var emailView: UIView!
   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var lblAddNewAddress: UILabel!
    @IBOutlet weak var addressFirstNameField: FloatingLabeledTextField!
    @IBOutlet weak var addressLastNameField: FloatingLabeledTextField!
    ///@IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var addressCountryField: FloatingLabeledTextField!
    @IBOutlet weak var addressCountryCodeField: UITextField!
    @IBOutlet weak var addressPhoneNumberField: FloatingLabeledTextField!
    @IBOutlet var btnAddNew: AppPrimaryButton!
    @IBOutlet weak var addressCityField: FloatingLabeledTextField!
    @IBOutlet weak var addressAreaField: FloatingLabeledTextField!
    @IBOutlet weak var addressApartmentField: FloatingLabeledTextField!
    @IBOutlet var txtEmail: FloatingLabeledTextField!
    @IBOutlet var addressErrorView: [UIView]!
    @IBOutlet var addressErrorLbl: [UILabel]!
    let dropDown = DropDown()
    var editDelegate : editAdressProtocol?

    var placesClient: GMSPlacesClient?
    var searchListArray:[String] = []
    var isFromCart:Bool = false
    //MARK START{MHIOS-962}
    var defaultAdrsStatus:Bool = false
    //MARK START{MHIOS-962}
    
    //MARK START{MHIOS-962}
    @IBOutlet weak var defaultAdrsSelectionView: UIView!
    @IBOutlet weak var defaultAdrsCheckBoxView: UIImageView!
    //MARK END{MHIOS-962}
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isFromCart
        {
            backActionLink(backButton)
        }
        else
        {
            backButton.addTarget(self, action: #selector(self.backActionNew), for: UIControl.Event.touchUpInside)
        }
        //MARK START{MHIOS-962}
        if(UserData.shared.isLoggedIn==true)
        {
            defaultAdrsSelectionView.isHidden = false
        }
        else
        {
            defaultAdrsSelectionView.isHidden = true
        }
        //MARK END{MHIOS-962}
        addressAreaField.autocapitalizationType = .words
        addressAreaField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        placesClient = GMSPlacesClient.shared()
        var i = 100
        for subviews in self.view.subviews {
            if subviews is UITextField
            {
                subviews.tag = i
                i+=1
            }
         }
        self.apiGetCountry(){ response in
            DispatchQueue.main.async {
                self.countryList = response
                
                self.addressCountryField.text =    self.countryList?.full_name_english ?? ""
                self.addressCityField.text = self.countryList?.available_regions?.first?.name  ?? ""
                self.addressCountryField.setDirectText()
                self.addressCityField.setDirectText()
                self.loadData()
            }
        }
    }
    
    @objc func backActionNew(_ sender: UIButton) {
        
        //self.navigationController?.popViewController(animated: true)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MyCartVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = addressAreaField.text ?? ""
        if searchText != ""{
            GoogleSearch(searchtext: searchText)
        }else{
            searchListArray = []
            dropDown.hide()
        }
    }
    func GoogleSearch(searchtext:String) {
        let token = GMSAutocompleteSessionToken.init()
        let filter = GMSAutocompleteFilter()
        filter.countries = ["\(self.countryList?.id ?? "")"]
        placesClient?.findAutocompletePredictions(fromQuery: searchtext,filter: filter,sessionToken: token,callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            if let results = results {
                self.searchListArray = []
                for result in results {
                    self.searchListArray.append(result.attributedFullText.string)
                }
            }
            self.AreaSearched()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        if UserData.shared.isLoggedIn{
            self.emailView.isHidden = true
            self.view.layoutIfNeeded()
        }
        else
        {
            self.emailView.isHidden = false
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Adding address Screen")
        //MARK: END MHIOS-1225
    }
    //MARK START{MHIOS-962}
    @IBAction func defaultAdrsCheckBoxBtnAction(_ sender: UIButton) {
        
        if defaultAdrsStatus == false
        {
            defaultAdrsCheckBoxView.image = UIImage(named: "checkboxButton_Selected_icon")
        }
        else
        {
            defaultAdrsCheckBoxView.image = UIImage(named: "checkboxButton_icon")
        }
        defaultAdrsStatus = !defaultAdrsStatus
    }
    //MARK END{MHIOS-962}
    @IBAction func countyCodePressed(_ sender: Any) {
        let countryCodes = CountryCodes.values()
        var countryText:[String] = []
       /* for item in countryCodes ?? []{
            countryText.append("+\(item.dialCode)" ?? "")
        }*/
        countryText.append("+971")
        dropDown.dataSource = countryText//4
        dropDown.direction = .top
        dropDown.anchorView = sender as! any AnchorView //5
        ///dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
               // (sender as! UIButton).setTitle("Quantity: \(item)", for: .normal) //9
                self?.addressCountryCodeField.text = item
                self?.addressErrorLbl[3].text = ""
                self?.addressErrorView[3].isHidden = true
                self?.addressCountryField.setDirectText()
               // self?.countrySelectedPos = index
               // self?.addressCityField.text = self?.countryList?.available_regions?.first?.name
               // self?.addressCityField.setDirectText()
               // self?.citySelectedPos = 0
            }
    }
    @IBAction func CountryPressed(_ sender: Any) {
        var countryText:[String] = []
        
        countryText.append(self.countryList?.full_name_english ?? "")
        
        dropDown.dataSource = countryText//4
        dropDown.direction = .top
        dropDown.anchorView = sender as! any AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: 0) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
               // (sender as! UIButton).setTitle("Quantity: \(item)", for: .normal) //9
                self?.addressCountryField.text = item
                self?.addressErrorLbl[3].text = ""
                self?.addressErrorView[3].isHidden = true
                self?.addressCountryField.setDirectText()
                self?.countrySelectedPos = index
              //  self?.addressCityField.text = self?.countryList?.available_regions?.first?.name
                self?.addressCityField.setDirectText()
                //self?.citySelectedPos = 0
            }
    }

    @IBAction func CityPressed(_ sender: Any) {
        var cityText:[String] = []
        for item in self.countryList?.available_regions ?? []{
            cityText.append(item.name ?? "")
        }
        dropDown.dataSource = cityText//4
        dropDown.direction = .top
        dropDown.anchorView = sender as! any AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                (sender as! UIButton).setTitle("Quantity: \(item)", for: .normal) //9
                self?.addressCityField.text = item
                self?.addressCityField.setDirectText()
                self?.citySelectedPos = index
                self?.addressErrorLbl[5].text = ""
                self?.addressErrorView[5].isHidden = true
            }
    }

    func AreaSearched() {
        dropDown.dataSource = searchListArray//4
        dropDown.anchorView = addressAreaField as! any AnchorView //5
        dropDown.direction = .top
        dropDown.width = addressAreaField.frame.width
        dropDown.topOffset = CGPoint(x: 0, y: -addressAreaField.frame.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.addressAreaField.text = item
            self?.addressAreaField.setDirectText()
            self?.addressErrorLbl[6].text = ""
            self?.addressErrorView[6].isHidden = true
        }
    }
    
func loadData()
    {
        if (UserData.shared.isLoggedIn == false)
        {
            self.btnAddNew.setTitle("CONFIRM ADDRESS", for: .normal)
        }
        else
        {
            self.btnAddNew.setTitle("ADD NEW ADDRESS", for: .normal)
            
        }
        //MARK START{MHIOS-962}
        if self.SelectedAdress?.default_billing == true && self.SelectedAdress?.default_shipping == true
        {
            defaultAdrsStatus = true
            defaultAdrsCheckBoxView.image = UIImage(named: "checkboxButton_Selected_icon")
        }
        else
        {
            defaultAdrsStatus = false
            defaultAdrsCheckBoxView.image = UIImage(named: "checkboxButton_icon")
        }
        //MARK END{MHIOS-962}
        /*if(self.myTotal != nil)
        {
            self.btnAddNew.setTitle("CONFIRM ADDRESS", for: .normal)
        }*/
        if(self.parameterEditAdress.isEmpty==false)
        {
            self.btnAddNew.setTitle("SAVE ADDRESS", for: .normal)
            self.lblAddNewAddress.text = "SAVE ADDRESS"
            addressFirstNameField.text = self.parameterEditAdress["firstname"] as! String
            txtEmail.text = self.parameterEditAdress["email"] as! String
            txtEmail.setDirectText()
            addressLastNameField.text = self.parameterEditAdress["lastname"] as! String
            let m = self.parameterEditAdress["telephone"] as! String
            if(m != nil)
            {
                let parsed = m.replacingOccurrences(of: "+971", with: "")
                addressPhoneNumberField.text = parsed
            }
            
           addressFirstNameField.setDirectText()
           addressLastNameField.setDirectText()
           addressPhoneNumberField.setDirectText()
           
                
                addressAreaField.setDirectText()
                let street = self.parameterEditAdress["street"] as! [String]
                addressAreaField.text = street[0]
                if(street.count>1)
                {
                    addressAreaField.text = street[0]
                    addressApartmentField.text = street[1]
                    addressApartmentField.setDirectText()
                }
                
            
            
        }
        if(self.SelectedAdress != nil)
        {
            self.btnAddNew.setTitle("SAVE ADDRESS", for: .normal)
            self.lblAddNewAddress.text = "SAVE ADDRESS"
            addressFirstNameField.text = self.SelectedAdress?.firstname
            addressLastNameField.text = self.SelectedAdress?.lastname
            let m = self.SelectedAdress?.telephone
            if(m != nil)
            {
                let parsed = m?.replacingOccurrences(of: "+971", with: "")
                addressPhoneNumberField.text = parsed
            }
            
           addressFirstNameField.setDirectText()
           addressLastNameField.setDirectText()
           addressPhoneNumberField.setDirectText()
            if((self.SelectedAdress?.street!.count)!>0)
            {
                addressAreaField.text = self.SelectedAdress?.street![0]
                addressAreaField.setDirectText()
                if((self.SelectedAdress?.street!.count)!>1)
                {
                    addressApartmentField.text = self.SelectedAdress?.street![1]
                    addressApartmentField.setDirectText()
                }
            }

          
           if (self.SelectedAdress?.country_id ?? "" == self.countryList?.id) {
                   //countrySelectedPos = cnIndex
               addressCountryField.text = self.countryList?.full_name_english ?? ""
               
                   addressCountryField.setDirectText()
               for (rgIndex,rg) in (self.countryList?.available_regions ?? []).enumerated(){
                       if self.SelectedAdress?.region?.region_code ?? "" == rg.code ?? ""{
                           citySelectedPos = rgIndex
                           addressCityField.text = rg.name ?? ""
                           addressCityField.setDirectText()
                           break
                       }
                   }
                  
               }
           
        }
        
        if (UserData.shared.isLoggedIn)
        {
            self.addressCountryField.text = self.countryList?.full_name_english ?? ""
            self.addressErrorLbl[3].text = ""
            self.addressErrorView[3].isHidden = true
            self.addressCountryField.setDirectText()
            txtEmail.text = UserData.shared.emailId
            txtEmail.setDirectText()
        }
        
        
    }
    //MARK: START MHIOS-1264
    @IBAction func addAction(_ sender: UIButton) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Adding address with values")
        CrashManager.shared.log("Email: \(self.txtEmail.text ?? "")")
        CrashManager.shared.log("First Name: \(addressFirstNameField.text ?? "")")
        CrashManager.shared.log("Last Name: \(addressLastNameField.text ?? "")")
        CrashManager.shared.log("Country: \(addressCountryField.text ?? "")")
        CrashManager.shared.log("Phone No.: \(addressPhoneNumberField.text ?? "")")
        CrashManager.shared.log("City: \(addressCityField.text ?? "")")
        CrashManager.shared.log("Area: \(addressAreaField.text ?? "")")
        CrashManager.shared.log("Apartment: \(addressApartmentField.text ?? "")")
        //MARK: END MHIOS-1225
        if(UserData.shared.isLoggedIn == false)
        {
            if ( !self.checkMailIdFormat(string: self.txtEmail.text ?? "")){
                //MARK: START MHIOS-1285
                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid email address.","Screen" : self.className])
                //MARK: END MHIOS-1285
                self.toastView(toastMessage: "Please enter a valid email address.",type: "error")
                addressErrorLbl[0].text = "Please enter a valid email address."
                addressErrorView[0].isHidden = false
                txtEmail.setErrorTheme(errorAction: {
                    self.addressErrorLbl[0].text = ""
                    self.addressErrorView[0].isHidden = true
                })
                return
            }
        }

        if  addressFirstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your first name","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your first name",type: "error")
             addressErrorLbl[1].text = "Please enter your first name"
             addressErrorView[1].isHidden = false
             addressFirstNameField.setErrorTheme(errorAction: {
                 self.addressErrorLbl[1].text = ""
                 self.addressErrorView[1].isHidden = true
             })
         }else if addressLastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{

             //MARK: START MHIOS-1285
             SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your last name","Screen" : self.className])
             //MARK: END MHIOS-1285
         }else if addressLastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
             //MARK: START MHIOS-1285
             SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your last name","Screen" : self.className])
             //MARK: END MHIOS-1285
             self.toastView(toastMessage: "Please enter your last name",type: "error")
             addressErrorLbl[2].text = "Please enter your last name"
             addressErrorView[2].isHidden = false
             addressLastNameField.setErrorTheme(errorAction: {
                 self.addressErrorLbl[2].text = ""
                 self.addressErrorView[2].isHidden = true
             })
         }else if addressCountryField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
             //MARK: START MHIOS-1285
             SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please select your country","Screen" : self.className])
             //MARK: END MHIOS-1285
                self.toastView(toastMessage: "Please select your country",type: "error")
                addressErrorLbl[3].text = "Please select your country"
                addressErrorView[3].isHidden = false
             addressCountryField.setErrorTheme(errorAction: {
                    self.addressErrorLbl[3].text = ""
                    self.addressErrorView[3].isHidden = true
                })
         }else if addressPhoneNumberField.text == "" && self.isValidPhone(phone:(self.addressCountryCodeField.text ?? "")+(addressPhoneNumberField.text ?? "") )==true{
             //MARK: START MHIOS-1285
             SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your mobile number","Screen" : self.className])
             //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your mobile number",type: "error")
            addressErrorLbl[4].text = "Please enter your mobile number"
            addressErrorView[4].isHidden = false
            addressPhoneNumberField.setErrorTheme(errorAction: {
                self.addressErrorLbl[4].text = ""
                self.addressErrorView[4].isHidden = true
            })
        }
        else if  7 > addressPhoneNumberField.text!.count {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid mobile number","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid mobile number",type: "error")
            addressErrorLbl[4].text = "Please enter a valid mobile number"
            addressErrorView[4].isHidden = false
            addressPhoneNumberField.setErrorTheme(errorAction: {
                self.addressErrorLbl[4].text = ""
                self.addressErrorView[4].isHidden = true
            })
        }else if addressPhoneNumberField.text!.count > 10 {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid mobile number","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid mobile number",type: "error")
            addressErrorLbl[4].text = "Please enter a valid mobile number"
            addressErrorView[4].isHidden = false
            addressPhoneNumberField.setErrorTheme(errorAction: {
                self.addressErrorLbl[4].text = ""
                self.addressErrorView[4].isHidden = true
            })
        }
        else if addressCityField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your city","Screen" : self.className])
            //MARK: END MHIOS-1285            
            self.toastView(toastMessage: "Please enter your city",type: "error")
            addressErrorLbl[5].text = "Please enter your city"
            addressErrorView[5].isHidden = false
            addressCityField.setErrorTheme(errorAction: {
                self.addressErrorLbl[5].text = ""
                self.addressErrorView[5].isHidden = true
            })

        }
           else if addressAreaField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your address/area","Screen" : self.className])
            //MARK: END MHIOS-1285            
            self.toastView(toastMessage: "Please enter your address/area",type: "error")
            addressErrorLbl[6].text = "Please enter your address/area"
            addressErrorView[6].isHidden = false
            addressAreaField.setErrorTheme(errorAction: {
                self.addressErrorLbl[6].text = ""
                self.addressErrorView[6].isHidden = true
            })
        }else if addressApartmentField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your apartment/villa no","Screen" : self.className])
            //MARK: END MHIOS-1285            
            self.toastView(toastMessage: "Please enter your apartment/villa no",type: "error")
            addressErrorLbl[7].text = "Please enter your apartment/villa no"
            addressErrorView[7].isHidden = false
            addressApartmentField.setErrorTheme(errorAction: {
                self.addressErrorLbl[7].text = ""
                self.addressErrorView[7].isHidden = true
            })
        }
        //MARK: END MHIOS-1264

        else{
            let street:[String] = [addressAreaField.text ?? "", addressApartmentField.text ?? ""]
            var address:[String:Any] = ["region": ["region_code": self.countryList?.available_regions?[citySelectedPos].code ?? "","region": self.countryList?.available_regions?[citySelectedPos].name ?? "",
                                                   "region_id": self.countryList?.available_regions?[citySelectedPos].id ?? ""],
                                        "country_id": countryList?.id ?? "",
                                        "customer_id": UserData.shared.userId,
                                            "street": street,
                                            "firstname": addressFirstNameField.text ?? "",
                                        // MARK: START MHIOS-1112
                                        "lastname": addressLastNameField.text?.trimTrailingWhitespace() ?? "",
                                        // MARK: END MHIOS-1112
                                        //MARK START{MHIOS-962}
                                            "default_shipping": defaultAdrsStatus,
                                            "default_billing": defaultAdrsStatus,
                                        //MARK END{MHIOS-962}
                                        "telephone": "+971\(addressPhoneNumberField.text ?? "")",
                                        "city": addressAreaField.text ?? ""]
            if(UserData.shared.isLoggedIn == false)
            {
                address["email"] = self.txtEmail.text ?? ""
            }
            if(self.SelectedAdress != nil){
                address["id"] = self.SelectedAdress?.id ?? 0
            }
           
            
            if UserData.shared.isLoggedIn{
                let parameter:Parameters = ["address":address]
                
                    self.apiAddOrUpdateAddress(parameters: parameter, token:AppInfo.shared.adminToken){ response in
                        DispatchQueue.main.async {
                            print(response)
                            if(self.isFromBilling==true)
                            {
                                self.editDelegate?.editedAdress(option: response)
                            }
                            self.toastView(toastMessage: self.SelectedAdress == nil ? "Address added successfully!" : "Address updated successfully!",type: "success")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                
            }
            else
            {
                var addressParam:[String:Any] = ["region": self.countryList?.available_regions?[citySelectedPos].name ?? "","region_id": self.countryList?.available_regions?[citySelectedPos].id ?? ""
                                                 ,"country_id": self.countryList?.id ?? "",
                                            "street": street,
                                                 "firstname": addressFirstNameField.text ?? "",
                                                 // MARK: START MHIOS-1112
                                                 "lastname": addressLastNameField.text?.trimTrailingWhitespace() ?? "",
                                                 // MARK: END MHIOS-1112
                                                 "telephone":"+971\(addressPhoneNumberField.text ?? "")",
                                                 "city": addressAreaField.text ?? "",
                                                 "email":self.txtEmail.text ?? ""]
                
                self.parameterAdress = addressParam
                if(self.parameterEditAdress.isEmpty == false)
                {
                    self.editDelegate?.editedGuestAdress(option: self.parameterAdress)
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    self.showTime()
                }
                
           
            }
        }
    }
    func showTime(){
        if(self.isadressSelectd == true)
        {
            let nextVC = AppController.shared.checkout
            nextVC.selectedTimeSlot = self.selectedTimeSlot
            nextVC.parameterAdress = self.parameterAdress
            // nextVC.address = self.adress?.addresses?[self.selectedSectionItem]
            nextVC.cartTotal = self.myTotal
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else
        {
            let popUpVC = AppController.shared.deliveryTime
            popUpVC.modalTransitionStyle = .crossDissolve
            popUpVC.modalPresentationStyle = .overCurrentContext
            popUpVC.proceedClosure = { time in
                self.selectedTimeSlot = time
                let nextVC = AppController.shared.checkout
                nextVC.selectedTimeSlot = time
                nextVC.parameterAdress = self.parameterAdress
                // nextVC.address = self.adress?.addresses?[self.selectedSectionItem]
                nextVC.cartTotal = self.myTotal
                self.isadressSelectd = true
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
        }
    }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
      print("\(textField.tag)")
      if(textField.tag == 104)
      {
          return newString.count <= 10
      }
      return true
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = self.view?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
       
        return true
    }
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }

}


