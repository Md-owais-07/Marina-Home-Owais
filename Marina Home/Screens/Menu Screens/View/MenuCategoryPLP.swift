//
//  MenuCategoryPLP.swift
//  Marina Home
//
//  Created by Eljo on 26/05/23.
//

import UIKit
import Firebase
import KlaviyoSwift
//MARK START{MHIOS-1248}
import MediaSlideshow
//MARK END{MHIOS-1248}
import Kingfisher
import Adjust
class MenuCategoryPLP: AppUIViewController,UICollectionViewDataSource,UICollectionViewDelegate,sortProductProtocol, FilterOptions, FilterOptionsRemoved,ProductCardDelegate {
    
    func redirectToLoginPage() {
        self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
    }
    
    // MARK START MHIOS_1058
    @IBOutlet weak var paginationLoder: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionPLP: UICollectionView!
    // MARK END MHIOS_1058
    
    
    
    var products:Products
    var roomtite:String = ""
    var category_id: String
    var pageCount: Int = 1
    var sortOption:String = "Relevance"
    var isPageRefreshing:Bool = false
    var isFromSearch:Bool = false
    var isFromPopular:Bool = false
    var filterSectionArray:[Available_filters] = []
    var selectedItemsArray:[FilterModel] = [] {
        didSet {
            collectionPLP.reloadData()
        }
    }
    init() {
        self.products = Products()
        self.category_id = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.products = Products()
        self.category_id = ""
        super.init(coder: aDecoder)
    }
    
    var sectionHeader = FilterHeaderView()
    // MARK START MHIOS_1058
    deinit {
        KingfisherManager.shared.cache.clearCache()
        print("deinit called")
    }
    // MARK END MHIOS_1058
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1225

        CrashManager.shared.log("MenuCategoryPLP_\(category_id)isFromSearch:\(isFromSearch),isFromPopular:\(isFromPopular)")
        
        //MARK: START MHIOS-1225
        self.automaticallyAdjustsScrollViewInsets = false
        ProductCVC.register(for: self.collectionPLP)
        print("SANTHOSH SORT KEY completeUrl IS SATRT FUNCTION viewDidLoad : ")
        print("SANTHOSH registration FCM TOKEN : ", UserDefaults.standard.string(forKey: "fcm_token"))
        
