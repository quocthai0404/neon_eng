import SwiftUI

struct VocabMatchingView: View {
    let listTitle: String

    @Environment(\.dismiss) private var dismiss
    @State private var selectedTerm: Int? = nil
    @State private var matchedTerms: Set<Int> = []
    @State private var isChecked = false
    @State private var feedbackText: String?

    private let terms = ["abide by", "renewal", "terminate", "clause"]
    private let meanings = ["chấm dứt", "tuân thủ", "điều khoản", "sự gia hạn"]
    private let matchingIndices = [1, 3, 0, 2]

    private var resultItems: [PracticeAnswerReview] {
        terms.indices.map { index in
            let answer = meanings[matchingIndices[index]]
            let isCorrect = matchedTerms.contains(index)
            return PracticeAnswerReview(
                id: "match-\(index)",
                label: terms[index],
                userAnswer: isCorrect ? answer : "Chưa ghép",
                correctAnswer: answer,
                explanation: "\(terms[index]) · \(answer)",
                isCorrect: isCorrect
            )
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Chạm từ tiếng Anh rồi chọn nghĩa tương ứng")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.gold)
                    Text(matchingStatus)
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                }
                .padding(.horizontal, 4)

                HStack(alignment: .top, spacing: 12) {
                    matchColumn(items: terms, isTermColumn: true)
                    matchColumn(items: meanings, isTermColumn: false)
                }

                if let feedbackText {
                    Text(feedbackText)
                        .font(.system(.subheadline, design: .default, weight: .medium))
                        .foregroundStyle(matchedTerms.count == terms.count ? NeonTheme.teal : NeonTheme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background((matchedTerms.count == terms.count ? NeonTheme.tealSoft : NeonTheme.subtleSurface))
                        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Ghép cặp")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Label("Trắc nghiệm", systemImage: "chevron.left") }
                    .font(.system(.subheadline, design: .default, weight: .medium))
                    .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.practiceResult(
                    title: "Ghép cặp từ vựng",
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
                Button(action: checkMatches) {
                    Text(isChecked ? "Đã kiểm tra" : "Kiểm tra")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Capsule().fill(NeonTheme.primaryBlue))
                }
                .buttonStyle(.plain)

                NavigationLink(value: LearnDestination.vocabFillBlank(listTitle: listTitle)) {
                    HStack(spacing: 6) {
                        Text("Điền từ")
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
            .overlay(alignment: .top) { Rectangle().fill(NeonTheme.border).frame(height: 1) }
        }
    }

    private var matchingStatus: String {
        if let selectedTerm {
            return "Đang chọn “\(terms[selectedTerm])” để ghép với nghĩa tiếng Việt"
        }
        return "Đã ghép \(matchedTerms.count)/\(terms.count) cặp"
    }

    private func matchColumn(items: [String], isTermColumn: Bool) -> some View {
        VStack(spacing: 10) {
            ForEach(items.indices, id: \.self) { index in
                let isMatched = isTermColumn ? matchedTerms.contains(index) : matchedTerms.contains(where: { matchingIndices[$0] == index })
                let isSelected = isTermColumn && selectedTerm == index

                Button {
                    guard !isMatched else { return }
                    if isTermColumn {
                        selectedTerm = index
                        feedbackText = nil
                    } else {
                        chooseMeaning(index)
                    }
                } label: {
                    HStack(spacing: 4) {
                        if isMatched { Text("✓") }
                        else if isSelected { Text("●") }
                        Text(items[index])
                            .lineLimit(2)
                            .minimumScaleFactor(0.82)
                        Spacer(minLength: 0)
                    }
                    .font(.system(.caption, design: .default, weight: isSelected || isMatched ? .semibold : .regular))
                    .foregroundStyle(isMatched ? NeonTheme.teal : (isSelected ? NeonTheme.primaryBlue : NeonTheme.textPrimary))
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                    .background(matchRowColor(matched: isMatched, selected: isSelected))
                    .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(isMatched)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func matchRowColor(matched: Bool, selected: Bool) -> Color {
        if matched { return NeonTheme.tealSoft }
        if selected { return NeonTheme.primaryBlueSoft }
        return NeonTheme.surface
    }

    private func chooseMeaning(_ meaningIndex: Int) {
        guard let selectedTerm else { return }
        if matchingIndices[selectedTerm] == meaningIndex {
            matchedTerms.insert(selectedTerm)
            self.selectedTerm = nil
            feedbackText = "Đã ghép đúng. Chọn cặp tiếp theo."
        } else {
            feedbackText = "Chưa khớp. Hãy thử lại với nghĩa khác."
        }
    }

    private func checkMatches() {
        isChecked = true
        feedbackText = matchedTerms.count == terms.count
            ? "✓ Hoàn thành lượt ghép: tất cả các cặp đã khớp chính xác."
            : "Còn \(terms.count - matchedTerms.count) cặp chưa ghép. Tiếp tục đối chiếu nhé."
    }
}

struct VocabFillBlankView: View {
    let listTitle: String

    @Environment(\.dismiss) private var dismiss
    @FocusState private var inputFocused: Bool
    @State private var answer = ""
    @State private var isChecked = false

    private let correctAnswer = "renewal"
    private var isCorrect: Bool { answer.trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(correctAnswer) == .orderedSame }
    private var resultItems: [PracticeAnswerReview] {
        [PracticeAnswerReview(
            id: "vocab-fill-renewal",
            label: "Điền từ · Câu mẫu",
            userAnswer: answer,
            correctAnswer: correctAnswer,
            explanation: "Cụm từ thường gặp trong TOEIC: contract renewal request.",
            isCorrect: isCorrect
        )]
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Nghĩa: sự gia hạn hợp đồng")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.gold)

                    (
                        Text("“Please submit your ") +
                        Text("_______").foregroundColor(NeonTheme.primaryBlue) +
                        Text(" request two weeks before the expiration date.”")
                    )
                    .font(.system(.title3, design: .default, weight: .semibold))
                    .foregroundStyle(NeonTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                    Text("Gợi ý: r _ _ _ _ _ l")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundStyle(NeonTheme.textSecondary)
                }
                .padding(.horizontal, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Nhập từ tiếng Anh")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textSecondary)

                    TextField("Viết đáp án", text: $answer)
                        .font(.system(.body, design: .monospaced))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .focused($inputFocused)
                        .padding(.horizontal, 16)
                        .frame(minHeight: 56)
                        .background(NeonTheme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous)
                                .stroke(NeonTheme.border, lineWidth: 1)
                        }
                }

                if isChecked {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(isCorrect ? "✓ Chính xác: renewal (n)" : "Đáp án: renewal (n)")
                            .font(.system(.subheadline, design: .default, weight: .semibold))
                        Text("Cụm từ thường gặp trong TOEIC: contract renewal request.")
                            .font(.system(.caption, design: .default))
                    }
                    .foregroundStyle(isCorrect ? NeonTheme.teal : NeonTheme.coral)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(isCorrect ? NeonTheme.tealSoft : NeonTheme.coralSoft)
                    .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Điền từ")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Label("Ghép cặp", systemImage: "chevron.left") }
                    .font(.system(.subheadline, design: .default, weight: .medium))
                    .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.practiceResult(
                    title: "Điền từ vựng",
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
                Button {
                    inputFocused = false
                    isChecked = true
                } label: {
                    Text(isChecked ? "Đã kiểm tra" : "Kiểm tra")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Capsule().fill(NeonTheme.primaryBlue))
                }
                .buttonStyle(.plain)

                NavigationLink(value: LearnDestination.vocabListen(listTitle: listTitle)) {
                    HStack(spacing: 6) {
                        Text("Nghe từ")
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
            .overlay(alignment: .top) { Rectangle().fill(NeonTheme.border).frame(height: 1) }
        }
    }
}

struct VocabListenView: View {
    let listTitle: String

    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: Int? = nil
    @State private var isPlaying = false
    @State private var isChecked = false
    @State private var slowPlayback = false

    private let options = ["terminate", "negotiate", "obligate", "delegate"]
    private let correctIndex = 1

    private var resultItems: [PracticeAnswerReview] {
        let userAnswer = selectedOption.map { options[$0] } ?? ""
        return [PracticeAnswerReview(
            id: "vocab-listen-negotiate",
            label: "Nghe từ · Câu mẫu",
            userAnswer: userAnswer,
            correctAnswer: options[correctIndex],
            explanation: "Nghĩa: đàm phán, thương lượng các điều khoản hợp đồng.",
            isCorrect: selectedOption == correctIndex
        )]
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Nghe phát âm và chọn từ đúng")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.gold)
                        .padding(.horizontal, 4)

                    HStack(spacing: 12) {
                        Button { isPlaying.toggle() } label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 48, height: 48)
                                .background(Circle().fill(NeonTheme.primaryBlue))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Phát âm mẫu")

                        VStack(alignment: .leading, spacing: 3) {
                            Text(isPlaying ? "Đang phát mẫu" : "Phát âm chuẩn TOEIC")
                                .font(.system(.subheadline, design: .default, weight: .semibold))
                                .foregroundStyle(NeonTheme.textPrimary)
                            Text("Giọng Anh–Mỹ")
                                .font(.system(.caption, design: .default))
                                .foregroundStyle(NeonTheme.textSecondary)
                        }
                        Spacer(minLength: 4)

                        Button(slowPlayback ? "0.8x" : "1.0x") {
                            slowPlayback.toggle()
                        }
                        .font(.system(.caption, design: .monospaced, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .padding(.horizontal, 14)
                        .frame(minHeight: 40)
                        .background(Capsule().fill(NeonTheme.subtleSurface))
                        .buttonStyle(.plain)
                    }
                    .padding(16)
                    .background(NeonTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
                }

                VStack(spacing: 10) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        listenOption(option, index: index)
                    }
                }

                if isChecked {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(selectedOption == correctIndex ? "✓ Chính xác: negotiate /nɪˈɡoʊ.ʃi.eɪt/" : "Đáp án: negotiate /nɪˈɡoʊ.ʃi.eɪt/")
                            .font(.system(.subheadline, design: .default, weight: .semibold))
                        Text("Nghĩa: đàm phán, thương lượng các điều khoản hợp đồng.")
                            .font(.system(.caption, design: .default))
                    }
                    .foregroundStyle(selectedOption == correctIndex ? NeonTheme.teal : NeonTheme.coral)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(selectedOption == correctIndex ? NeonTheme.tealSoft : NeonTheme.coralSoft)
                    .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Nghe từ")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: { Label("Điền từ", systemImage: "chevron.left") }
                    .font(.system(.subheadline, design: .default, weight: .medium))
                    .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.practiceResult(
                    title: "Nghe từ vựng",
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
                Button { isChecked = true } label: {
                    Text(isChecked ? "Đã kiểm tra" : "Kiểm tra")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Capsule().fill(NeonTheme.primaryBlue))
                }
                .buttonStyle(.plain)

                NavigationLink(value: LearnDestination.practiceResult(
                    title: "Nghe từ vựng",
                    subtitle: listTitle,
                    items: resultItems
                )) {
                    HStack(spacing: 6) {
                        Text("Kết quả")
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
            .overlay(alignment: .top) { Rectangle().fill(NeonTheme.border).frame(height: 1) }
        }
    }

    private func listenOption(_ option: String, index: Int) -> some View {
        let isSelected = selectedOption == index
        let isCorrect = isChecked && index == correctIndex
        let isWrong = isChecked && isSelected && index != correctIndex
        let letter = ["A", "B", "C", "D"][min(index, 3)]
        return Button {
            guard !isChecked else { return }
            selectedOption = index
        } label: {
            HStack {
                Text("\(letter). \(option)")
                    .font(.system(.subheadline, design: .default, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(NeonTheme.textPrimary)
                Spacer()
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(NeonTheme.teal)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(NeonTheme.coral)
                } else {
                    Text(isSelected ? "●" : "○")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(isSelected ? NeonTheme.primaryBlue : NeonTheme.textMuted)
                }
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(isCorrect ? NeonTheme.tealSoft : (isWrong ? NeonTheme.coralSoft : (isSelected ? NeonTheme.primaryBlueSoft : NeonTheme.surface)))
            .clipShape(RoundedRectangle(cornerRadius: NeonTheme.rowCornerRadius, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
