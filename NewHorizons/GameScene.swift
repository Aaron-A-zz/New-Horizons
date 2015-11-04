//
//  GameScene.swift
//  NewHorizons
//
//  Created by Aaron Ackerman on 10/18/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    let satellite = SKSpriteNode(imageNamed: "Sat2")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.blackColor()
        satellite.position = CGPoint(x:frame.size.width / 2, y: frame.size.height / 2)
        addChild(satellite)
        
        let spawnRandomAsteroid = SKAction.runBlock(spawnAsteroid)
        let waitTime = SKAction.waitForDuration(1.0)
        let sequence = SKAction.sequence([spawnRandomAsteroid,waitTime])
        runAction(SKAction.repeatActionForever(sequence))
        
        physicsWorld.gravity = CGVectorMake(0.0, -0.9)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        print(touchLocation)
        
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
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.frame.size.width * 0.3)
        addChild(asteroid)
        
    }

}
