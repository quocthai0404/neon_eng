import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: AppTab = .today

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TodayView()
                    .neonNavigationDestinations()
            }
            .tabItem {
                Label("Hôm nay", systemImage: "calendar")
            }
            .tag(AppTab.today)

            NavigationStack {
                LearnView()
                    .neonNavigationDestinations()
            }
            .tabItem {
                Label("Học", systemImage: "square.grid.2x2")
            }
            .tag(AppTab.learn)

            NavigationStack {
                ReviewView()
                    .neonNavigationDestinations()
            }
            .tabItem {
                Label("Ôn tập", systemImage: "arrow.counterclockwise")
            }
            .tag(AppTab.review)

            NavigationStack {
                StudyProgressView()
                    .neonNavigationDestinations()
            }
            .tabItem {
                Label("Tiến độ", systemImage: "chart.bar")
            }
            .tag(AppTab.progress)
        }
        .tint(NeonTheme.primaryBlue)
        .preferredColorScheme(.light)
    }
}

private extension View {
    func neonNavigationDestinations() -> some View {
        navigationDestination(for: LearnDestination.self) { destination in
            switch destination {
            case .vocabCatalog:
                VocabCatalogView()
            case .vocabDetail(let list):
                VocabListDetailView(list: list)
            case .flashcards(let listTitle):
                FlashcardView(listTitle: listTitle)
            case .vocabQuiz(let listTitle):
                VocabQuizView(listTitle: listTitle)
            case .vocabMatching(let listTitle):
                VocabMatchingView(listTitle: listTitle)
            case .vocabFillBlank(let listTitle):
                VocabFillBlankView(listTitle: listTitle)
            case .vocabListen(let listTitle):
                VocabListenView(listTitle: listTitle)
            case .grammarCatalog:
                GrammarCatalogView()
            case .grammarDetail(let topic):
                GrammarTopicDetailView(topic: topic)
            case .grammarPractice(let topic):
                GrammarPracticeView(topic: topic)
            case .practiceResult(let title, let subtitle, let items):
                PracticeResultView(title: title, subtitle: subtitle, items: items)
            case .dictationHub:
                DictationHubView()
            case .dictationSession(let lesson, let initialMode):
                DictationSessionView(lesson: lesson, initialMode: initialMode)
            case .listeningReadingHub:
                ListeningReadingHubView()
            case .toeicPartPractice(let part):
                ToeicPartPracticeView(part: part)
            }
        }
    }
}
