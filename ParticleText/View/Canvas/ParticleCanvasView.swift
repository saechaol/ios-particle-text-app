//
//  ParticleCanvasView.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

struct ParticleCanvasView: View {
    let text: String
    let interactionState: InteractionState
    
    @Binding var engine: ParticleEngine
    
    @State private var size: CGSize = .zero
    @State private var isActive = true
    
    private var gestureController: ParticleGestureController {
        ParticleGestureController(engine: engine)
    }
    
    var body: some View {
        ZStack {
            TimelineView(.animation) { _ in
                ParticleTextAnimationView(engine: engine,
                                          interactionState: interactionState)
            }
            ParticleCanvasOverlay(dragPosition: engine.dragPosition)
        }
        .gesture(gestureController.makeGesture())
        .background(
            LinearGradient.appPrimary
        )
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        size = geo.size
                        engine.generateParticles(for: text, in: size)
                    }
            }
        )
        .onChange(of: text) {
            engine.generateParticles(for: text, in: size)
        }
        .task {
            var lastUpdate = Date.now
            while isActive {
                let now = Date.now
                let delta = now.timeIntervalSince(lastUpdate)
                if delta >= 1.0 / 60.0 {
                    await MainActor.run {
                        engine.updateParticles()
                    }
                    lastUpdate = now
                }
                try? await Task.sleep(nanoseconds: 1_000_000)
            }
        }
        .onDisappear {
            isActive = false
        }
    }
}

#Preview("light mode") {
    @Previewable @State var particleEngine = ParticleEngine()
    let text: String = "Hello world"
    ParticleCanvasView(text: text, interactionState: .idle, engine: $particleEngine)
        .preferredColorScheme(.light)
}

#Preview("dark mode") {
    @Previewable @State var particleEngine = ParticleEngine()
    let text: String = "Hello world"
    ParticleCanvasView(text: text, interactionState: .idle, engine: $particleEngine)
        .preferredColorScheme(.dark)
}
