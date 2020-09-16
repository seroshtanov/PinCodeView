//
//  PinCodeView.swift
//  PinCodeView
//
//  Created by Виталий Сероштанов on 16.09.2020.
//

import UIKit

protocol PinCodeViewDelegate : AnyObject {
    func didEndEnterCode(code: String)
}


@IBDesignable public class PinCodeView: UIControl, UITextInputTraits {

    fileprivate var spaceSize : CGFloat = 1
    fileprivate var imputViewSize : CGFloat = 0
    fileprivate var textField : UITextField!
    @IBInspectable public var numberOfSymbols : Int = 4
    @IBInspectable public var imputViewColor : UIColor = UIColor.init(red: 244/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1)
    @IBInspectable public var symbolColor : UIColor = UIColor.init(red: 255/255.0, green: 168/255.0, blue: 18/255.0, alpha: 1)
    @IBInspectable public var underlineColor : UIColor = UIColor.init(red: 123/255.0, green: 207/255.0, blue: 218/255.0, alpha: 1)
    @IBInspectable public var underlineSize : CGFloat = 2
    @IBInspectable public var corners : CGFloat = 4
    @IBInspectable public var font : UIFont = UIFont.boldSystemFont(ofSize: 16)
    @IBInspectable public var symbolSize : CGFloat = 16
    @IBInspectable public var code : String = ""
    
    weak var delegate : PinCodeViewDelegate?
    public var keyboardType: UIKeyboardType = .decimalPad
    
    override public func draw(_ rect: CGRect) {
        self.calculateSizes(rect: rect)
        self.drawViews()
        self.addTarget(self, action: #selector(touchvent), for: .touchDown)
        
    }

     @objc fileprivate func touchvent() {
        self.becomeFirstResponder()
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
}


extension PinCodeView : UIKeyInput {
    public var hasText: Bool {
        return self.code.count > 0
    }
    
    public func insertText(_ text: String) {
        guard self.code.count < self.numberOfSymbols else {
            return
        }
        
        self.code += text
        
        if self.code.count == self.numberOfSymbols {
            self.delegate?.didEndEnterCode(code: text)
        }
        self.setNeedsDisplay()
    }
    
    public func deleteBackward() {
        guard self.code.count > 0 else {
            return
        }
        
        self.code.removeLast()
        self.setNeedsDisplay()
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
}
