//
//  WhackSlot.swift
//  Project14
//
//  Created by Vlad Katsubo on 5/15/22.
//
import SpriteKit
import UIKit

class WhackSlot: SKNode {
// these two propertis is for understanding if penguin is visible and/or hitted
    var isVisible = false
    var isHit = false
// this property stores data for a penguin
    var charNode: SKSpriteNode!

    
    func configure(at position: CGPoint) { // this function is creating a hole, crop mask and a penguin for a proper game
        self.position = position // position to create a hole, crop mask and a penguin
        let sprite = SKSpriteNode(imageNamed: "whackHole") // creating a property for a hole image and adding it as a child
        addChild(sprite)
        
        let cropNode = SKCropNode() // creating a crop mask that would hide a penguin inside itself

        cropNode.position = CGPoint(x: 0, y: 15) // positioned it slighlty higher than the hole
        cropNode.zPosition = 1 // adding the image which will show everything inside itself
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood") // adding a penguin which will be under the hole at start.
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode) // adding cropNode with a charnode inside it to the main parent
        
    }
    

    func show(hideTime: Double) { // function that will show a penguin

        if isVisible { return } // if the penguin already visible in this slot - stop
        charNode.xScale = 1 // returning to OK size
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05)) // action that will slide penguin out of the hole
        isVisible = true
        isHit = false
        
        if let mudBlown = SKEmitterNode(fileNamed: "mud") {
            mudBlown.position = CGPoint(x: charNode.position.x, y: 0)
            mudBlown.zPosition = 1
            addChild(mudBlown)
        }

        if Int.random(in: 0...2) == 0 { // an if statement that will decide what to create - a bad or a good penguin
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
            

        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5) { [weak self] in // proceed hide function for this particular penguin after a hideTime delay. Where hideTime is a popupTime modified.
            self?.hide()
        }
    }

    func hide() { // hide a penguin
        if !isVisible { return } // if he already hided - stop
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05)) // hide a penguin with a slide action in 0.05 seconds
        if let mudBlown = SKEmitterNode(fileNamed: "mud") {
            mudBlown.position = charNode.position
            addChild(mudBlown)
        }
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
}
