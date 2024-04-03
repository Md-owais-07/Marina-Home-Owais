//
//  HomePdpVC.swift
//  Marina Home
//
//  Created by Mohammad Owais on 02/04/24.
//

import UIKit

class HomePdpVC: AppUIViewController {
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backActionLink(crossBtn)
        favouriteBtn.layer.cornerRadius = favouriteBtn.frame.size.width / 2
        shareBtn.layer.cornerRadius = shareBtn.frame.size.width / 2
        cartButton.layer.cornerRadius = 5
    }

}
