//
//  PLPController.swift
//  Marina Home
//
//  Created by Codilar on 02/05/23.
//

import UIKit
import Kingfisher
import AVKit
import Firebase
import KlaviyoSwift
//MARK START{MHIOS-1248}
//import ImageSlideshow
import MediaSlideshow
//MARK END{MHIOS-1248}
import Adjust
class PLPController:AppUIViewController,UICollectionViewDataSource,UICollectionViewDelegate,sortProductProtocol, FilterOptions, FilterOptionsRemoved,ProductCardDelegate {


    
    func redirectToLoginPage() {
        self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
    }
    // MARK START MHIOS_1058
    @IBOutlet weak var pageLoader: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var readMoreView: UIView!
    var roomtite:String = ""
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblreadMoreTitle: UILabel!
    @IBOutlet weak var collectionPLP: UICollectionView!
    // MARK END MHIOS_1058
    @IBOutlet weak var readMorePopupHeight: NSLayoutConstraint!//72
    
    
    var pageCount: Int = 1
    var isPageRefreshing:Bool = false
    var category:Home
    var products:Products
    var player: AVQueuePlayer?
    var playerItem: AVPlayerItem?
    var playerLayer:AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    var sortOption:String = "Relevance"
    var filterSectionArray:[Available_filters] = []
    var selectedItemsArray:[FilterModel] = [] {
        didSet {
            collectionPLP.reloadData()
        }
    }
    init() {
        self.products = Products()
        self.category = Home()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.products = Products()
        self.category = Home()
       super.init(coder: aDecoder)
    }
    
    var sectionHeader = FilterHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mark MHIOS-1130
        let event1 = ADJEvent(eventToken: AdjustEventType.ViewListing.rawValue)
        Adjust.trackEvent(event1)
        // Mark MHIOS-1130
        //MARK: START MHIOS-1225
        CrashManager.shared.log("PLP Screen with\(self.category.category_id ?? "")")
        //MARK: END MHIOS-1225
        self.setupGridView()
        UserDefaults.standard.set("SORT", forKey: "sort_name")
        self.apiFilterOptions(categoryId: self.category.category_id ?? ""){ response in
            DispatchQueue.main.async { [self] in
                print(response)
                self.filterSectionArray = response.available_filters
            }
        }
        self.showActivityIndicator(uiView: self.view)
        self.automaticallyAdjustsScrollViewInsets = false
        ProductCVC.register(for: self.collectionPLP)
        
