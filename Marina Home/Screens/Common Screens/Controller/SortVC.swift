//
//  SortVC.swift
//  Marina Home
//
//  Created by Codilar on 04/05/23.
//
//MARK: START MHIOS-1202&1203
// Change the border type in no internet screen in commonScreen.storyboard
//MARK: END MHIOS-1202&1203
import UIKit
protocol sortProductProtocol {
    func sortproduct(option:String)
}
class SortVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var viewOptions: UIView!
    
    @IBAction func back(_ sender: Any) {
        //MARK: START MHIOS-1202&1203
        closePopup()
        //MARK: END MHIOS-1202&1203
       
    }
    @IBOutlet var tblSort: UITableView!
    var selectedSectionItem = "Relevance"
    var sortDelegate : sortProductProtocol?
    var sortSectionArray:[String] = ["Relevance","New In","Price - Low To High","Price - High To Low"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.hideTabBar(isHidden: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //MARK: START MHIOS-1202&1203
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: nil)
        //MARK: END MHIOS-1202&1203
        // Do any additional setup after loading the view.
    }
    //MARK: START MHIOS-1202&1203
    @objc func internetChanged(note:Notification) {
        
        let reachability =  note.object as! InternetReachability
        if reachability.connection != .none {
            
            // Internet Is ON
            
        } else {
            
            closePopup()
        }
    }
    func closePopup()
    {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.tabBarController?.hideTabBar(isHidden: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    //MARK: END MHIOS-1202&1203
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 56
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortSectionArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cellData = sortSectionArray[indexPath.item]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortTVC", for: indexPath) as? SortTVC else { return UITableViewCell() }
        cell.lblName.text = cellData
        cell.setSelectionStyle(isSelected: cellData == selectedSectionItem)
        cell.selectionStyle = .none
            return cell
       
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = sortSectionArray[indexPath.item]
        self.selectedSectionItem = cellData
        tblSort.reloadData()
        
    }

    @IBAction func showResult(_ sender: Any) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Sort Screen option: \(selectedSectionItem)")
        //MARK: END MHIOS-1225
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.sortDelegate?.sortproduct(option: selectedSectionItem)
        self.tabBarController?.hideTabBar(isHidden: true)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

