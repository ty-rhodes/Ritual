//
//  BrewTimerViewModel.swift
//  Ritual
//
//  Created by Tyler Rhodes on 6/16/23.
//

import Foundation

final class BrewTimerViewModel: ObservableObject {
    
    @Published var timeRemaining: TimeInterval = 180 // 3 minutes
    @Published var isTimerRunning = false
    @Published var Time: Timer? = nil
    @Published var navigateToSaveAndWrite = false
    
    func startTimer() {
        Time = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeRemaining += 1
        }
    }
    
    func stopTimer() {
        Time?.invalidate()
        Time = nil
    }
    
    func resetTimer() {
        stopTimer()
        timeRemaining = 180
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes      = Int(time) / 60 % 60
        let seconds      = Int(time) % 60
        let milliseconds = Int(time * 100) % 100
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}