        let message = self.category.shopbystyle_description!
        self.lblTitle.text = roomtite.uppercased()
        self.lblDescription.text = self.category.shopbystyle_description
        let contentHeight = message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).height
        let contentWidth = message.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).width
        let width = self.view.frame.size.width - 40
        let lblDescriptionHeight =  (contentWidth/width)*18
        print("SANTHOSH lblDescriptionHeight : \(lblDescriptionHeight)")
        if 280 < lblDescriptionHeight  //(contentWidth\width)// 17lines
        {
            readMorePopupHeight.constant = 350
        }
        else
        {
            readMorePopupHeight.constant = lblDescriptionHeight+72
        }
        self.lblreadMoreTitle.text = self.roomtite.uppercased()
        self.readMoreView.isHidden = true
        backActionLink(self.btnBack)
        self.apiProducts(page: 1){ response in
            DispatchQueue.main.async {
                print("SANTHOSH apiProducts : \(response)")
                self.products = response as Products
                self.collectionPLP.reloadData()
                
            }
            self.collectionPLP.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionPLP.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool)  {
        self.hideActivityIndicator(uiView: self.view)
    }
    func setupGridView() {
        
        let flow = collectionPLP?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(10.0)
        flow.minimumLineSpacing = CGFloat(10.0)
        flow.sectionHeadersPinToVisibleBounds = true
        
    }
    //MARK: START MHIOS-1154
    deinit {
        KingfisherManager.shared.cache.clearCache()
        print("deinit called")
    }
    //MARK: END MHIOS-1154

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func CloseReadMore(_ sender: Any) {
        self.readMoreView.isHidden = true
        self.tabBarController?.hideTabBar(isHidden: true)
    }
    
    @objc func ReadMore(_ sender: UIButton) {
       
        self.readMoreView.isHidden = false
        self.tabBarController?.hideTabBar(isHidden: false)
    }
    
    @objc func filterProducts(_ sender: UIButton) {
        print("SANTHOSH TAB BAR FUN")
        
        let nextVC = AppController.shared.filter
        nextVC.delegate = self
        nextVC.categoryId = self.category.category_id ?? "0"
        nextVC.selectedItemsArray = self.selectedItemsArray
        nextVC.filterSectionArray=self.filterSectionArray
        nextVC.hidesBottomBarWhenPushed = true
        func prepare(for segue: UIStoryboardSegue, sender : Any?) {
            self.hidesBottomBarWhenPushed = true
        }
        
        nextVC.hidesBottomBarWhenPushed = true
        //nextVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func sortProducts(_ sender: UIButton) {
        print("SANTHOSH STATUS : ")
        
        let controller = AppController.shared.sort
        controller.sortDelegate = self
        addChild(controller)
        controller.selectedSectionItem = sortOption
        self.view.addSubview(controller.view)
        controller.view.frame = self.view.frame
        controller.viewOptions.isHidden=true
        controller.hidesBottomBarWhenPushed = true
        controller.didMove(toParent: self)
        
        controller.viewOptions.animShow()
        controller.viewOptions.isHidden = false
        
        
        
//        let controller = AppController.shared.sort
//        controller.sortDelegate = self
//        controller.selectedSectionItem = sortOption
//        controller.hidesBottomBarWhenPushed = false
//        addChild(controller)
//        self.view.addSubview(controller.view)
//        controller.view.frame = self.view.frame
//        controller.viewOptions.isHidden=true
//
//        controller.viewOptions.animShow()
//        controller.viewOptions.isHidden = false
//
//        self.tabBarController?.hideTabBar(isHidden: false)
//        controller.hidesBottomBarWhenPushed = false
//        func prepare(for segue: UIStoryboardSegue, sender : Any?) {
//            self.hidesBottomBarWhenPushed = true
//        }
//
//        controller.hidesBottomBarWhenPushed = false
//
//        controller.didMove(toParent: self)
    }
    
    // MARK: - Sort
    func sortproduct(option:String)
    {
        print("sorttt \(option)")
        sortOption = option
        UserDefaults.standard.set(option, forKey: "sort_name")
        sectionHeader.labSort.text = option
        self.showActivityIndicator(uiView: self.view)
        sectionHeader.getAvailableWidth()
        self.apiProducts(page: 1){ response in
            DispatchQueue.main.async {
                print(response)
                self.products = response as Products
                self.collectionPLP.reloadData()
            }
            self.collectionPLP.reloadData()
            self.collectionPLP.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }

    func selectedFilterOptions(options: [FilterModel], filterSectionArray: [Available_filters]) {
        selectedItemsArray = options
        self.filterSectionArray = filterSectionArray
        self.showActivityIndicator(uiView: self.view)
        self.apiProducts(page: 1){ response in
            DispatchQueue.main.async {
                print(response)
                self.products = response as Products
                self.collectionPLP.reloadData()
            }
            self.collectionPLP.reloadData()
        }
    }

    func selectedFilterOptionsRemoved(options: [FilterModel]) {
        selectedItemsArray = options
        self.apiFilterOptions(categoryId: self.category.category_id!){ response in
            DispatchQueue.main.async { [self] in
                self.filterSectionArray = response.available_filters
                if self.selectedItemsArray.count > 0{
                    for (sectionIndex,section) in self.filterSectionArray.enumerated(){
                        for (sectionItemIndex,sectionItem) in section.options.enumerated(){
                            if self.selectedItemsArray.contains(where: {$0.displayTitle == sectionItem.label ?? ""}){
                                self.filterSectionArray[sectionIndex].options[sectionItemIndex].isSelected = true
                            }
                        }
                    }
                }
                self.apiProducts(page: 1){ response in
                    DispatchQueue.main.async {
                        print(response)
                        self.products = response as Products
                        self.collectionPLP.reloadData()
                    }
                    self.collectionPLP.reloadData()
                }
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.collectionPLP.contentOffset.y >= ((self.collectionPLP.contentSize.height -  self.collectionPLP.bounds.size.height)/3)*2) {
            if !isPageRefreshing {
                isPageRefreshing = true
                print(pageCount)
                pageCount = pageCount + 1
                  self.apiProducts(page: pageCount){ response in
                        DispatchQueue.main.async {
                            print(response)
                            if(self.pageCount==1)
                            {
                                self.products = response as Products
                                UIView.performWithoutAnimation {
                                    self.collectionPLP.performBatchUpdates({
                                        self.collectionPLP.reloadData()
                                    }, completion: nil)
                                }
                            }
                            else
                            {
                                let pageItems = response.items
                                self.products.items?.append(contentsOf: pageItems!)
                                UIView.performWithoutAnimation {
                                    self.collectionPLP.performBatchUpdates({
                                        self.collectionPLP.reloadData()
                                    }, completion: nil)
                                }
                                
                            }
                        }
                      self.isPageRefreshing = false
                       
                    }
                
            }
        }
    }
    func openDetail(tag:Int,sectionSelected:Int)
    {
        
            let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = "\(self.products.items![tag].sku ?? "")"
            nextVC.wishListId = "\(self.products.items![tag].id ?? 0)"
            nextVC.hidesBottomBarWhenPushed = true
            nextVC.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    //MARK START{MHIOS-1029}
    func addToWishList(productId:String,tag:Int,sku:String)
       {
           
               Analytics.logEvent("add_to_wishlist", parameters: [
                   
                   AnalyticsParameterItemID: productId ?? "",
                   
               ])
           //MARK: START MHIOS-1064
           SmartManager.shared.trackEvent(event: "add_to_wishlist", properties: ["product_id": "\(productId)"])
           //MARK: END MHIOS-1064
           // Mark MHIOS-1130
           AdjustAnalytics.shared.createEvent(type: .AddToWishList)
           AdjustAnalytics.shared.createParam(key: KeyConstants.productId, value: productId)
           AdjustAnalytics.shared.track()
           // Mark MHIOS-1130
           let klaviyo = KlaviyoSDK()
           var product:Item = self.products.items![tag]
           let event = Event(name: .CustomEvent("Add To Wishlist"), properties: [
               "AddedItemPrice": "\(product.price)" ,"AddedItemSku":product.sku,"AddedItemQuantity":"1",
               "AddedItemProductName": product.name
           ], value:Double(product.price ?? 0))
           klaviyo.create(event: event)
           if UserData.shared.isLoggedIn
           {
               self.apiAddToWishlist(id: productId){ responseData in
                   DispatchQueue.main.async {
                       print(responseData)
                       if responseData{
                           //MARK START{MHIOS-1181}
                           UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int(productId) ?? 0,sku: sku))
                           //MARK END{MHIOS-1181}
                           let appDelegate = UIApplication.shared.delegate as! AppDelegate
                           appDelegate.wishList.append(productId)
                           //self.collectionPLP.reloadData()
                           self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
                       }
                   }
               }
           }
           else
           {
               //let appDelegate = UIApplication.shared.delegate as! AppDelegate
               //appDelegate.wishList.append(productId)
               UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int(productId) ?? 0,sku: sku))
               self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
//                self.showAlert(message: "Please log in or register to view your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
//                    self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
//                }, leftAction: {
//                    //print("SANTHOSH WISHLIST G LIST \(appDelegate.wishLists[0])")
//                })
           }
       }
    //MARK END{MHIOS-1029}
    func removeWishList(productId:String,tag:Int)
    {
        if UserData.shared.isLoggedIn
        {
            self.apiRemoveProduct(id: productId){ responseData in
                DispatchQueue.main.async {
                    print(responseData)
                    if responseData{
                        //MARK START{MHIOS-1181}
                        UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(productId) ?? 0 }
                        //MARK END{MHIOS-1181}
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.wishList = appDelegate.wishList.filter{$0 != productId }
                        self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
                    }
                }
            }
        }
        else
        {
            //MARK START{MHIOS-1029}
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.wishList = appDelegate.wishList.filter{$0 != productId }
            UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(productId) ?? 0 }
            self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
            //MARK END{MHIOS-1029}
        }
    }
    
}


