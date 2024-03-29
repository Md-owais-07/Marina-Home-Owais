//
//  RoomMainBannerCVC.swift
//  Marina Home
//
//  Created by Codilar on 07/05/23.
//

import UIKit
import AVKit
protocol RoomBannerProtocol {
    

    func changeProducts(Room:ShopByRoom)
    
   
    
}
class RoomMainBannerCVC: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var collectionBanner: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var btnNext: UIButton!
    var category:[ShopByRoom] = []
    var player: AVQueuePlayer?
    var playerItem: AVPlayerItem?
    var  playerLayer:AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    var detailDelegate: RoomBannerProtocol?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.btnPrevious.addTarget(self, action: #selector(self.Btn_LeftAction(_:)), for: .touchUpInside)
        self.btnNext.addTarget(self, action: #selector(self.Btn_RightAction(_:)), for: .touchUpInside)
        self.collectionBanner.delegate = self
        self.collectionBanner.dataSource = self
       
        // Initialization code
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   self.category.count
    }
    func collectionView(_ collectionView: UICollectionView, layout
    collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
        
        
    }
   /* func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidth = scrollView.frame.width // Get the itemWidth. In my case every cell was the same width as the collectionView itself
        let contentOffset = targetContentOffset.pointee.x

        let targetItem = lround(Double(contentOffset/itemWidth))
        let targetIndex = self.category.count // numberOfItems which shows in the collection view
        print(targetIndex)
        DispatchQueue.main.async {
            self.pageControl.currentPage = targetIndex-1
        }
        
    self.detailDelegate?.changeProducts(Room: self.category[targetIndex-1])
    }*/
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        print("page = \(page)")
        if(page<=self.category.count-1)
        {
            DispatchQueue.main.async {
                self.pageControl.currentPage = page
            }
            
            self.detailDelegate?.changeProducts(Room: self.category[page])
        }
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let banner:ShopByRoom = self.category[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCell", for: indexPath) as! HomeBannerCell
         
         cell.btnDetail.tag = indexPath.row
         cell.btnDetail.addTarget(self, action: #selector(self.DetailAction(_:)), for: .touchUpInside)
         if banner.image != ""
         {
             let url = URL(string: "\(banner.image ?? "")")!
             cell.imgBanner.kf.setImage(with:url.downloadURL )
         }
         //cell.setNeedsDisplay()
        /* if(banner.title1 != nil)
         {
             //cell.lblTitle1.backgroundColor = .red
             cell.lblTitle1.isHidden = false
             cell.lblTitle1.text = banner.title1
             cell.lblTitle1.font = AppFonts.LatoFont.Regular(14)
             let alignment = banner.title_1_alignment

             switch alignment {
             case "left":
                 cell.lblTitle1.textAlignment = .left
             case "right":
                 cell.lblTitle1.textAlignment = .right
             default:
                 cell.lblTitle1.textAlignment = .center
             }
             let font = banner.title1_font
             switch font {
             case "light":
                 
                 cell.lblTitle1.font = AppFonts.LatoFont.Regular(14)
             case "bold":
                 cell.lblTitle1.font = AppFonts.PlayfairFont.SemiBold(28)
             default:
                 cell.lblTitle1.font = AppFonts.LatoFont.Regular(14)
             }
         }
         else
         {
             cell.lblTitle1.isHidden = true
         }*/
         
        
         
        /* if(banner.video != nil)
         {
            
             let pathURL = URL(string: banner.video!)
             let duration = Int64( ( (Float64(CMTimeGetSeconds(AVAsset(url: pathURL!).duration)) *  10.0) - 1) / 10.0 )
             playerItem = AVPlayerItem(url: pathURL!)
             player = AVQueuePlayer()
             player?.volume = 0
             playerLayer = AVPlayerLayer(player: player)
             playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
             cell.imgBanner.layoutIfNeeded()
             playerLayer?.frame = cell.imgBanner.layer.bounds
             cell.imgBanner.layer.insertSublayer(playerLayer!, at: 1)
            playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem!,
                                           timeRange: CMTimeRange(start: CMTime.zero, end: CMTimeMake(value: duration, timescale: Int32(0.00))) )
             player?.play()
         }
        else
         {
            let url = URL(string: "\(AppInfo.shared.imageURL)\(banner.image ?? "")")!
            
            cell.imgBanner.kf.setImage(with:url.downloadURL )
        }*/
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
//        let banner:ShopByRoom = self.category[indexPath.row]
//        let url = URL(string: "\(AppInfo.shared.imageURL)\(banner.image ?? "")")!
//        ///cell.imgBanner.kf.setImage(with:url.downloadURL )
//        let imageHeight = sizeOfImageAt(url: url)
//        print(indexPath.row)
//        print("SANTHSOSH IMAGE SIZE : ",imageHeight)
//        print("SANTHSOSH IMAGE URL : ",url)
//        //imageHeight!+60
        return CGSize(width: screenSize.width, height: self.collectionBanner.frame.size.height) //self.collectionBanner.frame.size.height
    }
    // MARK UICollectionViewDelegate

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         
    }
    
    
    
    @objc func DetailAction(_ sender: UIButton) {
        
       // let banner:Room = self.category[sender.tag]
        if(self.collectionBanner.tag == 1)
        {
          //  self.detailDelegate?.OpenDetailPlp(Room:banner )
        }
        else
        {
            //self.detailDelegate?.OpenDetail(Room:banner )
        }
    }
    @objc func Btn_RightAction(_ sender: Any)
    {
        var page = self.pageControl.currentPage
        if(self.pageControl.currentPage != self.category.count-1)
        {
            page = page+1
            self.collectionBanner.scrollToNextItem()
            DispatchQueue.main.async {
                self.pageControl.currentPage = page
            }
            
        self.detailDelegate?.changeProducts(Room: self.category[page])
        }
    }
    @objc func Btn_LeftAction(_ sender: Any)
    {
        var page = self.pageControl.currentPage
        if(self.pageControl.currentPage > 0)
        {
            page = page-1
            self.collectionBanner.scrollToPreviousItem()
            DispatchQueue.main.async {
                self.pageControl.currentPage = page
            }
            
        self.detailDelegate?.changeProducts(Room: self.category[page])
        }
    }
}
