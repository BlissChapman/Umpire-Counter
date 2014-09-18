//
//  ViewController.swift
//  umpireCounter
//
//  Created by Mac Pro on 8/24/14.
//  Copyright (c) 2014 Mac Pro. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI


class ViewController: UIViewController {
    
    @IBOutlet weak var outsButtonLabel: UIButton!
    @IBOutlet weak var ballsButtonLabel: UIButton!
    @IBOutlet weak var strikesButtonLabel: UIButton!
    @IBOutlet weak var awayScoreboard: UIButton!
    @IBOutlet weak var homeScoreboard: UIButton!
    @IBOutlet weak var inningsLabel: UIButton!
    @IBOutlet weak var upArrow: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var totalStrikes: UILabel!
    @IBOutlet weak var totalBalls: UILabel!
    @IBOutlet weak var resetPitchCountButton: UIButton!
    @IBOutlet weak var clockButton: UIButton!
    
    
    class Counter {
        var count = 0
        func increment() {
            count++
        }
        func decrement() {
            count--
        }
        func incrementBy(amount: Int) {
            count += amount
        }
        func reset() {
            count = 0
        }
    }
    

    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var offset = NSTimeInterval()
    var isPaused: Bool = false
    var stoppedTime = NSTimeInterval()
    var clockString: String = ""
    var buttonTitle = "START CLOCK"
    
    
    var ballCounter = Counter()
    var strikeCounter = Counter()
    var outCounter = Counter()
    var homeTeamCounter = Counter()
    var awayTeamCounter = Counter()
    var inningLabelCounter = Counter()
    
    var oldValueOfBalls = 0
    var oldValueOfStrikes = 0
    var oldValueOfTotalBalls = 0
    var oldValueOfTotalStrikes = 0
    
    var homePitcherTotalBalls = Counter()
    var homePitcherTotalStrikes = Counter()
    
    var awayPitcherTotalBalls = Counter()
    var awayPitcherTotalStrikes = Counter()
    
    var isTop = true
    var viewWillAppearHasBeenCalled = false
    
    //var pitchCounterIsOn = true
    //var vibrateIsOn = false
    var myMail: MFMailComposeViewController!
    
