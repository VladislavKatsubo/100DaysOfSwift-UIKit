//
//  GameScene.swift
//  Project11
//
//  Created by Vlad Katsubo on 4/14/22.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var createdBoxes = 0
    
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var balls = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
    var livesLabel: SKLabelNode!
    var lives = 5 {
        didSet{
            livesLabel.text = "You have \(lives) balls"
            if lives == 0 {
                let ac = UIAlertController(title: "You've lost", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK :(", style: .default))
                self.view?.window?.rootViewController?.present(ac, animated: true, completion: nil)
                startAgain()
            }
        }
    }
    var allBoxes = [SKNode]()
    
    override func didMove(to view: SKView) {
        // setting objects to variables and positioning them on the screen
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        //Blend modes determine how a node is drawn. The .replace option means "just draw it, ignoring any alpha values"
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 680)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 680)
        addChild(editLabel)
        
        livesLabel = SKLabelNode(fontNamed: "Chalkduster")
        livesLabel.text = "You have 5 balls"
        livesLabel.position = CGPoint(x: 512, y: 680)
        addChild(livesLabel)
        
        //adds a physics body to the whole scene that is a line on each edge, effectively acting like a container for the scene.
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        //
        physicsWorld.contactDelegate = self

        makeSlot(at: CGPoint(x: 128, y: 50), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 50), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 50), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 50), isGood: false)
        
        makeBouncer(at: (CGPoint(x: 0, y: 50)))
        makeBouncer(at: (CGPoint(x: 256, y: 50)))
        makeBouncer(at: (CGPoint(x: 512, y: 50)))
        makeBouncer(at: (CGPoint(x: 768, y: 50)))
        makeBouncer(at: (CGPoint(x: 1024, y: 50)))

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            //editing mode to place boxes on the screen
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.name = "box"
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.contactTestBitMask = box.physicsBody?.collisionBitMask ?? 0
                box.physicsBody?.isDynamic = false
                allBoxes.append(box)
                addChild(box)
                createdBoxes += 1
                //if not then create balls
            } else {
                let ball = SKSpriteNode(imageNamed: "\(balls.randomElement()!)")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.name = "ball"
                //to report on not to report about contacts of the object and what exact contacts to report. All or particular. Specified as All.
                //contactTestBitMask property of our physics objects, which sets the contact notifications we want to receive. This needs to introduce a whole new concept – bitmasks
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                //bounciness
                ball.physicsBody?.restitution = 0.5
                ball.position = location
                ball.position.y = 768
                addChild(ball)
            }
        }
    }
    //creation of a circle which will bounce away our balls
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    //create a line where ball would be destroyed
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        //spin for glow near line
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    //describes what would happen when objects collide
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            lives += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            lives -= 1
        } else if object.name == "box" {
            destroyBox(box: object)
            score += 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
        print(score, createdBoxes)
        if score == createdBoxes {
            let wc = UIAlertController(title: "You've Won!", message: nil, preferredStyle: .alert)
            wc.addAction(UIAlertAction(title: "OK :)", style: .default))
            self.view?.window?.rootViewController?.present(wc, animated: true, completion: nil)
            startAgain()
        }
        
    }
    
    func destroyBox(box: SKNode) {
        box.removeFromParent()
    }
    
//    func didHit(_ contact: SKPhysicsContact) {
//        guard let nodeA = contact.bodyA.node else { return }
//        guard let nodeB = contact.bodyB.node else { return }
//
//        if nodeA.name == "ball" {
//            collisionBox(between: nodeA, box: nodeB)
//        } else if nodeB.name == "box" {
//            collisionBox(between: nodeB, box: nodeA)
//        }
//    }
    
//    func collisionBox(between ball: SKNode, box: SKNode) {
//        if box.name == "box" {
//            destroyBox(box: box)
//        }
//    }
    
    func startAgain() {
        lives = 5
        createdBoxes = 0
        score = 0
        for box in allBoxes {
            box.removeFromParent()
        }
        
    }
    
}
