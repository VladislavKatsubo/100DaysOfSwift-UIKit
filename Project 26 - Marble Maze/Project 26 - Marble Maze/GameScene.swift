//
//  GameScene.swift
//  Project 26 - Marble Maze
//
//  Created by Vlad Katsubo on 6/15/22.
//
import CoreMotion
import SpriteKit
import UIKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    var level = 1
    var teleportNumber = 2
    var teleported = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var nodes = [SKSpriteNode]()
//    var lines: [String]?
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        loadLevel()
        createPlayer(atPosition: CGPoint(x: 96, y: 672))
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
        
    func loadFile() -> [String] {
        guard let levelURL = Bundle.main.url(forResource: "level2", withExtension: ".txt") else {
            fatalError("Could not load level\(level).txt from the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level\(level).txt from the app bundle.")
            
        }
        
        let lines = levelString.components(separatedBy: "\n")
        return lines
    }
    
    func createBaseNode(nodeName: String, position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: nodeName)
        node.name = nodeName
        node.position = position
        return node
    }
    
        func loadLevel() {

//            guard lines != nil else { return }
            guard let lines = loadFile() as? [String] else { return }
            
//            guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
//                   fatalError("Could not find level1.txt in the app bundle.")
//               }
//               guard let levelString = try? String(contentsOf: levelURL) else {
//                   fatalError("Could not load level1.txt from the app bundle.")
//               }
//
//               let lines = levelString.components(separatedBy: "\n")
            
            for (row, line) in lines.reversed().enumerated() {
                for (column, letter) in line.enumerated() {
                    let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                    print(row,letter)
                    if letter == "x" {
                        
                        let node = createBaseNode(nodeName: "block", position: position)
//
                        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                        node.physicsBody?.isDynamic = false
                        addChild(node)
                        nodes.append(node)
                    } else if letter == "v" {
                        let node = createBaseNode(nodeName: "vortex", position: position)
                        
                        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                        
                        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.isDynamic = false
                        
                        addChild(node)
                        nodes.append(node)
                    } else if letter == "s" {
                        let node = createBaseNode(nodeName: "star", position: position)
                        
                        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.isDynamic = false
                        
                        addChild(node)
                        nodes.append(node)
                    } else if letter == "f" {
                        let node = createBaseNode(nodeName: "finish", position: position)
                        
                        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.isDynamic = false
                        
                        addChild(node)
                        nodes.append(node)
                    } else if letter == "t" {
                        let node = createBaseNode(nodeName: "teleport", position: position)
                        node.name = "teleport\(teleportNumber)"
                        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 3)))
                        let scaleUp = SKAction.scale(by: 1.2, duration: 1)
                        let scaleDown = SKAction.scale(by: 0.8, duration: 1)
                        let seq = SKAction.sequence([scaleUp, scaleDown])
                        node.run(SKAction.repeatForever(seq))
                        
                        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
                        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                        node.physicsBody?.collisionBitMask = 0
                        node.physicsBody?.isDynamic = false
                        
                        addChild(node)
                        teleportNumber -= 1
                        nodes.append(node)
                    } else if letter == " " {
                        // do nothing
                    } else {
                        fatalError("Could not do anything with \(letter)")
                    }
                    
                }
            }
        }
    
    
    func createPlayer(atPosition: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = atPosition
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
        
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([move, scale, remove])
            
            player.run(seq) { [weak self] in
                if self?.level == 2 {
                    self?.createPlayer(atPosition: CGPoint(x: 96, y: 672))
                } else {
                    self?.createPlayer(atPosition: CGPoint(x: 96, y: 708))
                }
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            player.removeFromParent()
            let fc = UIAlertController(title: "Game Over", message: "Are you ready for a new Level?", preferredStyle: .alert)
            fc.addAction(UIAlertAction(title: "Yes", style: .default, handler: levelUp))
            fc.addAction(UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
                if self?.level == 2 {
                    self?.createPlayer(atPosition: CGPoint(x: 96, y: 672))
                } else {
                    self?.createPlayer(atPosition: CGPoint(x: 96, y: 708))
                }
                self?.loadLevel()
            })
            self.view?.window?.rootViewController?.present(fc, animated: true, completion: nil)
        } else if node.name == "teleport1" {
            if teleported == false {
                player.removeFromParent()
                teleported = true
                createPlayer(atPosition: childNode(withName: "teleport2")!.position)
                node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 3)))
                let scaleUp = SKAction.scale(by: 1.2, duration: 1)
                let scaleDown = SKAction.scale(by: 0.8, duration: 1)
                let seq = SKAction.sequence([scaleUp, scaleDown])
                node.run(SKAction.repeatForever(seq))
            } else {
                node.isUserInteractionEnabled = false
                node.removeAllActions()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.teleported = false
                }
            }
        } else if node.name == "teleport2" {
            if teleported == false {
                player.removeFromParent()
                teleported = true
                createPlayer(atPosition: childNode(withName: "teleport1")!.position)
                node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 3)))
                let scaleUp = SKAction.scale(by: 1.2, duration: 1)
                let scaleDown = SKAction.scale(by: 0.8, duration: 1)
                let seq = SKAction.sequence([scaleUp, scaleDown])
                node.run(SKAction.repeatForever(seq))
            } else {
                node.isUserInteractionEnabled = false
                node.removeAllActions()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.teleported = false
                }
            }

        }
        
    }
    
    func teleport(nodeName: String) {
        let positionTele = childNode(withName: "\(nodeName)")?.position
        let move = SKAction.move(to: positionTele!, duration: 0.2)
        player.run(move)
    }
     
    func levelUp(action: UIAlertAction) {
//        lines?.removeAll(keepingCapacity: true)
        
        for node in nodes {
            node.removeFromParent()
        }
        level += 1
        player.removeFromParent()
        loadLevel()
        
        if level == 2 {
            createPlayer(atPosition: CGPoint(x: 96, y: 708))
        } else {
            createPlayer(atPosition: CGPoint(x: 96, y: 672))
        }
        
    }
    
}
