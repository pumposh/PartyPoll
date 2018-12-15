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
    
    //Variables for local access
    var displayName = ""
    var colorID = "0"
    var uid = "000"
    var gameCode: NSString = ""
    var ref: DatabaseReference = Database.database().reference()
    var handle: DatabaseHandle!
    let defaults = UserDefaults.standard
    var lobbySnapshot: DataSnapshot = DataSnapshot.init()
    var allDeckInfoSnapshot: DataSnapshot = DataSnapshot.init()
    var lobbyDecksSnapshot: DataSnapshot = DataSnapshot.init()
    var displayStack: [String: LobbyPlayerStackView] = [:]
    var deckStack: [String: DeckViewCell] = [:]
    var playerAllowedDecks: [String]!
    var lobbyDecks: [String:String]!
    var allPlayersReady: Bool = false
    
    @IBOutlet weak var gameCodeDisplay: UIButton!
    
    @IBOutlet weak var deckScrollSuperView: UIView!
    @IBOutlet weak var deckScrollView: DeckScrollView!
    @IBOutlet weak var leftStack: UIStackView!
    @IBOutlet weak var rightStack: UIStackView!
    
    override func viewDidLoad() {
        syncLobby()
        super.viewDidLoad()
        deckScrollSuperView.layer.cornerRadius = 8.0
        deckScrollSuperView.layer.masksToBounds = true
        leftStack.frame.size.height = 0
        rightStack.frame.size.height = 0
        pullFromDefaults()
        self.updateLobbyDecks()
        self.view.backgroundColor = #colorLiteral(red: 0.9386781887, green: 0.9518757931, blue: 0.9419775898, alpha: 1)
        gameCodeDisplay.setTitle(gameCode as String, for: .normal)
    }
    @IBOutlet weak var errorLabel: UILabel!
    
    func syncLobby() {
        handle = ref.observe(DataEventType.value, with: {(snapshot) in
            self.lobbySnapshot = DataSnapshot.init()
            self.allDeckInfoSnapshot = DataSnapshot.init()
            self.rightStack.frame.size.height = 55
            self.leftStack.frame.size.height = 55
            self.lobbySnapshot = snapshot.childSnapshot(forPath: "Running Games").childSnapshot(forPath: self.gameCode as String)
            self.allDeckInfoSnapshot = snapshot.childSnapshot(forPath: "Decks")
            self.lobbyDecksSnapshot = self.lobbySnapshot.childSnapshot(forPath: "Enabled Decks")
            //self.updateLobbyDecks()
            self.deckScrollView.clearDecks()
            self.deckScrollView.displayDecks(allDecks: self.allDeckInfoSnapshot)
            self.clearPlayers()
            self.displayPlayers()
            self.readyCheck()
            
            if (self.lobbySnapshot.childSnapshot(forPath: "Players").childrenCount <= 1) {
                self.ref.child("Running Games").child(self.gameCode as String).onDisconnectRemoveValue()
            } else {
                self.ref.child("Running Games").child(self.gameCode as String).child("Players").child(self.uid).onDisconnectRemoveValue()
            }
        })
    }
    
    //To renew cards for player disconnect
    var cardRenewal = true
    
    func updateLobbyDecks() {
        var playerAllowedDecks = self.defaults.value(forKey: "allowedDecks") as? [String : String]
        
        for playerAllowedDeck in playerAllowedDecks!.keys {
            for lobbyDeck in lobbyDecksSnapshot.children.allObjects as! [DataSnapshot] {
                if playerAllowedDeck == lobbyDeck.key && playerAllowedDecks![playerAllowedDeck] != "restricted" && cardRenewal == true {
                ref.child("Running Games").child(gameCode as String).child("Enabled Decks").child(lobbyDeck.key).setValue(playerAllowedDecks![playerAllowedDeck])
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = disconnectFunc()
    }
    
    func disconnectFunc () -> Bool{
        cardRenewal = false
        
        if (lobbySnapshot.childSnapshot(forPath: "Players").childrenCount <= 1) {
            ref.child("Running Games").child(gameCode as String).child("Enabled Decks").removeValue()
            ref.child("Running Games").child(gameCode as String).removeValue()
        } else {
        ref.child("Running Games").child(gameCode as String).child("Players").child(uid).removeValue()
        }
        
        return true
    }
    
    @IBOutlet weak var readyButton: UIButton!
    @IBAction func readyButtonPressed(_ sender: Any) {
        if lobbySnapshot.childSnapshot(forPath: "Players").childSnapshot(forPath: uid).childSnapshot(forPath: "ready").value as! String == "0" {
            ref.child("Running Games").child(gameCode as String).child("Players").child(uid).child("ready").setValue("1")
            readyButton.alpha = 0.7
        } else {
            ref.child("Running Games").child(gameCode as String).child("Players").child(uid).child("ready").setValue("0")
            readyButton.alpha = 1.0
            self.errorLabel.isHidden = true
        }
    }
    
    func readyCheck() {
        if (lobbySnapshot.childSnapshot(forPath: "Players").childrenCount > 0) {
            var readyCount = 0
            for player in lobbySnapshot.childSnapshot(forPath: "Players").children.allObjects as! [DataSnapshot] {
                if player.childSnapshot(forPath: "ready").value as! String == "1" {
                    readyCount = readyCount + 1
                }
            }
            if (lobbySnapshot.childrenCount >= 3) {
                self.errorLabel.isHidden = true
            }
            if readyCount == lobbySnapshot.childSnapshot(forPath: "Players").childrenCount {
                if (lobbySnapshot.childrenCount >= 3) {
                    self.performSegue(withIdentifier: "letsPlay", sender: nil)
                }
                else
                {
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    
    var dimView: UIView!
    var deckStackBackground: UIView!
    var decksStackLabel: UILabel!
    var deckButtons: UIView!
    
    func updateDeckView() {
        deckButtons = UIView(frame: CGRect(x: self.view.frame.size.width/2-125, y: self.view.frame.size.height/2 - 200, width: 250, height: 65))
        deckButtons.alpha = 0
        
        dimView = UIView(frame: self.view.frame)
        dimView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dimView.alpha = 0
        
        decksStackLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-112.5, y: self.view.frame.size.height/2-187, width: 225, height: 45))
        decksStackLabel.text = "decks"
        decksStackLabel.textAlignment = .center
        decksStackLabel.alpha = 0
        decksStackLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir", size: 30.0).withFamily("Avenir").withFace("Heavy"), size: 30.0)
        decksStackLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        deckStackBackground = UIView(frame: CGRect(x: self.view.frame.size.width/2-125, y: self.view.frame.size.height/2 - 200, width: 250, height: 65))
        deckStackBackground.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        deckStackBackground.alpha = 0
        deckStackBackground.layer.cornerRadius = 8.0
        deckStackBackground.clipsToBounds = true
        self.addDeckSubview()
    }
    
    func addDeckSubview() {
        for deckToDisplay in allDeckInfoSnapshot.children.allObjects as! [DataSnapshot] {
            self.deckButtons.addSubview(deckStack[deckToDisplay.key]!)
        }
    }
    
    @objc func deckPressed(sender: DeckViewCell!) {
        switch(sender.deckIsSwitchedOn){
        case false:
            print("change to enabled")
            sender.deckIsSwitchedOn = true
            ref.child("Running Games").child(self.gameCode as String).child("Enabled Decks").child(sender.deck.key).setValue("enabled")
        case true:
            print("change to enabled")
            sender.deckIsSwitchedOn = false
            print("change to disabled")
            ref.child("Running Games").child(self.gameCode as String).child("Enabled Decks").child(sender.deck.key).setValue("disabled")
        default:
            print("default")
        }
    }
    
    @IBAction func decksButtonPressed(_ sender: Any) {
        self.view.addSubview(dimView)
        
        let dimViewTapped = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap))
        dimView.addGestureRecognizer(dimViewTapped)
        
        deckStackBackground.frame = CGRect(x: self.view.frame.size.width/2-125, y: self.view.frame.size.height/2 - 200, width: 250, height: 65)
        self.view.addSubview(deckStackBackground)

        self.view.addSubview(decksStackLabel)

        self.view.addSubview(deckButtons)
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.dimView.alpha = 0.3
                        self.deckStackBackground.alpha = 1
                        self.decksStackLabel.alpha = 1
                        self.deckButtons.alpha = 1
                        
                        for deck in self.allDeckInfoSnapshot.children.allObjects as! [DataSnapshot] {
                            self.deckStack[deck.key]?.alpha = 1
                        }
        })
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.dimView.alpha = 0
                        self.deckStackBackground.alpha = 0
                        self.decksStackLabel.alpha = 0
                        self.deckButtons.alpha = 0
                        for deck in self.allDeckInfoSnapshot.children.allObjects as! [DataSnapshot] {
                            self.deckStack[deck.key]?.alpha = 0
                        }
        })
        
        self.view.willRemoveSubview(dimView)
        self.view.willRemoveSubview(deckStackBackground)
        self.view.willRemoveSubview(decksStackLabel)
        self.view.willRemoveSubview(deckButtons)
        
        for deck in self.allDeckInfoSnapshot.children.allObjects as! [DataSnapshot] {
            self.view.willRemoveSubview(self.deckStack[deck.key]!)
        }
    }
    
    func pullFromDefaults() {
        self.gameCode = self.defaults.string(forKey: "currentGameCode")! as NSString
        self.uid = self.defaults.string(forKey: "uid")!
        self.displayName = self.defaults.string(forKey: "name")!
        self.colorID = self.defaults.string(forKey: "color")!
        
        var lobbyDecks: [String] = []
        for lobbyDeck in self.defaults.object(forKey: "allowedDecks") as! [String:String] {
            lobbyDecks.append(lobbyDeck.key)
        }
        
        self.playerAllowedDecks = lobbyDecks
    }
    
    @objc func displayPlayers() {
        if (lobbySnapshot.childSnapshot(forPath: "Players").childrenCount > 0) {
            var enumerate = 0
            for player in lobbySnapshot.childSnapshot(forPath: "Players").children.allObjects as! [DataSnapshot] {
                enumerate = enumerate + 1
                print(player.key)
                displayStack[player.key] = LobbyPlayerStackView()
                print(player.childSnapshot(forPath: "displayname").value!)
                displayStack[player.key]!.customizeView(playerName: player.childSnapshot(forPath: "displayname").value as! String, colorID: player.childSnapshot(forPath: "color").value as! String, ready: player.childSnapshot(forPath: "ready").value as! String, uid: player.key)
                if (enumerate % 2 == 1) {
                    leftStack.addArrangedSubview(displayStack[player.key]!)
                    leftStack.frame.size.height = leftStack.frame.size.height + 70
                }
                else {
                    rightStack.addArrangedSubview(displayStack[player.key]!)
                    rightStack.frame.size.height = rightStack.frame.size.height + 70
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
