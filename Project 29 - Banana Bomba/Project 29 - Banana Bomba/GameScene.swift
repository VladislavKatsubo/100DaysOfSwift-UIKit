//
//  GameScene.swift
//  Project 29 - Banana Bomba
//
//  Created by Vlad Katsubo on 6/25/22.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var viewController: GameViewController!
    var buildings = [BuildingNode]()
    
    var scoreLabelP1: SKLabelNode!
    var scoreLabelP2: SKLabelNode!
    
    var scoreP1 = 0 {
        didSet {
            scoreLabelP1.text = "Score: \(scoreP1)"
        }
    }
    var scoreP2 = 0 {
        didSet {
            scoreLabelP2.text = "Score: \(scoreP2)"
        }
    }
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        scoreLabelP1 = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabelP1.text = "Score: \(scoreP1)"
        scoreLabelP1.horizontalAlignmentMode = .left
        scoreLabelP1.position = CGPoint(x: 30, y: 650)
        scoreLabelP1.fontSize = 30
        scoreLabelP1.zPosition = 3
        addChild(scoreLabelP1)
        
        scoreLabelP2 = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabelP2.text = "Score: \(scoreP2)"
        scoreLabelP2.horizontalAlignmentMode = .left
        scoreLabelP2.position = CGPoint(x: 850, y: 650)
        scoreLabelP2.fontSize = 30
        scoreLabelP2.zPosition = 3
        addChild(scoreLabelP2)
        
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dx = CGFloat(Int.random(in: -3 ... 3))
        
        let gravityLabel = SKLabelNode(text: "Wind speed \(physicsWorld.gravity.dx)")
        gravityLabel.horizontalAlignmentMode = .center
        gravityLabel.position = CGPoint(x: 512, y: 600)
        gravityLabel.fontSize = 25
        gravityLabel.zPosition = 3
        addChild(gravityLabel)
        
        if physicsWorld.gravity.dx > 0 {
            gravityLabel.text = "Wind speed \(physicsWorld.gravity.dx) >>>"
        } else {
            gravityLabel.text = "Wind speed \(physicsWorld.gravity.dx) <<<"
        }
        
        createBuildings()
        createPlayers()
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.building.rawValue | CollisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(sequence)
            
            let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
        }
    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2) )
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2) )
        addChild(player2)
    }
    
    func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }

        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode as! BuildingNode, atPoint: contact.contactPoint)
        }

        if firstNode.name == "banana" && secondNode.name == "player1" {
            scoreP2 += 1
            destroy(player: player1)
        }

        if firstNode.name == "banana" && secondNode.name == "player2" {
            scoreP1 += 1
            destroy(player: player2)
            
        }
    }
                    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer") {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        
        if scoreP1 > 2 || scoreP2 > 2 {
            isUserInteractionEnabled = false
            let gameOver = SKLabelNode(text: "Game Over")
            gameOver.zPosition = 3
            gameOver.position = CGPoint(x: 524, y: 384)
            addChild(gameOver)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController.currentGame = newGame
                
                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                newGame.scoreLabelP1 = self.scoreLabelP1
                newGame.scoreLabelP2 = self.scoreLabelP2
                newGame.scoreP1 = self.scoreP1
                newGame.scoreP2 = self.scoreP2
                
                
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
            }
        }
        
    }
    
    func changePlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
        } else {
            currentPlayer = 1
        }
        
        viewController.activatePlayer(number: currentPlayer)
    }
    
    func bananaHit(building: BuildingNode, atPoint contactPoint: CGPoint ) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding") {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        
        changePlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    
    }
    
}
