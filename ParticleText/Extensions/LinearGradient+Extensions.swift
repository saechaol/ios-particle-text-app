//
//  LinearGradient+Extensions.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

extension LinearGradient {
    static let appPrimary = LinearGradient(
        colors: [Color.appPrimary, Color.appSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let appPrimaryInverse = LinearGradient(
        colors: [Color.appPrimary, Color.appSecondary],
        startPoint: .bottomTrailing,
        endPoint: .topLeading
    )
}
