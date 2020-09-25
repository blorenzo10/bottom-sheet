//
//  CardState.swift
//  bottom-sheet
//
//  Created by Bruno Lorenzo on 9/13/20.
//  Copyright © 2020 blorenzo. All rights reserved.
//

import Foundation

enum CardState {
    case collapsed
    case expanded
}

extension CardState {
    mutating func toggle() {
        switch self {
        case .collapsed:
            self = .expanded
        case .expanded:
            self = .collapsed
        }
    }
}
