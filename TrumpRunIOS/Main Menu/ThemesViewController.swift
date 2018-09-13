//
//  ThemesViewController.swift
//  TrumpRunIOS
//
//  Created by Luis F. Perrone on 2/10/18.
//  Copyright © 2018 TrumpRun. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var grntThemeView: UIView!
    @IBOutlet weak var originalThemeView: UIView!
    var currentTheme = UserDefaults().integer(forKey: "THEMENUMBER")

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
            setTheme(themeNumber: 1)
            break
        case 2:
            setTheme(themeNumber: 0)
            break
        default:
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
        
        if currentTheme == 1 {
            grntThemeView.alpha = 0.0
            originalThemeView.alpha = 0.2
        }
    }

    func setTheme(themeNumber: Int) {
        UserDefaults.standard.set(themeNumber, forKey: "THEMENUMBER")
        
        if themeNumber == 1 {
            originalThemeView.alpha = 0.2
            grntThemeView.alpha = 0.0
        } else {
            grntThemeView.alpha = 0.2
            originalThemeView.alpha = 0.0
        }
    }

}
