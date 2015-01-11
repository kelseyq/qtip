//
//  NewTipViewController.swift
//  qtip
//
//  Created by Kelsey Gilmore-Innis on 1/10/15.
//  Copyright (c) 2015 Kelsey Gilmore-Innis. All rights reserved.
//

import UIKit

class NewTipViewController: UIViewController {
    @IBOutlet weak var newTip: UITextField!
    var newTipValue: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "doneSegue" {
            newTipValue = newTip.text._bridgeToObjectiveC().doubleValue
        }
    }

}
