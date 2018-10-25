//
//  GameOverScene.swift
//  TapMaster
//
//  Created by Kendrew Chan on 24/9/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import Foundation
import  SpriteKit

let clickSound = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)

class GameOverScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        
        var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
        
        let background = SKSpriteNode(imageNamed: "DiscsBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2 ,y: self.size.height/2 ) //position it in middle of screen
        background.zPosition = 0 //ensure layering
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed:"pacifo")
        gameOverLabel.text = "GameOver"
        gameOverLabel.fontSize = 225
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.8)
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let finalScoreLabel = SKLabelNode(fontNamed:"pacifo")
        finalScoreLabel.text = "Score: \(scoreNum)"
        finalScoreLabel.fontSize = 100
        finalScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.6)
        finalScoreLabel.zPosition = 1
        self.addChild(finalScoreLabel)
        
        
        if scoreNum > highScore {
            highScore = scoreNum
            UserDefaults.standard.set(scoreNum, forKey: "HIGHSCORE")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed:"pacifo")
        highScoreLabel.text = "HighScore: \(highScore)"
        highScoreLabel.fontSize = 100
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        let restartLabel = SKLabelNode(fontNamed:"pacifo")
        restartLabel.text = "Restart"
        restartLabel.fontSize = 150
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        restartLabel.fontColor = SKColor.green
        restartLabel.zPosition = 1
        restartLabel.name = "restartButton"
        self.addChild(restartLabel)
        
        let exitLabel = SKLabelNode(fontNamed:"pacifo")
        exitLabel.text = "Exit"
        exitLabel.fontSize = 150
        exitLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        exitLabel.fontColor = SKColor.red
        exitLabel.zPosition = 1
        exitLabel.name = "exitButton"
        self.addChild(exitLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touched: AnyObject in touches {
            let positionOfTouch = touched.location(in: self)//set var to position of screen touched
            let tappedNode = atPoint(positionOfTouch) //for when "discs" are touched
            let nameOfTappedNode = tappedNode.name
            
            if nameOfTappedNode == "restartButton" {
                self.run(clickSound)
                let moveScene = GameScene(size: self.size) //to ensure GameOverScene has same screen size as this
                moveScene.scaleMode = self.scaleMode
                
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view!.presentScene(moveScene, transition: sceneTransition)
            }
            
            if nameOfTappedNode == "exitButton" {
                self.run(clickSound)
                let moveScene = MainMenuScene(size: self.size) //to ensure GameOverScene has same screen size as this
                moveScene.scaleMode = self.scaleMode
                
                let sceneTransition = SKTransition.fade(withDuration: 0.2)
                self.view!.presentScene(moveScene, transition: sceneTransition)
            }
        }
    }
}
