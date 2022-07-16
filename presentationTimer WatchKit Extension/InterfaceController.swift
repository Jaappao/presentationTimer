//
//  InterfaceController.swift
//  presenTimer WatchKit Extension
//
//  Created by Jaappao on 2022/07/16.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    var number: Int = 0
    var timer: Timer = Timer()
    
    var startTime: Date = Date()
    
    let oneminute = 60
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        label.setText("Hello World")
    }
    
    @IBAction func start() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let timeDiff = Int(-1 * self.startTime.timeIntervalSinceNow)
            print(timeDiff)
            self.label.setText(self.timeString(number: timeDiff))
            
            if timeDiff ==  10 * self.oneminute {
                WKInterfaceDevice.current().play(.click)
            }
            
            if timeDiff ==  18 * self.oneminute {
                WKInterfaceDevice.current().play(.notification)
            }
            
            if timeDiff ==  20 * self.oneminute {
                WKInterfaceDevice.current().play(.success)
            }
            
            if timeDiff ==  30 * self.oneminute {
                WKInterfaceDevice.current().play(.click)
            }
        }
    }
    
    @IBAction func stop() {
        timer.invalidate()
        label.setText("Stopped")
        
        number = 0
    }
    
    func timeString(number: Int) -> String {
        return "\(number / 60)m\(number % 60)s"
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible

    }

}
