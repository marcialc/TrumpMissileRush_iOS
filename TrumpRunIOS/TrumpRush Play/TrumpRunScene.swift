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

class TrumpRunScene: SKScene, SKPhysicsContactDelegate {
    
    var trump = SKSpriteNode()
    var scoreLabel = SKLabelNode(fontNamed:"PhosphateInline")
    var gameOverLabel = SKLabelNode(fontNamed:"Helvetica Bold")
    var highScoreLabel = SKLabelNode(fontNamed:"Helvetica Bold")
    var tapToPlayLabel = SKLabelNode(fontNamed:"Helvetica Bold")
    var score = 0
    var timer = Timer()
    var gameStarted = false
    var pauseNode = SKSpriteNode()
    var pauseButton = UIButton()
    var pauseChildren: [SKNode] = []
    var pauseButtonTouched = false
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
    var firstRound = true
    var currentTheme = UserDefaults().integer(forKey: "THEMENUMBER")
    var themeArray: [UIImage] = Constants.grntTheme
    var trumpOGSize: CGSize!
    var jumpCounterButtons: [SKSpriteNode] = []
    var firstTimerPassed = false
    var firstTimerCounter = 0
    
    var bg = SKSpriteNode()
    
    enum ColliderType: UInt32{
        case Trump = 1
        case Object = 2
        case Ground = 4
        case Gap = 8
    }
    
    var gameOver = false
    var jumpCounter = 0
    var speedVariable1: CGFloat = 100.0
    var speedVariable2: CGFloat = 120.0
    var speedVariable3: CGFloat = 80.0
    var speedVariable4: CGFloat = 60.0

    var creationRateVariable: CGFloat = -2.0
    
    override func sceneDidLoad() {
        
        if currentTheme == 1 {
            themeArray = Constants.originalTheme
        }
        
        let pauseTexture = SKTexture(image: #imageLiteral(resourceName: "pause_button"))
        pauseNode = SKSpriteNode(texture: pauseTexture )
        
        pauseNode.position = CGPoint(x: (-self.frame.width/2) + 80, y: (self.frame.height/2) - 80)
        pauseNode.name = "pauseButton"
        self.addChild(pauseNode)
        
    }
    
    @objc func makewalls() {
        
        if pauseButtonTouched == false {
        
            let randomNumber = arc4random_uniform(4)
            var tempSpeedVariable: CGFloat = 0.0
            
            switch randomNumber {
            case 0:
                tempSpeedVariable = speedVariable1
                break
            case 1:
                tempSpeedVariable = speedVariable2
                break
            case 2:
                tempSpeedVariable = speedVariable3
                break
            case 3:
                tempSpeedVariable = speedVariable4
                break
            default:
                tempSpeedVariable = speedVariable1
                break
            }
            
            var tempSpeedVariable2: CGFloat = 0.0
            
            switch randomNumber {
            case 0:
                tempSpeedVariable2 = speedVariable1
                break
            case 1:
                tempSpeedVariable2 = speedVariable2
                break
            case 2:
                tempSpeedVariable2 = speedVariable3
                break
            case 3:
                tempSpeedVariable2 = speedVariable4
                break
            default:
                tempSpeedVariable2 = speedVariable1
                break
            }
            
            
            
            let movewalls = SKAction.move(by: CGVector(dx: creationRateVariable * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / tempSpeedVariable))
            let removewalls = SKAction.removeFromParent()
            let moveAndRemovewalls = SKAction.sequence([movewalls, removewalls])
            
            let movemissiles = SKAction.move(by: CGVector(dx: creationRateVariable * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / (tempSpeedVariable2 + 100)))
            let removemissiles = SKAction.removeFromParent()
            let moveAndRemovemissiles = SKAction.sequence([movemissiles, removemissiles])
            
            
            
            let movementAmount = ((arc4random() + 50) % UInt32(self.frame.height / 2))
    //        let movementAmount = arc4random_uniform(5) + 2

            
            let wallOffset = CGFloat(movementAmount) - self.frame.height / 4
            
    //        let wallTexture = SKTexture(imageNamed: "wall_wall.png")
            var wallTexture = SKTexture()
            let missileTexture = SKTexture(imageNamed: "Trump_Missile.png")

            if score >= 15 && score < 30 {
                if score == 15 {
                playNewStageSound()
                }
                let randomNumber = arc4random_uniform(4)
                if randomNumber > 0 {
                    wallTexture = SKTexture(imageNamed: "space_wall.png")
                } else {
                    wallTexture = SKTexture(imageNamed: "space_wall.png")
                }
            } else if score >= 30 && score < 45 {
                if score == 30 {
                playNewStageSound()
                }
                wallTexture = SKTexture(imageNamed: "space_wall.png")

            } else if score >= 45 && score < 60 {
                if score == 45 {
                playNewStageSound()
                }
                wallTexture = SKTexture(imageNamed: "space_wall.png")
            } else if score >= 60 {
                if score == 60 {
                play60MarkSound()
                }
                wallTexture = SKTexture(imageNamed: "space_wall.png")
            } else {
                wallTexture = SKTexture(imageNamed: "space_wall.png")
            }
            
            let wall2 = SKSpriteNode(texture: wallTexture)
            let missileRocket = SKSpriteNode(texture: missileTexture)
            
    //        let gapHeight = trump.size.height
            
            
            wall2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - (wallTexture.size().height / 1.8) + wallOffset)
            
            wall2.run(moveAndRemovewalls)
            
            wall2.physicsBody = SKPhysicsBody(rectangleOf: wallTexture.size())
            
            wall2.physicsBody!.isDynamic = false
            
            wall2.physicsBody!.contactTestBitMask = ColliderType.Trump.rawValue
            wall2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
            wall2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
            
           
            self.addChild(wall2)
    //        wall2.zPosition = 0.0

            let gap = SKSpriteNode.init(color: UIColor.clear, size: CGSize(width: wallTexture.size().width - 200, height: wallTexture.size().height))
//            gap.color = UIColor.green
            
            gap.position = CGPoint(x: self.frame.midX + self.frame.width + 100, y: self.frame.midY + wallOffset)
            
            gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: wall2.size.width, height: wallTexture.size().height))
            print(wallOffset)
            print(gap.frame)
            