        // Mark MHIOS-1130
        let event1 = ADJEvent(eventToken: AdjustEventType.ViewListing.rawValue)
        Adjust.trackEvent(event1)
        // Mark MHIOS-1130
        self.setupGridView()
        self.lblTitle.text = roomtite.uppercased()
        self.emptyView.isHidden = true
        // self.lblreadMoreTitle.text = self.category.title1
        //self.readMoreView.isHidden = true
        backActionLink(self.btnBack)
        // commented to hide the filter load view for better experience
        //self.showActivityIndicator(uiView: self.view)
        UserDefaults.standard.set("SORT", forKey: "sort_name")
        self.apiFilterOptions(categoryId: self.category_id){ response in
            DispatchQueue.main.async { [self] in
                print(response)
                self.filterSectionArray = response.available_filters
            }
        }
        if(self.isFromSearch==true)
        {
            print("SANTHOSH SORT KEY completeUrl IS SATRT FUNCTION A : ")
            self.apiProducts(page: 1){ response in
                DispatchQueue.main.async {
                    if(response.items?.count == 0||response.items==nil)
                    {
                        self.emptyView.isHidden = false
                    }
                    else
                    {
                        self.emptyView.isHidden = true
                    }
                    self.hideActivityIndicator(uiView: self.view)
                    print(response)
                    self.products = response as Products
                    self.collectionPLP.reloadData()
                }
                
            }
        }
        else if(self.isFromPopular==true)
        {
            print("SANTHOSH SORT KEY completeUrl IS SATRT FUNCTION B : ")
            self.pageCount = 1
            self.apiProducts(page: self.pageCount){ response in
                DispatchQueue.main.async {
                    print(response)
                    if(response.items?.count == 1||response.items==nil)
                    {
                        self.emptyView.isHidden = false
                    }
                    else
                    {
                        self.emptyView.isHidden = true
                    }
                    self.hideActivityIndicator(uiView: self.view)
                    self.products = response as Products
                    self.collectionPLP.reloadData()
                }
                
            }
        }
        else
        {
            print("SANTHOSH SORT KEY completeUrl IS SATRT FUNCTION C : ")
            print("SANTHOSH SORT KEY completeUrl IS SATRT FUNCTION : ")
            self.pageCount = 1
            self.apiProducts(page: self.pageCount){ response in
                DispatchQueue.main.async {
                    print(response)
                    if(response.items?.count == 0||response.items==nil)
                    {
                        self.emptyView.isHidden = false
                    }
                    else
                    {
                        self.emptyView.isHidden = true
                    }
                    self.hideActivityIndicator(uiView: self.view)
                    self.products = response as Products
                    self.collectionPLP.reloadData()
                }
                
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //UserDefaults.standard.set("SORT", forKey: "sort_name")
        self.collectionPLP.reloadData()
        print("SANTHOSH SORT KEY completeUrl IS SATRT FUNCTION viewWillAppear : ")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //UserDefaults.standard.set("SORT", forKey: "sort_name")
        //sectionHeader.labSort.text = "SORT"
    }
    override func viewDidDisappear(_ animated: Bool)  {
        self.hideActivityIndicator(uiView: self.view)
    }
    @IBAction func reTry(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        selectedItemsArray.removeAll()
        /* self.apiProducts(page: 1){ response in
         DispatchQueue.main.async {
         print(response)
         if(response.items?.count == 0||response.items==nil)
         {
         self.emptyView.isHidden = false
         }
         else
         {
         self.emptyView.isHidden = true
         }
         self.products = response as Products
         self.collectionPLP.reloadData()
         }
         self.collectionPLP.reloadData()
         }*/
    }
    func setupGridView() {
        
        let flow = collectionPLP?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(10.0)
        flow.minimumLineSpacing = CGFloat(10.0)
        flow.sectionHeadersPinToVisibleBounds = true
        
    }
    
    
    
    // MARK: - FILTER
    @objc func filterProducts(_ sender: UIButton) {
        let nextVC = AppController.shared.filter
        nextVC.delegate = self
        nextVC.isfromSearch = self.isFromSearch
        nextVC.categoryId = self.category_id
        nextVC.selectedItemsArray = self.selectedItemsArray
        nextVC.filterSectionArray=self.filterSectionArray
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func sortProducts(_ sender: UIButton) {
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
    }
   
    // MARK: - Sort
    func sortproduct(option:String)
    {
        print("sorttt \(option)")
        print("SANTHOSH HEADER VALUE CHNAGE NOW : CCCCCCCC")
        self.pageCount = 1
        sortOption = option
        UserDefaults.standard.set(option, forKey: "sort_name")
        sectionHeader.labSort.text = option
        self.showActivityIndicator(uiView: self.view)
        sectionHeader.getAvailableWidth()
        self.apiProducts(page: 1){ response in
            DispatchQueue.main.async {
                print(response)
                if(response.items?.count == 0)
                {
                    self.emptyView.isHidden = false
                }
                else
                {
                    self.emptyView.isHidden = true
                }
                self.hideActivityIndicator(uiView: self.view)
                self.products = response as Products
                self.collectionPLP.reloadData()
                self.collectionPLP.setContentOffset(CGPoint(x:0,y:0), animated: true)
                self.collectionPLP.collectionViewLayout.invalidateLayout()
            }
        }
    }

    func selectedFilterOptions(options: [FilterModel], filterSectionArray: [Available_filters]) {
        selectedItemsArray = options
        self.filterSectionArray = filterSectionArray
        self.showActivityIndicator(uiView: self.view)
        self.apiProducts(page: 1){ response in
            DispatchQueue.main.async {
                print(response)
                if(response.items?.count == 0)
                {
                    self.emptyView.isHidden = false
                }
                else
                {
                    self.emptyView.isHidden = true
                }
                self.hideActivityIndicator(uiView: self.view)
                self.products = response as Products
                self.collectionPLP.reloadData()
            }

        }
    }
    
    func selectedFilterOptionsRemoved(options: [FilterModel]) {
        selectedItemsArray = options
        self.apiFilterOptions(categoryId: self.category_id){ response in
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
                        if(response.items?.count == 0)
                        {
                            self.emptyView.isHidden = false
                        }
                        else
                        {
                            self.emptyView.isHidden = true
                        }
                        self.hideActivityIndicator(uiView: self.view)
                        self.products = response as Products
                        self.collectionPLP.reloadData()
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.collectionPLP.contentOffset.y >= ((self.collectionPLP.contentSize.height -  self.collectionPLP.bounds.size.height)/3)*2) {
            if !isPageRefreshing {
                isPageRefreshing = true
                pageCount = pageCount + 1
                if(self.isFromSearch==true)
                {
                    
                    self.apiProducts(page: pageCount){ response in
                        DispatchQueue.main.async {
                            self.isPageRefreshing = false
                            if(self.pageCount==1)
                            {
                                print("SANTHOSH response first")
                                self.products = response as Products
                                //self.collectionPLP.reloadData()
                                self.collectionPLP.reloadData()
                            }
                            else
                            {
                                print("SANTHOSH response Second")
                                let pageItems = response.items
                                self.products.items?.append(contentsOf: pageItems!)
                                self.collectionPLP.reloadData()
                                
                            }
                        }
                    }
                }
                else
                {
                    self.apiProducts(page: pageCount){ response in
                        DispatchQueue.main.async {
                            print("SANTHOSH response")
                            print(response)
                            self.isPageRefreshing = false
                            if(self.pageCount==1)
                            {
                                print("SANTHOSH response first")
                                self.products = response as Products
                                self.collectionPLP.reloadData()
                            }
                            else
                            {
                                print("SANTHOSH response Second")
                                let pageItems = response.items
                                if(pageItems != nil)
                                {
                                    self.products.items?.append(contentsOf: pageItems!)
                                    self.collectionPLP.reloadData()
                                }
                                
                                
                            }
                        }
                        
                    }
                }
            }
        }
    }
    func openDetail(tag:Int,sectionSelected:Int)
    {
        if isFromSearch
        {
            //            let productID = self.products.items![tag].id
            //            var tempROPArray = [Int]()
            //            tempROPArray = UserData.shared.recentOpenProduct
            //            if tempROPArray.contains(productID!) {
            //                print("yes")
            //            }
            //            else
            //            {
            //                tempROPArray.append(productID!)
            //                print("SANTHOSH ARRAY OPEN PDP PAGE A \(tempROPArray.count)")
            //                if 5 < tempROPArray.count
            //                {
            //                    tempROPArray = Array(tempROPArray.dropFirst(tempROPArray.count-5))
            //                }
            //
            //                UserData.shared.recentOpenProduct = tempROPArray
            //            }
        }
        
        print("OPEN PDP PAGE A \(self.products.items![tag].id)")
        print("SANTHOSH ARRAY OPEN PDP PAGE A \(UserData.shared.recentOpenProduct)")
        let nextVC = AppController.shared.productDetailsImages
        nextVC.productId = "\(self.products.items![tag].sku ?? "")"
        nextVC.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
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
    //MARK START{MHIOS-1029}
    func addToWishList(productId:String,tag:Int,sku:String)
        {
            Analytics.logEvent("add_to_wishlist", parameters: [
                
                AnalyticsParameterItemID: productId ,
                
            ])
            //MARK: START MHIOS-1064
            SmartManager.shared.trackEvent(event: "add_to_wishlist", properties: ["product_id": "\(productId)"])
            //MARK: END MHIOS-1064
            // Mark MHIOS-1130
            AdjustAnalytics.shared.createEvent(type: .AddToWishList)
            AdjustAnalytics.shared.createParam(key: KeyConstants.productId, value: productId)
            AdjustAnalytics.shared.track()
            // Mark MHIOS_1130
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MenuCategoryPLP: UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.products.items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(section==0)
        {
            if self.products.items?.count == 1 {
                
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                var width = UIScreen.main.bounds.width/2
                width = width+3
                let diff = width-178.5
                return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: width)
                
            }
            var width = self.view.frame.width/2;
            width = width - 178.5
            width = width/2
            let space = width/2
            width =  width+space
            return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        }
        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
        
        let underlineAttribute_test = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,NSAttributedString.Key.font: AppFonts.LatoFont.Bold(13)] as [NSAttributedString.Key : Any]
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:" ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))
        
        //let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 18.0)! ]
        
        cell.lblActualPrice.attributedText = attributeString
        cell.lblActualPrice.text = ""
        cell.lblOfferPrice.text = ""
        cell.tag = indexPath.row
        cell.lblName.font = AppFonts.LatoFont.Regular(13)
        cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
        cell.lblActualPrice.font = AppFonts.LatoFont.Bold(13)
        var product:Item = self.products.items![indexPath.row]
        cell.lblName.text = product.name
        cell.lblActualPrice.text = "\(product.price ?? 0) AED"
        cell.productId = Int(product.id ?? 0)
        let price = Double(product.price ?? 0)
        let priceString = String(format: "%.2f", price)
        let priceDouble = Double(priceString)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("SNATHOSH W PLP WISHLIST ID \(appDelegate.wishList)")
        print("SNATHOSH W PLP productID\(String(describing: product.id!))")
        let productInfo:String = "\(product.id ?? 0 )"
        
        //MARK START{MHIOS-1029}
        cell.sku = product.sku ?? ""
        ///var result = appDelegate.wishList.contains(productInfo)
        let productSKU:String = "\(product.sku ?? "" )"
        let modelToCheck = WishlistIDsModel(product_id: Int(productInfo) ?? 0, sku: productSKU)
        var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
        //MARK END{MHIOS-1029}
        print("SNATHOSH W PLP result\(result)")
        if(result == true)
        {
            print("SNATHOSH W PLP STATUS TRUE")
            print("SNATHOSH W PLP STATUS \(product.id!)")
            //cell.btnLike.isEnabled = false
            cell.btnLike.setImage(UIImage(named: "liked"), for: .normal)
        }
        else
        {
            print("SNATHOSH W PLP STATUS FALSE")
            //print("SNATHOSH W PLP STATUS \(product.id!)")
            // cell.btnLike.isEnabled = true
            cell.btnLike.setImage(UIImage(named: "like_button"), for: .normal)
        }
        
        var specialPrice = ""
        var specialToDate = ""
        var specialFromDate = ""
        for item in product.customAttributes ?? [] {
            switch item.value {
            case .string(let stringValue):
                if item.attribute_code == "special_price"{
                    if let floatNumber = Float(stringValue) {
                        let priceDouble = Double(floatNumber)
                        specialPrice = formatNumberToThousandsDecimal(number: priceDouble)
                        cell.lblOfferPrice.text = specialPrice + " AED"
                    }
                }
                if item.attribute_code == "special_from_date"{
                    specialFromDate = "\(stringValue ?? "")"
                    //productPriceLbl.text = "\(item.value ?? "")"
                    print("special_from_date")
                    print("\(stringValue ?? "")")
                }
                if item.attribute_code == "special_to_date"{
                    specialToDate = "\(stringValue ?? "")"
                    print("special_to_date")
                    print("\(stringValue ?? "")")
                    //productPriceLbl.text = "\(item.value ?? "")"
                }
                
            case .stringArray(let stringArrayValue):
                print("String array value: \(stringArrayValue)")
            case .none:
                print("")
                
            }
        }
        let actualPriceDouble = product.price ?? 0.00;
        let formatedActualPrice = formatNumberToThousandsDecimal(number: actualPriceDouble)

        
        let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
        if specialPriceFlag
        {
            
            //                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 18.0)! ]
            //                let myString = NSMutableAttributedString(string: "Swift", attributes: myAttribute )
            
            //let underlineAttribute = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue , NSAttributedString.Key.font: AppFonts.LatoFont.Bold(13)] as [NSAttributedString.Key : Any]
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatedActualPrice + " AED" )")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            
            cell.lblActualPrice.attributedText = attributeString
            ///cell.lblOfferPrice.text = "\(formatNumberToThousandsDecimal(number: product.price ?? 0 ) + " AED")"
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
            ///cell.lblActualPrice.text = formatNumberToThousandsDecimal(number:product.price ?? 0) + " AED"
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatedActualPrice + " AED")")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))
            
            cell.lblActualPrice.attributedText = attributeString
            cell.lblActualPrice.isHidden = false
        }
        
