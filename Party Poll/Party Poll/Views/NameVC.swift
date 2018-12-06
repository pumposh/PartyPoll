//
//  NameVC.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 12/1/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import UIKit

class NameVC: UIViewController, UITextFieldDelegate {

    let defaults = UserDefaults.standard
    @IBOutlet weak var txtField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        txtField.delegate = self
        super.viewDidLoad()
        txtField.text = self.defaults.string(forKey: "name")
        let continueButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        continueButton.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        continueButton.setTitle("continue", for: .normal)
        continueButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        continueButton.addTarget(self, action: #selector(self.setName), for: .touchUpInside)
        continueButton.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir", size: 17.0).withFamily("Avenir").withFace("Heavy"), size: 17.0)
        txtField.inputAccessoryView = continueButton
        self.view.backgroundColor = #colorLiteral(red: 0.9386781887, green: 0.9518757931, blue: 0.9419775898, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtField.becomeFirstResponder()
        super.viewWillAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setName()
        return true
    }
    
    @objc func setName() {
        if txtField.text?.count ?? 0 > 14 {
            errorLabel.isHidden = false
        }
        else if txtField.hasText {
            txtField.resignFirstResponder()
            self.defaults.set(txtField.text?.lowercased(), forKey: "name")
            self.defaults.synchronize()
            performSegue(withIdentifier: "nameChanged", sender: nil)
        }
    }
}
