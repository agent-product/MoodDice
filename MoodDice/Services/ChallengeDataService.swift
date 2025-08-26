//
//  ChallengeDataService.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import Foundation

// MARK: - Challenge Data Service
class ChallengeDataService: ObservableObject {
    static let shared = ChallengeDataService()
    
    private init() {
        loadChallenges()
        loadDailyRecords()
    }
    
    // MARK: - Properties
    @Published var allChallenges: [Challenge] = []
    @Published var customChallenges: [Challenge] = []
    @Published var dailyRecords: [DailyChallengeRecord] = []
    
    // UserDefaults keys
    private let customChallengesKey = "CustomChallenges"
    private let dailyRecordsKey = "DailyRecords"
    
    // MARK: - Default Challenges
    private let defaultChallenges: [Challenge] = [
        // 社交类
        Challenge(title: "发一条尴尬的朋友圈", description: "分享一个你觉得有点尴尬但有趣的想法或照片", category: .social),
        Challenge(title: "给一个老朋友发消息", description: "联系一个你很久没有联系的朋友，问问他们近况", category: .social),
        Challenge(title: "夸奖一个陌生人", description: "真诚地夸奖今天遇到的一个陌生人", category: .social),
        Challenge(title: "今天不要用微信1小时", description: "在某个1小时时间段内完全不使用微信", category: .social),
        
        // 自我关怀类
        Challenge(title: "对着镜子说三遍 I love myself", description: "看着镜子中的自己，真诚地说三遍'我爱我自己'", category: .selfCare),
        Challenge(title: "写下今天的三件好事", description: "记录今天发生的三件让你感到开心的事情", category: .selfCare),
        Challenge(title: "给自己泡一杯好茶", description: "慢慢泡一杯茶，享受这个过程和味道", category: .selfCare),
        Challenge(title: "洗个热水澡并涂身体乳", description: "好好照顾自己的身体，享受护肤的过程", category: .selfCare),
        
        // 创意类
        Challenge(title: "用手机拍10张创意照片", description: "从不同角度拍摄身边的普通物品", category: .creativity),
        Challenge(title: "写一首四行小诗", description: "关于今天的天气、心情或看到的事物", category: .creativity),
        Challenge(title: "用身边的物品创作一个小雕塑", description: "发挥想象力，用手边的东西组合成艺术品", category: .creativity),
        Challenge(title: "学一个新的手工技能", description: "看视频学习折纸、编织或其他手工", category: .creativity),
        
        // 健身类
        Challenge(title: "做50个开合跳", description: "分组完成，注意动作标准", category: .fitness),
        Challenge(title: "爬楼梯代替坐电梯", description: "今天所有楼梯都用走的", category: .fitness),
        Challenge(title: "散步30分钟", description: "到附近公园或街道走走，观察周围环境", category: .fitness),
        Challenge(title: "做一组平板支撑", description: "挑战自己能坚持多久", category: .fitness),
        
        // 效率类
        Challenge(title: "清理手机相册", description: "删除不需要的照片，整理相册", category: .productivity),
        Challenge(title: "整理桌面", description: "把工作或学习桌面收拾得干干净净", category: .productivity),
        Challenge(title: "列出明天的三个重要任务", description: "为明天做好计划", category: .productivity),
        Challenge(title: "学习一个新单词", description: "查字典学一个你不认识的单词并造句", category: .productivity),
        
        // 正念类
        Challenge(title: "冥想10分钟", description: "找个安静的地方，专注呼吸10分钟", category: .mindfulness),
        Challenge(title: "感受当下5分钟", description: "放下手机，用五感感受此刻的环境", category: .mindfulness),
        Challenge(title: "写感恩日记", description: "写下今天你感恩的人和事", category: .mindfulness),
        Challenge(title: "深呼吸20次", description: "慢慢深呼吸，感受气息的流动", category: .mindfulness),
        
        // 冒险类
        Challenge(title: "尝试一种新食物", description: "去尝试一个你从没吃过的菜品", category: .adventure),
        Challenge(title: "走一条没走过的路", description: "选择一条平时不走的路线回家", category: .adventure),
        Challenge(title: "和陌生人聊天5分钟", description: "主动和身边的陌生人开始一段友善的对话", category: .adventure),
        Challenge(title: "做一件让你紧张的小事", description: "挑战自己的舒适圈", category: .adventure)
    ]
    
