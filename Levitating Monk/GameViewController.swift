//
//  GameViewController.swift
//  Levitating Monk
//
//  Created by Amandeep Singh on 2/4/17.
//  Copyright © 2017 Amandeep Singh. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation



class GameViewController: UIViewController {
    
    var backingAudio = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "sound", ofType: "wav")
        let audioNSURL = NSURL(fileURLWithPath: filePath!)
    
        do {backingAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL)}
        catch {return print("Cannot Find The Audio")}
        
        backingAudio.numberOfLoops = -1
        backingAudio.play()
        
        
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFill
        
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
