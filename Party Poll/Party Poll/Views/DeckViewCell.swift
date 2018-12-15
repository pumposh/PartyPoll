//
//  DeckViewCell.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 12/6/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import UIKit
import Firebase

class DeckViewCell: UIButton {

    var deck: DataSnapshot!
    var deckIsSwitchedOn: Bool!
    var deckIsEnabled: Bool!
    var enabledSwitch: UIImageView!
    var gameCode: String!
    var ref: DatabaseReference = Database.database().reference()
    let colorFunc = colorIDs()

    func customizeView(deckToDisplay: DataSnapshot, lobbyAllowed: [String:String], switchedOn: Bool, gameCode: String) {
        self.gameCode = gameCode
        self.deck = deckToDisplay
        self.deckIsSwitchedOn = switchedOn
        
        print(self.frame.origin.y)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 225, height: 45)
        self.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir", size: 15.0).withFamily("Avenir").withFace("Heavy"), size: 15.0)

        enabledSwitch = UIImageView(image: (UIImage(named: "0")))
        self.setTitle("  " + (deckToDisplay.childSnapshot(forPath: "title").value as! String), for: .normal)
        
        self.deckIsEnabled = false
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.798828125)
        self.titleLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir", size: 15.0).withFamily("Avenir").withFace("Heavy"), size: 15.0)

        self.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        enabledSwitch.setImageColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        
        for allowCheck in lobbyAllowed {
            if allowCheck.key == self.deck.key {
                self.deckIsEnabled = true
                
                if (self.deckIsSwitchedOn == true) {
                    enabledSwitch = UIImageView(image: UIImage(named: "checkmark"))
                }
                else {
                    enabledSwitch = UIImageView(image: (UIImage(named: "0")))
                }
                
                self.backgroundColor = colorFunc.getColorFromID(id: deckToDisplay.key as NSString)
                self.setTitleColor(colorFunc.getTextColorFromID(id: self.deck.key as NSString), for: .normal)
                
                enabledSwitch.setImageColor(color: colorFunc.getTextColorFromID(id: self.deck.key as NSString))
            }
        }
                
        enabledSwitch.frame = CGRect(x: self.frame.origin.x+190, y: self.frame.origin.y+10, width: 25, height: 25)
        
        self.contentHorizontalAlignment = .left
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true;
        
        //self.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)

        self.addSubview(enabledSwitch)
    }
    
    @objc func pressed() {
        print(deck.childSnapshot(forPath: "title").value as! String)
//        if deckIsEnabled {
//            if deckIsSwitchedOn == true {
//                deckIsSwitchedOn = false
//                ref.child("Running Games").child(gameCode).child("Enabled Decks").child(self.deck.key).setValue("enabled")
//            } else {
//                deckIsSwitchedOn = true
//                ref.child("Running Games").child(gameCode).child("Enabled Decks").child(self.deck.key).setValue("disabled")
//            }
//        } else {
//            print("Deck is not purchased")
//        }
    }
}
