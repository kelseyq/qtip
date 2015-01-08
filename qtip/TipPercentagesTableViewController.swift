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

    override func viewDidLoad() {
        super.viewDidLoad()
                
        tips = defaults.arrayForKey("tip_percentages") as [Double]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

       self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        cell.textLabel?.text = "\(tips[indexPath.row])"

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
            tips.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var tipToMove = tips[fromIndexPath.row]
        tips.removeAtIndex(fromIndexPath.row)
        tips.insert(tipToMove, atIndex: toIndexPath.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
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
                dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(!editing) {
           dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

    @IBAction func startEditing(sender: AnyObject) {
        self.editing = !self.editing
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.setObject(tips, forKey: "tip_percentages")
        defaults.synchronize()
    }

    
}
