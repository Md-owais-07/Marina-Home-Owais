//
//  DeliveryTimeVC.swift
//  Marina Home
//
//  Created by Codilar on 18/05/23.
//

import UIKit
import FSCalendar
class DeliveryTimeVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var customBGView: UIView!
    @IBOutlet weak var contentBGView: UIView!
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet weak var timeTable: UITableView!
    @IBOutlet weak var timeTableHeight: NSLayoutConstraint!
    //MARK: START MHIOS-1231
    var workingdays:[String] = []
    //MARK: END MHIOS-1231
    var address:Addresses?
    var maxDate:Date?
    var weekendDay1:Int = 0
    var weekendDay2:Int = 0
    var timeArray:[String] = ["Today, Feb 08, 2023", "Tomorrow, Feb 09, 2023", "Feb 10, 2023"]
    var selectedTime = 0
    var selectedDate = ""
    var max = 1000
    var min = 1
    var proceedClosure: ((_ time: String)->())!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calenderView.delegate = self
        self.calenderView.dataSource = self
        self.calenderView.scrollDirection = .vertical
        self.customBGView.alpha = 0
        self.contentBGView.alpha = 0
        self.contentBGView.clipsToBounds = true
        self.contentBGView.setCornerRadius(radius: 10)
        //timeTable.delegate = self
        //timeTable.dataSource = self
        //timeTable.register(UINib(nibName: "TimeSlotTVC", bundle: nil), forCellReuseIdentifier: "TimeSlotTVC_id")
       // timeTableHeight.constant = CGFloat(66*timeArray.count)
       
            
        var addressParam:[String:Any] = ["region":self.address?.region?.region ?? "",
                                             "country_id": "AE",
                                         "street": self.address?.street ?? [],
                                         "firstname": self.address?.firstname ?? "",
                                             // MARK: START MHIOS-1112
                                             "lastname": self.address?.lastname?.trimTrailingWhitespace() ?? "",
                                             // MARK: END MHIOS-1112
                                             "telephone": self.address?.telephone ?? "",
                                         "postcode": self.address?.postcode ?? "",
                                         "city": self.address?.city ?? ""]
             
        var fullParam:[String:Any] = ["address":addressParam,"useForShipping":true]
        if UserData.shared.isLoggedIn {
            self.apiAddBillingAdress(parameters: fullParam ){ response in
                self.hideActivityIndicator(uiView: self.view)
                self.apiGetDeliveryTimes(){ response in
                    if(response.count>0)
                    {
                        for s in response
                        {
                            if s.methodCode == AppInfo.shared.guestShipingCode
                            {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.shipingInfo = s
                                self.min = Int(s.extensionAttributes?.amdeliverydateChannelConfig?.min ?? 2)
                                self.max = Int(s.extensionAttributes?.amdeliverydateChannelConfig?.max ?? 2)
                               
                               //MARK: START MHIOS-1231
                                var dateNow = Date()
                                let zuluDateFormatter = DateFormatter()
                                zuluDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                zuluDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                                dateNow = zuluDateFormatter.date(from: s.extensionAttributes?.server_time ?? "2024-01-22T12:15:55.000Z") ?? Date()
                                let modifiedDate = Calendar.current.date(byAdding: .day, value: self.min, to: dateNow)!
                                //MARK: END MHIOS-1231
                                
                                //MARK: START MHIOS-1010
                                self.workingdays = s.extensionAttributes?.available_dates ?? [String]()
                                //MARK: END MHIOS-1010

                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                            
                              
                                if(self.selectedDate=="")
                                {
                                self.selectedDate = dateFormatter.string(from:modifiedDate)
                                self.calenderView.select(modifiedDate)
                                }
                                else
                                {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                let date =  dateFormatter.date(from:self.selectedDate)
                                self.calenderView.select(date)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.calenderView.reloadData()
                    }
                    
                    self.hideActivityIndicator(uiView: self.view)
                }
                
            }
        }
        else
        {
            self.apiAddGuestBillingAdress(parameters: fullParam ){ response in
                self.hideActivityIndicator(uiView: self.view)
                self.apiGuestDeliveryTimes(){ response in
    
                    if(response.count>0)
                    {
                        for s in response
                        {
                            if s.methodCode == AppInfo.shared.guestShipingCode
                            {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.shipingInfo = s
                                self.min = Int(s.extensionAttributes?.amdeliverydateChannelConfig?.min ?? 2)
                                self.max = Int(s.extensionAttributes?.amdeliverydateChannelConfig?.max ?? 2)
                               
                                //MARK: START MHIOS-1231
                                var dateNow = Date()
                                let zuluDateFormatter = DateFormatter()
                                zuluDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                zuluDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                                dateNow = zuluDateFormatter.date(from: s.extensionAttributes?.server_time ?? "2024-01-22T12:15:55.000Z") ?? Date()
                                
                                var modifiedDate = Calendar.current.date(byAdding: .day, value: self.min, to: dateNow)!
                                //MARK: END MHIOS-1231
                                
                                //MARK: START MHIOS-1010
                                self.workingdays = s.extensionAttributes?.available_dates ?? [String]()
                                //MARK: END MHIOS-1010

                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                              
                                if(self.selectedDate=="")
                                {
                                    self.selectedDate = dateFormatter.string(from:modifiedDate)
                                                                    self.calenderView.select(modifiedDate)
                                    //MARK: START MHIOS-1225
                                    CrashManager.shared.log("Selected Date: \(self.selectedDate)")
                                    //MARK: END MHIOS-1225
                                }
                                else
                                {
                                    //MARK: START MHIOS-1225
                                    CrashManager.shared.log("Selected Date: \(self.selectedDate)")
                                    //MARK: END MHIOS-1225
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd-MM-yyyy"
                                    let date = dateFormatter.date(from:self.selectedDate)
                                    self.calenderView.select(date)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.calenderView.reloadData()
                    }
                   
                    self.hideActivityIndicator(uiView: self.view)
                }
                
            }
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Delivery time Screen")
        //MARK: END MHIOS-1225
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.customBGView.alpha = 0.3
            self.contentBGView.alpha = 1.0
            self.view.layoutIfNeeded()
            self.changeMonthName()
            
           
        }
    }
    func changeMonthName(){
        let collectionView = self.calenderView.calendarHeaderView.value(forKey: "collectionView") as! UICollectionView

        collectionView.visibleCells.forEach { (cell) in
        let c = cell as! FSCalendarHeaderCell
                
        c.titleLabel.text = c.titleLabel.text?.uppercased()
        }
    }
    @IBAction private func proceedAction(_ sender: UIButton) {
        dismiss(completion: {
            self.proceedClosure(self.selectedDate)
        })
    }

    @IBAction private func closeAction(_ sender: UIButton) {
        dismiss(completion: {
        })
    }

    func dismiss(completion:(()->())? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.customBGView.alpha = 0
            self.contentBGView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (complete) in
            if complete {
                self.dismiss(animated: false) {
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }

    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = timeArray[indexPath.item]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotTVC_id", for: indexPath) as? TimeSlotTVC else { return UITableViewCell() }
        //cell.time.text = cellData
        cell.setSelectionStyle(isSelected: indexPath.item == selectedTime)
        cell.btnCalender.addTarget(self, action: #selector(self.CalenderAction(_:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTime = indexPath.item
        timeTable.reloadData()
    }
    @objc func CalenderAction(_ sender: UIButton) {
        
    }
}
//MARK: START MHIOS-1010

extension DeliveryTimeVC:FSCalendarDelegate,FSCalendarDataSource,
                         FSCalendarDelegateAppearance
//MARK: START MHIOS-1010
{
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        self.changeMonthName()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if !self.workingdays.contains(dateFormatter.string(from: date))
        {
            return .lightGray
        }
        
        return nil
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if !self.workingdays.contains(dateFormatter.string(from: date))
        {
            return false
        }
       else
        {
            return true
        }
    }
    //MARK: END MHIOS-1010

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.selectedDate = dateFormatter.string(from: date)
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    
        return 0
    }
   
    func minimumDate(for calendar: FSCalendar) -> Date {
        return  Calendar.current.date(byAdding: .day, value: min-1, to: Date()) ?? Date()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        Calendar.current.date(byAdding: .day, value: max, to: Date()) ?? Date()
    }
    
}



