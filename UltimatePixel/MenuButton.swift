//
//  File.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 28/12/2016.
//  Copyright © 2016 Altarrys. All rights reserved.
//

import UIKit

@IBDesignable
class MenuButton: UIButton {
  
        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = borderWidth
            }
        }
        //Normal state bg and border
        @IBInspectable var normalBorderColor: UIColor? {
            didSet {
                layer.borderColor = normalBorderColor?.cgColor
            }
        }
        
        @IBInspectable var normalBackgroundColor: UIColor? {
            didSet {
                setBgColorForState(color: normalBackgroundColor, forState: .normal)
            }
        }
    
        //Highlighted state bg and border
        @IBInspectable var highlightedBorderColor: UIColor?
        
        @IBInspectable var highlightedBackgroundColor: UIColor? {
            didSet {
                setBgColorForState(color: highlightedBackgroundColor, forState: .highlighted)
            }
        }
        
        private func setBgColorForState(color: UIColor?, forState: UIControlState){
            if color != nil {
                setBackgroundImage(UIImage.imageWithColor(color: color!), for: forState)
                
            } else {
                setBackgroundImage(nil, for: forState)
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            layer.cornerRadius = layer.frame.height / 2
            clipsToBounds = true
            
            if borderWidth > 0 {
                if state == .normal && layer.borderColor != normalBorderColor?.cgColor {
                    layer.borderColor = self.normalBorderColor?.cgColor
                } else if state == .highlighted && highlightedBorderColor != nil{
                    layer.borderColor = highlightedBorderColor?.cgColor
                }
            }
        }
        
    }
    
    //Extension Required by RoundedButton to create UIImage from UIColor
    extension UIImage {
        class func imageWithColor(color: UIColor) -> UIImage {
            let rect = CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: 1, height: 1)
            )
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 1.0)
            color.setFill()
            UIRectFill(rect)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
}
