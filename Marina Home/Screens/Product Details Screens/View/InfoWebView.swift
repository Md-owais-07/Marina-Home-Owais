//
//  InfoWebView.swift
//  Marina Home
//
//  Created by codilar on 01/02/24.
//
//MARK: START MHIOS-1182

import UIKit
import WebKit

protocol InfoDelegate {
    func closeInfoView()
}


class InfoWebView: UIView,WKUIDelegate {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var btnBack: UIButton!
    var urlString:String?
    var ScreenTitle:String? = ""
    var delegate : InfoDelegate?
    var spinner = UIActivityIndicatorView(style: .medium)
    var loadingView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("InfoWebView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        
    }
     func setUpUI() {

        self.lblTitle.text = self.ScreenTitle
        sendRequest(urlString: self.urlString ?? "")
        self.webView.navigationDelegate = self

    }
  
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.webView.load(URLRequest(url: URL(string:"about:blank")!))
        self.delegate?.closeInfoView()
    }
    
    private func sendRequest(urlString: String) {
        self.showActivityIndicator()
        let myURL = URL(string: urlString)
        if(myURL != nil)
        {
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
       
    }

    
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
            self.loadingView.center = self.center
            self.loadingView.backgroundColor = UIColor.clear
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            self.spinner = UIActivityIndicatorView(style: .medium)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)

            self.loadingView.addSubview(self.spinner)
            self.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
    
    
}
extension InfoWebView: WKNavigationDelegate {
    internal func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint("didCommit")
    }

    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("didFinish")
        self.hideActivityIndicator()

    }

    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("didFail")
    }
}
//MARK: START MHIOS-1182
