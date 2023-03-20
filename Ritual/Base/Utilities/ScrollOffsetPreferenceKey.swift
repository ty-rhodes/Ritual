//
//  ScrollOffsetPreferenceKey.swift
//  Ritual
//
//  Created by Tyler Rhodes on 7/26/23.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
