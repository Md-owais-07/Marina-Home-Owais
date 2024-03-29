//
//  HomeCell.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import UIKit
import AVKit
import Kingfisher
protocol HomeCellProtocol {
    

    func OpenDetail(Room:Home)
    func OpenDetailPlp(Room:Home)
    func OpenMenuPlp(Room:Home)
   
    
}
class HomeCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var detailDelegate: HomeCellProtocol?
    var category:[Home] = []
    var player: AVQueuePlayer?
    var playerItem: AVPlayerItem?
    var  playerLayer:AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var collectionBanner: UICollectionView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet var imgTopPadding: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       //
        self.pageControl.transform =  CGAffineTransformMakeScale(0.7,0.7)
        self.collectionBanner.delegate = self
        self.collectionBanner.dataSource = self
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        imgTopPadding.constant = statusBarHeight+8
        
       // self.collectionBanner.reloadData()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopPlayer), name: Notification.Name("stopPlayer"), object: nil)
    }

    @objc func stopPlayer() {
        // Mark MHIOS-1114
                player?.pause()
        //        player?.replaceCurrentItem(with: nil)
        //        playerLooper = nil
        //        playerItem = nil
        //        player = nil
        //        playerLayer?.removeFromSuperlayer()
        //        playerLayer = nil
        // Mark MHIOS-1114
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.category.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let banner:Home = self.category[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCell", for: indexPath) as! HomeBannerCell
         
         cell.btnDetail.tag = indexPath.row
         cell.btnDetail.addTarget(self, action: #selector(self.DetailAction(_:)), for: .touchUpInside)
         //cell.setNeedsDisplay()
         if(banner.title1 != nil)
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
         }
         
         //title 2
         if(banner.title2 != nil)
         {
             //cell.lblTitle2.backgroundColor = .green
             cell.lblTitle2.isHidden = false
             cell.lblTitle2.text = banner.title2
             cell.lblTitle2.font = AppFonts.PlayfairFont.SemiBold(28)
             let alignment = banner.title_2_alignment
             let font = banner.title2_font
             switch font {
             case "light":
                 
                 cell.lblTitle2.font = AppFonts.LatoFont.Regular(14)
             case "bold":
                 cell.lblTitle2.font = AppFonts.PlayfairFont.SemiBold(28)
             default:
                 cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
             }
             switch alignment {
             case "left":
                 cell.lblTitle2.textAlignment = .left
             case "right":
                 cell.lblTitle2.textAlignment = .right
             default:
                 cell.lblTitle2.textAlignment = .center
             }
         }
         else
         {
             cell.lblTitle2.isHidden = true
         }
         
         //title 2
         if(banner.title3 != nil)
         {
             cell.lblTitle3.isHidden = false
             cell.lblTitle3.text = banner.title3
             cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
             let alignment = banner.title_3_alignment

             switch alignment {
             case "left":
                 cell.lblTitle3.textAlignment = .left
             case "right":
                 cell.lblTitle3.textAlignment = .right
             default:
                 cell.lblTitle3.textAlignment = .center
             }
             let font = banner.title3_font
             switch font {
             case "light":
                 
                 cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
             case "bold":
                 cell.lblTitle3.font = AppFonts.PlayfairFont.SemiBold(28)
             default:
                 cell.lblTitle3.font = AppFonts.LatoFont.Regular(14)
             }
         }
         else
         {
             cell.lblTitle3.isHidden = true
         }
         
         if(banner.video != nil)
         {
            
             let asset = AVAsset(url: URL(string: banner.video ?? "")!)
             let keys: [String] = ["playable","duration"]
            

             asset.loadValuesAsynchronously(forKeys: keys, completionHandler: {
                  var error: NSError? = nil
                  let status = asset.statusOfValue(forKey: "playable", error: &error)
                  switch status {
                     case .loaded:
                      
                        
                              
                              let duration = asset.duration
                              //let duration = Int64( ( (Float64(CMTimeGetSeconds(du)) *  10.0) - 1) / 10.0 )
                      if(duration != CMTime.zero)
                      {
                          self.playerItem = AVPlayerItem(asset: asset)
                          self.player = AVQueuePlayer()
                          self.player?.volume = 0
                          self.playerLayer = AVPlayerLayer(player: self.player)
                          self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                          DispatchQueue.main.async {
                              cell.imgBanner.layoutIfNeeded()
                              self.playerLayer?.frame = cell.imgBanner.layer.bounds
                              
                              cell.imgBanner.layer.insertSublayer(self.playerLayer!, at: 1)
                              self.player?.removeAllItems()
                              self.playerLooper = AVPlayerLooper(player: self.player!, templateItem: self.playerItem!,
                                                                 timeRange: CMTimeRange(start: CMTime.zero, end:duration ))
                              self.player?.play()
                          }
                      }
                         break
                     case .failed:
                          DispatchQueue.main.async {
                              //do something, show alert, put a placeholder image etc.
                         }
                         break
                      case .cancelled:
                         DispatchQueue.main.async {
                             //do something, show alert, put a placeholder image etc.
                         }
                         break
                      default:
                         break
                }
             })
             // Mark MHIOS-1111
             cell.imgBanner.image = UIImage()
             // Mark MHIOS-1111
         }
        else
         {
            cell.imgBanner.layer.sublayers?.removeAll()
            if banner.image != ""
            {
                let url = URL(string: "\(banner.image ?? "")")!
                cell.imgBanner.kf.setImage(with:url.downloadURL )
            }
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return   self.contentView.frame.size
    }

    // MARK UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{

        return 0
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
    }
    @objc func DetailAction(_ sender: UIButton) {
        
        let banner:Home = self.category[sender.tag]
        if(banner.category_id==nil)
        {
            
                self.detailDelegate?.OpenDetail(Room:banner )
            
        }
      
        else
        {
            if(banner.is_shopbystyle_flag == "1")
            {
                self.detailDelegate?.OpenDetailPlp(Room:banner )
            }
           else
            {
               self.detailDelegate?.OpenMenuPlp(Room:banner )
              
           }
            
        }
    }
}

