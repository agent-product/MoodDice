//
//  HistoryView.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var challengeService = ChallengeDataService.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if challengeService.dailyRecords.isEmpty {
                    // 空状态
                    VStack(spacing: 20) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("还没有挑战记录")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("完成你的第一个挑战，开始记录美好时光吧！")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(challengeService.dailyRecords.sorted(by: { $0.date > $1.date }), id: \.date) { record in
                        HistoryRow(record: record)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("挑战历史")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct HistoryRow: View {
    let record: DailyChallengeRecord
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: record.date) {
            formatter.dateFormat = "M月d日 EEEE"
            formatter.locale = Locale(identifier: "zh_CN")
            return formatter.string(from: date)
        }
        return record.date
    }
    
    var isToday: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        return record.date == today
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 日期和状态
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(isToday ? "今天" : formattedDate)
                        .font(.headline)
                        .foregroundColor(isToday ? .blue : .primary)
                    
                    if isToday {
                        Text(formattedDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // 完成状态
                HStack(spacing: 4) {
                    Image(systemName: record.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(record.isCompleted ? .green : .secondary)
                    Text(record.isCompleted ? "已完成" : "未完成")
                        .font(.caption)
                        .foregroundColor(record.isCompleted ? .green : .secondary)
                }
            }
            
            // 挑战信息
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(record.challenge.category.emoji)
                    Text(record.challenge.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                Text(record.challenge.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // 分类标签
                HStack {
                    Text(record.challenge.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    
                    if record.challenge.isCustom {
                        Text("自定义")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
            }
            .padding(.leading, 16)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HistoryView()
}
