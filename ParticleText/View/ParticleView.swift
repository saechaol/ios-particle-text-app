//
//  ParticleView.swift
//  ParticleText
//
//  Created by 세차오 루카스 on 6/24/25.
//

import SwiftUI

struct ParticleView: View {
    @State private var engine = ParticleEngine()
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    @State private var isDragActive: Bool = false
    @State private var interactionState: InteractionState = .idle 
    
    var body: some View {
        ZStack {
            LinearGradient.appPrimary
                .ignoresSafeArea()
            
            ParticleCanvasView(text: text,
                               interactionState: interactionState,
                               engine: $engine)
                .ignoresSafeArea()
                .opacity(isFocused ? 0.3 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isFocused)
            
            VStack {
                TextField("", text: $text, onCommit: {
                    withAnimation {
                        interactionState = .submitted
                        isFocused = false
                    }
                })
                    .textInputAutocapitalization(.never)
                    .keyboardType(.default)
                    .focused($isFocused)
                    .foregroundStyle(Color.white)
                    .submitLabel(.done)
                    .opacity(0.01)
                    .frame(width: 1, height: 1)
                    .padding(.top, -100)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onChange(of: isFocused) {
            withAnimation {
                if isFocused {
                    if interactionState != .typing {
                        text = ""
                    }
                } else {
                    if interactionState != .submitted {
                        interactionState = .idle
                    }
                }
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 10)
                .onChanged { _ in
                    isDragActive = true
                }
                .onEnded { _ in
                    isDragActive = false
                }
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    if !isDragActive {
                        interactionState = .typing
                        isFocused = true
                    }
                }
        )
    }
}

enum InteractionState {
    case idle
    case typing
    case submitted
}

#Preview("light mode") {
    ParticleView()
        .preferredColorScheme(.light)
}

#Preview("dark mode") {
    ParticleView()
        .preferredColorScheme(.dark)
}
