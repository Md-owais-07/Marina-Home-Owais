//
//  PopularCatogoryTVC.swift
//  Marina Home
//
//  Created by Eljo on 04/07/23.
////MARK START{MHIOS-872}
///Added the TTGTags view in UI side
/// //MARK END{MHIOS-872}


import UIKit
//MARK START{MHIOS-872}
import TTGTags
//MARK END{MHIOS-872}
protocol PopularCatogorySelectDelegate
{
    func selectedCategory(id: String, name:String)
    //MARK START{MHIOS-872}
    func selectedPopularSearch(name:String)
    //MARK END{MHIOS-872}
}
class PopularCatogoryTVC: UITableViewCell,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, 
//MARK START{MHIOS-872}
TTGTextTagCollectionViewDelegate {
    //MARK END{MHIOS-872}
    // MARK START MHIOS_1058
    @IBOutlet weak var collectionCategory: UICollectionView!
    // MARK END MHIOS_1058
    var suggestions: [RecordsYML] = []
    var delegate:PopularCatogorySelectDelegate?
    //MARK START{MHIOS-872}
    var popularSearchArray: [String] = []
    var popularSearchStatus:Bool = false
    //MARK END{MHIOS-872}
    
    
    //MARK START{MHIOS-872}
    @IBOutlet weak var tagView: TTGTextTagCollectionView!
    //MARK END{MHIOS-872}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //MARK START{MHIOS-872}
//        self.collectionCategory.delegate = self
//        self.collectionCategory.dataSource = self
        // Initialization code

        tagView.alignment = .left
        tagView.delegate = self
        setDataFunc()
        //MARK END{MHIOS-872}
    }
    //MARK START{MHIOS-872}
    func setDataFunc()
    {
        var tempArray: [String] = []
        tempArray.removeAll()
        tagView.removeAllTags()
        if popularSearchStatus
        {
            tempArray = popularSearchArray
        }
        else
        {
            if !suggestions.isEmpty
            {
                for data in suggestions {
                    tempArray.append(data.name ?? "")
                }
            }
            
        }
        
        for text in tempArray {
            let content = TTGTextTagStringContent.init(text: text)
            content.textColor = UIColor.black
            content.textFont = UIFont(name: AppFontLato.regular, size: 13)! //UIFont.boldSystemFont(ofSize: 20)
        
            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            normalStyle.extraSpace = CGSize.init(width: 16, height: 7)
            normalStyle.exactHeight = 29
            normalStyle.cornerRadius = 2
            normalStyle.borderWidth = 0
            normalStyle.shadowRadius = 0
            normalStyle.shadowOpacity = 0
            
            let selectedStyle = TTGTextTagStyle.init()
            selectedStyle.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            selectedStyle.extraSpace = CGSize.init(width: 16, height: 7)
            selectedStyle.exactHeight = 29
            selectedStyle.cornerRadius = 2
            selectedStyle.borderWidth = 0
            selectedStyle.shadowRadius = 0
            selectedStyle.shadowOpacity = 0
            
            let tag = TTGTextTag.init()
            tag.content = content
            tag.style = normalStyle
            tag.selectedStyle = selectedStyle
            
            tagView.addTag(tag)
        }
        
        tagView.reload()
    }
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        if popularSearchStatus
        {
            delegate?.selectedPopularSearch(name: popularSearchArray[Int(index)] ?? "")
        }
        else
        {
            let item:RecordsYML = (self.suggestions[Int(index)])
            delegate?.selectedCategory(id: item.id ?? "", name: item.name ?? "")
        }
    }
    //MARK END{MHIOS-872}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //MARK START{MHIOS-872}
        if popularSearchStatus
        {
            return CGSize(width: (popularSearchArray[indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).width ?? 0) +  60, height: 40)
        }
        else
        {
            return CGSize(width: (suggestions[indexPath.item].name?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).width ?? 0) +  60, height: 40)
        }
        //MARK END{MHIOS-872}
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 5, left: 16, bottom: 10, right: 5)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
       return 10
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
       return 10
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //MARK START{MHIOS-872}
        if popularSearchStatus
        {
            return popularSearchArray.count ?? 0
        }
        else
        {
            return suggestions.count ?? 0
        }
        //MARK END{MHIOS-872}
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //MARK START{MHIOS-872}
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCategoryCVC", for: indexPath) as? PopularCategoryCVC else { return UICollectionViewCell() }
        if popularSearchStatus
        {
            cell.lblName.text = popularSearchArray[indexPath.row].capitalized
        }
        else
        {
            let item:RecordsYML = (self.suggestions[indexPath.item])
            let cellData = suggestions[indexPath.item]
            cell.lblName.text = item.name?.capitalized
        }
        return cell
        //MARK END{MHIOS-872}
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK START{MHIOS-872}
        if popularSearchStatus
        {
            delegate?.selectedPopularSearch(name: popularSearchArray[indexPath.row] ?? "")
        }
        else
        {
            let item:RecordsYML = (self.suggestions[indexPath.item])
            delegate?.selectedCategory(id: item.id ?? "", name: item.name ?? "")
        }
        //MARK START{MHIOS-872}
    }
}
