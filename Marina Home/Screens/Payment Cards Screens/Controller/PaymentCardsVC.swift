//
//  PaymentCardsVC.swift
//  Marina Home
//
//  Created by Eljo on 18/07/23.
//

import UIKit

class PaymentCardsVC: AppUIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var noDataView: UIView!
    var paymentCardsArray:[PaymentCardModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       
        backActionLink(backButton)
        self.listingTable.delegate = self
        self.listingTable.dataSource = self
        self.listingTable.register(UINib(nibName: "PaymentCardTVC", bundle: nil), forCellReuseIdentifier: "PaymentCardTVC_id")
        getSavedCards()
    }

    @IBAction func addCardAction(_ sender: UIButton) {
        let popUpVC = AppController.shared.addPaymentCard
        popUpVC.modalTransitionStyle = .crossDissolve
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.savedClosure = {
            self.tabBarController?.hideTabBar(isHidden: true)
            self.getSavedCards()
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
    }

    @objc func deleteCardAction(_ sender: UIButton) {
        let popUpVC = AppController.shared.paymentCardDelete
        popUpVC.modalTransitionStyle = .crossDissolve
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.card = paymentCardsArray[sender.tag]
        popUpVC.deleteClosure = {
            self.getSavedCards()
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(popUpVC, animated: false, completion: nil)
     }

    func getSavedCards(){
        self.apiGetPaymentCards(){ response in
            DispatchQueue.main.async {
                print(response)
                self.paymentCardsArray = response
                self.noDataView.isHidden = !self.paymentCardsArray.isEmpty
                self.listingTable.reloadData()
            }
        }
    }

    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentCardsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = paymentCardsArray[indexPath.item]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCardTVC_id", for: indexPath) as? PaymentCardTVC else { return UITableViewCell() }
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(deleteCardAction), for: .touchUpInside)
        /*if cellData.type == "visa"||cellData.type == "VI" {
            cell.cardTypeImage.image = UIImage(named:"visa")
        }
        else  if cellData.type == "master"{
            cell.cardTypeImage.image = UIImage(named:"master")
        }
        else {
            cell.cardTypeImage.image = UIImage(named:"visa")
        }*/
        cell.cardEndingLbl.text = cellData.maskedCC ?? ""
        cell.expiryDateLbl.text = cellData.expirationDate ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