            gap.physicsBody?.isDynamic = false
            
            gap.run(moveAndRemovewalls)

            gap.physicsBody!.contactTestBitMask = ColliderType.Trump.rawValue
            gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
            gap.physicsBody!.collisionBitMask = ColliderType.Trump.rawValue
            
            self.addChild(gap)
            
            var randomNumberAmount = 0
            
            if score < 15 {
                randomNumberAmount = 5
            } else if score < 31 {
                randomNumberAmount = 4
            } else if score < 46 {
                randomNumberAmount = 3
            } else {
                randomNumberAmount = 2
            }
            
            let randomNumber2 = arc4random_uniform(UInt32(randomNumberAmount))
            
            if randomNumber2 == 0 {
                missileRocket.position = CGPoint(x: self.frame.midX - 150 + self.frame.width, y: self.frame.midY - (wallTexture.size().height / 1.5) + wallOffset + (gap.frame.height/1.3))
                
                missileRocket.run(moveAndRemovemissiles)
                
                missileRocket.physicsBody = SKPhysicsBody(rectangleOf: missileTexture.size())
                
                missileRocket.physicsBody!.isDynamic = false
                
                missileRocket.physicsBody!.contactTestBitMask = ColliderType.Trump.rawValue
                missileRocket.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
                missileRocket.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
                
                self.addChild(missileRocket)
            }
            
