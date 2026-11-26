import SwiftUI

struct DictationHubView: View {
    @State private var selectedMode: DictationMode = .hard

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Chọn chế độ luyện tập")
                    .font(.system(.caption, design: .default))
                    .foregroundStyle(NeonTheme.textSecondary)
                    .padding(.horizontal, 5)

                Picker("Chế độ luyện tập", selection: $selectedMode) {
                    ForEach(DictationMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.vertical, 12)
            .overlay(alignment: .bottom) { Rectangle().fill(NeonTheme.border).frame(height: 1) }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(MockData.dictationLessons.enumerated()), id: \.element.id) { index, lesson in
                        NavigationLink(value: LearnDestination.dictationSession(lesson: lesson, initialMode: selectedMode)) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lessonRowTitle(lesson, index: index))
                                        .font(.system(.subheadline, design: .default, weight: .semibold))
                                        .foregroundStyle(NeonTheme.textPrimary)
                                    Text(index == 0 ? "Hội thoại văn phòng · Có bản ghi theo mốc giờ" : "Thông báo nội bộ · Có bản ghi theo mốc giờ")
                                        .font(.system(.caption, design: .default))
                                        .foregroundStyle(NeonTheme.textSecondary)
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

                        if index < MockData.dictationLessons.count - 1 {
                            Rectangle().fill(NeonTheme.border).frame(height: 1).padding(.leading, 20)
                        }
                    }
                }
                .background(NeonTheme.surface)
                .padding(.top, 8)
            }
        }
        .neonScreenBackground()
        .navigationTitle("Nghe chép chính tả")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }

    private func lessonRowTitle(_ lesson: DictationLessonItem, index: Int) -> String {
        let title = index == 0 ? "Đặt phòng hội nghị" : "Thông báo bảo trì hệ thống"
        return "Bài \(index == 0 ? "08" : "09") · \(title)"
    }
}

struct DictationSessionView: View {
    let lesson: DictationLessonItem

    @Environment(\.dismiss) private var dismiss
    @State private var mode: DictationMode
    @State private var lineIndex = 0
    @State private var answer = ""
    @State private var showTranscript = false
    @State private var isPlaying = false
    @State private var playbackSpeed = 1
    @State private var playbackProgress = 0.54

    init(lesson: DictationLessonItem, initialMode: DictationMode) {
        self.lesson = lesson
        _mode = State(initialValue: initialMode)
    }

    private var currentLine: DictationLine {
        lesson.lines[min(lineIndex, lesson.lines.count - 1)]
    }

    private var expectedAnswers: [String] {
        switch mode {
        case .normal: return currentLine.normalAnswers
        case .hard: return currentLine.hardAnswers
        case .sentence: return []
        }
    }

    private var tokens: [String] {
        switch mode {
        case .normal: return currentLine.normalMaskedTokens
        case .hard: return currentLine.hardMaskedTokens
        case .sentence: return []
        }
    }

    private var isAnswerMatched: Bool {
        if mode == .sentence {
            return normalize(answer) == normalize(currentLine.fullSentence)
        }
        let entered = answer.split(separator: ",", omittingEmptySubsequences: false).map { normalize(String($0)) }
        return entered.count == expectedAnswers.count && zip(entered, expectedAnswers).allSatisfy { $0 == normalize($1) }
    }

    private var resultItems: [PracticeAnswerReview] {
        if mode == .sentence {
            return [PracticeAnswerReview(
                id: "sentence-\(currentLine.id)",
                label: "Câu mẫu \(lineIndex + 1)",
                userAnswer: answer,
                correctAnswer: currentLine.fullSentence,
                explanation: currentLine.vietnameseMeaning,
                isCorrect: isAnswerMatched
            )]
        }

        let entered = answer.split(separator: ",", omittingEmptySubsequences: false).map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        return expectedAnswers.enumerated().map { index, expected in
            let userAnswer = entered.indices.contains(index) ? entered[index] : ""
            let details = index == 1 && lesson.id == "dict-1"
                ? "Âm cuối /d/ nối với từ “before”; cụm chuẩn là “are installed before 9 a.m.”"
                : currentLine.vietnameseMeaning
            return PracticeAnswerReview(
                id: "blank-\(currentLine.id)-\(index)",
                label: "Câu mẫu \(lineIndex + 1) · Chỗ trống [\(index + 1)]",
                userAnswer: userAnswer,
                correctAnswer: expected,
                explanation: details,
                isCorrect: userAnswer.caseInsensitiveCompare(expected) == .orderedSame
            )
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                audioSurface

                VStack(alignment: .leading, spacing: 14) {
                    if mode == .sentence {
                        Text("Nghe đoạn mẫu ở trên và gõ lại nguyên câu tiếng Anh:")
                            .font(.system(.subheadline, design: .default))
                            .foregroundStyle(NeonTheme.textPrimary)
                        TextEditor(text: $answer)
                            .font(.system(.body, design: .default))
                            .scrollContentBackground(.hidden)
                            .padding(10)
                            .frame(minHeight: 112)
                            .background(NeonTheme.surface)
                            .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                    } else {
                        Text(renderedPrompt)
                            .font(.system(.body, design: .default))
                            .foregroundStyle(NeonTheme.textPrimary)
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Nhập từ còn thiếu")
                                .font(.system(.caption, design: .default, weight: .semibold))
                                .foregroundStyle(NeonTheme.textSecondary)
                            TextField("Tách nhiều đáp án bằng dấu phẩy", text: $answer)
                                .font(.system(.body, design: .default))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.horizontal, 14)
                                .frame(minHeight: 48)
                                .background(NeonTheme.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous)
                                        .stroke(NeonTheme.border, lineWidth: 1)
                                }
                        }
                    }

