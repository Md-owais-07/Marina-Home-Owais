//
//  ErrorPopupVC.swift
//  Marina Home
//
//  Created by santhosh t on 31/10/23.
////MARK START{MHIOS-1005}
/// Crated a class ErrorPopupVC and the UI also
/////MARK END{MHIOS-1005}

import UIKit

class ErrorPopupVC: AppUIViewController {

    
    @IBOutlet weak var contentBGView: UIView!
    @IBOutlet weak var tryAgainBtnView: AppPrimaryButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lableAView: UILabel!
    @IBOutlet weak var lableBView: UILabel!
    //MARK START{MHIOS-1005}
    @IBOutlet weak var backBtnView: UIButton!
    @IBOutlet weak var backToHomeView: AppBorderButton!
    var regularText = ""
    var boldText = ""
    var textBValue = ""
    //MARK END{MHIOS-1005}
    var retryActionClosure: (()->())!
    var type:Int = 0
    var statusCode:Int = 0
    let inetReachability = InternetReachability()!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK START{MHIOS-1005}
        setData(initialLoad: true)
        //MARK END{MHIOS-1005}
    }
    //MARK START{MHIOS-1227}
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("noInternetBackActivty"), object: nil)
    }
    //MARK END{MHIOS-1227}
    //MARK START{MHIOS-1005}
    func setData(initialLoad:Bool)
    {
        DispatchQueue.main.async {
            self.tryAgainBtnView.isHidden = false
        }
        
        let status = Network.isAvailable()
        if status == false
        {
            //MARK START{MHIOS-1272}
            DispatchQueue.main.async {
                self.tryAgainBtnView.isEnabled = false
            }
            //MARK END{MHIOS-1272}
            //MARK: START MHIOS-1202&1203
            //MARK START{MHIOS-1277}
            self.backToHomeView.isHidden = true
            self.backBtnView.isHidden = true
            self.imageView.isHidden = false
            self.lableAView.isHidden = false
            self.lableBView.isHidden = false
            //MARK END{MHIOS-1277}
            regularText = "your connection seems off…"
            boldText = "Oops,"
            //MARK: END MHIOS-1202&1203
            textBValue = "Please check your internet connection and try again"
            imageView.image = UIImage(named: "no_internet_icon.png")
            tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
            let attributedText = NSMutableAttributedString(string: "\(boldText) \(regularText)")
            // Apply bold style to the boldText
            attributedText.addAttribute(.font, value: AppFonts.LatoFont.Bold(15), range: NSRange(location: 0, length: regularText.count))
            // Apply regular style to the regularText
            attributedText.addAttribute(.font, value: AppFonts.LatoFont.Regular(15), range: NSRange(location: boldText.count + 1, length: regularText.count))
            lableAView.attributedText = attributedText
            lableBView.text = textBValue
            checkInternetAndServerStatus()
            
        }
        else
        {
            apiStatusCheck(initialLoad: initialLoad)
        }
    }
    //MARK END{MHIOS-1005}
    func validateTheStatus(initialLoad:Bool)
    {
        
        if statusCode == 200
        {
            if initialLoad
            {
                regularText = "Something went wrong!"
                boldText = ""
                textBValue = "Oops! It seems like something went wrong. We apologize for the inconvenience"
                imageView.image = UIImage(named: "nknown_error.png")
                //tryAgainBtnView.setTitle("BACK TO HOME", for: .normal)
                tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
                backToHomeView.isHidden = false
                backBtnView.isHidden = false
                imageView.isHidden = false
                lableAView.isHidden = false
                lableBView.isHidden = false
            }
            else
            {
                dismiss(completion: {
                    self.retryActionClosure()
                })
            }
        }
        else
        {
            boldText = "We are currently undergoing maintenance,"
            regularText = "\n & will be back online shortly!"
            textBValue = "We are performing scheduled maintenance to enhance your experience with Marina Home."
            DispatchQueue.main.async {
                self.backToHomeView.isHidden = true
                self.backBtnView.isHidden = true
                self.imageView.isHidden = false
                self.lableAView.isHidden = false
                self.lableBView.isHidden = false
                self.imageView.image = UIImage(named: "maintenance_icon.png")
                self.tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
            }
        }
        
        let attributedText = NSMutableAttributedString(string: "\(boldText) \(regularText)")
        // Apply bold style to the boldText
        attributedText.addAttribute(.font, value: AppFonts.LatoFont.Bold(15), range: NSRange(location: 0, length: boldText.count))
        // Apply regular style to the regularText
        attributedText.addAttribute(.font, value: AppFonts.LatoFont.Regular(15), range: NSRange(location: boldText.count + 1, length: regularText.count))
        DispatchQueue.main.async {
            self.lableAView.attributedText = attributedText
            self.lableBView.text = self.textBValue
        }
    }
    //MARK START{MHIOS-1005}
    func setDataAgain()
    {
        var regularText = ""
        var boldText = ""
        var textBValue = ""
        DispatchQueue.main.async {
            self.tryAgainBtnView.isHidden = false
        }
        
        let status = Network.isAvailable()
        if status == false
        {
            //MARK START{MHIOS-1272}
            DispatchQueue.main.async {
                self.tryAgainBtnView.isEnabled = false
            }
            //MARK END{MHIOS-1272}
            //MARK START{MHIOS-1277}
            self.backToHomeView.isHidden = true
            self.backBtnView.isHidden = true
            self.imageView.isHidden = false
            self.lableAView.isHidden = false
            self.lableBView.isHidden = false
            //MARK END{MHIOS-1277}
            //MARK: START MHIOS-1202&1203
            regularText = "your connection seems off…"
            boldText = "Oops,"
            //MARK: END MHIOS-1202&1203
            textBValue = "Please check your internet connection and try again"
            imageView.image = UIImage(named: "no_internet_icon.png")
            tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
            checkInternetAndServerStatus()
        }
        else
        {
            
            switch statusCode {
            case 0:
                //Server Error section
                //MARK START{MHIOS-1277}
                self.backToHomeView.isHidden = true
                self.backBtnView.isHidden = true
                self.imageView.isHidden = false
                self.lableAView.isHidden = false
                self.lableBView.isHidden = false
                //MARK END{MHIOS-1277}
                //MARK: START MHIOS-1202&1203
                regularText = "your connection seems off…"
                boldText = "Oops,"
                //MARK: END MHIOS-1202&1203
                textBValue = "Please check your internet connection and try again"
                imageView.image = UIImage(named: "no_internet_icon.png")
                tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
                checkInternetAndServerStatus()
                break
            case 404:
                //Server Error section
                //MARK: START MHIOS-1202&1203
                regularText = "Page not found!"
                boldText = "Oops,"
                //MARK: END MHIOS-1202&1203
                textBValue = "Sorry, the page or resource you’re looking for cannot be found"
                imageView.image = UIImage(named: "server_error.png")
                //tryAgainBtnView.setTitle("BACK TO HOME", for: .normal)
                tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
                break
            case 200:
                dismiss(completion: {
                    //self.retryActionClosure()
                })
                break
            case 503:
                //maintenance section
                //tryAgainBtnView.isHidden = true
                regularText = "We are currently undergoing maintenance,"
                boldText = "\n & will be back online shortly!"
                textBValue = "We are performing scheduled maintenance to enhance your experience with Marina Home."
                imageView.image = UIImage(named: "maintenance_icon.png")
                tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
                break
            default:
                print("default")
                //Unknown Error section
                regularText = "Something went wrong!"
                boldText = ""
                textBValue = "Oops! It seems like something went wrong. We apologize for the inconvenience"
                imageView.image = UIImage(named: "nknown_error.png")
                //tryAgainBtnView.setTitle("BACK TO HOME", for: .normal)
                tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
            }
        }
        //MARK: START MHIOS-1225

        CrashManager.shared.log("ErrorPopupVC_Title: \(boldText) \(regularText),Message:\(textBValue)")
        
        //MARK: START MHIOS-1225
        
        //MARK: START MHIOS-1225

        CrashManager.shared.log("ErrorPopupVC_Title: \(boldText) \(regularText),Message:\(textBValue)")
        
        //MARK: START MHIOS-1225
        
        let attributedText = NSMutableAttributedString(string: "\(boldText) \(regularText)")
        // Apply bold style to the boldText
        attributedText.addAttribute(.font, value: AppFonts.LatoFont.Bold(15), range: NSRange(location: 0, length: regularText.count))
        // Apply regular style to the regularText
        attributedText.addAttribute(.font, value: AppFonts.LatoFont.Regular(15), range: NSRange(location: boldText.count + 1, length: regularText.count))
        lableAView.attributedText = attributedText
        lableBView.text = textBValue
    }
    //MARK END{MHIOS-1005}
    func checkInternetAndServerStatus() {
        let status = Network.isAvailable()
        if status
        {
            dismiss(completion: {
                self.retryActionClosure()
            })
            print("SANTHOSH INTERNET NET ON")
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Code to execute after a 2-second delay
                self.checkInternetAndServerStatus()
            }
            print("SANTHOSH INTERNET NET OFFFF")
        }
    }
    
    
    func tryAgainFunc()
    {
        switch type {
        case 0:
            //No Internet section
            //MARK START{MHIOS-1120}
            //checkInternetAndServerStatus()
            //MARK END{MHIOS-1120}
            break
        case 404:
            //Server Error section
//            dismiss(completion: {
//               self.retryActionClosure()
//            })
            apiStatusCheck(initialLoad: false)
            break
        case 200:
            //Unknown Error section
            dismiss(completion: {
               ///self.retryActionClosure()
            })
            break
        case 503:
            //maintenance section
//            dismiss(completion: {
//               self.retryActionClosure()
//            })
            apiStatusCheck(initialLoad: false)
            break
        default:
            print("default")
//            dismiss(completion: {
//               self.retryActionClosure()
//            })
            apiStatusCheck(initialLoad: false)
        }
    }
    //MARK START{MHIOS-1005}
    @IBAction private func backBtnAction(_ sender: UIButton) {
        dismiss(completion: {
            //self.retryActionClosure()
        })
    }
    
    @IBAction private func backToHomeAction(_ sender: UIButton) {
        print("santhosh go to home")
//        let storyboard = UIStoryboard(name: "DashboardScreens", bundle: nil)
//        let showHomePage = storyboard.instantiateViewController(withIdentifier: "DashboardTBC_id") as! DashboardTBC
//        navigationController?.pushViewController(showHomePage, animated: true)
        
//        let vc = AppController.shared.home
//        self.present(vc, animated: true, completion: nil)
        //self.tabBarController?.selectedIndex = 0
        dismiss(completion: {
            self.retryActionClosure()
        })
        
    }
    //MARK END{MHIOS-1005}
    
    @IBAction private func tryAgainAction(_ sender: UIButton) {
       //tryAgainFunc()
        DispatchQueue.main.async {
            self.tryAgainBtnView.isHidden = false
        }
        let status = Network.isAvailable()
        if status == false
        {
            //MARK START{MHIOS-1272}
            DispatchQueue.main.async {
                self.tryAgainBtnView.isEnabled = false
            }
            //MARK END{MHIOS-1272}
            //MARK START{MHIOS-1277}
            self.backToHomeView.isHidden = true
            self.backBtnView.isHidden = true
            self.imageView.isHidden = false
            self.lableAView.isHidden = false
            self.lableBView.isHidden = false
            //MARK END{MHIOS-1277}
            //MARK: START MHIOS-1202&1203
            regularText = "your connection seems off…"
            boldText = "Oops,"
            //MARK: END MHIOS-1202&1203
            textBValue = "Please check your internet connection and try again"
            imageView.image = UIImage(named: "no_internet_icon.png")
            tryAgainBtnView.setTitle("TRY AGAIN", for: .normal)
            let attributedText = NSMutableAttributedString(string: "\(boldText) \(regularText)")
            // Apply bold style to the boldText
            attributedText.addAttribute(.font, value: AppFonts.LatoFont.Bold(15), range: NSRange(location: 0, length: regularText.count))
            // Apply regular style to the regularText
            attributedText.addAttribute(.font, value: AppFonts.LatoFont.Regular(15), range: NSRange(location: boldText.count + 1, length: regularText.count))
            lableAView.attributedText = attributedText
            lableBView.text = textBValue
            checkInternetAndServerStatus()
            
        }
        else
        {
            apiStatusCheck(initialLoad: false)
        }
    }
    
    func dismiss(completion:(()->())? = nil) {
       UIView.animate(withDuration: 0.3, animations: {
          //self.customBGView.alpha = 0
           DispatchQueue.main.async {
               //self.contentBGView.alpha = 0
               self.view.layoutIfNeeded()
           }
          
       }) { (complete) in
          if complete {
             self.dismiss(animated: false) {
                DispatchQueue.main.async {
                   completion?()
                }
             }
          }
       }
    }
    
    //MARK START{MHIOS-1005}
    func apiStatusCheck(initialLoad:Bool) {
        if Network.isAvailable() {
            self.showActivityIndicator(uiView: self.view)
            let urlString = AppInfo.shared.homeURL
            if let url = URL(string: urlString) {
                let config = URLSessionConfiguration.default
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                config.urlCache = nil
                
                let urlSession = URLSession(configuration: config).dataTask(with: url) { (data, response, error) in
                    guard let httpResponse = response as? HTTPURLResponse else {
                            self.statusCode = 404
                            self.validateTheStatus(initialLoad: initialLoad)
                            print("Invalid response")
                            return
                    }
                    self.statusCode = httpResponse.statusCode
                    DispatchQueue.main.async {
                        self.hideActivityIndicator(uiView: self.view)
                        self.validateTheStatus(initialLoad: initialLoad)
//                        if self.statusCode == 200
//                        {
//                            self.dismiss(completion: {
//                               ///self.retryActionClosure()
//                            })
//                        }
                    }
                }
                
                urlSession.resume()
            }
        }
        else
        {

        }
        
    }
    //MARK END{MHIOS-1005}
}
