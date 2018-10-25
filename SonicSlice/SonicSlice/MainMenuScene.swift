//
//  MainMenuScene.swift
//  TapMaster
//
//  Created by Kendrew Chan on 24/9/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "DiscsBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2 ,y: self.size.height/2 ) //position it in middle of screen
        background.zPosition = 0 //ensure layering
        self.addChild(background)
        
        let gameTitleLabel2 = SKLabelNode()
        gameTitleLabel2.fontName = "pacifo"
        gameTitleLabel2.text = "SonicSlice"
        gameTitleLabel2.fontSize = 275
        gameTitleLabel2.alpha = 0.75
        gameTitleLabel2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.65)
        gameTitleLabel2.fontColor = SKColor.init(colorLiteralRed: 0.1, green: 0.9, blue: 1, alpha: 0.95)
        gameTitleLabel2.zPosition = 1
        self.addChild(gameTitleLabel2)
        
        let howToPlayLabel = SKLabelNode()
        howToPlayLabel.text = "Swipe The Rings Before They Vanish!"
        howToPlayLabel.fontName = "pacifo"
        howToPlayLabel.fontSize = 75
        howToPlayLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.1)
        howToPlayLabel.fontColor = SKColor.white
        howToPlayLabel.zPosition = 1
        self.addChild(howToPlayLabel)
        
        let startLabel = SKLabelNode()
        startLabel.text = "Start"
        startLabel.fontName = "pacifo"
        startLabel.fontSize = 175
        startLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
        startLabel.fontColor = SKColor.green
        startLabel.zPosition = 1
        startLabel.name = "startButton"
        startLabel.run(blinkingAnimation())
        self.addChild(startLabel)
    }
    
    func blinkingAnimation() -> SKAction {
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.4)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.4)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touched: AnyObject in touches {
            let pointOnTouch = touched.location(in: self)
            let tappedNode = atPoint(pointOnTouch)
            let tappedNodeName = tappedNode.name
            
            if tappedNodeName == "startButton" {
                self.run(clickSound)
                let moveScene = GameScene(size: self.size)
                moveScene.scaleMode = self.scaleMode
                
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view!.presentScene(moveScene, transition: sceneTransition)
            }
        }
    }
}

