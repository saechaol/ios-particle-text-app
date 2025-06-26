//
//  ParticleView.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/24/25.
//

import SwiftUI

struct Particle {
    var x, y: Double
    let baseX: Double
    let baseY: Double
    let density: Double
    
    static func random(base: CGPoint, canvasSize: CGSize) -> Particle {
        return Particle(
            x: Double.random(in: -canvasSize.width...canvasSize.width),
            y: Double.random(in: 0...canvasSize.height * 2),
            baseX: base.x,
            baseY: base.y,
            density: Double.random(in: 5...20)
        )
    }
    
    mutating func update(dragPosition: CGPoint?, dragVelocity: CGSize?) {
        let currentPosition = CGPoint(x: x, y: y)
        let targetPosition = CGPoint(x: baseX, y: baseY)
        let distance = currentPosition.distance(to: targetPosition)
        
        let dx = baseX - x
        let dy = baseY - y
        
        let xUnitVector = dx / distance
        let yUnitVector = dy / distance
        
        // short-range, linearly decaying force
        let force = max(0, (280 - distance) / 280)
        let xForceComponent = xUnitVector * force * density
        let yForceComponent = yUnitVector * force * density
        
        if distance < 30 {
            x += xForceComponent * 0.05
            y += yForceComponent * 0.05
        } else if distance < 280 {
            x += xForceComponent * 4.0
            y += yForceComponent * 4.0
        } else {
            x += (baseX - x) / 6.0
            y += (baseY - y) / 6.0
        }
        
        if let dragPosition = dragPosition {
            let dragDistance = currentPosition.distance(to: dragPosition)
            let dragDx = x - dragPosition.x
            let dragDy = y - dragPosition.y
            
            // velocity magnitude
            let velocityMagnitude = dragVelocity.map {
                max(abs($0.width), abs($0.height))
            } ?? 0.0
            
            let maxDragDistance: CGFloat = 200
            
            let normalizedDistance = max(0, 1 - min(dragDistance, maxDragDistance) / maxDragDistance)
            
            // quadratic easing for smooth falloff near touch
            let easedForce = normalizedDistance * normalizedDistance
            
            // combine easing with velocity influence
            let totalForce = easedForce + velocityMagnitude * 0.0001
            
            let dragMultiplier = 1.3
            
            x += dragDx * totalForce * dragMultiplier
            y += dragDy * totalForce * dragMultiplier
        }
    }
}