    var myUndoManager = NSUndoManager()
    
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //be sure settings can control pitch count on/off, vibrate on/off
        println("in viewDidLoad")
        /*
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
        var pitchCounterIsOn = userDefaults.boolForKey("pitchCounterIsOn")
        //documentation for boolForKey says, "If a boolean value is associated with defaultName in the user defaults, that value is returned. Otherwise, NO is returned."
       // http://stackoverflow.com/questions/24710855/swift-problems-nsuserdefault-and-settings-bundle-not-responding
        //pitchCounterIsOn.boolValue = true
    
        if pitchCounterIsOn as Bool == true {
            println("pitchCounterIsOn is true")
            totalBalls.hidden = false
            totalStrikes.hidden = false
            resetPitchCountButton.hidden = false
            resetPitchCountButton.userInteractionEnabled = true
        } else if pitchCounterIsOn as Bool == false {
            println("pitchCounterIsOn is false")
            totalBalls.hidden = true
            totalStrikes.hidden = true
            resetPitchCountButton.hidden = true
            resetPitchCountButton.userInteractionEnabled = false
        }*/
    }

    
    @IBAction func undoButtonTapped(sender: AnyObject) {
        //.registerUndoWithTarget
        myUndoManager.undo()
    }
    
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = (currentTime - startTime) - offset
        
        println("Current Time: \(currentTime) Elapsed Time: \(currentTime  - startTime) Offset: \(offset)")
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let hours = minutes / 60
        
        let seconds  = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //let hoursString = hours > 9 ? String(hours):"0" + String(hours)
        let minutesString = minutes > 9 ? String(minutes):"0" + String(minutes)
        let secondsString = seconds > 9 ? String(seconds):"0" + String(seconds)
        
        if isPaused == false {
        clockButton.reversesTitleShadowWhenHighlighted = false
        clockString = minutesString + ":" + secondsString
        clockButton.setTitle(buttonTitle + " " + clockString, forState: UIControlState.Normal)
        }
    }
    
    @IBAction func clockTapped(sender: UIButton) {
        //clockButton.userInteractionEnabled = true
        
        println(clockButton.titleLabel)
        println(clockString)
        if sender.titleLabel == "START CLOCK" {
            isPaused = false
            buttonTitle = "PAUSE"
            startClock()
            return
        }
        
        if clockButton.titleLabel == "PAUSE " + clockString {
            isPaused = true
            clockButton.setTitle("CONTINUE " + clockString, forState: UIControlState.Normal)
            stoppedTime = NSDate.timeIntervalSinceReferenceDate()
            return
        }
        
        if clockButton.titleLabel == "CONTINUE " + clockString {
            isPaused = false
            buttonTitle = "PAUSE"
            offset = offset + NSDate.timeIntervalSinceReferenceDate() - stoppedTime
            return
        }
        
    }
    
    func stopClock () {
        timer.invalidate()
    }
    
    func startClock () {
        let aSelector: Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        println("Start time: \(startTime)")
    }
    
    func vibrate (){
        //if certain switch in settings evaluates to true {
       // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
    }
    
    func undoSteeeerike (){
        if strikeCounter.count == 1 {
            strikeCounter.decrement()
        } else if strikeCounter.count == 2 {
            strikeCounter.decrement()
        } else if strikeCounter.count == 0 {
            ballCounter.count = oldValueOfBalls
            strikeCounter.count = 2
            if outCounter.count == 1 {
                outCounter.decrement()
                outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
            } else if outCounter.count == 2 {
                outCounter.decrement()
                outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
            } else if outCounter.count == 0 {
                outCounter.count == 3
                outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
                minusInning()
            }
        }
            if isTop == true {
                homePitcherTotalStrikes.decrement()
            } else {
                awayPitcherTotalStrikes.decrement()
            }
            reloadBallsAndStrikes()
        //hi bliss
    }

    
    @IBAction func steeeerike(sender: AnyObject) {
        myUndoManager.registerUndoWithTarget(self, selector: "undoSteeeerike", object: nil)
        vibrate()
        if strikeCounter.count < 2 {
            var oldValueOfStrikes = strikeCounter.count
            strikeCounter.increment()
            if isTop == true {
                homePitcherTotalStrikes.increment()
            } else {
                awayPitcherTotalStrikes.increment()
            }
            reloadBallsAndStrikes()
        } else {
            oldValueOfBalls = ballCounter.count
            outCounter.increment()
            if isTop == true {
                homePitcherTotalStrikes.increment()
            } else {
                awayPitcherTotalStrikes.increment()
            }
            resetCount()
            reloadBallsAndStrikes()
            if outCounter.count == 1 {
                updateOuts()
            } else if outCounter.count == 2 {
                updateOuts()
            } else if outCounter.count == 3 {
                updateOuts()
                updateInnings()
                outCounter.reset()
                outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)

            }
        }
    }
    
    func undoBallWasTapped() {
        if ballCounter.count == 1  {
            ballCounter.decrement()
            if isTop == true {
                homePitcherTotalBalls.decrement()
            } else {
                awayPitcherTotalBalls.decrement()
            }
            reloadBallsAndStrikes()
            return
        } else if ballCounter.count == 2 {
            ballCounter.decrement()
            if isTop == true {
                homePitcherTotalBalls.decrement()
            } else {
                awayPitcherTotalBalls.decrement()
            }
            reloadBallsAndStrikes()
            return
        } else if ballCounter.count == 3 {
            ballCounter.decrement()
            if isTop == true {
                homePitcherTotalBalls.decrement()
            } else {
                awayPitcherTotalBalls.decrement()
            }
            reloadBallsAndStrikes()
            return
        }
        if ballCounter.count == 0 {
            strikeCounter.count = oldValueOfStrikes
            ballCounter.count = 3
            if isTop == true {
                homePitcherTotalBalls.decrement()
            } else {
                awayPitcherTotalBalls.decrement()
            }
            reloadBallsAndStrikes()
            return
        }
    }
    
    @IBAction func ballWasTapped(sender: AnyObject) {
        myUndoManager.registerUndoWithTarget(self, selector: "undoBallWasTapped", object: nil)
        vibrate()
        if ballCounter.count < 3 {
            ballCounter.increment()
            if isTop == true {
                homePitcherTotalBalls.increment()
            } else {
                awayPitcherTotalBalls.increment()
            }
            reloadBallsAndStrikes()
        } else {
            oldValueOfStrikes = strikeCounter.count
            if isTop == true {
                homePitcherTotalBalls.increment()
            } else {
                awayPitcherTotalBalls.increment()
            }
            resetCount()
            reloadBallsAndStrikes()
            
        }
    }
    
    func undoAddOut() {
        /*
        if outCounter.count == 1 || 2 {
            outCounter.decrement()
            outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
        } else if outCounter.count == 0 {
            minusInning()
            outCounter.count = 3
            outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
            //undo reset Count
            //undo total pitch count stuff

        }*/
    }
    
    @IBAction func addOut(sender: AnyObject) {
        myUndoManager.registerUndoWithTarget(self, selector: "undoAddOut", object: nil)
        vibrate()
        if isTop == true {
            homePitcherTotalStrikes.increment()
        } else {
            awayPitcherTotalStrikes.increment()
        }
        reloadTotalBallsAndStrikes()
        if outCounter.count == 0 {
            outCounter.increment()
            resetCount()
            outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
        } else if outCounter.count == 1 {
            outCounter.increment()
            resetCount()
            outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
        } else if outCounter.count == 2 {
            outCounter.count = 0
            resetCount()
            outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
            updateInnings()
        }
    }
    
    
    func awayTeamScoreMinus() {
        awayTeamCounter.decrement()
        awayScoreboard.setTitle(String(format: "\(awayTeamCounter.count)"), forState: nil)
    }
   
    @IBAction func awayTeamScoreAdd(sender: AnyObject) {
        myUndoManager.registerUndoWithTarget(self, selector: "awayTeamScoreMinus", object: nil)
        if awayTeamCounter.count < 99 {
            vibrate()
            awayTeamCounter.increment()
            awayScoreboard.setTitle(String(format: "\(awayTeamCounter.count)"), forState: nil)
        } else {
            awayTeamCounter.count = 1
            awayScoreboard.setTitle(String(format: "\(awayTeamCounter.count)"), forState: nil)
        }
    }
    
    func homeTeamScoreMinus () {
        homeTeamCounter.decrement()
        homeScoreboard.setTitle(String(format: "\(homeTeamCounter.count)"), forState: nil)
    }
    
    @IBAction func homeTeamScoreAdd(sender: AnyObject) {
        myUndoManager.registerUndoWithTarget(self, selector: "homeTeamScoreMinus", object: nil)
        if homeTeamCounter.count < 99 {
            vibrate()
            homeTeamCounter.increment()
            homeScoreboard.setTitle(String(format: "\(homeTeamCounter.count)"), forState: nil)
        } else {
            homeTeamCounter.count = 1
            homeScoreboard.setTitle(String(format: "\(homeTeamCounter.count)"), forState: nil)
        }
    }
    
   
    
    @IBAction func resetPitchCount(sender: AnyObject) {
        /*println("the value of homePitcherTotalBalls.count is \(homePitcherTotalBalls.count)")
        println("the value of homePitcherTotalStrikes.count is \(homePitcherTotalStrikes.count)")*/
        
        /*println("the value of oldValueOfTotalBalls is \(oldValueOfTotalBalls)")
        println("the value of oldValueOfTotalStrikes is \(oldValueOfTotalStrikes)")*/
        
        myUndoManager.registerUndoWithTarget(self, selector: "resetPitchCountUndo", object: nil)
        
        if isTop == true {
            oldValueOfTotalBalls = homePitcherTotalBalls.count
            oldValueOfTotalStrikes = homePitcherTotalStrikes.count
            homePitcherTotalBalls.reset()
            homePitcherTotalStrikes.reset()
           } else {
            var oldValueOfTotalBalls = awayPitcherTotalBalls.count
            var oldValueOfTotalStrikes = awayPitcherTotalStrikes.count
            awayPitcherTotalBalls.reset()
            awayPitcherTotalStrikes.reset()
        }
        reloadTotalBallsAndStrikes()
    }
    
    
    func resetPitchCountUndo () {
        println("undoResetPitchCount has been called")
        println("My 'old value' for total strikes is now \(oldValueOfTotalStrikes)")
        
        if isTop == true {
            homePitcherTotalBalls.count = oldValueOfTotalBalls
            homePitcherTotalStrikes.count = oldValueOfTotalStrikes
        } else {
            awayPitcherTotalBalls.count = oldValueOfTotalBalls
            awayPitcherTotalStrikes.count = oldValueOfTotalStrikes
        }
        reloadTotalBallsAndStrikes()
    }
    
    @IBAction func inningClicked(sender: AnyObject) {
        if inningLabelCounter.count < 99 {
            vibrate()
            updateInnings()
            resetCount()
        }
    }
    
    
    func reloadBallsAndStrikes (){
        ballsButtonLabel.setTitle(String(format: "\(ballCounter.count)"), forState: nil)
        strikesButtonLabel.setTitle(String(format: "\(strikeCounter.count)"), forState: nil)
        reloadTotalBallsAndStrikes()
    }
    
    func reloadTotalBallsAndStrikes (){
        if isTop == true {
            totalBalls.text = "Balls: \(homePitcherTotalBalls.count)"
            totalStrikes.text = "Strikes: \(homePitcherTotalStrikes.count)"
        } else {
            totalBalls.text = "Balls: \(awayPitcherTotalBalls.count)"
            totalStrikes.text = "Strikes: \(awayPitcherTotalStrikes.count)"
        }
    }
    
    func resetCount () {
        ballCounter.reset()
        strikeCounter.reset()
        reloadBallsAndStrikes()
    }
    
    func updateOuts (){
        outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
    }
    
    func gameOver (){
            //http://www.appcoda.com/uialertcontroller-swift-closures-enum/
            
            var gameOverPopup = UIAlertController(title: "Game Over", message: "", preferredStyle: .Alert)
            
            let shareButtonHandler = { (action:UIAlertAction!) -> Void in
                
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            let shareResultButton = UIAlertAction(title: "Share Result", style: UIAlertActionStyle.Default, handler: nil)
            
            gameOverPopup.addAction(cancelButton)
            gameOverPopup.addAction(shareResultButton)
            
            self.presentViewController(gameOverPopup, animated: true, completion: nil)

    }
    
    func minusInning () {
        strikeCounter.count = oldValueOfStrikes
        ballCounter.count = oldValueOfBalls
        reloadBallsAndStrikes()
        if isTop == false {
            isTop = !isTop
            downArrow.hidden = true
            upArrow.hidden = false
        } else {
            if inningLabelCounter.count > 0 {
                inningLabelCounter.decrement()
                isTop = !isTop
                downArrow.hidden = false
                upArrow.hidden = true
            }
            inningsLabel.setTitle(String(format: "\(inningLabelCounter.count + 1)"), forState: nil)
        }
    }
    
    func updateInnings (){
        myUndoManager.registerUndoWithTarget(self, selector: "minusInning", object: nil)
        if inningLabelCounter.count == 0 {
            inningLabelCounter.increment()
            inningsLabel.setTitle(String(format: "\(inningLabelCounter.count)"), forState: nil)
            println(inningLabelCounter.count)
        }
        inningsLabel.setTitle(String(format: "\(inningLabelCounter.count)"), forState: nil)
        oldValueOfStrikes = strikeCounter.count
        oldValueOfBalls = ballCounter.count
        if inningLabelCounter.count >= 8 && homeTeamCounter.count != awayTeamCounter.count {
            if isTop == false {
                println("Game Over")
                gameOver()
            }
        }
        
        if isTop == true {
            outCounter.reset()
            resetCount()
            outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
            downArrow.hidden = false
            upArrow.hidden = true
        } else {
            inningLabelCounter.increment()
            inningsLabel.setTitle(String(format: "\(inningLabelCounter.count)"), forState: nil)
            outCounter.reset()
            resetCount()
            outsButtonLabel.setTitle(String(format: "\(outCounter.count) Out"), forState: nil)
            downArrow.hidden = true
            upArrow.hidden = false
        }
        isTop = !isTop
        reloadTotalBallsAndStrikes()
    }
    
    func undoFoulBall () {
        if isTop == true {
            homePitcherTotalStrikes.decrement()
        } else {
            awayPitcherTotalStrikes.decrement()
        }
        if strikeCounter.count <= 1 {
            strikeCounter.decrement()
        }
        reloadBallsAndStrikes()
    }
    
    @IBAction func foulBall(sender: AnyObject) {
        myUndoManager.registerUndoWithTarget(self, selector: "undoFoulBall", object: nil)
        if isTop == true {
            homePitcherTotalStrikes.increment()
        } else {
            awayPitcherTotalStrikes.increment()
        }
        reloadTotalBallsAndStrikes()
        if strikeCounter.count <= 1 {
            strikeCounter.increment()
            reloadBallsAndStrikes()
        }
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
            println ("share tapped")
            println("Mail Compose Result Sent . value = \(MFMailComposeResultSent.value)")
        
            if(MFMailComposeViewController.canSendMail()) {
                myMail = MFMailComposeViewController()
                myMail.setSubject("Score Update")
                
                //experimental
                var recipients = ["bliss.chapman@gmail.com"]
                myMail.setToRecipients(recipients)
                
                var messageBody = "testing"
                myMail.setMessageBody(messageBody, isHTML: false)
                
                if isTop == true {
                    println("should now compose message body")
                    
                    
                    //"Home: \(homeTeamCounter.count).  Away: \(awayTeamCounter.count).  Top of the \(inningLabelCounter.count), \(outCounter.count) out, \(ballCounter.count)-\(strikeCounter.count) count on the batter.  Sent from StrikeOut for iPhone."
                    myMail.setMessageBody(messageBody, isHTML: true)
                } else if isTop == false {
                    //println("should now compose message body")
                    //var messageBody = "testing"
                    //"Home: \(homeTeamCounter.count).  Away: \(awayTeamCounter.count).  Bottom of the \(inningLabelCounter.count), \(outCounter.count) out, \(ballCounter.count)-\(strikeCounter.count) count on the batter.  Sent from StrikeOut for iPhone."
                    myMail.setMessageBody(messageBody, isHTML: true)
                }

               
                
                self.presentViewController(myMail, animated: true, completion: nil)
                
                func mailComposeController(controller: MFMailComposeViewController!,
                    didFinishWithResult result: MFMailComposeResult,
                    error: NSError!){
                        println("In mailComposeController")
                        
                        switch(result.value){
                        case MFMailComposeResultSent.value:
                            println("Email sent")
                            
                        case MFMailComposeResultCancelled.value:
                            println("mail canceled")
                            
                        case  MFMailComposeResultSaved.value:
                            println("result saved")
                            
                        case MFMailComposeResultFailed.value:
                            println("result failed")
                            
                        default:
                            println("Whoops")
                        }
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                }
            }
    }
    
    //clicking the cancel button prints out, umpireCounter[1041:42292] _serviceViewControllerReady:error: Error Domain=_UIViewServiceErrorDomain Code=1 "The operation couldn’t be completed. (_UIViewServiceErrorDomain error 1.)" UserInfo=0x7fbace9866c0 {Canceled=service continuation}
    
    
    
    @IBAction func unwindBackToMainView(segue: UIStoryboardSegue) {
        myUndoManager.removeAllActions()
        println("unwinding from segue")
        if segue.sourceViewController.isKindOfClass(ManualOverrideViewController) {
            let previousController = segue.sourceViewController as ManualOverrideViewController
            
            homeTeamCounter.count = previousController.homeTeamCounter.count
            homeScoreboard.setTitle(String(format: "\(homeTeamCounter.count)"), forState: nil)
            awayTeamCounter.count = previousController.awayTeamCounter.count
            println(awayTeamCounter.count)
            awayScoreboard.setTitle(String(format: "\(awayTeamCounter.count)"), forState: nil)
            
            ballCounter.count = previousController.ballCounter.count
            strikeCounter.count = previousController.strikeCounter.count
            homePitcherTotalStrikes.count = previousController.homePitcherTotalStrikes.count
            homePitcherTotalBalls.count = previousController.homePitcherTotalBalls.count
            awayPitcherTotalStrikes.count = previousController.awayPitcherTotalStrikes.count
            awayPitcherTotalBalls.count = previousController.awayPitcherTotalBalls.count
            reloadBallsAndStrikes()
            
            outCounter.count = previousController.outCounter.count
            updateOuts()
            inningLabelCounter.count = previousController.inningCounter.count
            //println("inningLabelCounter has a value of \(inningLabelCounter.count)")
            if inningLabelCounter.count == 0 {
                inningLabelCounter.increment()
                //println("inningLabelCounter now has a value of \(inningLabelCounter.count)")

            }
            //this value is not being updated properly. Fix this and all problems should work.  Arrows should display bottom and top of innings properly.
            isTop = previousController.isTopOfInning
            println("isTop = \(isTop)")
            if isTop == true {
                inningsLabel.setTitle(String(format: "\(inningLabelCounter.count)"), forState: nil)
                upArrow.hidden = false
                downArrow.hidden = true
            } else {
                inningsLabel.setTitle(String(format: "\(inningLabelCounter.count)"), forState: nil)
                downArrow.hidden = false
                upArrow.hidden = true
            }
            
            viewWillAppearHasBeenCalled = previousController.viewWillAppearHasBeenCalled
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println("prepareforSegue was initialized")
        
        let thisManualOverrideViewController = segue.destinationViewController as ManualOverrideViewController
        
        thisManualOverrideViewController.homeTeamCounter.count = homeTeamCounter.count
        thisManualOverrideViewController.awayTeamCounter.count = awayTeamCounter.count
        thisManualOverrideViewController.ballCounter.count = ballCounter.count
        thisManualOverrideViewController.strikeCounter.count = strikeCounter.count
        thisManualOverrideViewController.outCounter.count = outCounter.count
        thisManualOverrideViewController.inningCounter.count = inningLabelCounter.count
        //if isTop == true {
            thisManualOverrideViewController.homePitcherTotalBalls.count = homePitcherTotalStrikes.count
            thisManualOverrideViewController.homePitcherTotalStrikes.count = homePitcherTotalStrikes.count
        //} else {
            thisManualOverrideViewController.awayPitcherTotalBalls.count = awayPitcherTotalBalls.count
            thisManualOverrideViewController.awayPitcherTotalStrikes.count = awayPitcherTotalStrikes.count
        //}
        
        thisManualOverrideViewController.isTopOfInning = isTop
        thisManualOverrideViewController.viewWillAppearHasBeenCalled = viewWillAppearHasBeenCalled
    }

    override func viewDidDisappear(animated: Bool) {
        println("Start time: \(startTime)")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

