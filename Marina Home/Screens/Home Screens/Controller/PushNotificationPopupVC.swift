//
//  PushNotificationPopupVC.swift
//  Marina Home
//
//  Created by codilar on 06/12/23.
//
// Mark MHIOS-710

// PushNotificationPopupVC added in PLP.storyboard

import UIKit

class PushNotificationPopupVC: UIViewController {

    //MARK: START MHIOS-1304
    @IBOutlet weak var img_bg: UIImageView!
    //MARK: END MHIOS-1304
    @IBOutlet weak var textMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnMaybeLater: AppPrimaryButton!
    @IBOutlet weak var btnNotify: AppPrimaryButton!
    //MARK: START MHIOS-1246
    @IBOutlet weak var viewNotification: UIView!
    var pushData : PushData?
    //MARK: END MHIOS-1246
    @IBOutlet weak var top: NSLayoutConstraint!
    var onDoneBlock : ((Bool) -> Void)?

    let underLineTextAttribute: [NSAttributedString.Key: Any] = [
          .font: AppFonts.LatoFont.Bold(13),
          .foregroundColor: UIColor.white,
          .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushPermissionReceived(notification:)), name: Notification.Name("PushPermissionReceive"), object: nil)
        setUpUI()
    }
    
    func setUpUI()
    {
       
        //MARK: START MHIOS-1246
        self.lblTitle.text = self.pushData?.title
        let htmlData = NSString(string: self.pushData?.description ?? "").data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html]
        let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                  options: options,
                                                                  documentAttributes: nil)
        
        self.lblDescription.attributedText = attributedString
        self.textMessage.text = self.pushData?.message
        //MARK: START MHIOS-1304
        let placeholderImage = UIImage(named: "push_bg.png")
        self.img_bg.image = placeholderImage
        let urlString = "\(AppInfo.shared.pushImageURL)/\(self.pushData?.image ?? "")"
        let url = URL(string: urlString)
        if let imageUrl = url
        {
            self.img_bg.kf.setImage(with: imageUrl, placeholder: placeholderImage, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.img_bg.image =  value.image
                case .failure(let error):
                    self.img_bg.image =  placeholderImage
                    print("Image loading failed with error: \(error)")
                }
            }
        }
        //MARK: END MHIOS-1304
        self.viewNotification.alpha = 1.0
        //MARK: END MHIOS-1246
        self.btnClose.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)

        let attributeString = NSMutableAttributedString(
                string: "MAY BE LATER",
                attributes: underLineTextAttribute
             )
        btnMaybeLater.setAttributedTitle(attributeString, for: .normal)
        viewNotification.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [unowned self] in
            UIView.animate(withDuration: 0.3)
            {
                self.viewNotification.alpha = 1
                self.top.constant = 0
                self.view.layoutIfNeeded()
               
            }
        })
       
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25,delay: 0.3, animations: { [unowned self] in
            self.btnClose.transform = CGAffineTransform.identity
        })
    }
    func closePopUp()
    {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                self.btnClose.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
            }, completion: { [unowned self]_ in
                onDoneBlock!(true)
                self.dismiss(animated: true)
            })
        }
        
    }
    @IBAction func onClickClose(_ sender: Any) {
        
        UserData.shared.pushPermission = true
        closePopUp()
       
    }
    @objc func pushPermissionReceived(notification: Notification) {
       
        UserData.shared.pushPermission = true
        NotificationCenter.default.removeObserver(self, name: Notification.Name("PushPermissionReceive"), object: nil)
        closePopUp()
    }
    
    @IBAction func onClickNotifyMe(_ sender: Any) {
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.openPushPopup()

    }
    
    @IBAction func onClickMayBeLater(_ sender: Any) {
        UserData.shared.pushPermission = true
        closePopUp()
    }
    
}
//Mark MHIOS-710
