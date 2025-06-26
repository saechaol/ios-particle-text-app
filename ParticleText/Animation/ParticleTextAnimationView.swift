//
//  ParticleTextAnimationView.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

struct ParticleTextAnimationView: View {
    let engine: ParticleEngine
    let interactionState: InteractionState
    
    @State private var isBlinking = true
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let opacity = 0.5 + 0.5 * sin(time * 2 * .pi / 1.2)
            Canvas { context, canvasSize in
                for particle in engine.particles {
                    let path = Path(ellipseIn: CGRect(x: particle.x,
                                                      y: particle.y,
                                                      width: 2,
                                                      height: 2))
                    context.fill(path, with: .color(Color.white.opacity(0.7)))
                    
                }
                
                switch interactionState {
                case .idle:
                    if isBlinking {
                        let circle = Path(ellipseIn: CGRect(x: canvasSize.width / 2 - 10,
                                                            y: canvasSize.height / 2 - 10,
                                                            width: 20,
                                                            height: 20))
                        context.fill(circle, with: .color(Color.white.opacity(opacity)))
                    }
                case .typing:
                    if let cursor = engine.cursorPosition, isBlinking {
                        let cursorRect = CGRect(x: cursor.x + 5, y: cursor.y, width: 2, height: 40)
                        // context.fill(Path(cursorRect), with: .color(Color.white.opacity(opacity)))
                    }
                case .submitted:
                    break
                }
            }
        }
    }
}

#Preview("blinking idle") {
    ZStack {
        LinearGradient.appPrimary.ignoresSafeArea()
        ParticleTextAnimationView(engine: ParticleEngine(), interactionState: .idle)
    }
    .preferredColorScheme(.dark)
}

#Preview("blinking typing") {
    ZStack {
        LinearGradient.appPrimary.ignoresSafeArea()
        ParticleTextAnimationView(engine: ParticleEngine(), interactionState: .typing)
    }
    .preferredColorScheme(.dark)
}
