//
//  SettingsViewController.swift
//  TrumpRunIOS
//
//  Created by Luis F. Perrone on 2/6/18.
//  Copyright © 2018 TrumpRun. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var helpbackButton_2: UIButton!
    @IBOutlet weak var resetHighScoreButton: UIButton!
    
    @IBAction func buttonAction(_ sender: Any) {
        
        switch ((sender as! UIButton).tag) {
        case 0:
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
            break
        case 1:
            UserDefaults.standard.set(0, forKey: "HIGHSCORE")
            break
        default:
            let tutorialViewController = UIStoryboard.viewControllerMain(identifier: "tutorialViewController") as! TutorialViewController
            tutorialViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(tutorialViewController, animated: true, completion: nil)
            break
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepare() {
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
        
        resetHighScoreButton.layer.cornerRadius = 6.0
        resetHighScoreButton.layer.shadowColor = UIColorFromRGB(rgbValue: 0x212121).cgColor
        resetHighScoreButton.layer.shadowOpacity = 0.3
        resetHighScoreButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
