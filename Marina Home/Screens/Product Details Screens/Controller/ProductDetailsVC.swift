//
//  ProductDetailsVC.swift
//  Marina Home
//
//  Created by Codilar on 26/04/23.
//

import UIKit
import UBottomSheet
import Foundation
import SwiftUI
import Firebase
import KlaviyoSwift
import Adjust

protocol AddToCartPopupDelegate {
    func cartPopup(data:String)
    
}

class ProductDetailsVC: AppUIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UBottomSheetCoordinatorDelegate,ProductCardDelegate,UIScrollViewDelegate,AddToCartPopupsDelegate, InfoDelegate{
    
    func goToCArt() {
        // Mark MHIOS-1072
        UserData.shared.previousTab =  self.tabBarController?.selectedIndex ?? 0
        // Mark MHIOS-1072
        UserData.shared.goTocartStatus = true
        if bottomSheetOpenStatus == true
        {
            self.tabBarController?.tabBar.isHidden = true
        }
        else
        {
            self.tabBarController?.tabBar.isHidden = false
        }
        myView?.isHidden = false
        addToCartbutton?.isHidden = false
        addToCartSuccess?.isHidden = true
        self.myView?.isHidden = true
        self.addToCartbutton?.isHidden = true
        sheetCoordinator!.setPosition(dataSource!.initialPosition(0), animated: false)
       
        self.tabBarController?.selectedIndex = 3
        self.tabBarController?.hidesBottomBarWhenPushed = false
        if let tab = self.tabBarController  {
             tab.selectedIndex = 3
             if let navcon = tab.selectedViewController as? UINavigationController {
                                navcon.popToRootViewController(animated: true)
             }

            }
            // Mark MHIOS-1072
//            }
//            else
//            {
//
//                if let tab = self.tabBarController  {
//                    tab.selectedIndex = 3
//                    if let navcon = tab.selectedViewController as? UINavigationController {
//
//                        let nextVC = AppController.shared.mycart
//                        nextVC.hidesBottomBarWhenPushed = false
//                        navcon.pushViewController(nextVC, animated: true)
//                    }
//
//                }
//
//            }
            // Mark MHIOS-1072
        }
    @IBAction func navigateButton(_ sender: Any) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = AppController.shared.homePdp
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func closePopup() {
        if bottomSheetOpenStatus == true
        {
            self.tabBarController?.tabBar.isHidden = true
        }
        else
        {
            self.tabBarController?.tabBar.isHidden = false
        }
        UserData.shared.goTocartStatus = false
        myView?.isHidden = false
        addToCartbutton?.isHidden = false
        //addToCartSuccess?.isHidden = true
        self.addToCartSuccess!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear],
                               animations: {
            self.addToCartSuccess!.center.y += self.addToCartSuccess!.bounds.height
            self.addToCartSuccess!.layoutIfNeeded()

                },  completion: {(_ completed: Bool) -> Void in
                self.addToCartSuccess!.isHidden = true
                    })
    }
    //MARK: START MHIOS-1182

   func closeInfoView()
    {
        self.webView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear],
                               animations: {
            self.webView!.center.y += self.addToCartSuccess!.bounds.height
            self.webView!.layoutIfNeeded()

                },  completion: {(_ completed: Bool) -> Void in
                self.webView!.isHidden = true
                    self.myView?.isHidden = false
                    self.addToCartbutton?.isHidden = false
                    })
    }
    //MARK: END MHIOS-1182

    //AddToCartPopupsDelegate
    
    func printMyText(takeIn stringValue: String) {
        print("String value result: \(stringValue)")
        addToCartSuccess!.isHidden = true
    }
    
    @IBOutlet var SuccesPopView: UIView!
    func redirectToLoginPage() {
        self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
    }
    var addToCartPopupDelegate : AddToCartPopupDelegate?
    var sheetCoordinator: UBottomSheetCoordinator?
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    @IBOutlet weak var recommendedProductsCV: UICollectionView!
    @IBOutlet weak var recommendedProductsView: UIStackView!
    @IBOutlet weak var offerProductCombCV: UICollectionView!
    @IBOutlet weak var productNameLbl: UILabel!
    
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var offerPriceLbl: UILabel!
    
    @IBOutlet weak var productCodeLbl: UILabel!
    @IBOutlet weak var productShortTitleLbl: UILabel!
    @IBOutlet weak var productQtyLbl: UILabel!
    @IBOutlet weak var productDescriptionView: UIView!
    @IBOutlet weak var productDescriptionLbl: UILabel!
    @IBOutlet weak var productCareView: UIView!
    @IBOutlet weak var productCareLbl: UILabel!
    @IBOutlet weak var productSpecView: UIView!
    @IBOutlet weak var productSpecLbl: UILabel!
    @IBOutlet weak var productDeliveryView: UIView!
    @IBOutlet weak var productDeliveryLbl: UILabel!
    @IBOutlet weak var productInstalmentView: UIView!
    @IBOutlet weak var instalmentMainView: UIView!
    
    //    @IBOutlet weak var productPostPay: UIStackView!
