//
//  ViewController.swift
//  tips
//
//  Created by Doan Cong Toan on 5/11/16.
//  Copyright © 2016 toanqri. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var billLabelFade: UILabel!
    @IBOutlet weak var tipLabelFade: UILabel!
    @IBOutlet weak var totalLabelFade: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        
        self.billLabelFade.alpha = 0
        self.tipLabelFade.alpha = 0
        self.totalLabelFade.alpha = 0
        self.tipLabel.alpha = 0
        self.totalLabel.alpha = 0
        
        // initial title for label
        billField.placeholder = NSNumberFormatter().currencySymbol
        tipLabel.text = formatCurrency(0.00)
        totalLabel.text = formatCurrency(0.00)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        billField.text = userDefaults.stringForKey("savedAmount")
        tipLabel.text = userDefaults.stringForKey("savedTip")
        totalLabel.text = userDefaults.stringForKey("savedTotal")
        tipControl.selectedSegmentIndex = userDefaults.integerForKey("savedSelectedIndex")
        
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        
        updateCalculation()
        
        // get saved tip percentages
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var lowTip = userDefaults.doubleForKey("low_tip")
        var mediumTip = userDefaults.doubleForKey("medium_tip")
        var highTip = userDefaults.doubleForKey("high_tip")
        
        if userDefaults.stringForKey("low_tip") == nil {
            lowTip = 0.15
            userDefaults.setDouble(lowTip, forKey: "low_tip")
        }
        if userDefaults.stringForKey("medium_tip") == nil {
            mediumTip = 0.20
            userDefaults.setDouble(mediumTip, forKey: "medium_tip")
        }
        if userDefaults.stringForKey("high_tip") == nil {
            highTip = 0.25
            userDefaults.setDouble(highTip, forKey: "high_tip")
        }
        userDefaults.synchronize()
        
        tipControl.setTitle("\(lround(lowTip * 100))%", forSegmentAtIndex: 0)
        tipControl.setTitle("\(lround(mediumTip * 100))%", forSegmentAtIndex: 1)
        tipControl.setTitle("\(lround(highTip * 100))%", forSegmentAtIndex: 2)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        
        UIView.animateWithDuration(1.5, animations: {
            self.billLabelFade.alpha = 1
            self.tipLabelFade.alpha = 1
            self.totalLabelFade.alpha = 1
            self.tipLabel.alpha = 1
            self.totalLabel.alpha = 1
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
        
        let amount = billField.text
        let tip = tipLabel.text
        let total = totalLabel.text
        let selectedIndex = tipControl.selectedSegmentIndex
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(amount, forKey: "savedAmount")
        userDefaults.setObject(tip, forKey: "savedTip")
        userDefaults.setObject(total, forKey: "savedTotal")
        userDefaults.setInteger(selectedIndex, forKey: "savedSelectedIndex")
        
        userDefaults.synchronize()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateCalculation()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func updateCalculation() {
        var tipPercentages = [0.15, 0.20, 0.22]
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let lowTip = userDefaults.doubleForKey("low_tip")
        let mediumTip = userDefaults.doubleForKey("medium_tip")
        let highTip = userDefaults.doubleForKey("high_tip")
        
        if lowTip > 0.0 && mediumTip > 0.0 && highTip > 0.0 {
            tipPercentages = [lowTip, mediumTip, highTip]
        }
        
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        tipLabel.text = formatCurrency(tip)
        totalLabel.text = formatCurrency(total)
    }
    
    func formatCurrency(amount: Double) -> String {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale.currentLocale()
        return currencyFormatter.stringFromNumber(amount as NSNumber)!
    }
}

