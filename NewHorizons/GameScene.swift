//
//  GameScene.swift
//  NewHorizons
//
//  Created by Aaron Ackerman on 10/18/15.
//  Copyright (c) 2015 Mav3r1ck. All rights reserved.
//

import SpriteKit

var missionDurationLabel = SKLabelNode(text: "Mission Duration")
var missionMinuteLabel = SKLabelNode(text: "Minute")
var missionHourLabel = SKLabelNode(text: "Hour")
var missionDayLabel = SKLabelNode(text: "Day")
var day = 0
var hour = 0
var minute = 0
var minuteTimeLabel = SKLabelNode(text: "\(minute)")
var hourTimeLabel = SKLabelNode(text: "\(hour)")
var dayTimeLabel = SKLabelNode(text: "\(day)")
var dodgedAsteroids = 0
var asteroidsDodgedCountLabel = SKLabelNode(text: "0")
var asteroidsDodgedLabel = SKLabelNode(text: "Asteroids dodged")
var asteroidsDodgedImage = SKSpriteNode(imageNamed: "AsteroidsDodged")
let pauseButton = SKSpriteNode(imageNamed: "pause")
let playButton = SKSpriteNode(imageNamed: "playButton")


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
        satellite.physicsBody = SKPhysicsBody(texture: satellite.texture!, size: satellite.frame.size)
        satellite.physicsBody?.dynamic = false
        satellite.physicsBody?.affectedByGravity = false
        satellite.physicsBody?.allowsRotation = false
        satellite.physicsBody?.categoryBitMask = bitMask.satellite.rawValue
        satellite.physicsBody?.contactTestBitMask = bitMask.asteroid.rawValue
        satellite.physicsBody?.collisionBitMask = 2
        addChild(satellite)
        
        let spawnRandomAsteroid = SKAction.runBlock(spawnAsteroid)
        let waitTime = SKAction.waitForDuration(1.0)
        let sequence = SKAction.sequence([spawnRandomAsteroid,waitTime])
        runAction((SKAction.repeatActionForever(sequence)), withKey: "spawnAsteroid")
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, -0.9)
        
        satellite.physicsBody?.contactTestBitMask = bitMask.asteroid.rawValue
        satellite.physicsBody?.collisionBitMask = bitMask.frame.rawValue
        
        missionDurationLabel.fontSize = 30
        missionDurationLabel.fontName = "Helvetica Neue"
        missionDurationLabel.fontColor = UIColor.redColor()
        missionDurationLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 45)
        addChild(missionDurationLabel)
        
        missionMinuteLabel.fontSize = 30
        missionMinuteLabel.fontName = "Helvetica Neue"
        missionMinuteLabel.position = CGPoint(x: frame.size.width / 2 + 150, y: frame.size.height - 85)
        addChild(missionMinuteLabel)
        
        missionHourLabel.fontSize = 30
        missionHourLabel.fontName = "Helvetica Neue"
        missionHourLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 85)
        addChild(missionHourLabel)
        
        missionDayLabel.fontSize = 30
        missionDayLabel.fontName = "Helvetica Neue"
        missionDayLabel.position = CGPoint(x: frame.size.width / 2 - 150, y: frame.size.height - 85)
        addChild(missionDayLabel)
        
        minuteTimeLabel.fontSize = 30
        minuteTimeLabel.fontName = "Helvetica Neue"
        minuteTimeLabel.position = CGPoint(x: frame.size.width / 2 + 150, y: frame.size.height - 120)
        addChild(minuteTimeLabel)
        
        hourTimeLabel.fontSize = 30
        hourTimeLabel.fontName = "Helvetica Neue"
        hourTimeLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 120)
        addChild(hourTimeLabel)
        
        dayTimeLabel.fontSize = 30
        dayTimeLabel.fontName = "Helvetica Neue"
        dayTimeLabel.position = CGPoint(x: frame.size.width / 2 - 150, y: frame.size.height - 120)
        addChild(dayTimeLabel)
        
        asteroidsDodgedImage.position = CGPoint(x: frame.size.width / 5.7, y: frame.size.height - 700)
        addChild(asteroidsDodgedImage)
        
        asteroidsDodgedLabel.fontSize = 28
        asteroidsDodgedLabel.fontName = "Helvetica Neue"
        asteroidsDodgedLabel.position = CGPoint(x: frame.size.width / 4.7, y: frame.size.height - 750)
        asteroidsDodgedLabel.zPosition = 1
        addChild(asteroidsDodgedLabel)
        
        asteroidsDodgedCountLabel.fontSize = 30
        asteroidsDodgedCountLabel.fontName = "Helvetica Neue"
        asteroidsDodgedCountLabel.position = CGPoint(x: frame.size.width / 15.5, y: frame.size.height - 700)
        asteroidsDodgedCountLabel.zPosition = 1
        addChild(asteroidsDodgedCountLabel)
        
        pauseButton.name = "pauseButton"
        pauseButton.zPosition = 1
        pauseButton.position = CGPoint(x: frame.size.width * 0.94, y: frame.size.height - 80)
        addChild(pauseButton)
        
        playButton.name = "playButton"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: frame.size.width * 0.94, y: frame.size.height - 80)
        playButton.hidden = true
        addChild(playButton)
        
        let updateMissionTimeLabels = SKAction.runBlock(updateMissionTime)
        let updateTime = SKAction.waitForDuration(2.0)
        let updateSequence = SKAction.sequence([updateMissionTimeLabels,updateTime])
        runAction((SKAction.repeatActionForever(updateSequence)), withKey: "missionDurationTime")
        
    }
    
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(self)
        print(touchLocation)
        
        let nodes = self.nodeAtPoint(touchLocation)
        if nodes.name == "pauseButton" {
            
            let showPlayButtonAction = SKAction.runBlock(showPlayButton)
            let pauseGameAction = SKAction.runBlock(pauseGame)
            let pauseSequence = SKAction.sequence([showPlayButtonAction, pauseGameAction])
            runAction(pauseSequence)
            
        } else if nodes.name == "playButton" {
            playButton.hidden = true
            pauseButton.hidden = false
            self.view?.paused = false
            
        } else {
            
            let moveTo = SKAction.moveTo(touchLocation, duration: 1.0)
            satellite.runAction(moveTo)
        }
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
        asteroid.name = "Asteroid"
        addChild(asteroid)
        
        
        let rotateAsteroid = SKAction.rotateByAngle(randomNumber(min: 1, max: 7), duration: 10)
        asteroid.runAction(rotateAsteroid, withKey: "rotateAsteroid")
        
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
            removeActionForKey("missionDurationTime")
            removeActionForKey("spawnAsteroid")
            enumerateChildNodesWithName("Asteroid") {
                asteroid,_ in
                
                asteroid.name = "dontCountMe"
            }
        default:
            return
        }
        
        
    }
    
    func updateMissionTime() {
        minute++
        
        if  minute == 60 {
            hour++
            minute = 0
        }
        
        if hour == 24 {
            day++
            hour = 0
        }
        minuteTimeLabel.text = "\(minute)"
        hourTimeLabel.text = "\(hour)"
        dayTimeLabel.text = "\(day)"
    }
    
    func pauseGame() {
        self.view!.paused = true
    }
    
    func showPlayButton() {
        pauseButton.hidden = true
        playButton.hidden = false
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        enumerateChildNodesWithName("Asteroid") {
            asteroid,_ in
            if asteroid.position.y <= 3 {
                let newdodgeCount = dodgedAsteroids++
                asteroidsDodgedCountLabel.text = (text: " \(newdodgeCount)")
                asteroid.removeFromParent()
            }
            
        }
        
    }

    
}
