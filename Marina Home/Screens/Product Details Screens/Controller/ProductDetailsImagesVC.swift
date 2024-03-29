//
//  ProductDetailsImagesVC.swift
//  Marina Home
//
//  Created by Codilar on 26/04/23.

//////MARK START{MHIOS-1248}
///Added NSAppTransportSecurity in Info.plist
/// added three files in roott folder for the Image and video slider (MediaSlideshow and MediaSlideshowKingfisher and MediaSlideshow.podspec)
/// change the slider view class MediaSlideshow
/////MARK END{MHIOS-1248}

import UIKit
import PageControls
import SDWebImage
import UBottomSheet
import WebKit
import QuickLook
import AVFoundation
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import KlaviyoSwift
import Kingfisher
import Adjust
//MARK START{MHIOS-1248}
import MediaSlideshow
//MARK END{MHIOS-1248}
class ProductDetailsImagesVC: AppUIViewController,AddToCartPopupDelegate,
//MARK START{MHIOS-1248}
MediaSlideshowDelegate{
//MARK END{MHIOS-1248}
    func cartPopup(data: String) {
        print("IS IT OK : ")
        print(data)
    }
    
    var previewController = QLPreviewController()
    
    var downloadedFilePath: URL?
    var downloadURL:String = ""
    private var wkWebView: WKWebView!
    
    var sheetCoordinator: UBottomSheetCoordinator!
    var backView: PassThroughView?
    
    ///var sheetVC = ProductDetailsNewVC()
    var useNavController = false
    var dataSource: UBottomSheetCoordinatorDataSource?
    
    @IBOutlet var viewSuccessPopUp: UIView!
    @IBOutlet var btnWishlist: UIButton!
    
    //MARK START{MHIOS-1248}
    //@IBOutlet weak var productImagesCV: UICollectionView!
    @IBOutlet weak var productImageHeight: NSLayoutConstraint!
    @IBOutlet weak var slideshow: MediaSlideshow!
        var sliderImages = [MediaSource]()
    //MARK END{MHIOS-1248}
    @IBOutlet weak var threeDeeMainView: UIView!
    @IBOutlet weak var threeDeeBottomPadding: NSLayoutConstraint!
    var product:ProductDetailsModel?
    let pageControl = PillPageControl()
    var productImagesArray:[Media_gallery_entries_2] = []
    @IBOutlet var btnBack: UIButton!
    var productId = ""
    //MARK START{MHIOS-1029}
    var sku = ""
    //MARK END{MHIOS-1029}
    var popUp:UINavigationController?
    var wishListId = ""
    var screenSize:CGRect?
    var statusBarHeight:CGFloat?
    var navBarHeight:CGFloat?
    
    var productQty = "0"
    var guestCartId = ""
  
        //MARK START{MHIOS-1248}
    //@IBOutlet weak var paginationViewMain: UIView!
        //MARK END{MHIOS-1248}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mark MHIOS-1130
        let event1 = ADJEvent(eventToken: AdjustEventType.ViewProduct.rawValue)
        Adjust.trackEvent(event1)
        // Mark MHIOS-1130
        print("SANTHOSH ")
        UserData.shared.previousProductId = productId
        //MARK START{MHIOS-1248}
//        productImagesCV.delegate = self
//        productImagesCV.dataSource = self
//        ProductImagesCVC.register(for: productImagesCV)
        //MARK END{MHIOS-1248}
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.guestCartId = appDelegate.guestCartId
        screenSize = UIScreen.main.bounds
        let screenHeight = screenSize!.height
        let width = screenSize!.width//(screenHeight/10)*6
        let height = screenSize!.height//(screenHeight/10)*6
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        navBarHeight = self.navigationController!.navigationBar.frame.size.height
        productImageHeight.constant = width
        print("statusBarHeight IS \(statusBarHeight)")
        print("navBarHeight IS \(navBarHeight)")
        threeDeeBottomPadding.constant = width-80
        threeDeeMainView.isHidden = true
        
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                let token = Messaging.messaging().fcmToken
                print("SANTHOSH FCM TOKEN : ",token)
                UserDefaults.standard.set(token, forKey: "fcm_token")
                //self.navigationController?.view.makeToast(token!, duration: 3.0, position: .bottom)
            }
        }
        
        self.tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
        {
            
        }
        
        //        if self.tabBarController?.tabBar.isHidden == true
        //        {
        //            print("SANTHOSH PRODUCT DETAILS IMAGE PAGE TRUE ")
        //            self.tabBarController?.tabBar.isHidden = false
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
        //            {
        //
        //            }
        //        }
        //        else
        //        {
        //            print("SANTHOSH PRODUCT DETAILS IMAGE PAGE FALSE ")
        //            self.tabBarController?.tabBar.isHidden = false
        //            self.navigationController?.popViewController(animated: true)
        //        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationMoving(notification:)), name: Notification.Name("NotificationIdentifierMoving"), object: nil)
        
        //MARK START{MHIOS-1271}
        if let navigationController = self.navigationController {
            var viewControllers = navigationController.viewControllers
            // Check if Class A exists in the navigation stack
            if let index = viewControllers.firstIndex(where: { $0 is ProductDetailsNewVC }) {
                // Remove Class A from the viewControllers array
                viewControllers.remove(at: index)
                // Set the updated viewControllers array back to the navigation stack
                navigationController.setViewControllers(viewControllers, animated: false)
            }
        }
        //MARK START{MHIOS-1271}
        
        ///customizePageControl()
        ///productId = "jai1083gsfhg"
        
        print("SANTHOSH productID FOR API IS : \(productId)")
        self.apiProductDetails(productID: productId){ response in
            DispatchQueue.main.async {
                
                if response.id == nil
                {
                    
                    //MARK: START MHIOS-1285
                    SmartManager.shared.trackEvent(event: "User_Alert_Event", properties: ["messege": "Product details are not available at this time. Please try after some time","Screen" : self.className])
                    //MARK: END MHIOS-1285
                    self.toastView(toastMessage: "Product details are not available at this time. Please try after some time",type: "error")
                    //MARK START{MHIOS-1271}
//                    self.navigationController?.presentedViewController?.dismiss(animated: false)
//                    self.navigationController?.popViewController(animated: false)
                    if let navigationController = self.navigationController {
                        navigationController.popToRootViewController(animated: true)
                    }
                    //MARK END{MHIOS-1271}
                }
                else
                {
                    print("SANTHOSH RESP AVAILABLE")
                
                
                self.product = response
                self.presentModal(details: response)
                self.productImagesArray = response.media_gallery_entries ?? []
                
                ///cell.imageArray = product.media_gallery_entries!
                    //MARK START{MHIOS-1248}
                    self.sliderImages.removeAll()
                    let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
                    let animatedGif = UIImage.sd_image(withGIFData: imageData)
                    let placeholderImage = UIImage(named: "failure_image.png")
                    let options: KingfisherOptionsInfo = [ // Set a fade-in transition with a duration
                        .onFailureImage(placeholderImage) // Set a custom target cache
                    ]
                        
                   
                    
                    var temp:[Media_gallery_entries_2] = []
                    for p in self.productImagesArray
                    {
                        if(p.media_type == "external-video")
                        {
                            //MARK START{MHIOS-1038}
                            for obj in self.product?.custom_attributes ?? []
                            {
                                //MARK START{MHIOS-1322}
                                if(obj.attribute_code == "mp4_url")
                                {
                                    let videoURL = obj.value ?? ""
                                    if videoURL != ""
                                    {
                                        let videoSource1 = AVSource(
                                            url: URL(string: "\(videoURL)")!,
                                        onAppear: .play)
                                        self.sliderImages.append(videoSource1)
                                        break
                                    }
                                }
                                //MARK END{MHIOS-1322}
                            }
                            //MARK START{MHIOS-1038}
                        }
                        else
                        {
                            temp.append(p)
                            let imageUrl = "\(AppInfo.shared.gumletProductImageURL)\(p.file ?? "")"
                            print("SANTHOSH PDP IMAGE : \(imageUrl)")
                            self.sliderImages.append(KingfisherSource(urlString: "\(imageUrl)",placeholder:placeholderImage,options: options)!)
                        }
                    }
                    //self.productImagesArray = temp
                        
                    if self.sliderImages.count == 0
                    {
                        self.sliderImages.append(KingfisherSource(urlString: "no_image",placeholder:placeholderImage,options: options)!)
                    }
    //                else
    //                {
    //                    //"https://mhstaging.gumlet.io/1695017630394_EAC1002_1.jpeg"
    //                    self.sliderImages.append(KingfisherSource(urlString: "no_image",placeholder:placeholderImage,options: options)!)
    //                    //self.productImagesArray = temp
    //                }
                    //MARK END{MHIOS-1248}
                
                    //MARK START{MHIOS-1029}
                    let product_id = self.product?.id ?? 0
                    let sku = self.product?.sku ?? ""
                    self.productQty = self.product?.extension_attributes?.only_qty_left ?? "0"
                    //self.productQty = self.product?.extension_attributes[0].only_qty_left
                    self.productId = String(product_id)
                    self.sku = String(sku)
                    //MARK END{MHIOS-1029}
                
                ////////RECENTLY VIEWD ITEM ID SAVE LOCALY
                
                let productID = Int(self.productId)
                print("SANTHOSH ARRAY productID IS : \(productID)")
                var tempROPArray = [Int]()
                tempROPArray = UserData.shared.recentOpenProduct
                if tempROPArray.contains(productID!) {
                    print("SANTHOSH ARRAY productID IS yes")
                }
                else
                {
                    tempROPArray.append(productID!)
                    print("SANTHOSH ARRAY OPEN PDP PAGE A \(tempROPArray.count)")
                    if 5 < tempROPArray.count
                    {
                        tempROPArray = Array(tempROPArray.dropFirst(tempROPArray.count-5))
                    }
                    
                    UserData.shared.recentOpenProduct = tempROPArray
                }
                print("SANTHOSH ARRAY OPEN PDP PAGE A \(UserData.shared.recentOpenProduct)")
                
                var threedyImageUrlStatus = false
                for obj in self.product?.custom_attributes ?? []
                {
                    if(obj.attribute_code == "threedy_image_url")
                    {
                        self.downloadURL = obj.value ?? ""
                        print("SANTHOSH APPPPP threedy_image_url : \(self.downloadURL)")
                        if self.downloadURL != ""
                        {
                            threedyImageUrlStatus = true
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                    }
                }
                
                if threedyImageUrlStatus
                {
                    self.threeDeeMainView.isHidden = false
                }
                else
                {
                    self.threeDeeMainView.isHidden = true
                }
                
                print("\(product_id)")
                    //MARK START{MHIOS-1029}
                    let modelToCheck = WishlistIDsModel(product_id: Int(product_id) ?? 0, sku: sku)
                    var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
                        print("SANTHOSH THIS PRODUCT WISHLIST ARRYA IS \(UserData.shared.wishListIdArray) ")
                    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if(result)//\(self.wishListId)
                    {
                        print("SANTHOSH THIS PRODUCT IS LIKED")
                        self.btnWishlist.setImage(UIImage(named: "liked"), for: .normal)
                    }
                    else
                    {
                        print("SANTHOSH THIS PRODUCT IS NOT LIKED ")
                        self.btnWishlist.isEnabled = true
                        self.btnWishlist.setImage(UIImage(named: "like_button"), for: .normal)
                    }
                    //MARK END{MHIOS-1029}

                     self.imageSlideStart()
                    //MARK END{MHIOS-1248}
            }
            }
        }
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Product Details Images Screen")
        //MARK: END MHIOS-1225
    }
    
   /* override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifierMoving"), object: nil)
    }*/
    
    //MARK START{MHIOS-1248}
    func imageSlideStart()
    {
        ///slideshow.slideshowInterval = 4.0
        //MARK START{MHIOS-1037}
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 20))
        //MARK END{MHIOS-1037}
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        //slideshow.padd
        //slideshow.
        //slideshow.pageIndicator?.view.isHidden = true
        //slideshow.pageIndicator = UIPageControl.init()//withSlideshowColors()
        
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
        pageIndicator.pageIndicatorTintColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
