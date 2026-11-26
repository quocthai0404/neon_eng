import SwiftUI

struct VocabQuizView: View {
    let listTitle: String

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var selectedAnswers: [String: Int] = [:]
    @State private var checkedQuestionIDs: Set<String> = []

    private let questions = MockData.sampleVocabQuiz

    private var question: VocabQuizQuestion {
        questions[min(currentIndex, questions.count - 1)]
    }

    private var selectedOptionIndex: Int? { selectedAnswers[question.id] }
    private var isChecked: Bool { checkedQuestionIDs.contains(question.id) }

    private var resultItems: [PracticeAnswerReview] {
        questions.enumerated().map { index, item in
            let selected = selectedAnswers[item.id]
            let correctAnswer = item.options.indices.contains(item.correctIndex) ? item.options[item.correctIndex] : ""
            let userAnswer = selected.flatMap { item.options.indices.contains($0) ? item.options[$0] : nil } ?? ""
            return PracticeAnswerReview(
                id: item.id,
                label: "Câu \(index + 1)",
                userAnswer: userAnswer,
                correctAnswer: correctAnswer,
                explanation: item.explanationVi,
                isCorrect: selected == item.correctIndex
            )
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(question.promptType)
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.gold)

                    Text(question.prompt)
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    if let ipa = question.ipaHint {
                        Text("\(ipa) · (v)")
                            .font(.system(.subheadline, design: .monospaced))
                            .foregroundStyle(NeonTheme.textSecondary)
                    }
                }
                .padding(.horizontal, 4)

                VStack(spacing: 10) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        optionRow(option, at: index)
                    }
                }

                if isChecked, let selectedOptionIndex {
                    feedback(isCorrect: selectedOptionIndex == question.correctIndex)
                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Trắc nghiệm")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("Chi tiết", systemImage: "chevron.left")
                }
                .font(.system(.subheadline, design: .default, weight: .medium))
                .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.practiceResult(
                    title: "Trắc nghiệm từ vựng",
                    subtitle: listTitle,
                    items: resultItems
                )) {
                    Text("Nộp")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            HStack(spacing: 10) {
                if isChecked && currentIndex == questions.count - 1 {
                    NavigationLink(value: LearnDestination.practiceResult(
                        title: "Trắc nghiệm từ vựng",
                        subtitle: listTitle,
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
                    Button {
                        if isChecked {
                            currentIndex += 1
                        } else {
                            checkedQuestionIDs.insert(question.id)
                        }
                    } label: {
                        Text(isChecked ? "Câu tiếp theo" : "Kiểm tra")
                            .font(.system(.subheadline, design: .default, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(Capsule().fill(NeonTheme.primaryBlue))
                    }
                    .buttonStyle(.plain)
                    .disabled(!isChecked && selectedOptionIndex == nil)
                    .opacity(!isChecked && selectedOptionIndex == nil ? 0.65 : 1)
                }

                NavigationLink(value: LearnDestination.vocabMatching(listTitle: listTitle)) {
                    HStack(spacing: 6) {
                        Text("Ghép cặp")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(.subheadline, design: .default, weight: .semibold))
                    .foregroundStyle(NeonTheme.textPrimary)
                    .padding(.horizontal, 20)
                    .frame(minHeight: 52)
                    .background(Capsule().fill(NeonTheme.subtleSurface))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .background(NeonTheme.canvas)
            .overlay(alignment: .top) {
                Rectangle().fill(NeonTheme.border).frame(height: 1)
            }
        }
    }

    private func optionRow(_ option: String, at index: Int) -> some View {
        let isSelected = selectedOptionIndex == index
        let isCorrect = index == question.correctIndex
        let showCorrect = isChecked && isCorrect
        let showWrong = isChecked && isSelected && !isCorrect
        let letter = ["A", "B", "C", "D"][min(index, 3)]

        return Button {
            guard !isChecked else { return }
            selectedAnswers[question.id] = index
        } label: {
            HStack(spacing: 12) {
                Text("\(letter). \(option)")
                    .font(.system(.subheadline, design: .default, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(NeonTheme.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 4)

                if showCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(NeonTheme.teal)
                } else if showWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(NeonTheme.coral)
                } else {
                    Text(isSelected ? "●" : "○")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(isSelected ? NeonTheme.primaryBlue : NeonTheme.textMuted)
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
            .background(rowColor(isSelected: isSelected, correct: showCorrect, wrong: showWrong))
            .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func rowColor(isSelected: Bool, correct: Bool, wrong: Bool) -> Color {
        if correct { return NeonTheme.tealSoft }
        if wrong { return NeonTheme.coralSoft }
        if isSelected { return NeonTheme.primaryBlueSoft }
        return NeonTheme.surface
    }

    private func feedback(isCorrect: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(isCorrect ? "✓ Chính xác (\(optionLetter(question.correctIndex)))" : "Chưa chính xác")
                .font(.system(.subheadline, design: .default, weight: .semibold))
            Text(question.explanationVi)
                .font(.system(.caption, design: .default))
        }
        .foregroundStyle(isCorrect ? NeonTheme.teal : NeonTheme.coral)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background((isCorrect ? NeonTheme.tealSoft : NeonTheme.coralSoft))
        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
    }

    private func optionLetter(_ index: Int) -> String {
        ["A", "B", "C", "D"][min(index, 3)]
    }
}
