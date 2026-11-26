import SwiftUI

struct ListeningReadingHubView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(Array(MockData.toeicParts.enumerated()), id: \.element.id) { index, part in
                    NavigationLink(value: LearnDestination.toeicPartPractice(part)) {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(part.skillGroup == .listening ? "Luyện nghe" : "Luyện đọc") · \(part.title)")
                                    .font(.system(.subheadline, design: .default, weight: .semibold))
                                    .foregroundStyle(NeonTheme.textPrimary)
                                Text(part.vietnameseName)
                                    .font(.system(.caption, design: .default))
                                    .foregroundStyle(NeonTheme.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(NeonTheme.textSecondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                    }
                    .buttonStyle(.plain)

                    if index < MockData.toeicParts.count - 1 {
                        Rectangle().fill(NeonTheme.border).frame(height: 1).padding(.leading, 20)
                    }
                }
            }
            .background(NeonTheme.surface)
            .padding(.top, 8)
        }
        .neonScreenBackground()
        .navigationTitle("Luyện nghe & đọc")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct ToeicPartPracticeView: View {
    let part: ToeicPartItem

    @Environment(\.dismiss) private var dismiss
    @State private var currentPartID: String
    @State private var selectedAnswers: [String: Int] = [:]
    @State private var isChecked = false
    @State private var showTranscript = false
    @State private var showOnlyQuestions = false
    @State private var isPlaying = false
    @State private var playbackSpeed = 1
    @State private var playbackProgress = 0.5

    init(part: ToeicPartItem) {
        self.part = part
        _currentPartID = State(initialValue: part.id)
    }

    private var activePart: ToeicPartItem {
        MockData.toeicParts.first(where: { $0.id == currentPartID }) ?? part
    }

    private var availableParts: [ToeicPartItem] {
        MockData.toeicParts.filter { $0.skillGroup == activePart.skillGroup }
    }

    private var isListening: Bool { activePart.skillGroup == .listening }

    private var resultItems: [PracticeAnswerReview] {
        activePart.questions.map { question in
            let selected = selectedAnswers[question.id]
            let correctAnswer = question.options.indices.contains(question.correctIndex) ? question.options[question.correctIndex] : ""
            let userAnswer = selected.flatMap { question.options.indices.contains($0) ? question.options[$0] : nil } ?? ""
            return PracticeAnswerReview(
                id: question.id,
                label: question.numberLabel,
                userAnswer: userAnswer,
                correctAnswer: correctAnswer,
                explanation: question.explanationVi,
                isCorrect: selected == question.correctIndex
            )
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                partSwitcher

                if isListening, activePart.visualCaption != nil {
                    Image("ListeningPartOne")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 176)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
                        .accessibilityLabel("Đồng nghiệp trao đổi tài liệu tại bàn làm việc")
                }

                if isListening, let title = activePart.audioTitle, let duration = activePart.audioDuration {
                    audioSurface(title: title, duration: duration)
                }

                if !isListening {
                    readingSwitcher
                    if !showOnlyQuestions, let passageTitle = activePart.passageTitle, let passageBody = activePart.passageBody {
                        readingPassage(title: passageTitle, bodyText: passageBody)
                    }
                }

                questionsSection

                if isListening, activePart.transcriptEn != nil {
                    transcriptSection
                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .navigationTitle("\(isListening ? "Luyện nghe" : "Luyện đọc") · Part \(activePart.partNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Label("Học", systemImage: "chevron.left") }
                    .font(.system(.subheadline, design: .default, weight: .medium))
                    .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.practiceResult(
                    title: "\(isListening ? "Luyện nghe" : "Luyện đọc") · Part \(activePart.partNumber)",
                    subtitle: activePart.vietnameseName,
                    items: resultItems
                )) {
                    Text("Nộp")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                }
            }
        }
        .onChange(of: currentPartID) { _, _ in
            selectedAnswers.removeAll()
            isChecked = false
            showTranscript = false
        }
    }

    private var partSwitcher: some View {
        HStack(spacing: 4) {
            ForEach(availableParts) { item in
                Button {
                    currentPartID = item.id
                } label: {
                    Text(item.title)
                        .font(.system(.caption, design: .default, weight: item.id == currentPartID ? .semibold : .medium))
                        .foregroundStyle(item.id == currentPartID ? NeonTheme.textPrimary : NeonTheme.textSecondary)
                        .frame(maxWidth: .infinity, minHeight: 38)
                        .background(item.id == currentPartID ? NeonTheme.surface : Color.clear)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Capsule().fill(NeonTheme.subtleSurface))
    }

    private var readingSwitcher: some View {
        HStack(spacing: 4) {
            switchButton("Đoạn văn & Câu hỏi", selected: !showOnlyQuestions) { showOnlyQuestions = false }
            switchButton("Chỉ xem câu hỏi", selected: showOnlyQuestions) { showOnlyQuestions = true }
        }
        .padding(4)
        .background(Capsule().fill(NeonTheme.subtleSurface))
    }

    private func switchButton(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(.caption2, design: .default, weight: selected ? .semibold : .medium))
                .foregroundStyle(selected ? NeonTheme.textPrimary : NeonTheme.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, minHeight: 38)
                .background(selected ? NeonTheme.surface : Color.clear)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func audioSurface(title: String, duration: String) -> some View {
        HStack(spacing: 12) {
            Button { isPlaying.toggle() } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(NeonTheme.primaryBlue))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Phát audio")

            VStack(spacing: 5) {
                Slider(value: $playbackProgress)
                    .tint(NeonTheme.primaryBlue)
                HStack {
                    Text(isPlaying ? "00:08" : "00:00")
                    Spacer()
                    Text(duration)
                }
                .font(.system(.caption2, design: .monospaced))
                .foregroundStyle(NeonTheme.textSecondary)
            }

            Button(playbackSpeed == 1 ? "1.0x" : "0.8x") {
                playbackSpeed = playbackSpeed == 1 ? 0 : 1
            }
            .font(.system(.caption, design: .monospaced, weight: .semibold))
            .foregroundStyle(NeonTheme.textPrimary)
            .padding(.horizontal, 11)
            .frame(minHeight: 36)
            .background(Capsule().fill(NeonTheme.subtleSurface))
            .buttonStyle(.plain)
            .accessibilityLabel("Tốc độ phát, \(playbackSpeed == 1 ? "1.0x" : "0.8x")")
        }
        .padding(14)
        .background(NeonTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }

    private func readingPassage(title: String, bodyText: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(.caption, design: .default, weight: .semibold))
                .foregroundStyle(NeonTheme.coral)
            Text(bodyText)
                .font(.system(.subheadline, design: .default))
                .foregroundStyle(NeonTheme.textPrimary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NeonTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
    }

    private var questionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(activePart.questions) { question in
                let chosen = selectedAnswers[question.id]

                if activePart.questions.count > 1 || !isListening {
                    Text("\(question.numberLabel) · Chọn đáp án đúng")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textSecondary)
                        .padding(.horizontal, 4)
                }

                if !isListening {
                    Text(question.prompt)
                        .font(.system(.subheadline, design: .default, weight: .medium))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 4)
                } else if activePart.partNumber != 1 {
                    Text(question.prompt)
                        .font(.system(.subheadline, design: .default, weight: .medium))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 4)
                }

                VStack(spacing: 8) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        answerOption(option, index: index, questionID: question.id, chosen: chosen, correctIndex: question.correctIndex)
                    }
                }

                if isChecked, let chosen {
                    Text(chosen == question.correctIndex ? "✓ Chính xác (\(letter(question.correctIndex))): \(question.explanationVi)" : "Đáp án \(letter(question.correctIndex)): \(question.explanationVi)")
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(chosen == question.correctIndex ? NeonTheme.teal : NeonTheme.coral)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(chosen == question.correctIndex ? NeonTheme.tealSoft : NeonTheme.coralSoft)
                        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                }
            }
        }
    }

    private func answerOption(_ option: String, index: Int, questionID: String, chosen: Int?, correctIndex: Int) -> some View {
        let isSelected = chosen == index
        let showCorrect = isChecked && index == correctIndex
        let showWrong = isChecked && isSelected && index != correctIndex
        let prefix = isListening ? "(\(letter(index))) " : "\(letter(index)). "

        return Button {
            guard !isChecked else { return }
            selectedAnswers[questionID] = index
        } label: {
            HStack(spacing: 8) {
                Text(prefix + option)
                    .font(.system(.subheadline, design: .default, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(NeonTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 4)
                if showCorrect { Image(systemName: "checkmark.circle.fill").foregroundStyle(NeonTheme.teal) }
                else if showWrong { Image(systemName: "xmark.circle.fill").foregroundStyle(NeonTheme.coral) }
                else { Text(isSelected ? "●" : "○").font(.system(.body, design: .monospaced)).foregroundStyle(isSelected ? NeonTheme.primaryBlue : NeonTheme.textMuted) }
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(showCorrect ? NeonTheme.tealSoft : (showWrong ? NeonTheme.coralSoft : (isSelected ? NeonTheme.primaryBlueSoft : NeonTheme.surface)))
            .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var transcriptSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                showTranscript.toggle()
            } label: {
                HStack {
                    Text(showTranscript ? "Ẩn transcript" : "Xem transcript")
                        .font(.system(.caption, design: .default, weight: .semibold))
                    Spacer()
                    Image(systemName: showTranscript ? "chevron.up" : "chevron.down")
                }
                .foregroundStyle(NeonTheme.primaryBlue)
            }
            .buttonStyle(.plain)

            if showTranscript, let transcript = activePart.transcriptEn {
                Text(transcript)
                    .font(.system(.caption, design: .default))
                    .foregroundStyle(NeonTheme.textSecondary)
                    .lineSpacing(4)
            }
        }
        .padding(14)
        .background(NeonTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
    }

    private func letter(_ index: Int) -> String {
        ["A", "B", "C", "D"][min(index, 3)]
    }
}
