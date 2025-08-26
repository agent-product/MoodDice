//
//  MoodDiceApp.swift
//  MoodDice
//
//  Created by baice on 8/26/25.
//

import SwiftUI

@main
struct MoodDiceApp: App {
    init() {
        // 请求通知权限
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    // App 进入前台时重置角标
                    NotificationManager.shared.resetBadgeCount()
                }
        }
    }
}
