//
//  RoomItemTableCell.swift
//  Marina Home
//
//  Created by Codilar on 13/04/23.
//

import UIKit

class RoomItemTableCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var products:Products = Products()
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
        return self.products.items?.count ?? 0
    
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomItemCell", for: indexPath) as! RoomItemCell
         let product:Item = self.products.items![indexPath.row]
         //cell.setNeedsDisplay()
         cell.lblName.text = product.name
         cell.lblPrice.text = String(format: "%d", product.price!)
         cell.lblName.font = AppFonts.LatoFont.Regular(13)
         cell.lblPrice.font = AppFonts.LatoFont.Bold(13)
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.contentView.frame.size.height
           let width = self.contentView.frame.size.width
           // in case you you want the cell to be 40% of your controllers view
           return CGSize(width:168, height: 232)
    }

    // MARK UICollectionViewDelegate
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
