//
//  GameViewController.swift
//  Flappy Bird
//
//  Created by Rob Percival on 05/07/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var currentPage = 0
    
    @IBAction func skipAction(_ sender: Any) {
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    @IBAction func nextAction(_ sender: Any) {
        
        if currentPage < 2 {
            scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat((currentPage + 1)), y: scrollView.contentOffset.y), animated: true)
//            pageControlView.currentPage = currentPage + 1
            currentPage += 1
            if currentPage == 2 {
                self.nextButton.alpha = 0.0
                self.getStartedButton.alpha = 1.0
            }
        } else {
            
        }
    }
    
    var slidesArray = [TutorialSlide]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "TutorialScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            //            view.showsFPS = true
            //            view.showsNodeCount = true
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        prepareLayout()
        
        //        setGradientBackground()
        //        let backgroundLayer = colors.gl
        //        backgroundLayer?.frame = createAnAccountButton.frame
        //        createAnAccountButton.layer.insertSublayer(backgroundLayer!, at: 0)
        
        // Calculate Sunrise and Sunset
        //        setUpTheme()
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        // Do any additional setup after loading the view, typically from a nib.
        //        self.navigationController?.isNavigationBarHidden = true
        
        
        scrollView.delegate = self
        let slides:[TutorialSlide] = creatSlides()
        setUpSlideScrollView(slides)
    
        
        //        slide2Image.image = slide2Image.image!.withRenderingMode(.alwaysTemplate)
        //        slide3Image.image = slide3Image.image!.withRenderingMode(.alwaysTemplate)
        //        slide4Image.image = slide4Image.image!.withRenderingMode(.alwaysTemplate)
        
//        logInButton.layer.cornerRadius = 6
        //        logInButton.layer.shadowColor = UIColorFromRGB(rgbValue: 0x212121).cgColor
        
        //        logInButton.layer.shadowOpacity = 0.3
        //        logInButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        //        logInButton.layer.shadowRadius = 3.0
        
//        createAnAccountButton.layer.cornerRadius = 6
//        createAnAccountButton.layer.borderWidth = 2
        //        createAnAccountButton.layer.borderColor = UIColorFromRGB(rgbValue: 0xfcfcfa).withAlphaComponent(0.4)
        //        startColorAnimation()
        
        
    }
    
    func prepareLayout() {
        
        scrollView.isUserInteractionEnabled = false
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTap)
        self.edgesForExtendedLayout = UIRectEdge.all;
        getStartedButton.layer.cornerRadius = 6.0
        
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        // Perform operation
    }
    
    
    func creatSlides() -> [TutorialSlide] {
        let slide1:TutorialSlide = Bundle.main.loadNibNamed("Slide1", owner: self, options: nil)!.first as! TutorialSlide
        
       
        let slide2:TutorialSlide = Bundle.main.loadNibNamed("Slide2", owner: self, options: nil)!.first as! TutorialSlide
        
        slide2.backgroundView.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = slide2.backgroundView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.clipsToBounds = true
//        slide2.backgroundView.addSubview(blurEffectView)
//        slide2.backgroundView.sendSubview(toBack: blurEffectView)
        //        slide1.continueButton.layer.borderWidth = 1.0
        //        slide1.continueButton.borderColor = UIColorFromRGB(rgbValue: 0xe0e0e0)
        let slide3:TutorialSlide = Bundle.main.loadNibNamed("Slide3", owner: self, options: nil)!.first as! TutorialSlide
        
        slide3.backgroundViewTwo.backgroundColor = UIColor.clear
        
        let blurEffectView2 = UIVisualEffectView(effect: blurEffect)
        blurEffectView2.frame = slide3.backgroundViewTwo.bounds
        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView2.clipsToBounds = true
        slide3.backgroundViewTwo.addSubview(blurEffectView2)
        slide3.backgroundViewTwo.sendSubview(toBack: blurEffectView2)

    
        return[slide1,slide2,slide3]
        
    }
    
    //    func setUpTheme() {
    //        let solar = Solar(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
    //        let isDaytime = solar?.isDaytime
    //        if(isDaytime)! {
    //            self.dayTime = true
    //            self.view.backgroundColor = UIColorFromRGB(rgbValue: 0xFCFCFA)
    //            self.createAnAccountButton.setTitleColor(UIColorFromRGB(rgbValue: 0xFCFCFA), for: UIControlState.normal)
    //            self.pageControlView.currentPageIndicatorTintColor = UIColorFromRGB(rgbValue: 0x040D14)
    //        }
    //
    //    }
    
    func setUpSlideScrollView(_ slides: [TutorialSlide]) {
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: self.scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i])
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
//        pageControlView.currentPage = Int(pageIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


