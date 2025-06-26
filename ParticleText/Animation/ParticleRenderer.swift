//
//  ParticleRenderer.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/25/25.
//

import SwiftUI

enum ParticleRenderer {
    static func textToPoints(text: String, canvasSize: CGSize) -> [CGPoint] {
        let maxWidth = canvasSize.width * 0.8
        let maxHeight = canvasSize.height * 0.8
        let fontSize = findBestFittingFontSize(for: text, in: canvasSize)
        
        let textView = Text(text)
            .font(.system(size: fontSize, design: .rounded))
            .bold()
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: maxWidth, height: maxHeight)
        
        let wrappedText = VStack { textView }
            .frame(width: maxWidth, height: maxHeight)
            .padding()
        
        let renderer = ImageRenderer(content: wrappedText)
        renderer.scale = 1.0
        
        guard let image = renderer.uiImage,
              let cgImage = image.cgImage,
              let data = cgImage.dataProvider?.data,
              let pixelData = CFDataGetBytePtr(data) else {
            return []
        }
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let offsetX = (canvasSize.width - CGFloat(width)) / 2
        let offsetY = (canvasSize.height - CGFloat(height)) / 2
        
        var points: [CGPoint] = []
        for y in 0..<height {
            for x in 0..<width {
                let alpha = pixelData[((width * y) + x) * 4 + 3]
                if alpha > 128 {
                    points.append(CGPoint(x: x + Int(offsetX), y: y + Int(offsetY)))
                }
            }
        }
        
        // cap runaway particle counts
        let minParticles = 800
        let maxParticles = 8000
        let densityFactor = 1.375
        let desiredCount = Int(Double(points.count) * densityFactor)
        let cappedCount = max(minParticles, min(maxParticles, desiredCount))
        return Array(points.shuffled().prefix(cappedCount))
    }
    
    static func findBestFittingFontSize(for text: String, in canvasSize: CGSize) -> CGFloat {
        let maxWidth = canvasSize.width * 0.8
        let maxHeight = canvasSize.height * 0.8
        let baseFontSize: CGFloat = 100
        let minFontSize: CGFloat = 24
        
        for size in stride(from: baseFontSize, through: minFontSize, by: -2) {
            let textView = Text(text)
                .font(.system(size: size, design: .rounded))
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: maxWidth)
            
            let container = VStack { textView }
                .frame(width: maxWidth)
                .padding()
            
            let renderer = ImageRenderer(content: container)
            renderer.scale = 1.0
            if let image = renderer.uiImage, image.size.height <= maxHeight {
                return size
            }
        }
        return minFontSize
    }
}
