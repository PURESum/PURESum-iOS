//
//  CustomTextView.swift
//  MatchingService
//
//  Created by JHKim on 2020/04/13.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextView: UITextView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var masksToBounds: Bool = true {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable var topPadding: CGFloat {
        get {
            return contentInset.top
        }
        set {
            self.contentInset = UIEdgeInsets(top: newValue,
                                             left: self.contentInset.left,
                                             bottom: self.contentInset.bottom,
                                             right: self.contentInset.right)
        }
    }

    @IBInspectable var bottomPadding: CGFloat {
        get {
            return contentInset.bottom
        }
        set {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top,
                                             left: self.contentInset.left,
                                             bottom: newValue,
                                             right: self.contentInset.right)
        }
    }

    @IBInspectable var leftPadding: CGFloat {
        get {
            return contentInset.left
        }
        set {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top,
                                             left: newValue,
                                             bottom: self.contentInset.bottom,
                                             right: self.contentInset.right)
        }
    }

    @IBInspectable var rightPadding: CGFloat {
        get {
            return contentInset.right
        }
        set {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top,
                                             left: self.contentInset.left,
                                             bottom: self.contentInset.bottom,
                                             right: newValue)
        }
    }
    
}
