//
//  CollectionViewExtensions.swift
//  Marina Home
//
//  Created by Codilar on 25/04/23.
//

import UIKit

extension UICollectionViewCell {

   static func register(for collectionView: UICollectionView)  {
      let cellName = String(describing: self)
      let cellIdentifier = cellName + "_id"
      let cellNib = UINib(nibName: String(describing: self), bundle: nil)
      collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
   }
}
