//
//  ProductDetailsNewVC.swift
//  Marina Home
//
//  Created by santhosh t on 21/08/23.
////MARK START{MHIOS-1248}
///Craete the class ProductDetailsNewVC and the UI Class
/////MARK START{MHIOS-1248}

import UIKit
//MARK START{MHIOS-1248}
//import ImageSlideshow
import MediaSlideshow
//MARK END{MHIOS-1248}

class ProductDetailsNewVC: AppUIViewController,
                           //MARK START{MHIOS-1248}
                           MediaSlideshowDelegate
                           //MARK END{MHIOS-1248}
                                                {
    
    var inputs: [MediaSource]?
    /// Closure called on page selection
    var pageSelected: ((_ page: Int) -> Void)?
    /// Index of initial image
    var initialPage: Int = 0
    var closeButton = UIButton()
    //MARK START{MHIOS-1248}
    @IBOutlet weak var slideshow: MediaSlideshow!
    //MARK END{MHIOS-1248}
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeBtnView: UIButton!
    //MARK START{MHIOS-1248}
    @IBOutlet weak var slideshowFullView: MediaSlideshow!
    //MARK END{MHIOS-1248}
    //MARK START{MHIOS-1273}
    var pageIndicator = UIPageControl()
    //MARK END{MHIOS-1273}
    //MARK START{MHIOS-1275}
    var tapStatus = false
    //MARK END{MHIOS-1275}
                                                    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK START{MHIOS-1248}
        backActionLink(self.closeBtnView)
        slideshow.zoomEnabled = true
        slideshow.backgroundColor = UIColor.clear
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        ///turns off the timer
        //slideshow.slideshowInterval = 0
        slideshow.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        slideshow.delegate = self
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 20))
        
        pageIndicator.currentPageIndicatorTintColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
        pageIndicator.pageIndicatorTintColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        pageIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        //MARK START{MHIOS-1273}
        pageIndicator.isEnabled = false
        //MARK END{MHIOS-1273}
        slideshow.pageIndicator = pageIndicator
        
        if let inputs = inputs {
            slideshow.setMediaSources(inputs)
        }
        slideshow.setCurrentPage(initialPage, animated: false)
        
        
        slideshowFullView.zoomEnabled = false
        slideshowFullView.contentScaleMode = UIViewContentMode.scaleAspectFill
        //slideshowFullView.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        ///turns off the timer
        //slideshow.slideshowInterval = 0
        slideshowFullView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        slideshowFullView.delegate = self
        slideshowFullView.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 20))
//        let pageIndicator = UIPageControl()
//        pageIndicator.currentPageIndicatorTintColor = #colorLiteral(red: 0.6588235294, green: 0.6, blue: 0.4078431373, alpha: 1)
//        pageIndicator.pageIndicatorTintColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
//        pageIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        //slideshowFullView.pageIndicator = pageIndicator
        if let inputs = inputs {
            slideshowFullView.setMediaSources(inputs)
        }
        slideshowFullView.setCurrentPage(initialPage, animated: false)
        //MARK END{MHIOS-1248}
        
        //MARK START{MHIOS-1275}
        // Add gesture recognizer for single tap
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGesture)
        
        // Add gesture recognizer for double tap
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        // Ensure that single tap is recognized only when double tap fails
        singleTapGesture.require(toFail: doubleTapGesture)
        //MARK END{MHIOS-1275}
    }
    //MARK START{MHIOS-1275}
    @objc func handleSingleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            print("Single Tap Detected")
        tapStatus = !tapStatus
        closeBtnView.isHidden = tapStatus
        pageIndicator.isHidden = tapStatus
    }
    @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        print("Double Tap Detected")
    }
    //MARK END{MHIOS-1275}
    
//    override open func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        //slideshow.slideshowItems.forEach { $0.cancelPendingLoad() }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
  
    }
    //MARK START{MHIOS-1037}
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        slideshow.slides.forEach { $0.willBeRemoved() }

        // Prevents broken dismiss transition when image is zoomed in
        if let zoomable = slideshow.currentSlide as? ZoomableMediaSlideshowSlide {
            zoomable.zoomOut()
        }
    }
    //MARK END{MHIOS-1037}
    
//    @IBAction func closeBtnAction(_ sender: UIButton) {
//        print("SANTHOSH current page : CLOSE")
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //MARK START{MHIOS-1248}
//    func setMainViewImage(page: Int)
//    {
//        let placeholderImage = UIImage(named: "failure_image.png")
//        let urlString = "\(inputs![page])"
//        //let imggg = inputs![page] ///slideshow.images[page] as! KingfisherSource
//        //let new = imggg
//        //let imggg = slideshow.images[page] as! KingfisherSource
//        let imggg = slideshow.sources[page]
//        ///let imgggnew = imggg.url //as! String
//        let urlStringIs = "" //"\(imgggnew)"
//        let url = URL(string: urlStringIs)
//        if let imageUr = url
//        {
//
//            // Load the image with Kingfisher and handle the result
//            imageView.kf.setImage(with: imageUr, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
//                switch result {
//                case .success(let value):
//                    self.imageView.image = value.image
//                case .failure(let error):
//                    self.imageView.image = placeholderImage
//                    print("Image loading failed with error: \(error)")
//                }
//            }
//        }
//        else
//        {
//            self.imageView.image = placeholderImage
//        }
//   }
    //MARK END{MHIOS-1248}
    func mediaSlideshow(_ mediaSlideshow: MediaSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        ///setMainViewImage(page: page)
        //MARK START{MHIOS-1248}
        slideshowFullView.setCurrentPage(page, animated: false)
        //MARK END{MHIOS-1248}
        //MARK START{MHIOS-1037}
        let isAVSource = inputs![page] is AVSource
        UIView.animate(withDuration: 0.3) {
//            self.slideshow.pageIndicator?.view.alpha = isAVSource ? 0.0 : 1.0
//            self.closeButton.alpha = isAVSource ? 0.0 : 1.0
            if isAVSource
            {
                self.tapStatus = false
                self.closeBtnView.isHidden = self.tapStatus
                self.pageIndicator.isHidden = self.tapStatus
            }
        }
        //MARK END{MHIOS-1037}
    }
}
