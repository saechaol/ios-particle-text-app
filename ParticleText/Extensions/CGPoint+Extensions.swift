//
//  CGPoint+Extensions.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import CoreGraphics

// MARK: Distance
extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        hypot(x - other.x, y - other.y)
    }
}
