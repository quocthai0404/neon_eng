import SwiftUI

struct ReviewView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Hàng đợi ôn tập")
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                    Spacer()
                    Text("Nội dung mẫu")
                        .font(.system(.caption2, design: .default, weight: .medium))
                        .foregroundStyle(NeonTheme.textSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(NeonTheme.subtleSurface))
                }

                Text("Ôn tập")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundStyle(NeonTheme.textPrimary)

                prioritySection
                reviewGroups
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var prioritySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Ưu tiên ôn lại")
                    .font(.system(.caption, design: .default, weight: .semibold))
                    .foregroundStyle(NeonTheme.coral)
                Text("Tổng hợp từ vựng đến hạn và các câu sai gần đây để củng cố trí nhớ.")
                    .font(.system(.subheadline, design: .default))
                    .foregroundStyle(NeonTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            NavigationLink(value: LearnDestination.vocabQuiz(listTitle: "Ôn tập từ vựng")) {
                Text("Bắt đầu ôn tập")
                    .font(.system(.subheadline, design: .default, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Capsule().fill(NeonTheme.primaryBlue))
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NeonTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
    }

    private var reviewGroups: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Theo nhóm nội dung")
                .font(.system(.subheadline, design: .default, weight: .semibold))
                .foregroundStyle(NeonTheme.textPrimary)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                reviewRow(
                    title: "Từ vựng cần nhắc lại",
                    subtitle: "stipulate, abide by, renewal",
                    destination: .flashcards(listTitle: "Ôn tập từ vựng")
                )
                divider
                reviewRow(
                    title: "Câu nghe chép sai gần đây",
                    subtitle: "Âm cuối /d/ và phân từ bị động",
                    destination: .dictationSession(lesson: MockData.dictationLessons[0], initialMode: .hard)
                )
                divider
                reviewRow(
                    title: "Chủ điểm ngữ pháp hay nhầm",
                    subtitle: "Despite / In spite of vs Although",
                    destination: .grammarPractice(MockData.grammarTopics[0])
                )
            }
        }
    }

    private var divider: some View {
        Rectangle().fill(NeonTheme.border).frame(height: 1).padding(.leading, 8)
    }

    private func reviewRow(title: String, subtitle: String, destination: LearnDestination) -> some View {
        NavigationLink(value: destination) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)
                    Text(subtitle)
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                }
                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(NeonTheme.textSecondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
