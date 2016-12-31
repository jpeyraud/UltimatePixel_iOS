//
//  PixelCell.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 30/12/2016.
//  Copyright © 2016 Altarrys. All rights reserved.
//

import UIKit

@IBDesignable
class PixelCell: UICollectionViewCell {
    
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
        
        layer.cornerRadius = layer.frame.height / 4
        clipsToBounds = true
    }
    
}
