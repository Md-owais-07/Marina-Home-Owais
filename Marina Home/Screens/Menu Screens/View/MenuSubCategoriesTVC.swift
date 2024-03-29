//
//  MenuSubCategoriesTVC.swift
//  Marina Home
//
//  Created by Codilar on 10/05/23.
////MARK START{MHIOS-554}
/// Craeted a model class "ChildExpandModel"
///Added a table view in the cell class
/// create an cell class and view "MenuChildrenCategoriesTVC"
/// MARK END{MHIOS-554}
////MARK START{MHIOS-1256}
///removed the divider in cell UI
////MARK START{MHIOS-1256}


import UIKit
//MARK START{MHIOS-554}
protocol MenuSubCategoriesDelegate: class {
    func expandChildCategories(tag:Int,section:Int)
    func openPLPPage(category_id:String,roomtite:String)
}
class MenuSubCategoriesTVC: UITableViewCell 
, UITableViewDataSource, UITableViewDelegate ,UITextViewDelegate {
   
    @IBOutlet weak var subCategoryLbl: UILabel!
    @IBOutlet weak var expandBtnView: UIButton!
    //MARK START{MHIOS-554}
    @IBOutlet weak var childListView: UITableView!
    @IBOutlet weak var bottomDivider:UIView!
    //MARK END{MHIOS-554}
    var indexValue:Int?
    var sectionValue:Int?
    weak var menuSubCategoriesDelegate : MenuSubCategoriesDelegate?
    var childCategoriesArray:[MenuModel] = []
    //MARK END{MHIOS-554}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        childListView.delegate = self
        childListView.dataSource = self
        
        let bibNAme = UINib(nibName: "MenuChildrenCategoriesTVC", bundle: nil)
        childListView.register(bibNAme, forCellReuseIdentifier: "MenuChildrenCategoriesTVC")
        childListView.separatorStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK START{MHIOS-554}
    @IBAction func expandBtnAction(_ sender: UIButton) {
        menuSubCategoriesDelegate?.expandChildCategories(tag: indexValue!,section: sectionValue!)
    }
    //MARK START{MHIOS-1319}
    func setData(data:ChildExpandModel,data2:MenuModel,lastItem:Int)
    //MARK END{MHIOS-1319}
    {
        self.childCategoriesArray.removeAll()
        if data2.childrenData.isEmpty
        {
            expandBtnView.isHidden = true
            bottomDivider.isHidden = true
            //MARK START{MHIOS-1319}
            subCategoryLbl.font = AppFonts.LatoFont.Regular(13)
            //MARK END{MHIOS-1319}
        }
        else
        {
            expandBtnView.isHidden = false
            //MARK START{MHIOS-1319}
            if indexValue == lastItem
            {
                bottomDivider.isHidden = true
            }
            else
            {
                bottomDivider.isHidden = !data.selection[indexValue!]
            }
            //MARK END{MHIOS-1319}
            let buttonStyleText = data.selection[indexValue!] ? "negative_icon.png" : "add_icon.png"
            
            subCategoryLbl.font = data.selection[indexValue!] ? AppFonts.LatoFont.Bold(13) : AppFonts.LatoFont.Regular(13)
            ///expandBtnView.setTitle("\(buttonStyleText)", for: .normal)
            expandBtnView.setImage(UIImage(named: "\(buttonStyleText)"), for: .normal)
            self.childCategoriesArray = data2.childrenData
            self.childListView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return childCategoriesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuChildrenCategoriesTVC", for: indexPath) as! MenuChildrenCategoriesTVC
        //MARK START{MHIOS-1260}
        if childCategoriesArray.count > indexPath.row
        {
            cell.childCategoryLbl.text = childCategoriesArray[indexPath.row].name.uppercased() //"indexPath.row"
        }
        else
        {
            cell.childCategoryLbl.text = ""
        }
        //MARK END{MHIOS-1260}
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECT")
        menuSubCategoriesDelegate?.openPLPPage(category_id: "\(childCategoriesArray[indexPath.item].id)", roomtite: childCategoriesArray[indexPath.item].name.uppercased())
    }
    //MARK END{MHIOS-554}
}