            firstTimerPassed = true
            
            }
        
        
        }
    
        func didBegin(_ contact: SKPhysicsContact) {
            
            if gameOver == false {
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
                
                playPointSound()
                score += 1
                scoreLabel.text = String(score)
                if(speedVariable2 < 760) {
                speedVariable1 += 20.0
                speedVariable2 += 20.0
                speedVariable3 += 20.0
                speedVariable4 += 20.0
                }

    //            creationRateVariable -= 0.01
                
            } else if contact.bodyA.categoryBitMask == ColliderType.Ground.rawValue || contact.bodyB.categoryBitMask == ColliderType.Ground.rawValue {
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
            } else {
//                if score > highScore {
//                    playHighScoreSound()
//                } else {
                    playDeathSound()
//                    playFallingSound()
//                }
                self.speed = 0
                jumpCounter = 0
                for i in 0...4 {
                    jumpCounterButtons[i].alpha = 1.0
                }
                speedVariable1 = 100.0
                speedVariable2 = 120.0
                speedVariable3 = 80.0
                speedVariable4 = 60.0
                creationRateVariable = -2.0
                gameOver = true
                gameStarted = false
                timer.invalidate()
                saveHighScore()
                
                highScoreLabel.fontSize = 36
                if score > highScore {
                    highScoreLabel.text = "NEW HIGHSCORE: \(String(highScore))"
                } else {
                    highScoreLabel.text = "HIGHSCORE: \(String(highScore))"
                }
                highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 60)
                highScoreLabel.fontColor = UIColor.white
                self.insertChild(highScoreLabel, at: self.children.count - 1)
            
                gameOverLabel.fontSize = 36
                gameOverLabel.text = "Game Over. Tap to play again."
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                gameOverLabel.fontColor = UIColor.white
                self.insertChild(gameOverLabel, at: self.children.count - 1)
                
            }
            
        }
        
    }
    
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        setupGame()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
      let touch:UITouch = touches.first! as UITouch
      let positionInScene = touch.location(in: self)
      let touchedNode = self.atPoint(positionInScene)
      var resumeClicked = false
        
      let array = [tapToPlayLabel]
      self.removeChildren(in: array)
        
        if let name = touchedNode.name
        {
            if name == "pauseButton"
            {
                if pauseButtonTouched == false && gameOver == false {
                    trump.physicsBody?.isDynamic = false
                    self.speed = 0
                    setupPauseScreen()
                    pauseButtonTouched = true
                } else if gameOver == false && pauseButtonTouched == true {
                    removePauseScreen()
                    trump.physicsBody?.isDynamic = true
                    pauseButtonTouched = false
                    resumeClicked = true
                }
            } else if name == "resumeButton" || name == "resumeLabel" {
                if(gameOver == false) {
                    trump.physicsBody?.isDynamic = true
                    pauseButtonTouched = false
                    resumeClicked = true
                }
                
                removePauseScreen()

            } else if name == "restartButton" || name == "restartLabel" {
                removePauseScreen()
                gameOver = false
                saveHighScore()
                timer.invalidate()
                speedVariable1 = 100.0
                speedVariable2 = 120.0
                speedVariable3 = 80.0
                speedVariable4 = 60.0
                creationRateVariable = -2.0
                score = 0
                self.children.filter { $0.name != "pauseButton" }.forEach { $0.removeFromParent() }
                setupGame()
                self.speed = 1
                trump.physicsBody?.isDynamic = true
                pauseButtonTouched = false
                resumeClicked = true
            } else if name == "quitButton" || name == "quitLabel" {
                let vc = self.view?.window?.rootViewController
                if let nav = vc?.navigationController {
                    nav.popViewController(animated: true)
                } else {
                    vc?.dismiss(animated: false, completion: nil)
                }
            }
        }

        if pauseButtonTouched == false && resumeClicked == false {
            
            if gameStarted == false {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.makewalls), userInfo: nil, repeats: false)
                gameStarted = true
            }
            
            if firstTimerPassed && firstTimerCounter == 0 {
                timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.makewalls), userInfo: nil, repeats: true)
                firstTimerCounter = 1
            }
        
            if gameOver == false {
               
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
                
            } else {
                gameOver = false
                saveHighScore()
                score = 0
                self.speed = 1
                self.children.filter { $0.name != "pauseButton" }.forEach { $0.removeFromParent() }
                setupGame()
                trump.physicsBody?.isDynamic = true
            }
            
        }
        
    }
    
    func setupPauseScreen() {
        
        let restartButton = SKShapeNode(rect: CGRect(x: -self.frame.width/4, y: -70, width: self.frame.width/2, height: 140), cornerRadius: 6)
        restartButton.fillColor = UIColor.black
        restartButton.name = "restartButton"
        
        let restartLabel = SKLabelNode(fontNamed:"Helvetica Bold")
        restartLabel.fontSize = 36
        restartLabel.text = "RESTART"
        restartLabel.position = CGPoint(x: 0, y: (restartButton.frame.height/2) - (restartLabel.frame.height/2) - 70)
        restartLabel.name = "restartLabel"
        
        let resumeButton = SKShapeNode(rect: CGRect(x: -self.frame.width/4, y: restartButton.frame.height - 40, width: self.frame.width/2, height: 140), cornerRadius: 6)
        resumeButton.fillColor = UIColor.black
        resumeButton.name = "resumeButton"
        
        let resumeLabel = SKLabelNode(fontNamed:"Helvetica Bold")
        resumeLabel.fontSize = 36
        resumeLabel.text = "RESUME"
        resumeLabel.position = CGPoint(x: 0, y: resumeButton.frame.height + (resumeButton.frame.height/2) - (resumeLabel.frame.height/2) - 40)
        resumeLabel.name = "resumeLabel"
        
        let quitButton = SKShapeNode(rect: CGRect(x: -self.frame.width/4, y: -restartButton.frame.height - 40 - restartButton.frame.height/2, width: self.frame.width/2, height: 140), cornerRadius: 6)
        quitButton.fillColor = UIColor.black
        quitButton.name = "quitButton"
        
        let quitLabel = SKLabelNode(fontNamed:"Helvetica Bold")
        quitLabel.fontSize = 36
        quitLabel.text = "QUIT"
        let y = -quitButton.frame.height - (quitButton.frame.height/2) + (quitLabel.frame.height/2)
        quitLabel.position = CGPoint(x: 0, y: y)
        quitLabel.name = "quitLabel"
        
        let pauseFrame = SKShapeNode(rect: self.frame)
//        restartButton.fillColor = UIColor.black
        pauseFrame.name = "pauseFrame"
       
        restartButton.addChild(restartLabel)
        pauseFrame.addChild(restartButton)
        resumeButton.addChild(resumeLabel)
        pauseFrame.addChild(resumeButton)
        quitButton.addChild(quitLabel)
        pauseFrame.addChild(quitButton)
        
        self.addChild(pauseFrame)
        pauseFrame.zPosition = 1.0
        trump.zPosition = 0.0
        pauseChildren.append(pauseFrame)
//        pauseChildren.append(restartButton)
//        pauseChildren.append(resumeButton)
//        pauseChildren.append(quitButton)
    }
    
    func removePauseScreen() {
//        self.removeChildren(in: pauseChildren)
        self.removeChildren(in: pauseChildren)
        self.speed = 1
        pauseChildren = []
    }
    
    func setupGame() {
        
        firstTimerCounter = 0

        let bgTexture = SKTexture(imageNamed: "trump_space.png")
        let scale = self.frame.height / bgTexture.size().height
        let newWidth = bgTexture.size().width * scale
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -newWidth, dy: 0), duration: 60)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: newWidth, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
 
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: newWidth * i, y: self.frame.midY)
            
            bg.size.height = self.frame.height
            bg.size.width = newWidth

            
            bg.run(moveBGForever)
            
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
        
        trump.position = CGPoint(x: self.frame.midX - 100, y: -self.frame.height / 3.5)
        
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
        
        
        //        scoreLabel.fontName = "6809-chargen"
        scoreLabel.fontSize = 100
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 200)
        scoreLabel.fontColor = UIColor.white
        self.addChild(scoreLabel)
        
        if firstRound == true {
            tapToPlayLabel.fontSize = 36
            tapToPlayLabel.text = "Tap to Start..."
            tapToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 20)
            tapToPlayLabel.fontColor = UIColor.white
            tapToPlayLabel.name = "tapToPlay"
            self.addChild(tapToPlayLabel)
            firstRound = false
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func saveHighScore() {
        if score > highScore {
            print(score)
            UserDefaults.standard.set(score, forKey: "HIGHSCORE")
            highScore = UserDefaults().integer(forKey: "HIGHSCORE")
        }
    }
    
    func playPointSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "retro_point", ofType: "mp3")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    func playDeathSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "hit_wall", ofType: "mp3")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
    func playFallingSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "falling", ofType: "mp3")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    func playNewStageSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "America Great", ofType: "wav")
        let filePath2 = Bundle.main.path(forResource: "Greatest President", ofType: "wav")
      
        let randomNumber = arc4random_uniform(2)
        
        if randomNumber == 0 {
            soundURL = NSURL(fileURLWithPath: filePath!)
        } else if randomNumber == 1 {
            soundURL = NSURL(fileURLWithPath: filePath2!)
        }
        
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    func playHighScoreSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "congratulations", ofType: "mp3")
        let filePath2 = Bundle.main.path(forResource: "Bored Winning", ofType: "wav")
        
        let randomNumber = arc4random_uniform(2)
        
        if randomNumber == 0 {
            soundURL = NSURL(fileURLWithPath: filePath!)
        } else if randomNumber == 1 {
            soundURL = NSURL(fileURLWithPath: filePath2!)
        }

        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    func play60MarkSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "I'm really rich", ofType: "mp3")
        let filePath2 = Bundle.main.path(forResource: "Rich_2", ofType: "wav")
        
        let randomNumber = arc4random_uniform(2)
        
        if randomNumber == 0 {
            soundURL = NSURL(fileURLWithPath: filePath!)
        } else {
            soundURL = NSURL(fileURLWithPath: filePath2!)
        }
        
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
}

