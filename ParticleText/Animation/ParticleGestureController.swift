//
//  ParticleGestureController.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

@MainActor
final class ParticleGestureController {
    private let engine: ParticleEngine
    
    init(engine: ParticleEngine) {
        self.engine = engine
    }
    
    func makeGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                self.engine.handleDrag(at: value.location, velocity: value.velocity)
            }
            .onEnded { _ in
                self.engine.resetDrag()
            }
    }
}
