//
//  DragGesture+Extensions.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

// MARK: Velocity
extension DragGesture.Value {
    var velocity: CGSize {
        let dx = predictedEndLocation.x - location.x
        let dy = predictedEndLocation.y - location.y
        return CGSize(width: dx, height: dy)
    }
}
