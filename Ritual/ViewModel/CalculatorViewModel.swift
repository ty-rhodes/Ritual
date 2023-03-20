//
//  CalculatorViewModel.swift
//  Ritual
//
//  Created by Tyler Rhodes on 4/13/23.
//

import Foundation

typealias Grams = Double

class CalculatorViewModel: ObservableObject {
    static func calculateGramsOfWaterTimes(waterRatio: Grams, coffee: Grams) -> Grams {
      return waterRatio * coffee
    }
}
