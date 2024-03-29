//
//  ReturnRequestVC.swift
//  Marina Home
//
//  Created by Sooraj R on 24/07/23.
//

import UIKit

class ReturnRequestVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var listingTableHeight: NSLayoutConstraint!
    @IBOutlet var attachedCollection: UICollectionView!
    @IBOutlet weak var orderIDField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var allSelectionIcon: UIImageView!
    @IBOutlet weak var allSelectionButton: UIButton!
    @IBOutlet weak var commentField: UITextField!

    var orderItemsArray:[returnItemsCustomModel] = []
    var attachedFilesArray:[[String : Any]] = []
    var orderDetails:OrderDeatil?
    var reasonList:[ReturnOrderInfoList] = []
    var entityId = ""
    var returninfo:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backActionLink(backButton)
        self.backActionLink(cancelButton)
        listingTable.delegate = self
        listingTable.dataSource = self
        listingTable.register(UINib(nibName: "ReturnItemsTVC", bundle: nil), forCellReuseIdentifier: "ReturnItemsTVC_id")
        listingTable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        attachedCollection.delegate = self
        attachedCollection.dataSource = self
        ProductImagesCVC.register(for: attachedCollection)
        self.getReasons(){ response in
            DispatchQueue.main.async {
                self.reasonList = response
            }
        }
        let ordrid:Int = self.orderDetails?.items?.first?.items?.first?.order_id  ?? 0
        self.apigetReturnRequestInfo(orderId:ordrid){ response in
            self.returninfo = response
            self.initUI()
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Return Request with values")
        CrashManager.shared.log("Order Items: \(orderItemsArray)")
        CrashManager.shared.log("Attached Files: \(attachedFilesArray)")
        CrashManager.shared.log("Order Details: \(String(describing: orderDetails))")
        CrashManager.shared.log("Reason List: \(reasonList)")
        CrashManager.shared.log("Entity Id: \(entityId)")
        CrashManager.shared.log("Return Info: \(returninfo)")
        //MARK: END MHIOS-1225
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        listingTable.layer.removeAllAnimations()
        listingTableHeight.constant = listingTable.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }

    }

    func initUI(){
        if let data = orderDetails{
            orderIDField.text = data.items?.first?.increment_id ?? ""
            lastNameField.text = data.items?.first?.billing_address?.lastname ?? ""
            emailField.text = data.items?.first?.customer_email ?? ""
            orderItemsArray = []
            
            
            let arry = data.items?.first?.items ?? []
                for  var item in arry {
                    
                    let dic = self.returninfo[ "\(item.product_id ?? 0)"] as! [String:Any]
                   
                    var isRetunable = false
                    for (key, value) in dic {
                          if key == "returnable"  {
                             isRetunable = value as! Bool
                          }
                       }
                    if(isRetunable==true)
                    {
                        item.qty_ordered = dic["returnableqty"] as! Int
                    }
                    else
                    {
                        
                        item.qty_ordered = 0
                    }
                    var appendItem:returnItemsCustomModel = returnItemsCustomModel(item: item)
                    appendItem.QtyToReturn = item.qty_ordered ?? 0
                    appendItem.isReturnable = isRetunable
                    if(item.qty_ordered != 0)
                    {
                        self.orderItemsArray.append(appendItem)
                    }
                    self.listingTable.reloadData()
                }
            
            
            
            
           
        }
    }

    @IBAction func addAttachmentsAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
     }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let fileName = url.lastPathComponent