//    @IBOutlet weak var productTabby: UIStackView!
//    @IBOutlet weak var productInstalmentNotAvailable: UIStackView!

    @IBOutlet var detailView: UIStackView!
    
    @IBOutlet var productDetailArrow: UIImageView!
    
    @IBOutlet var productinstallmentArrow: UIImageView!
    @IBOutlet var productDeliveryArrow: UIImageView!
    @IBOutlet var productCareArrow: UIImageView!
    @IBOutlet var specifcationArrow: UIImageView!
    var recommendedProductsArray:[Records] = []
    var offerProductImagesArray:[String] = []
    var productDetails:ProductDetailsModel!
    var navigation:UINavigationController?
    var productQty = 0
    var productQtyLeft = 0
    var finalPrice = 0.0
    
    @IBOutlet weak var droppingBtnView: UIButton!
    @IBOutlet weak var addToCartBtnBGView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var productDetailsView: UIView!
    @IBOutlet weak var specificationView: UIView!
    @IBOutlet weak var productCareMainView: UIView!
    @IBOutlet weak var deliveryMainView: UIView!
    
    var lastY: CGFloat = 0.0
    
    var statusBarHeight:CGFloat?
    var navBarHeight:CGFloat?
    var navTabBarHeight:CGFloat?
    var myView:UIView?
    var addToCartbutton:UIButton?
    var goToCartbutton:UIButton?
    var addToCartSuccess:AddToCartSuccess?
    
    //MARK: START MHIOS-1182
    var webView:InfoWebView?
    //MARK: END MHIOS-1182
    
    var screenSize:CGRect?
    var guestCartId = ""
    var bottomSheetOpenStatus = false
    
    var controller = AppController.shared.addCartSucces
    var addToCartSuccessClass = AddToCartSuccess()
   
    @IBOutlet var lblTabbyDescription: UILabel!
    @IBOutlet var lblPostpayDescription: UILabel!
    @IBOutlet var btnPostpayInfo: UIButton!
    @IBOutlet var btnTabbyInfo: UIButton!
    
    @IBOutlet weak var noInstallmentView: UIView!
    @IBOutlet weak var postpayView: UIView!
    @IBOutlet weak var TabbyView: UIView!
    @IBOutlet weak var installmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            self.sheetPresentationController?.delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        //MARK: START MHIOS-1182
        webView = InfoWebView(frame: CGRect(x: 0, y: 0, width:(view.frame.size.width), height: view.frame.size.height))
        self.navigationController?.view.addSubview(webView!)
        webView?.isHidden = true
        webView?.delegate = self
        //MARK: START MHIOS-1182

        
        self.scrollView.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.guestCartId = appDelegate.guestCartId
        scrollView.bounces = false
        self.detailView.isHidden = false
        recommendedProductsCV.delegate = self
        recommendedProductsCV.dataSource = self
        ProductCVC.register(for: recommendedProductsCV)
        offerProductCombCV.delegate = self
        offerProductCombCV.dataSource = self
        ComboProductsCVC.register(for: offerProductCombCV)
        ComboProductsPlusCVC.register(for: offerProductCombCV)
        //MARK: START MHIOS-1225
        CrashManager.shared.log("ProductDetailsVC: ItemPrice: \(productDetails.price ?? 0.0) ,ItemSku:\(productDetails.sku ?? "No SKU"),ItemName : \(productDetails.name ?? "No Name")")
        //MARK: START MHIOS-1225
        let klaviyo = KlaviyoSDK()
        
        let event = Event(name: .CustomEvent("Viewed product"), properties: [
            "ItemPrice": "\(productDetails.price ?? 0.0)" ,"ItemSku":productDetails.sku ?? "",
            "ItemName": productDetails.name ?? ""
        ], value:0)
        
        klaviyo.create(event: event)

        //MARK: START MHIOS-1225
        CrashManager.shared.log("ProductDetailsVC: ItemPrice: \(productDetails.price ?? 0.0) ,ItemSku:\(productDetails.sku ?? "No SKU"),ItemName : \(productDetails.name ?? "No Name")")
        //MARK: START MHIOS-1225
       // setDetails()
        
