//
//  FilterHeaderView.swift
//  Marina Home
//
//  Created by Codilar on 03/05/23.
//

import UIKit
// MARK START MHIOS_1058
protocol FilterOptionsRemoved: class { func selectedFilterOptionsRemoved(options:[FilterModel])}
// MARK END MHIOS_1058
class FilterHeaderView: UICollectionReusableView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate ,FilterSelectedItemsDelegate {
   
    func removeListItem(tag: Int) {
        selectedItemsArray.remove(at: tag)
        delegate?.selectedFilterOptionsRemoved(options: selectedItemsArray)
        if selectedItemsArray.isEmpty
        {
            labSort.text = UserDefaults.standard.string(forKey: "sort_name")
            filterSortBtnStatus = false
            fSBtnCurrentStatus = true
            labFilter.text = "FILTER"
            labFilterPadding.constant = 10
            labSortPadding.constant = 10
        }
    }
    // MARK START MHIOS_1058
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var selectedItemsCV: UICollectionView!
    @IBOutlet weak var selectedItemsListWidth: NSLayoutConstraint!
    @IBOutlet weak var labFilter: UILabel!
    @IBOutlet weak var labSort: UILabel!
    
    @IBOutlet weak var labFilterPadding: NSLayoutConstraint!
    @IBOutlet weak var labSortPadding: NSLayoutConstraint!
    @IBOutlet weak var filterDividerView: UIView!
    // MARK END MHIOS_1058
    var filterSortBtnStatus = false
    var fSBtnCurrentStatus = true
    
    var indexPos = 0
    var lastContentOffset: CGPoint = .zero
    ///var sortNameIs = "SORT"
    // MARK START MHIOS_1058
    weak var delegate:FilterOptionsRemoved?
    // MARK END MHIOS_1058
    var selectedItemsArray:[FilterModel] = [] {
        didSet {
            selectedItemsCV.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        FilterSelectedItemsCVC.register(for: selectedItemsCV)
        selectedItemsCV.delegate = self
        selectedItemsCV.dataSource = self
        selectedItemsCV.delegate = self
        //updateListWidth()
        getAvailableWidth()
        
    }

    
    func getAvailableWidth() -> CGFloat
    {
        let screenWidth = UIScreen.main.bounds.width
        let labSortName = UserDefaults.standard.string(forKey: "sort_name")!
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: AppFonts.LatoFont.Regular(13)] // You can change the font and size accordingly
        let size = (labSortName as NSString).size(withAttributes: attributes)
        let labSortWidth = size.width // This will gi
        print("SANTHOSH XXXXX labSortWidth \(labSortWidth)")
        var staticContentWidth = 0.0
        if fSBtnCurrentStatus
        {
            staticContentWidth = labSortWidth+170 //169
            print("SANTHOSH HEADER TRUE")
            print("SANTHOSH HEADER labSort NEW \(CGFloat(labSort.frame.size.width))")
        }
        else
        {
            staticContentWidth = 122 //121
            print("SANTHOSH HEADER FALSE")
        }
        //let staticContentWidth = labSortWidth+170
        let availableWidth = CGFloat(screenWidth)-staticContentWidth
        selectedItemsListWidth.constant = availableWidth

        return availableWidth
        
    }
    
    func getAvailableWidthWithText() -> CGFloat
    {
        let screenWidth = UIScreen.main.bounds.width
        let labSortName = UserDefaults.standard.string(forKey: "sort_name")!
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: AppFonts.LatoFont.Regular(13)] // You can change the font and size accordingly
        let size = (labSortName as NSString).size(withAttributes: attributes)
        let labSortWidth = size.width // This will gi
        print("SANTHOSH XXXXX labSortWidth \(labSortWidth)")
        var staticContentWidth = labSortWidth+170 //169
        //let staticContentWidth = labSortWidth+170
        let availableWidth = CGFloat(screenWidth)-staticContentWidth
        ///selectedItemsListWidth.constant = availableWidth

