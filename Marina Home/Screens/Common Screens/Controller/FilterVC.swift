//
//  FilterVC.swift
//  Marina Home
//
//  Created by Codilar on 24/04/23.
//

import UIKit
protocol FilterOptions { func selectedFilterOptions(options:[FilterModel], filterSectionArray:[Available_filters])}
class FilterVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,FilterSelectedItemsDelegate {
    func removeListItem(tag: Int) {
        selectedItemsArray.remove(at: tag)
        selectedItemsCV.reloadData()
        refreshFiltersWithApi()
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterSectionTable: UITableView!
    @IBOutlet weak var filterSectionItemsTable: UITableView!
    @IBOutlet weak var selectedItemsCV: UICollectionView!
    @IBOutlet weak var selectedItemsBGView: UIView!

    var isfromSearch = false
    var filterSectionArray:[Available_filters] = []
    var selectedSection = 0
    var selectedItemsArray:[FilterModel] = [] {
        didSet {
            if selectedItemsCV != nil{
                selectedItemsCV.reloadData()
                selectedItemsBGView.isHidden = selectedItemsArray.count == 0
            }
        }
    }
    var delegate:FilterOptions?
    var categoryId = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        backActionLink(backButton)
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Filter Screen")
        //MARK: END MHIOS-1225
        filterSectionTable.isHidden = true
        filterSectionItemsTable.isHidden = true
        selectedItemsBGView.isHidden = true
        FilterSelectedItemsCVC.register(for: selectedItemsCV)
        selectedItemsCV.delegate = self
        selectedItemsCV.dataSource = self
        filterSectionTable.delegate = self
        filterSectionTable.dataSource = self
        filterSectionTable.register(UINib(nibName: "FilterSectionsTVC", bundle: nil), forCellReuseIdentifier: "FilterSectionsTVC_id")
        filterSectionItemsTable.delegate = self
        filterSectionItemsTable.dataSource = self
        filterSectionItemsTable.register(UINib(nibName: "FilterSectionsItemsTVC", bundle: nil), forCellReuseIdentifier: "FilterSectionsItemsTVC_id")
        self.filterSectionTable.isHidden = self.filterSectionArray.count == 0
        self.filterSectionItemsTable.isHidden = self.filterSectionArray.count == 0
        self.selectedItemsCV.reloadData()
        self.selectedItemsBGView.isHidden = self.selectedItemsArray.count == 0
        self.filterSectionTable.reloadData()
        self.filterSectionItemsTable.reloadData()
        if( self.filterSectionArray.count==0)
        {
            self.refreshFiltersWithApi()
        }
    }

    @IBAction func clearAction(_ sender: UIButton) {
        selectedSection = 0
        selectedItemsArray = []
        refreshFiltersWithApi()
    }

