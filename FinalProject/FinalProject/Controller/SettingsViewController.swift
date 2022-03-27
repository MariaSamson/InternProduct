//
//  SettingsViewController.swift
//  FinalProject
//
//  Created by Maria Andreea on 18.03.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    static var setting : Int?
    @IBOutlet weak var segmentedSettings: UISegmentedControl!
    @IBAction func settingsButton(_ sender: UISegmentedControl){
        SettingsViewController.setting = segmentedSettings.selectedSegmentIndex
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
