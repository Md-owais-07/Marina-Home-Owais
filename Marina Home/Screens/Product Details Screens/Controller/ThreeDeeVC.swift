//
//  ThreeDeeVC.swift
//  Marina Home
//
//  Created by Eljo on 25/08/23.
//

import UIKit
import WebKit
import QuickLook
import AVFoundation
import Foundation

struct ScriptMessage: Codable {
let type: String
let realityFilePath: String
    let name: String
}
class ThreeDeeVC: AppUIViewController,
                  WKScriptMessageHandler, WKUIDelegate, QLPreviewControllerDataSource {
    @IBOutlet var threeDeeView: UIView!
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    var thrreDeeUrl:NSString = ""
    var previewController = QLPreviewController()
    var downloadedFilePath: URL?
    var downloadURL:String = ""
    ///private var wkWebView: WKWebView!
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: START MHIOS-1225
        CrashManager.shared.log("WebView Screen with url:\(downloadURL)")
        //MARK: END MHIOS-1225
        previewController.dataSource = self
        self.setupWKWebview()
        self.openWebView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideActivityIndicator(uiView: self.view)
    }
    
    public func setupWKWebview() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height+72
        let frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height-statusBarHeight)
        self.wkWebView = WKWebView(frame: frame , configuration: self.getWKWebViewConfiguration())

            self.wkWebView.uiDelegate = self

            self.wkWebView.navigationDelegate = self
        self.wkWebView.allowsBackForwardNavigationGestures = true
           
        self.threeDeeView.addSubview(self.wkWebView)
        }
   

    public func openWebView() {

   

    print("SANTHOSH URL : \(self.downloadURL)")

        if let url = URL(string: self.downloadURL) {

    self.wkWebView.load(URLRequest(url: url))

    }

    }

    public func getWKWebViewConfiguration() -> WKWebViewConfiguration {

        let userController = WKUserContentController()

                // call back handler for webView Javascript

                userController.add(self, name: "avataarCallBack")

                let configuration = WKWebViewConfiguration()

                configuration.userContentController = userController
    

                configuration.allowsInlineMediaPlayback = true

                configuration.mediaTypesRequiringUserActionForPlayback = []

                return configuration
        

   

    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

            guard let bodyString = message.body as? String, let bodyData = bodyString.data(using: .utf8) else { return }

            if let bodyStruct = try? JSONDecoder().decode(ScriptMessage.self, from: bodyData) {

                print("inside", bodyStruct.realityFilePath)

                switch(bodyStruct.type) {

                    case "realityFile":

                        // getting realityfile path

                        print("inside", bodyStruct.realityFilePath, bodyStruct.name)
                    self.showActivityIndicator(uiView: self.view)
                        downloadAndPreviewFile(realityFilePath: bodyStruct.realityFilePath, name: bodyStruct.name)

                    default:

                        print("Unsupported message")

                }

            }

        }

    func downloadAndPreviewFile(realityFilePath: String, name: String) {

            let url = URL(string: realityFilePath)!

            print("inside download!")

            

            // start loader....

            // Create a URLSession to download the file

            let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in

                if let localURL = localURL {

                    // Save the downloaded file to a local path

                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                    let destinationURL = documentsURL.appendingPathComponent(name)

                    

                    do {

                        try FileManager.default.removeItem(at: destinationURL)

                    } catch {

                        print("remving file error")

                    }

                    

                    do {

                        try FileManager.default.moveItem(at: localURL, to: destinationURL)

                    

                        self.downloadedFilePath = destinationURL

                        print(destinationURL)

                        // Present the Quick Look preview controller

                        DispatchQueue.main.async {
                            self.hideActivityIndicator(uiView: self.view)
                            self.previewController = QLPreviewController()
                            self.previewController.dataSource = self
                            self.navigationController!.present(self.previewController, animated: true, completion: nil)

                        }

                        

                    } catch {

                        print("Error moving file: \(error)")

                    }

                }

                // stop loading....

            }

            task.resume()

        }



    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {

    return downloadedFilePath != nil ? 1 : 0

    }

    @IBAction func back(_ sender: Any) {
        //self.dismiss(animated: true)
        self.navigationController?.presentedViewController?.dismiss(animated: false)
        self.navigationController?.popViewController(animated: false)
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index:

    Int) -> QLPreviewItem {

    return downloadedFilePath! as QLPreviewItem

    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ThreeDeeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            //wkWebView.constant = webView.scrollView.contentSize.height
        }
    }
}
