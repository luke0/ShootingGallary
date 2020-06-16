//
//  GameScene.swift
//  ShootingGallary
//
//  Created by Luke Inger on 16/06/2020.
//  Copyright © 2020 Luke Inger. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    
    var targetType = ["GoodTarget", "VGoodTarget", "BadTarget"]
    
    var timeRemaining = 20 {
        didSet {
            timerLabel.text = ("Remaining: \(timeRemaining)")
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = ("Score: \(score)")
        }
    }
    var remainingShots = 3
    
    var isGameOver = false {
        didSet {
            if isGameOver == true {
                countdownTimer.invalidate()
                gameTimer.invalidate()
                timerLabel.text = "Game Over!"
                for node in children {
                    if let name = node.name {
                        if name.contains("Target"){
                            node.removeFromParent()
                        }
                    }
                }
            }
        }
    }
    var gameTimer: Timer!
    var countdownTimer : Timer!
    
    override func didMove(to view: SKView) {
        
        scoreLabel = SKLabelNode(fontNamed: "ChalkDuster")
        scoreLabel.position = CGPoint(x: 15, y: 720)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "ChalkDuster")
        timerLabel.position = CGPoint(x: 800, y: 720)
        timerLabel.horizontalAlignmentMode = .right
        addChild(timerLabel)
        
        let gun = SKSpriteNode(imageNamed: "Gun")
        gun.size = CGSize(width: 100, height: 100)
        gun.position = CGPoint(x: 950, y: 60)
        gun.name = "Gun"
        addChild(gun)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        createBullet(at: CGPoint(x: 100, y: 30), name: "Bullet1")
        createBullet(at: CGPoint(x: 100, y: 50), name: "Bullet2")
        createBullet(at: CGPoint(x: 100, y: 70), name: "Bullet3")
        
        score = 0
        timeRemaining = 20
    }
    
    @objc func createBullet(at Location:CGPoint,name:String){
        let bullet = SKSpriteNode(imageNamed: "Bullet")
        bullet.position = Location
        bullet.name = "Bullet"
        addChild(bullet)
    }
    
    @objc func countdown(){
        timeRemaining -= 1
        if (timeRemaining <= 0){
            isGameOver = true
        }
    }
    
    @objc func createTargets(){

        let targetName = targetType.shuffled().first!
        
        let section = Int.random(in: 0...2)
        var y = 200
        var x = 1100
        var moveBy: CGFloat = -1300
        switch section {
        case 0:
            y = 200
            break
        case 1:
            y = 400
            x = -100
            moveBy = 1300
            break
        default:
            y = 600
        }
    
        
        let target = SKSpriteNode(imageNamed: targetName)
        target.position = CGPoint(x: x, y: y)
        target.name = targetName
        addChild(target)
        
        target.run(SKAction.moveBy(x: moveBy, y: 0, duration: 5))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes{
            
            if let name = node.name {
                if name.contains("Bullet"){
                    return
                } else if name == "Gun" {
                    remainingShots = 3
                    return
                }
            }
            
            if remainingShots <= 0 { return }
            
            if (node.name == "GoodTarget"){
                score += 1
            } else if (node.name == "BadTarget"){
                score -= 5
            } else if (node.name == "VGoodTarget"){
                score += 10
            }
            remainingShots -= 1
            node.removeFromParent()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
            if node.position.x > 1300 {
                node.removeFromParent()
            } else if node.position.x < -100 {
                node.removeFromParent()
            }
        }
    }
}
