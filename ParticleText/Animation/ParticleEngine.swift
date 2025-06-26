//
//  ParticleEngine.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

@Observable
@MainActor
final class ParticleEngine {
    
    var particles: [Particle] = []
    var dragPosition: CGPoint?
    var dragVelocity: CGSize?
    var cursorPosition: CGPoint? = nil
    
    func generateParticles(for text: String, in size: CGSize) {
        let points = ParticleRenderer.textToPoints(text: text, canvasSize: size)
        particles = points.map { point in
            Particle.random(base: point, canvasSize: size)
        }
        updateCursorPosition(for: text, in: size)
    }
    
    func updateParticles() {
        for i in particles.indices {
            particles[i].update(dragPosition: dragPosition, dragVelocity: dragVelocity)
        }
    }
    
    func handleDrag(at position: CGPoint, velocity: CGSize) {
        dragPosition = position
        dragVelocity = velocity
        triggerHapticFeedback()
    }
    
    func resetDrag() {
        dragPosition = nil
        dragVelocity = nil
    }
    
    private func triggerHapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func updateCursorPosition(for text: String, in canvasSize: CGSize) {
        guard !text.isEmpty else {
            cursorPosition = nil
            return
        }
        let points = ParticleRenderer.textToPoints(text: text, canvasSize: canvasSize)
        if let farthestPoint = points.max(by: {$0.x < $1.x}) {
            cursorPosition = CGPoint(x: farthestPoint.x + 8, y: farthestPoint.y)
        }
    }
}
