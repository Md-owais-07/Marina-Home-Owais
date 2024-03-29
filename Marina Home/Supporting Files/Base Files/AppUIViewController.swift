//
//  AppUIViewController.swift
//  Marina Home
//
//  Created by Codilar on 12/04/23.
//

import UIKit
import SkeletonView

class AppUIViewController: UIViewController, UITextFieldDelegate {
    
    var indicatorActiveCount = 0
    var loadingView: UIView!
    let transitionDuration = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func startAnim(view:UIView)
    {
        view.skeletonCornerRadius = 10
        view.isSkeletonable = true
        let gradient = SkeletonGradient(baseColor: SkeletonAppearance.default.tintColor)
        view.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(transitionDuration))
        view.showAnimatedSkeleton()
    }
    
    func stopAnim(view:UIView)
    {
        view.hideSkeleton(transition: .crossDissolve(transitionDuration))
    }
    
    public func formatNumberToThousand(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? ""
    }
    
    public func formatNumberToThousandsDecimal(number: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        if (number.truncatingRemainder(dividingBy: 1.0) != 0) {
            numberFormatter.minimumFractionDigits = 2
        }
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))
        return formattedNumber ?? ""
    }
    
    func checkSpecialPrice(specialPrice:String, specialToDate:String, specialFromDate:String) -> Bool {
        var status = false
        let specialCleanPrice = specialPrice.replacingOccurrences(of: ",", with: "")
        var price = 0.0
        if let doubleValue = Double(specialCleanPrice) {
            price = doubleValue
        }
        if(price <= 0) {
            return status
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let fromDate = dateFormatter.date(from: specialFromDate)
        let toDate = dateFormatter.date(from: specialToDate)
        let dateFormatter_new = DateFormatter()
        dateFormatter_new.timeZone = TimeZone(identifier: "Asia/Dubai")
        dateFormatter_new.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let current_date = dateFormatter_new.string(from: Date())
        let currentDate = dateFormatter.date(from: current_date)
        if let fromDate = fromDate, let toDate = toDate {
            if fromDate <= currentDate! && currentDate! <= toDate {
                status = true
            }
        } else if let fromDate = fromDate {
            if fromDate <= currentDate! {
                status = true
            }
        } else if (specialToDate == "" && specialFromDate == "") {
            status = true
        }
        
        return status
    }

    @objc func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func backRootAction(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    @objc func backActiondismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func backActionLink(_ button: UIButton) {
        button.addTarget(self, action: #selector(self.backAction), for: UIControl.Event.touchUpInside)
    }
    func backToRootLink(_ button: UIButton) {
        button.addTarget(self, action: #selector(self.backRootAction), for: UIControl.Event.touchUpInside)
    }

    func backActionDismissLink(_ button: UIButton) {
        button.addTarget(self, action: #selector(self.backActiondismiss(_:)), for: UIControl.Event.touchUpInside)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func checkMailIdFormat(string: String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: string)
    }

    
    func isValidPassword(password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    func convertDateFormater(date: String, neededFormat:String = "MMM dd, yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date = dateFormatter.date(from: date) else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = neededFormat
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
    }

    func getAttributedStatus(status:String,date:String)->NSMutableAttributedString{
        let blackAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFonts.LatoFont.Regular(15),
            .foregroundColor: AppColors.shared.Color_black_000000
        ]
        let grayAttributes: [NSAttributedString.Key: Any] = [
            .font: AppFonts.LatoFont.Regular(13),
            .foregroundColor: AppColors.shared.Color_gray_9A9A9A
        ]
        var attributeString = NSMutableAttributedString(
            string: status.capitalized,
            attributes: blackAttributes)
        var attributeString1 = NSMutableAttributedString(
            string: " | \(date)",
            attributes: grayAttributes)
        attributeString.append(attributeString1)
        return attributeString
    }

    func setShippingStatusText(status:String, dateString:String)->NSMutableAttributedString{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFromStr = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        return getAttributedStatus(status: status, date: timeFromDate)
    }
    
    
    func makeAddressText(addresse:Addresses) -> Int
    {
        var addressText = ""
        var street = ""
        let address2 = (addresse.region?.region ?? "") + " " + (addresse.postcode ?? "")
        for j in addresse.street!{
            street = street + j + " "
        }
        addressText = "\(street) \n\(address2)"
        let lineCount = self.calculateLineCount(text: addressText , font: AppFonts.LatoFont.Regular(13), maxWidth: UIScreen.main.bounds.width-70)
        //let cellHeight = (lineCount*16)+151
        
        return lineCount
    }
    
    func calculateLineCount(text: String?, font: UIFont, maxWidth: CGFloat) -> Int {
        guard let text = text else {
            return 0
        }
        
        let textStorage = NSTextStorage(string: text)
        let textContainer = NSTextContainer(size: CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(.font, value: font, range: NSMakeRange(0, textStorage.length))
        
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        
        while index < numberOfGlyphs {
            var lineRange = NSMakeRange(0, 0)
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return numberOfLines
    }
}

