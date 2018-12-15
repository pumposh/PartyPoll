//
//  JoinGameVC.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 11/2/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import UIKit
import Firebase

class JoinGameVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var gameCodeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    let defaults = UserDefaults.standard
    var ref = Database.database().reference()
    var handle: DatabaseHandle!
    
    var displayName = ""
    var colorID = "0"
    var uid = "000"
    var gameCode: NSString = ""
    var gameCodeFound: Bool = false
    var keyboardHeight: CGFloat = 0
    var isUnique: Bool = false
    var currentGame: DataSnapshot = DataSnapshot.init()
    var allGames: DataSnapshot = DataSnapshot.init()

    
    override func viewDidLoad() {
        let continueButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        continueButton.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        continueButton.setTitle("continue", for: .normal)
        continueButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        continueButton.addTarget(self, action: #selector(self.continueButtonPressed), for: .touchUpInside)
        continueButton.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir", size: 17.0).withFamily("Avenir").withFace("Heavy"), size: 17.0)
        gameCodeTextField.inputAccessoryView = continueButton
        
        gameCodeTextField.delegate = self
        self.displayName = self.defaults.string(forKey: "name") ?? ""
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9386781887, green: 0.9518757931, blue: 0.9419775898, alpha: 1)
    }
    
    @objc func continueButtonPressed(_ sender: Any) {
        handle = ref.observe(DataEventType.value, with: {(snapshot) in
            self.allGames = snapshot.childSnapshot(forPath: "Running Games")
        })
        perform(#selector(checkForGameCode), with: nil, afterDelay: 0.5)
    }
    
    @objc func checkForGameCode() {
        if allGames.childrenCount > 0 {
            var iterCheck = 0
            for gameNode in allGames.children.allObjects as! [DataSnapshot] {
                let gameCodeCheck = gameNode.key as String
                if self.gameCodeTextField.hasText && gameCodeCheck == self.gameCodeTextField.text {
                    self.gameCode = self.gameCodeTextField.text! as NSString
                    self.defaults.set(self.gameCodeTextField.text, forKey: "currentGameCode")
                    self.currentGame = gameNode
                }
                else{
                    iterCheck = iterCheck + 1
                }
            }
            if iterCheck == allGames.childrenCount {
                self.errorLabel.isHidden = false
            } else {
                self.initializePlayer()
                self.exit()
            }
        }
    }
    
    func exit() {
        self.gameCodeTextField.resignFirstResponder()
        self.defaults.synchronize()
        self.performSegue(withIdentifier: "joinLobby", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.gameCodeTextField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gameCodeTextField.becomeFirstResponder()
        super.viewWillAppear(true)
    }
    
    func initializePlayer() {
        self.colorID = randomStringWithLength(len: 1) as String
        self.uid = randomStringWithLength(len: 3) as String
        
        while (!isUnique) {
            var identifier: UInt = 0
            self.colorID = self.randomStringWithLength(len: 1) as String
            self.uid = self.randomStringWithLength(len: 3) as String
            for player in currentGame.childSnapshot(forPath: "Players").children.allObjects as! [DataSnapshot] {
                if self.colorID != player.childSnapshot(forPath: "color").value as! String && self.uid != player.key {
                    identifier = identifier + 1
                }
            }
            if identifier == currentGame.childSnapshot(forPath: "Players").childrenCount {
                isUnique = true
            }
        }

        //Push player stats
        let player = [
            "displayname": displayName,
            "score":  "0",
            "color": colorID,
            "ready":   "0"
        ]
        self.defaults.set(displayName, forKey: "name")
        self.defaults.set(colorID, forKey: "color")
        self.defaults.set(uid, forKey: "uid")
        self.defaults.set(gameCode, forKey: "currentGameCode")
        
        print("Pushing " + displayName + " to game: " + (gameCode as String))
        self.ref.child("Running Games").child(gameCode as String).child("Players").child(uid).setValue(player)
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let vals : NSString = "123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 1...len{
            let length = UInt32 (vals.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", vals.character(at: Int(rand)))
        }
        
        return randomString
    }
}
