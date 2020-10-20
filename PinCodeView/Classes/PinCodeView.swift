//
//  PinCodeView.swift
//  PinCodeView
//
//  Created by Виталий Сероштанов on 16.09.2020.
//

import UIKit

public protocol SVPinCodeViewDelegate : AnyObject {
    func didEnterCode(code: String)
}



@available(iOS 11.0, *)

@IBDesignable public class SVPinCodeView: UIControl {

    fileprivate var spaceSize : CGFloat = 1
    fileprivate var imputViewSize : CGFloat = 0
    
    /*
     according by apple doc:
     'If you use a custom input view for a security code input text field, iOS cannot display the necessary AutoFill UI.'
     it's reason to use hidden UItextField here (
     */
    
    
    fileprivate var textField : UITextField!
    @IBInspectable public var numberOfSymbols : Int = 4
    @IBInspectable public var imputViewColor : UIColor = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1)
    @IBInspectable public var symbolColor : UIColor = UIColor.init(red: 255/255.0, green: 168/255.0, blue: 18/255.0, alpha: 1)
    @IBInspectable public var underlineColor : UIColor = UIColor.init(red: 123/255.0, green: 207/255.0, blue: 218/255.0, alpha: 1)
    @IBInspectable public var underlineSize : CGFloat = 3
    @IBInspectable public var corners : CGFloat = 9
    @IBInspectable public var font : UIFont = UIFont.boldSystemFont(ofSize: 16)
    @IBInspectable public var symbolSize : CGFloat = 16
    @IBInspectable public var code : String = ""
    
    public weak var delegate : SVPinCodeViewDelegate?
    public var keyboardType: UIKeyboardType = .numberPad
    public var smartQuotesType: UITextSmartQuotesType = .yes
    override public func draw(_ rect: CGRect) {
        self.calculateSizes(rect: rect)
        self.drawViews()
        self.addTarget(self, action: #selector(touchvent), for: .touchDown)
        if self.textField == nil {
            self.textField = UITextField.init(frame: .zero)

        }
        self.addSubview(self.textField)
        self.textField.keyboardType = .numberPad
        self.textField.delegate = self
        if #available(iOS 12.0, *) {
            self.textField.textContentType = .oneTimeCode
        }
    }

     @objc fileprivate func touchvent() {
        self.textField.becomeFirstResponder()
    }

    func reset() {
        self.code = ""
        self.setNeedsDisplay()
    }
    
    
    fileprivate func calculateSizes(rect: CGRect) {
        let spacesCount = numberOfSymbols - 1
        let maxSizeByVertical = rect.height
        let maxSizeByHorisontal = (rect.width - (CGFloat(spacesCount) * spaceSize)) / CGFloat(numberOfSymbols)
        self.imputViewSize = min(maxSizeByVertical, maxSizeByHorisontal)
        self.spaceSize = (rect.width - (self.imputViewSize * CGFloat(numberOfSymbols))) / CGFloat(spacesCount)
    }
    
    fileprivate func  drawViews() {
        
        for i in 0 ..< numberOfSymbols {
            /// background
            let space : CGFloat = (i == 0) ? 0 : spaceSize
            let x = (CGFloat(i) * imputViewSize) + (CGFloat(i) * space)
            let rect = CGRect.init(x: x, y: 0, width: imputViewSize, height: imputViewSize)
            let path = UIBezierPath.init(roundedRect: rect, cornerRadius: corners)
            self.imputViewColor.setFill()
            path.fill()
            
            /// underline
            
            let underlineRect = CGRect.init(x: x + corners, y: imputViewSize - underlineSize, width: imputViewSize - (corners * 2), height: underlineSize)
            let underlinePath = UIBezierPath.init(roundedRect: underlineRect, cornerRadius: 0)
            if i < code.count {
                symbolColor.setFill()
            } else {
                underlineColor.setFill()
            }
            underlinePath.fill()
            
            // symbol
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            let newFont = font.withSize(symbolSize)
            print(newFont)
            paragraphStyle.alignment = .center
            let attributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle: paragraphStyle,
                .font: newFont,
                .foregroundColor: symbolColor
            ]
            let symbol = code[i]
            let attributed = NSAttributedString.init(string: symbol, attributes: attributes)
            let symbolRamge = CGRect.init(x: x + corners, y: (imputViewSize - symbolSize) / 2 - underlineSize, width: imputViewSize - (corners * 2), height: symbolSize)
            attributed.draw(in: symbolRamge)
        }
    }
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public override var canBecomeFirstResponder: Bool {return true}
}



@available(iOS 11.0, *)
extension SVPinCodeView : UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var trimming = ""
        if let raw = textField.text {
            let work = NSMutableString.init(string: raw)
            work.replaceCharacters(in: range, with: string)
            trimming = work as String
            trimming = trimming.replacingOccurrences(of: " ", with: "")
        }
        
        if trimming.count > self.numberOfSymbols {return false}
        
        textField.text = trimming
        self.code = trimming
        self.delegate?.didEnterCode(code:self.code)
        self.setNeedsDisplay()
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setNeedsDisplay()
        return textField.resignFirstResponder()
    }
}
