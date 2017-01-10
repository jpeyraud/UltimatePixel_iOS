//
//  ViewController.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 28/12/2016.
//  Copyright © 2016 Altarrys. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController {

    // MARK: Actions
    @IBAction func play(_ sender: MenuButton) {
        startPlayViewController(3, 3)
    }
    
    @IBAction func pixels(_ sender: MenuButton) {
        startPlayViewController(4, 5)
    }
    
    @IBAction func settings(_ sender: MenuButton) {
        startPlayViewController(5, 7)
    }
    
    func startPlayViewController(_ itemPerLine: Int, _ line:Int) {
        let storyboard = UIStoryboard(name: "PlayStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        controller.gameEngine.itemPerLine = itemPerLine
        controller.gameEngine.line = line
        self.present(controller, animated: true, completion: nil)
    }
}
