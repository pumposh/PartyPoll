//
//  LobbyVC.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 12/3/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import UIKit
import Firebase

class LobbyVC: UIViewController {
    var displayName = ""
    var colorID = "0"
    var uid = "000"
    var gameCode: NSString = ""
    var ref: DatabaseReference = Database.database().reference()
    var handle: DatabaseHandle!
    let defaults = UserDefaults.standard
    var lobby: DataSnapshot = DataSnapshot.init()
    var displayStack: [String: LobbyPlayerStackView] = [:]
    var allPlayersReady: Bool = false
    
    @IBOutlet weak var gameCodeDisplay: UIButton!
    
    @IBOutlet weak var leftStack: UIStackView!
    @IBOutlet weak var rightStack: UIStackView!
    
    override func viewDidLoad() {
        syncLobby()
        super.viewDidLoad()
        leftStack.frame.size.height = 0
        rightStack.frame.size.height = 0
        pullFromDefaults()
        self.view.backgroundColor = #colorLiteral(red: 0.9386781887, green: 0.9518757931, blue: 0.9419775898, alpha: 1)
        gameCodeDisplay.setTitle(gameCode as String, for: .normal)
    }
    @IBOutlet weak var errorLabel: UILabel!
    
    func syncLobby() {
        handle = ref.observe(DataEventType.value, with: {(snapshot) in
            self.lobby = DataSnapshot.init()
            self.rightStack.frame.size.height = 55
            self.leftStack.frame.size.height = 55
            self.lobby = snapshot.childSnapshot(forPath: self.gameCode as String)
            self.clearPlayers()
            self.displayPlayers()
            self.readyCheck()
            self.ref.child(self.gameCode as String).child(self.uid).onDisconnectRemoveValue()
            if (self.lobby.childrenCount < 1) {
                self.ref.child(self.gameCode as String).onDisconnectRemoveValue()
            }
        })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = disconnectFunc()
    }
    
    func disconnectFunc () -> Bool{
        ref.child(gameCode as String).child(uid).removeValue()
        if (lobby.childrenCount < 1) {
            ref.child(gameCode as String).removeValue()
        }
        return true
    }
    
    @IBOutlet weak var readyButton: UIButton!
    @IBAction func readyButtonPressed(_ sender: Any) {
        if lobby.childSnapshot(forPath: uid).childSnapshot(forPath: "ready").value as! String == "0" {
            ref.child(gameCode as String).child(uid).child("ready").setValue("1")
            readyButton.alpha = 0.7
        } else {
            ref.child(gameCode as String).child(uid).child("ready").setValue("0")
            readyButton.alpha = 1.0
        }
    }
    
    func readyCheck() {
        if (lobby.childrenCount > 0) {
            var readyCount = 0
            for player in lobby.children.allObjects as! [DataSnapshot] {
                if player.childSnapshot(forPath: "ready").value as! String == "1" {
                    readyCount = readyCount + 1
                }
            }
            if (lobby.childrenCount >= 3) {
                self.errorLabel.isHidden = true
            }
            if readyCount == lobby.childrenCount {
                if (lobby.childrenCount >= 3) {
                    self.performSegue(withIdentifier: "letsPlay", sender: nil)
                }
                else
                {
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    
    func pullFromDefaults() {
        self.gameCode = self.defaults.string(forKey: "currentGameCode")! as NSString
        self.uid = self.defaults.string(forKey: "uid")!
        self.displayName = self.defaults.string(forKey: "name")!
        self.colorID = self.defaults.string(forKey: "color")!
    }
    
    @objc func displayPlayers() {
        if (lobby.childrenCount > 0) {
            var enumerate = 0
            for player in lobby.children.allObjects as! [DataSnapshot] {
                enumerate = enumerate + 1
                print(player.key)
                displayStack[player.key] = LobbyPlayerStackView()
                displayStack[player.key]!.customizeView(playerName: player.childSnapshot(forPath: "displayname").value as! String, colorID: player.childSnapshot(forPath: "color").value as! String, ready: player.childSnapshot(forPath: "ready").value as! String, uid: player.key)
                if (enumerate % 2 == 1) {
                    leftStack.addArrangedSubview(displayStack[player.key]!)
                    leftStack.frame.size.height = leftStack.frame.size.height + 70
                    print(leftStack.frame.size.height)
                }
                else {
                    rightStack.addArrangedSubview(displayStack[player.key]!)
                    rightStack.frame.size.height = rightStack.frame.size.height + 70
                    print(leftStack.frame.size.height)
                }
            }
        }
    }
    
    @objc func clearPlayers() {
        for subview in leftStack.subviews {
            subview.removeFromSuperview()
        }
        for subview in rightStack.subviews {
            subview.removeFromSuperview()
        }
    }
}