                    Button {
                        showTranscript.toggle()
                    } label: {
                        Label(showTranscript ? "Ẩn bản chép song ngữ" : "Xem bản chép song ngữ", systemImage: showTranscript ? "eye.slash" : "doc.plaintext")
                            .font(.system(.caption, design: .default, weight: .semibold))
                            .foregroundStyle(NeonTheme.primaryBlue)
                    }
                    .buttonStyle(.plain)

                    if showTranscript {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(currentLine.fullSentence)
                                .font(.system(.subheadline, design: .default, weight: .medium))
                                .foregroundStyle(NeonTheme.textPrimary)
                            Text(currentLine.vietnameseMeaning)
                                .font(.system(.caption, design: .default))
                                .foregroundStyle(NeonTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .navigationTitle("Bài \(lesson.id == "dict-1" ? "08" : "09") · \(mode.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Label("Chọn bài", systemImage: "chevron.left") }
                    .font(.system(.subheadline, design: .default, weight: .medium))
                    .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.practiceResult(
                    title: "Nghe chép Bài \(lesson.id == "dict-1" ? "08" : "09") (\(mode.rawValue))",
                    subtitle: "Xem lại các câu trả lời và giải thích chi tiết bên dưới.",
                    items: resultItems
                )) {
                    Text("Nộp")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                }
            }
        }
    }

    private var audioSurface: some View {
        VStack(spacing: 12) {
            HStack {
                Text(lesson.id == "dict-1" ? "Đặt phòng hội nghị" : lesson.title)
                    .font(.system(.caption, design: .default, weight: .semibold))
                    .foregroundStyle(NeonTheme.teal)
                Spacer()
                Button(playbackSpeed == 1 ? "1.0x" : "0.8x") {
                    playbackSpeed = playbackSpeed == 1 ? 0 : 1
                }
                .font(.system(.caption, design: .monospaced, weight: .semibold))
                .foregroundStyle(NeonTheme.textPrimary)
                .padding(.horizontal, 12)
                .frame(minHeight: 36)
                .background(Capsule().fill(NeonTheme.subtleSurface))
                .buttonStyle(.plain)
            }

            HStack(spacing: 9) {
                Button { isPlaying.toggle() } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(NeonTheme.primaryBlue))
                }
                .buttonStyle(.plain)

                Button {
                    playbackProgress = max(0, playbackProgress - 0.16)
                } label: {
                    Text("-5s")
                        .font(.system(.caption, design: .monospaced, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(NeonTheme.subtleSurface))
                }
                .buttonStyle(.plain)

                VStack(spacing: 4) {
                    Slider(value: $playbackProgress)
                        .tint(NeonTheme.primaryBlue)
                    HStack {
                        Text("00:14")
                        Spacer()
                        Text("\(currentLine.durationLabel)")
                    }
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(NeonTheme.textSecondary)
                }
            }
        }
        .padding(16)
        .background(NeonTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
    }

    private var renderedPrompt: String {
        var blankIndex = 0
        return tokens.map { token in
            guard token.contains("____") else { return token }
            blankIndex += 1
            let suffix = token.replacingOccurrences(of: "____", with: "")
            return "[\(blankIndex)]\(suffix)"
        }
        .joined(separator: " ")
    }

    private func normalize(_ text: String) -> String {
        text.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: ",", with: "")
    }
}
