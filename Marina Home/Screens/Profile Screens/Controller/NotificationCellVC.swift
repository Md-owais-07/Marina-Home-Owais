//
//  NotificationCellVC.swift
//  Marina Home
//
//  Created by Mohammad Owais on 29/03/24.
//

import UIKit
import Alamofire

class NotificationCellVC: AppUIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationToggle: UISwitch!
    @IBOutlet weak var backButton: UIButton!
    
    var apiResullt: [NotificationDataModel] = []
    var filteredNotifications: [NotificationDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        backActionLink(backButton)
        tableView.register(UINib(nibName: "CellNotificationTableCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        fetchData { apiData in
            self.apiResullt = apiData
            self.filteredNotifications = apiData
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func switchNotification(_ sender: UISwitch) {
        if sender.isOn {
            // Show only unread notifications
            filteredNotifications = apiResullt.filter { !($0.hasRead ?? true) }
        } else {
            // Show all notifications
            filteredNotifications = apiResullt
        }
        tableView.reloadData()
    }
}

extension NotificationCellVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellNotificationTableCell else { return UITableViewCell() }
        
        let cellData = self.filteredNotifications
        cell.boldLabel.text = cellData[indexPath.row].notificationTitle
        cell.regularLabel.text = cellData[indexPath.row].notificationBody
        
        if (cellData[indexPath.row].hasRead ?? true) {
            cell.boldLabel.font = .systemFont(ofSize: 13, weight: .bold)
            cell.roundView.isHidden = false
        } else {
            cell.boldLabel.text = cellData[indexPath.row].notificationTitle
            cell.boldLabel.font = .systemFont(ofSize: 13, weight: .regular)
            cell.roundView.isHidden = true
        }
        return cell
    }
    
}
