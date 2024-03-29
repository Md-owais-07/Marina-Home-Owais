//
//  NotificationViewController.swift
//  Marina Home
//
//  Created by codilar on 13/02/24.
//

//MARK: START MHIOS-967

import UIKit
import Alamofire

class NotificationViewController: AppUIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var noNotificationViewTop: NSLayoutConstraint!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewNoNotification: UIView!
    private var finishedLoadingInitialTableCells = false
    var allnotificationList : [NotificationModel] = [NotificationModel]()

    var notificationList : [NotificationModel] = [NotificationModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        backActionLink(backButton)
        tblNotification.delegate = self
        tblNotification.dataSource = self
        tblNotification.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell_id")
        if notificationList.count > 0
        {
            viewNoNotification.isHidden = true
        }
        allnotificationList = notificationList
    }
    

   
    @IBAction func btnSwitchtoUnreadNotifications(_ sender: Any) {
        
        if ((sender as AnyObject).isOn){
                notificationList = allnotificationList.filter{$0.hasRead == 0}
            }
            else{
                notificationList = allnotificationList
            }
        
        if notificationList.count > 0
        {
            tblNotification.reloadData()
            viewNoNotification.isHidden = true
            noNotificationViewTop.constant = 5
        }
        else
        {
            viewNoNotification.isHidden = false
            noNotificationViewTop.constant = 65
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell_id", for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
       
        let notification = notificationList[indexPath.row]
        cell.lblTitle.text = notification.notificationTitle
        cell.lblDesc.text = notification.notificationBody
        // 0 Unread
        // 1 Read
        cell.iconNotification.isHidden = notification.hasRead == 0 ? false : true
        cell.lblTitle.font = notification.hasRead == 0 ? UIFont(name: AppFontLato.bold, size: 13) : UIFont(name: AppFontLato.regular, size: 13)
        
       return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notificationList[indexPath.row]
        if notification.hasRead == 0
        {
            self.readNotification(notificationId: notification.notificationID ?? 0){ response in
                DispatchQueue.main.async {
                    
                    if response
                    {
                        print(response)
                        if let cell = self.tblNotification.cellForRow(at: indexPath) as? NotificationTableViewCell
                        {
                            cell.lblTitle.font = UIFont(name: AppFontLato.regular, size: 13)
                            cell.iconNotification.isHidden = true
                            self.updateCellValue(notification: notification)
                        }
                        
                        self.redirectUser(notification: notification)
                    }
                    
                }
            }
        }
        else
        {
            self.redirectUser(notification: notification)

        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastIndexPath = tableView.indexPathsForVisibleRows?.last{
            if lastIndexPath.row <= indexPath.row{
                cell.center.y = cell.center.y + cell.frame.height / 2
                cell.alpha = 0
                UIView.animate(withDuration: 0.3, delay: 0.03*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                    cell.center.y = cell.center.y - cell.frame.height / 2
                    cell.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    func updateCellValue(notification:NotificationModel)
    {
        if let index = notificationList.firstIndex(where: {$0.notificationID == notification.notificationID}) {
            notificationList[index].hasRead = 1
        }
        
        if let indexAll = allnotificationList.firstIndex(where: {$0.notificationID == notification.notificationID}) {
            allnotificationList[indexAll].hasRead = 1
        }
    }
    
    func redirectUser(notification:NotificationModel)
    {
        
        let string = notification.notificationMessage ?? ""
        let data = string.data(using: .utf8)!
        do {
            if let userInfo = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>
            {
               print(userInfo) // use the json here
                if userInfo["data"] as? [String:Any] != nil
                {
                    let type = userInfo["data"] as! [String:Any]
                   
                    if  type["type"] as? String  == "order"{
                    let entity_id = type["order_entity_id"] as? String
                    let order_id = type["order_increment_id"] as? String
                    let email_d = type["customer_email"] as? String
                    let dic = ["order_id":order_id
                               ,"email_d":email_d
                               ,"entity_id":entity_id]
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        
                
                let sideMenuController = (UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailVC_id") as? OrderDetailVC)!
                sideMenuController.orderId = order_id ?? ""
                sideMenuController.emailId = email_d ?? ""
                sideMenuController.entityId = entity_id ?? ""
                sideMenuController.isFromOrderSuccess = true
                self.navigationController?.pushViewController(sideMenuController, animated: true)
                    })
                }
                }
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        
        
    }
    func readNotification(notificationId:Int,handler:((Bool) -> Void)? = nil){
        self.view.endEditing(true)
        let api = Api.shared.readNotification
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "notificationId=\(notificationId)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            
            AF.request(completeUrl, method: api.method, parameters: ["notificationId":notificationId], encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                    self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool
                        else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            self.toastView(toastMessage: apiError.message ?? "Something went wrong. please try again",type: "error")
                        } catch {
                            self.toastView(toastMessage: "Something went wrong. please try again",type: "error")
                        }
                    }
                }
        }else{
            self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.readNotification(notificationId: notificationId)
            }, leftAction: {})
        }
    }
    
}
//MARK: END MHIOS-967
