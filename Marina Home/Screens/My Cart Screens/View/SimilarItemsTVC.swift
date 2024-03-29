//
//  SimilarItemsTVC.swift
//  Marina Home
//
//  Created by Codilar on 17/05/23.
//

import UIKit

protocol ProductCardSubDelegate {
    func openDetailSub(tag:Int)
    //MARK START{MHIOS-1029}
    func addToWishListSub(productId:String,sku:String)
    //MARK END{MHIOS-1029}
    func removeWishListSub(productId:String,tag:Int)
    func redirectToLoginPageSub()
}

class SimilarItemsTVC: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,ProductCardDelegate {
    
    var productSubDelegate : ProductCardSubDelegate?
    
    func openDetail(tag:Int,sectionSelected:Int) {
        productSubDelegate?.openDetailSub(tag: tag)
    }
    //MARK START{MHIOS-1029}
    func addToWishList(productId:String,tag:Int,sku:String) {
        print("SELECT AAAAAAAA")
        self.productSubDelegate?.addToWishListSub(productId:productId,sku:sku)
    }
    //MARK END{MHIOS-1029}
    
    func removeWishList(productId: String, tag: Int) {
        print("UNSELECT AAAAAAAA")
        self.productSubDelegate?.removeWishListSub(productId:productId,tag: tag)
    }
    
    func redirectToLoginPage(){
        print("UNSELECT AAAAAAAA")
        self.productSubDelegate?.redirectToLoginPageSub()
    }
    

    @IBOutlet var collectionSimilarItems: UICollectionView!
    @IBOutlet var btnViewAll: UIButton!
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    var youMightLikeProductsArray:[RecordsYML]?
    
    override func awakeFromNib() {
        self.collectionSimilarItems.delegate = self
        self.collectionSimilarItems.dataSource = self
        super.awakeFromNib()
        ProductCVC.register(for: self.collectionSimilarItems)
       
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youMightLikeProductsArray!.count //self.products.items?.count ?? 0
    
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
         //cell.setNeedsDisplay()
         
         let cellData = youMightLikeProductsArray![indexPath.item]
         
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
         cell.setImages(sliderImages: [])
//         let flowLayout = UICollectionViewFlowLayout()
//         flowLayout.scrollDirection = .horizontal
//         flowLayout.itemSize = CGSize(width: 128, height: 128)
//         cell.collectionImages.collectionViewLayout = flowLayout
//         cell.collectionImages.reloadData()
         
//         DispatchQueue.main.async {
//            let flowLayout = UICollectionViewFlowLayout()
//            flowLayout.scrollDirection = .horizontal
//            flowLayout.itemSize = CGSize(width: 128, height: 128)
//            cell.collectionImages.collectionViewLayout = flowLayout
//            cell.collectionImages.reloadData()
//         }
         print("SANTHOSH PRICE : ",cellData.salePrice!)
         var salePrice = 0.0
         if let floatNumber = Float(cellData.salePrice ?? "0.00") {
             salePrice = Double(floatNumber)
             ///print(integerNumber) // Output: 123
             
         }
         else
         {
             print("Invalid number")
             salePrice = 0
         }
         
         let price = Double(cellData.price ?? "0.00") ?? 0.0
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width/2
        width = width - 9
        return CGSize(width: width, height: width+72)
           // in case you you want the cell to be 40% of your controllers view
        
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
    // MARK UICollectionViewDelegate
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
