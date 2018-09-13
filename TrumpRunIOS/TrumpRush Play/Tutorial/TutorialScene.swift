//
//  GameScene.swift
//  Flappy trump
//
//  Created by Rob Percival on 05/07/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

class TutorialScene: SKScene, SKPhysicsContactDelegate {
    
    var trump = SKSpriteNode()
  
    var timer = Timer()
    var currentTheme = UserDefaults().integer(forKey: "THEMENUMBER")
    var themeArray: [UIImage] = Constants.grntTheme
    var trumpOGSize: CGSize!
    var jumpCounterButtons: [SKSpriteNode] = []

    
    var bg = SKSpriteNode()
    
    enum ColliderType: UInt32{
        case Trump = 1
        case Object = 2
        case Ground = 4
        case Gap = 8
    }
    
    var jumpCounter = 0

    
    var creationRateVariable: CGFloat = -2.0
    
    override func sceneDidLoad() {
        
        if currentTheme == 1 {
            themeArray = Constants.originalTheme
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == ColliderType.Ground.rawValue || contact.bodyB.categoryBitMask == ColliderType.Ground.rawValue {
            jumpCounter = 0
            for i in 0...4 {
                jumpCounterButtons[i].alpha = 1.0
            }
            trump.removeAllActions()
            let trumpTexture1 = SKTexture(image: themeArray[0])
            let trumpTexture2 = SKTexture(image: themeArray[1])
            let trumpTexture3 = SKTexture(image: themeArray[2])
            let trumpTexture4 = SKTexture(image: themeArray[3])
            
            let animation = SKAction.animate(with: [trumpTexture1, trumpTexture2, trumpTexture3], timePerFrame: 0.1)
            let maketrumpRun = SKAction.repeatForever(animation)
            trump.size = trumpOGSize
            trump.run(maketrumpRun)
        }
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        setupGame()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if jumpCounter < 5 {
            trump.physicsBody?.isDynamic = true
            trump.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            if currentTheme == 0 {
                trump.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
            } else {
                trump.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 70))
            }
            trump.removeAllActions()
            let trumpTexture = SKTexture(image: themeArray[4])
            let animation = SKAction.animate(with: [trumpTexture], timePerFrame: 0.1)
            let maketrumpJump = SKAction.repeatForever(animation)
            
            let scale = 100 / trumpTexture.size().width
            let newHeight = trumpTexture.size().height * scale
                    
            if currentTheme == 0 {
                trump.size = CGSize(width: 100, height: newHeight)
            } else {
                trump.size = CGSize(width: 140, height: trump.size.height)
            }
            trump.run(maketrumpJump)
            jumpCounterButtons[(4 - jumpCounter)].alpha = 0.3
            jumpCounter += 1
        }
        
    }
    
    func setupGame() {
                
        let bgTexture = SKTexture(imageNamed: "trump_space.png")
        let scale = self.frame.height / bgTexture.size().height
        let newWidth = bgTexture.size().width * scale
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -newWidth, dy: 0), duration: 60)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: newWidth, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        
        
        while i < 1 {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: newWidth * i, y: self.frame.midY)
            
            bg.size.height = self.frame.height
            bg.size.width = newWidth
            
            
//            bg.run(moveBGForever)
            
            bg.zPosition = -1
            
            self.addChild(bg)
            
            i += 1
        }
        
        
        let trumpTexture1 = SKTexture(image: themeArray[0])
        let trumpTexture2 = SKTexture(image: themeArray[1])
        let trumpTexture3 = SKTexture(image: themeArray[2])
        let trumpTexture4 = SKTexture(image: themeArray[3])
        let animation = SKAction.animate(with: [trumpTexture1, trumpTexture2, trumpTexture3], timePerFrame: 0.1)
        let maketrumpRun = SKAction.repeatForever(animation)
        
        trump = SKSpriteNode(texture: trumpTexture1)
        
        trump.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 3.5)
        
        trump.size = CGSize(width: 120, height: trump.frame.height)
        trump.run(maketrumpRun)
        trumpOGSize = trump.size
        
        trump.physicsBody = SKPhysicsBody(circleOfRadius: trumpTexture1.size().height / 8)
        
        trump.physicsBody?.isDynamic = false
        
        trump.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        trump.physicsBody!.contactTestBitMask = ColliderType.Gap.rawValue
        trump.physicsBody!.categoryBitMask = ColliderType.Trump.rawValue
        trump.physicsBody!.collisionBitMask = ColliderType.Ground.rawValue
        
        self.addChild(trump)
        
        // Right wall
        //        node = [SKNode node];
        //        node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(CGRectGetWidth(self.frame) - 1.0f, 0.0f, 1.0f, CGRectGetHeight(self.view.frame))];
        //        [self addChild:node];
        
        let ground = SKSpriteNode()
        ground.color = UIColor.red
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -self.frame.width/2, y: 0, width: self.frame.width, height: 10))
        ground.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
        
        ground.position = CGPoint(x: 0, y: (-self.frame.height / 3.5) - 40)
        
        //        let ground = SKNode()
        //
        //        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2.28)
        //
        //        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        //
        //        ground.physicsBody!.isDynamic = false
        //
        ground.physicsBody!.contactTestBitMask = ColliderType.Trump.rawValue
        //        ground.physicsBody!.categoryBitMask = ColliderType.Ground.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Trump.rawValue
        
        
        self.addChild(ground)
        
        var widthAcum: CGFloat = 40
        
        for i in 0...4 {
            jumpCounterButtons.insert(SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "jumpCircle")), size: CGSize(width: 40, height: 40)), at: i)
            jumpCounterButtons[i].position = CGPoint(x: (self.frame.width/2) - widthAcum, y: (self.frame.height/2) - 80)
            
            self.addChild(jumpCounterButtons[i])
            widthAcum+=60
        }
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    

    
    
}


