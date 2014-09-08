//
//  ManualOverrideViewController.swift
//  umpireCounter
//
//  Created by Mac Pro on 8/30/14.
//  Copyright (c) 2014 Mac Pro. All rights reserved.
//

import UIKit

class ManualOverrideViewController: UIViewController {
    @IBOutlet weak var homeTeamStepper: UIStepper!
    @IBOutlet weak var homeTeamLabel: UILabel!

    @IBOutlet weak var awayTeamStepper: UIStepper!
    @IBOutlet weak var awayTeamLabel: UILabel!
    
    @IBOutlet weak var inningStepper: UIStepper!
    @IBOutlet weak var inningLabel: UILabel!
    
    @IBOutlet weak var outsStepper: UIStepper!
    @IBOutlet weak var outsLabel: UILabel!
    
    @IBOutlet weak var ballsStepper: UIStepper!
    @IBOutlet weak var ballsLabel: UILabel!
    
    @IBOutlet weak var strikesStepper: UIStepper!
    @IBOutlet weak var strikesLabel: UILabel!
    
    @IBOutlet weak var totalStrikesStepper: UIStepper!
    @IBOutlet weak var totalStrikesLabel: UILabel!
    
    @IBOutlet weak var totalBallsStepper: UIStepper!
    @IBOutlet weak var totalBallsLabel: UILabel!
    
    @IBOutlet weak var upArrowOverride: UIImageView!
    @IBOutlet weak var downArrowOverride: UIImageView!
    
    class Counter {
        var count = 0
        func increment() {
            count++
        }
    }
    class DoubleCounter {
        var count = 0.0
        func increment() {
            count++
        }
    }
    
    var homeTeamCounter = Counter()
    var awayTeamCounter = Counter()
    var ballCounter = Counter()
    var strikeCounter = Counter()
    var outCounter = Counter()
    var inningCounter = Counter() //double
    
    var homePitcherTotalStrikes = Counter()
    var homePitcherTotalBalls = Counter()
    var awayPitcherTotalStrikes = Counter()
    var awayPitcherTotalBalls = Counter()
    
    var isTopOfInning = true
    var viewWillAppearHasBeenCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad has been called")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        
        println("back button was tapped")
    }

    override func viewWillAppear(animated: Bool) {
        //if my variables have the correct values, all that is left is to update the labels and the values the steppers will start counting from to match those of the current game
        println("inside viewWillAppear...")
        
        if viewWillAppearHasBeenCalled == false {
            println("viewWillAppearHasBeenCalled = 0")
            inningLabel.text = String(inningCounter.count)
            if isTopOfInning == true {
                upArrowOverride.hidden = false
                downArrowOverride.hidden = true
            } else {
                upArrowOverride.hidden = true
                downArrowOverride.hidden = false
            }
        } else {
            println("viewWillAppearHasBeenCalled = \(viewWillAppearHasBeenCalled)")
            
            println(inningCounter.count)
            inningLabel.text = String(inningCounter.count)
            if isTopOfInning == true {
                upArrowOverride.hidden = false
                downArrowOverride.hidden = true
            } else {
                upArrowOverride.hidden = true
                downArrowOverride.hidden = false
            }
        }
        viewWillAppearHasBeenCalled = true
        println("the new value of viewWillAppearHasBeenCalled = \(viewWillAppearHasBeenCalled)")
        
        updateStartingStepperValues()
        updateLabels()
        //we only want to set the value to 1 at the initialization of the view, not every time the labels are updated.
    }
    /*
    @IBAction func backToGameTriggered(sender: AnyObject) {
        println("backToGame was triggered")
        self.performSegueWithIdentifier("unwindBackToMainView", sender: self)
    }
    */
    
    
    
    func updateLabels (){
        homeTeamLabel.text = String(homeTeamCounter.count)
        awayTeamLabel.text = String(awayTeamCounter.count)
        outsLabel.text = String(outCounter.count)
        ballsLabel.text = String(ballCounter.count)
        strikesLabel.text = String(strikeCounter.count)
        if isTopOfInning == true {
            totalStrikesLabel.text = String(homePitcherTotalStrikes.count)
            totalBallsLabel.text = String(homePitcherTotalBalls.count)
        } else {
            totalStrikesLabel.text = String(awayPitcherTotalStrikes.count)
            totalBallsLabel.text = String(awayPitcherTotalStrikes.count)
        }
    }
    
    func updateStartingStepperValues (){
        homeTeamStepper.value = Double(homeTeamCounter.count)
        awayTeamStepper.value = Double(awayTeamCounter.count)
        if viewWillAppearHasBeenCalled == false {
            inningStepper.value = Double(inningCounter.count + 1)
        } else {
            inningStepper.value = Double(inningCounter.count)
        }
        
        outsStepper.value = Double(outCounter.count)
        ballsStepper.value = Double(ballCounter.count)
        strikesStepper.value = Double(strikeCounter.count)
        if isTopOfInning == true {
            totalStrikesStepper.value = Double(homePitcherTotalStrikes.count)
            totalBallsStepper.value = Double(homePitcherTotalBalls.count)
        } else {
            totalStrikesStepper.value = Double(awayPitcherTotalStrikes.count)
            totalBallsStepper.value = Double(awayPitcherTotalBalls.count)
        }
    }
    
    
    
    
    @IBAction func homeTeamScoreOveridden(sender: AnyObject) {
        let double = homeTeamStepper.value
        let integer = Int(double)
        homeTeamLabel.text = String(integer)
        homeTeamCounter.count = integer
    }
    
    @IBAction func awayTeamScoreOveridden(sender: AnyObject) {
        let double = awayTeamStepper.value
        let integer = Int(double)
        awayTeamLabel.text = String(integer)
        awayTeamCounter.count = integer
    }
    
    @IBAction func inningsOveridden(sender: AnyObject) {
        if isTopOfInning == true {
            downArrowOverride.hidden = false
            upArrowOverride.hidden = true
            inningCounter.count = Int(inningStepper.value)
            inningLabel.text = String(inningCounter.count)
        } else {
            inningCounter.count = Int(inningStepper.value + 0.5)
            inningLabel.text = String(inningCounter.count)
            upArrowOverride.hidden = false
            downArrowOverride.hidden = true
        }
        isTopOfInning = !isTopOfInning
        println("isTopOfInning is \(isTopOfInning)")
    }
    
    @IBAction func outsOveridden(sender: AnyObject) {
        let double = outsStepper.value
        let integer = Int(double)
        outsLabel.text = String(integer)
        outCounter.count = integer
    }
    
    @IBAction func ballsOveridden(sender: AnyObject) {
        let double = ballsStepper.value
        let integer = Int(double)
        ballsLabel.text = String(integer)
        ballCounter.count = integer
    }
    
    @IBAction func strikesOveridden(sender: AnyObject) {
        let double = strikesStepper.value
        let integer = Int(double)
        strikesLabel.text = String(integer)
        strikeCounter.count = integer
    }
    
    @IBAction func totalStrikesOveridden(sender: AnyObject) {
        let double = totalStrikesStepper.value
        let integer = Int(double)
        totalStrikesLabel.text = String(integer)
        if isTopOfInning == true {
            homePitcherTotalStrikes.count = integer
        } else {
            awayPitcherTotalStrikes.count = integer
        }
    }
    
    @IBAction func totalBallsOveridden(sender: AnyObject) {
        let double = totalBallsStepper.value
        let integer = Int(double)
        totalBallsLabel.text = String(integer)
        if isTopOfInning == true {
            homePitcherTotalBalls.count = integer
        } else {
            awayPitcherTotalBalls.count = integer
        }
    }
    
    
    
}

