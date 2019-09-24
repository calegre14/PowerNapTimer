//
//  TimerController.swift
//  PowerNapTimer
//
//  Created by Christopher Alegre on 9/24/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation

//MARK: Protocols
protocol TimerDelegate: class {
    
    func timerSecondTick()
    func timerComplete()
    func timerStopped()
}

//MARK: Class
class TimerController {
    //Source of truth
    var timer: Timer?
    var timeRemaining: TimeInterval?
    // Give access to methods on protocol
    weak var delegate: TimerDelegate?
    //Handle if timer is on/off
    var isOn: Bool {
        return timeRemaining != nil ? true : false
    }
    
    func secondTick() {
        guard let timeRemaining = timeRemaining else {return}
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            delegate?.timerSecondTick()
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            delegate?.timerComplete()
        }
    }
    
    func startTimerWithTime(_ time: TimeInterval) {
        if isOn == false {
            timeRemaining = time
            DispatchQueue.main.async {
                //Unsure if we need this, the time should tick, it may be off by one second with this commented out, Test
 //               self.secondTick()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.secondTick()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn == true {
            timeRemaining = nil
            timer?.invalidate()
            delegate?.timerStopped()
        }
    }
    
}//End of TimerController class
