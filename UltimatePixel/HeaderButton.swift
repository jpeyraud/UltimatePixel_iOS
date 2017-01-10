//
//  HeaderButton.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 08/01/2017.
//  Copyright © 2017 Altarrys. All rights reserved.
//

import UIKit

@IBDesignable
class HeaderButton: UIButton {
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: layer.cornerRadius).cgPath;
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0);
        layer.shadowRadius = 2.0;
        layer.shadowOpacity = 1.0;
        layer.masksToBounds = false;
    }
    
    
}

