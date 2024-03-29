//
//  SearchController.swift
//  Marina Home
//
//  Created by Eljo on 04/07/23.
////MARK START{MHIOS-1206}
///Autoresizing addded in UI side
/////MARK END{MHIOS-1206}
//////////MARK START{MHIOS-1215}
///Changed the  productDefault image to product_placeholder_img in UI side
/////MARK END{MHIOS-1215}

import UIKit
import Firebase
import Adjust
import FirebaseAnalytics

class SearchVC: AppUIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,PopularCatogorySelectDelegate, ProductCardDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func redirectToLoginPage() {
        
    }
    func openDetail(tag:Int,sectionSelected:Int)
    {
        print("SANTHOSH OPEN PDP PAGE ")
        if sectionSelected == 2
        {
            let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = "\(self.recentProductsArray[tag].sku ?? "")"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else
        {
            let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = "\(self.newArrivalsProductsArray[tag].sku ?? "")"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        
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
    // MARK START MHIOS_1058
    @IBOutlet weak var lblNoresult: UILabel!
    @IBOutlet weak var productsHeader: UIView!
    @IBOutlet weak var popularHeader: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var NoResultHeader: UIView!
    var newArrivalsProductsArray:[RecordsYML] = []
    var recentProductsArray:[RecordsYML] = []
    var response:SearchResponse?
    // MARK END MHIOS_1058
    //MARK: START MHIOS-1243
    let dispatchGroup = DispatchGroup()
    //MARK: END MHIOS-1243
    //MARK START{MHIOS-872}
    var popularSearchArray:[String] = []
    @IBOutlet weak var popularHeaderText: UILabel!
    //MARK END{MHIOS-872}
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backToRootLink(self.btnBack)
        self.searchBar.delegate = self

        //MARK: START MHIOS-1243
        self.searchBar.isUserInteractionEnabled = false
        //MARK: END MHIOS-1243

        self.searchBar.setTextFieldColor(.white)
        self.searchBar.searchTextField.delegate = self
        self.searchBar.searchTextField.backgroundColor = .white
        self.searchBar.searchTextField.layer.borderWidth = 0.6
        self.searchBar.searchTextField.layer.cornerRadius = 4
        self.searchBar.searchTextField.layer.masksToBounds = true
        self.searchBar.inputAccessoryView = UIView(frame: CGRect.zero)
        self.searchBar.searchTextField.layer.borderColor = UIColor.black.cgColor
        self.searchBar.searchTextField.font = UIFont(name: AppFontLato.light, size: 13)
        
        self.searchBar.searchTextField.leftView?.tintColor = .black
        self.searchBar.setImage(UIImage(named: "Group 1194"), for: .search, state: .normal)
        self.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 10, vertical: 0)
        //MARK START{MHIOS-872}
        self.apiGetPopularSearch(){ response in
            self.popularSearchArray = response.popularSearchesArray ?? []
            //self.popularSearchArray = ["Abcdd","adjagjbh","adjagjbh","adj666agjbh","adjaetegjbh","adjagjbh","adjagjbh","adjagjbh","adjagjbh","adjagvcskj jbh","adjascjkgjbh","adjacsngjbh","adja2ywgjbh","adjqeuagjbh"]//response.popularSearchesArray ?? []
            self.tblSearch.reloadData()
        }
        //MARK END{MHIOS-872}
        self.apiGetSearchDetail(text:"new in"){ response in
            self.response = response
            self.tblSearch.reloadData()
        }
        //MARK: START MHIOS-1243
        dispatchGroup.enter()
        //MARK: END MHIOS-1243
        self.apiGetQueryNewArrivals() { response in
            let jsonString = response.search?.payload
            let data: Data? = jsonString?.data(using: .utf8)
            let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]
            self.apiNewArrival(recordQueries: json!){ response in
                DispatchQueue.main.async {
                    if response.queryResultsYML?.count ?? 0 > 0{
                        self.newArrivalsProductsArray = (response.queryResultsYML?[0].recordsYML!)!
                        self.tblSearch.reloadData()
                        
                    }
                    //MARK: START MHIOS-1243
                    self.dispatchGroup.leave()
                    //MARK: END MHIOS-1243
                }
            }
        }
        //MARK: START MHIOS-1243
        dispatchGroup.enter()
        //MARK: END MHIOS-1243
        self.apiRecentProducts(page: 0) { response in
            if(response.queryResultsYML != nil)
            {
                self.recentProductsArray = (response.queryResultsYML?[0].recordsYML!)!
            }
            self.tblSearch.reloadData()
            //MARK: START MHIOS-1243
            self.dispatchGroup.leave()
            //MARK: END MHIOS-1243
        }
        //MARK: START MHIOS-1243
        dispatchGroup.notify(queue: .main) {
            self.searchBar.isUserInteractionEnabled = true
            self.searchBar.searchTextField.becomeFirstResponder()
        }
        //MARK: END MHIOS-1243

    }
    @IBAction func newViewAll(_ sender: Any) {
        
        var vc = AppController.shared.menuPLP
        vc.category_id =   "362"
        vc.roomtite = "NEW ARRIVALS"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ViewAll(_ sender: Any) {
        if(self.searchBar.text == "")
        {
            var vc = AppController.shared.menuPLP
            vc.category_id =   "362"
            vc.roomtite = "POPULAR PRODUCTS"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            var vc = AppController.shared.menuPLP
            vc.category_id =  self.searchBar.text ?? ""
            vc.isFromSearch = true
            vc.roomtite = self.searchBar.text?.uppercased() ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    // Mark MHIOS-1130
    func sendAdjustEvent(searchText : String)
    {
        AdjustAnalytics.shared.createEvent(type: .SearchProduct)
        AdjustAnalytics.shared.createParam(key: KeyConstants.searchKey, value: searchText)
        AdjustAnalytics.shared.track()
    }
    // Mark MHIOS-1130
    //MARK START{MHIOS-872}
    func selectedPopularSearch(name:String) {
        
        var vc = AppController.shared.menuPLP
        vc.category_id = name
        vc.isFromSearch = true
        vc.roomtite =  name
        // Mark MHIOS-1130
        self.sendAdjustEvent(searchText: name)
        // Mark MHIOS-1130
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cetogeryHeightCalculat(array:[RecordsYML]) -> CGFloat {
        var totalLenght = 1
        let screenSize = UIScreen.main.bounds
        let screenWidth = (screenSize.width)
        let screenWidthInt = Int(screenWidth)
        var itemWidth = 0

        for  var item in array
        {
            let textLenght = Int((item.name?.size(withAttributes: [NSAttributedString.Key.font : AppFonts.LatoFont.Regular(13)]).width ?? 0) + 18) //38
            itemWidth = itemWidth+textLenght
            
            if screenWidthInt <= itemWidth
            {
                itemWidth = 0
                itemWidth = textLenght
                totalLenght = totalLenght+1
            }
        }
        return CGFloat((totalLenght*45)+5)
    }
    
    func popularSearchHeightCalculat(array:[String]) -> CGFloat {
        
        var totalLenght = 1
        let screenSize = UIScreen.main.bounds
        let screenWidth = (screenSize.width)
        let screenWidthInt = Int(screenWidth)
        var itemWidth = 0

        for  var item in array
        {
            let textLenght = Int((item.size(withAttributes: [NSAttributedString.Key.font : AppFonts.LatoFont.Regular(13)]).width ?? 0) + 18) //38
            itemWidth = itemWidth+textLenght
            
            if screenWidthInt <= itemWidth
            {
                itemWidth = 0
                itemWidth = textLenght
                totalLenght = totalLenght+1
            }
        }
        return CGFloat((totalLenght*45)+5)
    }
    //MARK END{MHIOS-872}
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if(self.searchBar.text == ""||self.response?.suggestionResults[0].suggestions.count==0 && self.response?.queryResults[0].records?.count==0)
        {
            //MARK START{MHIOS-872}
            return 4
            //MARK END{MHIOS-872}
        }
        else
        {
            return 3
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(self.searchBar.text == ""||self.response?.suggestionResults[0].suggestions.count==0 && self.response?.queryResults[0].records?.count==0)
        {
            var width = UIScreen.main.bounds.width/2
            let diff = width-130
            
            switch indexPath.section {
            case 0:
                return  0
            case 1:
                //MARK START{MHIOS-872}
                let rowHeight = (popularSearchHeightCalculat(array: popularSearchArray))
                //return  rowHeight
                return UITableView.automaticDimension
               // return  70
                //MARK END{MHIOS-872}
            case 2:
                return  270+diff
            case 3:
                return  270+diff
            default:
                return  270+diff
            }
            
        }
        else
        {
            switch indexPath.section {
            case 0:
                return  50
            case 1:
                if  self.response?.queryResults[1].records?.count == 0
                {
                    return  0
                }
                else
                {
                    //MARK START{MHIOS-872}
                    let rowHeight = (cetogeryHeightCalculat(array: (self.response?.queryResults[1].records)!))
                    ///return  rowHeight
                    return UITableView.automaticDimension
                    //MARK END{MHIOS-872}
                }
                
            case 2:
                if  self.response?.queryResults[0].records?.count != 0
                {
                    return  136
                }
                else
                {
                    return 0
                }
            default:
                return  50
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if(self.searchBar.text == ""||self.response?.suggestionResults[0].suggestions.count==0 && self.response?.queryResults[0].records?.count==0)
        {
            
            switch section {
            case 0:
                return  1
            case 1:
                return 1
                
            default:
                return  1
            }
            
        }
        else
        {
            switch section {
            case 0:
                return  self.response?.suggestionResults[0].suggestions.count ?? 0
            case 1:
                if  self.response?.queryResults[1].records?.count == 0
                {
                    return  0
                }
                else
                {
                    return  1
                }
            case 2:
               
                return  self.response?.queryResults[0].records?.count ?? 0
                
            default:
                return  1
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: START MHIOS-1250
        if self.response?.suggestionResults.count ?? 0 > 0 && self.response?.queryResults.count ?? 0 > 0
        {
            if(self.searchBar.text == ""||self.response?.suggestionResults[0].suggestions.count==0 && self.response?.queryResults[0].records?.count==0)
            {
            //MARK START{MHIOS-872}
            switch indexPath.section {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularCatogoryTVC", for: indexPath) as? PopularCatogoryTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
                //MARK START{MHIOS-872}
                cell.popularSearchStatus = true
                cell.popularSearchArray = []
                //MARK END{MHIOS-872}
                cell.delegate = self
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                cell.selectionStyle = .none
                //MARK START{MHIOS-872}
                //cell.collectionCategory.reloadData()
                cell.setDataFunc()
                //MARK END{MHIOS-872}
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularCatogoryTVC", for: indexPath) as? PopularCatogoryTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
                //MARK START{MHIOS-872}
                cell.popularSearchStatus = true
                cell.popularSearchArray = popularSearchArray
                //MARK END{MHIOS-872}
                cell.delegate = self
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                cell.selectionStyle = .none
                //MARK START{MHIOS-872}
                //cell.collectionCategory.reloadData()
                cell.setDataFunc()
                //MARK END{MHIOS-872}
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggesionNewArrivalCell", for: indexPath) as? SuggesionNewArrivalCell else { return UITableViewCell() }
                cell.newArrivalsProductsCV.delegate = self
                cell.newArrivalsProductsCV.dataSource = self
                cell.newArrivalsProductsCV.reloadData()
                cell.selectionStyle = .none
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyViewedCell", for: indexPath) as? RecentlyViewedCell else { return UITableViewCell() }
                cell.recentlyViewedProductsCV.delegate = self
                cell.recentlyViewedProductsCV.dataSource = self
                cell.recentlyViewedProductsCV.reloadData()
                cell.selectionStyle = .none
                return cell
            }
            //MARK END{MHIOS-872}
        }
        else
        {
            switch indexPath.section {
            case 0:
                let s:Suggestion = (self.response?.suggestionResults[0].suggestions[indexPath.row])!
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggessionTVC", for: indexPath) as? SuggessionTVC else { return UITableViewCell() }
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 13.0)! ]
                
                cell.lblName.attributedText = s.suggest.htmlToAttributedString()
                cell.selectionStyle = .none
                return cell
            case 1:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "PopularCatogoryTVC", for: indexPath) as? PopularCatogoryTVC else { return UITableViewCell() }
                cell.selectionStyle = .none
                //MARK START{MHIOS-872}
                cell.popularSearchStatus = false
                //MARK END{MHIOS-872}
                cell.suggestions = (self.response?.queryResults[1].records)!
                cell.delegate = self
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                cell.selectionStyle = .none
                //MARK START{MHIOS-872}
                //cell.collectionCategory.reloadData()
                cell.setDataFunc()
                //MARK END{MHIOS-872}
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductTVC", for: indexPath) as? SearchProductTVC else { return UITableViewCell() }
                let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
                let animatedGif = UIImage.sd_image(withGIFData: imageData)
                //cell.imgImage.image = animatedGif
                let cellData:RecordsYML = (self.response?.queryResults[0].records?[indexPath.row])!
               /* let price = Int(s.startPrice)
                let price1 = Int(s.price) ?? 0
                print("SANTHOSH price IS : \(price)")
                print("SANTHOSH price1 IS : \(price1)")
                print("SANTHOSH price New IS : \(s.toPrice)")
                //cell.lblPrice.text =  "\(formatNumberToThousandsDecimal(number:price ?? 0) ) AED  "
                cell.lblPrice.text =  ""
                cell.lblActualPrice.text =  "\(formatNumberToThousandsDecimal(number:price1 ?? 0) ) AED"
                
                cell.lblname.text = s.name.uppercased()
                if( s.imageURL == "")
                {
                }
                else
                {
                    let imageMain = s.imageURL.replacingOccurrences(of: "/needtochange", with: "", options: NSString.CompareOptions.literal, range:nil)
                    print("SANTHOSH IMAGE URL : ")
                    print(imageMain)
                    let url = URL(string: "\(imageMain)")!
                    
                    cell.lblName.attributedText = s.suggest.htmlToAttributedString()
                    cell.selectionStyle = .none
                    return cell*/
                    
                    cell.lblname.font = AppFonts.LatoFont.Regular(13)
                    cell.lblPrice.font = AppFonts.LatoFont.Bold(13)
                    cell.tag = indexPath.row
                    cell.lblname.text = cellData.name
                    let pId = (cellData.id! as String)
                    let placeholderImage = UIImage(named: "failure_image.png")
                    cell.imgImage.image = animatedGif
                    if(cellData.imageUrl != "")
                    {
                        let imageMain = cellData.imageUrl!.replacingOccurrences(of: "/needtochange", with: "", options: NSString.CompareOptions.literal, range:nil)
                        let urlString = "\(imageMain)"
                        let url = URL(string: urlString)
                        if let imageUr = url
                        {
                            // Load the image with Kingfisher and handle the result
                            cell.imgImage.kf.setImage(with: imageUr, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                                switch result {
                                case .success(let value):
                                    cell.imgImage.image = value.image
                                case .failure(let error):
                                    cell.imgImage.image = placeholderImage
                                    print("Image loading failed with error: \(error)")
                                }
                            }
                        }
                    }
                    //MARK START{MHIOS-1215}
                    else
                    {
                        cell.imgImage.image = placeholderImage
                    }
                    //MARK END{MHIOS-1215}
                                
                                var salePrice = 0.0
                                if let floatNumber = Float(cellData.salePrice ?? "0.00") {
                                    salePrice = Double(floatNumber)
                                }
                                else
                                {
                                    salePrice = 0
                                }
                                
                                let price = Double(cellData.price ?? "0") ?? 0.0
                                
                                cell.lblPrice.text = String(format: "%.2f", price) + " AED"
                                cell.lblActualPrice.isHidden = true
                                
                                if cellData.salePrice != ""
                                {
                                    if salePrice < price
                                    {
                                        cell.lblPrice.text = "\(formatNumberToThousandsDecimal(number: salePrice ) + " AED")"
                                        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                                        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatNumberToThousandsDecimal(number: price ) + " AED")")
                                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                                        
                                        cell.lblActualPrice.attributedText = attributeString
                                        cell.lblActualPrice.isHidden = false
                                        cell.lblPrice.isHidden = false
                                    }
                                    else
                                    {
                                        cell.lblPrice.isHidden = true
                                        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                                        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatNumberToThousandsDecimal(number: price ) + " AED")")
                                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))
                                        
                                        cell.lblActualPrice.attributedText = attributeString
                                        cell.lblActualPrice.isHidden = false
                                    }
                                    
                                }
                                else
                                {
                                    cell.lblPrice.isHidden = true
                                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatNumberToThousandsDecimal(number: price ) + " AED")")
                                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))
                                    
                                    cell.lblActualPrice.attributedText = attributeString
                                    cell.lblActualPrice.isHidden = false
                                }
                                
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                cell.selectionStyle = .none
                                return cell
                            default:
                                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggessionTVC", for: indexPath) as? SuggessionTVC else { return UITableViewCell() }
                                
                                
                                return cell
                            }
                        }
                    }
    
        return UITableViewCell()
        //MARK: END MHIOS-1250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SANTHOSH OPEN PDP PAGE tableView")
        //MARK: START MHIOS-1064
        SmartManager.shared.trackEvent(event: "search", properties: ["search_text": "\(self.searchBar.text ?? "")"])
        //MARK: END MHIOS-1064
        if(self.searchBar.text == "")
        {
            /*let s:RecordProducts = (self.response?.queryResults[0].records?[indexPath.row])!
             let nextVC = AppController.shared.productDetailsImages
             nextVC.productId =  s.sku
             nextVC.wishListId = s.sku
             self.navigationController?.pushViewController(nextVC, animated: true)*/
        }
        else
        {
            //MARK: START MHIOS-1251
            if indexPath.section == 0{
                if self.response?.suggestionResults.count ?? 0 > 0
                {
                    if self.response?.suggestionResults[0].suggestions.count ?? 0 > indexPath.row
                    {
                        let s:Suggestion = (self.response?.suggestionResults[0].suggestions[indexPath.row])!
                        let vc = AppController.shared.menuPLP
                        vc.category_id = s.suggest.htmlToAttributedString()?.string ?? ""
                        vc.isFromSearch = true
                        vc.roomtite =  s.suggest.htmlToAttributedString()?.string ?? ""
                        // Mark MHIOS-1130
                        self.sendAdjustEvent(searchText: s.suggest.htmlToAttributedString()?.string ?? "")
                        // Mark MHIOS-1130
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            if indexPath.section == 2{
                if self.response?.queryResults.count ?? 0 > 0
                {
                    if self.response?.queryResults[0].records?.count ?? 0 > indexPath.row
                    {
                        let s:RecordsYML = (self.response?.queryResults[0].records?[indexPath.row])!
                        let nextVC = AppController.shared.productDetailsImages
                        nextVC.productId =  s.sku ?? ""
                        nextVC.wishListId = s.sku ?? ""
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
        }
        //MARK: END MHIOS-1251
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //MARK START{MHIOS-872}
        if(self.searchBar.text == ""||self.response?.suggestionResults[0].suggestions.count==0 && self.response?.queryResults[0].records?.count==0)
        {
            switch section {
            case 0:
                if(self.searchBar.text != "")
                {
                    var attributedText: NSMutableAttributedString = NSMutableAttributedString(string: "Your search \"\(self.searchBar.text ?? "")\" does not match any products.")
                    let boldAttributes: [NSAttributedString.Key: Any] = [
                       .font: AppFonts.LatoFont.Bold(13),
                       .foregroundColor: AppColors.shared.Color_black_000000
                    ]
                    let regularAttributes: [NSAttributedString.Key: Any] = [
                       .font: AppFonts.LatoFont.Regular(13),
                       .foregroundColor: AppColors.shared.Color_black_000000
                    ]
                    var attributeString = NSMutableAttributedString(
                       string: "Your search \"",
                       attributes: regularAttributes)
                    var attributeString2 = NSMutableAttributedString(
                       string: "\" does not match any products.",
                       attributes: regularAttributes)
                    var attributeString1 = NSMutableAttributedString(
                       string: "\(self.searchBar.text ?? "")",
                       attributes: boldAttributes)
                     attributeString.append(attributeString1)
                    attributeString.append(attributeString2)

                  
                    self.lblNoresult.attributedText = attributeString
                    return self.NoResultHeader
                }
                else
                {
                    return  nil
                }
            case 1:
                popularHeaderText.text = "POPULAR SEARCHES"
                return  popularHeader
            case 2:
                return nil
            default:
                return  nil
            }

        }
        //MARK END{MHIOS-872}
        else
        {
            switch section {
            case 0:
                return  headerView
            case 1:
                if  self.response?.queryResults[1].records?.count != 0
                {
                    //MARK START{MHIOS-872}
                    popularHeaderText.text = "POPULAR CATEGORIES"
                    //MARK END{MHIOS-872}
                    return  popularHeader
                }
                else
                {
                    return  nil
                }
                
            case 2:
                if  self.response?.queryResults[0].records?.count != 0
                {
                    return  productsHeader
                }
                else
                {
                    return  nil
                }
                
            default:
                return  headerView
            }
        }
        
    }
    //MARK: START MHIOS-1243
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //MARK START{MHIOS-872}
        if(self.searchBar.text == ""||getErrorFlag())
        {
            switch section {
            case 0:
                if(self.searchBar.text != "")
                {
                    return 30
                }
                else
                {
                    return 0
                }
            case 1:
                return  40
            case 2:
                return 0
            case 3:
                return 0
            default:
                return  0
            }
        }
        else
        {
            switch section {
            case 0:
                
                if(getSuggessionFlag())
                {
               
                    return 0
                }
                else
                {
                    return 40.0
                }
                
            case 1:
                if(getCategoryFlag())
                {
                    return 40.0
                }
                else
                {
                    return 0
                }
                
            case 2:
                if(getProductFlag())
                {
                    return 40.0
                }
                else
                {
                    return 0
                }
            default:
                return 0
            }
        }
        //MARK END{MHIOS-872}
        
    }
    func getSuggessionFlag()->Bool
    {
        if(self.response?.suggestionResults.count ?? 0 > 0)
        {
            return self.response?.suggestionResults[0].suggestions.count==0
        }
        else
        {
            return false
        }
    }
    func getProductFlag()->Bool
    {
        if(self.response?.queryResults.count ?? 0 > 0)
        {
            return self.response?.queryResults[0].records?.count != 0
        }
        else
        {
            return false
        }
        
    }
   func getCategoryFlag()->Bool
   {
       if(self.response?.queryResults.count ?? 0 > 1)
       {
           return self.response?.queryResults[1].records?.count != 0
       }
       else
       {
           return false
       }
   }
    func getErrorFlag()->Bool
    {
        if(self.response?.suggestionResults.count ?? 0 > 0 && self.response?.queryResults.count ?? 0 > 0)
        {
        
            return self.response?.suggestionResults[0].suggestions.count==0 && self.response?.queryResults[0].records?.count==0
        }
        else
        {
            return true
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       let txt = self.searchBar.text ?? ""
        //MARK: START MHIOS-1225
        CrashManager.shared.log("AlertPopUpVC_Search Text: \(txt)")
        //MARK: START MHIOS-1225
            DispatchQueue.global(qos: .background).async {
                self.apiGetSearchDetail(text: txt ){ response in
                    //MARK: START MHIOS-1225
                    CrashManager.shared.addKey(key: "search_text_value", value: "\(response)")
                    //MARK: START MHIOS-1225
                    self.response = response
                    DispatchQueue.main.async {
                        self.tblSearch.reloadData()
                    }
                }
            }
        
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end editing")
        
    }
    func searchBarSearchButtonClicked(_ seachBar: UISearchBar) {
        var vc = AppController.shared.menuPLP
        vc.category_id =  self.searchBar.text ?? ""
        vc.isFromSearch = true
        vc.roomtite = self.searchBar.text?.uppercased() ?? ""
        // Mark MHIOS-1130
        self.sendAdjustEvent(searchText: self.searchBar.text ?? "")
        // Mark MHIOS-1130
        let event1 = ADJEvent(eventToken: "r35z2o")
        Adjust.trackEvent(event1)
        Analytics.logEvent("search", parameters: [
            AnalyticsParameterSearchTerm:"\(self.searchBar.text ?? "")"
        ])
        Analytics.logEvent("show_search_results", parameters: [
            AnalyticsParameterSearchTerm:"\(self.searchBar.text ?? "")"
          
        ])
        //MARK: START MHIOS-1064
        SmartManager.shared.trackEvent(event: "search", properties: ["search_text": "\(self.searchBar.text ?? "")"])
        //MARK: END MHIOS-1064
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func selectedCategory(id: String, name:String) {
        var vc = AppController.shared.menuPLP
        let parsed = id.replacingOccurrences(of: "categoryid_", with: "")
        vc.category_id =  parsed
        vc.roomtite = name.uppercased()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var vc = AppController.shared.menuPLP
        vc.category_id =  self.searchBar.text ?? ""
        vc.isFromSearch = true
        vc.roomtite = self.searchBar.text?.uppercased() ?? ""
        // Mark MHIOS-1130
        self.sendAdjustEvent(searchText: self.searchBar.text ?? "")
        // Mark MHIOS-1130
        self.navigationController?.pushViewController(vc, animated: true)
        return true
    }
    
    func addToWishList(productId:String,tag:Int)
    {
        if UserData.shared.isLoggedIn
        {
            self.apiAddToWishlist(id: productId){ responseData in
                DispatchQueue.main.async {
                    print(responseData)
                    if responseData{
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.wishList.append(productId)
            //self.collectionPLP.reloadData()
            //self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
            
            self.showAlert(message: "Please log in or register to view your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
                self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
            }, leftAction: {})
        }
    }
    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var width = UIScreen.main.bounds.width/2
        width = width - 9
        return CGSize(width: width, height: width+72)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
       return 6
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
       return 6
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1
        {
            return newArrivalsProductsArray.count
        }
        else
        {
            return recentProductsArray.count
                
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
        let underlineAttribute_test = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:" ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))
        
        if collectionView.tag == 1
        {
            var cellData = newArrivalsProductsArray[indexPath.item]
            cell.lblActualPrice.attributedText = attributeString
            cell.lblActualPrice.text = ""
            cell.lblOfferPrice.text = ""
            cell.tag = indexPath.row
            cell.sectionSelected = 1
            cell.lblName.font = AppFonts.LatoFont.Regular(13)
            cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
            var product:RecordsYML = self.newArrivalsProductsArray[indexPath.row]
            cell.lblName.text = product.name
            cell.lblActualPrice.text = "\(product.price ?? "") AED"
            cell.productId = Int(product.id!) ?? 0
            let price = Double(product.price!)
            let priceString = String(format: "%.2f", price!)
            let priceDouble = Double(priceString)
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            print("\(appDelegate.wishList)")
            print("productID\(String(describing: product.id))")
            let productInfo:String = "\(product.id ?? "" )"

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
                cell.btnLike.setImage(UIImage(named: "like_button"), for: .normal)
            }
            
            var specialPrice = ""
            
            for item in product.customAttributes ?? [] {
                switch item.value {
                case .string(let stringValue):
                    if item.attribute_code == "special_price"{
                        if let floatNumber = Float(stringValue) {
                            let spPriceVal = Double(floatNumber)
                            specialPrice = formatNumberToThousandsDecimal(number: spPriceVal )
                            cell.lblOfferPrice.text = specialPrice + " AED"
                        }
                    }
                    
                case .stringArray(let stringArrayValue):
                    print("String array value: \(stringArrayValue)")
                case .none:
                    print("")
                    
                }
            }
            
            var salePrice = 0.0
             if let floatNumber = Float(product.salePrice ?? "0.00") {
                 salePrice = Double(floatNumber)
             }
            
            let prodPriceDouble = Double(product.price ?? "0") ?? 0
            let prodPrice = formatNumberToThousandsDecimal(number: prodPriceDouble)
        
            
            //let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
            if salePrice < prodPriceDouble
            {
                cell.lblOfferPrice.text = "\(formatNumberToThousandsDecimal(number: salePrice ) + " AED")"
                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(prodPrice + " AED" )")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                
                cell.lblActualPrice.attributedText = attributeString
                ///cell.lblOfferPrice.text = "\(formatNumberToThousandsDecimal(number: product.price ?? 0 ) + " AED")"
                cell.lblActualPrice.isHidden = false
                cell.lblOfferPrice.isHidden = false
                cell.lblActualPrice.font = AppFonts.LatoFont.Regular(13)
            }
            else
            {
                cell.lblOfferPrice.isHidden = true
                cell.lblActualPrice.font = AppFonts.LatoFont.Bold(13)
                ///cell.lblActualPrice.text = formatNumberToThousandsDecimal(number:product.price ?? 0) + " AED"
                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(prodPrice + " AED")")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))

                cell.lblActualPrice.attributedText = attributeString
                cell.lblActualPrice.isHidden = false
            }
            
            let imageMain = cellData.imageUrl!.replacingOccurrences(of: "/needtochange", with: "", options: NSString.CompareOptions.literal, range:nil)
            print("SANTHOSH IMAGE URL : ")
            print(imageMain)
            cell.imageArrayRec = imageMain
            cell.file = imageMain//cellData.image
            cell.setImages(sliderImages: [])
//            DispatchQueue.main.async {
//                let flowLayout = UICollectionViewFlowLayout()
//                flowLayout.scrollDirection = .horizontal
//                flowLayout.itemSize = CGSize(width: 128, height: 128)
//                cell.collectionImages.collectionViewLayout = flowLayout
//                cell.collectionImages.reloadData()
//            }
            cell.tag = indexPath.row
            cell.productDelegate = self
        }
        else
        {
            var cellDatas = recentProductsArray[indexPath.row] //.queryResultsYML?[0].recordsYML as! [RecordsYML]
            
            cell.lblActualPrice.attributedText = attributeString
            cell.lblActualPrice.text = ""
            cell.lblOfferPrice.text = ""
            cell.tag = indexPath.row
            cell.sectionSelected = 2
            cell.lblName.font = AppFonts.LatoFont.Regular(13)
            cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
            //var product:Item = self.recentProductsArray[indexPath.row]
            cell.lblName.text = cellDatas.name
            cell.lblActualPrice.text = "\(cellDatas.price ?? "0") AED"
            cell.productId = Int(cellDatas.id!)!
            let price = Double(cellDatas.price!)
            let priceString = String(format: "%.2f", price!)
            let priceDouble = Double(priceString)
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            print("\(appDelegate.wishList)")
            print("productID\(String(describing: cellDatas.id))")
            let productInfo:String = "\(cellDatas.id ?? "0" )"
            
            //MARK START{MHIOS-1029}
            ///var result = appDelegate.wishList.contains(productInfo)
            let productSKU:String = "\(cellDatas.sku ?? "" )"
            cell.sku = productSKU
            let modelToCheck = WishlistIDsModel(product_id: Int(productInfo) ?? 0, sku: productSKU)
            var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
            //MARK END{MHIOS-1029}
            if(result == true)
            {
                //cell.btnLike.isEnabled = false
                cell.btnLike.setImage(UIImage(named: "liked"), for: .normal)
            }
            else
            {
                // cell.btnLike.isEnabled = true
                cell.btnLike.setImage(UIImage(named: "like_button"), for: .normal)
            }
            
            var salePrice = 0.0
            if let floatNumber = Float(cellDatas.salePrice ?? "0.00") {
                salePrice = Double(floatNumber)
                ///print(integerNumber) // Output: 123
                
            }
            else
            {
                print("Invalid number")
                salePrice = 0
            }
            
            let priceVal = Double(cellDatas.price ?? "0.00") ?? 0.0
            let actualPrice = formatNumberToThousandsDecimal(number: priceVal)
            
            cell.lblOfferPrice.text = actualPrice + " AED"
            cell.lblActualPrice.isHidden = true
            
            if cellDatas.salePrice != ""
            {
                if salePrice < priceVal
                {
                    cell.lblOfferPrice.text = "\(formatNumberToThousandsDecimal(number: salePrice ) + " AED")"
                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(actualPrice + " AED")")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                    
                    cell.lblActualPrice.attributedText = attributeString
                    ///cell.lblOfferPrice.text = "\(product.specialPrice ?? 0) AED"
                    cell.lblActualPrice.isHidden = false
                    cell.lblOfferPrice.isHidden = false
                }
                else
                {
                    cell.lblOfferPrice.isHidden = true
                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(actualPrice + " AED")")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))

                    cell.lblActualPrice.attributedText = attributeString
                    cell.lblActualPrice.isHidden = false
                }
                
            }
            else
            {
                cell.lblOfferPrice.isHidden = true
                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(actualPrice + " AED")")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))

                cell.lblActualPrice.attributedText = attributeString
                cell.lblActualPrice.isHidden = false
            }
            
            
            let imageMain = cellDatas.imageUrl!.replacingOccurrences(of: "/needtochange", with: "", options: NSString.CompareOptions.literal, range:nil)
            print("SANTHOSH IMAGE URL : ")
            print(imageMain)
            cell.imageArrayRec = imageMain
            cell.file = imageMain//cellData.image
            //cell.imageArray = cellDatas.media_gallery_entries!
            //cell.imageArray = cellDatas.image
            cell.setImages(sliderImages: [])
//            DispatchQueue.main.async {
//                let flowLayout = UICollectionViewFlowLayout()
//                flowLayout.scrollDirection = .horizontal
//                flowLayout.itemSize = CGSize(width: 128, height: 128)
//                cell.collectionImages.collectionViewLayout = flowLayout
//                cell.collectionImages.reloadData()
//            }
            cell.tag = indexPath.row
            cell.productDelegate = self
        }
        

        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}
extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                subSubView.backgroundColor = color
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
    
}
