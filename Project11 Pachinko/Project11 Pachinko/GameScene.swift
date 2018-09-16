//
//  GameScene.swift
//  Project11 Pachinko
//
//  Created by Hannie Kim on 9/3/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        // place back ground image in our game
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)   // centered in our scene
        background.blendMode = .replace                 // draw the image without alpha values
        background.zPosition = -1                       // background behind everything else
        addChild(background)                            // add the background node to the scene
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)    // adds physics body to the whole scene. Acts as the container for the scene
        physicsWorld.contactDelegate = self             // set contactDelegate to the self scene
        
        // make the slots for the scene, good and bad
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        // Setting the bouncer from the start to let balls bounce off of it
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {                      // pulls out any screen touches from touches Set
            let location = touch.location(in: self)         // finds where the screen was touched in relation to the game's scene
            let ball = SKSpriteNode(imageNamed: "ballRed")      // generates node of the ballRed image
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)     // adds physics body to the ball
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask   // to detect collisions
            ball.physicsBody?.restitution = 0.4             // bounciness of the ball
            ball.position = location                        // set new ball to where the tap occurs
            ball.name = "ball"                              // assign name to the ball node
            addChild(ball)                                   // add to the scene
        }
    }
    
    // makes the bouncers
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        
        addChild(bouncer)
    }
    
    // create slots for good or bad targets
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"          // assign name to slotBase node
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"           // assign name to slotBase node
        }

        slotBase.position = position
        slotGlow.position = position
        
        // have the slotGlow spin forever
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        //add rectangle physics to our slots
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    // when ball collides w/ something else
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    // when we're finished w/ the ball and want to get rid of it.
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
}
