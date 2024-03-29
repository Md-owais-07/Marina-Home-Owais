//
//  StoredCardListingCell.swift
//  Marina Home
//
//  Created by Eljo on 01/08/23.
//

import UIKit

class StoredCardListingCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tblCards: UITableView!
    var paymentCardsArray:[PaymentCardModel] = []
    var selectedCard = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tblCards.register(UINib(nibName: "StoredCardCell", bundle: nil), forCellReuseIdentifier: "StoredCardCell")
        self.tblCards.delegate = self
        self.tblCards.dataSource = self
        self.tblCards.reloadData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentCardsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = paymentCardsArray[indexPath.item]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoredCardCell", for: indexPath) as? StoredCardCell else { return UITableViewCell() }
        cell.radio.image = UIImage(named: indexPath.item == selectedCard ? AppAssets.radioButtonSelected_icon.rawValue : AppAssets.radioButton_icon.rawValue)
        cell.lblCardNo.text = "XXXX XXXX XXXX \( cellData.maskedCC ?? "")"
        cell.lblExpDate.text = "Exp. Date: \( cellData.expirationDate ?? "")"
        //cell.imgCard.image = UIImage(named: (cellData.type ?? "") == "vi" ? "Image 405" : "Group 1526")
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCard = indexPath.item
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.selectdCard = indexPath.item
        self.tblCards.reloadData()
    }
}
