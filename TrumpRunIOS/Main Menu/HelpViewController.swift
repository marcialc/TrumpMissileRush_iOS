//
//  HelpViewController.swift
//  TrumpRunIOS
//
//  Created by Marcial Cabrera on 2/3/18.
//  Copyright © 2018 TrumpRun. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController {

    @IBOutlet weak var rulesView: UIView!
//    @IBOutlet weak var gifView: UIImageView!
    
    @IBOutlet weak var helpbackButton: UIButton!
    @IBOutlet weak var helpbackButton_2: UIButton!
    
    
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
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            break
        case 2:
            UserDefaults.standard.set(0, forKey: "HIGHSCORE")
            break
        default:
            break
            
            
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        gifView.loadGif(name: "trump_running")
        prepare()
        
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        helpbackButton_2.layer.cornerRadius = 6.0
        helpbackButton_2.layer.shadowColor = UIColorFromRGB(rgbValue: 0x212121).cgColor
        helpbackButton_2.layer.shadowOpacity = 0.3
        helpbackButton_2.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        rulesView.layer.shadowColor = UIColorFromRGB(rgbValue: 0x212121).cgColor
        rulesView.layer.shadowOpacity = 0.3
        rulesView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