//        pageIndicator.fs_width = 4
//        pageIndicator.fs_height = 4
        
        pageIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        slideshow.pageIndicator = pageIndicator
        //slideshow.sd_internalSetImage(with: <#T##URL?#>, placeholderImage: <#T##UIImage?#>, context: <#T##[SDWebImageContextOption : Any]?#>, setImageBlock: <#T##SDSetImageBlock?##SDSetImageBlock?##(UIImage?, Data?, SDImageCacheType, URL?) -> Void#>, progress: <#T##SDImageLoaderProgressBlock?##SDImageLoaderProgressBlock?##(Int, Int, URL?) -> Void#>)
        /////curruntPageCounterView.text = String(1)

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        //slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        print("SANTHOAH PAGE COUNT : \(slideshow.currentPage)")
        print("SANTHOAH PAGE COUNT Changed : \(slideshow.currentPageChanged)")

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
//        let sliderImagesnew = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
//
//        let videoSource1 = AVSource(
//            url: URL(string: "https://video.gumlet.io/6215e23b6fe8af70032f517a/65c35c32837b5d2b626d20ba/download.mp4")!,
//            onAppear: .play)
//        slideshow.setMediaSources([videoSource1]+sliderImagesnew)
        
        slideshow.setMediaSources(sliderImages)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        ///totalPageCounterView.text = String(sliderImages.count)
    }
    
