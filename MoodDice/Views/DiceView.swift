//
//  DiceView.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import SwiftUI

struct DiceView: View {
    let isRolling: Bool
    let rotationAngle: Double
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // 骰子背景
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(.systemBlue).opacity(0.8),
                                Color(.systemPurple).opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                // 骰子点数（显示6点）
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                    }
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                    }
                }
                
                // 滚动时的模糊效果
                if isRolling {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .blur(radius: 2)
                }
            }
        }
        .rotationEffect(.degrees(rotationAngle))
        .scaleEffect(isRolling ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isRolling)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 30) {
        DiceView(isRolling: false, rotationAngle: 0) { }
        DiceView(isRolling: true, rotationAngle: 180) { }
    }
    .padding()
}