        cell.imageArray.removeAll()
        cell.imageArray = product.media_gallery_entries!
        var temp:[Media_gallery_entries] = []
        ///var optionArray:[KingfisherParsedOptionsInfo] = [] //KingfisherOptionsInfo = [KingfisherOptionsInfoItem]
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
                sliderImages.append(KingfisherSource(urlString: "\(AppInfo.shared.gumletProductImageURL)\(p.file ?? "")",placeholder:placeholderImage,options:options)!)
                ///sliderImages.append(KingfisherSource(urlString: "https://cdn.filmytoday.com/attachments/albums/dpdddds/ddddddddddd.jpg",placeholder: placeholderImage,options:options)!)//[onFailureImage:placeholderImage]
                ///print("SANTHOSH IMAGE URL \(AppInfo.shared.gumletProductImageURL)\(p.file ?? "")")
            }
            if i == 2
            {
              break
            }
        }
        cell.tag = indexPath.row
        
        cell.productDelegate = self
        cell.setImages(sliderImages:sliderImages)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.view.frame.size.height
        var width = UIScreen.main.bounds.width/2
        width = width - 9
        let diff = width-178.5
        switch indexPath.section {
        case 0:
            return CGSize(width:width, height: width+72)
        default:
            
            // in case you you want the cell to be 40% of your controllers view
            return CGSize(width:width, height: width+72)
        }
    }
    
    // MARK UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section != 0{
            print("OPEN PDP PAGE ")
            let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = "\(self.products.items![indexPath.item].sku ?? "")"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterHeaderView", for: indexPath) as! FilterHeaderView
            var width = self.view.frame.width/2;
            width = width - 178.5
            width = width/2
            let space = width/2
            width =  width+space
            //sectionHeader.filterViewleading.constant = width - 8
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
            
            return CGSize(width: collectionView.frame.width, height: 70)
            
        }
        return CGSize(width: 0, height: 0)
    }
    
}

public extension KFOptionSetter {
    func onFailureImage(_ image: KFCrossPlatformImage? = nil) -> Self {
        let placeholderImage = UIImage(named: "failure_image.png")
        options.onFailureImage = .some(placeholderImage)
        return self
    }
}