extension PLPController: UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.products.items?.count ?? 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(section==1)
        {
            if collectionView.numberOfItems(inSection: section) == 1 {

                     let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

                var width = UIScreen.main.bounds.width/2
                width = width+3
                let diff = width-178.5
                return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: width)

                }
            var width = self.view.frame.width/2;
            width = width - 168
            width = width/2
            let space = width/2
            width =  width+space
            return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
       return 6
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
       return 6
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         
         switch indexPath.section {
         case 0:
             
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PLPHeaderCell", for: indexPath) as! PLPHeaderCell
             let textAttributes: [NSAttributedString.Key: Any] = [
                .font: AppFonts.LatoFont.Bold(13),
                .foregroundColor: AppColors.shared.Color_yellow_A89968,
                .underlineStyle: NSUnderlineStyle.single.rawValue
             ]
            // cell.lblDescripton.preferredMaxLayoutWidth = self.view.frame.width;
             let title = "MORE ABOUT \(roomtite.uppercased())"
             let attributeString = NSMutableAttributedString(
                string: title,
                attributes: textAttributes)
            
             cell.btnReadMore.setAttributedTitle(attributeString, for: .normal)
             cell.btnReadMore.addTarget(self, action: #selector(self.ReadMore(_:)), for: .touchUpInside)
            
             let banner:Home = self.category;
             if(banner.title1 != nil)
             {
                 //cell.lblTitle1.backgroundColor = .red
                 cell.lblTitle1.isHidden = false
                 cell.lblTitle1.text = banner.title1?.uppercased()
                 cell.lblTitle1.font = AppFonts.LatoFont.Regular(14)
                 let alignment = banner.title_1_alignment

                 switch alignment {
                 case "left":
                     cell.lblTitle1.textAlignment = .left
                 case "right":
                     cell.lblTitle1.textAlignment = .right
                 default:
                     cell.lblTitle1.textAlignment = .center
                 }
                 let font = banner.title1_font
                 switch font {
                 case "light":
                     
                     cell.lblTitle1.font = AppFonts.LatoFont.Regular(14)
                 case "bold":
                     cell.lblTitle1.font = AppFonts.PlayfairFont.SemiBold(28)
                 default:
                     cell.lblTitle1.font = AppFonts.LatoFont.Regular(14)
                 }
             }
             else
             {
                 cell.lblTitle1.isHidden = true
             }
             
             //title 2
             if(banner.title2 != nil)
             {
                 //cell.lblTitle2.backgroundColor = .green
                 cell.lblTitle2.isHidden = false
                 cell.lblTitle2.text = banner.title2?.uppercased()
                 cell.lblTitle2.font = AppFonts.PlayfairFont.SemiBold(28)
                 let alignment = banner.title_2_alignment
                 let font = banner.title2_font
                 switch font {
                 case "light":
                     
                     cell.lblTitle2.font = AppFonts.LatoFont.Regular(14)
                 case "bold":
                     cell.lblTitle2.font = AppFonts.PlayfairFont.SemiBold(28)
                 default:
                     cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
                 }
                 switch alignment {
                 case "left":
                     cell.lblTitle2.textAlignment = .left
                 case "right":
                     cell.lblTitle2.textAlignment = .right
                 default:
                     cell.lblTitle2.textAlignment = .center
                 }
             }
             else
             {
                 cell.lblTitle2.isHidden = true
             }
             
             //title 2
             if(banner.title3 != nil)
             {
                 cell.lblTitle3.isHidden = false
                 cell.lblTitle3.text = banner.title3?.uppercased()
                 cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
                 let alignment = banner.title_3_alignment

                 switch alignment {
                 case "left":
                     cell.lblTitle3.textAlignment = .left
                 case "right":
                     cell.lblTitle3.textAlignment = .right
                 default:
                     cell.lblTitle3.textAlignment = .center
                 }
                 let font = banner.title3_font
                 switch font {
                 case "light":
                     
                     cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
                 case "bold":
                     cell.lblTitle3.font = AppFonts.PlayfairFont.SemiBold(28)
                 default:
                     cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
                 }
             }
             else
             {
                 cell.lblTitle3.isHidden = true
             }
             
             if(banner.video != nil)
             {
                
                 let pathURL = URL(string: banner.video!)
                 let duration = Int64( ( (Float64(CMTimeGetSeconds(AVAsset(url: pathURL!).duration)) *  10.0) - 1) / 10.0 )
                 playerItem = AVPlayerItem(url: pathURL!)
                 player = AVQueuePlayer()
                 player?.volume = 0
                 playerLayer = AVPlayerLayer(player: player)
                 playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                 cell.imgBanner.layoutIfNeeded()
                 playerLayer?.frame = cell.imgBanner.layer.bounds
                 cell.imgBanner.layer.insertSublayer(playerLayer!, at: 1)
                 player?.removeAllItems()
                playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem!,
                                               timeRange: CMTimeRange(start: CMTime.zero, end: CMTimeMake(value: duration, timescale: Int32(0.00))) )
                 player?.play()
             }
             else
             {
                 if banner.banner != ""
                 {
                     let url = URL(string: "\(banner.banner ?? "")")!
                     cell.imgBanner.kf.setImage(with:url.downloadURL )
                 }
            }
             return cell
              //let product:Item = self.products.items![indexPath.row]
              //cell.setNeedsDisplay()
              //cell.lblName.text = product.name
             // cell.lblPri
         default:
             /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomItemCell", for: indexPath) as! RoomItemCell
             cell.lblName.font = AppFonts.LatoFont.Regular(13)
             cell.lblPrice.font = AppFonts.LatoFont.Bold(13)
             let product:Item = self.products.items![indexPath.row]
             cell.lblName.text = product.name
             cell.lblPrice.text = "\(product.price ?? 0) AED"
             let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
             let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(product.price!-100 ?? 0) AED")
                 attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
          
             cell.lblActualPrice.attributedText = attributeString
             if(product.media_gallery_entries?.count ?? 0>0)
             {
                 let url = URL(string: "\(AppInfo.shared.productImageURL)\(product.media_gallery_entries![0].file ?? "")")!
                 
                 cell.imgProduct.kf.setImage(with:url.downloadURL )}
             return cell;*/
             
             
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
             let underlineAttribute_test = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
             let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:" ")
             attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))

             cell.lblActualPrice.attributedText = attributeString
             cell.lblActualPrice.text = ""
             cell.lblOfferPrice.text = ""
             cell.tag = indexPath.row
              cell.lblName.font = AppFonts.LatoFont.Regular(13)
              cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
             cell.lblActualPrice.font = AppFonts.LatoFont.Bold(13)
              var product:Item = self.products.items![indexPath.row]
              cell.lblName.text = product.name
             cell.productId = Int(product.id!)
             
              ///cell.lblActualPrice.text = "\(product.price ?? 0) AED"
             let price = Double(product.price!)
             let priceString = String(format: "%.2f", price)
             let priceDouble = Double(priceString)
             let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             print("\(appDelegate.wishList)")
             print("productID\(String(describing: product.id))")
             let productInfo:String = "\(product.id ?? 0 )"
             
             //MARK START{MHIOS-1029}
             cell.sku = product.sku ?? ""
             ///var result = appDelegate.wishList.contains(productInfo)
             let productSKU:String = "\(product.sku ?? "" )"
             let modelToCheck = WishlistIDsModel(product_id: Int(productInfo) ?? 0, sku: productSKU)
             var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
             //MARK END{MHIOS-1029}
             if(result == true)
             {
                 cell.btnLike.setImage(UIImage(named: "liked"), for: .normal)
             }
             else
             {
                 //cell.btnLike.isEnabled = true
                 cell.btnLike.setImage(UIImage(named: "like_button"), for: .normal)
             }
             
             var specialPrice = ""
             var specialToDate = ""
             var specialFromDate = ""
             for item in product.customAttributes ?? [] {
                 switch item.value {
                 case .string(let stringValue):
                     print(item.attribute_code)
                     print("String value: \(stringValue)")
                     
                     if item.attribute_code == "special_price"{
                         ///specialPrice = "\(stringValue ?? "")"
                         print("SANTHOSH TS value: \(stringValue)")
                         if let floatNumber = Float(stringValue) {
                             let priceProdDouble = Double(floatNumber)
                             specialPrice = formatNumberToThousandsDecimal(number: priceProdDouble)

                             cell.lblOfferPrice.text = specialPrice + " AED"
                         }
                         ///offerPriceLbl.text = "\(item.value ?? "0.00") AED"
                     }
                     if item.attribute_code == "special_from_date"{
                         specialFromDate = "\(stringValue ?? "")"
                     }
                     if item.attribute_code == "special_to_date"{
                         specialToDate = "\(stringValue ?? "")"
                        
                     }
                     
                 case .stringArray(let stringArrayValue):
                     print("String array value: \(stringArrayValue)")
                 case .none:
                     print("")
                     
                 }
             }
             
             let prodPriceDouble = product.price ?? 0.0
             let actualFormatPrice = formatNumberToThousandsDecimal(number: prodPriceDouble)

             
             let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
             if specialPriceFlag
             {
                 let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,.font: AppFonts.LatoFont.Bold(13)] as [NSAttributedString.Key : Any]
                 let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(actualFormatPrice + " AED" )")
                 attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                 
                 cell.lblActualPrice.attributedText = attributeString
                 ///cell.lblOfferPrice.text = "\(product.specialPrice ?? 0) AED"
                 cell.lblActualPrice.isHidden = false
                 cell.lblOfferPrice.isHidden = false
                 cell.lblActualPrice.font = AppFonts.LatoFont.Bold(13)
                 cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
             }
             else
             {
                 cell.lblOfferPrice.isHidden = true
                 cell.lblActualPrice.font = AppFonts.LatoFont.Bold(13)
                 cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
                 let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                 let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(actualFormatPrice + " AED")")
                 attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))

                 cell.lblActualPrice.attributedText = attributeString
                 cell.lblActualPrice.isHidden = false
             }
                 
              cell.imageArray = product.media_gallery_entries!
             cell.imageArray = product.media_gallery_entries!
             var temp:[Media_gallery_entries] = []
             var sliderImages = [KingfisherSource]()
             let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
             let animatedGif = UIImage.sd_image(withGIFData: imageData)
             let placeholderImage = UIImage(named: "failure_image.png")
             //MARK: START MHIOS-1154
             //MARK: START MHIOS-1242
             let processor = DownsamplingImageProcessor(size: CGSize(width: 1080, height: 1080))
             //MARK: END MHIOS-1242
             let options: KingfisherOptionsInfo = [ // Set a fade-in transition with a duration
                 .processor(processor),
                 .loadDiskFileSynchronously,
                 .cacheMemoryOnly,
                 .onFailureImage(placeholderImage) // Set a custom target cache
             ]
             //MARK: END MHIOS-1154
             for var i in (0..<cell.imageArray.count)
             {
                 let p = cell.imageArray[i]
                 if(p.media_type == "external-video")
                 {
                     
                 }
                 else
                 {
                     temp.append(p)
                     sliderImages.append(KingfisherSource(urlString: "\(AppInfo.shared.gumletProductImageURL)\(p.file ?? "")",placeholder:placeholderImage,options: options)!)
                 }
                 
                 if i == 2
                 {
                   break
                 }
                 
             }
             if(product.media_gallery_entries!.count == 0)
             {
                 cell.collectionImages.isUserInteractionEnabled = false
             }
             else
             {
                 cell.collectionImages.isUserInteractionEnabled = true
             }
             cell.setImages(sliderImages: sliderImages)
             cell.tag = indexPath.row
             cell.productDelegate = self
             return cell
              //let product:Item = self.products.items![indexPath.row]
              //cell.setNeedsDisplay()
              //cell.lblName.text = product.name
             // cell.lblPri
         }
         
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        switch indexPath.section {
        case 0:
            return CGSize(width: self.view.frame.width, height:210)
        default:
            var width = UIScreen.main.bounds.width/2
            width = width - 9
            
            return CGSize(width:width, height: width+72)
            // in case you you want the cell to be 40% of your controllers view
        }
        
    }

    // MARK UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SANTHOSH ")
//        print(self.products.items![indexPath.item].id)
//        print(self.products.items![indexPath.item].sku)
//        if indexPath.section != 0{
//            let nextVC = AppController.shared.productDetailsImages
//            nextVC.productId = "\(self.products.items![indexPath.item].id)"
//            nextVC.wishListId = "\(self.products.items![indexPath.item].id ?? 0)"
//            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
        
   }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterHeaderView", for: indexPath) as! FilterHeaderView
            
            sectionHeader.btnFilter.addTarget(self, action: #selector(self.filterProducts(_:)), for: .touchUpInside)
            sectionHeader.btnSort.addTarget(self, action: #selector(self.sortProducts(_:)), for: .touchUpInside)
            sectionHeader.selectedItemsArray = self.selectedItemsArray
            if self.selectedItemsArray.isEmpty
            {
                sectionHeader.filterDividerView.isHidden = true
            }
            else
            {
                sectionHeader.filterDividerView.isHidden = false
            }
            
            sectionHeader.delegate = self
             return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if(section==0)
        {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionView.frame.width, height: 85)
    }
}


