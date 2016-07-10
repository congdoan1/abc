//
//  SettingsViewController.swift
//  tips
//
//  Created by Doan Cong Toan on 5/11/16.
//  Copyright © 2016 toanqri. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipEditorControl: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var lowTip = userDefaults.doubleForKey("low_tip")
        var mediumTip = userDefaults.doubleForKey("medium_tip")
        var highTip = userDefaults.doubleForKey("high_tip")
        
        if userDefaults.stringForKey("low_tip") == nil { lowTip = 0.15 }
        if userDefaults.stringForKey("medium_tip") == nil { mediumTip = 0.20 }
        if userDefaults.stringForKey("high_tip") == nil { highTip = 0.25 }
        
        tipControl.setTitle("\(lround(lowTip * 100))%", forSegmentAtIndex: 0)
        tipControl.setTitle("\(lround(mediumTip * 100))%", forSegmentAtIndex: 1)
        tipControl.setTitle("\(lround(highTip * 100))%", forSegmentAtIndex: 2)
        
        tipControl.selectedSegmentIndex = NSUserDefaults.standardUserDefaults().integerForKey("savedSelectedIndex")
        
        if tipControl.selectedSegmentIndex == 0 {
            tipEditorControl.value = Float(lround(lowTip * 100.0))
        } else if tipControl.selectedSegmentIndex == 1 {
            tipEditorControl.value = Float(lround(mediumTip * 100.0))
        } else {
            tipEditorControl.value = Float(lround(highTip * 100.0))
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        NSUserDefaults.standardUserDefaults().setInteger(tipControl.selectedSegmentIndex, forKey: "savedSelectedIndex")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTipControlSelected(sender: AnyObject) {
        var currentValue: Float = 0.0
        if tipControl.selectedSegmentIndex == 0 {
            currentValue = NSUserDefaults.standardUserDefaults().floatForKey("low_tip")
        } else if tipControl.selectedSegmentIndex == 1 {
            currentValue = NSUserDefaults.standardUserDefaults().floatForKey("medium_tip")
        } else {
            currentValue = NSUserDefaults.standardUserDefaults().floatForKey("high_tip")
        }
        
        tipEditorControl.value = Float(lroundf(currentValue * 100.0))
    }
    
    @IBAction func onTipEditorControlValueChanged(sender: AnyObject) {
        
        // update tipEditorControl title
        let newTitle = "\(lroundf(tipEditorControl.value))%"
        tipControl.setTitle(newTitle, forSegmentAtIndex: tipControl.selectedSegmentIndex)
        
        // saving new value
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let newValue = Float(lroundf(tipEditorControl.value)) / 100.0
        
        if tipControl.selectedSegmentIndex == 0 {
            userDefaults.setFloat(newValue, forKey: "low_tip")
        } else if tipControl.selectedSegmentIndex == 1 {
            userDefaults.setFloat(newValue, forKey: "medium_tip")
        } else {
            userDefaults.setFloat(newValue, forKey: "high_tip")
        }
    }
}

