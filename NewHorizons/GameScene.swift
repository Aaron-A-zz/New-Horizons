//
//  GameScene.swift
//  NewHorizons
//
//  Created by Aaron Ackerman on 10/18/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var satellite = SKSpriteNode(imageNamed: "Sat2")
    var asteroid = SKSpriteNode(imageNamed: "Asteroid")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.blackColor()
        satellite.position = CGPoint(x:frame.size.width / 2, y: frame.size.height / 2)
        addChild(satellite)
        
        asteroid.position = CGPoint(x:frame.size.width / 2, y: frame.size.height / 1.3)
        addChild(asteroid)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        print(touchLocation)
        satellite.position = touchLocation
        
        //let move = SKAction.moveTo(touchLocation, duration: 1.0)
        //satellite.runAction(move)
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //satellite.position = CGPoint(x: satellite.position.x, y: satellite.position.y + 3)
        
    }
}