//                let fileType = url.pathExtension
                attachedFilesArray.append(["name":fileName,"base64_encoded_data":convertImageToBase64String(img: tempImage)])
               
                attachedCollection.reloadData()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
    }

    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }

    @IBAction func allSelectionAction(_ sender: UIButton) {
        for (index,item) in orderItemsArray.enumerated(){
            
            orderItemsArray[index].selected = sender.tag == 0 ? true : false
            orderItemsArray[index].QtyToReturn = item.item.qty_ordered ?? 0
            orderItemsArray[index].isExpanded = orderItemsArray[index].selected ? true : false
        }
        listingTable.reloadData()
        allSelectionIcon.image = UIImage(named: sender.tag == 0 ? "checkboxButton_Selected_icon" : "checkboxButton_icon")
        sender.tag = sender.tag == 0 ? 1 : 0
     }

    @objc func itemSelectionAction(_ sender: UIButton) {
        orderItemsArray[sender.tag].selected = !orderItemsArray[sender.tag].selected
        //MARK START{MHIOS-1147}
        if orderItemsArray[sender.tag].selected==false
        {
            orderItemsArray[sender.tag].reason = ""
            orderItemsArray[sender.tag].solution = ""
            orderItemsArray[sender.tag].reason_name = ""
            orderItemsArray[sender.tag].solution_name = ""
            orderItemsArray[sender.tag].condition = ""
        }
        //MARK END{MHIOS-1147}
        orderItemsArray[sender.tag].isExpanded = orderItemsArray[sender.tag].selected ? true : false
        var isSelectedAll = true
        for (index,item) in orderItemsArray.enumerated(){
            if !item.selected{
                
                isSelectedAll = false
                break
            }
            if(item.item.qty_ordered != item.QtyToReturn)
            {
                isSelectedAll = false
                break
            }
        }
        allSelectionButton.tag = isSelectedAll ? 1 : 0
        allSelectionIcon.image = UIImage(named: isSelectedAll ? "checkboxButton_Selected_icon" : "checkboxButton_icon")
        listingTable.reloadData()
     }

    @objc func itemQtyAction(_ sender: UIButton) {

     }

    func setParam(itemList:[returnItemsCustomModel])->[String:Any]{
        var additionalFields:[[String : Any]] = []
        for item in reasonList.first?.additional_field ?? []{
            additionalFields.append(["value":item.value ?? "","content":item.content?.type ?? ""])
        }
        
        var requestItem:[[String : Any]] = []
        let keyToUpdate = "content"
        for item in itemList{
            if item.selected{
                for index in 0..<additionalFields.count {
                    additionalFields[index][keyToUpdate] = item.condition
                }
                let requestItemToAppend:[String : Any] = ["product_id": item.item.product_id ?? 0,"qty_rma": item.QtyToReturn,"reason": item.reason,"additional_fields": additionalFields,"solution": item.solution]
                requestItem.append(requestItemToAppend)
            }
        }
        //MARK: START MHIOS-960
        var param = ["request": [
            "order_increment_id": self.orderDetails?.items?.first?.increment_id ?? "",
            "comment":commentField.text ?? "",
            "upload": attachedFilesArray,
            "request_item": requestItem,
            ]]
        if !UserData.shared.isLoggedIn
        {
            var guest_data = ["billing_last_name":self.orderDetails?.items?.first?.billing_address?.lastname,
                "find_by":"email",
                "email":self.orderDetails?.items?.first?.customer_email,
            ]
            
            param["request"]?["guest_data"] = guest_data
        }
        
        //MARK: END MHIOS-960

        return param
    }

    @IBAction func submitAction(_ sender: UIButton) {
        var selectedItemsArray:[returnItemsCustomModel] = orderItemsArray.filter({$0.selected})
        if orderIDField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your order id","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your order id",type: "error")
        }else if lastNameField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your billing last name","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your billing last name",type: "error")
        }else if emailField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter email address",type: "error")
        }else if ( !self.checkMailIdFormat(string: self.emailField.text ?? "")){
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid email address","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid email address",type: "error")
        }else if commentField.text == ""{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter your comments","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter your comments",type: "error")
        }else if selectedItemsArray.isEmpty{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please select atleast one item to continue","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please select atleast one item to continue",type: "error")
        }else{
            var errorMsg = ""
            for item in selectedItemsArray{
                if item.reason == ""{
                    errorMsg = "Select a reason for selected item to continue"
                    break
                }
                if item.solution == ""{
                    errorMsg = "Select a solution for selected item to continue"
                    break
                }
                if item.condition == ""{
                    errorMsg = "Add condition for selected item to continue"
                    break
                }
            }
            if errorMsg == ""{
               
                    
                   
                    var isRetunable = true
                    for i in selectedItemsArray
                    {
                        if(i.isReturnable==false)
                        {
                            isRetunable = false
                            break
                        }
                    }
                    if(isRetunable == true)
                    {
                        //MARK: START MHIOS-960
                        self.apiSubmitReturnRequest(parameters: self.setParam(itemList: selectedItemsArray), isLoggedIn: UserData.shared.isLoggedIn){ response in
                            DispatchQueue.main.async {
                                //MARK: END MHIOS-960
                                if response.request_id == nil{
                                    //MARK: START MHIOS-1285
                                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Sorry, but we are unable to process your return request for this item","Screen" : self.className])
                                    //MARK: END MHIOS-1285
                                    self.toastView(toastMessage: "Sorry, but we are unable to process your return request for this item",type: "error")
                                }else{
                                    let nextVC = AppController.shared.returnRequestResponse
                                    nextVC.responseDetails = response
                                    nextVC.entityId = self.entityId
                                    self.navigationController?.pushViewController(nextVC, animated: true)
                                }
                            }
                        }
                    
                    
                    
                }
                else
                {
                    //MARK: START MHIOS-1285
                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Sorry, This item is not returnable.","Screen" : self.className])
                    //MARK: END MHIOS-1285
                    self.toastView(toastMessage: "Sorry, This item is not returnable.",type: "error")
                }
            }else{
                //MARK: START MHIOS-1285
                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": errorMsg,"Screen" : self.className])
                //MARK: END MHIOS-1285
                self.toastView(toastMessage: errorMsg,type: "error")
            }
        }
    }

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: attachedCollection.frame.height, height: attachedCollection.frame.height)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
       return 20
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
       return 0
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachedFilesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = attachedFilesArray[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCVC_id", for: indexPath) as? ProductImagesCVC else { return UICollectionViewCell() }
        let imageString = cellData["base64_encoded_data"] as? String ?? ""
        print("\(imageString)")
        cell.productImage.image = convertBase64StringToImage(imageBase64String: imageString)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return orderItemsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cellData = orderItemsArray[indexPath.item]
      
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnItemsTVC_id", for: indexPath) as? ReturnItemsTVC else { return UITableViewCell() }
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
        let animatedGif = UIImage.sd_image(withGIFData: imageData)
        //cell.itemImageView.image = animatedGif
        cell.selectionButton.tag = indexPath.item
        cell.selectionButton.addTarget(self, action: #selector(itemSelectionAction), for: .touchUpInside)
        cell.itemQtyButton.tag = indexPath.item
        cell.itemQtyButton.addTarget(self, action: #selector(itemQtyAction), for: .touchUpInside)
        cell.setData(data: cellData, optionsList: reasonList)
        //MARK START{MHIOS-1142}
        cell.itemQtyButton.setTitle("", for: .normal)
        cell.itemQtyLable.text = "Quantity: \(cellData.QtyToReturn)"
        //MARK END{MHIOS-1142}
        //MARK START{MHIOS-1147}
        cell.reasonClosure = { reason,reasonName in
            self.orderItemsArray[indexPath.item].reason = reason
            self.orderItemsArray[indexPath.item].reason_name = reasonName
        }
        cell.solutionClosure = { solution,solutionName in
            self.orderItemsArray[indexPath.item].solution = solution
            self.orderItemsArray[indexPath.item].solution_name = solutionName
        }
        cell.conditionClosure = { condition in
            self.orderItemsArray[indexPath.item].condition = condition
        }
        //MARK END{MHIOS-1147}
        cell.qtyClosure = { qty in
            self.orderItemsArray[indexPath.item].QtyToReturn = qty
            var isSelectedAll = true
            for (index,item) in self.orderItemsArray.enumerated(){
                if !item.selected{
                    
                    isSelectedAll = false
                    break
                }
                if(item.item.qty_ordered != item.QtyToReturn)
                {
                    isSelectedAll = false
                    break
                }
            }
            self.allSelectionButton.tag = isSelectedAll ? 1 : 0
            self.allSelectionIcon.image = UIImage(named: isSelectedAll ? "checkboxButton_Selected_icon" : "checkboxButton_icon")
            self.listingTable.reloadData()
            self.listingTable.reloadData()
        }
        //cell.itemImageView.sd_setImage(with: URL(string: "\(AppInfo.shared.productImageURL)\(cellData.item.extensionAttributes?.image ?? "")"),placeholderImage: animatedGif)
        let placeholderImage = UIImage(named: "failure_image.png")
        cell.itemImageView.image = placeholderImage
        //MARK START{MHIOS-1215}
        let imageExt = "\(cellData.item.extensionAttributes?.image ?? "")"
        if imageExt != "" && imageExt != "no_selection"
        {
            let imageMain = "\(AppInfo.shared.productImageURL)\(imageExt)"
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderItemsArray[indexPath.item].isExpanded = !orderItemsArray[indexPath.item].isExpanded
        listingTable.reloadData()
    }
}

struct returnItemsCustomModel{
    var item:OrderDetailItems
    var isExpanded = false
    var isReturnable = true
    var reason = ""
    var solution = ""
    //MARK START{MHIOS-1147}
    var reason_name = ""
    var solution_name = ""
    //MARK END{MHIOS-1147}
    var condition = ""
    var selected = false
    var QtyToReturn = 1
}
