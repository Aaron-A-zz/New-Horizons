//
//  GameScene.swift
//  NewHorizons
//
//  Created by Aaron Ackerman on 10/18/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum bitMask: UInt32 {
        case satellite = 1
        case asteroid = 2
        case frame = 4
    }
    
    let satellite = SKSpriteNode(imageNamed: "Sat2")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.blackColor()
        satellite.position = CGPoint(x:frame.size.width / 2, y: frame.size.height / 2)
        //A
        satellite.physicsBody = SKPhysicsBody(texture: satellite.texture!, size: satellite.frame.size)
        //B
        satellite.physicsBody?.dynamic = false
        //C
        satellite.physicsBody?.affectedByGravity = false
        //D
        satellite.physicsBody?.allowsRotation = false
        //E
        satellite.physicsBody?.categoryBitMask = bitMask.satellite.rawValue
        //F
        satellite.physicsBody?.contactTestBitMask = bitMask.asteroid.rawValue
        //G
        satellite.physicsBody?.collisionBitMask = 0
        addChild(satellite)
        
        let spawnRandomAsteroid = SKAction.runBlock(spawnAsteroid)
        let waitTime = SKAction.waitForDuration(1.0)
        let sequence = SKAction.sequence([spawnRandomAsteroid,waitTime])
        runAction(SKAction.repeatActionForever(sequence))
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, -0.9)
        
        satellite.physicsBody?.contactTestBitMask = bitMask.asteroid.rawValue
        satellite.physicsBody?.collisionBitMask = bitMask.frame.rawValue
        
    }
    
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        //print(touchLocation)
        let moveTo = SKAction.moveTo(touchLocation, duration: 1.0)
        satellite.runAction(moveTo)
    }
    
    
    func randomNumber(min min: CGFloat, max: CGFloat) -> CGFloat {
        let random = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return random * (max - min) + min
    }
    
    
    func spawnAsteroid() {
        let asteroid = SKSpriteNode(imageNamed: "Asteroid")
        asteroid.position = CGPoint(x: frame.size.width * randomNumber(min: 0, max: 1), y: frame.size.height + asteroid.size.height)
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.frame.size)
        asteroid.physicsBody?.categoryBitMask = bitMask.asteroid.rawValue
        asteroid.physicsBody?.contactTestBitMask = bitMask.satellite.rawValue
        addChild(asteroid)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
        case bitMask.satellite.rawValue | bitMask.asteroid.rawValue:
            let secondNode = contact.bodyB.node
            secondNode?.physicsBody?.allowsRotation = true
            let firstNode = contact.bodyA.node
            firstNode?.physicsBody?.allowsRotation = true
            firstNode?.removeFromParent()
            
        default:
            return
        }
    }
    
}