    // MARK: - Methods
    func loadChallenges() {
        allChallenges = defaultChallenges
        loadCustomChallenges()
    }
    
    private func loadCustomChallenges() {
        if let data = UserDefaults.standard.data(forKey: customChallengesKey),
           let challenges = try? JSONDecoder().decode([Challenge].self, from: data) {
            customChallenges = challenges
            allChallenges.append(contentsOf: challenges)
        }
    }
    
    func saveCustomChallenges() {
        if let data = try? JSONEncoder().encode(customChallenges) {
            UserDefaults.standard.set(data, forKey: customChallengesKey)
        }
    }
    
    private func loadDailyRecords() {
        if let data = UserDefaults.standard.data(forKey: dailyRecordsKey),
           let records = try? JSONDecoder().decode([DailyChallengeRecord].self, from: data) {
            dailyRecords = records
        }
    }
    
    func saveDailyRecords() {
        if let data = try? JSONEncoder().encode(dailyRecords) {
            UserDefaults.standard.set(data, forKey: dailyRecordsKey)
        }
    }
    
    func addCustomChallenge(_ challenge: Challenge) {
        let customChallenge = Challenge(
            title: challenge.title,
            description: challenge.description,
            category: .custom,
            isCustom: true
        )
        customChallenges.append(customChallenge)
        allChallenges.append(customChallenge)
        saveCustomChallenges()
    }
    
    func removeCustomChallenge(_ challenge: Challenge) {
        customChallenges.removeAll { $0.id == challenge.id }
        allChallenges.removeAll { $0.id == challenge.id }
        saveCustomChallenges()
    }
    
    func getTodayChallenge() -> Challenge? {
        let today = getTodayString()
        return dailyRecords.first { $0.date == today }?.challenge
    }
    
    func hasChallengeForToday() -> Bool {
        let today = getTodayString()
        return dailyRecords.contains { $0.date == today }
    }
    
    func generateTodayChallenge() -> Challenge {
        let today = getTodayString()
        
        // 如果今天已经有挑战了，返回今天的挑战
        if let existingRecord = dailyRecords.first(where: { $0.date == today }) {
            return existingRecord.challenge
        }
        
        // 获取可用的挑战（排除最近几天的挑战）
        let recentDates = getRecentDates(days: 7)
        let recentChallengeIds = Set(dailyRecords
            .filter { recentDates.contains($0.date) }
            .map { $0.challengeId })
        
        let availableChallenges = allChallenges.filter { !recentChallengeIds.contains($0.id) }
        let challengePool = availableChallenges.isEmpty ? allChallenges : availableChallenges
        
        // 随机选择一个挑战
        let randomChallenge = challengePool.randomElement() ?? defaultChallenges[0]
        
        // 保存今天的挑战记录
        let record = DailyChallengeRecord(challenge: randomChallenge)
        dailyRecords.append(record)
        saveDailyRecords()
        
        return randomChallenge
    }
    
    func markTodayChallengeCompleted() {
        let today = getTodayString()
        if let index = dailyRecords.firstIndex(where: { $0.date == today }) {
            let record = dailyRecords[index]
            dailyRecords[index] = DailyChallengeRecord(challenge: record.challenge, isCompleted: true)
            saveDailyRecords()
        }
    }
    
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func getRecentDates(days: Int) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var dates: [String] = []
        for i in 0..<days {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                dates.append(formatter.string(from: date))
            }
        }
        return dates
    }
}
