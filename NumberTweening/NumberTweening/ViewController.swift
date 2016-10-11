//
//  ViewController.swift
//  NumberTweening
//
//  Created by Michał Szyszka on 10.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit
import NumberTweeningLibrary

class ViewController: UIViewController {

    var numberView: NTNumber!
    
    @IBAction func onIncreaseTouched(_ sender: UIButton) {
        numberView.increase()
    }
    
    @IBOutlet weak var mainContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainContainer.setNeedsLayout()
        mainContainer.layoutIfNeeded()
        
        let configuration = NTNumberConfiguration()
        configuration.color = UIColor(colorLiteralRed: Float(1), green: Float(1), blue: Float(1), alpha: Float(0.5)).cgColor
        configuration.lineWidth = 3
        
        numberView = NTNumber(frame: CGRect(x: 0, y: 0, width: mainContainer.bounds.width, height: mainContainer.bounds.height), configuration: configuration)
        numberView.backgroundColor = UIColor.clear
        
        numberView.setValue(toDisplay: 9)
        mainContainer.addSubview(numberView)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

