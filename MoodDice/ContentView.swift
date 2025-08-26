//
//  ContentView.swift
//  MoodDice
//
//  Created by baice on 8/26/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var showingHistory = false
    @State private var showingCustomChallenges = false
    @State private var showingSettings = false
    
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemGray6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App 标题
                VStack(spacing: 8) {
                    Text("🎲")
                        .font(.system(size: 50))
                    Text("Mood Dice")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("摇一摇，开启今日挑战")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 骰子按钮
                VStack(spacing: 24) {
                    DiceView(
                        isRolling: viewModel.isRolling,
                        rotationAngle: viewModel.rotationAngle,
                        onTap: {
                            viewModel.rollDice()
                        }
                    )
                    
                    VStack(spacing: 8) {
                        if let _ = viewModel.currentChallenge {
                            Text("今日挑战已生成")
                                .font(.headline)
                                .foregroundColor(.green)
                            Text("点击骰子查看挑战")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("摇一摇或点击骰子")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("获取今日专属挑战")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // 底部按钮区域
                HStack(spacing: 20) {
                    // 历史记录按钮
                    Button(action: {
                        showingHistory = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.title2)
                            Text("历史")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // 自定义挑战按钮
                    Button(action: {
                        if viewModel.canAccessCustomChallenges() {
                            showingCustomChallenges = true
                        } else {
                            viewModel.showPremiumUpgrade()
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: viewModel.isPremiumUser ? "star.fill" : "star")
                                .font(.title2)
                            Text("自定义")
                                .font(.caption)
                        }
                        .foregroundColor(viewModel.isPremiumUser ? .yellow : .secondary)
                    }
                    
                    Spacer()
                    
                    // 设置按钮
                    Button(action: {
                        showingSettings = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "gearshape")
                                .font(.title2)
                            Text("设置")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .overlay {
            // 挑战卡片覆盖层
            if viewModel.showChallenge, let challenge = viewModel.currentChallenge {
                ChallengeCardView(
                    challenge: challenge,
                    onDismiss: {
                        viewModel.resetChallenge()
                    },
                    onComplete: {
                        viewModel.markChallengeCompleted()
                    }
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
        }
        .alert("解锁高级功能", isPresented: $viewModel.showPremiumAlert) {
            Button("购买高级版") {
                viewModel.purchasePremium()
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text("解锁自定义挑战功能，创建属于你的专属挑战池！")
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView()
        }
        .sheet(isPresented: $showingCustomChallenges) {
            CustomChallengeView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

#Preview {
    ContentView()
}