//    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("SANTHOAH PAGE COUNT A : \(page)")
//        ////curruntPageCounterView.text = String(page+1)
//    }
    
    @objc func didTap() {
        ///UserDefaults().set(false, forKey: "video_status")
        //MARK START{MHIOS-1271}
        let vc = AppController.shared.productDetailsNew
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        vc.pageSelected = {[weak self] (page: Int) in
        }
        vc.initialPage = slideshow.currentPage
        vc.inputs = sliderImages
        self.navigationController?.pushViewController(vc, animated: true)
        //MARK END{MHIOS-1271}
    }
   
    @objc func methodOfReceivedNotificationMoving(notification: Notification) {
        let status = notification.userInfo?["moving"] as? Bool
        //pageControl.isHidden = true
       // self.btnBack.isEnabled = false
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        print("SANTHOSH WORKING FINE : ")
        let status = notification.userInfo?["status"] as? Bool
        if status!
        {
            print("SANTHOSH WORKING FINE : DOWN")
            //pageControl.isHidden = false
            //self.btnBack.isEnabled = false
        }
        else
        {
            print("SANTHOSH WORKING FINE : UP")
            //pageControl.isHidden = true
            //self.btnBack.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        print(productId)
        
        self.tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
        {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
        {
            
        }
        
    }
    
    
    
    @IBAction func backDismissAction(_ sender: UIButton) {
        //let seconds = 0.4
        //DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            
            self.navigationController?.presentedViewController?.dismiss(animated: false)
            self.navigationController?.popViewController(animated: false)
        //}
    }
    
    
    func presentModal(details:ProductDetailsModel) {
        let popUp = AppController.shared.productDetails
        //let popUp = AppController.shared.productDetailsNew
        popUp.hidesBottomBarWhenPushed = true
        popUp.productDetails = details
        
        popUp.modalTransitionStyle = .crossDissolve
        popUp.modalPresentationStyle = .custom
        
        guard sheetCoordinator == nil else {return}
        sheetCoordinator = UBottomSheetCoordinator(parent: self)
        if dataSource != nil {
            sheetCoordinator.dataSource = dataSource!
        }
        
        sheetCoordinator.delegate = self
        sheetCoordinator.dataSource = self
        popUp.sheetCoordinator = sheetCoordinator
        popUp.dataSource = MyDataSource()
        sheetCoordinator.addSheet(popUp, to: self, didContainerCreate: { container in
            let f = self.view.frame
            let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
            container.roundCorners(corners: [.topLeft, .topRight], radius: 0, rect: rect)
        })
        
        sheetCoordinator.setCornerRadius(100)
        
        ///addToCartButtonView()
        
    }
    
    private func addBackDimmingBackView(below container: UIView){
        backView = PassThroughView()
        self.view.insertSubview(backView!, belowSubview: container)
        backView!.translatesAutoresizingMaskIntoConstraints = false
        backView!.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backView!.bottomAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        backView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func addToCartButtonView()
    {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        let bottomView:UIView = UIView(frame: CGRect(x: 0, y:  CGFloat((Int(self.screenSize!.height) - Int(statusBarHeight!)-100)), width: self.screenSize!.width, height: 100))
        
        //let button.frame = CGRect(x:0,y:0,width:view.frame.width,height:50)
        
        //let button:UIButton = UIButton(frame: CGRect(x:0,y:0, width: self.screenSize!.width - 40, height: 42))
        let button:UIButton = UIButton(frame: CGRect(x: 20, y:  CGFloat((Int(self.screenSize!.height) - Int(statusBarHeight!))-85), width: self.screenSize!.width - 40, height: 42))
        button.layer.cornerRadius = 4
        button.backgroundColor = .black
        button.setTitle("ADD TO CART", for: .normal)
        button.titleLabel?.font =  UIFont(name: AppFontLato.bold, size: 13)
        button.addTarget(self, action:#selector(self.addToCart), for: .touchUpInside)
        //self.view.addSubview(button)
        bottomView.backgroundColor = UIColor.white
        
        self.view.addSubview(bottomView)
        self.view.addSubview(button)
        
        //button.center = view.center
        
    }
    
    @IBAction func threeDeeAction(_ sender: Any) {
        for obj in self.product?.custom_attributes ?? []
        {
            if(obj.attribute_code == "threedy_image_url")
            {
                self.downloadURL = obj.value ?? ""
            }
        }
        let vc = AppController.shared.threeDee
        vc.downloadURL = self.downloadURL
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let vc = AppController.shared.web
        //        vc.hidesBottomBarWhenPushed = true
        //        vc.urlString = self.downloadURL
        //        vc.ScreenTitle = "PRODUCT 3D VIEW"
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addToCart()
    {
        /*if productQty == "0"{
         self.toastView(toastMessage: "Product is out of stock!")
         }
         else
         {*/
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if UserData.shared.isLoggedIn
        {
            self.apiCreateCart()
            { response in
                DispatchQueue.main.async {
                    self.apiCarts(){ response in
                        DispatchQueue.main.async {
                            print(response)
                            self.apiAddToCart(parameters: ["cartItem":["sku": self.product?.sku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
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
                                        self.getCartCount()
                                        //self.toastView(toastMessage: "Added to cart successfully!")
                                        let controller = AppController.shared.addCartSucces
                                        controller.product = self.product
                                        self.addChild(controller)
                                        controller.view.frame = self.view.bounds
                                        self.view.addSubview((controller.view)!)
                                        controller.didMove(toParent: self)
                                        
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
                                
                                self.apiAddToGuestCart(parameters: ["cartItem":["sku": self.product?.sku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
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
                                            self.getCartCount()
                                            //self.toastView(toastMessage: "Added to cart successfully!")
                                            let controller = AppController.shared.addCartSucces
                                            controller.product = self.product
                                            self.addChild(controller)
                                            controller.view.frame = self.view.bounds
                                            self.view.addSubview((controller.view)!)
                                            controller.didMove(toParent: self)
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
                        self.apiAddToGuestCart(parameters: ["cartItem":["sku": self.product?.sku ?? "", "qty": 1, "quote_id": "\(response.id)"]]){ responseData in
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
                                    self.getCartCount()
                                    // self.toastView(toastMessage: "Added to cart successfully!")
                                    let controller = AppController.shared.addCartSucces
                                    controller.product = self.product
                                    self.addChild(controller)
                                    controller.view.frame = self.view.bounds
                                    self.view.addSubview((controller.view)!)
                                    controller.didMove(toParent: self)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // }
        
        
    }
    
        //MARK START{MHIOS-1248}
//    func customizePageControl(){
//        let width = 4
//        let height = 4
//        let indicatorPadding = 5
//        pageControl.indicatorPadding = CGFloat(indicatorPadding)
//        pageControl.pillSize = CGSize(width: width, height: height)
//        print("SCREEN WIDTH : ",self.screenSize?.width)
//        let faramWidth = (width*productImagesArray.count)+(indicatorPadding*(productImagesArray.count-1))
//        print("FRAM WIDTH : ",faramWidth)
//        let faramX = (Int(self.screenSize!.width)-faramWidth)/2
//        print("FRAM X : ",faramX)
//        statusBarHeight = UIApplication.shared.statusBarFrame.height
//        ///pageControl.frame = CGRect(origin: CGPoint(x: faramX, y: (Int(self.screenSize!.width)+Int(statusBarHeight!-30))), size: CGSize(width: faramWidth, height: 20))
//        pageControl.frame = CGRect(origin: CGPoint(x: faramX, y: 0), size: CGSize(width: faramWidth, height: 20))
//        pageControl.pageCount = productImagesArray.count
//        pageControl.tintColor = AppColors.shared.Color_gray_CACACA
//        pageControl.inactiveTint = AppColors.shared.Color_ash_CACACA
//        pageControl.activeTint = AppColors.shared.Color_yellow_A89968
//
//        //pageControl.backgroundColor = UIColor.red
//        //pageControl.indicatorPadding = 5
//
//
//        //self.view.addSubview(pageControl)
//        self.paginationViewMain.addSubview(pageControl)
//        //pageControl.center = view.center
//        pageControl.frame.origin.x = ((self.screenSize?.width ?? 0)-CGFloat(faramWidth))/2
//        //pageControl.layer.zPosition = 1
//    }
        //MARK END{MHIOS-1248}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.progress = CGFloat(scrollView.contentOffset.x) / CGFloat(scrollView.frame.width)
    }
    
    //MARK START{MHIOS-1248}
    // MARK: - COLLECTION VIEW
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//        let width = self.view.frame.size.width
//        let imageHeight = (width/5)*6 + 0
//        return CGSize(width: productImagesCV.frame.width, height: productImagesCV.frame.height)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
//        return 0
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
//        return 0
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return productImagesArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cellData = productImagesArray[indexPath.item]
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCVC_id", for: indexPath) as? ProductImagesCVC else { return UICollectionViewCell() }
//        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
//        let animatedGif = UIImage.sd_image(withGIFData: imageData)
//        let placeholderImage = UIImage(named: "failure_image.png")
//        cell.productImage.image = animatedGif
//
//        ///cell.productImage.sd_setImage(with: URL(string: AppInfo.shared.gumletProductImageURL + (cellData.file ?? "")),placeholderImage: animatedGif)
//        let urlString = "\(AppInfo.shared.gumletProductImageURL + (cellData.file ?? "") ?? "")"
//        let url = URL(string: urlString)//?q=100
//        print("SANTHOSH MENU URL IS : \(url)")
//        if let imageUr = url
//        {
//            // Load the image with Kingfisher and handle the result
//            cell.productImage.kf.setImage(with: url, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
//                switch result {
//                case .success(let value):
//                    // The image loaded successfully, and `value.image` contains the loaded image.
//                    cell.productImage.image = value.image
//                case .failure(let error):
//                    // An error occurred while loading the image.
//                    // You can handle the failure here, for example, by displaying a default image.
//                    cell.productImage.image = placeholderImage
//                    print("Image loading failed with error: \(error)")
//                }
//            }
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//
//    }
    //MARK END{MHIOS-1248}
    
    @IBAction func share(_ sender: Any) {
        print("sharing.......")
        print("sharing count : \(self.product?.product_links?.count)")
        let text = "This is the text...."
        var urlkey = ""
        for att:Custom_attributes in self.product?.custom_attributes ?? []
        {
            if(att.attribute_code=="url_key")
            {
                urlkey = att.value ?? ""
            }
        }
        if(urlkey=="")
        {
            DispatchQueue.main.async {
                let myWebsite = NSURL(string: "\(AppInfo.shared.shareBaseURL)")
                let shareAll = [self.product?.name! , myWebsite ] as [Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.isModalInPresentation = true
                activityViewController.popoverPresentationController?.sourceView = sender as! UIView
                self.present(activityViewController, animated: true, completion: nil)
            }
            
        }
        else
        {
            DispatchQueue.main.async {
                var urlstring:String = AppInfo.shared.shareBaseURL+urlkey+".html"
                
                let myWebsite = NSURL(string:urlstring)
                let shareAll = [self.product?.name! , myWebsite ] as [Any]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.isModalInPresentation = true
                activityViewController.popoverPresentationController?.sourceView = sender as! UIView
                self.present(activityViewController, animated: true)
            }
        }
    }
    @IBAction func LikeAction(_ sender: Any) {
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
        // Mark MHIOS-1130
        let klaviyo = KlaviyoSDK()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Add To Wishlist with product sku: \(productId)")
        //MARK: END MHIOS-1225
        let event = Event(name: .CustomEvent("Add To Wishlist"), properties: [
            "AddedItemPrice": "\(self.product?.price)" ,"AddedItemSku":self.product?.sku,"AddedItemQuantity":"1",
            "AddedItemProductName": self.product?.name
        ], value:Double(self.product?.price ?? 0))
        klaviyo.create(event: event)
        let btn:UIButton = sender as! UIButton
        if UserData.shared.isLoggedIn
        {
            print("SNATHOSH W PRODUCT ID ID : \(self.product?.id)")
            print("SNATHOSH W Whishlist ID ID : \(self.wishListId)")
            ///let btn:UIButton = sender as! UIButton
            if btn.currentImage!.isEqual(UIImage(named: "like_button")) {
                self.apiAddToWishlist(id: "\(Int((self.product?.id)!) )"){ responseData in
                    DispatchQueue.main.async { [self] in
                        print(responseData)
                        if responseData{
                            
                            print("SNATHOSH W PRODUCT ID ID : \(self.product?.id)")
                            print("SNATHOSH W Whishlist ID ID : \(self.wishListId)")
                            self.btnWishlist.setImage(UIImage(named: "liked"), for: .normal)
                            //MARK START{MHIOS-1181}
                            UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int(productId) ?? 0,sku: sku))
                            //MARK END{MHIOS-1181}
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.wishList.append(productId)
                            self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
                            
                        }
                    }
                }
            }
            else
            {
                self.apiRemoveProduct(id: productId ){ responseData in
                    DispatchQueue.main.async {
                        print(responseData)
                        if responseData{
                            self.btnWishlist.setImage(UIImage(named: "like_button"), for: .normal)
                            //MARK START{MHIOS-1181}
                            UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(self.productId) ?? 0 }
                            //MARK END{MHIOS-1181}
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.wishList = appDelegate.wishList.filter{$0 != self.productId }
                            //self.collectionPLP.reloadData()
                            self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
                        }
                    }
                }
            }
        }
        else
        {
            if btn.currentImage!.isEqual(UIImage(named: "like_button"))
            {
                //MARK START{MHIOS-1029}
                //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //appDelegate.wishList.append(productId)
                self.btnWishlist.setImage(UIImage(named: "liked"), for: .normal)
                UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int(productId) ?? 0,sku: sku))
                self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
//                self.showAlert(message: "Please log in or register to view your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
//                    self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
//                }, leftAction: {
//                    //print("SANTHOSH WISHLIST G LIST \(appDelegate.wishLists[0])")
//                })
                //MARK END{MHIOS-1029}
            }
            else
            {
                //MARK START{MHIOS-1029}
    //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //            appDelegate.wishList = appDelegate.wishList.filter{$0 != productId }
                UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(productId) ?? 0 }
                self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
                //MARK END{MHIOS-1029}
                //self.collectionPLP.reloadData()
                self.btnWishlist.setImage(UIImage(named: "like_button"), for: .normal)
                //self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
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
                            let cartCountIs = mycart.itemsCount!
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
                                let cartCountIs = mycart.itemsCount!
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
                        let cartCountIs = mycart.itemsCount!
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
}

extension ProductDetailsImagesVC: UBottomSheetCoordinatorDelegate{
    
    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
        //self.btnBack.isEnabled = false
    }
    
    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
        switch state {
        case .progressing(_, let percent):
            self.btnBack.isEnabled = false
        case .finished(_, let percent):
            //let seconds = 0.4
            //DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.btnBack.isEnabled = true
            //}
        default:
            break
        }
    }
    
    func bottomSheet(_ container: UIView?, finishTranslateWith extraAnimation: @escaping ((CGFloat) -> Void) -> Void) {
        extraAnimation({ percent in
//            if(percent==100)
//            {
//                self.tabBarController?.hideTabBar(isHidden: false)
//            }
//            else
//            {
//                self.tabBarController?.hideTabBar(isHidden: true)
//            }
        })
    }
    
    func handleState(_ state: SheetTranslationState){
        switch state {
        case .progressing(_, let percent):
            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
        case .finished(_, let percent):
            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
        default:
            break
        }
    }
}
