//
//  ReturnRequestResponseVC.swift
//  Marina Home
//
//  Created by Sooraj R on 26/07/23.
//

import UIKit

class ReturnRequestResponseVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var lblTrackingDescription: UILabel!
    @IBOutlet var btnOrderTrack: AppPrimaryButton!
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var listingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var requestIdLbl: UILabel!
    @IBOutlet var lblTrackingTitle: UILabel!
    var orderItemsArray:[RequestItem] = []
    var responseDetails:OrderRequestModel?
    var entityId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        listingTable.delegate = self
        listingTable.dataSource = self
        listingTable.register(UINib(nibName: "ReturnSubmittedItemsTVC", bundle: nil), forCellReuseIdentifier: "ReturnSubmittedItemsTVC_id")
        listingTable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        if(UserData.shared.isLoggedIn==false)
        {
            self.lblTrackingTitle.isHidden = true
            self.lblTrackingDescription.isHidden = true
        }
        if let data = responseDetails{
            requestIdLbl.text = "\(data.request_id ?? 0)"
            orderItemsArray = data.request_item ?? []
            listingTable.reloadData()
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Return Request Response with values")
        CrashManager.shared.log("Order Items: \(orderItemsArray)")
        CrashManager.shared.log("OrderRequestModel: \(orderItemsArray)")
        CrashManager.shared.log("EntityId: \(entityId)")
        //MARK: END MHIOS-1225
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        listingTable.layer.removeAllAnimations()
        listingTableHeight.constant = listingTable.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }

    @IBAction func customBackAction(_ sender: UIButton) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
     }

    @IBAction func trackAction(_ sender: UIButton) {
        let nextVC = AppController.shared.returnOrderTracking
        nextVC.entityId = self.entityId
        nextVC.requestId = self.responseDetails?.request_id ?? 0
        self.navigationController?.pushViewController(nextVC, animated: true)
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
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnSubmittedItemsTVC_id", for: indexPath) as? ReturnSubmittedItemsTVC else { return UITableViewCell() }
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
        let animatedGif = UIImage.sd_image(withGIFData: imageData)
        //cell.itemImageView.image = animatedGif
        cell.itemTitle.attributedText = (cellData.name ?? "").htmlToAttributedString()
        cell.itemQtyLbl.text = "\(cellData.qty_rma ?? 0)"
        cell.itemDateLbl.text = convertDateFormater(date: cellData.created_at ?? "",neededFormat: "dd-MMM-yyyy")
        //cell.itemImageView.sd_setImage(with: URL(string: "\(AppInfo.shared.gumletProductImageURL)\(cellData.image ?? "")"),placeholderImage: animatedGif)
        let placeholderImage = UIImage(named: "failure_image.png")
        cell.itemImageView.image = placeholderImage
        //MARK START{MHIOS-1215}
        let imageExt = "\(cellData.image ?? "")"
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
       return cell
    }

}
