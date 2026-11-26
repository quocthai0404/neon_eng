import SwiftUI

struct VocabCatalogView: View {
    @State private var searchText = ""

    private var lists: [VocabListItem] {
        guard !searchText.isEmpty else { return MockData.vocabLists }
        return MockData.vocabLists.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.topicVi.localizedCaseInsensitiveContains(searchText) ||
            $0.code.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(NeonTheme.textSecondary)

                    TextField("Tìm danh sách từ vựng...", text: $searchText)
                        .font(.system(.subheadline, design: .default))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(NeonTheme.textMuted)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .frame(minHeight: 44)
                .background(Capsule().fill(NeonTheme.subtleSurface))
                .padding(.bottom, 2)

                VStack(spacing: 0) {
                    ForEach(Array(lists.enumerated()), id: \.element.id) { index, list in
                        NavigationLink(value: LearnDestination.vocabDetail(list)) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(list.topicVi)
                                        .font(.system(.subheadline, design: .default, weight: .semibold))
                                        .foregroundStyle(NeonTheme.textPrimary)
                                        .multilineTextAlignment(.leading)

                                    Text(listSubtitle(for: list))
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
                            .frame(maxWidth: .infinity, minHeight: 68, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if index < lists.count - 1 {
                            Rectangle()
                                .fill(NeonTheme.border)
                                .frame(height: 1)
                                .padding(.leading, 20)
                        }
                    }
                }
                .background(NeonTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .navigationTitle("Danh sách Từ vựng")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }

    private func listSubtitle(for list: VocabListItem) -> String {
        if list.id == "list-1" {
            return "Flashcard · Trắc nghiệm · Ghép cặp · Điền từ · Nghe từ"
        }
        return "\(list.code) · Có âm thanh phát âm"
    }
}

struct VocabListDetailView: View {
    let list: VocabListItem

    private var sampleWords: [VocabWordItem] {
        let preferredTerms = ["stipulate", "abide by", "renewal"]
        return preferredTerms.compactMap { term in
            MockData.sampleVocabWords.first { $0.term == term }
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                topicHeader

                VStack(alignment: .leading, spacing: 8) {
                    Text("Từ vựng tiêu biểu (Mẫu)")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)

                    VStack(spacing: 0) {
                        ForEach(Array(sampleWords.enumerated()), id: \.element.id) { index, word in
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                                        Text(word.term)
                                            .font(.system(.subheadline, design: .default, weight: .bold))
                                            .foregroundStyle(NeonTheme.textPrimary)
                                        Text(word.ipa)
                                            .font(.system(.caption, design: .monospaced))
                                            .foregroundStyle(NeonTheme.textSecondary)
                                    }
                                    Text(word.meaningVi)
                                        .font(.system(.caption, design: .default))
                                        .foregroundStyle(NeonTheme.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                Spacer(minLength: 4)

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(NeonTheme.textSecondary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Rectangle()
                                .fill(NeonTheme.border)
                                .frame(height: 1)
                        }
                    }
                }
            }
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 28)
        }
        .neonScreenBackground()
        .navigationTitle("Chi tiết chủ đề")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }

    private var topicHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Chủ đề từ vựng TOEIC")
                .font(.system(.caption, design: .default, weight: .semibold))
                .foregroundStyle(NeonTheme.gold)

            Text(list.topicVi)
                .font(.system(.title2, design: .default, weight: .bold))
                .foregroundStyle(NeonTheme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Gồm hình ảnh minh họa, phát âm chuẩn và đầy đủ 4 dạng bài tập.")
                .font(.system(.subheadline, design: .default))
                .foregroundStyle(NeonTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            NavigationLink(value: LearnDestination.flashcards(listTitle: "\(list.code) · \(list.topicVi)")) {
                Text("Mở Flashcard")
                    .font(.system(.subheadline, design: .default, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Capsule().fill(NeonTheme.primaryBlue))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)

            NavigationLink(value: LearnDestination.vocabQuiz(listTitle: "\(list.code) · \(list.topicVi)")) {
                Text("Làm Bài tập")
                    .font(.system(.subheadline, design: .default, weight: .semibold))
                    .foregroundStyle(NeonTheme.textPrimary)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(Capsule().fill(NeonTheme.subtleSurface))
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NeonTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
    }
}
