import SwiftUI

struct FlashcardView: View {
    let listTitle: String

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var isPlaying = false

    private let cards = MockData.sampleVocabWords

    private var currentCard: VocabWordItem {
        cards[min(currentIndex, cards.count - 1)]
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Image("ContractNegotiation")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .accessibilityLabel("Hai đồng nghiệp đang xem hợp đồng")

                VStack(alignment: .leading, spacing: 14) {
                    Text(currentCard.partOfSpeech == "verb" ? "Động từ (v)" : currentCard.partOfSpeech)
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.gold)

                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentCard.term)
                                .font(.system(size: 30, weight: .bold, design: .default))
                                .foregroundStyle(NeonTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(currentCard.ipa)
                                .font(.system(.subheadline, design: .monospaced))
                                .foregroundStyle(NeonTheme.textSecondary)
                        }

                        Spacer(minLength: 8)

                        Button {
                            isPlaying.toggle()
                        } label: {
                            Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.wave.2")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(NeonTheme.primaryBlue)
                                .frame(width: 48, height: 48)
                                .background(Circle().fill(NeonTheme.primaryBlueSoft))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Nghe phát âm mẫu")
                    }

                    Rectangle()
                        .fill(NeonTheme.border)
                        .frame(height: 1)
                        .padding(.vertical, 2)

                    if isFlipped {
                        detailBlock(title: "Cụm từ đi kèm", text: currentCard.collocation, accent: NeonTheme.primaryBlue)
                    } else {
                        detailBlock(title: "Nghĩa tiếng Việt", text: currentCard.meaningVi, accent: NeonTheme.textPrimary, emphasized: true)
                        detailBlock(title: "Định nghĩa tiếng Anh", text: currentCard.definitionEn, accent: NeonTheme.textPrimary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ví dụ")
                                .font(.system(.caption, design: .default, weight: .medium))
                                .foregroundStyle(NeonTheme.textSecondary)
                            Text("“\(currentCard.exampleEn)”")
                                .font(.system(.subheadline, design: .default, weight: .medium).italic())
                                .foregroundStyle(NeonTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(NeonTheme.surface)
            }
            .clipShape(RoundedRectangle(cornerRadius: NeonTheme.cardCornerRadius, style: .continuous))
            .padding(.horizontal, NeonTheme.horizontalPadding)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .neonScreenBackground()
        .navigationTitle("Flashcard")
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
                        .labelStyle(.titleAndIcon)
                }
                .font(.system(.subheadline, design: .default, weight: .medium))
                .tint(NeonTheme.primaryBlue)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: LearnDestination.vocabQuiz(listTitle: listTitle)) {
                    Text("Bài tập")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            HStack(spacing: 12) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFlipped.toggle()
                    }
                } label: {
                    Text(isFlipped ? "Xem nghĩa" : "Lật thẻ")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textPrimary)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Capsule().fill(NeonTheme.subtleSurface))
                }
                .buttonStyle(.plain)

                Button(action: advanceCard) {
                    Text("Thẻ tiếp theo")
                        .font(.system(.subheadline, design: .default, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(Capsule().fill(NeonTheme.primaryBlue))
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

    private func detailBlock(title: String, text: String, accent: Color, emphasized: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(.caption, design: .default, weight: .medium))
                .foregroundStyle(NeonTheme.textSecondary)
            Text(text)
                .font(.system(.subheadline, design: .default, weight: emphasized ? .semibold : .regular))
                .foregroundStyle(accent)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func advanceCard() {
        withAnimation(.easeInOut(duration: 0.2)) {
            currentIndex = (currentIndex + 1) % cards.count
            isFlipped = false
            isPlaying = false
        }
    }
}
