//
//  PlayCollectionView.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 08/01/2017.
//  Copyright © 2017 Altarrys. All rights reserved.
//

import UIKit

class PlayBackgroundview: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable var color1: UIColor = UIColor.clear { didSet { updateColors() } }
    @IBInspectable var color2: UIColor = UIColor.clear  { didSet { updateColors() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }
    
    func configureGradient() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.type = kCAGradientLayerAxial
        updateColors()
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    private func updateColors() {
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }
}
