//
//  PaymentCardDeleteVC.swift
//  Marina Home
//
//  Created by Eljo on 19/07/23.
//

import UIKit

class PaymentCardDeleteVC: AppUIViewController {
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var cancelButton: AppBorderButton!
    @IBOutlet weak var deleteButton: AppBorderButton!
    @IBOutlet weak var messageLbl: UILabel!

    var card:PaymentCardModel?
    var deleteClosure: (()->())!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.hideTabBar(isHidden:false)
        self.backActionDismissLink(cancelButton)
        self.backActionDismissLink(crossButton)
        deleteButton.setTitleColor(AppColors.shared.Color_red_FF0000, for: .normal)
        deleteButton.layer.borderColor = AppColors.shared.Color_red_FF0000.cgColor
        if let cardDetails = card{
            messageLbl.text = "Are you sure about deleting the card ending in \(cardDetails.maskedCC ?? "")?"
        }
    }
    override func viewDidDisappear(_ animated: Bool)  {
        self.tabBarController?.hideTabBar(isHidden: true)
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        self.apiDeletePaymentCardDetails(key: card?.public_hash ?? ""){ response in
            DispatchQueue.main.async {
                print(response)
                self.toastView(toastMessage: "Details deleted successfully!",type: "success")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.deleteClosure()
                    self.dismiss(animated: true)
                })
            }
        }
    }

}
