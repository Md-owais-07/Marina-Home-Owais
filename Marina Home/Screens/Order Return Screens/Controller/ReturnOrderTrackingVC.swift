//
//  ReturnOrderTrackingVC.swift
//  Marina Home
//
//  Created by Sooraj R on 26/07/23.
//

import UIKit

class ReturnOrderTrackingVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var listingTableHeight: NSLayoutConstraint!
    @IBOutlet var cancelRequestViews: [UIView]!
    @IBOutlet weak var trackReturnView: UIView!
    @IBOutlet weak var returnItemsView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var returnItemsTitleLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var totalItemsCountLbl: UILabel!
    @IBOutlet weak var createdDateLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    //MARK: START MHIOS-1218
    @IBOutlet weak var btnCancelReturnRequest: AppBorderButton!
    //MARK: END MHIOS-1218

    @IBOutlet weak var trackDate: UILabel!
    @IBOutlet weak var trackText: UILabel!
    @IBOutlet weak var trackPoint: UIImageView!
    @IBOutlet weak var trackPipeView: UIView!
    //MARK: START MHIOS-1265
    @IBOutlet weak var textFinalStatus: UILabel!
    @IBOutlet weak var viewFinalBorder: UIView!
    @IBOutlet weak var iconFinalResult: UIImageView!
    @IBOutlet weak var viewFinalStatus: UIView!
    //MARK: END MHIOS-1265
    var orderReturnDetails:ReturnItems?
    var isCancelled = false
    var entityId = ""
    var requestId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backActionLink(backButton)
        listingTable.delegate = self
        listingTable.dataSource = self
        listingTable.register(UINib(nibName: "ReturnInformationTVC", bundle: nil), forCellReuseIdentifier: "ReturnInformationTVC_id")
        listingTable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        getReturnDetailsApi()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Return Order Tracking Screen with values")
        CrashManager.shared.log("Order Return Details: \(String(describing: orderReturnDetails))")
        CrashManager.shared.log("isCancelled: \(isCancelled)")
        CrashManager.shared.log("entityId: \(entityId)")
        CrashManager.shared.log("requestId: \(requestId)")
        //MARK: END MHIOS-1225
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        listingTable.layer.removeAllAnimations()
        listingTableHeight.constant = listingTable.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }

    @IBAction func cancelRequestAction(_ sender: UIButton) {
        //MARK: START MHIOS-1218
        if let status = self.orderReturnDetails?.isReturnRequestEligible
        {
            if !status{
                if self.orderReturnDetails?.rma_status?.lowercased() == "completed"
                {
                    self.toastView(toastMessage: "Your return request is \(self.orderReturnDetails?.rma_status?.lowercased() ?? "completed")",type: "warning")
                }
                else
                {
                    self.toastView(toastMessage: "Your return request is currently in \(self.orderReturnDetails?.rma_status?.lowercased() ?? "processing")",type: "warning")
                }
            }
            else
            {
                self.openCancelReqScreen()
            }
        }
        else
        {
            self.openCancelReqScreen()
        
        }
        //MARK: END MHIOS-1218
    }
    
    //MARK: START MHIOS-1218
   func openCancelReqScreen()
    {
            
            let popUpVC = AppController.shared.returnRequestCancel
            popUpVC.modalTransitionStyle = .crossDissolve
            popUpVC.modalPresentationStyle = .overCurrentContext
            popUpVC.requestId = self.orderReturnDetails?.request_id ?? 0
            popUpVC.deleteClosure = {
                self.isCancelled = true
                self.checkCancelledView()
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
        
    }
    //MARK: END MHIOS-1218
    @IBAction func contactUSAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.web
        vc.hidesBottomBarWhenPushed = true
        vc.urlString = appDelegate.returnAndExchange
        vc.ScreenTitle = "CONTACT US"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkCancelledView(){
        if isCancelled {
            self.setPipeLine(status: "Canceled")
            for item in cancelRequestViews{
                item.isHidden = true
            }
           // trackPipeView.setBackgroundColor(color: UIColor(red: 4/255, green: 173/255, blue: 4/255, alpha: 1))
            mainStackView.removeArrangedSubview(returnItemsView)
            mainStackView.removeArrangedSubview(trackReturnView)
            mainStackView.setNeedsLayout()
            mainStackView.layoutIfNeeded()

            mainStackView.insertArrangedSubview(returnItemsView, at: 2)
            mainStackView.insertArrangedSubview(trackReturnView, at: 6)
            mainStackView.setNeedsLayout()

            returnItemsTitleLbl.text = "RETURN ORDER DETAILS"
            listingTable.reloadData()
        }
    }

    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderReturnDetails?.request_item?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = orderReturnDetails?.request_item?[indexPath.item]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnInformationTVC_id", for: indexPath) as? ReturnInformationTVC else { return UITableViewCell() }
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
        let animatedGif = UIImage.sd_image(withGIFData: imageData)
        ///cell.itemImageView.image = animatedGif
        cell.returnInfoView.isHidden = isCancelled
        //cell.itemImageView.sd_setImage(with: URL(string: "\(AppInfo.shared.gumletProductImageURL)\(cellData?.image ?? "")"),placeholderImage: animatedGif)
        let placeholderImage = UIImage(named: "failure_image.png")
        cell.itemImageView.image = placeholderImage
        //MARK START{MHIOS-1248}
        let imageExt = "\(cellData?.image ?? "")"
        if imageExt != "" && imageExt != "no_selection"
        {
            let imageMain = "\(AppInfo.shared.gumletProductImageURL)\(imageExt)"
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
        cell.itemTitleLbl.attributedText = (cellData?.name ?? "").htmlToAttributedString()
        cell.itemQtyLbl.text = "\(cellData?.qty_rma ?? 1)"
        cell.itemPriceLbl.text = "\(formatNumberToThousandsDecimal(number: cellData?.price ?? 0) ) AED"
        cell.reasonLbl.text = cellData?.reason ?? ""
        cell.solutionLbl.text = cellData?.solution ?? ""
        cell.conditionLbl.text = getCondition(input: cellData?.additional_fields ?? "")
        return cell
    }

    func getCondition(input:String)->String{
        if let data = input.data(using: .utf8){
            do{
                let myJson = try JSONSerialization.jsonObject(with: data,
                                                              options: JSONSerialization.ReadingOptions.allowFragments) as Any
                if let dict = myJson as? [[String: Any]] {
                    return dict.first?["content"] as? String ?? ""
                }else{
                    return ""
                }
            }catch{
                return ""
            }
        }else{
            return ""
        }
    }

    func setPipeLine(status:String){
        let greenColor = UIColor(red: 4/255, green: 173/255, blue: 4/255, alpha: 1)
        let greenIcon = UIImage(named: "Group 1524")
        let yellowColor = UIColor(red: 234/275, green: 164/255, blue: 0/255, alpha: 1)
        let yellowIcon = UIImage(named: "processing")
        let redColor = AppColors.shared.Color_red_FF0000
        let redIcon = UIImage(named: "cancelled")

        //MARK: START MHIOS-1218
        if let status = orderReturnDetails?.isReturnRequestEligible
        {
           if !status
            {
               self.btnCancelReturnRequest.setTitleColor(AppColors.shared.Color_darkGray_8C8C8C, for: .normal)
               self.btnCancelReturnRequest.layer.borderColor = AppColors.shared.Color_darkGray_8C8C8C.cgColor
           }
            
        }
        //MARK: END MHIOS-1218
        
       // MARK: START MHIOS-1265
        var returnStatus = ""
        
        if status.lowercased() == "new" || status.lowercased() == "pending" || status.lowercased() == "received" || status.lowercased() == "processing" || status.lowercased() == "sustomer service"
        {
            returnStatus = "processing"
            self.trackText.text = returnStatus.capitalized
            self.trackPipeView.setBackgroundColor(color: greenColor)
            self.orderStatusLbl.textColor = yellowColor
            self.trackPoint.image = yellowIcon
            self.statusIcon.image = yellowIcon
        }
        else
        {
            returnStatus = status.lowercased()
            viewFinalStatus.isHidden = false
            self.trackText.text = "Processing"
            self.trackPoint.image = greenIcon
            self.textFinalStatus.text = returnStatus.capitalized
            self.trackPipeView.setBackgroundColor(color: greenColor)
            self.viewFinalBorder.setBackgroundColor(color: greenColor)
            switch returnStatus {
            case "completed":
                self.iconFinalResult.image = greenIcon
                self.statusIcon.image = greenIcon
                self.orderStatusLbl.textColor = greenColor

            case "canceled":
                self.iconFinalResult.image = redIcon
                self.statusIcon.image = redIcon
                self.orderStatusLbl.textColor = redColor


            case "rejected":
                self.iconFinalResult.image = redIcon
                self.statusIcon.image = redIcon
                self.orderStatusLbl.textColor = redColor

            default:
                self.iconFinalResult.image = yellowIcon
                self.statusIcon.image = yellowIcon
                self.orderStatusLbl.textColor = yellowColor


            }
            
        }
        
        self.orderStatusLbl.text = returnStatus.capitalized
        
        //MARK: END MHIOS-1265

    }
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 4/255, green: 173/255, blue: 4/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [4,3] // 7 is the length of dash, 3 is length of the gap.
        shapeLayer.backgroundColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    func getReturnDetailsApi(){
        //MARK: START MHIOS-960
        self.getReturnDetails(orderId: self.entityId, isLoggedIn: UserData.shared.isLoggedIn){ orderReturnResponse in
            //MARK: END MHIOS-960
            DispatchQueue.main.async {
                self.orderReturnDetails = orderReturnResponse.items?.first(where: {$0.request_id == self.requestId})
                self.setPipeLine(status:  self.orderReturnDetails?.rma_status ?? "")
                self.isCancelled = (self.orderReturnDetails?.is_canceled ?? 0) == 1
                self.checkCancelledView()
                self.trackDate.text = "| " +  self.convertDateFormater(date: ( self.orderReturnDetails?.created_at ?? ""))
                self.orderIdLbl.text = self.orderReturnDetails?.increment_id ?? ""
                self.totalItemsCountLbl.text = "(\(self.orderReturnDetails?.request_item?.count ?? 1) Items)"
                self.createdDateLbl.text = self.convertDateFormater(date: self.orderReturnDetails?.created_at ?? "",neededFormat: "dd-MMM-yyyy")
                self.emailLbl.text = self.orderReturnDetails?.customer_email ?? ""
                self.mobileNumberLbl.text = self.orderReturnDetails?.phone_number ?? ""
                self.listingTable.reloadData()
            }
        }
    }
}


