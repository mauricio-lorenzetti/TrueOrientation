//
//  ViewController.swift
//  TrueOrientation
//
//  Created by Mauk on 13/02/18.
//  Copyright © 2018 Mauricio Lorenzetti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var to:TrueOrientation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        to = TrueOrientation(whenOrientationChanges: orientationDidChanged)
    }
    
    private func orientationDidChanged() {
        if self.label.text == "mudou" {
            self.label.text = "voltou"
        } else {
            self.label.text = "mudou"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

