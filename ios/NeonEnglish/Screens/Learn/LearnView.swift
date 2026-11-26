import SwiftUI

struct LearnView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Kho học liệu TOEIC 650+")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(NeonTheme.textSecondary)
                    Text("Học")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(NeonTheme.textPrimary)
                }

                resourceSection(
                    title: "Kiến thức nền tảng",
                    rows: [
                        ResourceRow(
                            title: "Từ vựng TOEIC",
                            subtitle: "Flashcard, trắc nghiệm, ghép cặp, điền từ & nghe từ",
                            destination: .vocabCatalog
                        ),
                        ResourceRow(
                            title: "Ngữ pháp trọng tâm",
                            subtitle: "Lý thuyết, bảng so sánh & câu hỏi thực hành",
                            destination: .grammarCatalog
                        )
                    ]
                )

                resourceSection(
                    title: "Kỹ năng & Nghe chép",
                    rows: [
                        ResourceRow(
                            title: "Nghe chép chính tả",
                            subtitle: "Chế độ NORMAL, HARD và SENTENCE",
                            destination: .dictationHub
                        ),
                        ResourceRow(
                            title: "Luyện nghe (Part 1–4)",
                            subtitle: "Mô tả tranh, hỏi đáp, hội thoại & bài nói",
                            destination: .toeicPartPractice(MockData.toeicParts[0])
                        ),
                        ResourceRow(
                            title: "Luyện đọc (Part 5–7)",
                            subtitle: "Điền câu, đoạn văn & đọc hiểu",
                            destination: .toeicPartPractice(MockData.toeicParts[4])
                        )
                    ]
                )
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 10)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Học")
        .toolbar(.hidden, for: .navigationBar)
    }

    private func resourceSection(title: String, rows: [ResourceRow]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(NeonTheme.textPrimary)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.title) { index, row in
                    NavigationLink(value: row.destination) {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(row.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(NeonTheme.textPrimary)
                                Text(row.subtitle)
                                    .font(.system(size: 13))
                                    .foregroundStyle(NeonTheme.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Spacer(minLength: 4)

                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(NeonTheme.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .frame(minHeight: 86)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if index < rows.count - 1 {
                        Rectangle()
                            .fill(NeonTheme.border)
                            .frame(height: 1)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous)
                    .fill(NeonTheme.surface)
            )
            .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
        }
    }
}

private struct ResourceRow {
    let title: String
    let subtitle: String
    let destination: LearnDestination
}
