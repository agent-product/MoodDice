//
//  SettingsView.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storeManager = StoreManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    
    @State private var showingRestoreAlert = false
    @State private var notificationsEnabled = true
    
    var body: some View {
        NavigationView {
            List {
                // 高级功能区
                Section(header: Text("高级功能")) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("高级版")
                        Spacer()
                        if storeManager.isPremiumUser {
                            Text("已激活")
                                .font(.caption)
                                .foregroundColor(.green)
                        } else {
                            Button("升级") {
                                Task {
                                    try? await storeManager.purchasePremium()
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                    
                    if !storeManager.isPremiumUser {
                        Button("恢复购买") {
                            Task {
                                await storeManager.restorePurchases()
                                showingRestoreAlert = true
                            }
                        }
                    }
                }
                
                // 通知设置
                Section(header: Text("通知设置")) {
                    Toggle("每日提醒", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, enabled in
                            if enabled {
                                notificationManager.requestPermission()
                            } else {
                                notificationManager.cancelAllNotifications()
                            }
                        }
                    
                    if notificationsEnabled {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                            Text("提醒时间")
                            Spacer()
                            Text("中午 12:00")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // 数据管理
                Section(header: Text("数据管理")) {
                    Button("清除历史记录") {
                        clearHistory()
                    }
                    .foregroundColor(.red)
                    
                    Button("重置所有数据") {
                        resetAllData()
                    }
                    .foregroundColor(.red)
                }
                
                // 关于
                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("开发者")
                        Spacer()
                        Text("Mood Dice Team")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("评价应用") {
                        // TODO: 跳转到 App Store 评价
                    }
                    
                    Button("联系我们") {
                        // TODO: 打开邮件客户端
                    }
                }
                
                // 法律信息
                Section(header: Text("法律")) {
                    Button("隐私政策") {
                        // TODO: 显示隐私政策
                    }
                    
                    Button("服务条款") {
                        // TODO: 显示服务条款
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
        .alert("恢复购买", isPresented: $showingRestoreAlert) {
            Button("确定") { }
        } message: {
            Text(storeManager.isPremiumUser ? "购买已恢复！" : "没有找到可恢复的购买记录。")
        }
        .onAppear {
            checkNotificationStatus()
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
    
    private func clearHistory() {
        let challengeService = ChallengeDataService.shared
        challengeService.dailyRecords.removeAll()
        challengeService.saveDailyRecords()
    }
    
    private func resetAllData() {
        let challengeService = ChallengeDataService.shared
        
        // 清除所有数据
        challengeService.dailyRecords.removeAll()
        challengeService.customChallenges.removeAll()
        challengeService.allChallenges = challengeService.allChallenges.filter { !$0.isCustom }
        
        // 保存更改
        challengeService.saveDailyRecords()
        challengeService.saveCustomChallenges()
        
        // 重置高级版状态（仅用于演示）
        UserDefaults.standard.set(false, forKey: "isPremiumUser")
        storeManager.isPremiumUser = false
    }
}

#Preview {
    SettingsView()
}
