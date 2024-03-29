//
//  CustomUITextfields.swift
//  Marina Home
//
//  Created by Sooraj R on 06/08/23.
//

import UIKit

class FloatingLabeledTextField: UITextField {

    var floatingLabel: UILabel!
    var bottomLine = UIView()
    var floatingLabelDefaultFrame:CGRect?
    var floatingLabelFloattedFrame:CGRect?
    var errorClosure:(()->())?
    var errorIcon = UIImageView(image: UIImage(named: "errorIcon"))
//    var errorLabel = UILabel()

    var floatingLabelFont: UIFont = UIFont(name: AppFontLato.light, size: 13) ?? UIFont.systemFont(ofSize: 13) {
        didSet {
            self.floatingLabel.font = floatingLabelFont
        }
    }

    func setDirectText(){
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.frame = self.floatingLabelFloattedFrame!
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        floatingLabelDefaultFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        floatingLabelFloattedFrame = CGRect(x: 0, y: -22, width: self.frame.width, height: self.frame.height)
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.textColor = AppColors.shared.Color_black_000000
        self.font = UIFont(name: AppFontLato.regular, size: 13) ?? UIFont.systemFont(ofSize: 13)

        floatingLabel = UILabel(frame: floatingLabelDefaultFrame!)
        floatingLabel.textColor = AppColors.shared.Color_black_000000
        floatingLabel.font = floatingLabelFont
        floatingLabel.attributedText = setAsMandatory(fullText: self.placeholder ?? "")
        self.addSubview(floatingLabel)
        self.placeholder = ""

        bottomLine.layer.backgroundColor = AppColors.shared.Color_black_000000.cgColor
        self.addSubview(bottomLine)

        self.addSubview(errorIcon)
        errorIcon.isHidden = true
//        errorLabel.textColor = AppColors.shared.Color_red_FF0000
//        errorLabel.font = UIFont(name: AppFontLato.regular, size: 13) ?? UIFont.systemFont(ofSize: 13)
//        errorLabel.text = "Invalid email address!"
//        errorLabel.textAlignment = .right
//        self.addSubview(errorLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height-5, width: self.frame.width, height: 0.75)
        errorIcon.frame = CGRect(x: self.frame.width - 24, y: (self.frame.height/2) - 12, width: 24, height: 24)
//        errorLabel.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 20)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if errorClosure != nil{
            errorIcon.isHidden = true
            bottomLine.layer.backgroundColor = AppColors.shared.Color_black_000000.cgColor
            floatingLabel.textColor = AppColors.shared.Color_black_000000
            floatingLabel.attributedText = setAsMandatory(fullText: self.floatingLabel.text ?? "")
            errorClosure!()
        }
    }

    func setErrorTheme(errorAction:@escaping ()->()){
        errorIcon.isHidden = false
        bottomLine.layer.backgroundColor = AppColors.shared.Color_red_FF0000.cgColor
        floatingLabel.textColor = AppColors.shared.Color_red_FF0000
        errorClosure = errorAction
    }

    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.floatingLabel.frame = self.floatingLabelFloattedFrame!
            }
        }
    }

    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if self.text == "" {
            UIView.animate(withDuration: 0.3) {
                self.floatingLabel.frame = self.floatingLabelDefaultFrame!
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setAsMandatory(fullText:String)->NSAttributedString{
        let HighLightAttributes: [NSAttributedString.Key: Any] = [
            .font: self.floatingLabelFont,
            .foregroundColor: AppColors.shared.Color_red_FF0000
        ]
        let Range = (fullText as NSString).range(of: "*")
        let mutableAttributedString = NSMutableAttributedString.init(string: fullText)
        mutableAttributedString.addAttributes(HighLightAttributes, range: Range)
        return mutableAttributedString
    }
}
