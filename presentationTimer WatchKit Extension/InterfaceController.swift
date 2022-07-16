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
    @IBOutlet var label4: WKInterfaceLabel!
    @IBOutlet weak var talkPicker: WKInterfacePicker!
    @IBOutlet weak var questionPicker: WKInterfacePicker!
    @IBOutlet weak var image: WKInterfaceImage!
    
    var number: Int = 0
    var timer: Timer = Timer()
    
    var startTime: Date = Date()
    
    var talkMinute = 20
    var questionMinute = 10
    
    var items: [TimePickerItem] = []
    let maxMinutes = 30
    
    let oneminute = 60
    
    var notificationDone = [false, false, false, false]
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
//        label.setText("Hello World")
        
        for i in 1...maxMinutes {
            items.append(TimePickerItem(time: i))
        }
        talkPicker.setItems(items)
        questionPicker.setItems(items)
        talkPicker.setSelectedItemIndex(19)
        questionPicker.setSelectedItemIndex(9)
    }
    
    @IBAction func start() {
        if timer.isValid {
            print("now running")
            return
        }
        startTime = Date()
        
        talkPicker.setEnabled(false)
        questionPicker.setEnabled(false)
        label.setText("0m 0s")
        
        print([talkMinute, questionMinute])
        print([Int(self.talkMinute/2), self.talkMinute-1, self.talkMinute, (self.talkMinute + self.questionMinute)])
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let timeDiff = Int(-1 * self.startTime.timeIntervalSinceNow)
            print(timeDiff)
            self.label.setText(self.timeString(number: timeDiff))
            
            if self.notificationDone[0] == false && timeDiff >=  Int(self.talkMinute/2) * self.oneminute {
                WKInterfaceDevice.current().play(.click)
                self.notificationDone[0] = true
            }
            
            if self.notificationDone[1] == false && timeDiff ==  self.talkMinute-1 * self.oneminute {
                WKInterfaceDevice.current().play(.notification)
                self.notificationDone[1] = true
            }
            
            if self.notificationDone[2] == false && timeDiff ==  self.talkMinute * self.oneminute {
                WKInterfaceDevice.current().play(.success)
                self.notificationDone[2] = true
            }
            
            if self.notificationDone[3] == false && timeDiff ==  (self.talkMinute + self.questionMinute) * self.oneminute {
                WKInterfaceDevice.current().play(.click)
                self.notificationDone[3] = true
            }
        }
        image.setImage(UIImage(systemName: "play.fill"))
        image.setTintColor(UIColor(red: 0.0, green: 1.0, blue: 0, alpha: 1.0))
    }
    
    @IBAction func talkPickerAction(_ index: Int) {
        guard let n_minute = items[index].time else {
            return
        }
        self.talkMinute = n_minute
        label2Changed()
    }
    
    @IBAction func questionPickerAction(_ index: Int) {
        guard let n_minute = items[index].time else {
            return
        }
        self.questionMinute = n_minute
        label2Changed()
    }
    
    func label2Changed() {
        label4.setText("\(Int(self.talkMinute/2)) - \(self.talkMinute-1) - \(self.talkMinute) - \(self.talkMinute + self.questionMinute)")
    }
    
    @IBAction func stop() {
        timer.invalidate()
        
        number = 0
        
        image.setImage(UIImage(systemName: "stop.fill"))
        image.setTintColor(UIColor(red: 1.0, green: 0.0, blue: 0, alpha: 1.0))
        
        talkPicker.setEnabled(true)
        questionPicker.setEnabled(true)
        
    }
    
    func timeString(number: Int) -> String {
        return "\(number / 60)m \(number % 60)s"
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible

    }

}

class TimePickerItem: WKPickerItem {
    var time: Int?
    
    init(time: Int) {
        super.init()
        self.time = time
        self.title = String(time)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
