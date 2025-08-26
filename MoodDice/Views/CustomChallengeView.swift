//
//  CustomChallengeView.swift
//  MoodDice
//
//  Created by AI Assistant on 8/26/25.
//

import SwiftUI

struct CustomChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var challengeService = ChallengeDataService.shared
    @State private var showingAddChallenge = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if challengeService.customChallenges.isEmpty {
                    // 空状态
                    VStack(spacing: 20) {
                        Image(systemName: "star.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("还没有自定义挑战")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("创建属于你的专属挑战，让每一天都充满惊喜！")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: { showingAddChallenge = true }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("创建第一个挑战")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(25)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    // 挑战列表
                    List {
                        ForEach(challengeService.customChallenges) { challenge in
                            CustomChallengeRow(challenge: challenge)
                        }
                        .onDelete(perform: deleteChallenge)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("自定义挑战")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
                
                if !challengeService.customChallenges.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddChallenge = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddChallenge) {
            AddChallengeView()
        }
    }
    
    private func deleteChallenge(at offsets: IndexSet) {
        for index in offsets {
            let challenge = challengeService.customChallenges[index]
            challengeService.removeCustomChallenge(challenge)
        }
    }
}

struct CustomChallengeRow: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(challenge.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(challenge.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Text(challenge.category.emoji)
                Text(challenge.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(challenge.createdAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var challengeService = ChallengeDataService.shared
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: ChallengeCategory = .custom
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("挑战信息")) {
                    TextField("挑战标题", text: $title)
                    TextField("挑战描述", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("挑战分类")) {
                    Picker("分类", selection: $selectedCategory) {
                        ForEach(ChallengeCategory.allCases.filter { $0 != .custom }, id: \.self) { category in
                            HStack {
                                Text(category.emoji)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .navigationTitle("新建挑战")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveChallenge()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
        }
    }
    
    private func saveChallenge() {
        let challenge = Challenge(
            title: title,
            description: description,
            category: selectedCategory,
            isCustom: true
        )
        challengeService.addCustomChallenge(challenge)
        dismiss()
    }
}

#Preview {
    CustomChallengeView()
}
