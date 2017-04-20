//
//  MainMenuScene.swift
//  Levitating Monk
//
//  Created by Amandeep Singh on 2/5/17.
//  Copyright © 2017 Amandeep Singh. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "The Bold Font")
        gameBy.text = "FourSquare"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.gray
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        
        let gameName1 = SKLabelNode(fontNamed: "The Bold Font")
        gameName1.text = "Levitating"
        gameName1.fontSize = 180
        gameName1.fontColor = SKColor.gray
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode (fontNamed: "The Bold Font")
        gameName2.text = "Monk"
        gameName2.fontSize = 180
        gameName2.fontColor = SKColor.gray
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.625)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        let startGame = SKLabelNode(fontNamed: "The Bold Font")
        
        startGame.text = "Start Game"
        startGame.fontSize = 180
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
       startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch
            )
            
            if nodeITapped.name == "startButton"{
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            }
        }

         }




    
