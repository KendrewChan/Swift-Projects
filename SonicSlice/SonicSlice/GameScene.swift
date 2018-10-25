//
//  GameScene.swift
//  TapMaster
//
//  Created by Kendrew Chan on 23/9/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import AVKit

var scoreNum = -1 //declared outside of GameScene, thus can be used in other scenes
let playCorrectSoundEffect = SKAction.playSoundFileNamed("Correct.wav", waitForCompletion: false)


class GameScene: SKScene {
    
    let scoreLabel = SKLabelNode() //to set up font
    var player = AVAudioPlayer() //sets audioplayer as var
    let audioPath = Bundle.main.path(forResource: "gameMusic", ofType: "wav")
    
    //TouchPoints
    var activeSlicePoints = [CGPoint]();
    
    //Slash Mechanic
    var activeSliceBG: SKShapeNode!;
    var activeSliceFG: SKShapeNode!;
    let sliceLength = 4;
 
    
    let playGameOverSoundEffect = SKAction.playSoundFileNamed("GameOverSound.wav", waitForCompletion: false)
    
    let gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let gameAreaMargin = (size.width - playableWidth)/2
        gameArea = CGRect(x: gameAreaMargin, y:0, width: playableWidth, height: size.height - size.height*0.20)
        
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) { //useless code
        fatalError("init(code: ) has not been implemented") //useless code
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    func createSlices()
    {
        activeSliceBG = SKShapeNode();
        activeSliceBG.zPosition = 2;
        activeSliceBG.strokeColor = UIColor.white
        activeSliceBG.alpha = 0.6
        activeSliceBG.lineWidth = 15;
        
        addChild(activeSliceFG);
    }
    
    //Create path based on slice points positions.
    func redrawActiveSlice()
    {
        //Not enough data - early out
        guard activeSlicePoints.count > 2 else { self.activeSliceFG.path = nil; self.activeSliceBG.path = nil; return; } //if activeSlicePoints.count < 2 { self.activeSliceFG.path = nil; self.activeSliceBG.path = nil; return; }
        
        while activeSlicePoints.count > sliceLength //repeat code while etc occurs
        {
            //Pop oldest slice points, maintains the length of slice
            activeSlicePoints.remove(at: 0);
        }
        
        //Construct path
        let path = UIBezierPath();
        path.move(to: activeSlicePoints[0]);
        
        for index in 1..<activeSlicePoints.count
        {
            path.addLine(to: activeSlicePoints[index]);
        }
        
        //Assign path
        activeSliceBG.path = path.cgPath;
        activeSliceFG.path = path.cgPath;
    }
    
    override func didMove(to view: SKView) {
        createSlices()
        
        scoreNum = -1 //reset scoreNum otherwise scoreNum from previous game will be carried over
        
        do {
            
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            
            
        } catch {
            
            // process error
            
        }
        
        player.play()
        
        let background = SKSpriteNode(imageNamed: "DiscsBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2 ,y: self.size.height/2 ) //position it in middle of screen
        background.zPosition = 0 //ensure layering
        self.addChild(background) //final code to tell xcode to make the background
    
        let disc = SKSpriteNode(imageNamed: "DiscsBackground")
        disc.size = self.size
        disc.position = CGPoint(x: self.size.width/2, y: self.size.height/2) //position in middle of screen
        disc.name = "discObject"
        disc.zPosition = 0
        self.addChild(disc)
        
        scoreLabel.fontSize = 250
        scoreLabel.text = "0"
        scoreLabel.fontName = "pacifo"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.zPosition = 1 //make sure label is overlaid above background
        scoreLabel.position = CGPoint(x: self.size.width/2 /* middle of x axis */ , y: self.size.height*0.80)
        self.addChild(scoreLabel)
    }
    
    func spawnNewDisc() {
        var randomImage = arc4random()%4
        randomImage += 1 //since array of arc4random is 0,1,2,3 instead of 1,2,3,4
        
        let disc = SKSpriteNode(imageNamed: "Disc")
        disc.zPosition = 1
        disc.name = "discObject"
        
        let randomX = random(min: gameArea.minX + disc.size.width/2 , max: gameArea.maxX - disc.size.width/2 )
        let randomY = random(min: gameArea.minY + disc.size.height/2 , max: gameArea.maxY - disc.size.height/2 )
        disc.position = CGPoint(x: randomX, y: randomY) //for random position
        self.addChild(disc) //add the discs
        
        disc.run(SKAction.sequence([SKAction.scale(to: 0, duration: 2), playGameOverSoundEffect, SKAction.run(runGameOver) ]))
    }
   
    //transfer to gameOverScene
    func runGameOver() {
        let moveScene = GameOverScene(size: self.size) //to ensure GameOverScene has same screen size as this
        moveScene.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(moveScene, transition: sceneTransition)
        player.stop()
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touched: AnyObject in touches{
            let positionOfTouch = touched.location(in: self)//set var to position of screen touched
            let tappedNode = atPoint(positionOfTouch) //for when "discs" are touched
            let nameOfTappedNode = tappedNode.name
            
            if nameOfTappedNode == "discObject" {
                tappedNode.name = "" //to remove glitch of multiple taps whilst disc is spawned
                tappedNode.removeAllActions() //remove actions from node, removes glitch of multiple taps
                tappedNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1),
                                                  SKAction.removeFromParent()]))
                self.run(playCorrectSoundEffect)
                
                spawnNewDisc()
                scoreNum += 1
                scoreLabel.text = String(scoreNum) //or "\(scoreNum)"
                
                if scoreNum == 5 || scoreNum == 25 || scoreNum == 100 || scoreNum == 250 || scoreNum == 1000 { spawnNewDisc() }
        }
    }
    
    
            activeSlicePoints.removeAll(keepingCapacity: true); //remove initial/previous CGpoint?
            
            guard let vTouch = touches.first else { return; } //guard statements only run if the conditions are not met, helps to prevent errors?
            let touchLocation = vTouch.location(in: self); //finds touch location
            activeSlicePoints.append(touchLocation); //adds CGpoint where touch begins
            
            //Bezier Curve Construction
            redrawActiveSlice();
            
            activeSliceBG.removeAllActions();
            activeSliceFG.removeAllActions();
            
            activeSliceBG.alpha = 1.0;
            activeSliceFG.alpha = 1.0;
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        guard let vTouch = touches.first else { return; } //guard allows code to run if initial statement is false
        let positionOfTouch = vTouch.location(in: self);
        activeSlicePoints.append(positionOfTouch);
        
        //Bezier Curve Construction
        redrawActiveSlice();
        
        let nodesAtPoint = nodes(at: positionOfTouch);
        
        for tappedNode in nodesAtPoint
        {
            if tappedNode.name == "discObject"
            {
                
                //Prevent multiple swipes
                tappedNode.name = "";
                
                tappedNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1),
                                                  SKAction.removeFromParent()]))
                
                self.run(playCorrectSoundEffect)
                
                spawnNewDisc()
                scoreNum += 1
                scoreLabel.text = String(scoreNum) //or "\(scoreNum)"
                
                if scoreNum == 5 || scoreNum == 25 || scoreNum == 100 || scoreNum == 250 || scoreNum == 1000 { spawnNewDisc() }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>?, with event: UIEvent?)
    {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25));
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25));
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?)
    {
        guard let vTouches = touches else { return; }
        touchesEnded(vTouches, with: event);
    }
}
