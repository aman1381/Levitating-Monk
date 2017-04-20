

//
//  GameScene.swift
//  Levitating Monk
//
//  Created by Amandeep Singh on 2/4/17.
//  Copyright © 2017 Amandeep Singh. All rights reserved.
//

import SpriteKit
import GameplayKit


var gameScore = 0

struct PhysicsCatagory {
    static let None: UInt32 = 0 << 0
    static let player : UInt32 = 0x1 << 1
    static let ground : UInt32 = 0x10 << 2
    static let power  : UInt32 = 0x100 << 4
    static let bird   : UInt32 = 0x1000 << 8
}




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max -  min) + min
    }
    
    
    //declaring global variable
    
    var player = SKSpriteNode()
    var ground = SKSpriteNode()
    var background = SKSpriteNode()
   
    var gameArea: CGRect
    var powerSound = SKAction.playSoundFileNamed("powerchime.wav", waitForCompletion: false)
    var boomSound = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    var fallingSound = SKAction.playSoundFileNamed("ground.wav", waitForCompletion: false)
    
    let scoreLable = SKLabelNode(fontNamed: "The Bold Font")
    var livesNumber = 5
    let livesLable = SKLabelNode(fontNamed: "The Bold Font")
    var levelNumber = 0
    let tapToStartLable = SKLabelNode(fontNamed: "The Bold Font")
    
    enum gameState{
        case preGame //before start of the game
        case inGame  // during the game
        case afterGame // after game
    }
    var currentGameState = gameState.preGame
    
    
    
    
    override init(size: CGSize){
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        
        
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func didMove(to view: SKView){
         gameScore = 0
        
        
        self.physicsWorld.contactDelegate = self
       
        
        
        //background
        background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
       
        
        
        //player
        player = SKSpriteNode(imageNamed:"player1")
        player.setScale(1)
        player.position = CGPoint(x:self.size.width/2, y: self.size.height*0.2)
        player.zPosition = 4
       
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.height/2)
        player.physicsBody?.categoryBitMask = PhysicsCatagory.player
        player.physicsBody?.collisionBitMask = PhysicsCatagory.ground
        player.physicsBody?.contactTestBitMask = PhysicsCatagory.ground | PhysicsCatagory.power | PhysicsCatagory.bird
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
       
        self.addChild(player)
       
        
        
        //ground
        ground = SKSpriteNode(imageNamed: "ground1")
        ground.setScale(1)
        ground.position = CGPoint(x: self.size.width/2, y:0 + ground.size.height/2)
        ground.zPosition = 7
       
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCatagory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCatagory.player
        ground.physicsBody?.contactTestBitMask = PhysicsCatagory.player
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        
        self.addChild(ground)
        
        scoreLable.text = "Score: 0"
        scoreLable.fontSize = 70
        scoreLable.fontColor = SKColor.gray
        scoreLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLable.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLable.frame.size.height)
        scoreLable.zPosition = 100
        self.addChild(scoreLable)
        
        livesLable.text = "Lives: 5"
        livesLable.fontSize = 70
        livesLable.fontColor = SKColor.gray
        livesLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLable.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesLable.frame.size.height)
        livesLable.zPosition = 100
        self.addChild(livesLable)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        
        scoreLable.run(moveOnToScreenAction)
        livesLable.run(moveOnToScreenAction)
        
        
        
        
        
        tapToStartLable.text = "Tap To Begin"
        tapToStartLable.fontSize = 100
        tapToStartLable.fontColor = SKColor.gray
        tapToStartLable.zPosition = 1
        tapToStartLable.position = CGPoint(x: self.size.width/2,  y: self.size.height/2)
        tapToStartLable.alpha = 0
        self.addChild(tapToStartLable)
        
            let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
            tapToStartLable.run(fadeInAction)
        
        }
    func startGame() {
        
        currentGameState = gameState.inGame
        
    
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLable.run(deleteSequence)
        
        
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([ startLevelAction])
        player.run(startGameSequence)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    func loseALife(){
        
        livesNumber -= 1
        livesLable.text = "Lives: \(livesNumber)"
        
        let scaleUP = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUP, scaleDown])
        livesLable.run(scaleSequence)
        
        if livesNumber == 0{
            runGameOver()
        }
        
    }
    
    
    func addLife(){
        
        livesNumber += 1
        livesLable.text = "Lives: \(livesNumber)"
        
        let scaleUP = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUP, scaleDown])
        livesLable.run(scaleSequence)
        
        
        
    }
    
    
    
    
    
    //add score
    func addScore(){
        
        gameScore += 1
        scoreLable.text = "Score: \(gameScore)"
        
        if gameScore%15 == 0 && livesNumber < 5{
        
            self.addLife()
        }
        
        
        if gameScore == 25 || gameScore == 50 || gameScore == 100{
           
            startNewLevel()
            
        }
        
        
        
    }
    
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
       
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Power"){
        power, stop in
            power.removeAllActions()
        }
       let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
        }
    
    
    
    
    
    // change Secne Game Ove
    
    func changeScene(){
        
        let sceneToMove = GameOverScene(size: self.size)
        sceneToMove.scaleMode = self.scaleMode
        let mytransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMove, transition: mytransition)
    }
    
    
    
    
    
   // contact when two bodies made contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCatagory.player && body2.categoryBitMask == PhysicsCatagory.power{
            // player hits the power
            
            addScore()
          
            if body2.node != nil {
                spawnChime(spawnPosition: body1.node!.position)}
            
            body2.node?.removeFromParent()
           
          
            
            
        }
        
        if body1.categoryBitMask == PhysicsCatagory.power && body2.categoryBitMask == PhysicsCatagory.ground{
            // power hit the ground
           
            body1.node?.removeFromParent()
            
            
            
            
        }
        if body1.categoryBitMask == PhysicsCatagory.player && body2.categoryBitMask == PhysicsCatagory.ground {
            
            //player hit the ground
           
            spawnExplosion1(spawnPosition: body1.node!.position)
             body1.node?.removeFromParent()
            
            runGameOver()
            
        }
        if body1.categoryBitMask == PhysicsCatagory.player && body2.categoryBitMask == PhysicsCatagory.bird{
            //player hit the bird
            
            if body1.node != nil {
    spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            
            if body2.node != nil{
        spawnExplosion(spawnPosition: body2.node!.position)
            }
        
        
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
            
            
        }
    }
    
    
    
    
    
    
    
    
    // power chime
    func spawnChime(spawnPosition: CGPoint){
        let chime = SKSpriteNode(imageNamed: "chime")
        chime.position = spawnPosition
        chime.zPosition = 3
        chime.setScale(0)
        self.addChild(chime)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        
        let delete = SKAction.removeFromParent()
        
        let chimeSequence = SKAction.sequence([powerSound, scaleIn, fadeOut, delete])
        chime.run(chimeSequence)
        
        
    }
    
    func spawnExplosion(spawnPosition:CGPoint){
        let explosion = SKSpriteNode(imageNamed: "boom")
        explosion.position = spawnPosition
        explosion.zPosition = 5
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([boomSound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
    }
    
    // falling
    func spawnExplosion1(spawnPosition:CGPoint){
        let explosion = SKSpriteNode(imageNamed: "boom")
        explosion.position = spawnPosition
        explosion.zPosition = 8
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([fallingSound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
    }

    
    
    
    
    // power come to at random number
    
    func spawnPower (){
        
        let randomXStart = random(min: gameArea.minX , max: gameArea.maxX )
        let randomXEnd = random(min: gameArea.minX , max: gameArea.maxX )
        
        let startPoint = CGPoint(x: randomXStart, y:self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
       let  power = SKSpriteNode(imageNamed: "power1")
        power.name = "Power"
        power.setScale(1)
        power.position = startPoint
        power.zPosition = 1
        power.physicsBody = SKPhysicsBody(rectangleOf:power.size)
        
        power.physicsBody?.affectedByGravity = false
        power.physicsBody?.categoryBitMask = PhysicsCatagory.power
        power.physicsBody?.collisionBitMask = PhysicsCatagory.None
        power.physicsBody?.contactTestBitMask = PhysicsCatagory.player
        self.addChild(power)
        
        let movePower = SKAction.move(to: endPoint, duration:2)
        let deletePower = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let powerSequence = SKAction.sequence([movePower, deletePower, loseALifeAction])
        
        
        if currentGameState == gameState.inGame{
            power.run(powerSequence)}
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        power.zRotation = amountToRotate
        }
   
    //bird
    
    func spawnBird (){
        
        let randomXStart = random(min: gameArea.minX , max: gameArea.maxX )
        let randomXEnd = random(min: gameArea.minX , max: gameArea.maxX )
        
        let startPoint = CGPoint(x: randomXStart, y:self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let  bird = SKSpriteNode(imageNamed: "bird")
        bird.name = "Bird"
        bird.setScale(0.9)
        bird.position = startPoint
        bird.zPosition = 5
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.categoryBitMask = PhysicsCatagory.bird
        bird.physicsBody?.collisionBitMask = PhysicsCatagory.None
        bird.physicsBody?.contactTestBitMask = PhysicsCatagory.player
        self.addChild(bird)
        
        let moveBird = SKAction.move(to: endPoint, duration:1.5)
        let deleteBird = SKAction.removeFromParent()
        let birdSequence = SKAction.sequence([moveBird, deleteBird])
        
        
        if currentGameState == gameState.inGame{
            bird.run(birdSequence)}
        
        
    }

    
    
    
    
    
    
    // different level
    
    func startNewLevel(){
        levelNumber += 1
        if self.action(forKey: "spawningPower") != nil{
            self.removeAction(forKey: "spawningPower")
        }
        
        var levelDuration = TimeInterval()
        switch levelNumber {
        case 1: levelDuration = 1
        case 2: levelDuration = 0.8
        case 3: levelDuration = 0.5
        case 4: levelDuration = 0.2
            
        default:
            levelDuration = 0.2
            print("Cannot find level info")
            
        }
       
        let spawn = SKAction.run(spawnPower)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningPower")
        
        if self.action(forKey: "spawningBird") != nil{
            self.removeAction(forKey: "spawningBird")
        }
        
        var levelDurationB = TimeInterval()
        switch levelNumber {
        case 1: levelDurationB = 1.5
        case 2: levelDurationB = 1.5
        case 3: levelDurationB = 1
        case 4: levelDurationB = 0.8
            
        default: levelDurationB = 0.5
            print("Cannot find level info")
        }
        
        
       //bird
        let spwanb = SKAction.run(spawnBird)
        let waitToSpawnb = SKAction.wait(forDuration: levelDurationB)
        let spawnbSequence = SKAction.sequence([waitToSpawnb, spwanb])
        let spawnbForever = SKAction.repeatForever(spawnbSequence)
        self.run(spawnbForever, withKey: "spawningBird")
        
    }
    
    
    
    
    
    // impulse function
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.preGame {
            startGame()
        }
    
        else if currentGameState == gameState.inGame{
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 800))
        }
       
    }
    
    
    // side to side movement
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            if currentGameState == gameState.inGame{
            player.position.x += amountDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width/2 {
                
                player.position.x = gameArea.maxX - player.size.width/2
            }
            
            if player.position.x < gameArea.minX
            + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
                
            }
            
            
}
}
}
