//
//  TimerModel.swift
//  ThreeminWorkout
//
//  Created by 工藤彩名 on 2023/04/18.
//

import Foundation
import Combine

class TimerModel: ObservableObject{
    @Published var seconds: Int = 0
    @Published var minutes: Int = 3
    @Published var timer: AnyCancellable!
    
    func intToStringCount() -> String {
        var intCount = "\(minutes):\(seconds)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        let newCount = dateFormatter.date(from: intCount)!
        let timerCount = dateFormatter.string(from: newCount)
        return timerCount
    }

    func startTimer(_ interval: Double = 1.0){
        print("start timer!")

        if let _timer = timer{
            _timer.cancel()
        }

        timer = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: ({_ in
                if self.minutes >= 4 {
                    self.minutes = 3
                }
                self.seconds -= 1
                
                if self.seconds <= -1 {
                    self.minutes -= 1
                    self.seconds = 59
                }
                if self.minutes == 0 && self.seconds == 0 {
                    self.resetTimer()
                }
            }))
    }
    
    func resetTimer(){
        print("stop timer!")
        timer?.cancel()
        timer = nil
    }
}
