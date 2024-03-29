//
//  OrderDetailVC.swift
//  Marina Home
//
//  Created by Eljo on 03/06/23.
//
//MARK START{MHIOS-1119}
//Created bottom Space Height view in UI
//MARK END{MHIOS-1119}
///////MARK START{MHIOS-1215}
///Changed the  productDefault image to product_placeholder_img in UI side
/////MARK END{MHIOS-1215}

import UIKit

//MARK START{MHIOS-1121}
class OrderDetailVC: AppUIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    //MARK END{MHIOS-1121}
    @IBOutlet var ImGoutforDeiver: UIImageView!
    @IBOutlet var viewDelivered: UIView!
    @IBOutlet var imgDeliverd: UIImageView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var imgShiped: UIImageView!
    @IBOutlet var imgProcessd: UIImageView!
    //MARK: START MHIOS-1234
    @IBOutlet weak var btnOrderReturn: UIButton!
    //MARK: START MHIOS-1234
    @IBOutlet var imgOrderConfirm: UIImageView!
    @IBOutlet var tblHieghtConstraint: NSLayoutConstraint!
    @IBOutlet var tblItems: UITableView!
    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblreadyToShip: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblAdress: UILabel!
    @IBOutlet var lblOrderProcessedTack: UIView!
    @IBOutlet var lblOrderShipedTack: UIView!
    @IBOutlet var lblOrderConfirmTack: UIView!
    @IBOutlet var lblShipped: UILabel!
    @IBOutlet var lblDelivered: UILabel!
    @IBOutlet var returnPossibleLbl: UILabel!
    @IBOutlet var lblOutForDelivery: UILabel!
    @IBOutlet var lblOrderConfirmed: UILabel!
    @IBOutlet var imProcessing: UIImageView!
    @IBOutlet var lblStaus: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblNumberOfItems: UILabel!
    @IBOutlet var lblOrderNumber: UILabel!
   // return details
    @IBOutlet weak var returnDetailsView: UIStackView!
    @IBOutlet weak var returnListingTable: UITableView!
    @IBOutlet weak var returnListingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var showDetailsButtonView: UIView!
    @IBOutlet weak var detailsView: UIStackView!
    @IBOutlet weak var returnReqView: UIStackView!
    @IBOutlet var orderTrakingSectionView: UIView!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var discountPriceView: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var shippingLblView: UILabel!
    @IBOutlet var lblOrderTotal: UILabel!
    @IBOutlet var lblSubTotal: UILabel!
    //MARK START{MHIOS-1119}
    @IBOutlet weak var bottomSpaceHeight: NSLayoutConstraint!
    var isFromOrderSuccess:Bool = false
    //MARK END{MHIOS-1119}
    var isFromGuest:Bool = false
    var detail:OrderDeatil?
    var trackingDetail:OrderTrackingDeatil?
    var orderReturnDetails:ReturnItemsModel?
    var orderId:String = ""
    var entityId = ""
    var emailId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        returnListingTable.delegate = self
        returnListingTable.dataSource = self
        returnListingTable.register(UINib(nibName: "ReturnItemWithStatusTVC", bundle: nil), forCellReuseIdentifier: "ReturnItemWithStatusTVC_id")
        returnListingTable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.backActionLink(self.btnBack)
        if UserData.shared.isLoggedIn{
            self.loginView.isHidden = true
        }
        
       
    }
    override func viewWillAppear(_ animated: Bool)
    {
        //MARK START{MHIOS-1121}
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //MARK END{MHIOS-1121}
        //MARK START{MHIOS-1119}
        if isFromOrderSuccess
        {
            bottomSpaceHeight.constant = self.tabBarController!.tabBar.frame.size.height
        }
        else
        {
            bottomSpaceHeight.constant = 0
        }
        //MARK END{MHIOS-1119}
        if UserData.shared.isLoggedIn{
            self.loginView.isHidden = true
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Order Detail Screen with values")
        CrashManager.shared.log("isFromOrderSuccess:  \(isFromOrderSuccess)")
        CrashManager.shared.log("isFromGuest:  \(isFromGuest)")
        CrashManager.shared.log("OrderDetails:  \(String(describing: detail))")
        CrashManager.shared.log("OrderTrackingDeatil:  \(String(describing: trackingDetail))")
        CrashManager.shared.log("ReturnItemsModel:  \(String(describing: orderReturnDetails))")
        CrashManager.shared.log("orderId:  \(orderId)")
        CrashManager.shared.log("entityId:  \(entityId)")
        CrashManager.shared.log("emailId:  \(emailId)")
        //MARK: END MHIOS-1225
    }
    //MARK START{MHIOS-1121}
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // Allow default navigation behavior
    }
    //MARK END{MHIOS-1121}
    override func viewDidAppear(_ animated: Bool) {
        if UserData.shared.isLoggedIn{
            self.loginView.isHidden = true
        }
        self.orderId = self.orderId.uppercased()
        self.apiGetOrderDetail(orderId: self.orderId, email: emailId ){response in
            DispatchQueue.main.async {
                self.detail = response
                self.UpdateUI()
                //MARK: START MHIOS-960
                if !UserData.shared.isLoggedIn
                {
                    self.entityId = "\(response.items?.first?.items?[0].order_id ?? 0)"
                }
                self.getReturnDetails(orderId: self.entityId, isLoggedIn: UserData.shared.isLoggedIn){ orderReturnResponse in
                //MARK: END MHIOS-960
                    DispatchQueue.main.async {
                        self.orderReturnDetails = orderReturnResponse
                        self.detail = response
                        self.apiGetOrderTrackingDetail(orderId: self.orderId, emailId: self.emailId ){response in
                            self.trackingDetail = response
                            self.UpdateUI()
                        }
                        let count  = self.detail?.items?.first?.items?.count
                        let heigt = (count ?? 1)*100;
                        self.tblHieghtConstraint.constant = CGFloat(heigt)
                        
                        let discount = self.detail?.items?.first?.discount_amount ?? 0
                        if discount != 0
                        {
                            self.discountPrice.text = "\(self.formatNumberToThousandsDecimal(number: discount )) AED"
                            self.discountPrice.isHidden = false
                            self.discountPriceView.isHidden = false
                        }
                        else
                        {
                            self.discountPrice.isHidden = true
                            self.discountPriceView.isHidden = true
                        }
                        
                        let delivery = self.detail?.items?.first?.shipping_incl_tax ?? 0
                        if delivery == 0
                        {
                            self.deliveryLbl.text = "FREE"
                        }
                        else 
                        {
                            self.deliveryLbl.text = "\(self.formatNumberToThousandsDecimal(number:delivery)) AED"
                        }
                        self.lblOrderTotal.text = "\(self.formatNumberToThousandsDecimal(number:self.detail?.items?.first?.grand_total ?? 0 )) AED"
                        self.lblSubTotal.text = "\(self.formatNumberToThousandsDecimal(number:self.detail?.items?.first?.subtotal_incl_tax ?? 0 )) AED"
                        
                        self.UpdateUI()
                        self.tblItems.reloadData()
                        self.returnListingTable.reloadData()
                        self.returnDetailsView.isHidden = self.orderReturnDetails?.items?.isEmpty ?? true
                        self.showDetailsButtonView.isHidden = (self.orderReturnDetails?.items?.isEmpty ?? true)
                        self.detailsView.isHidden = !(self.orderReturnDetails?.items?.isEmpty ?? true)
                    }
                }
            }
        }
        // Mark MHIOS-1157
        self.tabBarController?.tabBar.isHidden = false
        // Mark MHIOS-1157
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        returnListingTable.layer.removeAllAnimations()
        returnListingTableHeight.constant = returnListingTable.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }

    func setOrderStatus(status:String){
        let greenColor = UIColor(red: 4/255, green: 173/255, blue: 4/255, alpha: 1)
        let greenIcon = UIImage(named: "Group 1524")
        let yellowColor = UIColor(red: 234/275, green: 164/255, blue: 0/255, alpha: 1)
        let yellowIcon = UIImage(named: "processing")
        let redColor = AppColors.shared.Color_red_FF0000
        let redIcon = UIImage(named: "cancelled")

        lblStaus.text = self.detail?.items?.first?.extensionAttributes?.statusLabel?.capitalized

        switch self.detail?.items?.first?.status ?? "".lowercased() {
        case "delivered":
            lblStaus.textColor = greenColor
            imProcessing.image = greenIcon
        case "processing":
            lblStaus.textColor = greenColor
            imProcessing.image = greenIcon
        case "shipped":
            lblStaus.textColor = greenColor
            imProcessing.image = greenIcon
        case "read_to_ship":
            lblStaus.textColor = greenColor
            imProcessing.image = greenIcon
        case "complete":
            lblStaus.textColor = greenColor
            imProcessing.image = greenIcon
        case "closed":
            lblStaus.textColor = redColor
            imProcessing.image = redIcon
        case "canceled":
            lblStaus.textColor = redColor
            imProcessing.image = redIcon
        default:
            lblStaus.textColor = yellowColor
            imProcessing.image = yellowIcon
        }

        switch status.lowercased() {
        case "draft":
            self.imgOrderConfirm.image = greenIcon
            self.orderTrakingSectionView.isHidden = false
        case "booked":
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.booked{
                self.lblreadyToShip.attributedText = self.setShippingStatusText(status: "Ready to ship", dateString: trackStatus)
            }else{
                self.lblreadyToShip.text = "Ready to ship"
            }
            self.lblOrderConfirmTack.backgroundColor =  greenColor
            self.imgOrderConfirm.image = greenIcon
            self.imgProcessd.image = greenIcon
            self.orderTrakingSectionView.isHidden = false
        case "ready_to_ship":
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.ready_to_ship {
                self.lblreadyToShip.attributedText = self.setShippingStatusText(status: "Ready to ship", dateString: trackStatus)
            }else{
                self.lblreadyToShip.text = "Ready to ship"
            }
            self.lblOrderConfirmTack.backgroundColor =  greenColor
            self.imgOrderConfirm.image = greenIcon
            self.imgProcessd.image = greenIcon
            self.orderTrakingSectionView.isHidden = false
        case "shipped":
            //ready_to_ship
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.ready_to_ship{
                self.lblreadyToShip.attributedText = self.setShippingStatusText(status: "Ready to ship", dateString: trackStatus)
            }else{
                self.lblreadyToShip.text = "Ready to ship"
            }
            //shipped
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.shipped{
                self.lblShipped.attributedText = self.setShippingStatusText(status: "Shipped", dateString: trackStatus)
            }else{
                self.lblShipped.text = "Shipped"
            }
            self.lblOrderProcessedTack.backgroundColor = greenColor
            self.lblOrderConfirmTack.backgroundColor = greenColor
            self.imgOrderConfirm.image = greenIcon
            self.imgProcessd.image = greenIcon
            self.imgShiped.image = greenIcon
            self.orderTrakingSectionView.isHidden = false
        case "out_for_delivery":
            //ready_to_ship
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.ready_to_ship{
                self.lblreadyToShip.attributedText = self.setShippingStatusText(status: "Ready to ship", dateString: trackStatus)
            }else{
                self.lblreadyToShip.text = "Ready to ship"
            }
            //shipped
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.shipped{
                self.lblShipped.attributedText = self.setShippingStatusText(status: "Shipped", dateString: trackStatus)
            }else{
                self.lblShipped.text = "Shipped"
            }
            //out_for_delivery
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.out_for_delivery{
                self.lblOutForDelivery.attributedText = self.setShippingStatusText(status: "Out for delivery", dateString: trackStatus)
            }else{
                self.lblOutForDelivery.text = "Out for delivery"
            }
            self.lblOrderProcessedTack.backgroundColor = greenColor
            self.lblOrderConfirmTack.backgroundColor = greenColor
            self.lblOrderShipedTack.backgroundColor = greenColor
            self.imgOrderConfirm.image = greenIcon
            self.imgProcessd.image = greenIcon
            self.imgShiped.image = greenIcon
            self.ImGoutforDeiver.image = greenIcon
            self.orderTrakingSectionView.isHidden = false
        case "delivered":
            //ready_to_ship
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.ready_to_ship{
                self.lblreadyToShip.attributedText = self.setShippingStatusText(status: "Ready to ship", dateString: trackStatus)
            }
            else{
                self.lblreadyToShip.text = "Ready to ship"
            }
            //shipped
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.shipped{
                self.lblShipped.attributedText = self.setShippingStatusText(status: "Shipped", dateString: trackStatus)
            }else{
                self.lblShipped.text = "Shipped"
            }
            //out_for_delivery
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.out_for_delivery{
                self.lblOutForDelivery.attributedText = self.setShippingStatusText(status: "Out for delivery", dateString: trackStatus)
            }else{
                self.lblOutForDelivery.text = "Out for delivery"
            }
            //delivered
            if let trackStatus = self.trackingDetail?.postShippingInfo?.keyMilestones?.delivered{
                self.lblDelivered.attributedText = self.setShippingStatusText(status: "Delivered", dateString: trackStatus)
            }else{
                self.lblDelivered.text = "Delivered"
            }
            self.lblOrderProcessedTack.backgroundColor = greenColor
            self.lblOrderConfirmTack.backgroundColor = greenColor
            self.lblOrderShipedTack.backgroundColor = greenColor
            self.viewDelivered.backgroundColor = greenColor
            self.imgOrderConfirm.image = greenIcon
            self.imgProcessd.image = greenIcon
            self.imgShiped.image = greenIcon
            self.ImGoutforDeiver.image = greenIcon
            self.imgDeliverd.image = greenIcon
            
            self.apigetReturnRequestInfo(orderId:self.detail?.items?.first?.items?.first?.order_id ?? 0){ response in
                 response
                var retunableStatus = false
                let arry = self.detail?.items?.first?.items ?? []
                for  var item in arry {
                    var returnableQty = 0
                    var isRetunable = false
                    let dic = response[ "\(item.product_id ?? 0)"] as! [String:Any]
                    for (key, value) in dic {
                        if key == "returnable"  {
                            isRetunable = value as! Bool
                        }
                        if key == "returnableqty"  {
                            returnableQty = value as! Int
                        }
                    }
                    
                    if isRetunable && returnableQty > 0 {
                        retunableStatus = true
                        break
                    }
                }
                //MARK: START MHIOS-1234
                self.returnReqView.isHidden = false
                if(retunableStatus) {
                    self.btnOrderReturn .isUserInteractionEnabled = true
                    self.returnPossibleLbl.text = self.detail?.items?.first?.items?.first?.extensionAttributes?.return_possible_date ?? ""
                }
                else
                {
                    if self.orderReturnDetails?.items?.count ?? 0 > 0
                    {
                        let order = self.orderReturnDetails?.items?[0]
                        let txt = "Return requested on: "
                        let returnDate = self.convertDateFormater(date: order?.created_at ?? "",neededFormat: "dd-MMM-yyyy")
                        self.btnOrderReturn .isUserInteractionEnabled = false
                        let returnText = "Return is already requested."
                        self.returnPossibleLbl.text = returnDate == "" ?  returnText : txt + returnDate
                    }
                    else
                    {
                        let txt = self.detail?.items?.first?.items?.first?.extensionAttributes?.return_possible_date ?? ""
                        let returnDate = txt.components(separatedBy: "Eligible for return until")
                        self.btnOrderReturn .isUserInteractionEnabled = false
                        var returnText = "This order is not eligible for return."
                        if returnDate.count > 1
                        {
                            returnText = "Return window closed on\(returnDate[1])"
                        }
                        self.returnPossibleLbl.text = returnText
                    }

                }
                //MARK: START MHIOS-1234
            }
           
            self.orderTrakingSectionView.isHidden = false
        case "cancelled":
            orderTrakingSectionView.isHidden = true
        default:
            orderTrakingSectionView.isHidden = true
        }

        let finalcheckStatus = self.detail?.items?.first?.status ?? "".lowercased()
        if finalcheckStatus == "pending_payment" || finalcheckStatus == "payment_review" || finalcheckStatus == "pending" || finalcheckStatus == "canceled"{
            orderTrakingSectionView.isHidden = true
        }
    }


    func UpdateUI()
    {
        
        self.lblOrderNumber.text = "#\(self.orderId)"
        let joined = self.detail?.items?.first?.billing_address?.street?.joined(separator: ", ")
        self.lblAdress.text = "\(joined ?? "") ,\(self.detail?.items?.first?.billing_address?.region ?? "")"
        let itemCount = "\(self.detail?.items?.first?.total_qty_ordered ?? 0)"
        if itemCount == "1"
        {
            self.lblNumberOfItems.text = "(\(itemCount) Item)"
        }
        else
        {
            self.lblNumberOfItems.text = "(\(itemCount) Items)"
        }
        
        self.lblDate.text = convertDateFormater(date: self.detail?.items?.first?.created_at ?? "",neededFormat: "dd-MMM-yyyy")
        
        //MARK: START MHIOS-1228
        var timeFromDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateFromStr = dateFormatter.date(from: self.detail?.items?.first?.created_at ?? "")
        {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            timeFromDate = dateFormatter.string(from: dateFromStr)
            
        }
        //MARK: END MHIOS-1228
        
        self.lblOrderConfirmed.attributedText = self.getAttributedStatus(status:"Order Confirmed" , date: timeFromDate)
        self.setOrderStatus(status: self.trackingDetail?.postShippingInfo?.status ?? "")
    }
    @IBAction func OrderReturn(_ sender: Any) {
        let nextVC = AppController.shared.orderReturn
        nextVC.orderDetails = self.detail
        nextVC.entityId = self.entityId
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func showHideDetailsAction(_ sender: UIButton) {
        self.detailsView.isHidden = !self.detailsView.isHidden
        sender.setTitle(self.detailsView.isHidden ? "SHOW ORDER DETAILS" : "HIDE ORDER DETAILS", for: .normal)
        sender.setImage(UIImage(named: self.detailsView.isHidden ? "down_arrow" : "up_arrow"), for: .normal)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblItems{
            return 100
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblItems{
            return 100
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblItems{
            return self.detail?.items?.first?.items?.count ?? 0
        }else{
            return self.orderReturnDetails?.items?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblItems{
            //let cellData = wishlistArray[indexPath.item]
            let item: OrderDetailItems = (self.detail?.items?.first?.items?[indexPath.row])!
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as? OrderItemCell else { return UITableViewCell() }
            
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
            let animatedGif = UIImage.sd_image(withGIFData: imageData)
            
            
            let originalPrice = item.original_price ?? 0
            let priceIncTax = item.price_incl_tax ?? 0
            let hasOffer = priceIncTax < originalPrice
            let stringToStrike = " \(formatNumberToThousandsDecimal(number: originalPrice) + " AED") "
            let mainString = "\(formatNumberToThousandsDecimal(number: priceIncTax ) + " AED") \(stringToStrike)"
            let range = (mainString as NSString).range(of: stringToStrike)
            let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
            mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
            cell.lblName.attributedText = item.name?.htmlToAttributedString()
            if hasOffer{
                cell.lblPrice.attributedText = mutableAttributedString
            }else{
                cell.lblPrice.text = "\(formatNumberToThousandsDecimal(number: priceIncTax) + " AED")"
                cell.lblPrice.textColor = .black
            }
            cell.lblQuantity.text = "Quantity: \(String(format: "%d", item.qty_ordered!))"
            print("\(AppInfo.shared.productImageURL)\(item.extensionAttributes?.image ?? "")")
            cell.lblType.text = item.extensionAttributes?.shortDescription
            //cell.imgItem.sd_setImage(with: URL(string: "\(AppInfo.shared.productImageURL)\(item.extensionAttributes?.image ?? "")"),placeholderImage: animatedGif)
            let placeholderImage = UIImage(named: "failure_image.png")
            cell.imgItem.image = placeholderImage
            //MARK START{MHIOS-1215}
            let imageExt = "\(item.extensionAttributes?.image ?? "")"
            if imageExt != "" && imageExt != "no_selection"
            {
                let imageMain = "\(AppInfo.shared.productImageURL)\(imageExt)"
                let url = URL(string: imageMain)
                if let imageUr = url
                {
                    // Load the image with Kingfisher and handle the result
                    cell.imgItem.kf.setImage(with: url, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            // The image loaded successfully, and `value.image` contains the loaded image.
                            cell.imgItem.image = value.image
                        case .failure(let error):
                            // An error occurred while loading the image.
                            // You can handle the failure here, for example, by displaying a default image.
                            cell.imgItem.image = placeholderImage
                            print("Image loading failed with error: \(error)")
                        }
                    }
                }
            }

            //MARK START{MHIOS-1215}
            else
            {
                cell.imgItem.image = placeholderImage
            }
            //MARK END{MHIOS-1215}
            cell.selectionStyle = .none
            return cell
        }else{
            let cellData = self.orderReturnDetails?.items?[indexPath.item]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnItemWithStatusTVC_id", for: indexPath) as? ReturnItemWithStatusTVC else { return UITableViewCell() }
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
            let animatedGif = UIImage.sd_image(withGIFData: imageData)
            cell.itemImageView.image = animatedGif
            cell.itemTitleLbl.attributedText = (cellData?.request_item?.first?.name ?? "").htmlToAttributedString()
            cell.itemQtyLbl.text = "\(cellData?.request_item?.first?.qty_rma ?? 0)"
            cell.itemDateLbl.text = convertDateFormater(date: cellData?.created_at ?? "",neededFormat: "dd-MMM-yyyy")
            let greenColor = UIColor(red: 4/255, green: 173/255, blue: 4/255, alpha: 1)
            let greenIcon = UIImage(named: "Group 1524")
            let yellowColor = UIColor(red: 234/275, green: 164/255, blue: 0/255, alpha: 1)
            let yellowIcon = UIImage(named: "processing")
            let redColor = AppColors.shared.Color_red_FF0000
            let redIcon = UIImage(named: "cancelled")
            //MARK: START MHIOS-1265
            if cellData?.rma_status?.lowercased() == "new" || cellData?.rma_status?.lowercased() == "pending" || cellData?.rma_status?.lowercased() == "received" || cellData?.rma_status?.lowercased() == "processing" || cellData?.rma_status?.lowercased() == "sustomer service"
            {
                cell.itemStatusTextLbl.text = "Processing"
            }
            else
            {
                cell.itemStatusTextLbl.text = (cellData?.rma_status ?? "Processing").capitalized
            }
            //MARK: END MHIOS-1265

            switch cellData?.rma_status ?? "New" {
            case "Completed":
                cell.itemStatusIconView.image = greenIcon
                cell.itemStatusTextLbl.textColor = greenColor
            case "Canceled":
                cell.itemStatusIconView.image = redIcon
                cell.itemStatusTextLbl.textColor = redColor
            case "Rejected":
                cell.itemStatusIconView.image = redIcon
                cell.itemStatusTextLbl.textColor = redColor
            default:
                cell.itemStatusIconView.image = yellowIcon
                cell.itemStatusTextLbl.textColor = yellowColor
            }
            if cellData?.is_canceled ?? 0 == 1{
                cell.itemStatusIconView.image = redIcon
                cell.itemStatusTextLbl.textColor = redColor
                cell.itemStatusTextLbl.text = "Canceled"
            }
            //cell.itemImageView.sd_setImage(with: URL(string: "\(AppInfo.shared.gumletProductImageURL)\(cellData?.request_item?.first?.image ?? "")"),placeholderImage: animatedGif)
            let placeholderImage = UIImage(named: "failure_image.png")
            cell.itemImageView.image = placeholderImage
            //MARK START{MHIOS-1215}
            let imageExt = "\(cellData?.request_item?.first?.image ?? "")"
            let imageMain = "\(AppInfo.shared.gumletProductImageURL)\(imageExt)"
            if imageExt != "" && imageExt != "no_selection"
            {
                let url = URL(string: imageMain)
                if let imageUr = url
                {
                    // Load the image with Kingfisher and handle the result
                    cell.itemImageView.kf.setImage(with: url, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            // The image loaded successfully, and `value.image` contains the loaded image.
                            cell.itemImageView.image = value.image
                        case .failure(let error):
                            // An error occurred while loading the image.
                            // You can handle the failure here, for example, by displaying a default image.
                            cell.itemImageView.image = placeholderImage
                            print("Image loading failed with error: \(error)")
                        }
                    }
                }
            }

            //MARK START{MHIOS-1215}
            else
            {
                cell.itemImageView.image = placeholderImage
            }
            //MARK END{MHIOS-1215}
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblItems{
            let item: OrderDetailItems = (self.detail?.items?.first?.items?[indexPath.row])!
            let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = item.sku ?? ""
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else
        {
            let nextVC = AppController.shared.returnOrderTracking
            nextVC.entityId = self.entityId
            nextVC.requestId = self.orderReturnDetails?.items?[indexPath.item].request_id ?? 0
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @IBAction func contactUSAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.contactUs
        vc.ScreenTitle = "CONTACT US"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
    }
}



