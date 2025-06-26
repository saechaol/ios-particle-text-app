//
//  ParticleCanvasOverlay.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

struct ParticleCanvasOverlay: View {
    let dragPosition: CGPoint?
    var body: some View {
        GeometryReader { _ in
            if let position = dragPosition {
                Circle()
                    .stroke(Color.white.opacity(0), lineWidth: 2)
                    .frame(width: 40, height: 40)
                    .position(position)
            }
        }
    }
}

#Preview("light mode") {
    ParticleCanvasOverlay(dragPosition: .init(x: 200, y: 416))
        .preferredColorScheme(.light)
}

#Preview("dark mode") {
    ParticleCanvasOverlay(dragPosition: .init(x: 200, y: 416))
        .preferredColorScheme(.dark)
}
