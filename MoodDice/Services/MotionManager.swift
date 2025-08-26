//
//  MotionManager.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import Foundation
import CoreMotion

// MARK: - Motion Manager
class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var shakeThreshold: Double = 2.5
    private var lastShakeTime: Date = Date()
    private let shakeInterval: TimeInterval = 1.0 // 防止重复触发的时间间隔
    
    @Published var isShaking = false
    
    var onShakeDetected: (() -> Void)?
    
    func startShakeDetection() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is not available")
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let accelerometerData = data else { return }
            
            let acceleration = accelerometerData.acceleration
            let magnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
            
            // 检测摇动
            if magnitude > self.shakeThreshold {
                let now = Date()
                if now.timeIntervalSince(self.lastShakeTime) > self.shakeInterval {
                    DispatchQueue.main.async {
                        self.isShaking = true
                        self.onShakeDetected?()
                        self.lastShakeTime = now
                        
                        // 重置摇动状态
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isShaking = false
                        }
                    }
                }
            }
        }
    }
    
    func stopShakeDetection() {
        motionManager.stopAccelerometerUpdates()
    }
    
    deinit {
        stopShakeDetection()
    }
}
