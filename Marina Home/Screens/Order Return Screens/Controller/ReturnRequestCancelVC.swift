//
//  ReturnRequestCancelVC.swift
//  Marina Home
//
//  Created by Sooraj R on 27/07/23.
//

import UIKit

class ReturnRequestCancelVC: AppUIViewController {

    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var cancelButton: AppBorderButton!
    @IBOutlet weak var deleteButton: AppBorderButton!

    var deleteClosure: (()->())!
    var requestId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backActionDismissLink(cancelButton)
        self.backActionDismissLink(crossButton)
        deleteButton.setTitleColor(AppColors.shared.Color_red_FF0000, for: .normal)
        deleteButton.layer.borderColor = AppColors.shared.Color_red_FF0000.cgColor
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        //MARK: START MHIOS-1225
        CrashManager.shared.log("Return Request Cancel with values")
        CrashManager.shared.log("Request Id: \(String(describing: requestId))")
        //MARK: END MHIOS-1225

        //MARK: START MHIOS-960
        self.apiCancelRequest(parameters: ["cancel": ["request_id": requestId]], isLoggedIn: UserData.shared.isLoggedIn){ response in
            //MARK: END MHIOS-960
            DispatchQueue.main.async {
                self.toastView(toastMessage: "Return request has been cancelled successfully!",type: "success")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.deleteClosure()
                    self.dismiss(animated: true)
                })
            }
        }
    }

}
