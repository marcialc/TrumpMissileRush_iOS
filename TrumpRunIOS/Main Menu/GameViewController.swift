//
//  GameViewController.swift
//  TrumpRunIOS
//
//  Created by Luis F. Perrone on 2/3/18.
//  Copyright © 2018 TrumpRun. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit


class GameViewController: BaseViewController, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var leaderBoardButton: UIButton!
    var firstTimePlaying = UserDefaults().integer(forKey: "FIRSTTIME")
    var currentScore = 0
    
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
    
    @IBAction func buttonAction(_ sender: Any) {
        switch ((sender as! UIButton).tag) {
        case 0:
             let trumpRunViewController = UIStoryboard.viewControllerMain(identifier: "trumpRunViewController") as! TrumpRunViewController
            self.navigationController?.present(trumpRunViewController, animated: false, completion: nil)
            break
        case 1:
            let helpViewControlller = UIStoryboard.viewControllerMain(identifier: "helpViewController") as! HelpViewController
            helpViewControlller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(helpViewControlller, animated: true, completion: nil)
            break
        case 2:
            let GCVC = GKGameCenterViewController()
            GCVC.gameCenterDelegate = self
            self.navigationController?.present(GCVC, animated: true, completion: nil)
        case 3:
            let settingsViewController = UIStoryboard.viewControllerMain(identifier: "settingsViewController") as! SettingsViewController
            settingsViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(settingsViewController, animated: true, completion: nil)
            break
        case 4:
            let themesViewController = UIStoryboard.viewControllerMain(identifier: "themesViewController") as! ThemesViewController
            themesViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.navigationController?.present(themesViewController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setHighScore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authPlayer()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
        
        if firstTimePlaying == 0 {
            let tutorialViewController = UIStoryboard.viewControllerMain(identifier: "tutorialViewController") as! TutorialViewController
            //            tutorialViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(tutorialViewController, animated: true, completion: nil)
            UserDefaults.standard.set(1, forKey: "FIRSTTIME")
            print("IM HERE!")
        }
        
        prepare()
        setHighScore()
    }
    
    func prepare() {
        playButton.layer.cornerRadius = 6.0
        leaderBoardButton.layer.cornerRadius = 6.0
        helpView.layer.cornerRadius = helpView.frame.width/2
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setHighScore() {
        highScore = UserDefaults().integer(forKey: "HIGHSCORE")
        highscoreLabel.text = "HIGHSCORE: \(String(highScore))"
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "TrumpRushHS")
            
            scoreReporter.value = Int64(highScore)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    func authPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
    }
}
