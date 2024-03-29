//
//  AppWebViewVC.swift
//  Marina Home
//
//  Created by Codilar on 08/05/23.
//

import UIKit
import WebKit
class AppWebViewVC:AppUIViewController,WKUIDelegate {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    var urlString:String?
    var ScreenTitle:String? = ""
    var htmlContent:String?
    var baseGrandTotal: Double? = 0
    var orderId = ""
    var incrementId = ""
    var rference = ""
    var postpayId = ""
    var selectedTomeSlot = ""
    var isfromPayment:Bool = false
    var isfromPostpay:Bool = false
    var guestName = ""
    //MARK: START MHIOS-1281
    var guestEmail = ""
    //MARK: END MHIOS-1281

    var trasactionParam: [String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.hideTabBar(isHidden: false)
        self.lblTitle.text = self.ScreenTitle
        backActionLink(self.btnBack)
        backActionLink(self.closeBtn)
        
        if(self.isfromPayment==true)
        {
            self.btnBack.isHidden = true
            self.closeBtn.isHidden = false
        }
        else
        {
            self.btnBack.isHidden = false
            self.closeBtn.isHidden = true
        }

        //MARK: START MHIOS-1252

        if isfromPostpay
        {
            
            let configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = true
            configuration.mediaTypesRequiringUserActionForPlayback = []
            self.webView = WKWebView(frame: self.view.bounds , configuration: configuration)
            self.webView.navigationDelegate = self
            self.webView.configuration.dataDetectorTypes = [.link, .phoneNumber]
            self.view.addSubview(webView)
        }
        else
        {
            self.webView.navigationDelegate = self
            self.webView.configuration.dataDetectorTypes = [.link, .phoneNumber]
        }
        //MARK: START MHIOS-1252

        sendRequest(urlString: self.urlString ?? "")
        // Do any additional setup after loading the view.
    }
    // MARK: START MHIOS-1170
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    // MARK: END MHIOS-1170
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.hideTabBar(isHidden: true)
    }
    //    @IBAction func closeBtnAction(_ sender: UIButton) {
    //
    //        self.dismiss(animated: true, completion: nil)
    //
    //    }
    
    private func sendRequest(urlString: String) {
        self.showActivityIndicator(uiView: self.webView)
        let myURL = URL(string: urlString)
        if(myURL != nil)
        {
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
       
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url))")
        self.hideActivityIndicator(uiView: self.webView)
        if let url = webView.url?.absoluteString{
            print("success url = \(url)")
            if(self.isfromPostpay==true)
            {
                //MARK: START MHIOS-1317
                if url.contains(AppInfo.shared.checkOutPaymentFailureURL)
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                //MARK: END MHIOS-1317

                    self.postPayChekoutConfirm()
                }
            }
        }
        // MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString{
            print("success url = \(url)")
            if(self.isfromPostpay==true)
            {
                self.postPayChekoutConfirm()
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    // Mark MHIOS-1099
    func createOpenMapsOptions()
    {
        let controller = AppController.shared.openActionSheet
        controller.view.frame = self.view.frame
        self.addChild(controller)
        self.view.addSubview((controller.view)!)
        controller.didMove(toParent: self)
    }
    // Mark MHIOS-1099
}

extension AppWebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestUrl = navigationAction.request.url, requestUrl.scheme == "tel" {
            UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            
        } else if let requestUrls = navigationAction.request.url, requestUrls.scheme!.lowercased() == "mailto" {
            UIApplication.shared.open(requestUrls, options: [:], completionHandler: nil)
            // here I decide to .cancel, do as you wish
            decisionHandler(.cancel)
            return
        }
        // Mark MHIOS-1099
        else if let requestUrls = navigationAction.request.url, requestUrls.scheme!.lowercased() == "https" || requestUrls.scheme!.lowercased() == "http"{
            if requestUrls.description.contains("maps.apple.com") || requestUrls.description.contains("google.com/maps")
            {
                let urlArr = requestUrls.description.components(separatedBy: "!@#$")
                if urlArr.indices.contains(0)
                {
                    MapURLs.AppleMapLink = urlArr[0]
                }
                if urlArr.indices.contains(1)
                {
                    MapURLs.GoogleMapLink = urlArr[1]
                }
                createOpenMapsOptions()
                decisionHandler(.cancel)
                return
            }
           
            else
            {
                decisionHandler(.allow)
            }
        }
        // Mark MHIOS-1099
        else
        {
            decisionHandler(.allow)
        }
    }
    

}
