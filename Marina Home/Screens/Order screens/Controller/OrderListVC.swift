//
//  OrderListVC.swift
//  Marina Home
//
//  Created by Eljo on 01/06/23.
//
//MARK START{MHIOS-1156}
//Added a botton constrain in UI
//MARK END{MHIOS-1156}
import UIKit

class OrderListVC: AppUIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet var btnback: UIButton!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var tblOrders: UITableView!
    //MARK START{MHIOS-1119}
    @IBOutlet weak var bottomSpaceHeight: NSLayoutConstraint!
    var isFromOrderSuccess:Bool = false
    //MARK END{MHIOS-1119}
    var orderlistArray:OrderList?
    var pageCount: Int = 1
    var isPageRefreshing:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyView.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let boldAttributes: [NSAttributedString.Key: Any] = [
           .font: AppFonts.LatoFont.Bold(13),
           .foregroundColor: AppColors.shared.Color_black_000000
        ]
        let regularAttributes: [NSAttributedString.Key: Any] = [
           .font: AppFonts.LatoFont.Regular(13),
           .foregroundColor: AppColors.shared.Color_black_000000
        ]
        var attributeString = NSMutableAttributedString(
           string: "From Empty to Extraordinary: ",
           attributes: boldAttributes)
        var attributeString1 = NSMutableAttributedString(
           string: "Write Your Furniture Story with Every Order!",
           attributes: regularAttributes)
         attributeString.append(attributeString1)
        self.lblDescription.attributedText = attributeString
        self.backActionLink(self.btnback)
        if UserData.shared.isLoggedIn{
            self.apiGetOrderList(page: 1){response in
                self.orderlistArray = response as OrderList
                if(self.orderlistArray?.items!.count ?? 0>0)
                {
                    self.emptyView.isHidden = true
                }
                else
                {
                    self.emptyView.isHidden = false
                }
                
                 
               
                self.tblOrders.reloadData()
            }
        }
        else
        {
            self.apiGetGuestOrderList(){response in
                self.orderlistArray = response as OrderList
                self.tblOrders.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    // Mark MHIOS-1157
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    // Mark MHIOS-1157
    override func viewWillAppear(_ animated: Bool) {
        //MARK START{MHIOS-1121}
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //MARK END{MHIOS-1121}
        self.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //MARK START{MHIOS-1156}
        if isFromOrderSuccess
        {
            bottomSpaceHeight.constant = self.tabBarController!.tabBar.frame.size.height
        }
        else
        {
            bottomSpaceHeight.constant = 0
        }
        //MARK END{MHIOS-1156}
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Order List Screen with values")
        CrashManager.shared.log("OrderList:  \(String(describing: orderlistArray))")
        CrashManager.shared.log("isPageRefreshing:  \(isPageRefreshing)")
        //MARK: END MHIOS-1225
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //MARK START{MHIOS-1121}
        if isFromOrderSuccess
        {
            self.navigationController?.popToRootViewController(animated: true)
            return false
        }
        else
        {
            return true
        }
        //MARK END{MHIOS-1121}
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.tblOrders.contentOffset.y >= ( self.tblOrders.contentSize.height -  self.tblOrders.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                print(pageCount)
                pageCount = pageCount + 1
                apiGetOrderList(page: pageCount){ response in
                        DispatchQueue.main.async {
                            print(response)
                            
                            self.isPageRefreshing = false
                            if(self.orderlistArray?.items!.count ?? 0>0)
                            {
                                self.emptyView.isHidden = true
                            }
                            else
                            {
                                self.emptyView.isHidden = false
                            }
                            
                            if(self.pageCount==1)
                            {
                                self.orderlistArray = response as OrderList
                                self.tblOrders.reloadData()
                            }
                            else
                            {
                                let pageItems = response.items
                                self.orderlistArray?.items?.append(contentsOf: pageItems!)
                                self.tblOrders.reloadData()
                                
                            }
                           
                            
                        }
                       
                    }
                
            }
        }
    }
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return 219
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 247//UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderlistArray?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //let cellData = wishlistArray[indexPath.item]
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTVC", for: indexPath) as? OrderListTVC else { return UITableViewCell() }
        
        let item:OrderListItem = (self.orderlistArray?.items?[indexPath.row])!
        
        cell.lblOrderId.text = "#\(item.increment_id ?? "")"
        cell.lblAdress.text = "\(item.billing_address?.street?.joined(separator: ",") ?? "") ,\(item.billing_address?.region ?? "")"
        let itemCount = "\(item.total_qty_ordered ?? 0)"
        if itemCount == "1"
        {
            cell.lblNoOfItems.text = "(\(itemCount) Item)"
        }
        else
        {
            cell.lblNoOfItems.text = "(\(itemCount) Items)"
        }
        //cell.lblNoOfItems.text = "(\(item.total_qty_ordered ?? 0) items)"
        let listGrandTotal = formatNumberToThousandsDecimal(number: Double(item.grand_total ?? 0))
        
        cell.lblTotal.text = "\(listGrandTotal) AED"
        cell.lblStatus.text = item.extensionAttributes?.statusLabel?.capitalized
        let greenColor = UIColor(red: 4/255, green: 173/255, blue: 4/255, alpha: 1)
        let greenIcon = UIImage(named: "Group 1524")
        let yellowColor = UIColor(red: 234/275, green: 164/255, blue: 0/255, alpha: 1)
        let yellowIcon = UIImage(named: "processing")
        let redColor = AppColors.shared.Color_red_FF0000
        let redIcon = UIImage(named: "cancelled")
        switch item.status?.lowercased() {
        case "delivered":
            cell.lblStatus.textColor = greenColor
            cell.imgProcessing.image = greenIcon
        case "processing":
            cell.lblStatus.textColor = greenColor
            cell.imgProcessing.image = greenIcon
        case "read_to_ship":
            cell.lblStatus.textColor = greenColor
            cell.imgProcessing.image = greenIcon
        case "complete":
            cell.lblStatus.textColor = greenColor
            cell.imgProcessing.image = greenIcon
        case "shipped":
            cell.lblStatus.textColor = greenColor
            cell.imgProcessing.image = greenIcon
        case "closed":
            cell.lblStatus.textColor = redColor
            cell.imgProcessing.image = redIcon
        case "canceled":
            cell.lblStatus.textColor = redColor
            cell.imgProcessing.image = redIcon
        default:
            cell.lblStatus.textColor = yellowColor
            cell.imgProcessing.image = yellowIcon
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //MARK: START MHIOS-1288
        var dateFromStr = dateFormatter.date(from: item.created_at ?? "2024-01-16 08:17:18")!
        //MARK: END MHIOS-1288
        
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        var timeFromDate = dateFormatter.string(from: dateFromStr)
        cell.lblDate.text = timeFromDate
        cell.selectionStyle = .none
        cell.btnViewDetails.tag = indexPath.row
        cell.btnViewDetails.addTarget(self, action: #selector(self.detailAction(_:)), for
        : .touchUpInside)
       return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let nextVC = AppController.shared.productDetailsImages
//        nextVC.productId = wishlistArray[indexPath.item].productId ?? ""
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @IBAction func back(_ sender: Any) {
      
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func StartOrdering(_ sender: Any) {
        var vc = AppController.shared.menuPLP
        vc.category_id =  "362"
        vc.roomtite = "NEW IN"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func detailAction(_ sender: UIButton) {
        let item:OrderListItem = (self.orderlistArray?.items?[sender.tag])!
        let nextVC = AppController.shared.orderDetail
        nextVC.orderId = item.increment_id ?? ""
        nextVC.emailId = item.billing_address?.email ?? ""
        nextVC.entityId = "\(item.entity_id ?? 0)"
        //MARK START{MHIOS-1119}
        nextVC.isFromOrderSuccess = isFromOrderSuccess
        //MARK END{MHIOS-1119}
        //nextVC.status = item.status
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

