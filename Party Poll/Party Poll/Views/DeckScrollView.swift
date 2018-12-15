//
//  DeckScrollView.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 12/13/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import UIKit
import Firebase

class DeckScrollView: UIScrollView {

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 8.0
    }
    
    func clearDecks() {
        
    }
    
    func displayDecks(allDecks: DataSnapshot) {
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
