//
//  BeginVC.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 11/13/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import UIKit
import Firebase

class BeginVC: UIViewController {
    var displayName = ""
    var colorID = "0"
    var uid = "000"
    var gameCode: NSString = ""
    var dbReference: DatabaseReference!
    var handle: DatabaseHandle!
    let defaults = UserDefaults.standard
    
    var isUnique: Bool = false
    var currentGame: DataSnapshot = DataSnapshot.init()
    var allGames: DataSnapshot = DataSnapshot.init()
    
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        dbReference = Database.database().reference()
        checkDisplayName()
        defaults.synchronize()
        self.view.backgroundColor = #colorLiteral(red: 0.9386781887, green: 0.9518757931, blue: 0.9419775898, alpha: 1)
    }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        self.gameCode = self.randomStringWithLength(len: 5)

        handle = dbReference.observe(DataEventType.value, with: {(snapshot) in
            self.allGames = snapshot
        })
        
        perform(#selector(checkCode), with: nil, afterDelay: 0.5)
        initializePlayer()
        self.defaults.synchronize()
    }
    
    @objc func checkCode() {
        var gameCodeIsUnique: Bool = false
        
        while (!gameCodeIsUnique) {
            var gameiter = 0
            self.gameCode = self.randomStringWithLength(len: 5)
            if allGames.childrenCount > 0 {
                for gameNode in allGames.children.allObjects as! [DataSnapshot] {
                    let gameCodeCheck = gameNode.key as String
                    if gameCodeCheck != self.gameCode as String {
                        gameCodeIsUnique = true
                        gameiter = gameiter + 1
                    }
                }
                if gameiter != allGames.childrenCount {
                    gameCodeIsUnique = false
                }
            }
            else {
                gameCodeIsUnique = true
            }
        }
    }
    
    func initializePlayer() {
        self.colorID = randomStringWithLength(len: 1) as String
        self.uid = randomStringWithLength(len: 3) as String
        
        while (!isUnique) {
            var identifier: UInt = 0
            self.colorID = self.randomStringWithLength(len: 1) as String
            self.uid = self.randomStringWithLength(len: 3) as String
            for player in currentGame.children.allObjects as! [DataSnapshot] {
                if self.colorID != player.childSnapshot(forPath: "color").value as! String && self.uid != player.key {
                    identifier = identifier + 1
                }
            }
            if identifier == currentGame.childrenCount {
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
        self.dbReference.child(gameCode as String).child(uid).setValue(player)
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
    
    func checkDisplayName() {
        if self.defaults.string(forKey: "name") == nil
        {
            self.displayName = ""
            print("displayName")
            performSegue(withIdentifier: "editNameSegue", sender: nil)
        }
        else //assign to label if exists
        {
            self.displayName = self.defaults.string(forKey: "name") ?? ""
        }
        
        nameLabel.text = self.displayName
        self.defaults.set(nil, forKey: "currentGameCode")
    }
}
