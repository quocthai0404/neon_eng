import SwiftUI

struct GrammarCatalogView: View {
    private var topics: [GrammarTopicItem] { MockData.grammarTopics }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(Array(topics.enumerated()), id: \.element.id) { index, topic in
                    NavigationLink(value: LearnDestination.grammarDetail(topic)) {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(catalogTitle(topic))
                                    .font(.system(.subheadline, design: .default, weight: .semibold))
                                    .foregroundStyle(NeonTheme.textPrimary)
                                    .multilineTextAlignment(.leading)
                                Text(topic.subtitle)
                                    .font(.system(.caption, design: .default))
                                    .foregroundStyle(NeonTheme.textSecondary)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer(minLength: 4)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(NeonTheme.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if index < topics.count - 1 {
                        Rectangle()
                            .fill(NeonTheme.border)
                            .frame(height: 1)
                            .padding(.leading, 20)
                    }
                }
            }
            .background(NeonTheme.surface)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Ngữ pháp trọng tâm")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }

    private func catalogTitle(_ topic: GrammarTopicItem) -> String {
        topic.id == "g-1" ? "Giới từ & Liên từ (Despite / Although)" : topic.title
    }
}

struct GrammarTopicDetailView: View {
    let topic: GrammarTopicItem

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Lý thuyết trọng tâm · Part 5 & 6")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.primaryBlue)
                    Text(topic.title)
                        .font(.system(.title2, design: .default, weight: .bold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(topic.subtitle)
                        .font(.system(.subheadline, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if topic.id == "g-1" {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Bảng phân biệt nhanh")
                            .font(.system(.subheadline, design: .default, weight: .semibold))
                            .foregroundStyle(NeonTheme.textPrimary)
                        comparisonTable
                    }
                } else {
                    ruleSummary
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Ví dụ trong đề TOEIC")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)

                    ForEach(topic.rules) { rule in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(rule.exampleEn)
                                .font(.system(.subheadline, design: .default, weight: .medium))
                                .foregroundStyle(NeonTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("→ \(rule.noteVi)")
                                .font(.system(.caption, design: .default))
                                .foregroundStyle(NeonTheme.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if rule.id != topic.rules.last?.id {
                            Rectangle().fill(NeonTheme.border).frame(height: 1)
                        }
                    }
                }
                .padding(.top, 18)
                .overlay(alignment: .top) {
                    Rectangle().fill(NeonTheme.border).frame(height: 1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .navigationTitle("Lý thuyết")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.grammarPractice(topic)) {
                    Text("Thực hành")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                }
            }
        }
    }

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                tableCell("Loại từ", weight: .semibold)
                tableCell("Từ khóa", weight: .semibold)
                tableCell("Theo sau", weight: .semibold)
            }
            .background(NeonTheme.subtleSurface)

            HStack(alignment: .top, spacing: 0) {
                tableCell("Giới từ")
                tableCell("Despite / In spite of", color: NeonTheme.primaryBlue, mono: true)
                tableCell("Cụm danh từ / V-ing")
            }
            .overlay(alignment: .bottom) { Rectangle().fill(NeonTheme.border).frame(height: 1) }

            HStack(alignment: .top, spacing: 0) {
                tableCell("Liên từ")
                tableCell("Although / Even though", color: NeonTheme.teal, mono: true)
                tableCell("Mệnh đề (S + V)")
            }
        }
        .background(NeonTheme.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(NeonTheme.border, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var ruleSummary: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quy tắc cốt lõi")
                .font(.system(.subheadline, design: .default, weight: .semibold))
                .foregroundStyle(NeonTheme.textPrimary)

            ForEach(Array(topic.rules.enumerated()), id: \.element.id) { index, rule in
                VStack(alignment: .leading, spacing: 6) {
                    Text(rule.heading)
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.primaryBlue)
                    Text(rule.formula)
                        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(rule.noteVi)
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if index < topic.rules.count - 1 {
                    Rectangle().fill(NeonTheme.border).frame(height: 1)
                }
            }
        }
    }

    private func tableCell(_ text: String, weight: Font.Weight = .regular, color: Color = NeonTheme.textPrimary, mono: Bool = false) -> some View {
        Text(text)
            .font(.system(mono ? .caption : .caption, design: mono ? .monospaced : .default, weight: weight))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            .padding(.horizontal, 9)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct GrammarPracticeView: View {
    let topic: GrammarTopicItem

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var selectedAnswers: [String: Int] = [:]
    @State private var checkedQuestionIDs: Set<String> = []

    private var question: GrammarPracticeItem {
        topic.practiceItems[min(currentIndex, topic.practiceItems.count - 1)]
    }

    private var selectedAnswer: Int? { selectedAnswers[question.id] }
    private var isChecked: Bool { checkedQuestionIDs.contains(question.id) }

    private var resultItems: [PracticeAnswerReview] {
        topic.practiceItems.enumerated().map { index, item in
            let selected = selectedAnswers[item.id]
            let correctAnswer = item.options.indices.contains(item.correctIndex) ? item.options[item.correctIndex] : ""
            let userAnswer = selected.flatMap { item.options.indices.contains($0) ? item.options[$0] : nil } ?? ""
            return PracticeAnswerReview(
                id: item.id,
                label: "Câu \(index + 1)",
                userAnswer: userAnswer,
                correctAnswer: correctAnswer,
                explanation: item.tipVi,
                isCorrect: selected == item.correctIndex
            )
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(topic.id == "g-1" ? "Part 5 · Giới từ & Liên từ" : "Part 5 · \(topic.title)")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.primaryBlue)
                    Text("“\(question.question)”")
                        .font(.system(.body, design: .default))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 4)

                VStack(spacing: 10) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        practiceOption(option, index: index)
                    }
                }

                if isChecked {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(selectedAnswer == question.correctIndex ? "✓ Chính xác (\(letter(question.correctIndex)))" : "Chưa chính xác")
                            .font(.system(.subheadline, design: .default, weight: .semibold))
                        Text(question.tipVi)
                            .font(.system(.caption, design: .default))
                    }
                    .foregroundStyle(selectedAnswer == question.correctIndex ? NeonTheme.teal : NeonTheme.coral)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(selectedAnswer == question.correctIndex ? NeonTheme.tealSoft : NeonTheme.coralSoft)
                    .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))

                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Thực hành")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Label("Lý thuyết", systemImage: "chevron.left") }
                    .font(.system(.subheadline, design: .default, weight: .medium))
                    .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.practiceResult(
                    title: "Ngữ pháp · \(topic.indexLabel)",
                    subtitle: topic.title,
                    items: resultItems
                )) {
                    Text("Nộp")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Group {
                if isChecked && currentIndex == topic.practiceItems.count - 1 {
                    NavigationLink(value: LearnDestination.practiceResult(
                        title: "Ngữ pháp · \(topic.indexLabel)",
                        subtitle: topic.title,
                        items: resultItems
                    )) {
                        Text("Xem kết quả")
                            .font(.system(.subheadline, design: .default, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(Capsule().fill(NeonTheme.primaryBlue))
                    }
                    .buttonStyle(.plain)
                } else {
                    Button(isChecked ? "Câu tiếp theo" : "Kiểm tra") {
                        if isChecked {
                            currentIndex += 1
                        } else {
                            checkedQuestionIDs.insert(question.id)
                        }
                    }
                    .buttonStyle(NeonPrimaryButtonStyle())
                    .disabled(!isChecked && selectedAnswer == nil)
                    .opacity(!isChecked && selectedAnswer == nil ? 0.65 : 1)
                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(NeonTheme.canvas)
            .overlay(alignment: .top) { Rectangle().fill(NeonTheme.border).frame(height: 1) }
        }
    }

    private func practiceOption(_ option: String, index: Int) -> some View {
        let isSelected = selectedAnswer == index
        let isCorrect = isChecked && index == question.correctIndex
        let isWrong = isChecked && isSelected && !isCorrect
        return Button {
            guard !isChecked else { return }
            selectedAnswers[question.id] = index
        } label: {
            HStack {
                Text("\(letter(index)). \(option)")
                    .font(.system(.subheadline, design: .default, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(NeonTheme.textPrimary)
                Spacer(minLength: 4)
                if isCorrect { Image(systemName: "checkmark.circle.fill").foregroundStyle(NeonTheme.teal) }
                else if isWrong { Image(systemName: "xmark.circle.fill").foregroundStyle(NeonTheme.coral) }
                else { Text(isSelected ? "●" : "○").foregroundStyle(isSelected ? NeonTheme.primaryBlue : NeonTheme.textMuted) }
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(isCorrect ? NeonTheme.tealSoft : (isWrong ? NeonTheme.coralSoft : (isSelected ? NeonTheme.primaryBlueSoft : NeonTheme.surface)))
            .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func letter(_ index: Int) -> String { ["A", "B", "C", "D"][min(index, 3)] }
}
