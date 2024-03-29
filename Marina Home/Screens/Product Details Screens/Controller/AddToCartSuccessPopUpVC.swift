//
//  AddToCartSuccessPopUpVC.swift
//  Marina Home
//
//  Created by Eljo on 28/07/23.
//

import UIKit

class AddToCartSuccessPopUpVC: AppUIViewController {
 
    
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet var btnQuantity: UIButton!
    
    @IBOutlet weak var viewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    
    var product:ProductDetailsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDetails()

        viewHeightConst.constant = (330)
        //viewBottomConst.constant = -(180)
        viewBottomConst.constant = -(150)
        
       
    }
    
    @IBAction func GoToCart(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 3
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.tabBarController?.hidesBottomBarWhenPushed = false
        if let tab = self.tabBarController  {
             tab.selectedIndex = 3
             if let navcon = tab.selectedViewController as? UINavigationController {
                                navcon.popToRootViewController(animated: true)
             }

        }
        ///self.navigationController?.popToRootViewController(animated: false)
    }
    func setDetails(){
        
        self.lblTitle.text = product?.name ?? ""
        self.lblDescription.text = product?.extension_attributes?.pdp_description
        let productImagesArray = product?.media_gallery_entries ?? []
        if(productImagesArray.count>0)
        {
            let cellData = productImagesArray[0]
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
            let animatedGif = UIImage.sd_image(withGIFData: imageData)
            ///self.imgProduct.image = animatedGif
            ///self.imgProduct.sd_setImage(with: URL(string: AppInfo.shared.productImageURL + (cellData.file ?? "")),placeholderImage: animatedGif)
            let placeholderImage = UIImage(named: "failure_image.png")
            self.imgProduct.image = placeholderImage
            let imageMain = "\(AppInfo.shared.productImageURL + (cellData.file ?? ""))"
            if(imageMain != "")
            {
                let url = URL(string: imageMain)
                if let imageUr = url
                {
                    // Load the image with Kingfisher and handle the result
                    self.imgProduct.kf.setImage(with: url, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            // The image loaded successfully, and `value.image` contains the loaded image.
                            self.imgProduct.image = value.image
                        case .failure(let error):
                            // An error occurred while loading the image.
                            // You can handle the failure here, for example, by displaying a default image.
                            self.imgProduct.image = placeholderImage
                            print("Image loading failed with error: \(error)")
                        }
                    }
                }
            }
       }
        var specialPrice = ""
        var specialToDate = ""
        var specialFromDate = ""
        for item in product?.custom_attributes ?? []{
            if item.attribute_code == "special_price"{
                let spPriceVal = Double(item.value ?? "0.00")
                if let floatNumber = Float(item.value ?? "0.00")
                {
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
        }
//        let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
//        if specialPriceFlag {
//            self.lblCrossedprice.isHidden = false
//            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatNumberToThousandsDecimal(number: product?.price ?? 0 ) ?? "") AED")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
//            
//            lblPrice.attributedText = attributeString
//        }
//        else
//        {
//            self.lblCrossedprice.isHidden = true
//            lblPrice.text = formatNumberToThousandsDecimal(number: product?.price ?? 0 ) + " AED"
//        }
        
        let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
        if specialPriceFlag {
            offerPriceLbl.isHidden = false
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let productPrice = formatNumberToThousandsDecimal(number: product?.price ?? 0)
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(productPrice) AED")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            
            productPriceLbl.attributedText = attributeString
        } else {
            offerPriceLbl.isHidden = true
            productPriceLbl.text = formatNumberToThousandsDecimal(number: product?.price ?? 0 ) + " AED"
        }
       
//        productQtyLbl.isHidden = false
//        productQtyLbl.text = "Only \(productQty) Left!"
       
    }
    
    @IBAction func close(_ sender: Any) {
        UserData.shared.goTocartStatus = false
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
