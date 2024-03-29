//
//  MenuVC.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//
////MARK START{MHIOS-1205}
///added 2 Constraint in the UI side
////MARK END{MHIOS-1205}

import UIKit
import Kingfisher
//MARK START{MHIOS-1248}
import MediaSlideshow
//MARK END{MHIOS-1248}

class MenuVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductCardDelegate,UIGestureRecognizerDelegate, MenuSubCategoriesDelegate{
    
    
    func redirectToLoginPage() {
        
    }
    func openDetail(tag:Int,sectionSelected:Int)
    {
        
        let nextVC = AppController.shared.productDetailsImages
        nextVC.productId = "\(self.newArrivalsProductsArray[tag].sku ?? "")"
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
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var newArrivalsProductsCV: UICollectionView!
    // MARK START MHIOS_1058
    @IBOutlet weak var recentlyProductsCV: UICollectionView!
    // MARK END MHIOS_1058
    //MARK START{MHIOS-554}
    var categoriesArray:[MenuModel] = []
    var expand:[Bool] = []
    var childExpand:[ChildExpandModel] = []
    func expandChildCategories(tag: Int, section: Int) {
//        for index in 0..<childExpand[section].selection.count {
//            childExpand[section].selection[index] = false
//        }
        childExpand[section].selection[tag] = !childExpand[section].selection[tag]
        self.listingTable.reloadData()
    }
    func openPLPPage(category_id: String, roomtite: String) {
        var vc = AppController.shared.menuPLP
        vc.category_id =  category_id
        vc.roomtite = roomtite
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK END{MHIOS-554}
    // MARK START MHIOS_1058
    @IBOutlet weak var searchBar: UISearchBar!
    // MARK END MHIOS_1058
    //MARK START{MHIOS-1205}
    @IBOutlet weak var newArrivalsMainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var newArrivalsGridViewHeight: NSLayoutConstraint!
    //MARK END{MHIOS-1205}
    var newArrivalsProductsArray:[RecordsYML] = []
    var selectedCategoryName = ""
    var youMightLikeProductsArray:[RecordsYML] = []
    var imageReloadStatus = true
    init() {
       
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.setTextFieldColor(.white)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.searchBar.searchTextField.backgroundColor = .white
        self.searchBar.searchTextField.layer.borderWidth = 0.6
        self.searchBar.searchTextField.layer.cornerRadius = 4
        self.searchBar.searchTextField.layer.masksToBounds = true
        self.searchBar.searchTextField.layer.borderColor = UIColor.black.cgColor
        self.searchBar.searchTextField.font = UIFont(name: AppFontLato.light, size: 13)
        self.searchBar.searchTextField.leftView?.tintColor = .black
        self.searchBar.setImage(UIImage(named: "Group 1194"), for: .search, state: .normal)
        self.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 10, vertical: 0)
                listingTable.delegate = self
        listingTable.dataSource = self
        listingTable.register(UINib(nibName: "MenuCategoriesTVC", bundle: nil), forCellReuseIdentifier: "MenuCategoriesTVC_id")
        listingTable.register(UINib(nibName: "MenuSubCategoriesTVC", bundle: nil), forCellReuseIdentifier: "MenuSubCategoriesTVC_id")
        newArrivalsProductsCV.delegate = self
        newArrivalsProductsCV.dataSource = self
        ProductCVC.register(for: newArrivalsProductsCV)
        //MARK START{MHIOS-1205}
        var width = UIScreen.main.bounds.width/2
        width = width - 9
        width = width+72
        newArrivalsGridViewHeight.constant = width
        newArrivalsMainViewHeight.constant = width+80
        //MARK END{MHIOS-1205}
        self.apiGetQueryNewArrivals() { response in
            let jsonString = response.search?.payload
            let data: Data? = jsonString?.data(using: .utf8)
            let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]
             print(json ?? "Empty Data")
            self.apiNewArrival(recordQueries: json!){ response in
                DispatchQueue.main.async {
                    print(response)
                    if response.queryResultsYML?.count ?? 0 > 0{
                        self.newArrivalsProductsArray = response.queryResultsYML?[0].recordsYML as! [RecordsYML]
                        self.newArrivalsProductsCV.reloadData()
                    }
                    else
                    {
                        print("WORKING Not FINE")
                    }
                }
                self.newArrivalsProductsCV.reloadData()
                
            }
        }
        self.apiCategories(){ response in
            DispatchQueue.main.async {
                print(response)
                //MARK START{MHIOS-554}
                //MARK START{MHIOS-1260}
                self.categoriesArray.removeAll()
                self.expand.removeAll()
                self.childExpand.removeAll()
                //MARK END{MHIOS-1260}
                self.categoriesArray = response.childrenData
                self.expand = Array(repeating: false, count: self.categoriesArray.count)
                
                for index in 0..<self.categoriesArray.count {
                    var temp:[Bool] = []
                    temp = Array(repeating: false, count: self.categoriesArray.count)
                    var tempChildData:[MenuModel] = []
                    for i in 0..<self.categoriesArray[index].childrenData.count {
                        tempChildData = self.categoriesArray[index].childrenData[i].childrenData
                    }
                    let childData = tempChildData
                    
                    self.childExpand.append(ChildExpandModel(selection: temp, childData: childData))
                }
                let tempChildExpand = self.childExpand
                print("SANTHOSH MENU childExpand : \(self.childExpand)")
                self.listingTable.reloadData()
                //MARK END{MHIOS-554}
            }
        }
       
        self.apiRecentProduct(id: "recsRecentlyViewed", url:AppInfo.shared.searchUrl, token:AppInfo.shared.klevuKey)
        { responseData in
            DispatchQueue.main.async {
                print(responseData)
                if responseData.queryResultsYML?.count ?? 0 > 0{
                    self.youMightLikeProductsArray = responseData.queryResultsYML?[0].recordsYML as! [RecordsYML]
                    self.recentlyProductsCV.reloadData()
                }
                else
                {
                    print("WORKING Not FINE")
                }
            }
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Menu Screen")
        //MARK: END MHIOS-1225
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.hideActivityIndicator(uiView: self.view)
    }
    @IBAction func ReTry(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ViewAll(_ sender: Any) {
        
        var vc = AppController.shared.menuPLP
        vc.category_id =  "362"
        vc.roomtite = "NEW ARRIVALS"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.item == 0
            {
                if expand[indexPath.section]
                {
                    return 138
                }
                else
                {
                    return 98
                }
                
            }
            else
            {
        //MARK START{MHIOS-554}
                if childExpand[indexPath.section].selection[indexPath.item]==true
                {
                    //return CGFloat(47+(childExpand[indexPath.section].childData.count*46))
                    return CGFloat(47+(categoriesArray[indexPath.section].childrenData [indexPath.item - 1].childrenData.count*46))
                }
                else
                {
                    return 46
                }
     //MARK END{MHIOS-554}
            }
        }

    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expand[section] {
            return categoriesArray[section].childrenData.count + 1
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cellData = categoriesArray[indexPath.section]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCategoriesTVC_id", for: indexPath) as? MenuCategoriesTVC else { return UITableViewCell() }
            cell.categoryLbl.text = cellData.name.uppercased()
            cell.indexValue = indexPath.section
            cell.categoryLbl.textColor = expand[indexPath.section] ? AppColors.shared.Color_yellow_AB936B : AppColors.shared.Color_black_000000
            print("-->\(cellData.image)")
            let view = UIView()
            
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
            let animatedGif = UIImage.sd_image(withGIFData: imageData)
            let placeholderImage = UIImage(named: "menu_failure_image.png")
            let options: KingfisherOptionsInfo = [ // Set a fade-in transition with a duration
                .onFailureImage(placeholderImage) // Set a custom target cache
            ]
            
            if(cellData.image != "" || cellData.image != nil )
            {
                let urlString =  "\(cellData.image ?? "")" ///cellData.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
               
                let url = URL(string: urlString)//?q=100
                print("SANTHOSH MENU URL IS : \(url)")
                if let imageUr = url
                {
                    cell.itemImage.kf.setImage(with: url, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            // The image loaded successfully, and `value.image` contains the loaded image.
                            cell.itemImage.image = value.image
                        case .failure(let error):
                            // An error occurred while loading the image.
                            // You can handle the failure here, for example, by displaying a default image.
                            cell.itemImage.image = placeholderImage
                            print("Image loading failed with error: \(error)")
                        }
                    }
                }
                
            }
            
            cell.arrowImage.image = expand[indexPath.section] ? UIImage(named: "up_arrow")?.withTintColor(AppColors.shared.Color_yellow_AB936B) : UIImage(named: "down_arrow")
            if categoriesArray[indexPath.section].childrenData.isEmpty
            {
                cell.arrowImage.isHidden = true
            }
            else
            {
                cell.arrowImage.isHidden = false
            }
            
            if (expand[indexPath.section])
            {
                cell.divaiderView.backgroundColor = #colorLiteral(red: 0.1137254902, green: 0.1137254902, blue: 0.1058823529, alpha: 1)
                //cell.divaiderView.isHidden = false
                cell.subLbl.text = "ALL " +  categoriesArray[indexPath.section].name.uppercased()//selectedCategoryName
                cell.subViewHeight.constant = 40
                cell.selectSubView = { [self] (index) in
                    
                    let cellData = categoriesArray[index]
                    var vc = AppController.shared.menuPLP
                    vc.category_id =  "\(cellData.id)"
                    vc.roomtite = cellData.name.uppercased()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else
            {
                cell.divaiderView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                //cell.divaiderView.isHidden = false
                cell.subLbl.text = ""
                cell.subViewHeight.constant = 0
            }
            return cell
        }else{
            let cellData = categoriesArray[indexPath.section].childrenData [indexPath.item - 1]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSubCategoriesTVC_id", for: indexPath) as? MenuSubCategoriesTVC else { return UITableViewCell() }
            cell.subCategoryLbl.text = cellData.name.uppercased()
            //MARK START{MHIOS-554}
            cell.sectionValue = indexPath.section
            cell.indexValue = indexPath.item
            cell.menuSubCategoriesDelegate = self
            //MARK START{MHIOS-1319}
            cell.setData(data: childExpand[indexPath.section], data2: cellData, lastItem:categoriesArray[indexPath.section].childrenData.count)
            //MARK END{MHIOS-1319}
            //MARK END{MHIOS-554}
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            //cell.sepView.isHidden = (indexPath.item - 1) != 0
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) ->CGFloat {
                if indexPath.item == 0
                {
                    if expand[indexPath.section]
                    {
                        return 138
                    }
                    else
                    {
                        return 98
                    }
                    
                }
                else
                {
                    return 46
                    
                }
            }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.item == 0{
         
            let cellData = categoriesArray[indexPath.section]
            selectedCategoryName = cellData.name
            if expand[indexPath.section]{
                expand[indexPath.section] = false
                let sections = IndexSet.init(integer: indexPath.section)
                UIView.performWithoutAnimation {
                    let loc = tableView.contentOffset
                    listingTable.reloadSections(sections, with: .none)
                    tableView.contentOffset = loc
                }
              
                
            }else{
                
                if categoriesArray[indexPath.section].childrenData.isEmpty
                {
                    let cellData = categoriesArray[indexPath.section]
                    var vc = AppController.shared.menuPLP
                    vc.category_id =  "\(cellData.id)"
                    vc.roomtite = cellData.name.uppercased()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                   
                        
                  
                    
                    expand[indexPath.section] = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    UIView.performWithoutAnimation {
                        let loc = tableView.contentOffset
                        listingTable.reloadSections(sections, with: .none)
                        tableView.contentOffset = loc
                    }
                    
                }
               
            }
        }
        else
        {
            let cellData = categoriesArray[indexPath.section].childrenData[indexPath.item - 1]
            var vc = AppController.shared.menuPLP
            vc.category_id =  "\(cellData.id)"
            vc.roomtite = cellData.name.uppercased()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var width = UIScreen.main.bounds.width/2
        width = width - 9
        return CGSize(width: width, height: width+72)//newArrivalsProductsCV.frame.height
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
        if(collectionView==self.recentlyProductsCV)
        {
            return self.youMightLikeProductsArray.count
        }
        return newArrivalsProductsArray.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView==self.recentlyProductsCV)
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
            //cell.setNeedsDisplay()
            
            let cellData = youMightLikeProductsArray[indexPath.item]
            
            cell.lblName.font = AppFonts.LatoFont.Regular(13)
            cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
            cell.tag = indexPath.row
            cell.lblName.text = cellData.name
            let pId = (cellData.id! as String)
            //MARK START{MHIOS-1029}
            let sku = (cellData.sku! as String)
            cell.productId = Int(pId)!
            cell.sku = sku
            //MARK END{MHIOS-1029}
            cell.pageControl.isHidden = true
            
            let imageMain = cellData.imageUrl!.replacingOccurrences(of: "/needtochange", with: "", options: NSString.CompareOptions.literal, range:nil)
            print("SANTHOSH PRGE URL : \(imageMain)")
            print(imageMain)
            cell.imageArrayRec = imageMain
            cell.file = imageMain//cellData.image
            cell.setImages(sliderImages: [])
//            DispatchQueue.main.async {
//                  let flowLayout = UICollectionViewFlowLayout()
//                  flowLayout.scrollDirection = .horizontal
//                flowLayout.itemSize = CGSize(width: 128, height: 128)
//                  cell.collectionImages.collectionViewLayout = flowLayout
//                cell.collectionImages.reloadData()
//            }
            print("SANTHOSH PRICE dddddddd : ",cellData.salePrice!)
            var salePrice = 0.0
            if let floatNumber = Float(cellData.salePrice ?? "0.00") {
                salePrice = Double(floatNumber)
                
            }
            
            let price = Double(cellData.price ?? "0") ?? 0
            let actualPrice = formatNumberToThousandsDecimal(number: price)
            
            cell.lblOfferPrice.text = actualPrice + " AED"
            cell.lblActualPrice.isHidden = true
            
            if cellData.salePrice != ""
            {
                if salePrice < price
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
             
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             print("\(appDelegate.wishList)")
             let productInfo:String = "\(pId ?? "0" )"
            //MARK START{MHIOS-1029}
             let productSKU:String = "\(sku ?? "")"
             let modelToCheck = WishlistIDsModel(product_id: Int(productInfo) ?? 0, sku: productSKU)
             var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
             //var result = appDelegate.wishList.contains(pId)
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
             //cell.lblActualPrice.attributedText = attributeString
             cell.productDelegate = self
           
           return cell;
           
            
        }
        else
        {
            
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
             //cell.setNeedsDisplay()
             
            let cellData = newArrivalsProductsArray[indexPath.item]
             
             cell.lblName.font = AppFonts.LatoFont.Regular(13)
             cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
             cell.tag = indexPath.row
             cell.lblName.text = cellData.name
             let pId = (cellData.id! as String)
            //MARK START{MHIOS-1029}
             let sku = (cellData.sku! as String)
             cell.productId = Int(pId)!
             cell.sku = sku
            //MARK END{MHIOS-1029}
             cell.pageControl.isHidden = true
             
             let imageMain = cellData.imageUrl!.replacingOccurrences(of: "/needtochange", with: "", options: NSString.CompareOptions.literal, range:nil)
             print("SANTHOSH IMAGE URL : ")
             print(imageMain)
             cell.imageArrayRec = imageMain
             cell.file = imageMain//cellData.image
            //var sliderImages = [KingfisherSource]()
            //sliderImages.append(KingfisherSource(urlString: "\(imageMain ?? "")")!)
            cell.setImages(sliderImages: [])
//             DispatchQueue.main.async {
//                   let flowLayout = UICollectionViewFlowLayout()
//                   flowLayout.scrollDirection = .horizontal
//                 flowLayout.itemSize = CGSize(width: 128, height: 128)
//                   cell.collectionImages.collectionViewLayout = flowLayout
//                 cell.collectionImages.reloadData()
//             }
             print("SANTHOSH PRICE : ",cellData.salePrice!)
            var salePrice = 0.0
             if let floatNumber = Float(cellData.salePrice ?? "0.00") {
                 salePrice = Double(floatNumber)
                 
             }
             
             let price = Double(cellData.price ?? "0") ?? 0
            let actualPrice = formatNumberToThousandsDecimal(number: price)
             
             cell.lblOfferPrice.text = actualPrice + " AED"
             cell.lblActualPrice.isHidden = true
             
             if cellData.salePrice != ""
             {
                 if salePrice < price
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
              
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              print("\(appDelegate.wishList)")
              let productInfo:String = "\(pId ?? "0" )"
            //MARK START{MHIOS-1029}
             let productSKU:String = "\(sku ?? "")"
             let modelToCheck = WishlistIDsModel(product_id: Int(productInfo) ?? 0, sku: productSKU)
             var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
             //var result = appDelegate.wishList.contains(pId)
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
              //cell.lblActualPrice.attributedText = attributeString
              cell.productDelegate = self
            
            return cell;
           
            
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    // MARK: - Navigation
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(self.navigationController?.viewControllers.count==1)
        {
            return false
        }
        else
        {
            return true
        }
    }
}

extension MenuVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        var vc = AppController.shared.search
       
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
