import SwiftUI

struct TodayView: View {
    private let tasks = MockData.todayTasks

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                topBrandRow

                Text("Hôm nay")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(NeonTheme.textPrimary)

                nextStepCard
                planSection
                weeklyRhythmSection
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 4)
            .padding(.bottom, 20)
        }
        .neonScreenBackground()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var topBrandRow: some View {
        HStack(spacing: 8) {
            NeonBrandSymbol(size: 20)
            Text("Neon English · Thứ Năm")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(NeonTheme.textPrimary)
            Spacer(minLength: 8)
            Text("Nội dung mẫu")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(NeonTheme.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(NeonTheme.subtleSurface))
        }
        .frame(minHeight: 28)
        .accessibilityElement(children: .combine)
    }

    private var nextStepCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Bước tiếp theo")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(NeonTheme.teal)
                Spacer()
                Text("Nghe chép · HARD")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(NeonTheme.textSecondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Bài 08: Đặt phòng hội nghị")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(NeonTheme.textPrimary)
                Text("Luyện nghe điền từ khóa và xác nhận thiết bị văn phòng")
                    .font(.system(size: 14))
                    .foregroundStyle(NeonTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let lesson = MockData.dictationLessons.first {
                NavigationLink(value: LearnDestination.dictationSession(lesson: lesson, initialMode: .hard)) {
                    Label("Tiếp tục học", systemImage: "play.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .foregroundStyle(.white)
                        .background(Capsule().fill(NeonTheme.primaryBlue))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous)
                .fill(NeonTheme.surface)
        )
    }

    private var planSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("Kế hoạch hôm nay")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(NeonTheme.textPrimary)
                Spacer()
                Text("Mục tiêu 1,5–2 giờ")
                    .font(.system(size: 12))
                    .foregroundStyle(NeonTheme.textSecondary)
            }
            .padding(.bottom, 8)

            Rectangle()
                .fill(NeonTheme.border)
                .frame(height: 1)

            ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                NavigationLink(value: task.destination) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(task.accent.color)
                            .frame(width: 9, height: 9)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(task.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(NeonTheme.textPrimary)
                                .multilineTextAlignment(.leading)
                            Text(task.subtitle)
                                .font(.system(size: 13))
                                .foregroundStyle(NeonTheme.textSecondary)
                                .multilineTextAlignment(.leading)
                        }

                        Spacer(minLength: 4)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(NeonTheme.textMuted)
                    }
                    .frame(minHeight: 70)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if index < tasks.count - 1 {
                    Rectangle()
                        .fill(NeonTheme.border.opacity(0.8))
                        .frame(height: 1)
                }
            }
        }
    }

    private var weeklyRhythmSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Nhịp học 6 ngày")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(NeonTheme.textPrimary)
                Spacer()
                Text("Chủ nhật nghỉ / ôn nhẹ")
                    .font(.system(size: 12))
                    .foregroundStyle(NeonTheme.textSecondary)
            }

            HStack(spacing: 2) {
                ForEach(MockData.weeklyDays) { day in
                    VStack(spacing: 4) {
                        Text(day.shortLabel)
                            .font(.system(size: 12, weight: day.isToday ? .semibold : .regular))
                        Text(day.isToday ? "Nay" : day.id == "sun" ? "Nhẹ" : day.isCompleted ? "✓" : "Học")
                            .font(.system(size: 12, weight: day.isToday || day.isCompleted ? .semibold : .regular))
                    }
                    .foregroundStyle(day.isToday ? NeonTheme.primaryBlue : day.id == "sun" ? NeonTheme.gold : day.isCompleted ? NeonTheme.teal : NeonTheme.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background {
                        if day.isToday {
                            Capsule().fill(NeonTheme.primaryBlueSoft)
                        } else if day.id == "sun" {
                            Capsule().fill(NeonTheme.goldSoft.opacity(0.75))
                        }
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .padding(.top, 2)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(NeonTheme.border.opacity(0.8))
                .frame(height: 1)
                .offset(y: -8)
        }
    }
}
