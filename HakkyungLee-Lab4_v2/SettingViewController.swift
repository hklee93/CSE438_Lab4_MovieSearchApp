//
//  SettingViewController.swift
//  HakkyungLee-Lab4_v2
//
//  Created by Hakkyung on 2018. 10. 22..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var thePicker: UIPickerView!
    @IBOutlet weak var searchSwitch: UISwitch!
    
    var languageSet: [String] = []
    var selected:String = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        languageSet = ["Chinese", "English", "Korean", "Spanish"]
        thePicker.delegate = self
        thePicker.dataSource = self
        thePicker.selectRow(1, inComponent: 0, animated: true)
        
        self.title = "Settings"
        searchSwitch.setOn(false, animated: false)
    }
    
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        
        if(sender.isOn){
            
            Lang.shared.switchVal = true
            print("Switch is on")
        }
        else{
            
            Lang.shared.switchVal = false
            print("Switch is off")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return languageSet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return languageSet[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch row{

        case 0:
            selected = "zh"
        case 1:
            selected = "en"
        case 2:
            selected = "ko"
        case 3:
            selected = "es"
        default:
            selected = "en"
        }
        
        Lang.shared.lang = selected
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
