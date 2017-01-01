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
        let storyboard = UIStoryboard(name: "PlayStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PlayViewController")
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func pixels(_ sender: MenuButton) {
    }
    @IBAction func settings(_ sender: MenuButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

