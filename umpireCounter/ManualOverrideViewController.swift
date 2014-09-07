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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("inside viewDidLoad")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(animated: Bool) {
        //if my variables have the correct values, all that is left is to update the labels and the values the steppers will start counting from to match those of the current game
        println("inside viewWillAppear...")
        
        updateStartingStepperValues()
        updateLabels()
        //we only want to set the value to 1 at the initialization of the view, not every time the labels are updated.
        inningLabel.text = String(1)
        
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
        inningStepper.value = Double(inningCounter.count)
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
    }
    
    @IBAction func inningsOveridden(sender: AnyObject) {
        isTopOfInning = !isTopOfInning
        println("isTopOfInning = \(isTopOfInning)")
        var double = inningStepper.value
        println("inningSteppers value is \(inningStepper.value)")
        println("therefore double's value is \(double)")
        if double % 1.0 == 0 {
            println("remainder is 0")
            inningCounter.count = Int(double)
            inningLabel.text = ("\(inningCounter.count)")
        } else {
            println("remainder is not 0")
            double = double - 0.5
            println("doubles new value is \(double)")
            inningCounter.count = Int(double)
            println("The value to be displayed is \(inningCounter.count)")
            inningLabel.text = ("\(inningCounter.count)")

        }
        //update the arrows
        println("isTopOfInning = \(isTopOfInning)")
        if isTopOfInning == true {
            println("Since isTopOfInning = \(isTopOfInning),")
            upArrowOverride.hidden = false
            downArrowOverride.hidden = true
            println("upArrowOverride.hidden = \(upArrowOverride.hidden) and downArrowOverride.hidden = \(downArrowOverride.hidden)")
        } else {
            println("should hide up arrow and reveal down arrow")
            upArrowOverride.hidden = true
            //println("upArrowOverride.hidden = \(upArrowOverride.hidden)")
            downArrowOverride.hidden = false
            println("upArrowOverride.hidden = \(upArrowOverride.hidden)")
            println("upArrowOverride.hidden = \(upArrowOverride.hidden) and downArrowOverride.hidden = \(downArrowOverride.hidden)")
        }

    }
    
    @IBAction func outsOveridden(sender: AnyObject) {
        let double = outsStepper.value
        let integer = Int(double)
        outsLabel.text = String(integer)
    }
    
    @IBAction func ballsOveridden(sender: AnyObject) {
        let double = ballsStepper.value
        let integer = Int(double)
        ballsLabel.text = String(integer)
    }
    
    @IBAction func strikesOveridden(sender: AnyObject) {
        let double = strikesStepper.value
        let integer = Int(double)
        strikesLabel.text = String(integer)
    }
    
    @IBAction func totalStrikesOveridden(sender: AnyObject) {
        let double = totalStrikesStepper.value
        let integer = Int(double)
        totalStrikesLabel.text = String(integer)
    }
    
    @IBAction func totalBallsOveridden(sender: AnyObject) {
        let double = totalBallsStepper.value
        let integer = Int(double)
        totalBallsLabel.text = String(integer)
    }
    
    
    
}

