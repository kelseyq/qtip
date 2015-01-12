//
//  TipPercentagesTableViewController.swift
//  qtip
//
//  Created by Kelsey Gilmore-Innis on 1/7/15.
//  Copyright (c) 2015 Kelsey Gilmore-Innis. All rights reserved.
//

import UIKit

class TipPercentagesTableViewController: UITableViewController {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var tips = [Double]()
    var newTip: Double = 0.0
    var defaultTipIndex: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
                
        tips = defaults.arrayForKey("tip_percentages") as [Double]
        self.clearsSelectionOnViewWillAppear = true

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        defaultTipIndex = defaults.integerForKey("default_tip_index")
        var indexPath = NSIndexPath(forRow: defaultTipIndex, inSection: 0)
        selectDefault(indexPath)
    }
    
    func selectDefault(idx: Int) {
        var indexPath = NSIndexPath(forRow: idx, inSection: 0)
        selectDefault(indexPath)
    }
    
    func selectDefault(indexPath: NSIndexPath) {
        var defaultCell = self.tableView.cellForRowAtIndexPath(indexPath)
        defaultCell?.selectionStyle = UITableViewCellSelectionStyle.None
        defaultCell?.detailTextLabel?.text = "Default"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var tipPercentage = tips[indexPath.row]
        if tipPercentage == -1.0 {
            cell.textLabel?.text = "add new tip"
        } else {
            cell.textLabel?.text = String(format: "%.2f%%", tipPercentage)
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var indexToDelete = indexPath.row
            if (indexToDelete < defaultTipIndex) {
                defaultTipIndex--
            }
            tips.removeAtIndex(indexToDelete)
            if (defaultTipIndex >= (tips.count - 1)) { //includes "add new tip"
                defaultTipIndex = (tips.count - 2)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            selectDefault(defaultTipIndex)
        } else if editingStyle == UITableViewCellEditingStyle.Insert {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("newTipVC") as NewTipViewController
            let navigationController = UINavigationController(rootViewController: vc)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
            return UITableViewCellEditingStyle.Insert;
        } else {
            return UITableViewCellEditingStyle.Delete;
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var tipToMove = tips[fromIndexPath.row]
        tips.removeAtIndex(fromIndexPath.row)
        tips.insert(tipToMove, atIndex: toIndexPath.row)
        if (fromIndexPath.row == defaultTipIndex) {
            defaultTipIndex = toIndexPath.row
        } else if ((fromIndexPath.row < defaultTipIndex) &&
                   (toIndexPath.row >= defaultTipIndex)) {
            defaultTipIndex--
        } else if ((fromIndexPath.row > defaultTipIndex) &&
                    (toIndexPath.row <= defaultTipIndex)) {
            defaultTipIndex++
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !(indexPath.row == (tips.count - 1))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backFromSettings(sender: AnyObject) {
        if (self.editing) {
           self.editing = false
        } else {
           dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if (editing) {
            tips.append(-1.0)
        } else {
            tips.removeLast()
        }
        self.tableView.reloadData()
        super.setEditing(editing, animated: animated)
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.setObject(tips, forKey: "tip_percentages")
        defaults.setInteger(defaultTipIndex, forKey: "default_tip_index")
        defaults.synchronize()
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        var newTipVC = segue.sourceViewController as NewTipViewController
        newTip = newTipVC.newTipValue
        tips.insert(newTip, atIndex: tips.count - 1)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var oldDefaultPath = NSIndexPath(forRow: defaultTipIndex, inSection: 0)
        var oldCell = tableView.cellForRowAtIndexPath(oldDefaultPath)
        oldCell?.detailTextLabel?.text = " "
        selectDefault(indexPath)
        defaultTipIndex = indexPath.row
        return indexPath
    }
    
}
