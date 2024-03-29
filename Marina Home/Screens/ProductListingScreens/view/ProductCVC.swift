//
//  ProductCVC.swift
//  Marina Home
//
//  Created by Codilar on 04/05/23.
////////MARK START{MHIOS-1248}
/// change the slider view class MediaSlideshow
/////MARK END{MHIOS-1248}

import UIKit
import PageControls
import Alamofire
import Kingfisher
//MARK START{MHIOS-1248}
//import ImageSlideshow
import MediaSlideshow
//MARK END{MHIOS-1248}
// MARK START MHIOS_1058
protocol ProductCardDelegate: class {
    func openDetail(tag:Int,sectionSelected:Int)
    //MARK START{MHIOS-1029}
    func addToWishList(productId:String,tag:Int,sku:String)
    //MARK END{MHIOS-1029}
    func removeWishList(productId:String,tag:Int)
    func redirectToLoginPage()
}
// MARK END MHIOS_1058
class ProductCVC: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,//MARK START{MHIOS-1248}
MediaSlideshowDelegate
//MARK END{MHIOS-1248}
{
    // MARK START MHIOS_1058
    @IBOutlet weak var btnLike: UIButton!
    //@IBOutlet var pageControl: PillPageControl!
    @IBOutlet weak var lblActualPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var pageControlMainView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var mainView: UIView!
    //MARK START{MHIOS-1248}
    @IBOutlet weak var slideshow: MediaSlideshow!
    //MARK END{MHIOS-1248}
    // MARK END MHIOS_1058
    var sliderImages = [KingfisherSource]()
    // MARK START MHIOS_1058
    weak var productDelegate : ProductCardDelegate?
    // MARK END MHIOS_1058
    var imageArray:[Media_gallery_entries] = []
    var productId:Int = 0
    //MARK START{MHIOS-1029}
    var sku:String = ""
    //MARK END{MHIOS-1029}
    var file:String? = ""
    var imageArrayRec:String? = ""
    var currantPagePos = 0
    var sectionSelected:Int? = 0
   

    override func awakeFromNib() {

        super.awakeFromNib()
        ProductImageCVC.register(for: self.collectionImages)
        self.collectionImages.delegate = self
        self.collectionImages.dataSource = self

        // Initialization code
        self.customizePageControl()
        
       
    }
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    func customizePageControl()
    {
        self.pageControl.transform =  CGAffineTransformMakeScale(0.7,0.7)
        if 3 < imageArray.count
        {
            pageControl.numberOfPages = 3
        }
        else
        {
            pageControl.numberOfPages = imageArray.count
        }
       
    }
    
    func imageSlideStart()
    {
        ///slideshow.slideshowInterval = 4.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
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
        //MARK START{MHIOS-1248}
        slideshow.setMediaSources(sliderImages)
        //MARK END{MHIOS-1248}
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        ///totalPageCounterView.text = String(sliderImages.count)
    }
    
//    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("SANTHOAH PAGE COUNT A : \(page)")
//        ////curruntPageCounterView.text = String(page+1)
//    }
    
    @objc func didTap() {
        productDelegate?.openDetail(tag: self.tag,sectionSelected: sectionSelected!)
    }
    
   /* func customizePageControl(){
        let width = 4
        let height = 4
        let faramWidth = 22
        let indicatorPadding = 5
        pageControl.indicatorPadding = CGFloat(indicatorPadding)
        pageControl.pillSize = CGSize(width: width, height: height)
        //print("SCREEN WIDTH : ",self.screenSize?.width)
            //let faramWidth = (width*productImagesArray.count)+(indicatorPadding*(productImagesArray.count-1))
        //print("FRAM WIDTH : ",faramWidth)
        let faramX = (Int(pageControlMainView.frame.size.width)-faramWidth)/2
        //print("FRAM X : ",faramX)
        //statusBarHeight = UIApplication.shared.statusBarFrame.height
        pageControl.frame = CGRect(origin: CGPoint(x: faramX, y: 0), size: CGSize(width: faramWidth, height: 10))
        if 3 < imageArray.count
        {
            pageControl.pageCount = 3
        }
        else
        {
            pageControl.pageCount = imageArray.count
        }
        pageControl.tintColor = AppColors.shared.Color_gray_CACACA
        pageControl.inactiveTint = AppColors.shared.Color_ash_CACACA
        pageControl.activeTint = AppColors.shared.Color_yellow_A89968
        //pageControl.backgroundColor = UIColor.red
        self.pageControlMainView.addSubview(pageControl)
        pageControl.frame.origin.x = CGFloat(faramX) //((self.screenSize?.width ?? 0)-CGFloat(faramWidth))/2

    }*/

    func setImages(sliderImages:[KingfisherSource]){
//        if images.count>0{
//            imageArray = images
//        }else{
//            let defaultValue = Media_gallery_entries(id: 0, media_type: "image", label: "", position: 0, disabled: false, types: ["image"])
//            imageArray = [defaultValue]
//        }
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.itemSize = CGSize(width: 128, height: 128)
//        collectionImages.collectionViewLayout = flowLayout
//        collectionImages.reloadData()
        
        print("SANTHOSH PRODUCT FILE IMAGE NEW \(self.file)")
        print("SANTHOSH PRODUCT FILE IMAGE NEW imageArrayRec \(self.imageArrayRec)")
        self.sliderImages.removeAll()
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
        let animatedGif = UIImage.sd_image(withGIFData: imageData)
        let placeholderImage = UIImage(named: "failure_image.png")
        let options: KingfisherOptionsInfo = [ // Set a fade-in transition with a duration
            .onFailureImage(placeholderImage) // Set a custom target cache
        ]
        if(sliderImages.count != 0)
        {
            self.sliderImages = sliderImages
        }
        else
        {
            if imageArrayRec != ""
            {
                if(self.file == "")
                {
                    if imageArrayRec != ""
                    {
                        self.sliderImages.append(KingfisherSource(urlString: "\(self.imageArrayRec! )",placeholder:placeholderImage,options: options)!)
                    }
                }
                else
                {
                    self.sliderImages.append(KingfisherSource(urlString: "\(self.file!)",placeholder:placeholderImage,options: options)!)
                }
            }
            //MARK START{MHIOS-1215}
            else
            {
                self.sliderImages.append(KingfisherSource(urlString: "no_image",placeholder:placeholderImage,options:options)!)
            }
            //MARK END{MHIOS-1215}
        }
        imageSlideStart()
        
//        if(self.file == "")
//        {
//            if(self.sliderImages.count != 0)
//            {
//                self.sliderImages = sliderImages
//                imageSlideStart()
//            }
//            else
//            {
//                if imageArrayRec != ""
//                {
//                    self.sliderImages.append(KingfisherSource(urlString: "\(AppInfo.shared.gumletProductImageURL)\(self.imageArrayRec ?? "")")!)
//                    imageSlideStart()
//                }
//            }
//
//        }
//        else
//        {
//           self.sliderImages.append(KingfisherSource(urlString: "\(AppInfo.shared.gumletProductImageURL)\(self.file ?? "")")!)
//            imageSlideStart()
//        }
        
        
        
    }

    // MARK: - COLLECTION VIEW
    @IBAction func AddToWishList(_ sender: Any) {
        print("ss\(self.productId )")
        print("ss tag\(self.tag )")



            if self.btnLike.currentImage!.isEqual(UIImage(named: "like_button")) {
                print("SELECT")
                //MARK START{MHIOS-1029}
                self.productDelegate?.addToWishList(productId:"\(self.productId )",tag: self.tag, sku: "\(self.sku)")
                //MARK END{MHIOS-1029}
                self.btnLike.setImage(UIImage(named: "liked"), for: .normal)
            }
            else
            {
                print("UNSELECT")
                self.btnLike.setImage(UIImage(named: "like_button"), for: .normal)
                self.productDelegate?.removeWishList(productId:"\(self.productId )",tag: self.tag)
            }

       /* else
        {
            self.showAlert(message: "You must login or register to add items to your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
                self.productDelegate?.redirectToLoginPage()
            }, leftAction: {})

        }*/

//       let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.wishList.append("\(self.productId )")
//        self.apiAddToWishlist(id: "\(self.productId ?? 0)"){ responseData in
//            DispatchQueue.main.async {
//                print(responseData)
//
//
//                if responseData{
//                     print ("Added product!!!!")
//                    self.collectionImages.reloadData()//self.toastView(toastMessage: "Added to wishlist successfully!")
//                }
//            }
//        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var width = UIScreen.main.bounds.width/2
        width = width - 9
        return CGSizeMake(width, width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{

        return 0
    }
/*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
       return 8
    }*/


   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
       return 0
    }*/
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.isHidden = false
        if(self.file == "")
        {
            if(self.imageArray.count>=3)
            {
                self.pageControl.numberOfPages = 3
                return 3
            }
            else
            {
                if(self.imageArray.count>1)
                {
                    self.pageControl.numberOfPages = self.imageArray.count
                    return  self.imageArray.count
                }
                else
                {
                    self.pageControl.numberOfPages = 1
                    self.pageControl.isHidden = true
                }
            }
         return   self.imageArray.count
        }
        else
        {
            self.pageControl.isHidden = true
            return 1
        }


    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCVC_id", for: indexPath) as? ProductImageCVC else { return UICollectionViewCell() }
        
        
        
        
        print("SANTHOSH IMAGE  : ",imageArrayRec)
        //AppUIViewController().startAnim(view: mainView)
        cell.indexPath = indexPath.row
        cell.file = self.file
        cell.imageArrayRec = self.imageArrayRec
        cell.setImageData(imageArray: imageArray)
//        cell.imgProduct.image = nil
//        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
//        let animatedGif = UIImage.sd_image(withGIFData: imageData)
//        cell.imgProduct.image = animatedGif
//        if(self.file == "")
//        {
//            if(self.imageArray.count != 0)
//            {
//                print("SANTHOSH IMAGE STATUS IMAGE ARRAY AVAILABLE")
//                let image = self.imageArray[indexPath.row]
//                let url = URL(string: "\(AppInfo.shared.productImageURL)\(image.file ?? "")")!
//                //cell.imgProduct.kf.setImage(with:url.downloadURL,placeholder: animatedGif)
//
//                //
//                KF.url(url)
//                  .loadDiskFileSynchronously()
//                  .cacheMemoryOnly(true)
//                  .fade(duration: 0)
//                  .onProgress {
//                      receivedSize,
//                      totalSize in
//                      AppUIViewController().startAnim(view: self.mainView)
//                  }
//                  .onSuccess {
//                      result in
//                      AppUIViewController().stopAnim(view: self.mainView)
//                  }
//                  .onFailure {
//                      error in
//                      AppUIViewController().stopAnim(view: self.mainView)
//                      ///cell.imgProduct.image = UIImage(named:"product_placeholder_img.jpeg")
//                  }
//                  .set(to: cell.imgProduct)
//            }
//            else
//            {
//                if imageArrayRec != ""
//                {
//                    print("SANTHOSH IMAGE STATUS IMAGE ARRAY NOT AVAILABLE")
//                    let url = URL(string: "\(imageArrayRec)")!
//                    //cell.imgProduct.kf.setImage(with:url.downloadURL,placeholder: animatedGif)
//                    KF.url(url)
//                      .loadDiskFileSynchronously()
//                      .cacheMemoryOnly(true)
//                      .fade(duration: 0)
//                      .onProgress {
//                          receivedSize,
//                          totalSize in
//                          AppUIViewController().startAnim(view: self.mainView)
//                      }
//                      .onSuccess {
//                          result in
//                          AppUIViewController().stopAnim(view: self.mainView)
//                      }
//                      .onFailure {
//                          error in
//                          AppUIViewController().stopAnim(view: self.mainView)
//                          ///cell.imgProduct.image = UIImage(named:"product_placeholder_img.jpeg")
//                      }
//                      .set(to: cell.imgProduct)
//                }
//            }
//        }
//        else
//        {
//            print("SANTHOSH IMAGE STATUS FILE NOT AVAILABLE")
////            let url = URL(string: "\(AppInfo.shared.productImageURL)\(self.file ?? "")")!
////            cell.imgProduct.kf.setImage(with:url.downloadURL )
//
//            let url = URL(string: "\(self.file ?? "")")!
//            KF.url(url)
//              .loadDiskFileSynchronously()
//              .cacheMemoryOnly(true)
//              .fade(duration: 0)
//              .onProgress {
//                  receivedSize,
//                  totalSize in
//                  AppUIViewController().startAnim(view: self.mainView)
//              }
//              .onSuccess {
//                  result in
//                  AppUIViewController().stopAnim(view: self.mainView)
//              }
//              .onFailure {
//                  error in
//                  AppUIViewController().stopAnim(view: self.mainView)
//                  ///cell.imgProduct.image = UIImage(named:"product_placeholder_img.jpeg")
//              }
//              .set(to: cell.imgProduct)
//        }
        currantPagePos = 0
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("SANTHOSH POS : \(Int(indexPath.row))")
        print("SANTHOSH POS CRU : \(currantPagePos)")
        let currantIndex = indexPath.row
//        if currantPagePos == 0
//        {
//            self.pageControl.progress = 1
//            currantPagePos = 1
//        }
//        else if currantPagePos == 1
//        {
//            if currantIndex == 0
//            {
//                self.pageControl.progress = 0
//                currantPagePos = 0
//            }
//            else
//            {
//                self.pageControl.progress = 2
//                currantPagePos = 2
//            }
//        }
//        else if currantPagePos == 2
//        {
//            self.pageControl.progress = 1
//            currantPagePos = 1
//        }
        self.pageControl.currentPage = indexPath.row
        print("SANTHOSH PAGE pageControl : \(Int(indexPath.row))")
        //self.pageControl.progress = CGFloat(currantPagePos) //CGFloat(Int(indexPath.row))
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productDelegate?.openDetail(tag: self.tag,sectionSelected: sectionSelected!)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       // pageControl.currentPage = CGFloat(scrollView.contentOffset.x) / CGFloat(scrollView.frame.width)
    }
    
    func apiAddToWishlist(id:String,handler:((Bool) -> Void)? = nil){
        //self.view.endEditing(true)
        let api = Api.shared.addToWishlist
        if Network.isAvailable() {
            //self.showActivityIndicator(uiView: self.view)
            var completeUrl = AppInfo.shared.baseURL + api.url + "\(id)"
            completeUrl = completeUrl.replacingOccurrences(of: " ", with: "%20")
            var headers: HTTPHeaders = [:]
            headers["Content-Type"] = api.contentType.rawValue
            headers["Authorization"] = "Bearer \(UserData.shared.currentAuthKey)"
            AF.request(completeUrl, method: api.method, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: Bool.self) { response in
                   // self.hideActivityIndicator(uiView: self.view)
                    switch response.result {
                    case .success(_):
                        guard let data = response.value as? Bool else { return }
                        handler?(data)
                    case .failure(_):
                        guard let data = response.data else { return }
                        do {
                            let apiError = try JSONDecoder().decode(errorModel.self, from: data)
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": apiError.message ])
                           //MARK: END MHIOS-1285
                          
                        } catch {
                            //MARK: START MHIOS-1285
                           SmartManager.shared.trackEvent(event: "Server_Error_Event", properties: ["url": "\(completeUrl)","parameter": "","response": "Something went wrong. please try again" ])
                           //MARK: END MHIOS-1285
                        }
                    }
                }
        }else{
           // self.showAlert(message: "Please check your internet connection",rightactionTitle: "Retry", rightAction: {
                self.apiAddToWishlist(id: id, handler: handler)
           // }, leftAction: {})
        }
    }


    func showAlert(title: String = "", message: String, hasleftAction: Bool = false, leftactionTitle: String = "CANCEL", rightactionTitle: String = "OK", rightAction: @escaping ()->(), leftAction: @escaping ()->()) {
       DispatchQueue.main.async {
          let popUpVC = AppController.shared.alertPopUp
          popUpVC.rightActionClosure = rightAction
          popUpVC.leftActionClosure = leftAction
          popUpVC.message = message
          popUpVC.popUptitle = title
          popUpVC.hasleftAction = hasleftAction
          popUpVC.rightActionTitle = rightactionTitle
          popUpVC.leftActionTitle = leftactionTitle
          popUpVC.modalTransitionStyle = .crossDissolve
          popUpVC.modalPresentationStyle = .overCurrentContext
          UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
       }
    }
}
