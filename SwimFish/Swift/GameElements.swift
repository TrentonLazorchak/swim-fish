//
//  GameElements.swift
//  SwimFish
//
//  Created by Trenton Lazorchak on 4/12/19.
//  Copyright © 2019 Trenton Lazorchak. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let fishCategory:UInt32 = 0x1 << 0
    static let coinCategory:UInt32 = 0x1 << 1
    static let groundCategory:UInt32 = 0x1 << 2
    static let hookCategory:UInt32 = 0x1 << 3
    static let jellyCategory:UInt32 = 0x1 << 4
    static let sharkCategory:UInt32 = 0x1 << 5
}

extension GameScene {

    // Creates fish sprite
    func createFish() -> SKSpriteNode {
        let fish = SKSpriteNode(texture: SKTextureAtlas(named: "fish").textureNamed("fish1"))
        //fish.size = CGSize(width: 50, height: 50)
        fish.size = CGSize(width: self.frame.width * 0.133333333, height: self.frame.height * 0.07496252)
        fish.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        fish.physicsBody = SKPhysicsBody(circleOfRadius: fish.size.width/2.5)
        fish.physicsBody?.linearDamping = 2
        fish.physicsBody?.restitution = 0
        
        fish.physicsBody?.categoryBitMask = CollisionBitMask.fishCategory
        fish.physicsBody?.collisionBitMask = CollisionBitMask.hookCategory | CollisionBitMask.groundCategory | CollisionBitMask.jellyCategory | CollisionBitMask.sharkCategory
        fish.physicsBody?.contactTestBitMask = CollisionBitMask.hookCategory | CollisionBitMask.coinCategory | CollisionBitMask.groundCategory | CollisionBitMask.jellyCategory | CollisionBitMask.sharkCategory
        
        fish.physicsBody?.affectedByGravity = false
        fish.physicsBody?.isDynamic = true
        
        return fish
    }
    
    
    // Creates restart button
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        //restartBtn.size = CGSize(width: 100, height: 100)
        restartBtn.size = CGSize(width: self.frame.width * 0.26666667, height: self.frame.height * 0.14992504)
        restartBtn.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    // Creates pause button
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        //pauseBtn.size = CGSize(width: 60, height: 60)
        pauseBtn.size = CGSize(width: self.frame.width * 0.16, height: self.frame.height * 0.08995502)
        //pauseBtn.position = CGPoint(x: self.frame.width - 40, y: 40)
        pauseBtn.position = CGPoint(x: self.frame.width * 0.10666667, y: self.frame.height * 0.05997001)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    // Creates score label
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        //scoreLbl.fontSize = 50
        scoreLbl.fontSize = self.frame.height * 0.0749625187
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0/255.0), green: 0.0/255.0, blue: 0.0/255.0, alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        
        return scoreLbl
    }
    
    // Creates the highscore label
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        //highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        //highscoreLbl.position = CGPoint(x: self.frame.width * 0.78666667, y: self.frame.height * 0.96701649)
        highscoreLbl.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.27511244)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore") {
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        //highscoreLbl.fontSize = 15
        highscoreLbl.fontSize = self.frame.height * 0.0224887556
        highscoreLbl.fontName = "Helvetica-Bold"
        
        return highscoreLbl
    }
    
    // Creates the logo
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        //logoImg.size = CGSize(width: 272, height: 65)
        logoImg.size = CGSize(width: self.frame.width * 0.72533333, height: self.frame.height * 0.09745127)
        //logoImg.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        logoImg.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.64992504)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        // Animates the size of the logo
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    // Creates the tap to play label
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        //taptoplayLbl.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        taptoplayLbl.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.35007496)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        //taptoplayLbl.fontSize = 20
        taptoplayLbl.fontSize = self.frame.height * 0.0299850075
        taptoplayLbl.fontName = "HelveticaNeue"
        
        return taptoplayLbl
    }
    
    //create how to play button
    func createHTPBtn() -> SKNode {
        howToPlayBtn = SKNode()
        howToPlayBtn.name = "htpBtn"
        
        //let bg = SKShapeNode(rectOf: CGSize(width: 200, height: 60))
        let bg = SKShapeNode(rectOf: CGSize(width: self.frame.width * 0.53333333, height: self.frame.height * 0.08995502))
        bg.fillColor = SKColor.white
        bg.strokeColor = SKColor.blue
        bg.lineWidth = 15
        //bg.position = CGPoint(x: self.frame.midX, y: 50)
        bg.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.07496252)
        bg.zPosition = 6
        howToPlayBtn.addChild(bg)
        
        let words = SKLabelNode()
        words.text = "How To Play"
        words.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        words.fontName = "HelveticaNeue"
        //words.fontSize = 20
        words.fontSize = self.frame.height * 0.0299850075
        //words.position = CGPoint(x: self.frame.midX, y: 42)
        words.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.06296852)
        words.zPosition = 7
        howToPlayBtn.addChild(words)
        
        return howToPlayBtn
    }
    
    // Test create how to play label
    func createHTPNode() -> SKNode {
        howToPlay = SKNode()
        howToPlay.name = "howToPlay"
        
        //let background = SKShapeNode(rectOf: CGSize(width: 310, height: 250))
        //let background = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: self.frame.height * 0.37481259))
        let background = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: self.frame.height * 0.44977511))
        background.strokeColor = SKColor.blue
        background.lineWidth = 20
        background.fillColor = SKColor.white
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = 10
        howToPlay.addChild(background)
        
        let line1 = SKLabelNode()
        line1.text = "How To Play"
        line1.fontColor = SKColor.red
        line1.fontName = "HelveticaNeue"
        //line1.fontSize = 20
        line1.fontSize = self.frame.height * 0.0299850075
        //line1.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 90)
        line1.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.63493253)
        line1.zPosition = 11
        howToPlay.addChild(line1)
        
        let line2 = SKLabelNode()
        line2.text = "Hold the screen to move up"
        line2.fontColor = SKColor.red
        line2.fontName = "HelveticaNeue"
        //line2.fontSize = 18
        line2.fontSize = self.frame.height * 0.0269865067
        //line2.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 65)
        line2.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.5974512744)
        line2.zPosition = 11
        howToPlay.addChild(line2)
        
        let line3 = SKLabelNode()
        line3.text = "Let go to move down"
        line3.fontColor = SKColor.red
        line3.fontName = "HelveticaNeue"
        //line3.fontSize = 18
        line3.fontSize = self.frame.height * 0.0269865067
        //line3.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 35)
        line3.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.5524737631)
        line3.zPosition = 11
        howToPlay.addChild(line3)
        
        let line4 = SKLabelNode()
        line4.text = "If you hit the bottom of the screen,"
        line4.fontColor = SKColor.red
        line4.fontName = "HelveticaNeue"
        //line4.fontSize = 18
        line4.fontSize = self.frame.height * 0.0269865067
        //line4.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 5)
        line4.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.5074962519)
        line4.zPosition = 11
        howToPlay.addChild(line4)
        
        let line5 = SKLabelNode()
        line5.text = "a hook, jellyfish, or shark..."
        line5.fontColor = SKColor.red
        line5.fontName = "HelveticaNeue"
        //line5.fontSize = 18
        line5.fontSize = self.frame.height * 0.0269865067
        //line5.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 25)
        line5.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.4625187406)
        line5.zPosition = 11
        howToPlay.addChild(line5)
        
        let gameover = SKLabelNode()
        gameover.text = "GAME OVER!!!"
        gameover.fontColor = SKColor.red
        gameover.fontName = "HelveticaNeue"
        //gameover.fontSize = 30
        gameover.fontSize = self.frame.height * 0.0449775112
        //gameover.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)
        gameover.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.38005997)
        gameover.zPosition = 11
        howToPlay.addChild(gameover)
        
        return howToPlay
    }
    
    // paused label
    func createPaused() -> SKLabelNode {
        pause = SKLabelNode()
        pause.name = "paused"
        pause.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        pause.text = "PAUSED"
        pause.fontColor = UIColor.red
        pause.zPosition = 20
        pause.fontSize = 40
        pause.fontName = "HelveticaNeue"
        
        return pause
    }
    
    // Unpause label
    func createUnpause() -> SKLabelNode {
        unpause = SKLabelNode()
        unpause.name = "unpause"
        unpause.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.35007496)
        unpause.text = "TAP ANYWHERE TO RESUME"
        unpause.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        unpause.zPosition = 20
        //unpause.fontSize = 20
        unpause.fontSize = self.frame.height * 0.0299850075
        unpause.fontName = "HelveticaNeue"
        
        return unpause
    }
    
    // This label will appear after death if a new high score has been earned
    func createNewHighscore() -> SKNode {
        let text = SKLabelNode()
        text.name = "newhigh"
        text.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.64992504)
        text.text = "NEW HIGHSCORE!"
        text.fontColor = UIColor.red
        text.zPosition = 20
        //text.fontSize = 30
        text.fontSize = self.frame.height * 0.04497751
        text.fontName = "HelveticaNeue"
        newhigh.addChild(text)
        
        let bg = SKShapeNode(rectOf: CGSize(width: self.frame.width * 0.9, height: self.frame.height * 0.08995502))
        bg.fillColor = SKColor.white
        bg.position = CGPoint(x: self.frame.midX, y: self.frame.height * 0.66)
        bg.zPosition = 19
        newhigh.addChild(bg)
        
        
        return newhigh
    }
    
    // button for muting the music
    func createMuteMusic() -> SKNode {
        muteMusic = SKNode()
        
        let text = SKLabelNode()
        text.name = "muteMusic"
        text.position = CGPoint(x: self.frame.midX-15, y: self.frame.midY - 205)
        text.text = "Music: "
        text.fontColor = UIColor.black
        text.zPosition = 20
        text.fontSize = 20
        //text.fontsize = self.frame.height * ...
        text.fontName = "HelveticaNeue"
        muteMusic.addChild(text)
        
        
        box = SKSpriteNode(imageNamed: "checked")
        box.name = "box"
        // 50,50
        box.size = CGSize(width: self.frame.width * 0.1066666667, height: self.frame.height * 0.059970015)
        box.position = CGPoint(x: self.frame.midX + 40, y: self.frame.midY - 200)
        muteMusic.addChild(box)
        muteMusic.zPosition = 20
        
        return muteMusic
    }
    
    // Creates the hooks and coins
    func createHooks() -> SKNode {
        // Creates the coin
        //coinNode = SKSpriteNode(imageNamed: "coin")
        coinNode = SKSpriteNode(texture: SKTextureAtlas(named: "hook").textureNamed("coin"))
        //coinNode.size = CGSize(width: 40, height: 40)
        //coinNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        coinNode.size = CGSize(width: self.frame.width * 0.1066666667, height: self.frame.height * 0.059970015)
        coinNode.position = CGPoint(x: self.frame.width + (self.frame.width * 0.0666666667) , y: self.frame.height / 2)
        coinNode.physicsBody = SKPhysicsBody(rectangleOf: coinNode.size)
        coinNode.physicsBody?.affectedByGravity = false
        coinNode.physicsBody?.isDynamic = false
        coinNode.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        coinNode.physicsBody?.collisionBitMask = 0
        coinNode.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        coinNode.color = SKColor.blue
        coinNode.name = "coin"
        coinNode.run(moveAndRemoveHook)
        
        // Contains both hook and coin
        hookCoin = SKNode()
        hookCoin.name = "hookCoin"
        
        // Creates the hook
        //let hook = SKSpriteNode(imageNamed: "hook")
        let hook = SKSpriteNode(texture: SKTextureAtlas(named: "hook").textureNamed("hook"))
        
        //hook.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        hook.position = CGPoint(x: self.frame.width + (self.frame.width * 0.0666666667), y: self.frame.height/2 + (self.frame.height * 0.6296851574))
        hook.size = CGSize(width: self.frame.width * 0.15733333, height: self.frame.height * 1.92353823)
        
        hook.setScale(0.5)
        
        hook.physicsBody = SKPhysicsBody(rectangleOf: hook.size)
        hook.physicsBody?.categoryBitMask = CollisionBitMask.hookCategory
        hook.physicsBody?.collisionBitMask = CollisionBitMask.fishCategory
        hook.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        hook.physicsBody?.isDynamic = false
        hook.physicsBody?.affectedByGravity = false
        hook.run(moveAndRemoveHook)
        
        hook.zRotation = CGFloat(Double.pi)
        
        hookCoin.zPosition = 1
        
        hookCoin.addChild(hook)
        //let randomPosition = CGFloat.random(in: -200 ... 75)
        let randomPosition = CGFloat.random(in: (self.frame.height * -0.29985007) ... (self.frame.height * 0.1124437781))
        hookCoin.position.y = hookCoin.position.y +  randomPosition
        hookCoin.addChild(coinNode)
        //hookCoin.run(moveAndRemoveHook)
        
        return hookCoin
    }
    
    // Cretes the jellyfish
    func createJelly() -> SKNode {
        // Creates the coin
        //coinNode = SKSpriteNode(imageNamed: "coin")
        coinNode = SKSpriteNode(texture: SKTextureAtlas(named: "jelly").textureNamed("coin"))
        //coinNode.size = CGSize(width: 40, height: 40)
        //coinNode.position = CGPoint(x: self.frame.width + 250, y: self.frame.height / 2)
        coinNode.size = CGSize(width: self.frame.width * 0.1066666667, height: self.frame.height * 0.059970015)
        coinNode.position = CGPoint(x: self.frame.width + (self.frame.width * 0.7418397626), y: self.frame.height / 2)
        coinNode.physicsBody = SKPhysicsBody(rectangleOf: coinNode.size)
        coinNode.physicsBody?.affectedByGravity = false
        coinNode.physicsBody?.isDynamic = false
        coinNode.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        coinNode.physicsBody?.collisionBitMask = 0
        coinNode.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        coinNode.color = SKColor.blue
        
        jellyCoin = SKNode()
        jellyCoin.name = "jellyCoin"
        
        //let jelly = SKSpriteNode(imageNamed: "jelly")
        let jelly = SKSpriteNode(texture: SKTextureAtlas(named: "jelly").textureNamed("jelly"))
        
        //jelly.position = CGPoint(x: self.frame.width + 500, y: self.frame.height / 2)
        jelly.position = CGPoint(x: self.frame.width + (self.frame.width * 1.333333333), y: self.frame.height / 2)
        jelly.size = CGSize(width: self.frame.width * 0.4, height: self.frame.height * 0.33433283)
        
        jelly.setScale(0.5)
        
        jelly.physicsBody = SKPhysicsBody(texture: SKTextureAtlas(named: "jelly").textureNamed("coin"), size: jelly.size)
        jelly.physicsBody?.categoryBitMask = CollisionBitMask.jellyCategory
        jelly.physicsBody?.collisionBitMask = CollisionBitMask.fishCategory
        jelly.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        jelly.physicsBody?.isDynamic = false
        jelly.physicsBody?.affectedByGravity = false
        
        jellyCoin.zPosition = 1
        
        jellyCoin.addChild(jelly)
        //let randomPosition = CGFloat.random(in: -100 ... 75)
        let randomPosition = CGFloat.random(in: (self.frame.height * -0.1499250375) ... (self.frame.height * 0.1124437781))
        jellyCoin.position.y = jellyCoin.position.y + randomPosition
        jellyCoin.addChild(coinNode)
        
        jellyCoin.run(moveAndRemoveJelly)
        
        return jellyCoin
    }
    
    // Creates the shark node
    func createShark() -> SKNode {
        // Creates the coin nodes
        let coinNode1 = SKSpriteNode(texture: SKTextureAtlas(named: "jelly").textureNamed("coin"))
        //coinNode1.size = CGSize(width: 40, height: 40)
        //coinNode1.position = CGPoint(x: self.frame.width + 50, y: self.frame.height / 2 + 50)
        coinNode1.size = CGSize(width: self.frame.width * 0.1066666667, height: self.frame.height * 0.059970015)
        coinNode1.position = CGPoint(x: self.frame.width + (self.frame.width * 0.1333333333), y: self.frame.height/2 + (self.frame.height * 0.0749625187))
        coinNode1.physicsBody = SKPhysicsBody(rectangleOf: coinNode1.size)
        coinNode1.physicsBody?.affectedByGravity = false
        coinNode1.physicsBody?.isDynamic = false
        coinNode1.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        coinNode1.physicsBody?.collisionBitMask = 0
        coinNode1.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        coinNode1.color = SKColor.blue
        
        let coinNode2 = SKSpriteNode(texture: SKTextureAtlas(named: "jelly").textureNamed("coin"))
        //coinNode2.size = CGSize(width: 40, height: 40)
        coinNode2.size = CGSize(width: self.frame.width * 0.1066666667, height: self.frame.height * 0.059970015)
        coinNode2.position = CGPoint(x: self.frame.width, y: self.frame.height / 2)
        coinNode2.physicsBody = SKPhysicsBody(rectangleOf: coinNode2.size)
        coinNode2.physicsBody?.affectedByGravity = false
        coinNode2.physicsBody?.isDynamic = false
        coinNode2.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        coinNode2.physicsBody?.collisionBitMask = 0
        coinNode2.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        coinNode2.color = SKColor.blue
        
        let coinNode3 = SKSpriteNode(texture: SKTextureAtlas(named: "jelly").textureNamed("coin"))
        //coinNode3.size = CGSize(width: 40, height: 40)
        //coinNode3.position = CGPoint(x: self.frame.width + 50, y: self.frame.height / 2 - 50)
        coinNode3.size = CGSize(width: self.frame.width * 0.1066666667, height: self.frame.height * 0.059970015)
        coinNode3.position = CGPoint(x: self.frame.width + (self.frame.width * 0.1333333333), y: self.frame.height/2 - (self.frame.height * 0.0749625187))
        coinNode3.physicsBody = SKPhysicsBody(rectangleOf: coinNode3.size)
        coinNode3.physicsBody?.affectedByGravity = false
        coinNode3.physicsBody?.isDynamic = false
        coinNode3.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        coinNode3.physicsBody?.collisionBitMask = 0
        coinNode3.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        coinNode3.color = SKColor.blue
        
        sharkCoin = SKNode()
        sharkCoin.name = "sharkCoin"
        
        //let shark = SKSpriteNode(imageNamed: "shark")
        let shark = SKSpriteNode(texture: SKTextureAtlas(named: "shark").textureNamed("shark"))
        
        //shark.position = CGPoint(x: self.frame.width + 500, y: self.frame.height / 2)
        shark.position = CGPoint(x: self.frame.width + (self.frame.width * 1.333), y: self.frame.height / 2)
        shark.size = CGSize(width: self.frame.width * 0.66666667, height: self.frame.height * 0.22488756)
        
        shark.setScale(1.0)
        
        //shark.physicsBody = SKPhysicsBody(texture: shark.texture!, size: shark.texture!.size())
        shark.physicsBody = SKPhysicsBody(texture: SKTextureAtlas(named: "shark").textureNamed("shark"), size: shark.size)
        shark.physicsBody?.categoryBitMask = CollisionBitMask.sharkCategory
        shark.physicsBody?.collisionBitMask = CollisionBitMask.fishCategory
        shark.physicsBody?.contactTestBitMask = CollisionBitMask.fishCategory
        shark.physicsBody?.isDynamic = false
        shark.physicsBody?.affectedByGravity = false
        
        sharkCoin.zPosition = 1
        
        sharkCoin.addChild(shark)
        //let randomPosition = CGFloat.random(in: -75 ... 75)
        let randomPosition = CGFloat.random(in: (self.frame.height * -0.1124437781) ... (self.frame.height * 0.1124437781))
        sharkCoin.position.y = sharkCoin.position.y + randomPosition
        sharkCoin.addChild(coinNode1)
        sharkCoin.addChild(coinNode2)
        sharkCoin.addChild(coinNode3)
        
        sharkCoin.run(moveAndRemoveShark)
        
        return sharkCoin
    }
    
}
