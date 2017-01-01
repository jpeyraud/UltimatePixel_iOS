//
//  TargetLabel.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 01/01/2017.
//  Copyright © 2017 Altarrys. All rights reserved.
//

import UIKit

@IBDesignable
class TargetLabel: UILabel {
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var normalBorderColor: UIColor? {
        didSet {
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
    }
    
}
