//
//  MyWishlistVC.swift
//  Marina Home
//
//  Created by Codilar on 20/04/23.
//
////MARK START{MHIOS-1029}
//Created a model class WishlistIDsModel
////MARK END{MHIOS-1029}
/////MARK START{MHIOS-1291}
/// wishlist item title and descreption and peice text coler and font changed
/// added login now button in UI side
/////MARK END{MHIOS-1291}

import UIKit
import PageControls
import SDWebImage
import UBottomSheet

class MyWishlistVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var btnContinue: AppBorderButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var noDataInfo: UIView!

    @IBOutlet var lblHmm: UILabel!
    var wishlistArray:[WishlistModel] = []
    
    @IBOutlet weak var shareBtnView: UIButton!
    
    @IBOutlet weak var loginNowBtnVIEW: UIView!
    @IBOutlet weak var loginNowBtnHeight: NSLayoutConstraint!
    
    var wishlistItemStatus = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("My Wishlist Screen")
        //MARK: END MHIOS-1225
        backActionLink(backButton)
        //MARK START{MHIOS-1029}
        loginNowBtnVIEW.isHidden = true
        loginNowBtnHeight.constant = 0 //53
        //MARK END{MHIOS-1029}
        self.noDataInfo.isHidden = true
        listingTable.delegate = self
        listingTable.dataSource = self
        listingTable.register(UINib(nibName: "MyWishlistTVC", bundle: nil), forCellReuseIdentifier: "MyWishlistTVC_id")
        self.btnContinue.setTitle("ADD FAVOURITES", for: .normal)
        let boldAttributes: [NSAttributedString.Key: Any] = [
           .font: AppFonts.LatoFont.Bold(13),
           .foregroundColor: AppColors.shared.Color_black_000000
        ]
        let regularAttributes: [NSAttributedString.Key: Any] = [
           .font: AppFonts.LatoFont.Regular(13),
           .foregroundColor: AppColors.shared.Color_black_000000
        ]
        var attributeString = NSMutableAttributedString(
           string: "Hmm, ",
           attributes: boldAttributes)
        var attributeString1 = NSMutableAttributedString(
           string: "You don’t have any Favourite picks yet!",
           attributes: regularAttributes)
         attributeString.append(attributeString1)
        lblHmm.attributedText = attributeString
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //MARK START{MHIOS-1029}
        loginNowBtnVIEW.isHidden = true
        loginNowBtnHeight.constant = 0 //53
        //MARK END{MHIOS-1029}
        getWishlist()
    }
    
    //MARK START{MHIOS-1029}
    @IBAction func loginNowBtnAction(_ sender: UIButton) {
        let nextVC = AppController.shared.loginRegister
        nextVC.hidesBottomBarWhenPushed = true
        //.isFromCart = true
        //nextVC.myTotal = self.myTotal
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    //MARK END{MHIOS-1029}
    
    
    
    @IBAction func CintnueShoping(_ sender: Any) {
        
        if self.wishlistItemStatus
        {
            ///Show Warrning PopUp Message
            self.showAlert(message: "Do you want to move this all product to cart?", hasleftAction: true,rightactionTitle: "Yes", rightAction: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                print("SANTHOSH wishList ITEMS BEFORE IS S : \(appDelegate.wishList)")
                DispatchQueue.main.async {
                    //MARK START{MHIOS-1029}
                    if UserData.shared.isLoggedIn
                    {
                        self.apiMoveProductFromWishlistToCart(){ response in
                            DispatchQueue.main.async {
                                if response
                                {
                                    appDelegate.wishList.removeAll()
                                    print("SANTHOSH wishList ITEMS IS S : \(appDelegate.wishList)")
                                    self.getCartCount()
                                    self.getWishlist()
                                    self.toastView(toastMessage: "Successfully Moved",type: "success")
                                }
                                else
                                {
                                    //MARK: START MHIOS-1285
                                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Couldn't able to send reset link to your email!. please try again","Screen" : self.className])
                                    //MARK: END MHIOS-1285
                                    self.toastView(toastMessage: "Couldn't able to send reset link to your email!. please try again",type: "error")
                                }
                            }

                        }
                    }
                    else
                    {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if(appDelegate.guestCartId != "")
                        {
                            self.guestMoveAllProductToCart()
                        }
                        else
                        {
                            self.craeteGuestUser(returnFunc: {
                                self.guestMoveAllProductToCart()
                                print("SANTHOSH ACTION TEST")
                            })
                        }
                        
                    }
                    //MARK END{MHIOS-1029}
                }
            }, leftAction: {})
        }
        else
        {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    //MARK START{MHIOS-1029}
    func guestMoveAllProductToCart()
    {
        
        self.apiCreateGuestCart()
        { response in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.guestCartId = response
            DispatchQueue.main.async {
                self.apiGuestCarts{ response in
                    DispatchQueue.main.async {
                        print(response)
                        self.apiGuestMoveProductFromWishlistToCart(quote_id: "\(response.id)"){ response in
                            DispatchQueue.main.async {
                                if response
                                {
                                    UserData.shared.wishListIdArray.removeAll()
                                    //print("SANTHOSH wishList ITEMS IS S : \(appDelegate.wishList)")
                                    self.getCartCount()
                                    self.getWishlist()
                                    self.toastView(toastMessage: "Successfully Moved",type: "success")
                                }
                                else
                                {
                                    self.toastView(toastMessage: "Couldn't able to send reset link to your email!. please try again",type: "error")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //MARK END{MHIOS-1029}
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Share Wishlist")
        //MARK: END MHIOS-1225
        let controller = AppController.shared.shareWishlist
        addChild(controller)
        self.view.addSubview(controller.view)
        controller.view.frame = self.view.frame
        controller.didMove(toParent: self)
        
        
//        self.apiShareWishlist(email: "thalilsanthosh@gmail.com", message: "Test Santhosh"){ response in
//            DispatchQueue.main.async {
//                print(response)
//                if response{
//                    self.toastView(toastMessage: "Successfully Shared")
//                }
//            }
//        }
    }
    
    @objc func moveToCartAction(_ sender: UIButton) {
      
        self.showAlert(message: "Do you want to move this product to cart?", hasleftAction: true,rightactionTitle: "Yes", rightAction: {
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                print("SANTHOSH wishList ITEMS BEFORE IS : \(appDelegate.wishList)")
                //MARK START{MHIOS-1029}
                if UserData.shared.isLoggedIn
                {
                    self.apiMoveWishToCart(id: self.wishlistArray[sender.tag].productId ?? "", qty: "1"){ response in //self.wishlistArray[sender.tag].qty ?? ""
                        DispatchQueue.main.async {
                            print(response)
                            if response{
                                
                                appDelegate.wishList.removeAll() ///= appDelegate.wishList.filter{$0 != self.wishlistArray[sender.tag].productId}
                                print("SANTHOSH wishList ITEMS IS : \(appDelegate.wishList)")
                                //MARK START{MHIOS-MHIOS-1266}
                                self.toastView(toastMessage: "Product added to cart  successfully",type: "success")
                                //MARK END{MHIOS-MHIOS-1266}
                                self.getCartCount()
                                self.getWishlist()
                            }
                        }
                    }
                }
                else
                {
                    self.guestMoveToCart(indexIs: sender.tag)
                }
                //MARK END{MHIOS-1029}
            }
        }, leftAction: {})
    }

    @objc func removeAction(_ sender: UIButton) {
        self.showAlert(message: "Do you want to remove this product from wishlist?", hasleftAction: true,rightactionTitle: "Yes", rightAction: {
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                print("SANTHOSH wishList ITEMS BEFORE IS NEW : \(appDelegate.wishList)")
                //MARK START{MHIOS-1029}
                if UserData.shared.isLoggedIn
                {
                    self.apiRemoveProduct(id: self.wishlistArray[sender.tag].productId ?? ""){ response in
                        DispatchQueue.main.async {
                            print(response)
                            if response{
                                //MARK START{MHIOS-1181}
                                UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(self.wishlistArray[sender.tag].productId ?? "") ?? 0 }
                                //MARK END{MHIOS-1181}
                                appDelegate.wishList = appDelegate.wishList.filter{$0 != self.wishlistArray[sender.tag].productId }
                                //MARK START{MHIOS-MHIOS-1266}
                                self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
                                //MARK END{MHIOS-MHIOS-1266}
                                self.getWishlist()
                            }
                        }
                    }
                }
                else
                {
                    UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(self.wishlistArray[sender.tag].productId ?? "") ?? 0 }
                    self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
                    self.getWishlist()
                }
                //MARK END{MHIOS-1029}
            }
        }, leftAction: {})
    }

    //MARK START{MHIOS-1029}
    func guestMoveToCart(indexIs:Int)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.guestCartId != "")
        {
            guestAddToCart(indexIs: indexIs)
        }
        else
        {
            craeteGuestUser(returnFunc: {
                self.guestMoveToCart(indexIs: indexIs)
                print("SANTHOSH ACTION TEST")
            })
        }
    }

    func getWishlist(){
        if UserData.shared.isLoggedIn{
            //MARK START{MHIOS-1029}
            self.loginNowBtnVIEW.isHidden = true
            self.loginNowBtnHeight.constant = 0 //53
            //MARK END{MHIOS-1029}
            self.apiWishlist(){ response in
                DispatchQueue.main.async {
                    print(response)
                    
                    self.wishlistArray = response
                    if(self.wishlistArray.count>0)
                    {
                        self.wishlistItemStatus = true
                        self.shareBtnView.isHidden = false
                        self.btnContinue.backgroundColor = UIColor.black
                        self.btnContinue.setTitleColor(.white, for: .normal)
                        self.btnContinue.setTitle("ADD ALL ITEMS TO CART", for: .normal)
                    }
                    else
                    {
                        self.wishlistItemStatus = false
                        self.btnContinue.backgroundColor = UIColor.white
                        self.btnContinue.setTitleColor(.black, for: .normal)
                        self.btnContinue.setTitle("ADD FAVOURITES", for: .normal)
                        self.shareBtnView.isHidden = true
                    }
                    self.listingTable.reloadData()
                    self.noDataInfo.isHidden = self.wishlistArray.count != 0
                }
            }
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if(appDelegate.guestCartId != "")
            {
                UserData.shared.guestCartId = appDelegate.guestCartId
                self.apiGuestWishlist(){ response in
                    DispatchQueue.main.async {
                        print(response)
                       
                        self.wishlistArray = response
                        if(self.wishlistArray.count>0)
                        {
                            //MARK START{MHIOS-1029}
                            self.loginNowBtnVIEW.isHidden = false
                            self.loginNowBtnHeight.constant = 53
                            //MARK END{MHIOS-1029}
                            self.wishlistItemStatus = true
                            self.shareBtnView.isHidden = false
                            self.btnContinue.backgroundColor = UIColor.black
                            self.btnContinue.setTitleColor(.white, for: .normal)
                            self.btnContinue.setTitle("ADD ALL ITEMS TO CART", for: .normal)
                        }
                        else
                        {
                            //MARK START{MHIOS-1029}
                            self.loginNowBtnVIEW.isHidden = true
                            self.loginNowBtnHeight.constant = 0 //53
                            //MARK END{MHIOS-1029}
                            self.wishlistItemStatus = false
                            self.btnContinue.backgroundColor = UIColor.white
                            self.btnContinue.setTitleColor(.black, for: .normal)
                            self.btnContinue.setTitle("ADD FAVOURITES", for: .normal)
                            self.shareBtnView.isHidden = true
                        }
                        self.listingTable.reloadData()
                        self.noDataInfo.isHidden = self.wishlistArray.count != 0
                    }
                }
            }
            else
            {
                craeteGuestUser(returnFunc: {
                    self.getWishlist()
                    print("SANTHOSH ACTION TEST")
                })
            }
        }
    }
    
    func craeteGuestUser(returnFunc: @escaping ()->())
    {
        self.apiCreateGuestCart(){ response in
            DispatchQueue.main.async {
                print("SANTHOSH CART apiCreateGuestCart : OK")
                print(response)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.guestCartId = response
                UserData.shared.guestCartId = response
                let userDefaults = UserDefaults.standard
                userDefaults.set(response, forKey: "GuestCart")
                ///self.getWishlist()
                return returnFunc()
            }
        }
    }
    
    func guestAddToCart(indexIs:Int)
    {
        self.apiCreateGuestCart()
        { response in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.guestCartId = response
            DispatchQueue.main.async {
                self.apiGuestCarts{ response in
                    DispatchQueue.main.async {
                        print(response)
                        self.apiAddToGuestCart(parameters: ["cartItem":["sku": self.wishlistArray[indexIs].productSku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
                            DispatchQueue.main.async { [self] in
                                print(responseData)
                                if(responseData.itemID == nil)
                                {
                                    self.toastView(toastMessage:"Product that you are trying to add is not available.", type: "error")
                                }
                                else
                                {
                                    UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(self.wishlistArray[indexIs].productId ?? "") ?? 0 }
                                    //MARK START{MHIOS-MHIOS-1266}
                                    self.toastView(toastMessage: "Product added to cart  successfully",type: "success")
                                    //MARK END{MHIOS-MHIOS-1266}
                                    self.getCartCount()
                                    self.getWishlist()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
   
    
    func getCartCount()
    {
        if UserData.shared.isLoggedIn{
            self.apiCreateCart(){ response in
                DispatchQueue.main.async {
                    print("SANTHOSH response AAAA")
                    print(response)
                    self.apiCarts(){ response in
                        DispatchQueue.main.async {
                            print(response)
                            let mycart = response as Cart
                            let cartCountIs = mycart.itemsQty!
                            UserData.shared.cartCount = cartCountIs
                            if cartCountIs == 0
                            {
                                self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                            }
                            else
                            {
                                self.tabBarController?.tabBar.items?.last?.badgeValue = "\(cartCountIs)"
                            }
                        }
                    }
                }
            }
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.apiGuestCarts(){ response in
                appDelegate.storeID = response.storeID ?? 0
                DispatchQueue.main.async {
                    print("SANTHOSH apiGuestCarts : OK")
                    print(response)
                    let mycart = response as Cart
                    let cartCountIs = mycart.itemsCount!
                    UserData.shared.cartCount = cartCountIs
                    if cartCountIs == 0
                    {
                        self.tabBarController!.tabBar.items?.last?.badgeValue = nil
                    }
                    else
                    {
                        self.tabBarController!.tabBar.items?.last?.badgeValue = "\(cartCountIs)"
                    }
                }
            }
       }
    }
    //MARK END{MHIOS-1029}

    // MARK: - TABLEVIEW
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//       return 208
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return UITableView.automaticDimension
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return wishlistArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cellData = wishlistArray[indexPath.item]
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyWishlistTVC_id", for: indexPath) as? MyWishlistTVC else { return UITableViewCell() }
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
        let animatedGif = UIImage.sd_image(withGIFData: imageData)
        //cell.productImageView.image = animatedGif
        //cell.productImageView.sd_setImage(with: URL(string: "\(AppInfo.shared.productImageURL)\(cellData.image ?? "")"),placeholderImage: animatedGif)
        let placeholderImage = UIImage(named: "failure_image.png")
        cell.productImageView.image = placeholderImage
        let imageMain = "\(AppInfo.shared.productImageURL)\(cellData.image ?? "")"
        if(imageMain != "")
        {
            let url = URL(string: imageMain)
            if let imageUr = url
            {
                // Load the image with Kingfisher and handle the result
                cell.productImageView.kf.setImage(with: url, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        // The image loaded successfully, and `value.image` contains the loaded image.
                        cell.productImageView.image = value.image
                    case .failure(let error):
                        // An error occurred while loading the image.
                        // You can handle the failure here, for example, by displaying a default image.
                        cell.productImageView.image = placeholderImage
                        print("Image loading failed with error: \(error)")
                    }
                }
            }
        }
        cell.prodTitleLbl.text = cellData.productName
        cell.prodSpecLbl.text = cellData.description
        
        //cell.ProdPriceLbl.text = formatNumberToThousandsDecimal(number: cellData.price ?? 0 ) + " AED" //"\(Float(cellData.price ?? 0)) AED"
        
       
        let saleprice : String = String(format: "%.1f", cellData.salePrice!)
        let Price : String = String(format: "%.1f", cellData.price!)
        var salePrice = 0.0
        if let floatNumber = Float(saleprice ?? "0.00") {
            salePrice = Double(floatNumber)
            
        }
        
        let price = Double(Price ?? "0") ?? 0
        let actualPrice = formatNumberToThousandsDecimal(number: price)
        
        cell.lblOfferPrice.text = actualPrice + " AED"
        cell.lblActualPrice.isHidden = true
        
        if saleprice != "0.0"
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
        //Mark MHIOS-1161
        
        
        
        
        
        
        cell.moveToCartButton.tag = indexPath.item
        cell.moveToCartButton.addTarget(self, action: #selector(self.moveToCartAction(_:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.item
        cell.removeButton.addTarget(self, action: #selector(self.removeAction(_:)), for: .touchUpInside)
       return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cellData = wishlistArray[indexPath.item]
            
           let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = cellData.productSku ?? ""
         self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
