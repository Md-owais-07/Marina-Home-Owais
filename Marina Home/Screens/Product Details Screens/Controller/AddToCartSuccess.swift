//
//  AddToCartSuccess.swift
//  Marina Home
//
//  Created by santhosh t on 08/08/23.
///////MARK START{MHIOS-1215}
///Changed the  productDefault image to product_placeholder_img in UI side
/////MARK END{MHIOS-1215}

import UIKit

protocol AddToCartPopupsDelegate {
    func goToCArt()
    func closePopup()
}

class AddToCartSuccess: UIView {
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet var btnQuantity: UIButton!
    
    ///var product:ProductDetailsModel?

    var tabBarCont:UITabBarController?
    var addToCartPopupsDelegate : AddToCartPopupsDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("AddToCartSuccess", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        
    }
    
    
    @IBAction func goToCartBtnAction(_ sender: AppPrimaryButton) {
        print("SANTHOSH CART POP IS WORKING AAAA")
        
        //addToCartPopupsDelegate!.cartPopup(data: "APP NAME IS SANTHOSH")
        print("Button is Tapped")
        self.addToCartPopupsDelegate?.goToCArt()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        print("SANTHOSH CART POP IS WORKING AAAA")
        self.addToCartPopupsDelegate?.closePopup()
    }
    
    
    func setDetails(product:ProductDetailsModel){
        
        self.lblTitle.text = product.name ?? ""
        self.lblDescription.text = product.extension_attributes?.pdp_description
        var productImagesArray = product.media_gallery_entries ?? []
        //self.productImagesArray = response.media_gallery_entries ?? []
        
        var temp:[Media_gallery_entries_2] = []
        for p in productImagesArray
        {
            if(p.media_type == "external-video")
            {
                
            }
            else
            {
                temp.append(p)
            }
        }
        productImagesArray = temp
        //MARK START{MHIOS-1215}
        let placeholderImage = UIImage(named: "failure_image.png")
        if(productImagesArray.count>0)
        {
            let cellData = productImagesArray[0]
            let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
            let animatedGif = UIImage.sd_image(withGIFData: imageData)
            //self.imgProduct.image = animatedGif
            //self.imgProduct.sd_setImage(with: URL(string: AppInfo.shared.productImageURL + (cellData.file ?? "")),placeholderImage: animatedGif)
            
            self.imgProduct.image = placeholderImage
            let imageExt = "\(cellData.file ?? "")"
            let imageMain = "\(AppInfo.shared.productImageURL + (imageExt))"
            if(imageExt != "")
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
            //MARK START{MHIOS-1215}
            else
            {
                self.imgProduct.image = placeholderImage
            }
            //MARK END{MHIOS-1215}
        }
       
        //MARK START{MHIOS-1215}
        else
        {
            let placeholderImage = UIImage(named: "failure_image.png")
            self.imgProduct.image = placeholderImage
        }
        //MARK END{MHIOS-1215}
        var specialPrice = ""
        var specialToDate = ""
        var specialFromDate = ""
        for item in product.custom_attributes ?? []{
            if item.attribute_code == "special_price"{
                ///offerPriceLbl.text = "\(item.value ?? "0.00") AED"
                if let floatNumber = Float(item.value ?? "0.00")
                {
                    let spPriceVal = Double(floatNumber)
                    specialPrice = formatNumberToThousandsDecimal(number: spPriceVal )
                    offerPriceLbl.text = specialPrice + " AED  "
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
            //offerPriceLbl.isHidden = false
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatNumberToThousandsDecimal(number: product.price ?? 0 ) ) AED")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            
            productPriceLbl.attributedText = attributeString
        }
        else
        {
            ///offerPriceLbl.isHidden = true
            offerPriceLbl.text = ""
            productPriceLbl.text = formatNumberToThousandsDecimal(number: product.price ?? 0 ) + " AED"
        }
       
//        productQtyLbl.isHidden = false
//        productQtyLbl.text = "Only \(productQty) Left!"
       
    }
    func checkSpecialPrice(specialPrice:String, specialToDate:String, specialFromDate:String) -> Bool {
        var status = false
        let specialCleanPrice = specialPrice.replacingOccurrences(of: ",", with: "")
        var price = 0.0
        if let doubleValue = Double(specialCleanPrice) {
            price = doubleValue
        }
        if(price <= 0) {
            return status
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let fromDate = dateFormatter.date(from: specialFromDate)
        let toDate = dateFormatter.date(from: specialToDate)
        let dateFormatter_new = DateFormatter()
        dateFormatter_new.timeZone = TimeZone(identifier: "Asia/Dubai")
        dateFormatter_new.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let current_date = dateFormatter_new.string(from: Date())
        let currentDate = dateFormatter.date(from: current_date)
        if let fromDate = fromDate, let toDate = toDate {
            if fromDate <= currentDate! && currentDate! <= toDate {
                status = true
            }
        } else if let fromDate = fromDate {
            if fromDate <= currentDate! {
                status = true
            }
        } else if (specialToDate == "" && specialFromDate == "") {
            status = true
        }
        
        return status
    }
    
    public func formatNumberToThousand(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? ""
    }
    
    public func formatNumberToThousandsDecimal(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        if (number.truncatingRemainder(dividingBy: 1.0) != 0) {
            numberFormatter.minimumFractionDigits = 2
        }
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? ""
    }

}
