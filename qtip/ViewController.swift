//
//  ViewController.swift
//  qtip
//
//  Created by Kelsey Gilmore-Innis on 1/6/15.
//  Copyright (c) 2015 Kelsey Gilmore-Innis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var defaults = NSUserDefaults.standardUserDefaults()
    var tipPercentages = [Double]()
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        
        tipPercentages = defaults.arrayForKey("tip_percentages") as [Double]
        for (index, tip) in enumerate(tipPercentages) {
            tipControl.setTitle(String(format: "%.2f%%", tip), forSegmentAtIndex: index)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onEditingChanged(sender: AnyObject) {
        var billAmount = billField.text._bridgeToObjectiveC().doubleValue
        var tipPercentages = defaults.arrayForKey("tip_percentages") as [Double]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        var tip = billAmount * (tipPercentage / 100)
        var total = billAmount + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tipPercentages = defaults.arrayForKey("tip_percentages") as [Double]
        tipControl.removeAllSegments()
        for (index, tip) in enumerate(tipPercentages) {
            tipControl.insertSegmentWithTitle(String(format: "%.2f%%", tip), atIndex: index, animated:false)
        }
    }

    
}