        return availableWidth
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollX = scrollView.contentOffset.x
        let screenWidth = UIScreen.main.bounds.width
        let scrollContentWidth = scrollView.contentSize.width
        let scrollViewFrame = scrollView.frame.size.width
        let scrollWidth = (scrollContentWidth - scrollViewFrame)
        let availableWidth = getAvailableWidth()
        let availableWidthWithoutText = CGFloat(screenWidth)-122
        let availableWidthWithText = getAvailableWidthWithText()
        
        print("SANTHOSH XXXXX scrollX \(scrollX)")
        print("SANTHOSH XXXXX screenWidth \(screenWidth)")
        print("SANTHOSH XXXXX scrollContentWidth \(scrollContentWidth)")
        print("SANTHOSH XXXXX scrollViewFrame \(scrollViewFrame)")
        print("SANTHOSH XXXXX scrollWidth \(scrollWidth)")
        print("SANTHOSH XXXXX availableWidth \(availableWidth)")
        
        
        if availableWidth>scrollContentWidth
        {
            scrollView.contentSize = CGSize(width: availableWidth, height: 32)
        }
        
        if availableWidthWithText<scrollContentWidth && availableWidthWithoutText<scrollContentWidth
        {
            if (2.0 < scrollX)
            {
                if !filterSortBtnStatus
                {
                    print("SANTHOSH HEADER SCROLL STATUS AAAAAAAAAA HIDE")
                    filterSortBtnStatus = true
                    fSBtnCurrentStatus = false
                    labFilter.text = ""
                    labSort.text = ""
                    labFilterPadding.constant = 5
                    labSortPadding.constant = 5
                    print("SANTHOSH HEADER labSort NEW AAAAAAA \(CGFloat(labSort.frame.size.width))")
                    //updateListWidth()
                    //getAvailableWidth()
                }
            }
            else
            {
                //            //scrolled to top, do smth
                if filterSortBtnStatus
                {
                    print("SANTHOSH HEADER SCROLL STATUS BBBBBBBBBB VISIBLE")
                    labSort.text = UserDefaults.standard.string(forKey: "sort_name")
                    filterSortBtnStatus = false
                    fSBtnCurrentStatus = true
                    labFilter.text = "FILTER"
                    labFilterPadding.constant = 10
                    labSortPadding.constant = 10
                    print("SANTHOSH HEADER labSort NEW BBBBBBBBB \(CGFloat(labSort.frame.size.width))")
                    //updateListWidth()
                    
                }
                
            }
        }
        else if availableWidthWithText<scrollContentWidth
        {
            if scrollView.contentOffset.x > lastContentOffset.x {
                print("Scrolling to the right")
                if filterSortBtnStatus
                {
                    print("SANTHOSH HEADER SCROLL STATUS BBBBBBBBBB VISIBLE")
                    labSort.text = UserDefaults.standard.string(forKey: "sort_name")
                    filterSortBtnStatus = false
                    fSBtnCurrentStatus = true
                    labFilter.text = "FILTER"
                    labFilterPadding.constant = 10
                    labSortPadding.constant = 10
                    //selectedItemsListWidth.constant = availableWidthWithText
                }
            } else if scrollView.contentOffset.x < lastContentOffset.x {
                print("Scrolling to the left")
                if !filterSortBtnStatus
                {
                    filterSortBtnStatus = true
                    fSBtnCurrentStatus = false
                    labFilter.text = ""
                    labSort.text = ""
                    labFilterPadding.constant = 5
                    labSortPadding.constant = 5
                    //selectedItemsListWidth.constant = availableWidthWithoutText
                }
            }
            
            lastContentOffset = scrollView.contentOffset
        }
        
    }
    

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: ((selectedItemsArray[indexPath.item].displayTitle)).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).width +  60, height: 32)
        
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
       return 0
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
       return 8
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedItemsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        indexPos = indexPath.row
        let cellData = selectedItemsArray[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterSelectedItemsCVC_id", for: indexPath) as? FilterSelectedItemsCVC else { return UICollectionViewCell() }
        cell.selectedItemsLbl.text = cellData.displayTitle
        cell.indexPath = indexPath.row
        cell.filterSelectedItemsDelegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedItemsArray.remove(at: indexPath.item)
        //delegate?.selectedFilterOptionsRemoved(options: selectedItemsArray)
    }

}
