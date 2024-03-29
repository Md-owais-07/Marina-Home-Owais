//
//  AdressListVC.swift
//  Marina Home
//
//  Created by Codilar on 17/05/23.
//

import UIKit
protocol AddressProtocol {
    func selectedAddress(address:Addresses)
    // Mark MHIOS-1146
    func selectedAddressIndex(index:Int)
    // Mark MHIOS-1146
}
class AdressListVC: AppUIViewController,UITableViewDataSource,UITableViewDelegate {
    var selectedSectionItem = -1
    // Mark MHIOS-1146
    var selectedAddress = -1
    // Mark MHIOS-1146
    var adress:AddressModel?
    var myTotal:GrandTotal?
    var delegate:AddressProtocol?
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tbldeliveryOptions: UITableView!
    var comeBackAddAddress = true
    override func viewDidLoad() {
        super.viewDidLoad()
        backActionLink(self.btnBack)
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Address List Screen")
        //MARK: END MHIOS-1225
       // tblCart.register(UINib(nibName: "CartCupenTVC", bundle: nil), forCellReuseIdentifier: "CartCupenTVC")
        // Do any additional setup after loading the view.
        self.tbldeliveryOptions.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiDeliveryOption(){ response in
            DispatchQueue.main.async {
                print(response)
                self.adress = response as AddressModel
                if( self.adress?.addresses?.count ?? 0 > 0)
                {
                    if self.comeBackAddAddress
                    {
                        //MARK START{MHIOS-962}
                        if self.selectedAddress == -1
                        {
                            self.setDefaultAddress()
                        }
                        //MARK END{MHIOS-962}
                        else
                        {
                            // Mark MHIOS-1146
                            self.selectedSectionItem = self.selectedAddress
                            self.tbldeliveryOptions.reloadData()
                            // Mark MHIOS-1146
                        }
                    }
                    
                }
                self.tbldeliveryOptions.reloadData()
                if ((self.adress?.addresses?.isEmpty ?? true)){
                    let nextVC = AppController.shared.addAddress
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.hidesBottomBarWhenPushed = false
    }
    //MARK START{MHIOS-962}
    func setDefaultAddress()
    {
        let adressArray = self.adress?.addresses as! [Addresses]
        for index in 0..<adressArray.count
        {
            let adrs = adressArray[index]
            if adrs.default_billing == true && adrs.default_shipping == true
            {
                self.selectedSectionItem = index
                break
            }
        }
        //MARK: START MHIOS-962
        if self.selectedSectionItem == -1
        {
            self.selectedSectionItem = 0
        }
        //MARK: END MHIOS-962
        self.tbldeliveryOptions.reloadData()
    }
    //MARK END{MHIOS-962}
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        
    
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section==0)
        {
            return 100
        }
        else
        {
            let lineCount = makeAddressText(addresse: (self.adress?.addresses?[indexPath.row])!)
            if(indexPath.row==0)
            {
                //return 270
                let cellHeight = (lineCount*16)+227
                return CGFloat(cellHeight)
            }
            else
            {
                //return 220
                let cellHeight = (lineCount*16)+177
                return CGFloat(cellHeight)
            }
        }
            //return 220
      
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1
        }
        return self.adress?.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section==0)
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewAddressTVC", for: indexPath) as? AddNewAddressTVC else { return UITableViewCell()}
            cell.btnAddNew.addTarget(self, action: #selector(self.addNew(_:)), for: .touchUpInside)
            return cell
            
        }
        else
        {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryOptionTVC", for: indexPath) as? DeliveryOptionTVC else { return UITableViewCell()}
            let adres:Addresses = (self.adress?.addresses?[indexPath.row])!
            cell.lblName.text = (adres.firstname ?? "") + " " + (adres.lastname ?? "")
            var street = ""
            for i in adres.street!
            {
                street = street + i + " "
            }
            cell.lblStreet.text = "\(street) \n\(adres.region?.region ?? "")  \(adres.postcode ?? "")"
            //cell.lblStreet.text = street
            //cell.lblRegion.text = (adres.region?.region ?? "") + " " + (adres.postcode ?? "")
            cell.setSelectionStyle(isSelected: indexPath.item == selectedSectionItem)
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(self.edit(_:)), for: .touchUpInside)
            if(indexPath.row==0)
            {
                cell.titleView.isHidden = false
            }
            else
            {
                cell.titleView.isHidden = true
            }
            return cell
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedSectionItem = indexPath.item
        self.tbldeliveryOptions.reloadData()
    }

    func showTime(){
        self.comeBackAddAddress = false
        let popUpVC = AppController.shared.deliveryTime
        popUpVC.modalTransitionStyle = .crossDissolve
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.proceedClosure = { time in
            let nextVC = AppController.shared.checkout
            nextVC.selectedTimeSlot = time
            nextVC.hidesBottomBarWhenPushed = true
            // Mark MHIOS-1146
            nextVC.selectedAddress = self.selectedSectionItem
            // Mark MHIOS-1146
            nextVC.address = self.adress?.addresses?[self.selectedSectionItem]
            nextVC.cartTotal = self.myTotal
            // Mark MHIOS-1130
            if  nextVC.address != nil
            {
                self.sendAdjustEvent(address: nextVC.address!)
            }
            // Mark MHIOS-1130
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
    }

    // Mark MHIOS-1130
    func sendAdjustEvent(address: Addresses)
    {
        
        do {
          
            let jsonData = try JSONEncoder().encode(address)
            if let dict = try JSONSerialization.jsonObject(with: jsonData) as? [String:Any] {
                    
                
                AdjustAnalytics.shared.createEvent(type: .ShippingDetails)
                for val in dict
                {
                    AdjustAnalytics.shared.createParam(key: val.key, value: "\(val.value)")
                }
                AdjustAnalytics.shared.track()
              
                }
           
        }
        catch {
            
            print(error)
            
        }
        
    }
    // Mark MHIOS-1130
     @IBAction func confirmAdress(_ sender: Any) {
         if selectedSectionItem == -1{
             //MARK: START MHIOS-1285
             SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please select an address to continue","Screen" : self.className])
             //MARK: END MHIOS-1285
             self.toastView(toastMessage: "Please select an address to continue",type: "error")
         }else{
             if self.delegate == nil{
                 
                 showTime()
             }else{
                 let addressSelected = self.adress?.addresses?[self.selectedSectionItem]
                 if addressSelected != nil{
                     self.comeBackAddAddress = false
                     self.delegate?.selectedAddress(address: addressSelected!)
                     // Mark MHIOS-1130
                        self.sendAdjustEvent(address: addressSelected!)
                    // Mark MHIOS-1130
                     // Mark MHIOS-1146
                     self.delegate?.selectedAddressIndex(index: self.selectedSectionItem)
                     // Mark MHIOS-1146
                     self.navigationController?.popViewController(animated: true)
                 }
             }
         }
     }
     
    @objc func addNew(_ sender: UIButton) {
        self.comeBackAddAddress = true
        let nextVC = AppController.shared.addAddress
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func edit(_ sender: UIButton) {
            //MARK: START MHIOS-962
            self.comeBackAddAddress = true
            //MARK: END MHIOS-962
            let nextVC = AppController.shared.addAddress
            nextVC.SelectedAdress = self.adress?.addresses![sender.tag]
            self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
