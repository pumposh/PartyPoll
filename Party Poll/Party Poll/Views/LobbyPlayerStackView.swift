//
//  LobbyPlayer.swift
//  Party Poll
//
//  Created by Pumposh Bhat on 12/3/18.
//  Copyright © 2018 Pumposh/Ethan. All rights reserved.
//

import UIKit

@IBDesignable
class LobbyPlayerStackView: UIStackView {
    var text: String = ""
    var id: String = ""
    
    override func prepareForInterfaceBuilder() {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.axis = .horizontal
        self.distribution = .equalCentering
    }
    
    func customizeView(playerName: String, colorID: String, ready: String, uid: String) {
        self.id = uid
        let playerNameLabel = UILabel(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 150, height: 45))
        let colorFunc = colorIDs()
        playerNameLabel.textColor = colorFunc.getTextColorFromID(id: colorID as NSString)
        playerNameLabel.backgroundColor = colorFunc.getColorFromID(id: colorID as NSString)
        playerNameLabel.text = "  " + playerName
        text = playerName
        self.addSubview(playerNameLabel)
        playerNameLabel.contentMode = .scaleAspectFill
        playerNameLabel.layer.cornerRadius = 8.0
        playerNameLabel.layer.masksToBounds = true;
        playerNameLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir", size: 15.0).withFamily("Avenir").withFace("Heavy"), size: 15.0)
        
        var readyImg: UIImageView!
        
        if (ready == "1") {
            readyImg = UIImageView(image: UIImage(named: "checkmark"))
        }
        else {
            readyImg = UIImageView(image: UIImage(named: "0"))
        }
        
        readyImg.setImageColor(color: colorFunc.getTextColorFromID(id: colorID as NSString))
        readyImg.frame = CGRect(x: self.frame.origin.x+playerNameLabel.frame.size.width-32.5, y: self.frame.origin.y+10, width: 25, height: 25)
        readyImg.contentMode = .scaleAspectFit

        self.addSubview(readyImg)
    }
    
    func getText() -> String {
        return text
    }
    
    func getuid() -> String {
        return id
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