    @IBAction func applyAction(_ sender: UIButton) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Filter Screen option: \(selectedItemsArray)")
        CrashManager.shared.log("Filter Screen data: \(filterSectionArray)")
        //MARK: END MHIOS-1225
            delegate?.selectedFilterOptions(options: selectedItemsArray, filterSectionArray: filterSectionArray)
            self.navigationController?.popViewController(animated: true)
    }

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: ((selectedItemsArray[indexPath.item].displayTitle)).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).width +  60, height: 32)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
        let cellData = selectedItemsArray[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterSelectedItemsCVC_id", for: indexPath) as? FilterSelectedItemsCVC else { return UICollectionViewCell() }
        cell.selectedItemsLbl.text = cellData.displayTitle
        cell.indexPath = indexPath.row
        cell.filterSelectedItemsDelegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedItemsArray.remove(at: indexPath.item)
//        selectedItemsCV.reloadData()
//        refreshFiltersWithApi()
    }

    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == filterSectionTable ? filterSectionArray.count : (filterSectionArray.count > selectedSection ? filterSectionArray[selectedSection].options.count : 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == filterSectionTable{
            let cellData = filterSectionArray[indexPath.item]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSectionsTVC_id", for: indexPath) as? FilterSectionsTVC else { return UITableViewCell() }
            cell.setSelectionStyle(isSelected: indexPath.item == selectedSection)
            cell.sectionLbl.text = cellData.name
            return cell
        }else{
            var cellData = filterSectionArray[selectedSection].options[indexPath.item]
            if self.selectedItemsArray.contains(where: {$0.displayTitle == cellData.label ?? ""}){
                cellData.isSelected = true
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSectionsItemsTVC_id", for: indexPath) as? FilterSectionsItemsTVC else { return UITableViewCell() }
            cell.sectionItemLbl.text = cellData.label
            let itemCount = "\(cellData.count ?? "0")"
            if itemCount == "1"
            {
                cell.sectionCountLbl.text = "\(itemCount) item"
            }
            else
            {
                cell.sectionCountLbl.text = "\(itemCount) items"
            }
            
            cell.setSelectionStyle(isSelected: cellData.isSelected)
            var apiColorValue = cellData.swatch_value ?? ""
            if apiColorValue != ""{
                if cellData.label?.uppercased() ?? "" == "MULTICOLOR"{
                    cell.sectionItemImage.setBackgroundColor(color:UIColor.clear)
                    cell.sectionItemImage.image = UIImage(named: "multicolor_icon")
                }else if cellData.label?.uppercased() ?? "" == "CLEAR"{
                    cell.sectionItemImage.setBackgroundColor(color:UIColor.clear)
                    cell.sectionItemImage.image = UIImage(named: "clear_png")
                }else{
                    
                    
                    if apiColorValue.hasPrefix("#"){
                        let hexValue = apiColorValue.removeFirst()
                        cell.sectionItemImage.setBackgroundColor(color:colorWithHexString(hexString: apiColorValue))
                        cell.sectionItemImage.image = UIImage()
                    }
                    else if !apiColorValue.hasPrefix("http")
                    {
                        cell.selectionImage.kf.setImage(with:URL(string: apiColorValue) )
                        cell.imageBG.isHidden = false
                    }
                }
                cell.imageBG.isHidden = false
            }else{
                
                cell.sectionItemImage.setBackgroundColor(color:UIColor.clear)
                cell.imageBG.isHidden = true
                cell.sectionItemImage.image = UIImage()
                
            }
            return cell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filterSectionTable{
            selectedSection = indexPath.item
            filterSectionTable.reloadData()
            filterSectionItemsTable.reloadData()
        }else{
            self.filterSectionArray[selectedSection].options[indexPath.item].isSelected = !self.filterSectionArray[selectedSection].options[indexPath.item].isSelected
            if self.filterSectionArray[selectedSection].options[indexPath.item].isSelected{
                let dataToAppend = FilterModel(section: filterSectionArray[selectedSection].attribute_code ?? "", sectionItem: self.filterSectionArray[selectedSection].options[indexPath.item].value ?? "", displayTitle: self.filterSectionArray[selectedSection].options[indexPath.item].label ?? "", itemCount: self.filterSectionArray[selectedSection].options[indexPath.item].count ?? "0")
                    if !selectedItemsArray.contains(where: { $0.sectionItem == dataToAppend.sectionItem }) {
                        selectedItemsArray.append(dataToAppend)
                    }
            }else{
                for (sectionIndex,section) in selectedItemsArray.enumerated(){
                    if section.displayTitle == self.filterSectionArray[selectedSection].options[indexPath.item].label{
                        selectedItemsArray.remove(at: sectionIndex)
                        break
                    }
                }
            }
            refreshFiltersWithApi()
        }
    }

    func refreshFiltersWithApi(){
        filterSectionTable.reloadData()
        filterSectionItemsTable.reloadData()
        self.apiFilterOptions(categoryId: categoryId){ response in
            DispatchQueue.main.async { [self] in
                let selectedSectionText = self.filterSectionArray.count > selectedSection ?  self.filterSectionArray[selectedSection].name ?? "" : ""
                self.filterSectionArray = response.available_filters
                var hasSection = false
                for (index,item) in self.filterSectionArray.enumerated(){
                    if (item.name ?? "") == selectedSectionText{
                        selectedSection = index
                        hasSection = true
                        break
                    }
                }
                if !hasSection{
                    selectedSection = 0
                }
                if self.selectedItemsArray.count > 0{
                    for (sectionIndex,section) in self.filterSectionArray.enumerated(){
                        for (sectionItemIndex,sectionItem) in section.options.enumerated(){
                            if self.selectedItemsArray.contains(where: {$0.displayTitle == sectionItem.label ?? ""}){
                                self.filterSectionArray[sectionIndex].options[sectionItemIndex].isSelected = true
                            }
                        }
                    }
                }
                self.filterSectionTable.isHidden = self.filterSectionArray.count == 0
                self.filterSectionItemsTable.isHidden = self.filterSectionArray.count == 0
               
                self.selectedItemsBGView.isHidden = self.selectedItemsArray.count == 0
                self.filterSectionTable.reloadData()
                self.filterSectionItemsTable.reloadData()
            }
        }
    }

    func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {

        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }

    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        hexInt = UInt32(bitPattern: scanner.scanInt32(representation: .hexadecimal) ?? 0)
        return hexInt
    }
}



