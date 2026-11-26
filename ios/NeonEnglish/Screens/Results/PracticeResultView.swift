import SwiftUI

struct PracticeResultView: View {
    let title: String
    let subtitle: String
    let items: [PracticeAnswerReview]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("✓ Đã hoàn thành lượt học")
                            .font(.system(.caption, design: .default, weight: .semibold))
                            .foregroundStyle(NeonTheme.teal)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(NeonTheme.tealSoft))
                        Spacer()
                        Text("Nội dung mẫu")
                            .font(.system(.caption2, design: .default))
                            .foregroundStyle(NeonTheme.textSecondary)
                    }

                    Text(title)
                        .font(.system(.title3, design: .default, weight: .bold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .padding(.top, 2)

                    Text(subtitle)
                        .font(.system(.subheadline, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(NeonTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Giải thích chi tiết")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .padding(.horizontal, 4)

                    VStack(spacing: 0) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            reviewRow(item)

                            if index < items.count - 1 {
                                Rectangle().fill(NeonTheme.border).frame(height: 1).padding(.horizontal, 16)
                            }
                        }
                    }
                    .background(NeonTheme.surface)
                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .navigationTitle("Kết quả & Chữa lỗi")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Xong") { dismiss() }
                    .font(.system(.subheadline, design: .default, weight: .medium))
                    .tint(NeonTheme.primaryBlue)
            }
        }
    }

    private func reviewRow(_ item: PracticeAnswerReview) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(item.label)
                    .font(.system(.caption, design: .default, weight: .semibold))
                    .foregroundStyle(NeonTheme.textPrimary)
                Spacer(minLength: 4)
                Text(item.isCorrect ? "✓ Đúng" : "✕ Cần ôn lại")
                    .font(.system(.caption2, design: .default, weight: .semibold))
                    .foregroundStyle(item.isCorrect ? NeonTheme.teal : NeonTheme.coral)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(item.isCorrect ? NeonTheme.tealSoft : NeonTheme.coralSoft))
            }

            if item.isCorrect {
                answerLine(label: "Đáp án", value: item.correctAnswer, color: NeonTheme.teal)
            } else {
                answerLine(label: "Bạn gõ", value: item.userAnswer.isEmpty ? "—" : item.userAnswer, color: NeonTheme.coral)
                answerLine(label: "Đáp án", value: item.correctAnswer, color: NeonTheme.teal)
            }

            if !item.explanation.isEmpty {
                Text(item.explanation)
                    .font(.system(.caption, design: .default))
                    .foregroundStyle(NeonTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func answerLine(label: String, value: String, color: Color) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("\(label):")
                .foregroundStyle(NeonTheme.textSecondary)
            Text(value)
                .font(.system(.caption, design: .monospaced, weight: .semibold))
                .foregroundStyle(color)
                .fixedSize(horizontal: false, vertical: true)
        }
        .font(.system(.caption, design: .default))
    }
}
