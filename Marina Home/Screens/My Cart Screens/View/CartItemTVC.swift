//
//  CartItemTVC.swift
//  Marina Home
//
//  Created by Codilar on 16/05/23.
//

//MARK START{MHIOS-1020 and MHIOS-1090}
//the UI side added a only left item lable
//MARK End{MHIOS-1020 and MHIOS-1090}

import UIKit
import DropDown
import McPicker
protocol ProductCartDelegate {
    func changeQuantity(tag:Int ,quantity:Int,sku:String)
}
class CartItemTVC: UITableViewCell {
    let dropDown = DropDown()
   
    var productDelegate : ProductCartDelegate?
    @IBOutlet var btnQuantity: UIButton!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet weak var cartImg: UIImageView!
    @IBOutlet weak var btnMoveToWishlist: UIButton!
    @IBOutlet weak var downArrowView: UIImageView!
    @IBOutlet weak var stockStatusView: UILabel!
    //MARK START{MHIOS-1020 and MHIOS-1090}
    @IBOutlet var leftQtyLbl: UILabel!
    //MARK END{MHIOS-1020 and MHIOS-1090}
    
    //MARK START{MHIOS-1030}
    @IBOutlet weak var warningMsgLable: UILabel!
    @IBOutlet weak var warningMsgMainView: UIView!
    @IBOutlet weak var warningMsgAction: UIButton!
    //MARK END{MHIOS-1030}
    
    
    var skuValue:String?
    var availableQuantity:Int = 0
    var indexValue:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK START{MHIOS-1030}
//    @IBAction func warningMsgViewAction(_ sender: UIButton) {
//        
//    }
    //MARK END{MHIOS-1030}

    @IBAction func changeQuantity(_ sender: Any) {
        let indexValueTemp = indexValue
        if(self.availableQuantity>0)
        {
            let customLabel = UILabel()
            customLabel.textAlignment = .center
            customLabel.textColor = .white
            customLabel.font = UIFont(name:AppFontLato.regular, size: 20)!
            var options:[String] = []
            for i in 1...self.availableQuantity {
                options.append("\(i)")
            }
            let data: [[String]] = [options]
            let picker = McPicker(data: data)
            picker.label = customLabel
            picker.toolbarButtonsColor = .white
            picker.toolbarBarTintColor = .black
            picker.pickerBackgroundColor = .black
            picker.backgroundColor = .gray
            picker.backgroundColorAlpha = 0.50
            let selectedQty = Int((lblQuantity.text ?? "1").replacingOccurrences(of: "Quantity: ", with: "")) ?? 1
            if(selectedQty < self.availableQuantity)
            {
                picker.pickerSelectRowsForComponents = [
                    0: [(selectedQty - 1): true]
                ]
            }
            else
            {
                picker.pickerSelectRowsForComponents = [
                    0: [0: true]
                ]
            }
            picker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
                if let name = selections[0] {
                    self?.productDelegate?.changeQuantity(tag: indexValueTemp, quantity:Int(name) ?? 0 , sku: String(self?.skuValue ?? ""))
                }
            }, cancelHandler: {
                print("Canceled Styled Picker")
            }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
                let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
                print("Component \(componentThatChanged) changed value to \(newSelection)")
            })
            
            
            
            
            /*dropDown.dataSource =
             dropDown.anchorView = sender as! any AnchorView //5
             dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
             dropDown.show() //7
             dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
             guard let _ = self else { return }
             //self?.lblQuantity.text = "Quantity: \(item)"
             //(sender as! UIButton).setTitle("Quantity: \(item)", for: .normal) //9
             self?.productDelegate?.changeQuantity(tag: self?.tag ?? 0, quantity:Int(item) ?? 0 , sku: String(self?.skuValue ?? ""))
             }*/
        }
    }
}
