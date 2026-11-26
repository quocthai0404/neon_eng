import SwiftUI

struct StudyProgressView: View {
    private let areas: [(title: String, detail: String, status: String, accent: NeonAccent)] = [
        ("Từ vựng TOEIC", "Theo dõi theo từng danh sách và lượt ôn", "Sẵn sàng", .gold),
        ("Ngữ pháp trọng tâm", "Ghi nhận chủ điểm đã đọc và thực hành", "Sẵn sàng", .blue),
        ("Nghe chép chính tả", "Lưu lại câu nghe sai để ôn tập", "Sẵn sàng", .teal),
        ("Luyện nghe & Luyện đọc", "Part 1–4 và Part 5–7 theo từng buổi", "Sẵn sàng", .coral)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Mục tiêu TOEIC 650+")
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                    Text("Tiến độ")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundStyle(NeonTheme.textPrimary)
                }

                VStack(alignment: .leading, spacing: 7) {
                    Text("Lộ trình cá nhân")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.teal)
                    Text("6 ngày học / tuần · 1,5–2 giờ / ngày")
                        .font(.system(.title3, design: .default, weight: .bold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Bản xem trước giao diện · Chưa có dữ liệu học được lưu.")
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(NeonTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Các mảng học tập")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .padding(.horizontal, 4)

                    VStack(spacing: 0) {
                        ForEach(Array(areas.enumerated()), id: \.element.title) { index, area in
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(area.title)
                                        .font(.system(.subheadline, design: .default, weight: .semibold))
                                        .foregroundStyle(NeonTheme.textPrimary)
                                    Text(area.detail)
                                        .font(.system(.caption, design: .default))
                                        .foregroundStyle(NeonTheme.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer(minLength: 4)
                                Text(area.status)
                                    .font(.system(.caption2, design: .default, weight: .semibold))
                                    .foregroundStyle(area.accent.color)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Capsule().fill(area.accent.softColor))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)

                            if index < areas.count - 1 {
                                Rectangle().fill(NeonTheme.border).frame(height: 1).padding(.leading, 8)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .toolbar(.hidden, for: .navigationBar)
    }
}
