//
//  GameScene.swift
//  Milestone Project 16-18
//
//  Created by Vlad Katsubo on 5/28/22.
//

import SpriteKit
import UIKit



class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var bullet: SKSpriteNode!
    var ammo = [SKSpriteNode]()
    var fullAmmo = [SKSpriteNode]()
    var revolverAmmo: SKSpriteNode!
    var bullets = 6
    
    var enemies = ["banditBad", "scorpioBad", "snakeBad"]
    var friends = ["horseGood", "bisonGood", "cactusGood"]
    var objectSprite: SKSpriteNode!
    
    var gameTimer: Timer?
    var minuteTimer: Timer?
    var seconds = 60 {
        didSet {
            timerLabel.text = "Time left: \(seconds) seconds"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var playField = [CGPoint]()
    var firstRow = CGPoint(x: -100, y: 195)
    var secondRow = CGPoint(x: 1300, y: 384)
    var thirdRow = CGPoint(x: -100, y: 579)

    
    
    override func didMove(to view: SKView) {
        
        playField.append(firstRow)
        playField.append(secondRow)
        playField.append(thirdRow)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        background.size = view.frame.size
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 850, y: 710)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.text = "Time left: \(seconds) seconds"
        timerLabel.position = CGPoint(x: 50, y: 710)
        timerLabel.horizontalAlignmentMode = .left
        addChild(timerLabel)
        
        minuteTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        
        for i in 0...5 {
            bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.name = "\(i)bullet"
            bullet.position = CGPoint(x: 100+(i*50), y: 55)
            bullet.zPosition = 1
            bullet.scale(to: CGSize(width: 35, height: 100))
            ammo.append(bullet)
            addChild(bullet)
        }
        
        fullAmmo = ammo
        
        revolverAmmo = SKSpriteNode(imageNamed: "drum")
        revolverAmmo.position = CGPoint(x: 850, y: 55)
        revolverAmmo.scale(to: CGSize(width: 100, height: 100))
//        revolverAmmo.zRotation = CGFloat(5.7)
        revolverAmmo.isHidden = true
        addChild(revolverAmmo)
        
        physicsWorld.gravity = .zero
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createObject), userInfo: nil, repeats: true)
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            } else if node.position.x > 1300 {
                node.removeFromParent()
            }
        }
        
        if bullets == 0 {
           revolverAmmo.isHidden = false
           ammo.removeAll()
       }
    }
    
    @objc func timerUpdate() {
        if seconds > 0 {
            seconds -= 1
        }
        
    }
    
    @objc func createObject() {
        guard let enemy = enemies.randomElement() else { return }
        guard let friend = friends.randomElement() else { return }
        
        if Int.random(in: 0...2) == 0 {
            objectSprite = SKSpriteNode(imageNamed: friend)
            objectSprite.name = "good"
        } else {
            objectSprite = SKSpriteNode(imageNamed: enemy)
            objectSprite.name = "bad"
        }
        
        addChild(objectSprite)
        objectSprite.position = playField.randomElement()!
        objectSprite.size = CGSize(width: 100, height: 100)
        objectSprite.physicsBody = SKPhysicsBody(texture: objectSprite.texture!, size: objectSprite.size)
//        objectSprite.physicsBody?.categoryBitMask = 1
        
        if objectSprite.position == firstRow {
            objectSprite.physicsBody?.velocity = CGVector(dx: 150, dy: 0)
        } else if objectSprite.position == secondRow{
            objectSprite.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
        } else if objectSprite.position == thirdRow {
            objectSprite.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        }
//        objectSprite.physicsBody?.angularVelocity = 5
//        objectSprite.physicsBody?.linearDamping = 0
//        objectSprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        var tappedNodes = nodes(at: location)
        
        
        if bullets > 0 {
            for node in tappedNodes {
                if node.name == "good" {
                    score -= 1
                    node.removeFromParent()
                    
                    ammo[bullets - 1].removeFromParent()
                    bullets -= 1
                    
                } else if node.name == "bad" {
                    score += 1
                    node.removeFromParent()
                    
                    ammo[bullets - 1].removeFromParent()
                    bullets -= 1
                    
                }
            }
        }
        
        if nodes(at: location).contains(revolverAmmo) {
            for i in 0...5 {
                bullet = SKSpriteNode(imageNamed: "bullet")
                bullet.name = "\(i)bullet"
                bullet.position = CGPoint(x: 100+(i*50), y: 55)
                bullet.zPosition = 1
                bullet.scale(to: CGSize(width: 35, height: 100))
                ammo.append(bullet)
                addChild(bullet)
            }
            
            bullets = 6
            revolverAmmo.isHidden = true
            
        }
        
    }

}
