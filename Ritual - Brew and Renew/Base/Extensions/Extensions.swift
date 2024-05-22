//
//  Extensions.swift
//  Ritual
//
//  Created by Tyler Rhodes on 8/5/23.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Date {
    var displayFormat: String {
        self.formatted(date: .long, time: .omitted)
    }
    
    var timeFormat: String {
        self.formatted(
            .dateTime
                .year(.defaultDigits)
                .month(.wide)
                .day(.twoDigits)
                .hour()
                .minute()
        )
    }
}

extension DateFormatter {
    static let allNumericUSA: DateFormatter = {
        print("Initializing DateFormatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self) else { return Date() }
        
        return parsedDate
    }
}
