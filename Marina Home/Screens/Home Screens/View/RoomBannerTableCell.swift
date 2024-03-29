//
//  RoomCell.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit

class RoomBannerTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionBanner.delegate = self
        self.collectionBanner.dataSource = self
        // Initialization code
    }
    @IBOutlet weak var collectionBanner: UICollectionView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCell", for: indexPath) as! HomeBannerCell
         
         //cell.setNeedsDisplay()
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return   CGSize(width: self.contentView.frame.size.width, height: 450)
    }

    // MARK UICollectionViewDelegate
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    @IBAction func Btn_RightAction(_ sender: Any)
    {
        self.collectionBanner.scrollToNextItem()
    }
    @IBAction func Btn_LeftAction(_ sender: Any)
    {
        self.collectionBanner.scrollToPreviousItem()
    }
}
extension UICollectionView {

 func scrollToNextItem() {
    let contentOffset = CGFloat(floor(self.contentOffset.x +
    self.bounds.size.width))
    self.moveToFrame(contentOffset: contentOffset)
}

func scrollToPreviousItem() {
    let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
    self.moveToFrame(contentOffset: contentOffset)
}

func moveToFrame(contentOffset : CGFloat) {
    self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
}}
