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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.frame.height / 4
        clipsToBounds = true
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: layer.cornerRadius).cgPath;
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0);
        layer.shadowRadius = 3.0;
        layer.shadowOpacity = 1.0;
        layer.masksToBounds = false;
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
}
