//
//  MainViewModel.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import Foundation
import SwiftUI

// MARK: - Main View Model
@MainActor
class MainViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentChallenge: Challenge?
    @Published var showChallenge = false
    @Published var isRolling = false
    @Published var rotationAngle: Double = 0
    @Published var showPremiumAlert = false
    @Published var isPremiumUser = false
    
    let challengeDataService = ChallengeDataService.shared
    private let motionManager = MotionManager()
    private let storeManager = StoreManager.shared
    
    // MARK: - Initialization
    init() {
        setupMotionDetection()
        loadPremiumStatus()
        loadTodayChallenge()
    }
    
    // MARK: - Setup
    private func setupMotionDetection() {
        motionManager.onShakeDetected = { [weak self] in
            self?.rollDice()
        }
        motionManager.startShakeDetection()
    }
    
    private func loadPremiumStatus() {
        isPremiumUser = storeManager.isPremiumUser
    }
    
    private func loadTodayChallenge() {
        if let todayChallenge = challengeDataService.getTodayChallenge() {
            currentChallenge = todayChallenge
        }
    }
    
    // MARK: - Actions
    func rollDice() {
        // 检查今天是否已经抽过
        if challengeDataService.hasChallengeForToday() {
            if let todayChallenge = challengeDataService.getTodayChallenge() {
                currentChallenge = todayChallenge
                showChallenge = true
            }
            return
        }
        
        // 开始滚动动画
        isRolling = true
        
        withAnimation(.easeInOut(duration: 0.1).repeatCount(6, autoreverses: true)) {
            rotationAngle += 360
        }
        
        // 延迟显示结果
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let challenge = self.challengeDataService.generateTodayChallenge()
            self.currentChallenge = challenge
            self.isRolling = false
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                self.showChallenge = true
            }
        }
    }
    
    func resetChallenge() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showChallenge = false
        }
    }
    
    func markChallengeCompleted() {
        challengeDataService.markTodayChallengeCompleted()
    }
    
    func canAccessCustomChallenges() -> Bool {
        return isPremiumUser
    }
    
    func showPremiumUpgrade() {
        showPremiumAlert = true
    }
    
    // MARK: - Premium Features
    func purchasePremium() {
        Task {
            do {
                try await storeManager.purchasePremium()
                await MainActor.run {
                    isPremiumUser = storeManager.isPremiumUser
                    showPremiumAlert = false
                }
            } catch {
                print("Purchase failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Cleanup
    deinit {
        motionManager.stopShakeDetection()
    }
}
