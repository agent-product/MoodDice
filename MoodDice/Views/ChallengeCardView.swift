//
//  ChallengeCardView.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import SwiftUI

struct ChallengeCardView: View {
    let challenge: Challenge
    let onDismiss: () -> Void
    let onComplete: () -> Void
    
    @State private var isCompleted = false
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // 背景模糊
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissCard()
                }
            
            // 挑战卡片
            VStack(spacing: 0) {
                // 卡片头部
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(challenge.category.emoji)
                            .font(.title)
                        Text(challenge.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: dismissCard) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // 挑战内容
                VStack(spacing: 16) {
                    Text(challenge.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text(challenge.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                
                // 完成按钮
                Button(action: completeChallenge) {
                    HStack {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                        Text(isCompleted ? "已完成" : "标记完成")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(isCompleted ? .green : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isCompleted ? Color.green.opacity(0.2) : Color.blue)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .disabled(isCompleted)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .frame(maxWidth: 320)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
        }
    }
    
    private func dismissCard() {
        withAnimation(.easeInOut(duration: 0.3)) {
            cardScale = 0.8
            cardOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
    
    private func completeChallenge() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isCompleted = true
        }
        
        // 震动反馈
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        onComplete()
        
        // 2秒后自动关闭
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            dismissCard()
        }
    }
}

#Preview {
    ChallengeCardView(
        challenge: Challenge(
            title: "对着镜子说三遍 I love myself",
            description: "看着镜子中的自己，真诚地说三遍'我爱我自己'",
            category: .selfCare
        ),
        onDismiss: { },
        onComplete: { }
    )
}
