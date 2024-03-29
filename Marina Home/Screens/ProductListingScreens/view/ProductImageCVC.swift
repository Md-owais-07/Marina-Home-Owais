//
//  ProductImageCVC.swift
//  Marina Home
//
//  Created by Codilar on 04/05/23.
//

import UIKit
import Kingfisher

class ProductImageCVC: UICollectionViewCell {

    @IBOutlet var imgProduct: UIImageView!
    var file:String? = ""
    var indexPath:Int? = 0
    var imageArrayRec:String? = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func setImageData(imageArray:[Media_gallery_entries])
    {
         imgProduct.image = nil
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "image-loading-placeholder", withExtension: "gif")!)
        let animatedGif = UIImage.sd_image(withGIFData: imageData)
         //imgProduct.image = animatedGif
        if(self.file == "")
        {
            if(imageArray.count != 0)
            {
                print("SANTHOSH IMAGE STATUS IMAGE ARRAY AVAILABLE")
                let image = imageArray[indexPath!]
                let url = URL(string: "\(AppInfo.shared.productImageURL)\(image.file ?? "")")!
                // imgProduct.kf.setImage(with:url.downloadURL,placeholder: animatedGif)

                //
                KF.url(url)
                  .loadDiskFileSynchronously()
                  .cacheMemoryOnly(true)
                  .fade(duration: 0)
                  .onProgress {
                      receivedSize,
                      totalSize in
                      AppUIViewController().startAnim(view: self.imgProduct)
                  }
                  .onSuccess {
                      result in
                      AppUIViewController().stopAnim(view: self.imgProduct)
                  }
                  .onFailure {
                      error in
                      AppUIViewController().stopAnim(view: self.imgProduct)
                      /// imgProduct.image = UIImage(named:"product_placeholder_img.jpeg")
                  }
                  .set(to:  imgProduct)
            }
            else
            {
                if imageArrayRec != ""
                {
                    print("SANTHOSH IMAGE STATUS IMAGE ARRAY NOT AVAILABLE")
                    let url = URL(string: "\(imageArrayRec)")!
                    // imgProduct.kf.setImage(with:url.downloadURL,placeholder: animatedGif)
                    KF.url(url)
                      .loadDiskFileSynchronously()
                      .cacheMemoryOnly(true)
                      .fade(duration: 0)
                      .onProgress {
                          receivedSize,
                          totalSize in
                          AppUIViewController().startAnim(view: self.imgProduct)
                      }
                      .onSuccess {
                          result in
                          AppUIViewController().stopAnim(view: self.imgProduct)
                      }
                      .onFailure {
                          error in
                          AppUIViewController().stopAnim(view: self.imgProduct)
                          /// imgProduct.image = UIImage(named:"product_placeholder_img.jpeg")
                      }
                      .set(to:  imgProduct)
                }
            }
        }
        else
        {
            print("SANTHOSH IMAGE STATUS FILE NOT AVAILABLE")
//            let url = URL(string: "\(AppInfo.shared.productImageURL)\(self.file ?? "")")!
//             imgProduct.kf.setImage(with:url.downloadURL )

            let url = URL(string: "\(self.file ?? "")")!
            KF.url(url)
              .loadDiskFileSynchronously()
              .cacheMemoryOnly(true)
              .fade(duration: 0)
              .onProgress {
                  receivedSize,
                  totalSize in
                  AppUIViewController().startAnim(view: self.imgProduct)
              }
              .onSuccess {
                  result in
                  AppUIViewController().stopAnim(view: self.imgProduct)
              }
              .onFailure {
                  error in
                  AppUIViewController().stopAnim(view: self.imgProduct)
                  /// imgProduct.image = UIImage(named:"product_placeholder_img.jpeg")
              }
              .set(to:  imgProduct)
        }
    }
}
