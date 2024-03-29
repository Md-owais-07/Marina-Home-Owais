//
//  MyCartVC.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//
////MARK START{MHIOS-1033}
///Added Warning message popup in the UI section
///Added the Warning message view in UI cell Secction
/////MARK END{MHIOS-1033}
/// //MARK START{MHIOS-1210}
///updated Warning message popup in the UI section
/////MARK END{MHIOS-1210}
///
/// //MARK START{MHIOS-1221}
/// the popup outer area added click for popp close  in the UI section
/////MARK END{MHIOS-1221}
///
//////////MARK START{MHIOS-1249}
//changed the address list border style in UI side
////MARK END{MHIOS-1249}
///// //MARK START{MHIOS-1316}
/// updated the cat item list cell main view width
/////MARK END{MHIOS-1316}


import UIKit
import Tabby
import SwiftUI
import Firebase
import KlaviyoSwift
import Adjust
import FirebaseAnalytics

class MyCartVC: AppUIViewController,UITableViewDelegate,UITableViewDataSource,ProductCartDelegate,ProductCardSubDelegate,
                UIGestureRecognizerDelegate,CartShareScreenDelegate{
    
    @IBOutlet var bottomView: UIView!
    @IBOutlet var popContentView: UIView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var lblPostpaySplitUp: UILabel!
    @IBOutlet var lblGrandTotal: UILabel!
    @IBOutlet var tblCart: UITableView!
    @IBOutlet weak var shareBtnView: UIButton!
    @IBOutlet weak var proceedBtnView: AppPrimaryButton!
    @IBOutlet weak var backBtnView: UIButton!
    //MARK START{MHIOS-1033}
    @IBOutlet weak var wMsgPopupView: UIView!
    @IBOutlet weak var wMsgPopupTitle: UILabel!
    @IBOutlet weak var wMsgDescription: UILabel!
    @IBOutlet weak var  wMsgPopupHeight: NSLayoutConstraint!//72
    //MARK END{MHIOS-1033}
    //MARK START{MHIOS-1212}
    @IBOutlet weak var wMsgScrollView: UIScrollView!
    //MARK END{MHIOS-1212}

    let dispatchGroup = DispatchGroup()
    var myTotal:GrandTotal?
    var cupanExpand:Bool = false
    var installementExpand:Bool = false
    var guestCartId = ""
    var codeTxt:UITextField?
    var insatllmentBoxHeight = 170
    var insatllmentBoxHeightDrop = 50
    var totalGrandSegement = 0.00
    var youMightLikeProductsArray:[RecordsYML] = []
    var attrs : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.font : AppFonts.LatoFont.Bold(12),
        NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1),
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
    ]
    var cartItemsIds = ""
    var iscountPriceStatus = false
    var similarItemsStatus = true
    var activeInCartPage = true
    var cartShareScreen:CartShareScreen?
    var mycart:Cart?
    var youmightlikeModel:YouMightLikeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK START{MHIOS-1227}
        NotificationCenter.default.addObserver(self, selector: #selector(self.noInternetBackActivty(notification:)), name: Notification.Name("noInternetBackActivty"), object: nil)
        //MARK END{MHIOS-1227}
        //MARK START{MHIOS-1033}
        self.wMsgPopupView.isHidden = true
        //MARK END{MHIOS-1033}
        //MARK START{MHIOS-1212}
        self.wMsgScrollView.delegate = self
        //MARK END{MHIOS-1212}
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.guestCartId = appDelegate.guestCartId
        NotificationCenter.default.addObserver(self, selector: #selector(self.shareCartReloadData(notification:)), name: Notification.Name("ShareCartReloadData"), object: nil)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        ///backActionLink(self.backBtnView)
        tblCart.register(UINib(nibName: "InstallmentTVC", bundle: nil), forCellReuseIdentifier: "InstallmentTVC")
        tblCart.register(UINib(nibName: "CartCupenTVC", bundle: nil), forCellReuseIdentifier: "CartCupenTVC")
        tblCart.register(UINib(nibName: "SimilarItemsTVC", bundle: nil), forCellReuseIdentifier: "SimilarItemsTVC")
        tblCart.register(UINib(nibName: "FaqTVC", bundle: nil), forCellReuseIdentifier: "FaqTVC")
        tblCart.register(UINib(nibName: "OrderSummeryCell", bundle: nil), forCellReuseIdentifier: "OrderSummeryCell")
        self.tblCart.reloadData()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("My Cart Screen")
        //MARK: END MHIOS-1225
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("SANTHOSH CART PAGE COME BACK A")
        //MARK START{MHIOS-1227}
        wMsgPopupColse()
        //MARK END{MHIOS-1227}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SANTHOSH CART PAGE COME BACK B")
        self.hideActivityIndicator(uiView: self.view)
        self.similarItemsStatus = true
        //MARK START{MHIOS-1227}
        wMsgPopupColse()
        //MARK END{MHIOS-1227}
//        let indexPath = IndexPath(row: 0, section: 0)
//        tblCart.scrollToRow(at: indexPath, at: .top, animated: true)
        let count = UserData.shared.cartCount
        if count == 0
        {
            self.tabBarController?.tabBar.items?.last?.badgeValue = nil
        }
        else
        {
            self.tabBarController?.tabBar.items?.last?.badgeValue = "\(count)"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("SANTHOSH CART PAGE COME BACK C")
        //MARK START{MHIOS-1227}
        wMsgPopupColse()
        //MARK END{MHIOS-1227}
    }
    
    
    
    @objc func shareCartReloadData(notification: Notification) {
        //MARK: START MHIOS-1226
        if let topController = UIApplication.topViewController() {
            
            if topController is DeliveryTimeVC
            {
                topController.dismiss(animated: true)
            }
            
        }
        //MARK: END MHIOS-1226

        // Take Action on Notification
        if activeInCartPage
        {
            self.cartStatusCheck()
        }
        
    }
    //MARK START{MHIOS-1227}
    //MARK START{MHIOS-1033}
    @IBAction func wMsgColseAction(_ sender: UIButton) {
//        //MARK START{MHIOS-1212}
//        let topOffset = CGPoint(x: 0, y: -wMsgScrollView.contentInset.top)
//        wMsgScrollView.setContentOffset(topOffset, animated: true)
//        //MARK END{MHIOS-1212}
//        self.wMsgPopupView.isHidden = true
//        self.tabBarController?.hideTabBar(isHidden: true)
        wMsgPopupColse()
    }
    func wMsgPopupColse()
    {
        //MARK START{MHIOS-1212}
        let topOffset = CGPoint(x: 0, y: -wMsgScrollView.contentInset.top)
        wMsgScrollView.setContentOffset(topOffset, animated: true)
        //MARK END{MHIOS-1212}
        self.wMsgPopupView.isHidden = true
        self.tabBarController?.hideTabBar(isHidden: true)
    }
    
    func wMsgPopupShow()
    {
        self.wMsgPopupTitle.text = "NOTE"
        let cartItem:CartItem = self.mycart?.items?[popPosition] ?? [] as! CartItem
        let warningMsg = cartItem.extension_attributes?.wp_warning_message ?? ""
        self.wMsgDescription.text = "\(warningMsg)"
        do
        {
            if warningMsg != ""
            {
                let attributedString = try NSMutableAttributedString(htmlString: warningMsg)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byTruncatingTail
                paragraphStyle.lineSpacing = 3.5
                attributedString.addAttribute(.paragraphStyle,value: paragraphStyle,range: NSRange(location: 0, length: attributedString.length))
                self.wMsgDescription.attributedText = attributedString
            }
        }
        catch
        {
             print("Error")
        }
        
        let contentHeight = warningMsg.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).height
        let contentWidth = warningMsg.size(withAttributes:[.font: AppFonts.LatoFont.Regular(13)]).width
        let width = self.view.frame.size.width - 40
        let lblDescriptionHeight =  (contentWidth/width)*18
        print("SANTHOSH lblDescriptionHeight : \(lblDescriptionHeight)")
        if 280 < lblDescriptionHeight  //(contentWidth\width)// 17lines
        {
            wMsgPopupHeight.constant = 350
        }
        else
        {
            wMsgPopupHeight.constant = lblDescriptionHeight+100
        }
        self.wMsgPopupView.isHidden = false
        self.tabBarController?.hideTabBar(isHidden: false)
        
    }
    //MARK START{MHIOS-1227}
    //MARK START{MHIOS-1227}
    @objc func noInternetBackActivty(notification: Notification) {
        if wMsgPopupView.isHidden == false
        {
            wMsgPopupShow()
        }
    }
    var popPosition = 0
    //MARK END{MHIOS-1227}
   
    func closePopup() {
        cartShareScreen?.isHidden = true
    }
    
    func redirectToLoginPageSub() {
        self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
    }
    @objc func wMsgPopupShow(_ sender: UIButton) {
        
        popPosition = sender.tag
        wMsgPopupShow()
    }
    //MARK END{MHIOS-1033}
    //MARK END{MHIOS-1227}
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        if UserData.shared.goTocartStatus
        {
            if self.tabBarController?.selectedIndex == UserData.shared.previousTab
            {
                if UserData.shared.previousProductId != ""
                {
                    let nextVC = AppController.shared.productDetailsImages
                    nextVC.productId =  UserData.shared.previousProductId
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                else
                {
                    self.tabBarController?.selectedIndex = UserData.shared.previousTab
                    self.tabBarController?.hidesBottomBarWhenPushed = true
                }
            }
            else
            {
                self.tabBarController?.selectedIndex = UserData.shared.previousTab
                self.tabBarController?.hidesBottomBarWhenPushed = true
            }
            
            // Mark MHIOS-1072
//                if self.tabBarController?.selectedIndex == UserData.shared.previousTab
//                {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                else
//                {
            // Mark MHIOS-1072
           // self.tabBarController?.selectedIndex = 0
           // self.tabBarController?.hidesBottomBarWhenPushed = true
            // Mark MHIOS-1072
            //    }
            // Mark MHIOS-1072
        }
        else
        {
            self.tabBarController?.selectedIndex = 3
        }
    }
    
    //MARK: START MHIOS-1025
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        var shareURL = AppInfo.shared.baseURL
        
        
        dispatchGroup.enter()
        self.apiShareCartlistViaUrl(quoteId: self.mycart!.id){ response in
            DispatchQueue.main.async {
                if response.error == false {
                    // write to clipboard
                    shareURL = "\(response.message!)"
                    self.dispatchGroup.leave()
                }
                else
                {
                    AppUIViewController().toastView(toastMessage: "Try again",type: "error")
                }
            }
            
        }
        
        
        dispatchGroup.notify(queue: .main) {
            // Perform task 3
            UIPasteboard.general.string = shareURL
            DispatchQueue.main.async {
                let mysharecart = NSURL(string: shareURL)
                let shareAll = [mysharecart]
                let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
                activityViewController.isModalInPresentation = true
                activityViewController.popoverPresentationController?.sourceView = sender as UIView
                self.present(activityViewController, animated: true)
        }
        
       
        }
    
    }
    //MARK: END MHIOS-1025
    
    override func viewWillAppear(_ animated: Bool) {
        print("SANTHOSH CART PAGE COME BACK D")
        self.wMsgPopupView.isHidden = true
        self.similarItemsStatus = true
        self.tblCart.reloadData()
        // Mark MHIOS-1130
        let event1 = ADJEvent(eventToken: AdjustEventType.ViewCart.rawValue)
        Adjust.trackEvent(event1)
        // Mark MHIOS-1130
        
        if UserData.shared.goTocartStatus
        {
            backBtnView.isHidden = false
        }
        else
        {
            backBtnView.isHidden = true
        }
        
        let count = UserData.shared.cartCount
        if count == 0
        {
            self.tabBarController?.tabBar.items?.last?.badgeValue = nil
        }
        else
        {
            self.tabBarController?.tabBar.items?.last?.badgeValue = "\(count)"
        }
        self.tblCart.isHidden = false
        activeInCartPage = false
        cartStatusCheck()
        
        
    }
    
    func shareEmailAPICall(email: String, message: String, quoteId: Int) {
        
        self.apiShareCartlistEmail(email: email, message: message,quoteId: quoteId){ response in
            DispatchQueue.main.async {
                print(response)
                if response.error == false {
                    AppUIViewController().toastView(toastMessage: "Successfully Shared",type: "success")
                    self.cartShareScreen!.tabSelection(tabIndex: 0)
                }
                else
                {
                    //MARK: START MHIOS-1285
                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Try again","Screen" : self.className])
                    //MARK: END MHIOS-1285
                    AppUIViewController().toastView(toastMessage: "Try again",type: "error")
                }
            }
        }
    }
    
    func shareCopyLinkAPICall(quoteId: Int) {
        
        self.apiShareCartlistViaUrl(quoteId: quoteId){ response in
            DispatchQueue.main.async {
                print(response)
                if response.error == false {
                    // write to clipboard
                    UIPasteboard.general.string = "\(response.message!)"
                    AppUIViewController().toastView(toastMessage: "Link Copied",type: "success")
                    self.cartShareScreen!.tabSelection(tabIndex: 0)
                }
                else
                {
                    //MARK: START MHIOS-1285
                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Try again","Screen" : self.className])
                    //MARK: END MHIOS-1285
                    AppUIViewController().toastView(toastMessage: "Try again",type: "error")
                }
            }
        }
    }
    func shareWhatsAppAPICall(quoteId: Int) {
        
        self.apiShareCartlistViaWhatsApp(quoteId: quoteId){ response in
            DispatchQueue.main.async {
                print(response)
                if response.error == false {
                    // write to clipboard
                    UIPasteboard.general.string = "\(response.message!)"
                    let urlWhats = "whatsapp://send?text=\(response.message!)"
                    if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                          if let whatsappURL = NSURL(string: urlString) {
                                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                                     UIApplication.shared.open(whatsappURL as URL)
                                 }
                          }
                    }
                }
                else
                {
                    //MARK: START MHIOS-1285
                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Try again","Screen" : self.className])
                    //MARK: END MHIOS-1285
                    AppUIViewController().toastView(toastMessage: "Try again",type: "error")
                }
            }
        }
    }
    
    func cartStatusCheck()
    {
        self.similarItemsStatus = true
        self.shareBtnView.isHidden = true
        print("SANTHOSH response ZZZZZZZ")
        if UserData.shared.isLoggedIn{
            self.apiCreateCart(){ response in
                DispatchQueue.main.async {
                    print("SANTHOSH response AAAA")
                    print(response)
                    self.apiCarts(){ response in
                        DispatchQueue.main.async {
                            print("SANTHOSH response apiCarts")
                            print(response)
                            self.mycart = response as Cart
                            let cartCountIs = self.mycart?.itemsQty!
                            let cartQuoteId = self.mycart!.id as! Int
                            UserData.shared.cartQuoteId = cartQuoteId
                            print("SANTHOSN CART COUNT IS : ")
                            print(self.mycart?.extensionAttributes?.isPostpayAvailable!)
                            let isPostpayAvailableStatus = self.mycart?.extensionAttributes?.isPostpayAvailable!
                            let isTabbyAvailableStatus = self.mycart?.extensionAttributes?.isTabbyAvailable!
                            
                            if isPostpayAvailableStatus == "1" && isTabbyAvailableStatus == "1"
                            {
                                self.insatllmentBoxHeight = 170
                                self.insatllmentBoxHeightDrop = 50
                            }
                            else
                            {
                                if isPostpayAvailableStatus == "0" && isTabbyAvailableStatus == "0"
                                {
                                    self.insatllmentBoxHeight = 0
                                    self.insatllmentBoxHeightDrop = 0
                                }
                                else if  isPostpayAvailableStatus == "0"
                                {
                                    self.insatllmentBoxHeight = 85
                                    self.insatllmentBoxHeightDrop = 50
                                }
                                else
                                {
                                    self.insatllmentBoxHeight = 85
                                    self.insatllmentBoxHeightDrop = 50
                                }
                            }
                            print(cartCountIs)
                            UserData.shared.cartCount = cartCountIs!
                            let count = UserData.shared.cartCount
                            if count == 0
                            {
                                self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                            }
                            else
                            {
                                self.tabBarController?.tabBar.items?.last?.badgeValue = "\(count)"
                            }
                            if(self.mycart?.items?.count==0)
                            {
                                self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                                self.tblCart.isHidden = true
                                self.bottomView.isHidden = true
                                self.shareBtnView.isHidden = true
                                self.proceedBtnView.IBborderColor = UIColor.black
                                self.proceedBtnView.IBborderWidth = 1
                                self.proceedBtnView.backgroundColor = UIColor.white
                                self.proceedBtnView.setTitleColor(.black, for: .normal)
                                
                            }
                            else
                            {
                                self.tblCart.isHidden = false
                                self.bottomView.isHidden = false
                                self.shareBtnView.isHidden = false
                                self.proceedBtnView.IBborderColor = UIColor.black
                                self.proceedBtnView.IBborderWidth = 1
                                self.proceedBtnView.backgroundColor = UIColor.black
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.cachedCartItems = self.mycart?.items
                                self.proceedBtnView.setTitleColor(.white, for: .normal)
                                self.tblCart.reloadData()
                            }
                            self.tblCart.reloadData()
                            self.apiGrandTotal(){ response in
                                DispatchQueue.main.async { [self] in
                                    print("SANTHOSH response apiGrandTotal")
                                    print(response)
                                    self.myTotal = response as GrandTotal
                                    let totalSegments = self.myTotal?.totalSegments
                                    for var index in (0..<(self.myTotal?.totalSegments.count)!)
                                    {
                                        if totalSegments![index].code == "grand_total"
                                        {
                                            print("SANTHOSH subtotal is : \(totalSegments![index].value)")
                                            self.lblGrandTotal.text = "\(self.formatNumberToThousandsDecimal(number: totalSegments![index].value ?? 0.00)) AED"
                                        }
                                    }
                                    
                                    //self.showActivityIndicator(uiView: self.view)
                                    
                                    print("SANTHOSH grandTotal : ",self.myTotal?.grandTotal)
                                    ///self.lblGrandTotal.text = "\(self.formatNumberToThousandNew(number: Int(self.myTotal?.grandTotal ?? 0.00))) AED"
                                    
                                    ///self.tblCart.reloadData()
                                    //                                    self.cartItemsIds = ""
                                    //                                    for var index in (0..<(self.mycart?.items!.count)!)
                                    //                                    {
                                    //                                        let ids = self.mycart!.items![index].itemID!
                                    //                                        print(ids)
                                    //                                        if index == 0
                                    //                                        {
                                    //                                            self.cartItemsIds = "id:\(ids)"
                                    //                                        }
                                    //                                        else
                                    //                                        {
                                    //                                            self.cartItemsIds = "\(self.cartItemsIds),id:\(ids)"
                                    //                                        }
                                    //                                    }
                                    
                                    var cartItemsArray = [Any]()
                                    for var index in (0..<(self.mycart?.items!.count)!)
                                    {
                                        let ids = self.mycart!.items![index].extension_attributes?.custom_product_id ?? 0
                                        print(ids)
                                        let topId = ["id": ids]
                                        cartItemsArray.append(topId)
                                    }
                                    
                                    //self.tblCart.reloadData()
                                    print("SNTHAOSH IS LOOP CART ID IS : ")
                                    print(self.cartItemsIds)
                                    //self.youMightLikeProductsArray.removeAll()
                                    self.apiProductRecommended(id: cartItemsArray, url:AppInfo.shared.searchUrl, token:AppInfo.shared.klevuKey) //"klevu-162186563256313664"
                                    { responseData in
                                        DispatchQueue.main.async {
                                            print(responseData)
                                            self.similarItemsStatus = false
                                            if responseData.queryResultsYML?.count ?? 0 > 0{
                                                self.youMightLikeProductsArray = responseData.queryResultsYML?[0].recordsYML as! [RecordsYML]
                                                let indexPath = IndexPath(row: 1, section: 2)
                                               // self.tblCart.reloadRows(at: [indexPath], with: .fade)
                                                DispatchQueue.main.async {
                                                    self.tblCart.reloadData()
                                                }
                                            }
                                            else
                                            {
                                                self.tblCart.reloadData()
                                                print("WORKING Not FINE")
                                            }
                                        }
                                    }
                                    self.tblCart.reloadData()
                                }
                            }
                            //self.tblCart.reloadData()
                            print("SANTHOSH CART ID IS ")
                            print(self.mycart?.id)
                        }
                        
                    }
                }
                
            }
        }
        else
        {
            print("SANTHOSH response Guestflow")
            //Guestflow
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if(appDelegate.guestCartId == "")
            {
                print("SANTHOSH apiCreateGuestCart : Come")
                self.apiCreateGuestCart(){ response in
                    DispatchQueue.main.async {
                        print("SANTHOSH apiCreateGuestCart : OK")
                        print(response)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.guestCartId = response
                        self.guestCartId = response
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(response, forKey: "GuestCart")
                        print("SANTHOSH apiGuestCarts : Come")
                        self.cartStatusCheck()
                        
                    }
                }
                
            }
            else
            {
                print("SANTHOSH ELSE CASE")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                self.guestCartId =  appDelegate.guestCartId
                self.apiGuestCarts(){ response in
                    appDelegate.storeID = response.storeID ?? 0
                    DispatchQueue.main.async {
                        print(response)
                        self.mycart = response as Cart
                        let cartCountIs = self.mycart?.itemsQty!
                        UserData.shared.cartCount = cartCountIs!
                        let cartQuoteId = self.mycart!.id
                        UserData.shared.cartQuoteId = cartQuoteId
                        let count = UserData.shared.cartCount
                        if count == 0
                        {
                            self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                        }
                        else
                        {
                            self.tabBarController?.tabBar.items?.last?.badgeValue = "\(count)"
                        }
                        if(self.mycart?.items?.count==0||self.mycart?.items == nil)
                        {
                            self.tabBarController?.tabBar.items?.last?.badgeValue = nil
                            self.tblCart.isHidden = true
                            self.bottomView.isHidden = true
                            self.shareBtnView.isHidden = true
                            
                            self.proceedBtnView.IBborderColor = UIColor.black
                            self.proceedBtnView.IBborderWidth = 1
                            self.proceedBtnView.backgroundColor = UIColor.white
                            self.proceedBtnView.setTitleColor(.black, for: .normal)
                            
                            
                        }
                        else
                        {
                            self.tblCart.isHidden = false
                            self.bottomView.isHidden = false
                            //MARK START{MHIOS-1025} SANTHOSH
                            self.shareBtnView.isHidden = false
                            //MARK END{MHIOS-1025} SANTHOSH
                            appDelegate.cachedCartItems = self.mycart?.items
                            self.proceedBtnView.IBborderColor = UIColor.black
                            self.proceedBtnView.IBborderWidth = 1
                            self.proceedBtnView.backgroundColor = UIColor.black
                            self.proceedBtnView.setTitleColor(.white, for: .normal)
                            
                            self.tblCart.reloadData()
                        }
                        
                        print("SANTHOSH apiGuestGrandTotal OK ")
                        self.apiGuestGrandTotal(){ response in
                            DispatchQueue.main.async {
                                print(response)
                                // self.myTotal = response as GrandTotal
                                // self.lblGrandTotal.text = "\(self.myTotal?.grandTotal ?? 0.00) AED"
                                
                                print(response)
                                self.myTotal = response as GrandTotal
                                print("SANTHOSH grandTotal : ",self.myTotal?.grandTotal)
                                self.lblGrandTotal.text = "\(self.formatNumberToThousandsDecimal(number: self.myTotal?.baseGrandTotal ?? 0.00)) AED"
                                //self.tblCart.reloadData()
                                
                                ///self.showActivityIndicator(uiView: self.view)
                                self.cartItemsIds = ""
                                //var tempSkuArray = [3599,887]
                                var cartItemsArray = [Any]()
                            
                                
                                for var index in (0..<(self.mycart?.items!.count)!)
                                {
                                    let ids = self.mycart!.items![index].extension_attributes?.custom_product_id ?? 0
                                    print(ids)
                                    let topId = ["id": ids]
                                    cartItemsArray.append(topId)
                                }
                                ////self.youMightLikeProductsArray.removeAll()
                                self.apiProductRecommended(id: cartItemsArray, url:AppInfo.shared.searchUrl, token:AppInfo.shared.klevuKey)
                                { responseData in
                                    DispatchQueue.main.async {
                                        self.similarItemsStatus = false
                                        print(responseData)
                                        if responseData.queryResultsYML?.count ?? 0 > 0{
                                            self.youMightLikeProductsArray = responseData.queryResultsYML?[0].recordsYML as! [RecordsYML]
                                            let indexPath = IndexPath(row: 1, section: 2)
                                           // self.tblCart.reloadRows(at: [indexPath], with: .fade)
                                            DispatchQueue.main.async {
                                                self.tblCart.reloadData()
                                            }
                                        }
                                        else
                                        {
                                            self.tblCart.reloadData()
                                            print("WORKING Not FINE")
                                        }
                                    }
                                }
                                //self.tblCart.reloadData()
                            }
                            
                        }
                        
                        
                    }
                    
                }
            }
        }
        
        activeInCartPage = true
        
    }
    
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            //MARK START{MHIOS-1033}
            let cartItem:CartItem = self.mycart?.items?[indexPath.row] ?? [] as! CartItem
            let warningMsg = cartItem.extension_attributes?.cart_item_warning_message ?? ""
            if warningMsg != ""
            {
                return 268//289//220
            }
            else
            {
                return 220
            }
            //MARK END{MHIOS-1033}
        }
        else
        {
            switch indexPath.row {
                
                
            case 0:
                if(self.cupanExpand==true)
                {
                    return 140
                }
                else
                {
                    return 70
                }
            case 1:
                if(self.installementExpand==true)
                {
                    return CGFloat(340+self.insatllmentBoxHeight)//528
                }
                else
                {
                    return CGFloat(250+self.insatllmentBoxHeightDrop)                }
                //return 215
            case 2:
                if youMightLikeProductsArray.count==0
                {
                    return 0
                }
                else
                {
                    return 360
                }
                
                
            case 3:
                return 55
            case 4:
                return 55
                
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return self.mycart?.items?.count ?? 0
        }
        else
        {
            if( self.mycart?.items?.count ?? 0>0)
            {
                return 5
            }
            else
            {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0)
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTVC", for: indexPath) as? CartItemTVC else { return UITableViewCell() }
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
            let animatedGif = UIImage.sd_image(withGIFData: imageData)
            //cell.cartImg.image = animatedGif
            let cartItem:CartItem = self.mycart?.items?[indexPath.row] ?? [] as! CartItem
            //MARK START{MHIOS-1020 and MHIOS-1090}
            cell.leftQtyLbl.isHidden = true
            //MARK END{MHIOS-1020 and MHIOS-1090}
            cell.indexValue = indexPath.row
            cell.skuValue = cartItem.sku
            cell.lblName.text = cartItem.name
            //cell.lblPrice.text = formatNumberToThousandsDecimal(number: Int(cartItem.price ?? 0) ) + " AED" //String(format: "%.2f", cartItem.price!) + " AED"original_price    String
            let originalPrice = Double(cartItem.extension_attributes?.original_price ?? "0.00")
            let normalPrice = formatNumberToThousandsDecimal(number: cartItem.price ?? 0.0)
            let stringToStrike = "\(formatNumberToThousandsDecimal(number: originalPrice ?? 0 ) + " AED")"
            let mainString = "\(normalPrice + " AED  ") \(stringToStrike)"
            
            if ((originalPrice ?? 0) > (Double(normalPrice) ?? 0))
            {
                
                let range = (mainString as NSString).range(of: stringToStrike)
                let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
                mutableAttributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range)
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
                cell.lblPrice.textColor =  #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
                cell.lblPrice.attributedText =  mutableAttributedString
            } else {
                cell.lblPrice.text =  "\(normalPrice) AED"
                cell.lblPrice.textColor = UIColor.black
            }
            cell.lblType.text = cartItem.extension_attributes?.short_description
            //MARK START{MHIOS-1033}
            cell.warningMsgAction.tag = indexPath.row
            cell.warningMsgAction.addTarget(self, action: #selector(self.wMsgPopupShow(_:)), for: .touchUpInside)
            let warningMsg = cartItem.extension_attributes?.cart_item_warning_message ?? ""
            if warningMsg != ""
            {
                cell.warningMsgMainView.isHidden = false
                cell.warningMsgLable.text = cartItem.extension_attributes?.cart_item_warning_message
            }
            else
            {
                cell.warningMsgMainView.isHidden = true
            }
            //MARK END{MHIOS-1033}
            //MARK START{MHIOS-1020 and MHIOS-1090}
            let productQtyLeft = Int(cartItem.extension_attributes?.only_qty_left ?? "0") ?? 0
            
            if 1 ... 10 ~= productQtyLeft {
                cell.leftQtyLbl.isHidden = false
                cell.leftQtyLbl.text = "Only \(productQtyLeft) Left!"
                cell.leftQtyLbl.textColor = AppColors.shared.Color_red_FF0000
            } else {
                cell.leftQtyLbl.isHidden = true
            }
            //MARK END{MHIOS-1020 and MHIOS-1090}
            cell.lblQuantity.text = "Quantity: \(String(format: "%d", cartItem.qty!))"
            let availableQuantity = Int(cartItem.extension_attributes?.salable_qty ?? "0") ?? 0
            let currentQuantity = Int(cartItem.qty ?? 0)
            if(currentQuantity > availableQuantity && availableQuantity > 0)
            {
                if availableQuantity == 1{
                    cell.stockStatusView.text = "Only \(availableQuantity) item are available"
                }
                else
                {
                    cell.stockStatusView.text = "Only \(availableQuantity) items are available"
                }
                
                cell.stockStatusView.textColor = .red
                cell.downArrowView.isHidden = false
                cell.lblQuantity.isHidden = false
                cell.stockStatusView.isHidden = false
            } else if (availableQuantity > 0) {
                cell.lblQuantity.textColor = .black
                cell.downArrowView.isHidden = false
                cell.lblQuantity.isHidden = false
                cell.stockStatusView.isHidden = true
            } else {
                cell.stockStatusView.text = "Out of stock"
                cell.stockStatusView.textColor = .red
                cell.downArrowView.isHidden = true
                cell.lblQuantity.isHidden = true
                cell.stockStatusView.isHidden = false
            }
            
            cell.availableQuantity = availableQuantity
            cell.btnRemove.tag = indexPath.row
            cell.tag = indexPath.row
            cell.productDelegate = self
            cell.btnRemove.addTarget(self, action: #selector(self.RemoveItem(_:)), for: .touchUpInside)
            cell.btnMoveToWishlist.tag = indexPath.row
            cell.btnRemove.tag = indexPath.row
            cell.btnMoveToWishlist.addTarget(self, action: #selector(self.moveToWishlistItem(_:)), for: .touchUpInside)
            //cell.cartImg.sd_setImage(with: URL(string: "\(AppInfo.shared.productImageURL)\(cartItem.extension_attributes?.image ?? "")"),placeholderImage: animatedGif)
            
            let placeholderImage = UIImage(named: "failure_image.png")
            cell.cartImg.image = placeholderImage
            let urlString = "\(AppInfo.shared.productImageURL)\(cartItem.extension_attributes?.image ?? "")"
            let url = URL(string: urlString)//?q=100
            print("SANTHOSH MENU URL IS : \(url)")
            if let imageUr = url
            {
                // Load the image with Kingfisher and handle the result
                //let placeholderImage = UIImage(named: "failure_image.png")
                cell.cartImg.kf.setImage(with: url, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        // The image loaded successfully, and `value.image` contains the loaded image.
                        cell.cartImg.image = value.image
                    case .failure(let error):
                        // An error occurred while loading the image.
                        // You can handle the failure here, for example, by displaying a default image.
                        cell.cartImg.image = placeholderImage
                        print("Image loading failed with error: \(error)")
                    }
                }
            }
            
            return cell
        }
        else
        {
            switch indexPath.row {
                
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCupenTVC", for: indexPath) as? CartCupenTVC else { return UITableViewCell()}
                if(self.cupanExpand==true)
                {
                    cell.expandView.isHidden = false
                    cell.btnExpand.setImage(UIImage(named: "up_arrow.png"), for: .normal)
                }
                else
                {
                    cell.expandView.isHidden = true
                    cell.btnExpand.setImage(UIImage(named: "down_arrow.png"), for: .normal)
                }
                self.codeTxt = cell.txtCode
                ///cell.btnApply.addTarget(self, action: #selector(self.ApplyCode(_:)), for: .touchUpInside)
                print("SANTHOSH COUPEN CODE ID ")
                ////print(self.myTotal?.couponCode)
                if self.myTotal?.couponCode != nil
                {
                    cell.txtCode.text = self.myTotal?.couponCode
                    let attributedString = NSMutableAttributedString(string: "CANCEL COUPON", attributes: attrs)
                    cell.btnApply.setAttributedTitle(NSAttributedString(attributedString: attributedString), for: .normal)
                    cell.couponStatus = false
                }
                else
                {
                    cell.txtCode.text = ""
                    let attributedString = NSMutableAttributedString(string: "APPLY CODE", attributes: attrs)
                    cell.btnApply.setAttributedTitle(NSAttributedString(attributedString: attributedString), for: .normal)
                    cell.couponStatus = true
                }
                //MARK: START MHIOS-1129
                if let ob = self.myTotal
                {
                    if ob.extensionAttributes.instantCouponApplied
                       
                    {
                        if ob.totalSegments.count != 0
                        {
                            for var index in (0..<ob.totalSegments.count)
                            {
                                if ob.totalSegments[index].code == "discount"
                                {
                                    cell.txtCode.text = ob.totalSegments[index].title
                                }
                            }
                        }
                           
                        let attributedString = NSMutableAttributedString(string: "REMOVE", attributes: attrs)
                        cell.btnApply.setAttributedTitle(NSAttributedString(attributedString: attributedString), for: .normal)
                        cell.txtCode.isUserInteractionEnabled = false
                        cell.isInstantDiscount = true
                        if self.myTotal?.couponCode != nil
                        {
                            cell.isCouponApplied = true
                            cell.couponCode = self.myTotal?.couponCode ?? ""
                        }
                    }
                    else
                    { 
                        if self.myTotal?.couponCode != nil
                        {
                            cell.txtCode.isUserInteractionEnabled = false

                        }
                        else
                        {
                            cell.txtCode.isUserInteractionEnabled = true
                        }
                        cell.isInstantDiscount = false
                        cell.isCouponApplied = false
                        cell.couponCode = ""
                    }
                    
                }
                //MARK: END MHIOS-1129
                cell.btnExpandNew.addTarget(self, action: #selector(self.cupenExpand(_:)), for: .touchUpInside)
                cell.couponApply = { [self] (status) in
                    if cell.isInstantDiscount && cell.isCouponApplied
                    {
                        ApplyCode(code:cell.couponCode,status: status)
                        
                    }
                    else
                    {
                        ApplyCode(code:cell.txtCode.text!,status: status)
                    }
                }
                //MARK: START MHIOS-1129
                cell.couponCancel = {
                    self.removeDiscount()
                }
                //MARK: END MHIOS-1129
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstallmentTVC", for: indexPath) as? InstallmentTVC else { return UITableViewCell()}
                if(self.installementExpand==true)
                {
                    cell.installementView.isHidden = false
                    cell.btnExpand.setImage(UIImage(named: "up_arrow.png"), for: .normal)
                }
                else
                {
                    cell.installementView.isHidden = true
                    cell.btnExpand.setImage(UIImage(named: "down_arrow.png"), for: .normal)
                }
                
                let isPostpayAvailableStatus = self.mycart?.extensionAttributes?.isPostpayAvailable!
                let isTabbyAvailableStatus = self.mycart?.extensionAttributes?.isTabbyAvailable!
                
                print("isPostpayAvailableStatus : \(isPostpayAvailableStatus)")
                print("isTabbyAvailableStatus : \(isTabbyAvailableStatus)")
                
                if isPostpayAvailableStatus == "1" && isTabbyAvailableStatus == "1"
                {
                    insatllmentBoxHeight = 170
                    insatllmentBoxHeightDrop = 50
                    cell.installmentMainView.isHidden = false
                    cell.noInstallmentView.isHidden = true
                    cell.postpayView.isHidden = false
                    cell.TabbyView.isHidden = false
                }
                else
                {
                    if isPostpayAvailableStatus == "0" && isTabbyAvailableStatus == "0"
                    {
                        insatllmentBoxHeight = 0
                        insatllmentBoxHeightDrop = 0
                        //MARK: START MHIOS-1308
                        cell.installementView.isHidden = false
                        //MARK: END MHIOS-1308
                        cell.installmentMainView.isHidden = true
                        cell.noInstallmentView.isHidden = false
                        cell.postpayView.isHidden = true
                        cell.TabbyView.isHidden = true
                    }
                    else if  isPostpayAvailableStatus == "0"
                    {
                        insatllmentBoxHeight = 85
                        insatllmentBoxHeightDrop = 50
                        cell.installmentMainView.isHidden = false
                        cell.noInstallmentView.isHidden = true
                        cell.postpayView.isHidden = true
                        cell.TabbyView.isHidden = false
                    }
                    else
                    {
                        insatllmentBoxHeight = 85
                        insatllmentBoxHeightDrop = 50
                        cell.noInstallmentView.isHidden = true
                        //MARK: START MHIOS-1308
                        cell.installmentMainView.isHidden = false
                        //MARK: END MHIOS-1308
                        cell.postpayView.isHidden = false
                        cell.TabbyView.isHidden = true
                    }
                }
                
                
                
                let boldAttributes: [NSAttributedString.Key: Any] = [
                    .font: AppFonts.LatoFont.Bold(13),
                    .foregroundColor: AppColors.shared.Color_black_000000
                ]
                let regularAttributes: [NSAttributedString.Key: Any] = [
                    .font: AppFonts.LatoFont.Regular(13),
                    .foregroundColor: AppColors.shared.Color_black_000000
                ]
                
                let totalSegments = self.myTotal?.totalSegments
                let totalSegmentsCount = self.myTotal?.totalSegments.count ?? 0
                cell.discountPrice.isHidden = true
                iscountPriceStatus = false
                if totalSegments?.count != 0
                {
                    for var index in (0..<totalSegmentsCount)
                    {
                        if totalSegments![index].code == "discount"
                        {
                            iscountPriceStatus = true
                            print("SANTHOSH discount is : \(totalSegments![index].value)")
                            cell.discountPrice.text = "\(self.formatNumberToThousandsDecimal(number: totalSegments![index].value ?? 0.00)) AED"
                            cell.discountPrice.isHidden = false
        
                        }
                        
                        if totalSegments![index].code == "subtotal"
                        {
                            print("SANTHOSH subtotal is : \(totalSegments![index].value)")
                            cell.lblSubTotal.text = "\(self.formatNumberToThousandsDecimal(number: totalSegments![index].value ?? 0.00)) AED"
                        }
                        
                        if totalSegments![index].code == "grand_total"
                        {
                            print("SANTHOSH grand_total is : \(totalSegments![index].value)")
                            totalGrandSegement = totalSegments![index].value ?? 0.00
                            let totalGrand = self.formatNumberToThousandsDecimal(number: totalGrandSegement);
                            cell.lblOrderTotal.text = "\(totalGrand) AED"
                            
                        }
                    }
                }
                
                let shippingTotalAmt = Double(self.myTotal?.shippingInclTax ?? 0.00)
                if shippingTotalAmt > 0
                {
                    cell.deliveryLbl.isHidden = false
                    cell.shippingLblView.isHidden = false
                    cell.deliveryLbl.text = "\(self.formatNumberToThousandsDecimal(number:shippingTotalAmt )) AED"
                } else {
                    cell.deliveryLbl.isHidden = true
                    cell.shippingLblView.isHidden = true
                    //cell.deliveryLbl.text = "FREE"
                }
                //tabby
                var attributeString = NSMutableAttributedString(
                    string: "4 interest free installments every month of ",
                    attributes: regularAttributes)
                let instalment = Double ((totalGrandSegement)/4)
                let doubleStr = String(format: "%.2f", instalment)
                var attributeString1 = NSMutableAttributedString(
                    string: "\(doubleStr) AED",
                    attributes: boldAttributes)
                //                var attributeString2 = NSMutableAttributedString(
                //                   string: " Valid for orders upto ",
                //                   attributes: regularAttributes)
                //                var attributeString3 = NSMutableAttributedString(
                //                   string: "10000 AED",
                //                   attributes: boldAttributes)
                attributeString.append(attributeString1)
                
                //                attributeString.append(attributeString2)
                //                attributeString.append(attributeString3)
                cell.lblTabbyDescription.attributedText = attributeString
                
                //postpay
                //MARK: START MHIOS-1293
                var attributeStringPostPay = NSMutableAttributedString(
                    string: "As low as /month",
                    attributes: regularAttributes)
                let instalment1 = Double ((totalGrandSegement)/6)
                let doubleStr1 = String(format: "%.2f", instalment1)
                var attributeString4 = NSMutableAttributedString(
                    string: "AED \(doubleStr1) ",
                    attributes: boldAttributes)
                let insertionIndex = 10
                attributeStringPostPay.insert(attributeString4, at: insertionIndex)
                cell.lblPostpayDescription.attributedText = attributeStringPostPay
                //                var attributeString5 = NSMutableAttributedString(
                //                   string: " Valid for orders upto ",
                //                   attributes: regularAttributes)
                //                var attributeString6 = NSMutableAttributedString(
                //                   string: "10000 AED",
                //                   attributes: boldAttributes)
                //attributeStringPostPay.append(attributeString4)
                //                attributeStringPostPay.append(attributeString5)
                //                attributeStringPostPay.append(attributeString6)
                
                // cell.lblPostpayDescription.attributedText = attributeStringPostPay
                cell.btnTabbyInfo.addTarget(self, action: #selector(self.tabbyInfo(_:)), for: .touchUpInside)
                cell.btnPostpayInfo.addTarget(self, action: #selector(self.postpayInfo(_:)), for: .touchUpInside)
                //MARK: END MHIOS-1293

                
                
                
                //cell.lblSubTotal.text = "\(formatNumberToThousandsDecimal(number:Int(self.myTotal?.subtotalInclTax ?? 0)) ) AED"
                ///cell.lblOrderTotal.text = "\(formatNumberToThousandsDecimal(number:Int(self.myTotal?.baseGrandTotal ?? 0)) ) AED" //"\(self.myTotal?.grandTotal ?? 0 ) AED"
                print("SANTHOSH COUPEN CODE ID ")
                print(self.myTotal?.couponCode)
                if self.myTotal?.couponCode != nil
                {
                    cell.discountPrice.isHidden = false
                    cell.discountPriceView.isHidden = false
                    ///cell.discountPrice.text = "\(formatNumberToThousandsDecimal(number:Int(self.myTotal?.discountAmount ?? 0)) ) AED"
                }
                else
                {
                    if !iscountPriceStatus
                    {
                        cell.discountPrice.isHidden = true
                        cell.discountPriceView.isHidden = true
                    }
                    else
                    {
                        cell.discountPrice.isHidden = false
                        cell.discountPriceView.isHidden = false
                    }
                }
                //"\(self.myTotal?.grandTotal ?? 0 ) AED"
                cell.btnExpandNew.addTarget(self, action: #selector(self.installmentExpand(_:)), for: .touchUpInside)
                return cell
            case 2:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarItemsTVC", for: indexPath) as? SimilarItemsTVC else { return UITableViewCell()}
                
                cell.youMightLikeProductsArray = youMightLikeProductsArray
                cell.productSubDelegate = self
                cell.collectionSimilarItems.delegate = cell
                cell.collectionSimilarItems.dataSource = cell
                DispatchQueue.main.async {
                    cell.collectionSimilarItems.reloadData()
                }
                if similarItemsStatus
                {
                    startAnim(view: cell.mainView)
                    startAnim(view: cell.labelView)
                }
                else
                {
                    stopAnim(view: cell.mainView)
                    stopAnim(view: cell.labelView)
                }
                
                return cell
                
            case 3:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTVC", for: indexPath) as? FaqTVC else { return UITableViewCell()}
                cell.lblName.text = "FAQ’s"
                cell.lastSepView.isHidden = false
                return cell
            case 4:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTVC", for: indexPath) as? FaqTVC else { return UITableViewCell()}
                cell.lblName.text = "DELIVERY & RETURNS"
                cell.lastSepView.isHidden = true
                return cell
                
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTVC", for: indexPath) as? FaqTVC else { return UITableViewCell()}
                cell.lastSepView.isHidden = true
                return cell
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
            let cartItem:CartItem = (self.mycart?.items?[indexPath.row])!
            let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = cartItem.sku ?? ""
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        if(indexPath.section == 1)
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            switch indexPath.row {
            case 3:
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = AppController.shared.web
                vc.urlString = appDelegate.faqs
                // Mark MHIOS-533
                vc.hidesBottomBarWhenPushed = true
                // Mark MHIOS-533
                vc.ScreenTitle = "FAQ's"
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 4:
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let vc = AppController.shared.web
                vc.urlString = appDelegate.deliverReturns
                // Mark MHIOS-533
                vc.hidesBottomBarWhenPushed = true
                // Mark MHIOS-533

                vc.ScreenTitle = "DELIVERY & RETURNS"
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
            default:
                print("")
            }
        }
        
    }
    @objc func cupenExpand(_ sender: UIButton) {
        self.cupanExpand = !self.cupanExpand
        self.tblCart.reloadData()
    }
    @IBAction func close(_ sender: Any) {
        self.popUpView.isHidden = true
        
        for v in   self.popContentView.subviews
        {
            if(v.isKind(of: UIImageView.self))
            {
                
            }
            else if(v.isKind(of: UILabel.self))
            {
                
            }
            else
            {
                v.removeFromSuperview()
            }
            
        }
    }
    @IBAction func StartShoping(_ sender: Any) {
        //self.toastView(toastMessage: "Couldn't able..",type: "success")
        ///self.tabBarController?.selectedIndex = 1
        //        var vc = AppController.shared.menuPLP
        //        vc.category_id =  "362"
        //        vc.roomtite = "NEW IN"
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        self.tabBarController?.selectedIndex = 0
    }
    @objc func installmentExpand(_ sender: UIButton) {
        self.installementExpand = !self.installementExpand
        self.tblCart.reloadData()
    }
    
    
    
    
    @IBAction func ProccedtoCheckOut(_ sender: Any) {
        
        
        let klaviyo = KlaviyoSDK()
        let event = Event(name: .CustomEvent("Start checkout"), properties: [
            "OrderCurrencyCode": "AED" ,"GrandTotal":self.myTotal?.baseGrandTotal,"ItemQuantity":self.mycart?.itemsQty,
            "Items": self.mycart?.items
        ], value:Double(self.myTotal?.baseGrandTotal ?? 0))
        klaviyo.create(event: event)
        var readyToProceed = true
        for item in self.mycart?.items ?? []{
            let availableQuantity = Int(item.extension_attributes?.salable_qty ?? "0") ?? 0
            let currentQuantity = Int(item.qty ?? 0)
            if currentQuantity > availableQuantity {
                readyToProceed = false
                break
            }
        }
        if readyToProceed {
            if UserData.shared.isLoggedIn{
                self.apiDeliveryOption(){ response in
                    DispatchQueue.main.async {
                        let adress:AddressModel? = response as AddressModel
                        if ((adress?.addresses?.isEmpty ?? true)){
                            let nextVC = AppController.shared.deliveryOptions
                            nextVC.myTotal = self.myTotal
                            nextVC.hidesBottomBarWhenPushed = true
                            
                            let nextVC2 = AppController.shared.addAddress
                            nextVC2.isFromCart = true
                            self.navigationController?.pushViewControllers([nextVC,nextVC2], animated: true)
                        }else{
                            let nextVC = AppController.shared.deliveryOptions
                            nextVC.myTotal = self.myTotal
                            nextVC.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }
                }
            }
            else
            {
                let nextVC = AppController.shared.loginRegister
                nextVC.hidesBottomBarWhenPushed = true
                nextVC.isFromCart = true
                nextVC.myTotal = self.myTotal
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }else{
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Unable to proceed: Some of the products are out of stock in your cart","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Unable to proceed: Some of the products are out of stock in your cart",type: "error")
        }
    }
    @objc func tabbyInfo(_ sender: UIButton) {
        //self.popUpView.isHidden=false
        print("tabby")
        let instalment = Double (totalGrandSegement)
        /* if #available(iOS 14.0, *) {
         let vc = UIHostingController(
         rootView: Tabby.TabbyCreditCardInstallmentsSnippet(amount: self.myTotal?.grandTotal ?? 0.0, currency: .AED)
         )
         addChild(vc)
         vc.view.frame = CGRect(x: 0, y: 0, width:self.popContentView.frame.size.width , height: self.popContentView.frame.size.height)
         self.popContentView.addSubview(vc.view)
         vc.didMove(toParent: self)
         } else {
         // Fallback on earlier versions
         }*/
        
        let vc = AppController.shared.web
        vc.urlString = "https://checkout.tabby.ai/promos/product-page/installments/en/?price=\(instalment)&currency=AED"
        vc.ScreenTitle = "Installments with Tabby"
        vc.isfromPayment = true
        // Mark MHIOS-533
        vc.hidesBottomBarWhenPushed = true
        // Mark MHIOS-533
        //self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func postpayInfo(_ sender: UIButton) {
        print("postpay")
        let instalment = Double (totalGrandSegement)
        let doubleStr = String(format: "%.2f", instalment)
        self.lblPostpaySplitUp.text = "Pay AED \(doubleStr) today, pay the rest in 2 monthly installments"
        // self.popUpView.isHidden=false
        let vc = AppController.shared.web
        vc.urlString = AppInfo.shared.postpayCMSUrl + "\(instalment)" //"https://checkout.tabby.ai/promos/product-page/installments/en/?price=\(instalment)&currency=AED"
        vc.ScreenTitle = "Installments with Postpay"
        vc.isfromPayment = true
        // Mark MHIOS-533
        vc.hidesBottomBarWhenPushed = true
        // Mark MHIOS-533
        //self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func moveToWishlistItem(_ sender: UIButton) {
        print("moveToWishlistItem")
        
        let cartItem:CartItem = (self.mycart?.items?[sender.tag])!
        if UserData.shared.isLoggedIn
        {
            print(cartItem.itemID)
            self.apiMoveProductFromCartToWishlist(Itemid:cartItem.sku ?? "",qty: cartItem.qty ?? 0){ response in
                DispatchQueue.main.async {
                    if response{
                        //MARK START{MHIOS-1181}
                        UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int("\(cartItem.itemID ?? 0)") ?? 0,sku: "\(cartItem.sku ?? "0")"))
                        //MARK END{MHIOS-1181}
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.wishList.append("\(cartItem.itemID ?? 0)")
                        self.cartStatusCheck()
                    }
                    /*self.apiCarts(){ response in
                     DispatchQueue.main.async {
                     print(response)
                     self.mycart = response as Cart
                     self.tblCart.reloadData()
                     }
                     
                     }*/
                    
                    
                    else{
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
            
            //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //            appDelegate.wishList.append(productId)
            //self.collectionPLP.reloadData()
            
            //self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
            //            self.showAlert(message: "Please log in or register to view your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
            //                self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
            //            }, leftAction: {})
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            print("SANTHOSH CART WISHLIST ITEMS BEFORE : \(appDelegate.wishList)")
            //appDelegate.wishList.append("\(cartItem.itemID!)")
            print("SANTHOSH CART WISHLIST ITEMS : \(appDelegate.wishList)")
            //self.btnWishlist.setImage(UIImage(named: "liked"), for: .normal)
            //self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
            //MARK START{MHIOS-1029}
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.wishList.append(productId)
            //MARK START{MHIOS-1235}
            UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:cartItem.extension_attributes?.custom_product_id ?? 0,sku: cartItem.sku ?? ""))
            //MARK END{MHIOS-1235}
            print("SANTHOSH WISHLIST G LIST \(UserData.shared.wishListIdArray)")
            self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
//                self.showAlert(message: "Please log in or register to view your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
//                    self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
//                }, leftAction: {
//                    //print("SANTHOSH WISHLIST G LIST \(appDelegate.wishLists[0])")
//                })
            //MARK END{MHIOS-1029}
            let cartItem:CartItem = (self.mycart?.items?[sender.tag])!
            Analytics.logEvent("remove_from_cart", parameters: [
                AnalyticsParameterItemID: cartItem.itemID ?? "",
                AnalyticsParameterItemName: cartItem.name ?? "" ,
                AnalyticsParameterCurrency: "AED",
                AnalyticsParameterValue:cartItem.price ?? 0.0
            ])
            //MARK: START MHIOS-1064
            var properties = [String:Any]()
            properties["ItemID"] = "\(cartItem.itemID ?? -1)"
            properties["ItemName"] = "\(cartItem.name ?? "")"
            properties["currency"] = "AED"
            properties["price"] = "\(cartItem.price ?? 0.0)"
            SmartManager.shared.trackEvent(event: "remove_from_cart", properties: properties)
            //MARK: END MHIOS-1064
            self.apiGuestRemoveItemFromCart(Itemid:cartItem.itemID ?? 0){ response in
                DispatchQueue.main.async {
                    if response{
                        print("SANTHOSH apiGuestRemoveItemFromCart OK dddddddddddddddd: ")
                        self.cartStatusCheck()
                        //self.toastView(toastMessage: "Successfully Removed",type: "success")
                        //MARK START{MHIOS-1235}
//                        self.showAlert(message: "Please log in or register to view your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
//                            self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
//                        }, leftAction: {})
                        //MARK START{MHIOS-1235}
                    }else{
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Couldn't able to send reset link to your email!. please try again","Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: "Couldn't able to send reset link to your email!. please try again",type: "error")
                    }
                }
            }
            
        }
        
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
    @objc func RemoveItem(_ sender: UIButton) {
        
        self.showAlert(message: "Do you want to remove this product?", hasleftAction: true,rightactionTitle: "Yes", rightAction: {
            
            let cartItem:CartItem = (self.mycart?.items?[sender.tag])!
            
            Analytics.logEvent("remove_from_cart", parameters: [
                AnalyticsParameterItemID: cartItem.itemID ?? "",
                AnalyticsParameterItemName: cartItem.name ?? "" ,
                AnalyticsParameterCurrency: "AED",
                AnalyticsParameterValue:cartItem.price ?? 0.0
            ])
            //MARK: START MHIOS-1064
            var properties = [String:Any]()
            properties["ItemID"] = "\(cartItem.itemID ?? -1)"
            properties["ItemName"] = "\(cartItem.name ?? "")"
            properties["currency"] = "AED"
            properties["price"] = "\(cartItem.price ?? 0.0)"
            SmartManager.shared.trackEvent(event: "remove_from_cart", properties: properties)
            //MARK: END MHIOS-1064
            //MARK: START MHIOS-1225
            CrashManager.shared.log("Product removed from cart:\(cartItem.itemID ?? -1)")
            //MARK: END MHIOS-1225
            if UserData.shared.isLoggedIn{
                self.apiRemoveItemFromCart(Itemid:cartItem.itemID ?? 0){ response in
                    DispatchQueue.main.async {
                        if response{
                            //                            self.apiGrandTotal(){ response in
                            //                                DispatchQueue.main.async {
                            //                                    print(response)
                            ////                                    self.myTotal = response as GrandTotal
                            ////                                    self.lblGrandTotal.text = "\(self.myTotal?.grandTotal ?? 0.00) AED"
                            //
                            //                                    print(response)
                            //                                    self.myTotal = response as GrandTotal
                            //                                    print("SANTHOSH grandTotal : ",self.myTotal?.grandTotal)
                            //                                    self.lblGrandTotal.text = "\(self.formatNumberToThousandNew(number: Int(self.myTotal?.baseGrandTotal ?? 0.00))) AED"
                            //
                            //
                            //                                }
                            //                            }
                            //                            self.apiCarts(){ response in
                            //                                DispatchQueue.main.async {
                            //                                    print(response)
                            //                                    self.mycart = response as Cart
                            //                                    self.tblCart.reloadData()
                            //                                }
                            //
                            //                            }
                            
                            self.cartStatusCheck()
                            self.toastView(toastMessage: "Successfully Removed",type: "success")
                        }else{
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
                self.apiGuestRemoveItemFromCart(Itemid:cartItem.itemID ?? 0){ response in
                    DispatchQueue.main.async {
                        if response{
                            print("SANTHOSH apiGuestRemoveItemFromCart OK dddddddddddddddd: ")
                            //                            self.apiGuestGrandTotal(){ response in
                            //                                DispatchQueue.main.async {
                            ////                                    print(response)
                            ////                                    self.myTotal = response as GrandTotal
                            ////                                    self.lblGrandTotal.text = "\(self.myTotal?.grandTotal ?? 0.00) AED"
                            //
                            //                                    print(response)
                            //                                    self.myTotal = response as GrandTotal
                            //                                    print("SANTHOSH grandTotal : ",self.myTotal?.grandTotal)
                            //                                    self.lblGrandTotal.text = "\(self.formatNumberToThousandNew(number: Int(self.myTotal?.baseGrandTotal ?? 0.00))) AED"
                            //
                            //
                            //                                }
                            //                            }
                            //                            self.apiCarts(){ response in
                            //                                DispatchQueue.main.async {
                            //                                    print(response)
                            //                                    self.mycart = response as Cart
                            //                                    self.tblCart.reloadData()
                            //                                }
                            //
                            //                            }
                            
                            self.cartStatusCheck()
                            self.toastView(toastMessage: "Successfully Removed",type: "success")
                        }else{
                            //MARK: START MHIOS-1285
                            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Couldn't able to send reset link to your email!. please try again","Screen" : self.className])
                            //MARK: END MHIOS-1285
                            self.toastView(toastMessage: "Couldn't able to send reset link to your email!. please try again",type: "error")
                        }
                    }
                }
            }
            
        }, leftAction: {})
        
    }
    func ApplyCode(code: String ,status:Bool) {
        
        print("CODE VALIDATION")
        print(status)
        
        if self.codeTxt?.text != ""
        {
            if UserData.shared.isLoggedIn{
                apiApplyCoupenCode(Code:self.codeTxt?.text ?? "" ,status: status){ response in
                    
                    print("SANTHOSH APPLY COUPEN : \(response)")
                    DispatchQueue.main.async {
                        if response
                        {
                            self.cartStatusCheck()
                            self.tblCart.reloadData()
                            //                        self.apiCarts(){ response in
                            //                            DispatchQueue.main.async {
                            //                                print(response)
                            //                                self.mycart = response as Cart
                            //                                self.tblCart.reloadData()
                            //                            }
                            //
                            //                        }
                        }
                        else
                        {
                            ///self.toastView(toastMessage: "Couldn't able to send reset link to your email!. please try again",type: "error")
                        }
                    }
                }
            }
            else
            {
                apiGuestApplyCoupenCode(Code:self.codeTxt?.text ?? "" ,status: status){ response in
                    print("SANTHOSH Guest APPLY COUPEN : \(response)")
                    DispatchQueue.main.async {
                        if response{
                            self.cartStatusCheck()
                            self.tblCart.reloadData()
                            //                        self.apiCarts(){ response in
                            //                            DispatchQueue.main.async {
                            //                                print(response)
                            //                                self.mycart = response as Cart
                            //                                self.tblCart.reloadData()
                            //                            }
                            //
                            //                        }
                        }
                        else
                        {
                            ///self.toastView(toastMessage: "Couldn't able to send reset link to your email!. please try again",type: "error")
                        }
                    }
                }
            }
        }
        else
        {
            //MARK: START MHIOS-1285
            SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Please enter a valid coupon code","Screen" : self.className])
            //MARK: END MHIOS-1285
            self.toastView(toastMessage: "Please enter a valid coupon code",type: "error")
        }
        
        
    }
    //MARK: START MHIOS-1129
    func removeDiscount() {
        
            if UserData.shared.isLoggedIn{
                apiRemoveUserDiscount(cartId: "\(UserData.shared.cartQuoteId)"){ response in
                        DispatchQueue.main.async {
                        if response
                            {
                            if let cell = self.tblCart.cellForRow(at: IndexPath(row: 0, section: 1)) as? CartCupenTVC
                            {
                                cell.txtCode.isUserInteractionEnabled = true
                            }
                           
                            self.cartStatusCheck()
                           
                        }
                        
                    }
                }
            }
            else
            {
                apiRemoveGuestUserDiscount(cartId: "\(UserData.shared.cartQuoteId)"){ response in
                    DispatchQueue.main.async {
                        if response{
                            if let cell = self.tblCart.cellForRow(at: IndexPath(row: 0, section: 1)) as? CartCupenTVC
                            {
                                cell.txtCode.isUserInteractionEnabled = true
                            }
                            self.cartStatusCheck()
                           
                        }
                        
                    }
                }
            }
        
    }
    //MARK: END MHIOS-1129
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func changeQuantity(tag:Int ,quantity:Int,sku:String)
    {
        print("SNTHOPSH SKU IS AAAAA : ",sku )
        print("SNTHOPSH QTY IS AAAAA : ",quantity )
        print("SNTHOPSH Q UPDATE API TAG IS : ",tag )
        
        let cartItem:CartItem = (self.mycart?.items?[tag])!
        print("SNTHOPSH ID IS BBBBB : ",cartItem.itemID)
        if UserData.shared.isLoggedIn{
            self.apiChangeQuantityCart(Itemid:cartItem.itemID ?? 0, Quantity: quantity, sku: cartItem.sku ?? "" ){ response,message in
                DispatchQueue.main.async {
                    if response
                    {
                        self.cartStatusCheck()
                        
                        self.toastView(toastMessage: "Successfully added",type: "success")
                    }
                    else
                    {
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": message,"Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: message,type: "error")
                    }
                }
            }
        }
        else
        {
            self.apiGuestChangeQuantityCart(Itemid:cartItem.itemID ?? 0, Quantity: quantity ){ response,message in
                DispatchQueue.main.async {
                    if response{
                        
                        self.cartStatusCheck()
                        self.toastView(toastMessage: "Successfully added",type: "success")
                        //                        self.apiGuestGrandTotal(){ response in
                        //                            DispatchQueue.main.async {
                        ////                                print(response)
                        ////                                self.myTotal = response as GrandTotal
                        ////                                self.lblGrandTotal.text = "\(self.myTotal?.grandTotal ?? 0.00) AED"
                        //
                        //                                print(response)
                        //                                self.myTotal = response as GrandTotal
                        //                                print("SANTHOSH grandTotal : ",self.myTotal?.grandTotal)
                        //                                self.lblGrandTotal.text = "\(self.formatNumberToThousandNew(number: Int(self.myTotal?.baseGrandTotal ?? 0.00))) AED"
                        //
                        //                            }
                        //                        }
                        //                        self.apiGuestCarts(){ response in
                        //                            DispatchQueue.main.async {
                        //                                print(response)
                        //                                self.mycart = response as Cart
                        //                                self.tblCart.reloadData()
                        //                            }
                        //
                        //                        }
                    }else{
                        //MARK: START MHIOS-1285
                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": message,"Screen" : self.className])
                        //MARK: END MHIOS-1285
                        self.toastView(toastMessage: message ,type: "error")
                    }
                }
            }
        }
        
    }
    

    //MARK START{MHIOS-1029}
    func addToWishListSub(productId:String,sku:String)
    {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Product added to wishlist:\(productId)")
        //MARK: END MHIOS-1225
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
    
    func removeWishListSub(productId:String,tag:Int)
    {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Product removed from wishlist:\(productId)")
        //MARK: END MHIOS-1225
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
    
    func openDetailSub(tag:Int)
    {
        
        let nextVC = AppController.shared.productDetailsImages
        nextVC.productId = "\(self.youMightLikeProductsArray[tag].sku ?? "")"
        nextVC.wishListId = "\(self.youMightLikeProductsArray[tag].id)"
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    private func formatNumberToThousandNew(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? ""
    }
    
    private func formatNumberToThousandNew2(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.minimumFractionDigits = 2
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? ""
    }
}


extension UINavigationController {
    open func pushViewControllers(_ inViewControllers: [UIViewController], animated: Bool) {
        var stack = self.viewControllers
        stack.append(contentsOf: inViewControllers)
        self.setViewControllers(stack, animated: animated)
    }
    
}

extension UIViewController {
    
    var previousViewController: UIViewController? {
        guard
            let viewControllers = navigationController?.viewControllers,
            let index = viewControllers.firstIndex(of: self),
            index > 0
        else { return nil }
        
        return viewControllers[index - 1]
    }
}
