//
//  ProductImagesCVC.swift
//  Marina Home
//
//  Created by Codilar on 26/04/23.
//

import UIKit
import Kingfisher
//import youtube_ios_player_helper

class ProductImagesCVC: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImage.isHidden = false
        
    }
    
    func dataSet(data:Media_gallery_entries_2)
    {
        let url = AppInfo.shared.productImageURL + data.file!
        let fileType = data.media_type
        print("SANTHOSH IMAGE URL : \(url)")
        
        productImage.isHidden = false
       
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urls = URL(string: "\(url ?? "")")
        if let imageUr = urls
        {
            print("SANTHOSH IMAGE URL IMAGE URL : \(imageUr)")
            KF.url(imageUr)
              .loadDiskFileSynchronously()
              .cacheMemoryOnly(true)
              .fade(duration: 0)
              .onProgress { receivedSize, totalSize in  }
              .onSuccess { result in  }
              .onFailure { error in }
              .set(to: productImage)
        }
        
//        if fileType == "external-video"
//        {
//
//            productImage.isHidden = true
//            playerView.isHidden = false
//            let urlVideo = data.extensionAttributesVideo?.videoContent?.videoURL
//            print("SANTHOSH IMAGE URL urlVideo : \(urlVideo)")
//            let urlSplit = urlVideo!.split(separator: "/")
//            let ytUrl = urlSplit[urlSplit.count-1]//"2kLlovR_LJA"
//            print("SANTHOSH IMAGE URL VIDEO : \(ytUrl)")
//            playerView.load(withVideoId: String(ytUrl))
//            ///playerView.playVideo()
//        }
//        else
//        {
//            print("SANTHOSH IMAGE URL IMAGE : \(url)")
//            playerView.stopVideo()
//            productImage.isHidden = false
//            playerView.isHidden = true
//            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            let urls = URL(string: "\(url ?? "")")
//            if let imageUr = urls
//            {
//                print("SANTHOSH IMAGE URL IMAGE URL : \(imageUr)")
//                KF.url(imageUr)
//                  .loadDiskFileSynchronously()
//                  .cacheMemoryOnly(true)
//                  .fade(duration: 0)
//                  .onProgress { receivedSize, totalSize in  }
//                  .onSuccess { result in  }
//                  .onFailure { error in }
//                  .set(to: productImage)
//            }
//        }
    }

}