//        topView.layer.masksToBounds = false
//        topView.layer.shadowRadius = 4
//        topView.layer.shadowOpacity = 1
//        topView.layer.shadowColor = UIColor.gray.cgColor
//        ///topView.layer.shadowOffset = CGSize(width: 0 , height:2)
//        topView.layer.shadowOffset = CGSize(width: -20, height: 20)
        
        installmentViewHeight.constant = 195
        
        self.tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
        {
        
        }
        
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        navBarHeight = self.navigationController!.navigationBar.frame.size.height
        navTabBarHeight = self.tabBarController!.tabBar.frame.size.height
        screenSize = UIScreen.main.bounds
        addToCartButtonView(yVAlue: (screenSize!.height-navTabBarHeight!)-90)
        goToCartButtonView(yVAlue: (screenSize!.height-navTabBarHeight!)-300)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.myView?.isHidden = true
        self.addToCartbutton?.isHidden = true
        addToCartSuccess!.isHidden = true
        sheetCoordinator!.setPosition(dataSource!.initialPosition(0), animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserData.shared.goTocartStatus = false
        self.myView?.isHidden = false
        self.addToCartbutton?.isHidden = false
//        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        sheetCoordinator?.startTracking(item: self)
        if dataSource != nil{
            sheetCoordinator!.dataSource = dataSource!
        }
        
        topView.addShadow(location: .top)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
       
        setDetails()
    }
    
    func DateToString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }

    func apiLogError(field:String){
        self.apiToLogError(parameters: [
            "api_end_point":"rest/V2/print/message",
            "area":"frontend",
            "time": DateToString(),
            "message" : "ProductDetailsVC - HTML Conversion error in \(field) - ProductId : \(self.productDetails.id ?? 0) - ProductSKU : \(self.productDetails.sku ?? "")"
            ]){
        }
    }
    
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        print("SANTHOSH WORKING FINE : ")
        let status = notification.userInfo?["status"] as? Bool
        if status!
        {
            scrollView.setContentOffset(.zero, animated: true)
            scrollView.isScrollEnabled = false
            bottomSheetOpenStatus = false
            print("SANTHOSH WORKING FINE : DOWN")
            droppingBtnView.setImage(UIImage(named: "drop_arrow_normal.png"), for: .normal)
            detailView.isHidden = false
            addToCartBtnBGView.isHidden = false
            

            if self.tabBarController?.tabBar.isHidden == true
            {
                self.tabBarController?.tabBar.isHidden = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    //self.navigationController?.popViewController(animated: true)
                }
            }
            else
            {
                //self.navigationController?.popViewController(animated: true)
            }
            updateToCartButtonView(yVAlue: (screenSize!.height-navTabBarHeight!)-90 , btnYVAlue: 25)
            ///goToCartButtonViewUpdate(yVAlue: (screenSize!.height-navTabBarHeight!)-300)
            ///scrollView.isScrollEnabled = false
            scrollView.setContentOffset(.zero, animated: true)
        }
        else
        {
            scrollView.setContentOffset(.zero, animated: true)
            self.scrollView.isScrollEnabled = true
            bottomSheetOpenStatus = true
            print("SANTHOSH WORKING FINE : UP")
            droppingBtnView.setImage(UIImage(named: "drop_arrow_down.png"), for: .normal)
            detailView.isHidden = false
            addToCartBtnBGView.isHidden = true
            
//            mainViewA.isHidden = false
//            mainViewB.isHidden = true
            if self.tabBarController?.tabBar.isHidden == false
            {
                self.tabBarController?.tabBar.isHidden = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    //self.navigationController?.popViewController(animated: true)
                }
            }
            else
            {
                //self.navigationController?.popViewController(animated: true)
            }
            
            
            //updateToCartButtonView(yVAlue: screenSize!.height-statusBarHeight! - navBarHeight! - 35 , btnYVAlue: 30)
            ////////updateToCartButtonView(yVAlue: screenSize!.height + navBarHeight! - 94 , btnYVAlue: 20)//statusBarHeight! - navBarHeight! -
            updateToCartButtonView(yVAlue: (screenSize!.height - 90) , btnYVAlue: 25)//statusBarHeight! - navBarHeight! -
            ////goToCartButtonViewUpdate(yVAlue: (screenSize!.height - 300))//statusBarHeight! - navBarHeight! -
            ///self.scrollView.isScrollEnabled = true
            scrollView.setContentOffset(.zero, animated: true)
        }
    }

    func setDetails(){
        deliveryMainView.isHidden = true
        productDetailsView.isHidden = true
        specificationView.isHidden = true
        productCareMainView.isHidden = true
        
        self.productDescriptionView.isHidden = false
        self.productDetailArrow.image = UIImage(named: "up_arrow")
        
        productNameLbl.text = productDetails.name ?? ""
        productCodeLbl.text = productDetails.sku ?? ""
        
        let isPostpayAvailableStatus = productDetails.extension_attributes?.is_postpay_available
        let isTabbyAvailableStatus = productDetails.extension_attributes?.is_tabby_available
        let wp_warning_message = productDetails.extension_attributes?.wp_warning_message
        
        if wp_warning_message != ""
        {
            do
            {
                let value = wp_warning_message ?? ""
                if value != ""
                {
                    //MARK START{MHIOS-1109}
                    deliveryMainView.isHidden = false
                    let attributedString = try NSMutableAttributedString(htmlString: value)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineBreakMode = .byTruncatingTail
                    paragraphStyle.lineSpacing = 3.5
                    attributedString.addAttribute(.paragraphStyle,value: paragraphStyle,range: NSRange(location: 0, length: attributedString.length))
                    //MARK: START MHIOS-1165
                    productDeliveryLbl.attributedText = attributedString.trailingNewlineChopped
                    //MARK: START MHIOS-1165

                    //MARK END{MHIOS-1109}
                    
//                    let splitValue = value.components(separatedBy: "|")
//                    var listValue = ""
//                    for var i in (0..<splitValue.count)
//                    {
//                        listValue = "\(listValue)• \(splitValue[i]) \n"
//                    }
//                    productDeliveryLbl.font = AppFonts.LatoFont.Light(13)
//                    productDeliveryLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                    let attributedString = NSMutableAttributedString(string: "\(listValue)")
//                    let paragraphStyle = NSMutableParagraphStyle()
//                    paragraphStyle.lineSpacing = 10 // Whatever line spacing you want in points
//                    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//                    productDeliveryLbl.attributedText = attributedString
                    
                }
                else
                {
                    deliveryMainView.isHidden = true
                }
            }
            catch
            {
                 print("Error")
            }
        }
        
        if isPostpayAvailableStatus == "1" && isTabbyAvailableStatus == "1"
        {
            
            self.installmentViewHeight.constant = 195
            self.instalmentMainView.isHidden = false
            self.noInstallmentView.isHidden = true
            self.postpayView.isHidden = false
            self.TabbyView.isHidden = false
        }
        else
        {
            if isPostpayAvailableStatus == "0" && isTabbyAvailableStatus == "0"
            {
                self.installmentViewHeight.constant = 0
                self.instalmentMainView.isHidden = true
                self.noInstallmentView.isHidden = false
                self.postpayView.isHidden = true
                self.TabbyView.isHidden = true
            }
            else if  isPostpayAvailableStatus == "0"
            {
                self.installmentViewHeight.constant = 110
                self.instalmentMainView.isHidden = false
                self.noInstallmentView.isHidden = true
                self.postpayView.isHidden = true
                self.TabbyView.isHidden = false
            }
            else
            {
                self.installmentViewHeight.constant = 110
                self.instalmentMainView.isHidden = false
                self.noInstallmentView.isHidden = true
                self.postpayView.isHidden = false
                self.TabbyView.isHidden = true
            }
        }
        
        productShortTitleLbl.text = productDetails.extension_attributes?.pdp_description ?? ""
        var specialPrice = ""
        var specialToDate = ""
        var specialFromDate = ""
        var specialPriceNumber = 0.0
        
        for item in productDetails.custom_attributes ?? []{
            
            if item.attribute_code == "special_price"{
                let spPriceVal = Double(item.value ?? "0.00")
                if let floatNumber = Float(item.value ?? "0.00")
                {
                    specialPriceNumber = spPriceVal ?? 0.0
                    specialPrice = formatNumberToThousandsDecimal(number: spPriceVal ?? 0)
                    offerPriceLbl.text = specialPrice + " AED"
                }
                else
                {
                    print("Invalid number")
                }
            }
            
            if item.attribute_code == "special_from_date"{
                specialFromDate = "\(item.value ?? "")"
                //productPriceLbl.text = "\(item.value ?? "")"
                print("special_to_date")
                print("\(item.value ?? "")")
            }
            if item.attribute_code == "special_to_date"{
                specialToDate = "\(item.value ?? "")"
                print("special_to_date")
                print("\(item.value ?? "")")
                //productPriceLbl.text = "\(item.value ?? "")"
            }
            
            if item.attribute_code == "description"{
                do
                {
                    let value = item.value ?? ""
                    if value != ""
                    {
                        productDetailsView.isHidden = false
                        let attributedString = try NSMutableAttributedString(htmlString: value, font: AppFonts.LatoFont.Light(13))
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineBreakMode = .byTruncatingTail
                        paragraphStyle.lineSpacing = 3.5
                        attributedString.addAttribute(.paragraphStyle,value: paragraphStyle,range: NSRange(location: 0, length: attributedString.length))
                        //MARK: START MHIOS-1165
                        productDescriptionLbl.attributedText = attributedString.trailingNewlineChopped
                        //MARK: END MHIOS-1165

                    }
                    else
                    {
                        productDetailsView.isHidden = true
                    }
                }
                catch
                {
                    DispatchQueue.main.async {
                        self.productDetailsView.isHidden = true
                        self.apiLogError(field: "description")
                    }
                }
            }
            
            if item.attribute_code == "product_care"{
                do
                {
                    let value = item.value ?? ""
                    if value != ""
                    {
                        productCareMainView.isHidden = false
                        let attributedString = try NSMutableAttributedString(htmlString: value, font: AppFonts.LatoFont.Light(13))
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineBreakMode = .byTruncatingTail
                        paragraphStyle.lineSpacing = 3.5
                        attributedString.addAttribute(.paragraphStyle,value: paragraphStyle,range: NSRange(location: 0, length: attributedString.length))
                        //MARK: START MHIOS-1165
                        productCareLbl.attributedText = attributedString.trailingNewlineChopped
                        //MARK: END MHIOS-1165

                    }
                    else
                    {
                        productCareMainView.isHidden = true
                    }
                    
                }
                catch
                {
                    DispatchQueue.main.async {
                        self.productCareMainView.isHidden = true
                        self.apiLogError(field: "product_care")
                    }
                }
                
            }
            
            if item.attribute_code == "show_dimensions"{
                do
                {
                    let value = item.value ?? ""
                    if value != ""
                    {
                        specificationView.isHidden = false
//                        let splitValue = value.components(separatedBy: ",")
//                        var listValue = ""
//                        for var i in (0..<splitValue.count)
//                        {
//                            listValue = "\(listValue)• \(splitValue[i]) \n"
//                        }
//
//                        productSpecLbl.font = AppFonts.LatoFont.Light(13)
//                        productSpecLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                        let attributedString = NSMutableAttributedString(string: "\(listValue)")
//                        let paragraphStyle = NSMutableParagraphStyle()
//                        paragraphStyle.lineSpacing = 10 // Whatever line spacing you want in points
//                        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//                        productSpecLbl.attributedText = attributedString
                        //MARK START{MHIOS-1141}
                        let attributedString = try NSMutableAttributedString(htmlString: value)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineBreakMode = .byTruncatingTail
                        paragraphStyle.lineSpacing = 3.5
                        attributedString.addAttribute(.paragraphStyle,value: paragraphStyle,range: NSRange(location: 0, length: attributedString.length))
                         //MARK: START MHIOS-1165
                        productSpecLbl.attributedText = attributedString.trailingNewlineChopped
                        //MARK: START MHIOS-1165
                        //MARK END{MHIOS-1141}
                    }
                    else
                    {
                        specificationView.isHidden = true
                    }
                }
                catch
                {
                     print("Error")
                }
            }
        }
        
        let thePriceIs = self.productDetails?.price ?? 0
        if 6000 < thePriceIs
        {
            
        }
        else
        {
            
        }
        
        let prodPrice = Double(productDetails.price ?? 0)
        let prodPriceTxt = formatNumberToThousandsDecimal(number: prodPrice )
        
        let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
        if specialPriceFlag {
            offerPriceLbl.isHidden = false
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(prodPriceTxt) AED")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            
            productPriceLbl.attributedText = attributeString
            finalPrice = specialPriceNumber
        } else {
            offerPriceLbl.isHidden = true
            finalPrice = prodPrice
            productPriceLbl.text = prodPriceTxt + " AED"
        }
        
        let boldAttributes: [NSAttributedString.Key: Any] = [
           .font: AppFonts.LatoFont.Bold(13),
           .foregroundColor: AppColors.shared.Color_black_000000
        ]
        let regularAttributes: [NSAttributedString.Key: Any] = [
           .font: AppFonts.LatoFont.Regular(13),
           .foregroundColor: AppColors.shared.Color_black_000000
        ]
        
        //tabby
        var attributeString = NSMutableAttributedString(
           string: "4 interest free installments every month of ",
           attributes: regularAttributes)
        let instalment = finalPrice / 4
        let doubleStr = String(format: "%.2f", instalment)
        var attributeString1 = NSMutableAttributedString(
           string: "\(doubleStr) AED",
           attributes: boldAttributes)
//        var attributeString2 = NSMutableAttributedString(
//           string: " Valid for orders upto ",
//           attributes: regularAttributes)
//        var attributeString3 = NSMutableAttributedString(
//           string: "10000 AED",
//           attributes: boldAttributes)
         attributeString.append(attributeString1)
        
//        attributeString.append(attributeString2)
//        attributeString.append(attributeString3)
        lblTabbyDescription.attributedText = attributeString
        //postpay
        //MARK: START MHIOS-1293
        var attributeStringPostPay = NSMutableAttributedString(
           string: "As low as /month",
           attributes: regularAttributes)
        let instalment1 = finalPrice/6
        let doubleStr1 = String(format: "%.2f", instalment1)
        var attributeString4 = NSMutableAttributedString(
           string: "AED \(doubleStr1) ",
           attributes: boldAttributes)
//        var attributeString5 = NSMutableAttributedString(
//           string: " Valid for orders upto ",
//           attributes: regularAttributes)
//        var attributeString6 = NSMutableAttributedString(
//           string: "10000 AED",
//           attributes: boldAttributes)
        let insertionIndex = 10
        attributeStringPostPay.insert(attributeString4, at: insertionIndex)
        //attributeStringPostPay.append(attributeString4)
//        attributeStringPostPay.append(attributeString5)
//        attributeStringPostPay.append(attributeString6)
        //MARK: END MHIOS-1293
        
        lblPostpayDescription.attributedText = attributeStringPostPay
        btnTabbyInfo.addTarget(self, action: #selector(self.tabbyInfo(_:)), for: .touchUpInside)
        btnPostpayInfo.addTarget(self, action: #selector(self.postpayInfo(_:)), for: .touchUpInside)
        
        
        productQtyLeft = Int(productDetails.extension_attributes?.only_qty_left ?? "0")!
        productQty = Int(productDetails.extension_attributes?.available_stock ?? "0")!
        
        if productQty == 0{
            productQtyLbl.isHidden = false
            productQtyLbl.text = "Out of stock"
            productQtyLbl.textColor = AppColors.shared.Color_red_FF0000
            addToCartbutton!.backgroundColor = .gray
            addToCartbutton?.isEnabled = false
            
        } else {
            addToCartbutton!.backgroundColor = .black
            addToCartbutton?.isEnabled = true
            if 1 ... 10 ~= productQtyLeft {
                productQtyLbl.isHidden = false
                productQtyLbl.text = "Only \(productQtyLeft) Left!"
                productQtyLbl.textColor = AppColors.shared.Color_red_FF0000
            } else {
                productQtyLbl.isHidden = true
//                productQtyLbl.text = ""
//                productQtyLbl.textColor = AppColors.shared.Color_black_000000
            }
        }
//        productQtyLbl.isHidden = false
//        productQtyLbl.text = "Only \(productQty) Left!"
        
//        if productDetails.extension_attributes?.is_postpay_available ?? "0" == "0"{
//            productPostPay.isHidden = true
//            productInstalmentNotAvailable.isHidden = true
//        }
//        if productDetails.extension_attributes?.is_tabby_available ?? "0" == "0"{
//            productTabby.isHidden = true
//            productInstalmentNotAvailable.isHidden = true
//        }
//        if productDetails.extension_attributes?.is_postpay_available ?? "0" == "0" && productDetails.extension_attributes?.is_tabby_available ?? "0" == "0"{
//            productInstalmentNotAvailable.isHidden = false
//        }
        self.apiProductRecommended(id: productDetails.id ?? 0, url:productDetails.extension_attributes?.klevu_search_url ?? "", token:productDetails.extension_attributes?.klevu_api_key ?? ""){ responseData in
            DispatchQueue.main.async {
                print(responseData)
                if responseData.queryResults?.count ?? 0 > 0{
                    self.recommendedProductsArray = responseData.queryResults?[0].records ?? []
                    self.recommendedProductsCV.reloadData()
                }
                self.recommendedProductsView.isHidden = self.recommendedProductsArray.count == 0
            }
        }
        
        
    }
    
    func updateToCartButtonView(yVAlue:CGFloat,btnYVAlue:CGFloat)
    {
        //myView!.center = CGPointMake(screenSize!.width/2, yVAlue);
        myView!.frame.origin.y = yVAlue
        addToCartbutton!.center = CGPointMake(screenSize!.width/2, yVAlue);
        addToCartbutton!.addTarget(self, action:#selector(self.addToCart), for: .touchUpInside)
        addToCartbutton!.frame.origin.y = yVAlue + btnYVAlue
       
        
    }
    
    func addToCartButtonView(yVAlue:CGFloat)
    {
        myView = UIView(frame: CGRect(x: 0, y: yVAlue , width: screenSize!.width , height: 90))
        
        myView!.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        myView!.layer.borderColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        myView!.layer.borderWidth = 3
        self.navigationController?.view.addSubview(myView!)
    
        addToCartbutton = UIButton(frame: CGRect(x: 20, y: yVAlue+30, width: self.screenSize!.width - 40, height: 42 ))
        addToCartbutton!.layer.cornerRadius = 4
        addToCartbutton!.setTitle("ADD TO CART", for: .normal)
        addToCartbutton!.titleLabel?.font =  UIFont(name: AppFontLato.bold, size: 13)
        addToCartbutton!.addTarget(self, action:#selector(self.addToCart), for: .touchUpInside)
        
        //self.view.addSubview(button)
        //bottomView.backgroundColor = UIColor.white

        //self.view.addSubview(bottomView)
        self.navigationController?.view.addSubview(addToCartbutton!)
        //addToCartbutton!.center = view.center
        
        
    }
    
    func goToCartButtonViewUpdate(yVAlue:CGFloat)
    {
//        myView?.isHidden = true
//        addToCartbutton?.isHidden = true
        addToCartSuccess!.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 0)
        self.tabBarController?.tabBar.isHidden = true
        addToCartSuccess!.isHidden = false
        addToCartSuccess!.setDetails(product: self.productDetails)
        addToCartSuccess!.isHidden = false
        ///addToCartSuccess!.frame.origin.y = 0
        
        self.addToCartSuccess!.frame.origin.y = (self.view.frame.size.height/2)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                               animations: {
            //self.addToCartSuccess!.center.y = (self.view.frame.size.height/2)+self.navBarHeight!
            self.addToCartSuccess!.frame.origin.y = 0///(self.view.frame.size.height/2)+self.navBarHeight!
            self.addToCartSuccess!.layoutIfNeeded()
                },
                       completion: {_ in
            self.addToCartSuccess!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2031508692)
            
        })
        self.addToCartSuccess!.isHidden = false
        
        
        
    }
    
    
    
    
    
    func goToCartButtonView(yVAlue:CGFloat)
    {
        addToCartSuccess = AddToCartSuccess(frame: CGRect(x: 0, y: 0, width:(view.frame.size.width), height: view.frame.size.height))
        addToCartSuccess!.tabBarCont = self.tabBarController
        addToCartSuccess!.setDetails(product: self.productDetails)
       
        
        
        self.navigationController?.view.addSubview(addToCartSuccess!)
        //addToCartSuccess!.isHidden = true
        print("SANTHOSH Screen H IS : \(screenSize!.height)")
        print("SANTHOSH Screen H 2 IS : \(self.tabBarController!.tabBar.frame.size.height)")
        print("SANTHOSH STAUS BAR H IS : \(navBarHeight!)")
        print("SANTHOSH TAB BAR H IS : \(statusBarHeight!)")
        addToCartSuccess!.closeBtn.addTarget(self, action: #selector(self.closeBtnAction(_:)), for: .touchUpInside)
        
        //let delegate = AddToCartSuccess() //instance on MyView
        
        addToCartSuccess!.addToCartPopupsDelegate = self
        addToCartSuccess!.isHidden = true
//        goToCartbutton = UIButton(frame: CGRect(x: 20, y: yVAlue+30, width: self.screenSize!.width - 40, height: 42 ))
//        goToCartbutton!.layer.cornerRadius = 4
//        goToCartbutton!.backgroundColor = .systemPink
//        goToCartbutton!.setTitle("GO TO CART", for: .normal)
//        goToCartbutton!.titleLabel?.font =  UIFont(name: AppFontLato.bold, size: 13)
//        goToCartbutton!.addTarget(self, action:#selector(self.goToCart), for: .touchUpInside)
        
        //self.navigationController?.view.addSubview(goToCartbutton!)
        
        ///goToCartbutton!.isHidden = false
    }
    
    @objc func closeBtnAction(_ sender: UIButton) {
        print("SANTHOSH Screen H IS : WORKING FILNE")
    }
    
    // MARK: - BUTTON ACTIONS
    @IBAction func prdDetailsAction(_ sender: UIButton) {
        productDescriptionView.isHidden = !productDescriptionView.isHidden
        if(productDescriptionView.isHidden == true)
        {
            self.productDetailArrow.image = UIImage(named: "down_arrow")
        }
        else
        {
            self.productDetailArrow.image = UIImage(named: "up_arrow")
        }
    }
    @IBAction func prdSpecAction(_ sender: UIButton) {
        productSpecView.isHidden = !productSpecView.isHidden
        if(productSpecView.isHidden == true)
        {
            self.specifcationArrow.image = UIImage(named: "down_arrow")
        }
        else
        {
            self.specifcationArrow.image = UIImage(named: "up_arrow")
        }
    }
    @IBAction func prdCareAction(_ sender: UIButton) {
        productCareView.isHidden = !productCareView.isHidden
        if(productCareView.isHidden == true)
        {
            self.productCareArrow.image = UIImage(named: "down_arrow")
        }
        else
        {
            self.productCareArrow.image = UIImage(named: "up_arrow")
        }
    }
    @IBAction func prdDeliveryAction(_ sender: UIButton) {
        productDeliveryView.isHidden = !productDeliveryView.isHidden
        if(productDeliveryView.isHidden == true)
        {
            self.productDeliveryArrow.image = UIImage(named: "down_arrow")
        }
        else
        {
            self.productDeliveryArrow.image = UIImage(named: "up_arrow")
        }
    }
    
    @IBAction func prdInstalmentAction(_ sender: UIButton) {
        productInstalmentView.isHidden = !productInstalmentView.isHidden
        if(productInstalmentView.isHidden == true)
        {
            self.productinstallmentArrow.image = UIImage(named: "down_arrow")
        }
        else
        {
            self.productinstallmentArrow.image = UIImage(named: "up_arrow")
        }
    }
    @IBAction func addToCartAction(_ sender: UIButton) {
        /*if productQty == 0{
            self.toastView(toastMessage: "Product is out of stock!")
        }else{*/
        Analytics.logEvent("add_to_cart", parameters: [
            AnalyticsParameterItemName: self.productDetails.name ?? "",
            AnalyticsParameterItemID:self.productDetails.sku ?? "",
          AnalyticsParameterCurrency: "AED",
            AnalyticsParameterValue: self.productDetails.price ?? 0.0
            
        ])
        //MARK: START MHIOS-1064
        var properties = [String:Any]()
        properties["ItemName"] = "\(self.productDetails.name ?? "")"
        properties["ItemID"] = "\(self.productDetails.sku ?? "")"
        properties["currency"] = "AED"
        properties["price"] = "\(self.productDetails.price ?? 0.0)"
        SmartManager.shared.trackEvent(event: "add_to_cart", properties: properties)
        //MARK: END MHIOS-1064
   
        if UserData.shared.isLoggedIn
        {
            self.apiCreateCart(){ response in
                DispatchQueue.main.async {
                    self.apiCarts(){ response in
                        DispatchQueue.main.async {
                            print(response)
                            self.apiAddToCart(parameters: ["cartItem":["sku": self.productDetails.sku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
                                DispatchQueue.main.async {
                                    print(responseData)
                                    if(responseData.itemID == nil)
                                    {
                                        //MARK: START MHIOS-1285
                                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Product that you are trying to add is not available.","Screen" : self.className])
                                        //MARK: END MHIOS-1285
                                        self.toastView(toastMessage:"Product that you are trying to add is not available.",type: "error")
                                    }
                                    else
                                    {
                                        self.toastView(toastMessage: "Added to cart successfully!",type: "successr")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else
        {

        }
        
    }

    @IBAction func addToWishlistAction(_ sender: UIButton) {
        Analytics.logEvent("add_to_wishlist", parameters: [
            
            AnalyticsParameterItemID: self.productDetails.sku ?? "" ,
            
        ])
        //MARK: START MHIOS-1064
        SmartManager.shared.trackEvent(event: "add_to_wishlist", properties: ["product_id": "\(self.productDetails.sku)"])
        //MARK: END MHIOS-1064
        // Mark 1130
        AdjustAnalytics.shared.createEvent(type: .AddToWishList)
        AdjustAnalytics.shared.createParam(key: KeyConstants.productId, value: self.productDetails.sku ?? "")
        AdjustAnalytics.shared.track()
        // Mark 1130
        let klaviyo = KlaviyoSDK()
        
        let event = Event(name: .CustomEvent("Add To Wishlist"), properties: [
            "AddedItemPrice": "\(self.productDetails.price)" ,"AddedItemSku":self.productDetails.sku,"AddedItemQuantity":"1",
            "AddedItemProductName": self.productDetails.name
        ], value:Double(self.productDetails.price ?? 0))
        klaviyo.create(event: event)
        if UserData.shared.isLoggedIn
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let productInfo:String = "\(self.productDetails.id ?? 0)"
            
            
            //MARK START{MHIOS-1029}
            ///var result = appDelegate.wishList.contains(productInfo)
            let productSKU:String = "\(productDetails.sku ?? "" )"
            let modelToCheck = WishlistIDsModel(product_id: Int(productInfo) ?? 0, sku: productSKU)
            var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
            //MARK END{MHIOS-1029}
                if(result == false)
            {
                    
                        self.apiAddToWishlist(id: "\(self.productDetails.id ?? 0)"){ responseData in
                            DispatchQueue.main.async {
                                print(responseData)
                                if responseData{
                                    self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
                                }
                            }
                        }
                    }
            else
            {
                //MARK: START MHIOS-1285
                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "This Product is in your wishlist !","Screen" : self.className])
                //MARK: END MHIOS-1285
                self.toastView(toastMessage: "This Product is in your wishlist !",type: "error")
            }
        }
        else
        {
            self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
        }
        
            
    }
    
    
    
   

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var width = UIScreen.main.bounds.width/2
        width = width - 9
        let diff = width-178.5
        
        if collectionView == offerProductCombCV{
//            let width = indexPath.item % 2 == 0 ? (offerProductCombCV.frame.width/2) - 40 : 40
//            return CGSize(width: width, height: 100)//offerProductCombCV.frame.height
            return CGSize(width:width, height: width+72)
        }else{
            //return CGSize(width: 200, height: 300)//recommendedProductsCV.frame.height
            
            return CGSize(width:width, height:  width+72)
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == offerProductCombCV{
            return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        }else{
            return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        if collectionView == offerProductCombCV{
            return 0
        }else{
            return 6
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        if collectionView == offerProductCombCV{
            return 0
        }else{
            return 6
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == offerProductCombCV{
            return offerProductImagesArray.count
        }else{
            return recommendedProductsArray.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == offerProductCombCV
        {
            if indexPath.item % 2 == 0 {
                let cellData = offerProductImagesArray[indexPath.item]
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComboProductsCVC_id", for: indexPath) as? ComboProductsCVC else { return UICollectionViewCell() }
                //        cell.productImage.image = UIImage(named: cellData)
                return cell
            }else{
                let cellData = offerProductImagesArray[indexPath.item]
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComboProductsPlusCVC_id", for: indexPath) as? ComboProductsPlusCVC else { return UICollectionViewCell() }
                //        cell.productImage.image = UIImage(named: cellData)
                return cell
            }
        }
        else
        {
            let cellData = recommendedProductsArray[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
            cell.lblName.font = AppFonts.LatoFont.Regular(13)
            cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
            cell.tag = indexPath.row
            //cell.file = cellData.image
            cell.lblName.text = cellData.name
            let pId = (cellData.id! as String)
            //MARK START{MHIOS-1029}
            let sku = (cellData.sku! as String)
            cell.productId = Int(pId)!
            cell.sku = sku
            //MARK END{MHIOS-1029}
//            let price = Double(cellData.price ?? "0")
//            cell.lblOfferPrice.text = String(format: "%.2f", price!) + " AED"
//            cell.lblActualPrice.isHidden = true
//            cell.pageControl.isHidden = true
            
            //Mark MHIOS-1161
            
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
            //Mark MHIOS-1161
            
            
            
            ///cell.productId = "\(cellData.id)"
//            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(cellData.price ?? "") AED")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            
//            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(cellData.price ?? "") AED")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            
            let imageMain = cellData.imageUrl!.replacingOccurrences(of: "/needtochange", with: "", options: NSString.CompareOptions.literal, range:nil)
            print("SANTHOSH IMAGE URL : ")
            print(imageMain)
            cell.imageArrayRec = imageMain
            cell.file = imageMain//cellData.image
            cell.setImages(sliderImages: [])
//           DispatchQueue.main.async {
//                 let flowLayout = UICollectionViewFlowLayout()
//                 flowLayout.scrollDirection = .horizontal
//               flowLayout.itemSize = CGSize(width: 128, height: 128)
//                 cell.collectionImages.collectionViewLayout = flowLayout
//               cell.collectionImages.reloadData()
//           }

            
//            DispatchQueue.main.async {
//                let flowLayout = UICollectionViewFlowLayout()
//                flowLayout.scrollDirection = .horizontal
//                flowLayout.itemSize = CGSize(width: 128, height: 128)
//                cell.collectionImages.collectionViewLayout = flowLayout
//                cell.collectionImages.reloadData()
//            }
            
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
            ///cell.lblActualPrice.attributedText = attributeString
            cell.productDelegate = self
            
            
            var specialPrice = ""
            var specialToDate = ""
            var specialFromDate = ""
            for item in cellData.customAttributes ?? [] {
                switch item.value {
                case .string(let stringValue):
                    print(item.attribute_code)
                    print("String value: \(stringValue)")
                    
                    if item.attribute_code == "special_price"{
                        ///specialPrice = "\(stringValue ?? "")"
                        print("SANTHOSH TS value: \(stringValue)")
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
           // let actualPriceDouble = Double(cellData.price ?? "0.0") ?? 0
          //  let formatedActualPrice = formatNumberToThousandsDecimal(number: actualPriceDouble)

            
//            let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
//            if specialPriceFlag
//            {
//                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatedActualPrice + " AED")")
//                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
//
//                cell.lblActualPrice.attributedText = attributeString
//                ///cell.lblOfferPrice.text = "\(product.specialPrice ?? 0) AED"
//                cell.lblActualPrice.isHidden = false
//                cell.lblOfferPrice.isHidden = false
//
//            }
//            else
//            {
//                cell.lblOfferPrice.isHidden = true
//                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatedActualPrice + " AED")")
//                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))
//
//                cell.lblActualPrice.attributedText = attributeString
//                cell.lblActualPrice.isHidden = false
//            }
            
            
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == offerProductCombCV{
            print("Offer")

        }else{
            print("Recomented")
//            let nextVC = AppController.shared.productDetailsImages
//            nextVC.productId = "\(recommendedProductsArray[indexPath.item].id ?? "")"
//            self.navigation?.pushViewController(nextVC, animated: true)
            
//            let nextVC = AppController.shared.productDetailsImages
//            nextVC.productId = "\(recommendedProductsArray[indexPath.item].id)"
//            nextVC.wishListId = "\(recommendedProductsArray[indexPath.item].id)"
//            self.navigationController?.pushViewController(nextVC, animated: true)
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

    func openDetail(tag:Int,sectionSelected:Int)
    {
        let nextVC = AppController.shared.productDetailsImages
        nextVC.productId = "\(self.recommendedProductsArray[tag].sku ?? "")"
        nextVC.wishListId = "\(self.recommendedProductsArray[tag].id)"
        nextVC.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
    
    @objc func addToCart()
    {
        Analytics.logEvent("add_to_cart", parameters: [
          "name": self.productDetails.name ?? "",
          "itemId":self.productDetails.sku ?? "",
          "value": "\(self.productDetails.price ?? 0)",
          "currency": "AED"
        ])
        //MARK: START MHIOS-1064
        var properties = [String:Any]()
        properties["ItemName"] = "\(self.productDetails.name ?? "")"
        properties["ItemID"] = "\(self.productDetails.sku ?? "")"
        properties["currency"] = "AED"
        properties["price"] = "\(self.productDetails.price ?? 0.0)"
        SmartManager.shared.trackEvent(event: "add_to_cart", properties: properties)
        //MARK: END MHIOS-1064
        // Mark MHIOS-1130
        let event1 = ADJEvent(eventToken: AdjustEventType.AddtoCart.rawValue)
        Adjust.trackEvent(event1)
        // Mark MHIOS-1130
        
        let klaviyo = KlaviyoSDK()
        let event = Event(name: .CustomEvent("Added To Cart"), properties: [
            "AddedItemPrice": "\(self.productDetails.price)" ,"AddedItemSku":self.productDetails.sku,"AddedItemQuantity":"1",
            "AddedItemProductName": [self.productDetails.name]
        ], value:Double(self.productDetails.price ?? 0))
        klaviyo.create(event: event)
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Add To Cart with product sku: \(self.productDetails.sku)")
        //MARK: END MHIOS-1225
            addToCartPopupDelegate?.cartPopup(data: "APP NAME IS SANTHOSH")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if UserData.shared.isLoggedIn
                {
                        self.apiCreateCart()
                        { response in
                            DispatchQueue.main.async {
                                self.apiCarts(){ response in
                                    DispatchQueue.main.async {
                                        print(response)
                                        self.apiAddToCart(parameters: ["cartItem":["sku": self.productDetails?.sku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
                                            DispatchQueue.main.async { [self] in
                                                print(responseData)
                                                if(responseData.itemID == nil)
                                                {
                                                    //MARK: START MHIOS-1285
                                                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Product that you are trying to add is not available.","Screen" : self.className])
                                                    //MARK: END MHIOS-1285
                                                    self.toastView(toastMessage:"Product that you are trying to add is not available.",type: "error")
                                                }
                                                else
                                                {
    //                                                self.myView?.isHidden = true
    //                                                self.addToCartbutton?.isHidden = true
                                                    ///UserData.shared.goTocartStatus = true
                                                    print("SANTHOSH ADD TO CART STATUS 2 : \(UserData.shared.goTocartStatus)")
                                                    
                                                    self.getCartCount()
                                                    goToCartButtonViewUpdate(yVAlue: (self.screenSize!.height-self.navTabBarHeight!)-300)
                                                    
                                                    //self.toastView(toastMessage: "Added to cart successfully!")
    //                                                let controller = AppController.shared.addCartSucces
    //                                                controller.product = self.productDetails
    //                                                self.addChild(controller)
    //                                                //controller.view.frame =  CGRect(x: 30, y: 50 , width: self.screenSize!.width , height: 200)//self.view.bounds
    //                                                controller.view = UIView(frame: CGRect(x: 0, y: 100 , width: self.screenSize!.width , height: 200))
    //                                                self.view.addSubview((controller.view)!)
    //                                                controller.didMove(toParent: self)
                                                    
                                                    //var controller = AppController.shared.addCartSucces
//                                                    self.controller.product = self.productDetails
//                                                    self.navigationController?.addChild(self.controller)
//                                                    let screenSize: CGRect = UIScreen.main.bounds
//                                                    self.controller.view.frame = self.view.bounds
//                                                    //UIApplication.shared.keyWindow!.addSubview(self.controller.view)
//                                                    self.controller.view.addSubview(self.controller.view)
//                                                    self.controller.didMove(toParent: self.navigationController)
//                                                    self.goToCartbutton!.isHidden = false
                                                    
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        if(appDelegate.guestCartId == "")
                        {
                            self.apiCreateGuestCart()
                            { response in

                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.guestCartId = response
                                DispatchQueue.main.async {
                                    self.apiGuestCarts{ response in
                                        DispatchQueue.main.async {
                                            print(response)

                                            self.apiAddToGuestCart(parameters: ["cartItem":["sku": self.productDetails?.sku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
                                                DispatchQueue.main.async { [self] in
                                                    print(responseData)
                                                    if(responseData.itemID == nil)
                                                    {
                                                        //MARK: START MHIOS-1285
                                                        SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Product that you are trying to add is not available.","Screen" : self.className])
                                                        //MARK: END MHIOS-1285
                                                        self.toastView(toastMessage:"Product that you are trying to add is not available.", type: "error")
                                                    }
                                                    else
                                                    {
                                                        self.getCartCount()
                                                        goToCartButtonViewUpdate(yVAlue: (self.screenSize!.height-self.navTabBarHeight!)-300)
                                                        ////UserData.shared.goTocartStatus = true
//                                                        //self.toastView(toastMessage: "Added to cart successfully!")
//                                                        let controller = AppController.shared.addCartSucces
//                                                        controller.product = self.productDetails
//                                                        self.navigationController?.addChild(controller)
//                                                        let screenSize: CGRect = UIScreen.main.bounds
//                                                        controller.view.frame = self.view.bounds
//                                                        //UIApplication.shared.keyWindow!.addSubview(controller.view)
//                                                        self.controller.view.addSubview(self.controller.view)
//                                                        self.controller.didMove(toParent: self)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            self.apiGuestCarts{ response in
                                DispatchQueue.main.async {
                                    print(response)
                                    self.apiAddToGuestCart(parameters: ["cartItem":["sku": self.productDetails?.sku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
                                        DispatchQueue.main.async { [self] in
                                            print(responseData)
                                            if(responseData.itemID == nil)
                                            {
                                                //MARK: START MHIOS-1285
                                                SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Product that you are trying to add is not available.","Screen" : self.className])
                                                //MARK: END MHIOS-1285
                                                self.toastView(toastMessage:"Product that you are trying to add is not available.",type: "error")
                                            }
                                            else
                                            {
                                                self.getCartCount()
                                                goToCartButtonViewUpdate(yVAlue: (self.screenSize!.height-self.navTabBarHeight!)-300)
                                                ///UserData.shared.goTocartStatus = true
                                               // self.toastView(toastMessage: "Added to cart successfully!")
//                                                let controller = AppController.shared.addCartSucces
//                                                controller.product = self.productDetails
//                                                self.navigationController?.addChild(controller)
//                                                controller.view.frame = self.view.bounds
//                                                UIApplication.shared.keyWindow!.addSubview(controller.view)
//                                                controller.didMove(toParent: self)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    //}
            
        }
        ///UserData.shared.goTocartStatus = false
//        self.myView?.isHidden = true
//        self.addToCartbutton?.isHidden = true
       /* print("SANTHOSH ADD TO CART ")
        self.toastViews(toastMessage: "Login Successful Couldn't able to send reset link to your email!. please try again! Login Successful Couldn't able to ",type: "warning")*///success,error,warning
        
        
             
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
                        self.apiGuestCarts(){ response in
                            appDelegate.storeID = response.storeID ?? 0
                            DispatchQueue.main.async {
                                print("SANTHOSH apiGuestCarts : OK")
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
                self.guestCartId =  appDelegate.guestCartId
                self.apiGuestCarts(){ response in
                    appDelegate.storeID = response.storeID ?? 0
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
    //MARK: START MHIOS-1182
    @objc func tabbyInfo(_ sender: UIButton) {
        let instalment = Double (finalPrice )
        webView?.isHidden = false
        myView?.isHidden = true
        addToCartbutton?.isHidden = true
        webView?.urlString = "https://checkout.tabby.ai/promos/product-page/installments/en/?price=\(instalment)&currency=AED"
        webView?.ScreenTitle = "Installments with Tabby"
        self.webView!.frame.origin.y = (self.view.frame.size.height/2)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                               animations: {
            self.webView?.frame.origin.y = 0
            self.webView?.layoutIfNeeded()
                },
            completion: {_ in
            self.webView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.webView?.setUpUI()
        })

    }
    //MARK: END MHIOS-1182
    //MARK: START MHIOS-1182
    @objc func postpayInfo(_ sender: UIButton) {

        let instalment = Double ((finalPrice))
      
        self.tabBarController?.tabBar.isHidden = true
        webView?.isHidden = false
        myView?.isHidden = true
        addToCartbutton?.isHidden = true
        webView?.urlString = AppInfo.shared.postpayCMSUrl + "\(instalment)"
        webView?.ScreenTitle = "Installments with Postpay"
        self.webView!.frame.origin.y = (self.view.frame.size.height/2)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn],
                               animations: {
            self.webView?.frame.origin.y = 0
            self.webView?.layoutIfNeeded()
                },
            completion: {_ in
            self.webView!.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.webView?.setUpUI()
        })
        
    }
    //MARK: END MHIOS-1182
}
extension ProductDetailsVC: UISheetPresentationControllerDelegate {
    @available(iOS 15.0, *)
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        self.detailView.isHidden = !self.detailView.isHidden
    }
}


extension NSAttributedString {
    convenience init(htmlString html: String, font: UIFont? = nil) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let data = html.data(using: .utf8, allowLossyConversion: true) else {
            throw NSError(domain: "InvalidData", code: 0, userInfo: nil)
        }

        do {
            var attr: NSMutableAttributedString

            if let font = font {
                attr = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)

                let fontSize = font.pointSize
                let range = NSRange(location: 0, length: attr.length)

                attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
                    if let htmlFont = attrib as? UIFont {
                       let fontFamily = font.familyName
                        let traits = htmlFont.fontDescriptor.symbolicTraits
                        var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)

                        if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                            descrip = descrip.withSymbolicTraits(.traitBold)!
                        }

                        if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                            descrip = descrip.withSymbolicTraits(.traitItalic)!
                        }

                        attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize), range: range)
                    }
                }
            } else {
                attr = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            }

            self.init(attributedString: attr)
        } catch {
            throw error
        }
    }
}

extension ProductDetailsVC: Draggable{
    func draggableView() -> UIScrollView? {
        return scrollView
    }
}

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 3) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -3), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
extension ProductDetailsVC : UINavigationControllerDelegate {
     
      

}
