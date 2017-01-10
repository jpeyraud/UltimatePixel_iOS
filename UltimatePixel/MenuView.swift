//
//  MenuView.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 08/01/2017.
//  Copyright © 2017 Altarrys. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    override func layoutSubviews() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "menuBackground.png")
        //backgroundColor = UIColor(patternImage: UIImage(named: "menuBackground.png")!)
        //insertSubview(backgroundImage, at: 0)
    }
}
