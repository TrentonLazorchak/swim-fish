//
//  GameScene.swift
//  SwimFish
//
//  Created by Trenton Lazorchak on 4/12/19.
//  Copyright © 2019 Trenton Lazorchak. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    var isTouching = Bool(false)
    var isHTP = Bool(false)
    var isJelly = Bool(false)
    var isShark = Bool(false)
    
    let coinSound = SKAction.playSoundFileNamed("CoinSound.caf", waitForCompletion: false)
    let jellySound = SKAction.playSoundFileNamed("JellySound.caf", waitForCompletion: false)
    let sharkSound = SKAction.playSoundFileNamed("SharkSound.caf", waitForCompletion: false)
    let hookSound = SKAction.playSoundFileNamed("HookSound.caf", waitForCompletion: false)
    let startGame = SKAction.playSoundFileNamed("bubble.caf", waitForCompletion: false)
    
    var score = Int(0)
    
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var box = SKSpriteNode()
    
    var howToPlay = SKNode()
    var howToPlayBtn = SKNode()
    
    var unpause = SKLabelNode()
    var pause = SKLabelNode()
    var newhigh = SKNode()
    
    var muteMusic = SKNode()
    var muteAll = SKNode()
    var isMusic = Bool(true)
    
    var coinNode = SKSpriteNode()
    var jellyCoin = SKNode()
    var hookCoin = SKNode()
    var sharkCoin = SKNode()
    
    var moveAndRemoveHook = SKAction()
    var moveAndRemoveJelly = SKAction()
    var moveAndRemoveShark = SKAction()
    
    // Creates fish atlas for animation
    let fishAtlas = SKTextureAtlas(named:"fish")
    var fishSprites = Array<Any>()
    var fish = SKSpriteNode()
    var repeatActionFish = SKAction()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    // Called when screen is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // create musicplayer object
        let music = MusicPlayer()
        // check to see if how to play is pressed
        for touch in touches{
            let location = touch.location(in: self)
            
            if howToPlayBtn.contains(location) && isGameStarted == false {
                if isHTP == false {
                    isHTP = true
                    self.addChild(createHTPNode())
                    howToPlayBtn.removeFromParent()
                    highscoreLbl.removeFromParent()
                    return
                }
            }
            else if muteMusic.contains(location) && isGameStarted == false {
                if(isMusic == true) {
                    music.pauseMusic()
                    isMusic = false
                    box.texture = SKTexture(imageNamed: "unchecked")
                    return
                } else {
                    music.resumeMusic()
                    isMusic = true
                    box.texture = SKTexture(imageNamed: "checked")
                    return
                }
            }
            
            
        }
        // if how to play is open, close it
        if isHTP == true {
            howToPlay.removeFromParent()
            self.addChild(howToPlayBtn)
            self.addChild(highscoreLbl)
            isHTP = false
            return
        }
        
        // if game is paused, unpause
        if self.isPaused {
            self.isPaused = false
            //pauseBtn.texture = SKTexture(imageNamed: "pause")
            self.addChild(pauseBtn)
            pause.removeFromParent()
            unpause.removeFromParent()
            isTouching = true
            return
       }
        
        // if game is not started start game
        if isGameStarted == false{
            run(startGame)
            
            isTouching = true
            
            // Set isGameStarted to true, set gravity to true and create pause button
            isGameStarted = true
            fish.physicsBody?.affectedByGravity = true
            createPauseBtn()
            
            // Scales logo to half its size in 0.3 secs then removes it
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            
            taptoplayLbl.removeFromParent()
            howToPlayBtn.removeFromParent()
            highscoreLbl.removeFromParent()
            muteMusic.removeFromParent()
            
            // Runs the animation for the fish
            self.fish.run(repeatActionFish)
            
            // Spawns a hook every 2 seconds, repeats forever
            let spawnHook = SKAction.run({
                () in
                self.hookCoin = self.createHooks()
                self.addChild(self.hookCoin)
            })
            let delayHook = SKAction.wait(forDuration: 2.0)
            let spawnDelayHook = SKAction.sequence([spawnHook, delayHook])
            let spawnDelayHookForever = SKAction.repeatForever(spawnDelayHook)
            self.run(spawnDelayHookForever)
            
            // Moves and removes hooks
            let distanceHook = CGFloat(self.frame.width + hookCoin.frame.width)
            //let moveHooks = SKAction.moveBy(x: -distanceHook-50, y: 0, duration: TimeInterval(0.008*distanceHook))
            let moveHooks = SKAction.moveBy(x: -distanceHook - (self.frame.width * 0.1333333333), y: 0, duration: TimeInterval(0.008*distanceHook))
            let removeHooks = SKAction.removeFromParent()
            moveAndRemoveHook = SKAction.sequence([moveHooks, removeHooks])
            
            // Moves and removes jellyfish
            let distanceJelly = CGFloat(self.frame.width + jellyCoin.frame.width)
            //let moveJelly = SKAction.moveBy(x: -distanceJelly-550, y: 0, duration: TimeInterval(0.010*distanceJelly))
            let moveJelly = SKAction.moveBy(x: -distanceJelly-(self.frame.width * 1.466666667), y: 0, duration: TimeInterval(0.010*distanceJelly))
            let removeJelly = SKAction.removeFromParent()
            moveAndRemoveJelly = SKAction.sequence([moveJelly, removeJelly])
            
            // Moves and removes the sharks
            let distanceShark = CGFloat(self.frame.width + sharkCoin.frame.width)
            //let moveShark = SKAction.moveBy(x: -distanceShark-850, y: 0, duration: TimeInterval(0.010 * distanceShark))
            let moveShark = SKAction.moveBy(x: -distanceShark-(self.frame.width * 2.266666667), y: 0, duration: TimeInterval(0.010 * distanceShark))
            let removeShark = SKAction.removeFromParent()
            moveAndRemoveShark = SKAction.sequence([moveShark, removeShark])
            
            // Set fish velocity and impulse to 0
            fish.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            fish.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
        } else {
            // Sets is touching to true if the game is started and applies a small impulse
            isTouching = true
        }
        
        // Check to see if pause or restart button is pressed
        for touch in touches{
            let location = touch.location(in: self)
            // restart button
            if isDied == true{
                if restartBtn.contains(location){
                    restartScene()
                }
            } else {
                // pause and play button
                if pauseBtn.contains(location) && self.isPaused == false {
                    self.isPaused = true
                    self.addChild(createUnpause())
                    self.addChild(createPaused())
                    //pauseBtn.texture = SKTexture(imageNamed: "play")
                    pauseBtn.removeFromParent()
                }
            }
        }
    }
    
    // Does this when finger is lifted from the screen (when touch ends)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Sets isTouching to false
        isTouching = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true{
            if isDied == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                    }
                }))
                // If isTouching is true, fish goes up, if not fish goes down
                if(isTouching == true) {
                    self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 8.0)
                } else {
                    self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
                }
            }
            
        } else {
            // After the fish dies, reset the boolean to false
            isJelly = false
            isShark = false
        }
    }
    
    func createScene() {
        self.physicsWorld.speed = 0.9999
        // Fish will bounce off walls
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.fishCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        // Create Background
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x: self.frame.width * CGFloat(i), y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        // Set up the fish sprites for animation
        fishSprites.append(fishAtlas.textureNamed("fish1"))
        fishSprites.append(fishAtlas.textureNamed("fish2"))
        
        // Adds fish to game scene
        self.fish = createFish()
        self.addChild(fish)
        
        // Prepare to animate the fish and repeat the animation forever
        let animateFish = SKAction.animate(with: self.fishSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionFish = SKAction.repeatForever(animateFish)
        
        // Adds score label, highscore label, logo, and tap to play label to the scene
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        
        howToPlayBtn = createHTPBtn()
        self.addChild(howToPlayBtn)
        
        muteMusic = createMuteMusic()
        self.addChild(muteMusic)
        if(isMusic) {
            box.texture = SKTexture(imageNamed: "checked")
        } else {
            box.texture = SKTexture(imageNamed: "unchecked")
        }
    }
    
    // Detects contacts and collision between different physics objects
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        
        // If fish hits ground do this
        if  firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory {
            
            enumerateChildNodes(withName: "hookCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
 
            enumerateChildNodes(withName: "jellyCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            enumerateChildNodes(withName: "sharkCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
 
            if isDied == false{
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                fish.removeAllActions()
                // sets new highscore
                if UserDefaults.standard.object(forKey: "highestScore") != nil {
                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                    if hscore < Int(scoreLbl.text!)!{
                        UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        // creates a new high score label if a new highscore is obtained
                        // create new highscore label
                        newhigh = createNewHighscore()
                        self.addChild(newhigh)
                    }
                } else {
                    UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                    newhigh = createNewHighscore()
                    self.addChild(newhigh)
                }
            }

        }
        // If fish hits a coin
        else if firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.coinCategory {
            
            secondBody.node?.removeFromParent()
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            
            // If the score is 5, spawn the jellyfish
            if(isJelly == false && score == 5) {
                let spawnJelly = SKAction.run({
                    () in
                    self.jellyCoin = self.createJelly()
                    self.addChild(self.jellyCoin)
                })
                let delayJelly = SKAction.wait(forDuration: 2.0)
                let spawnDelayJelly = SKAction.sequence([spawnJelly, delayJelly])
                let spawnDelayJellyForever = SKAction.repeatForever(spawnDelayJelly)
                self.run(spawnDelayJellyForever)
                isJelly = true
            }
            
            // If the score is 10, spawn the sharks
            if(isShark == false && score == 10) {
                let spawnShark = SKAction.run({
                    () in
                    self.sharkCoin = self.createShark()
                    self.addChild(self.sharkCoin)
                })
                let delayShark = SKAction.wait(forDuration: 7.0)
                let spawnDelayShark = SKAction.sequence([delayShark, spawnShark])
                let spawnDelaySharkForever = SKAction.repeatForever(spawnDelayShark)
                self.run(spawnDelaySharkForever)
                isShark = true
            }
            
            
        } else if firstBody.categoryBitMask == CollisionBitMask.coinCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory {
            
            firstBody.node?.removeFromParent()
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            
            // If the score is 5, spawn the jellyfish
            if(isJelly == false && score == 5) {
                let spawnJelly = SKAction.run({
                    () in
                    self.jellyCoin = self.createJelly()
                    self.addChild(self.jellyCoin)
                })
                let delayJelly = SKAction.wait(forDuration: 2.0)
                let spawnDelayJelly = SKAction.sequence([spawnJelly, delayJelly])
                let spawnDelayJellyForever = SKAction.repeatForever(spawnDelayJelly)
                self.run(spawnDelayJellyForever)
                isJelly = true
            }
            
            // If the score is 10, spawn the sharks
            if(isShark == false && score == 10) {
                let spawnShark = SKAction.run({
                    () in
                    self.sharkCoin = self.createShark()
                    self.addChild(self.sharkCoin)
                })
                let delayShark = SKAction.wait(forDuration: 7.0)
                let spawnDelayShark = SKAction.sequence([delayShark, spawnShark])
                let spawnDelaySharkForever = SKAction.repeatForever(spawnDelayShark)
                self.run(spawnDelaySharkForever)
                isShark = true
            }
            
            
        }
        // If fish hits a hook
        else if firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.hookCategory || firstBody.categoryBitMask == CollisionBitMask.hookCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory {
            
            enumerateChildNodes(withName: "jellyCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            enumerateChildNodes(withName: "sharkCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            enumerateChildNodes(withName: "hookCoin", using: ({
                (node, error) in
                self.removeAllActions()
                node.childNode(withName: "coin")?.speed = 0
            }))

            if isDied == true {
                fish.removeAllActions()
            }
            if isDied == false{
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                fish.removeAllActions()
                fish.run(hookSound)
                fish.physicsBody?.isDynamic = false
                
                self.fish.physicsBody?.affectedByGravity = false
                //let moveUp = SKAction.moveBy(x: 0, y: 500, duration: TimeInterval(1))
                let moveUp = SKAction.moveBy(x: 0, y: self.frame.height * 0.7496251874, duration: TimeInterval(1))
                //let moveHookUp = SKAction.moveBy(x: 0, y: 500, duration: TimeInterval(1))
                let moveHookUp = SKAction.moveBy(x: 0, y: self.frame.height * 0.7496251874, duration: TimeInterval(1))
                if(firstBody.categoryBitMask == CollisionBitMask.hookCategory) {
                    secondBody.node?.run(moveUp)
                    firstBody.node?.removeAllActions()
                    firstBody.node?.run(moveHookUp)
                } else if(secondBody.categoryBitMask == CollisionBitMask.hookCategory) {
                    firstBody.node?.run(moveUp)
                    secondBody.node?.removeAllActions()
                    secondBody.node?.run(moveHookUp)
                }
                if UserDefaults.standard.object(forKey: "highestScore") != nil {
                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                    if hscore < Int(scoreLbl.text!)!{
                        UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        // creates a new high score label if a new highscore is obtained
                        // create new highscore label
                        newhigh = createNewHighscore()
                        self.addChild(createNewHighscore())
                    }
                } else {
                    UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                    // create new highscore label
                    newhigh = createNewHighscore()
                    self.addChild(newhigh)
                }
            }
        }
        // If fish hits a jelly fish
        else if firstBody.categoryBitMask == CollisionBitMask.fishCategory && secondBody.categoryBitMask == CollisionBitMask.jellyCategory || firstBody.categoryBitMask == CollisionBitMask.jellyCategory && secondBody.categoryBitMask == CollisionBitMask.fishCategory {
            
            enumerateChildNodes(withName: "hookCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
 
            
            enumerateChildNodes(withName: "jellyCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
 
            enumerateChildNodes(withName: "sharkCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
 
            
            if isDied == false{
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                fish.removeAllActions()
                fish.run(jellySound)
                if UserDefaults.standard.object(forKey: "highestScore") != nil {
                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                    if hscore < Int(scoreLbl.text!)!{
                        UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        // creates a new high score label if a new highscore is obtained
                        // create new highscore label
                        newhigh = createNewHighscore()
                        self.addChild(newhigh)
                    }
                } else {
                    UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                    // create new highscore label
                    newhigh = createNewHighscore()
                    self.addChild(newhigh)
                }
            }

        }
        // If the fish hits a shark
        else if firstBody.categoryBitMask == CollisionBitMask.fishCategory &&
            secondBody.categoryBitMask == CollisionBitMask.sharkCategory ||
            firstBody.categoryBitMask == CollisionBitMask.sharkCategory &&
            secondBody.categoryBitMask == CollisionBitMask.fishCategory {
            
            enumerateChildNodes(withName: "hookCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            enumerateChildNodes(withName: "jellyCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            enumerateChildNodes(withName: "sharkCoin", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            if isDied == false{
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                fish.removeAllActions()
                self.run(sharkSound)
                fish.removeFromParent()
                if UserDefaults.standard.object(forKey: "highestScore") != nil {
                    let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                    if hscore < Int(scoreLbl.text!)!{
                        UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        // creates a new high score label if a new highscore is obtained
                        // create new highscore label
                        newhigh = createNewHighscore()
                        self.addChild(newhigh)
                    }
                } else {
                    UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                    // create new highscore label
                    newhigh = createNewHighscore()
                    self.addChild(newhigh)
                }
            }
            
        }
 
    }
    
    // Restarts the scene. Called when fish dies
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
    }
}
