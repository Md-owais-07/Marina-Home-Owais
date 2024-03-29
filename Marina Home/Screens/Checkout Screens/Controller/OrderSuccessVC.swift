//
//  OrderSuccessVC.swift
//  Marina Home
//
//  Created by Eljo on 01/06/23.
//

import UIKit
import Firebase
class OrderSuccessVC: AppUIViewController {
    @IBOutlet var deliveryTimeStack: UIStackView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblOrderID: UILabel!
    @IBOutlet var lblDeliveryDate: UILabel!
    var selectedTimeSlot = ""
    var orderId = ""
    var incrementId = ""
    var DeliveryDate = ""
    var isPostPay = true
    var guestName = ""
    var isFromtabby:Bool = false
    //MARK: START MHIOS-1192
    var isFromCheckout:Bool = false
    //MARK: START MHIOS-1192
    var trasactionParam: [String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Order Success Screen")
        CrashManager.shared.log("Order ID: \(orderId)")
        CrashManager.shared.log("IncrementID: \(incrementId)")
        CrashManager.shared.log("IsPostPay: \(isPostPay)")
        CrashManager.shared.log("selectedTimeSlot: \(selectedTimeSlot)")
        CrashManager.shared.log("trasactionParam: \(trasactionParam)")
        CrashManager.shared.log("DeliveryDate: \(DeliveryDate)")
        CrashManager.shared.log("isFromtabby: \(isFromtabby)")
        //MARK: END MHIOS-1225
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.payementSucces=true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if(UserData.shared.isLoggedIn)
        {
            self.lblName.text = "Thank you, \(UserData.shared.firstName)"
        }
        else
        {
            self.lblName.text = "Thank you, \(self.guestName)"
        }
        self.hideActivityIndicator(uiView: self.view)
        self.lblOrderID.text = self.incrementId//"APPUAEEN\(orderId)"
       
        appDelegate.cachedCartItems?.removeAll()
        self.navigationController?.isNavigationBarHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date =    dateFormatter.date(from:self.DeliveryDate)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date ?? Date())
        self.lblDeliveryDate.text = convertDateFormater(date: dateString,neededFormat:"MMM dd, yyyy" )
        //MARK: START MHIOS-1192
        if self.isFromCheckout == false
        {

        //MARK: START MHIOS-1192

        //MARK: END MHIOS-1192

            if(self.isFromtabby == false)
            {
                self.apiGenerateInvoice(orderId: orderId, token: AppInfo.shared.integrationToken, isPostpay: isPostPay ){ response in
                    self.apiOrderUpdate(param:self.trasactionParam ){ response in
                     
                    }
                    
                }
            }
            else
            {
                self.apiOrderUpdate(param:self.trasactionParam ){ response in
                    
                }
            }
        //MARK: START MHIOS-1192
        }
        else
        {

            self.apiOrderUpdate(param:self.trasactionParam ){ response in
               
            }
        }
        //MARK: END MHIOS-1192


        // Do any additional setup after loading the view.

    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.hideTabBar(isHidden: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

    }
    
    @IBAction func continueShoping(_ sender: Any) {
       
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: false)
    }
    @IBAction func myOrders(_ sender: Any) {
        if( UserData.shared.isLoggedIn==true)
        {
            let vc = AppController.shared.orderList
            self.hidesBottomBarWhenPushed = false
            //MARK START{MHIOS-1119}
            vc.isFromOrderSuccess = true
            //MARK END{MHIOS-1119}
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
  
}
