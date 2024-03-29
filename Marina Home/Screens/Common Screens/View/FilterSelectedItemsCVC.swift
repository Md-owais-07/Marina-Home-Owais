//
//  FilterSelectedItemsCVC.swift
//  Marina Home
//
//  Created by Codilar on 24/04/23.
//

import UIKit

protocol FilterSelectedItemsDelegate {
    func removeListItem(tag:Int)
}

class FilterSelectedItemsCVC: UICollectionViewCell {
    @IBOutlet weak var selectedItemsLbl: UILabel!
    var filterSelectedItemsDelegate : FilterSelectedItemsDelegate?
    var indexPath:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        filterSelectedItemsDelegate?.removeListItem(tag: indexPath!)
    }
    

}
