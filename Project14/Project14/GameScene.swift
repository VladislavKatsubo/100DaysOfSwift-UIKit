//
//  GameScene.swift
//  Project14
//
//  Created by Vlad Katsubo on 5/14/22.
//

import SpriteKit

class GameScene: SKScene {
    

    var slots = [WhackSlot]() // properties for custom class values and score label
    var gameScore: SKLabelNode!

    var popupTime = 0.85 // default "lifetime" for a penguin
    
    var numRounds = 0 // it will stop the game after hitting 30

    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    

    func createSlot(at position: CGPoint) { // function that describes how and where to create a slot for a hole with penguin
        let slot = WhackSlot()
        slot.configure(at: position) // it uses configure method from WhackSlot swift file
        addChild(slot)
        slots.append(slot)
    }
    
    
// it's like viewDidLoad for UIKit
// here we are creating background, score label and slots using for loop.
// also this method is calling createEnemy() function that would call itself after.
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes { //check if node that was tapped is a whackSlot and it is visible and not hitted
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            if let hitSmoke = SKEmitterNode(fileNamed: "smoke") {
                hitSmoke.position = touch.location(in: self)
                addChild(hitSmoke)
            }
            
            if node.name == "charFriend" {
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
            }
        }
    }
    
    
// creates evil penguins faster and faster each iteration.
    func createEnemy() {
        
        numRounds += 1
        
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            let scoreOver = SKLabelNode(text: "Your final score is \(score)")
            scoreOver.position = CGPoint(x: 512, y: 310)
            scoreOver.zPosition = 1
            scoreOver.fontSize = 44
            scoreOver.fontName = "Verdana"
            scoreOver.color = .white
            scoreOver.horizontalAlignmentMode = .center
            addChild(scoreOver)
            
            run(SKAction.playSoundFileNamed("game-over.mp3", waitForCompletion: false))
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 6 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
}
