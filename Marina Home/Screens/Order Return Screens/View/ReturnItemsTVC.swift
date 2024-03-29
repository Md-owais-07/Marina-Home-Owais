//
//  ReturnItemsTVC.swift
//  Marina Home
//
//  Created by Sooraj R on 25/07/23.
//
////MARK START{MHIOS-1142}
///qty showing lable change in UI
/////MARK END{MHIOS-1142}
//////////MARK START{MHIOS-1215}
///Changed the  productDefault image to product_placeholder_img in UI side
/////MARK END{MHIOS-1215}

import UIKit
import DropDown
class ReturnItemsTVC: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemQtyButton: UIButton!
    @IBOutlet weak var reasonField: UITextField!
    @IBOutlet weak var solutionField: UITextField!
    @IBOutlet weak var conditionField: UITextField!
    @IBOutlet weak var returnInformationView: UIView!
    //MARK START{MHIOS-1142}
    @IBOutlet weak var itemQtyLable: UILabel!
    @IBOutlet weak var itemQtyDownArrow: UIButton!
    //MARK END{MHIOS-1142}
    
    let dropDown = DropDown()
    //MARK START{MHIOS-1147}
    var reasonClosure: ((String,String)->())!
    var solutionClosure: ((String,String)->())!
    //MARK END{MHIOS-1147}
    var conditionClosure: ((String)->())!
    var qtyClosure: ((Int)->())!
    var reasonList:[Reason] = []
    var solutionList:[Solution] = []
    var maxLimit = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        conditionField.delegate = self
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        conditionClosure(textField.text ?? "")
    }

    func setData(data:returnItemsCustomModel, optionsList:[ReturnOrderInfoList]){
        reasonList = optionsList.first?.reason ?? []
        solutionList = optionsList.first?.solution ?? []
        itemTitle.attributedText = (data.item.name ?? "").htmlToAttributedString()
        maxLimit = data.item.qty_ordered ?? 1
//        if let image = data.item.media_gallery_entries?.first{
//            let url = URL(string: "\(AppInfo.shared.productImageURL)\(image.file ?? "")")!
//            itemImageView.kf.setImage(with:url.downloadURL)
//        }else{
//            itemImageView.image = UIImage(named: "productDefault")
//        }
        returnInformationView.isHidden = !data.isExpanded
        let qtyImage = UIImage(named: "down_arrow")?.withRenderingMode(.alwaysTemplate)
        //MARK START{MHIOS-1142}
        //itemQtyButton.setImage(qtyImage, for: .normal)
        itemQtyDownArrow.setImage(qtyImage, for: .normal)
        //itemQtyButton.tintColor = data.selected ? AppColors.shared.Color_black_000000 : AppColors.shared.Color_gray_9A9A9A
        itemQtyDownArrow.tintColor = data.selected ? AppColors.shared.Color_black_000000 : AppColors.shared.Color_gray_9A9A9A
        itemQtyLable.textColor = data.selected ? AppColors.shared.Color_black_000000 : AppColors.shared.Color_gray_9A9A9A
        //itemQtyButton.setTitleColor(data.selected ? AppColors.shared.Color_black_000000 : AppColors.shared.Color_gray_9A9A9A, for: .normal)
        //MARK END{MHIOS-1142}
        selectionButton.setImage(UIImage(named:data.selected ? "checkboxButton_Selected_icon" : "checkboxButton_icon"), for: .normal)
        //MARK START{MHIOS-1148 and MHIOS-1147}
        self.reasonField.text = data.reason_name
        self.solutionField.text = data.solution_name
        self.conditionField.text = data.condition
        //MARK END{MHIOS-1148 and MHIOS-1147}
    }

    @IBAction func reasonAction(_ sender: UIButton) {
        var options:[String] = []
        for item in reasonList{
            options.append(item.content ?? "")
        }
        dropDown.dataSource = options
        dropDown.anchorView = sender as! any AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { (index: Int, item: String) in //8
            self.reasonField.text = item
            //MARK START{MHIOS-1147}
            self.reasonClosure(self.reasonList[index].value ?? "",self.reasonList[index].content ?? "")
            //MARK END{MHIOS-1147}
        }
    }

    @IBAction func solutionAction(_ sender: UIButton) {
        var options:[String] = []
        for item in solutionList{
            options.append(item.content ?? "")
        }
        dropDown.dataSource = options
        dropDown.anchorView = sender as! any AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { (index: Int, item: String) in //8
            self.solutionField.text = item
            //MARK START{MHIOS-1147}
            self.solutionClosure(self.solutionList[index].value ?? "",self.solutionList[index].content ?? "")
            //MARK END{MHIOS-1147}
        }
    }

    @IBAction func changeQuantity(_ sender: Any) {
        var options:[String] = []
        for item in 0..<maxLimit{
            let selectedQty = (Int(item) ?? 1) + 1
            options.append("\(selectedQty)")
        }
        dropDown.dataSource = options
        dropDown.anchorView = sender as! any AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
                let selectedQty = (Int(item) ?? 1)
                (sender as! UIButton).setTitle("Quantity: \(selectedQty)", for: .normal) //9
                self?.qtyClosure(selectedQty)
            }
    }
}
