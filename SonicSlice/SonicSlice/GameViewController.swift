//
//  GameViewController.swift
//  TapMaster
//
//  Created by Kendrew Chan on 23/9/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController {

    @IBOutlet weak var gadBanner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GAD loaded" + GADRequest.sdkVersion())
        
        gadBanner.adUnitID = "ca-app-pub-2786926870945068/6406274951"
        gadBanner.rootViewController = self
        gadBanner.load(GADRequest())
        
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.ignoresSiblingOrder = true
            skView.presentScene(scene)
            
    
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
}
