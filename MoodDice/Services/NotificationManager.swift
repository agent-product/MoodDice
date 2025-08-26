//
//  NotificationManager.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import Foundation
import UserNotifications

// MARK: - Notification Manager
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Request Permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
                self.scheduleDailyReminder()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Schedule Daily Reminder
    func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "🎲 Mood Dice"
        content.body = "今天还没有摇骰子哦！快来获取你的专属挑战吧~"
        content.sound = .default
        content.badge = 1
        
        // 设置每天中午12点提醒
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "daily_reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Daily reminder scheduled successfully")
            }
        }
    }
    
    // MARK: - Cancel All Notifications
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    // MARK: - Reset Badge Count
    func resetBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
