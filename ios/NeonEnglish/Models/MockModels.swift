import SwiftUI

// MARK: - Navigation Routes

enum AppTab: Hashable {
    case today
    case learn
    case review
    case progress
}

enum LearnDestination: Hashable {
    case vocabCatalog
    case vocabDetail(VocabListItem)
    case flashcards(listTitle: String)
    case vocabQuiz(listTitle: String)
    case vocabMatching(listTitle: String)
    case vocabFillBlank(listTitle: String)
    case vocabListen(listTitle: String)
    case grammarCatalog
    case grammarDetail(GrammarTopicItem)
    case grammarPractice(GrammarTopicItem)
    case practiceResult(title: String, subtitle: String, items: [PracticeAnswerReview])
    case dictationHub
    case dictationSession(lesson: DictationLessonItem, initialMode: DictationMode)
    case listeningReadingHub
    case toeicPartPractice(ToeicPartItem)
}

// MARK: - Today & Planning Models

struct TodayTaskItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let durationLabel: String
    let tag: String
    let icon: String
    let accent: NeonAccent
    let destination: LearnDestination
    var isCompleted: Bool
}

struct WeeklyStudyDay: Identifiable, Hashable {
    let id: String
    let shortLabel: String
    let minutes: Int
    let isToday: Bool
    let isCompleted: Bool
}

// MARK: - Vocabulary Models

struct VocabListItem: Identifiable, Hashable {
    let id: String
    let code: String
    let title: String
    let topicVi: String
    let totalWords: Int
    let masteredWords: Int
    let levelBadge: String
    let accent: NeonAccent

    var progress: Double {
        guard totalWords > 0 else { return 0 }
        return Double(masteredWords) / Double(totalWords)
    }
}

struct VocabWordItem: Identifiable, Hashable {
    let id: String
    let term: String
    let ipa: String
    let partOfSpeech: String
    let meaningVi: String
    let definitionEn: String
    let exampleEn: String
    let exampleVi: String
    let collocation: String
    let status: VocabWordStatus
}

enum VocabWordStatus: String, CaseIterable, Hashable {
    case mastered = "Đã thuộc"
    case learning = "Đang ôn"
    case tricky = "Dễ nhầm"

    var accent: NeonAccent {
        switch self {
        case .mastered: return .green
        case .learning: return .blue
        case .tricky: return .coral
        }
    }
}

struct VocabQuizQuestion: Identifiable, Hashable {
    let id: String
    let promptType: String
    let prompt: String
    let ipaHint: String?
    let contextSentence: String?
    let options: [String]
    let correctIndex: Int
    let explanationVi: String
}

struct PracticeAnswerReview: Identifiable, Hashable {
    let id: String
    let label: String
    let userAnswer: String
    let correctAnswer: String
    let explanation: String
    let isCorrect: Bool
}

// MARK: - Grammar Models

struct GrammarRuleBlock: Identifiable, Hashable {
    let id: String
    let heading: String
    let formula: String
    let noteVi: String
    let exampleEn: String
    let exampleVi: String
}

struct GrammarPracticeItem: Identifiable, Hashable {
    let id: String
    let question: String
    let options: [String]
    let correctIndex: Int
    let tipVi: String
}

struct GrammarTopicItem: Identifiable, Hashable {
    let id: String
    let indexLabel: String
    let title: String
    let subtitle: String
    let level: String
    let masteryPercent: Int
    let lessonMinutes: Int
    let accent: NeonAccent
    let rules: [GrammarRuleBlock]
    let practiceItems: [GrammarPracticeItem]
}

// MARK: - Dictation Models

enum DictationMode: String, CaseIterable, Identifiable, Hashable {
    case normal = "NORMAL"
    case hard = "HARD"
    case sentence = "SENTENCE"

    var id: String { rawValue }

    var subtitleVi: String {
        switch self {
        case .normal: return "Điền từ khóa chính"
        case .hard: return "Ẩn sâu nhiều từ"
        case .sentence: return "Chép trọn câu"
        }
    }

    var accent: NeonAccent {
        switch self {
        case .normal: return .teal
        case .hard: return .coral
        case .sentence: return .blue
        }
    }
}

struct DictationLine: Identifiable, Hashable {
    let id: String
    let speaker: String
    let fullSentence: String
    let vietnameseMeaning: String
    let normalMaskedTokens: [String]
    let normalAnswers: [String]
    let hardMaskedTokens: [String]
    let hardAnswers: [String]
    let wordBank: [String]
    let durationLabel: String
}

struct DictationLessonItem: Identifiable, Hashable {
    let id: String
    let partTag: String
    let title: String
    let subtitle: String
    let sentenceCount: Int
    let durationLabel: String
    let difficulty: String
    let accent: NeonAccent
    let lines: [DictationLine]
}

// MARK: - Listening & Reading Models

enum ToeicSkillGroup: String, CaseIterable, Identifiable, Hashable {
    case all = "Tất cả"
    case listening = "Listening"
    case reading = "Reading"

    var id: String { rawValue }
}

struct ToeicPracticeQuestion: Identifiable, Hashable {
    let id: String
    let numberLabel: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanationVi: String
}

struct ToeicPartItem: Identifiable, Hashable {
    let id: String
    let partNumber: Int
    let skillGroup: ToeicSkillGroup
    let title: String
    let vietnameseName: String
    let descriptionVi: String
    let questionFormat: String
    let progress: Double
    let accent: NeonAccent
    let audioTitle: String?
    let audioDuration: String?
    let visualCaption: String?
    let passageTitle: String?
    let passageBody: String?
    let transcriptEn: String?
    let transcriptVi: String?
    let questions: [ToeicPracticeQuestion]
}

// MARK: - Review & Progress Models

struct ReviewDeckItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let dueCount: Int
    let estimatedMinutes: Int
    let icon: String
    let accent: NeonAccent
    let destination: LearnDestination
}

struct WeakAreaItem: Identifiable, Hashable {
    let id: String
    let category: String
    let title: String
    let detail: String
    let accent: NeonAccent
    let destination: LearnDestination
}

struct SkillProgressItem: Identifiable, Hashable {
    let id: String
    let name: String
    let completedLabel: String
    let percent: Double
    let icon: String
    let accent: NeonAccent
}

struct MilestoneBadge: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let accent: NeonAccent
}

// MARK: - Hardcoded Presentation Sample Data

enum MockData {
    static let vocabLists: [VocabListItem] = [
        VocabListItem(
            id: "list-1",
            code: "List 01",
            title: "Contracts & Agreements",
            topicVi: "Hợp đồng & Đàm phán",
            totalWords: 55,
            masteredWords: 42,
            levelBadge: "Cốt lõi 600+",
            accent: .blue
        ),
        VocabListItem(
            id: "list-2",
            code: "List 02",
            title: "Marketing & Promotions",
            topicVi: "Tiếp thị & Chiến dịch",
            totalWords: 55,
            masteredWords: 31,
            levelBadge: "Hay gặp Part 7",
            accent: .teal
        ),
        VocabListItem(
            id: "list-3",
            code: "List 03",
            title: "Office & Operations",
            topicVi: "Vận hành văn phòng",
            totalWords: 55,
            masteredWords: 20,
            levelBadge: "Nghe nhanh",
            accent: .coral
        ),
        VocabListItem(
            id: "list-4",
            code: "List 04",
            title: "Finance & Budgeting",
            topicVi: "Tài chính & Ngân sách",
            totalWords: 55,
            masteredWords: 12,
            levelBadge: "Mục tiêu 750+",
            accent: .gold
        )
    ]

    static let sampleVocabWords: [VocabWordItem] = [
        VocabWordItem(
            id: "w-4",
            term: "stipulate",
            ipa: "/ˈstɪp.jə.leɪt/",
            partOfSpeech: "verb",
            meaningVi: "quy định rõ, đặt điều kiện",
            definitionEn: "To state clearly and firmly as a requirement in an agreement or contract.",
            exampleEn: "The contract stipulates that all invoices must be paid within 30 days.",
            exampleVi: "Hợp đồng quy định rằng mọi hóa đơn phải được thanh toán trong vòng 30 ngày.",
            collocation: "stipulate that + clause",
            status: .learning
        ),
        VocabWordItem(
            id: "w-1",
            term: "abide by",
            ipa: "/əˈbaɪd baɪ/",
            partOfSpeech: "phrasal verb",
            meaningVi: "tuân thủ, chấp hành (quy định, hợp đồng)",
            definitionEn: "To obey a rule, agreement, or instruction.",
            exampleEn: "All vendors must abide by the revised safety regulations.",
            exampleVi: "Tất cả nhà cung cấp phải tuân thủ các quy định an toàn đã sửa đổi.",
            collocation: "abide by the terms / abide by the policy",
            status: .mastered
        ),
        VocabWordItem(
            id: "w-2",
            term: "obligate",
            ipa: "/ˈɑːb.lə.ɡeɪt/",
            partOfSpeech: "verb",
            meaningVi: "bắt buộc, ràng buộc theo nghĩa vụ",
            definitionEn: "To require someone to do something as part of a duty.",
            exampleEn: "The clause obligates the contractor to finish repairs by Friday.",
            exampleVi: "Điều khoản ràng buộc nhà thầu hoàn tất việc sửa chữa trước thứ Sáu.",
            collocation: "be obligated to + V",
            status: .tricky
        ),
        VocabWordItem(
            id: "w-3",
            term: "provision",
            ipa: "/prəˈvɪʒ.ən/",
            partOfSpeech: "noun",
            meaningVi: "điều khoản; sự cung cấp",
            definitionEn: "A condition in an agreement, or the act of supplying something.",
            exampleEn: "We added a provision covering delayed overseas shipments.",
            exampleVi: "Chúng tôi đã bổ sung một điều khoản cho các lô hàng quốc tế giao trễ.",
            collocation: "contract provision / make provision for",
            status: .learning
        ),
        VocabWordItem(
            id: "w-5",
            term: "assurance",
            ipa: "/əˈʃʊr.əns/",
            partOfSpeech: "noun",
            meaningVi: "sự cam đoan, lời bảo đảm",
            definitionEn: "A promise or statement that gives confidence about something.",
            exampleEn: "The director gave his assurance that funding would remain stable.",
            exampleVi: "Giám đốc đã đưa ra lời bảo đảm rằng nguồn vốn sẽ giữ ổn định.",
            collocation: "quality assurance / give assurance",
            status: .mastered
        ),
        VocabWordItem(
            id: "w-6",
            term: "consensus",
            ipa: "/kənˈsen.səs/",
            partOfSpeech: "noun",
            meaningVi: "sự đồng thuận, nhất trí chung",
            definitionEn: "A general agreement reached by a group of people.",
            exampleEn: "After two hours of discussion, the board reached a consensus.",
            exampleVi: "Sau hai giờ thảo luận, hội đồng đã đạt được sự đồng thuận.",
            collocation: "reach a consensus / broad consensus",
            status: .learning
        ),
        VocabWordItem(
            id: "w-7",
            term: "renewal",
            ipa: "/rɪˈnuː.əl/",
            partOfSpeech: "noun",
            meaningVi: "sự gia hạn hợp đồng",
            definitionEn: "The act of extending an agreement or making it valid again.",
            exampleEn: "Please submit your renewal request two weeks before the expiration date.",
            exampleVi: "Vui lòng gửi yêu cầu gia hạn hai tuần trước ngày hết hạn.",
            collocation: "contract renewal request",
            status: .tricky
        )
    ]

    static let sampleVocabQuiz: [VocabQuizQuestion] = [
        VocabQuizQuestion(
            id: "vq-1",
            promptType: "Chọn nghĩa đúng",
            prompt: "stipulate",
            ipaHint: "/ˈstɪp.jə.leɪt/",
            contextSentence: "The warranty stipulates that free service applies only to original buyers.",
            options: [
                "Từ chối gia hạn hợp đồng",
                "Quy định rõ trong điều khoản",
                "Hoãn cuộc họp sang tuần sau",
                "Gửi bản sao hóa đơn"
            ],
            correctIndex: 1,
            explanationVi: "“stipulate” là động từ mang nghĩa quy định rõ, ghi rõ như một điều kiện bắt buộc trong hợp đồng hoặc chính sách."
        ),
        VocabQuizQuestion(
            id: "vq-2",
            promptType: "Điền từ vào ngữ cảnh",
            prompt: "All employees are expected to ______ the updated confidentiality guidelines.",
            ipaHint: nil,
            contextSentence: nil,
            options: [
                "abide by",
                "allocate to",
                "prevail over",
                "inquire about"
            ],
            correctIndex: 0,
            explanationVi: "Cụm động từ “abide by + quy định/hợp đồng” mang nghĩa tuân thủ, rất phổ biến trong TOEIC Part 5."
        ),
        VocabQuizQuestion(
            id: "vq-3",
            promptType: "Từ đồng nghĩa TOEIC",
            prompt: "reach a consensus",
            ipaHint: "/kənˈsen.səs/",
            contextSentence: "Department leads reached a consensus on the Q4 launch timeline.",
            options: [
                "Đạt được sự đồng thuận chung",
                "Gửi báo cáo tổng kết quý",
                "Gia hạn thời gian bảo hành",
                "Cắt giảm chi phí vận hành"
            ],
            correctIndex: 0,
            explanationVi: "“reach a consensus” = đạt được sự nhất trí, đồng thuận giữa các thành viên sau thảo luận."
        ),
        VocabQuizQuestion(
            id: "vq-4",
            promptType: "Chọn danh từ phù hợp",
            prompt: "The legal team reviewed every ______ of the lease before signing.",
            ipaHint: nil,
            contextSentence: nil,
            options: [
                "provision",
                "hesitation",
                "attendance",
                "departure"
            ],
            correctIndex: 0,
            explanationVi: "“provision” trong ngữ cảnh hợp đồng thuê (lease) có nghĩa là điều khoản."
        )
    ]

    static let grammarTopics: [GrammarTopicItem] = [
        GrammarTopicItem(
            id: "g-1",
            indexLabel: "Chủ điểm 01",
            title: "Giới từ & Liên từ chỉ sự nhượng bộ",
            subtitle: "Despite / In spite of + cụm danh từ; Although / Even though + mệnh đề",
            level: "Nền tảng",
            masteryPercent: 78,
            lessonMinutes: 12,
            accent: .teal,
            rules: [
                GrammarRuleBlock(
                    id: "gr-1",
                    heading: "Giới từ: Despite / In spite of",
                    formula: "Despite / In spite of + cụm danh từ / V-ing",
                    noteVi: "Theo sau giới từ là cụm danh từ hoặc V-ing, không có chủ ngữ và động từ chia thì.",
                    exampleEn: "Despite the heavy rain, the outdoor demonstration began on time.",
                    exampleVi: "Dù trời mưa lớn, buổi trình diễn ngoài trời vẫn bắt đầu đúng giờ."
                ),
                GrammarRuleBlock(
                    id: "gr-2",
                    heading: "Liên từ: Although / Even though",
                    formula: "Although / Even though + S + V",
                    noteVi: "Theo sau liên từ là một mệnh đề đầy đủ, có chủ ngữ và động từ chia thì.",
                    exampleEn: "Although it rained heavily, the outdoor demonstration began on time.",
                    exampleVi: "Mặc dù trời mưa lớn, buổi trình diễn ngoài trời vẫn bắt đầu đúng giờ."
                )
            ],
            practiceItems: [
                GrammarPracticeItem(
                    id: "gp-1",
                    question: "_______ the heavy rain earlier this morning, the outdoor product demonstration began on schedule.",
                    options: ["Although", "Despite", "Because", "Even though"],
                    correctIndex: 1,
                    tipVi: "Sau chỗ trống là cụm danh từ “the heavy rain earlier this morning”, nên dùng giới từ “Despite”."
                ),
                GrammarPracticeItem(
                    id: "gp-2",
                    question: "_______ the schedule changed twice, all presenters arrived before the keynote.",
                    options: ["Despite", "Although", "Because of", "In spite"],
                    correctIndex: 1,
                    tipVi: "Sau chỗ trống là mệnh đề đầy đủ “the schedule changed twice”, nên dùng liên từ “Although”."
                )
            ]
        ),
        GrammarTopicItem(
            id: "g-2",
            indexLabel: "Chủ điểm 02",
            title: "Mệnh đề quan hệ & Rút gọn",
            subtitle: "who, which, whose, V-ing và V3/ed",
            level: "Trung cấp",
            masteryPercent: 62,
            lessonMinutes: 15,
            accent: .blue,
            rules: [
                GrammarRuleBlock(
                    id: "gr-3",
                    heading: "Rút gọn chủ động vs bị động",
                    formula: "Danh từ + V-ing (chủ động) / Danh từ + V3/ed (bị động)",
                    noteVi: "Kiểm tra xem danh từ đứng trước tự thực hiện hành động hay chịu tác động để chọn V-ing hay V3/ed.",
                    exampleEn: "Applicants submitting forms after 5 P.M. will be reviewed tomorrow.",
                    exampleVi: "Ứng viên nộp biểu mẫu sau 5 giờ chiều sẽ được xem xét vào ngày mai."
                ),
                GrammarRuleBlock(
                    id: "gr-4",
                    heading: "Sở hữu với “whose + Noun”",
                    formula: "Danh từ + whose + Danh từ (không mạo từ) + V",
                    noteVi: "“whose” dùng được cho cả người và vật, theo sau ngay bởi một danh từ.",
                    exampleEn: "We partnered with a studio whose designs won two industry awards.",
                    exampleVi: "Chúng tôi hợp tác với một studio có các thiết kế đạt hai giải thưởng ngành."
                )
            ],
            practiceItems: [
                GrammarPracticeItem(
                    id: "gp-3",
                    question: "All invoices ______ before the 15th of the month qualify for an early-payment discount.",
                    options: ["submitting", "submitted", "are submitted", "submit"],
                    correctIndex: 1,
                    tipVi: "“invoices” (hóa đơn) chịu hành động được nộp → rút gọn mệnh đề quan hệ bị động “submitted”."
                ),
                GrammarPracticeItem(
                    id: "gp-4",
                    question: "The committee selected a candidate ______ portfolio demonstrated strong retail leadership.",
                    options: ["who", "whom", "whose", "which"],
                    correctIndex: 2,
                    tipVi: "Phía sau chỗ trống là danh từ “portfolio” thuộc sở hữu của “candidate” → dùng “whose”."
                )
            ]
        ),
        GrammarTopicItem(
            id: "g-3",
            indexLabel: "Chủ điểm 03",
            title: "Câu điều kiện & Đảo ngữ",
            subtitle: "Loại 1, 2, 3 và Should / Were / Had",
            level: "Nâng cao",
            masteryPercent: 45,
            lessonMinutes: 14,
            accent: .gold,
            rules: [
                GrammarRuleBlock(
                    id: "gr-5",
                    heading: "Đảo ngữ điều kiện loại 1 với Should",
                    formula: "Should + S + V(nguyên mẫu), S + will/can/please + V",
                    noteVi: "Mẫu cực kỳ phổ biến trong email công việc TOEIC Part 5 & Part 6.",
                    exampleEn: "Should you need further assistance, please contact our support desk.",
                    exampleVi: "Nếu bạn cần hỗ trợ thêm, vui lòng liên hệ bộ phận hỗ trợ của chúng tôi."
                )
            ],
            practiceItems: [
                GrammarPracticeItem(
                    id: "gp-5",
                    question: "______ any equipment arrive damaged, notify the warehouse supervisor immediately.",
                    options: ["Should", "If", "Unless", "Were"],
                    correctIndex: 0,
                    tipVi: "Động từ “arrive” ở dạng nguyên mẫu sau chủ ngữ số ít “any equipment” → đảo ngữ điều kiện loại 1 với “Should”."
                )
            ]
        ),
        GrammarTopicItem(
            id: "g-4",
            indexLabel: "Chủ điểm 04",
            title: "Từ loại & Vị trí trong câu",
            subtitle: "Danh từ, tính từ, trạng từ và đuôi nhận diện",
            level: "Ghi điểm nhanh",
            masteryPercent: 86,
            lessonMinutes: 10,
            accent: .coral,
            rules: [
                GrammarRuleBlock(
                    id: "gr-6",
                    heading: "Trạng từ bổ nghĩa cho tính từ & phân từ",
                    formula: "be / mạo từ + Adv (-ly) + Adj / V3-ed + Noun",
                    noteVi: "Nhìn nhanh hai bên chỗ trống để xác định từ loại cần điền trong vòng 10 giây.",
                    exampleEn: "The newly renovated lobby welcomes visitors with natural light.",
                    exampleVi: "Sảnh lễ tân mới được cải tạo đón khách bằng ánh sáng tự nhiên."
                )
            ],
            practiceItems: [
                GrammarPracticeItem(
                    id: "gp-6",
                    question: "Ms. Tran delivered a ______ detailed presentation on the regional budget.",
                    options: ["remark", "remarkable", "remarkably", "remarking"],
                    correctIndex: 2,
                    tipVi: "Trước tính từ “detailed” cần trạng từ bổ nghĩa → “remarkably”."
                )
            ]
        )
    ]

    static let dictationLessons: [DictationLessonItem] = [
        DictationLessonItem(
            id: "dict-1",
            partTag: "Part 2 • Hỏi đáp",
            title: "Lịch họp & Đặt phòng hội nghị",
            subtitle: "Giọng Anh - Mỹ rõ nhịp, luyện bắt nối âm và từ khóa thời gian",
            sentenceCount: 3,
            durationLabel: "02:45",
            difficulty: "600+ TOEIC",
            accent: .coral,
            lines: [
                DictationLine(
                    id: "dl-1",
                    speaker: "Speaker A",
                    fullSentence: "Please confirm that the projector and wireless microphones are installed before 9 a.m.",
                    vietnameseMeaning: "Vui lòng xác nhận máy chiếu và micro không dây đã được lắp đặt trước 9 giờ sáng.",
                    normalMaskedTokens: ["Please", "confirm", "that", "the", "____", "and", "wireless", "microphones", "are", "installed", "before", "9", "a.m."],
                    normalAnswers: ["projector"],
                    hardMaskedTokens: ["Please", "confirm", "that", "the", "____", "and", "wireless", "microphones", "are", "____", "before", "9", "a.m."],
                    hardAnswers: ["projector", "installed"],
                    wordBank: ["projector", "installed", "wireless", "microphones", "before", "9", "a.m.", "schedule"],
                    durationLabel: "00:26"
                ),
                DictationLine(
                    id: "dl-2",
                    speaker: "Speaker B",
                    fullSentence: "Let me check whether the main conference room is available after two.",
                    vietnameseMeaning: "Để tôi kiểm tra xem phòng hội nghị chính có trống sau hai giờ không.",
                    normalMaskedTokens: ["Let", "me", "____", "whether", "the", "main", "____", "room", "is", "____", "after", "two."],
                    normalAnswers: ["check", "conference", "available"],
                    hardMaskedTokens: ["Let", "me", "____", "____", "the", "____", "____", "____", "is", "____", "____", "two."],
                    hardAnswers: ["check", "whether", "main", "conference", "room", "available", "after"],
                    wordBank: ["check", "conference", "available", "whether", "main", "room", "after", "reserved"],
                    durationLabel: "00:08"
                ),
                DictationLine(
                    id: "dl-3",
                    speaker: "Speaker A",
                    fullSentence: "Thanks, I will send the updated agenda once the time is confirmed.",
                    vietnameseMeaning: "Cảm ơn, tôi sẽ gửi chương trình họp cập nhật ngay khi chốt giờ.",
                    normalMaskedTokens: ["Thanks,", "I", "will", "send", "the", "____", "____", "once", "the", "time", "is", "____."],
                    normalAnswers: ["updated", "agenda", "confirmed"],
                    hardMaskedTokens: ["Thanks,", "I", "will", "____", "the", "____", "____", "____", "the", "____", "is", "____."],
                    hardAnswers: ["send", "updated", "agenda", "once", "time", "confirmed"],
                    wordBank: ["updated", "agenda", "confirmed", "send", "once", "time", "invoice", "printed"],
                    durationLabel: "00:08"
                )
            ]
        ),
        DictationLessonItem(
            id: "dict-2",
            partTag: "Part 3 • Hội thoại",
            title: "Giao hàng chậm & Xử lý đơn",
            subtitle: "Tốc độ tự nhiên, có từ đồng âm dễ nhầm trong kho vận",
            sentenceCount: 2,
            durationLabel: "03:10",
            difficulty: "700+ TOEIC",
            accent: .teal,
            lines: [
                DictationLine(
                    id: "dl-4",
                    speaker: "Coordinator",
                    fullSentence: "The express shipment was delayed at customs until early this morning.",
                    vietnameseMeaning: "Lô hàng chuyển phát nhanh đã bị giữ chậm ở hải quan cho đến sáng sớm nay.",
                    normalMaskedTokens: ["The", "____", "shipment", "was", "____", "at", "____", "until", "early", "this", "morning."],
                    normalAnswers: ["express", "delayed", "customs"],
                    hardMaskedTokens: ["The", "____", "____", "was", "____", "at", "____", "____", "____", "this", "morning."],
                    hardAnswers: ["express", "shipment", "delayed", "customs", "until", "early"],
                    wordBank: ["express", "delayed", "customs", "shipment", "until", "early", "cleared", "warehouse"],
                    durationLabel: "00:09"
                ),
                DictationLine(
                    id: "dl-5",
                    speaker: "Manager",
                    fullSentence: "Please notify the retail client and waive the delivery fee.",
                    vietnameseMeaning: "Vui lòng thông báo khách bán lẻ và miễn phí vận chuyển.",
                    normalMaskedTokens: ["Please", "____", "the", "retail", "____", "and", "____", "the", "delivery", "fee."],
                    normalAnswers: ["notify", "client", "waive"],
                    hardMaskedTokens: ["Please", "____", "the", "____", "____", "and", "____", "the", "____", "____."],
                    hardAnswers: ["notify", "retail", "client", "waive", "delivery", "fee"],
                    wordBank: ["notify", "client", "waive", "retail", "delivery", "fee", "charge", "cancel"],
                    durationLabel: "00:07"
                )
            ]
        )
    ]

    static let toeicParts: [ToeicPartItem] = [
        ToeicPartItem(
            id: "part-1",
            partNumber: 1,
            skillGroup: .listening,
            title: "Part 1",
            vietnameseName: "Mô tả tranh",
            descriptionVi: "Nghe 4 câu mô tả và nhận diện hành động, vị trí đồ vật chính xác.",
            questionFormat: "6 câu mẫu • Âm thanh + Khung cảnh",
            progress: 0.82,
            accent: .blue,
            audioTitle: "Part 1 • Văn phòng & Bàn họp",
            audioDuration: "00:38",
            visualCaption: "Khung cảnh mẫu: Hai nhân viên đang xem bản vẽ trên bàn gỗ cạnh cửa sổ kính sáng, máy tính xách tay đang mở.",
            passageTitle: nil,
            passageBody: nil,
            transcriptEn: "(A) They are rearranging chairs around the window.\n(B) Two colleagues are reviewing documents at a table.\n(C) A laptop is being packed into a briefcase.\n(D) The blinds have been completely closed.",
            transcriptVi: "(A) Họ đang sắp xếp lại ghế quanh cửa sổ.\n(B) Hai đồng nghiệp đang xem tài liệu tại bàn.\n(C) Một máy tính xách tay đang được cất vào cặp.\n(D) Rèm cửa đã được kéo kín hoàn toàn.",
            questions: [
                ToeicPracticeQuestion(
                    id: "p1-q1",
                    numberLabel: "Câu 1",
                    prompt: "Chọn câu mô tả chính xác nhất nội dung bức tranh mẫu.",
                    options: ["Đáp án (A)", "Đáp án (B)", "Đáp án (C)", "Đáp án (D)"],
                    correctIndex: 1,
                    explanationVi: "Câu (B) “Two colleagues are reviewing documents at a table” khớp trực tiếp với hành động hai nhân viên đang xem tài liệu tại bàn."
                )
            ]
        ),
        ToeicPartItem(
            id: "part-2",
            partNumber: 2,
            skillGroup: .listening,
            title: "Part 2",
            vietnameseName: "Hỏi đáp",
            descriptionVi: "Nghe câu hỏi ngắn và chọn phản hồi phù hợp nhất theo ngữ cảnh.",
            questionFormat: "25 câu mẫu • Hỏi và đáp",
            progress: 0.66,
            accent: .teal,
            audioTitle: "Part 2 • Hợp đồng đã cập nhật",
            audioDuration: "00:05",
            visualCaption: nil,
            passageTitle: nil,
            passageBody: nil,
            transcriptEn: "Where should I leave the updated contract?\n(A) On Ms. Lee's desk.\n(B) It was signed yesterday.\n(C) The contract is renewed annually.",
            transcriptVi: nil,
            questions: [
                ToeicPracticeQuestion(
                    id: "p2-q1",
                    numberLabel: "Câu 8",
                    prompt: "Where should I leave the updated contract?",
                    options: ["On Ms. Lee's desk.", "It was signed yesterday.", "The contract is renewed annually."],
                    correctIndex: 0,
                    explanationVi: "Đáp án (A) trả lời trực tiếp câu hỏi về địa điểm: để hợp đồng trên bàn của cô Lee."
                )
            ]
        ),
        ToeicPartItem(
            id: "part-3",
            partNumber: 3,
            skillGroup: .listening,
            title: "Part 3",
            vietnameseName: "Đoạn hội thoại ngắn",
            descriptionVi: "Luyện nghe hội thoại công sở 2–3 người và xác định mục đích, hành động tiếp theo.",
            questionFormat: "3 câu / đoạn • Có transcript song ngữ",
            progress: 0.56,
            accent: .teal,
            audioTitle: "Part 3 • Đổi địa điểm workshop",
            audioDuration: "01:12",
            visualCaption: nil,
            passageTitle: nil,
            passageBody: nil,
            transcriptEn: "W: Hi Ken, more than eighty guests registered for Friday's design workshop.\nM: That exceeds the capacity of Room 302. Should we move to the auditorium on the fifth floor?\nW: Good idea. I'll email attendees the updated room number right away.",
            transcriptVi: "Nữ: Chào Ken, hơn tám mươi khách đã đăng ký buổi workshop thiết kế thứ Sáu.\nNam: Vậy vượt sức chứa phòng 302 rồi. Ta chuyển sang hội trường tầng năm nhé?\nNữ: Ý hay đấy. Tôi sẽ gửi email báo số phòng mới cho người tham dự ngay.",
            questions: [
                ToeicPracticeQuestion(
                    id: "p3-q1",
                    numberLabel: "Câu 1",
                    prompt: "Why do the speakers need to change the room?",
                    options: [
                        "The projector in Room 302 is broken.",
                        "More guests registered than the room can hold.",
                        "The fifth floor is being repainted.",
                        "The workshop date was postponed."
                    ],
                    correctIndex: 1,
                    explanationVi: "Người nam nói “That exceeds the capacity of Room 302” → số lượng đăng ký vượt sức chứa phòng 302."
                ),
                ToeicPracticeQuestion(
                    id: "p3-q2",
                    numberLabel: "Câu 2",
                    prompt: "What will the woman do next?",
                    options: [
                        "Order additional chairs",
                        "Cancel the Friday workshop",
                        "Send attendees the new room number",
                        "Print new name badges"
                    ],
                    correctIndex: 2,
                    explanationVi: "Câu cuối người nữ nói “I'll email attendees the updated room number right away.”"
                )
            ]
        ),
        ToeicPartItem(
            id: "part-4",
            partNumber: 4,
            skillGroup: .listening,
            title: "Part 4",
            vietnameseName: "Bài nói ngắn",
            descriptionVi: "Nghe thông báo và tìm mục đích, thời gian cùng hành động cần thực hiện.",
            questionFormat: "30 câu mẫu • Bài nói đơn",
            progress: 0.49,
            accent: .teal,
            audioTitle: "Part 4 • Thông báo bảo trì",
            audioDuration: "00:42",
            visualCaption: nil,
            passageTitle: nil,
            passageBody: nil,
            transcriptEn: "Attention, employees. The main conference room will be unavailable for maintenance this Friday. Please save any presentation files by 6 P.M. on Thursday. Meetings scheduled for Friday will move to Room 410.",
            transcriptVi: "Xin chú ý, các nhân viên. Phòng hội nghị chính sẽ ngừng hoạt động để bảo trì vào thứ Sáu này. Vui lòng lưu các tệp thuyết trình trước 6 giờ chiều thứ Năm. Các cuộc họp ngày thứ Sáu sẽ chuyển sang Phòng 410.",
            questions: [
                ToeicPracticeQuestion(
                    id: "p4-q1",
                    numberLabel: "Câu 71",
                    prompt: "What is being announced?",
                    options: ["A conference room will be under maintenance.", "A new employee orientation will begin.", "The office will close permanently.", "A presentation has been postponed."],
                    correctIndex: 0,
                    explanationVi: "Người nói thông báo phòng hội nghị chính sẽ được bảo trì vào thứ Sáu."
                ),
                ToeicPracticeQuestion(
                    id: "p4-q2",
                    numberLabel: "Câu 72",
                    prompt: "When should employees save their presentation files?",
                    options: ["By 6 P.M. Thursday", "Before noon on Friday", "At the start of next week", "After the room reopens"],
                    correctIndex: 0,
                    explanationVi: "Thông báo yêu cầu lưu tệp trước 6 giờ chiều thứ Năm."
                )
            ]
        ),
        ToeicPartItem(
            id: "part-5",
            partNumber: 5,
            skillGroup: .reading,
            title: "Part 5",
            vietnameseName: "Hoàn thành câu",
            descriptionVi: "Phản xạ nhanh ngữ pháp, collocation và từ loại trong câu đơn TOEIC.",
            questionFormat: "Tốc độ 20s / câu • Giải thích chi tiết",
            progress: 0.74,
            accent: .gold,
            audioTitle: nil,
            audioDuration: nil,
            visualCaption: nil,
            passageTitle: nil,
            passageBody: nil,
            transcriptEn: nil,
            transcriptVi: nil,
            questions: [
                ToeicPracticeQuestion(
                    id: "p5-q1",
                    numberLabel: "Câu 101",
                    prompt: "To avoid delays at check-in, passengers are advised to arrive ______ two hours prior to boarding.",
                    options: ["at least", "as soon", "in spite", "even though"],
                    correctIndex: 0,
                    explanationVi: "Trước cụm số lượng “two hours” cần cụm trạng từ chỉ mức tối thiểu “at least” (ít nhất)."
                ),
                ToeicPracticeQuestion(
                    id: "p5-q2",
                    numberLabel: "Câu 102",
                    prompt: "The new inventory software allows managers to track stock levels ______ across all branches.",
                    options: ["accurate", "accuracy", "accurately", "accuracies"],
                    correctIndex: 2,
                    explanationVi: "Cần trạng từ bổ nghĩa cho động từ “track” → “accurately”."
                )
            ]
        ),
        ToeicPartItem(
            id: "part-6",
            partNumber: 6,
            skillGroup: .reading,
            title: "Part 6",
            vietnameseName: "Hoàn thành đoạn văn",
            descriptionVi: "Đọc email ngắn, điền từ và chọn câu phù hợp với mạch văn.",
            questionFormat: "16 câu mẫu • Đoạn văn khuyết",
            progress: 0.58,
            accent: .gold,
            audioTitle: nil,
            audioDuration: nil,
            visualCaption: nil,
            passageTitle: "EMAIL • Lịch gửi báo cáo quý",
            passageBody: "To: Marketing Team\nFrom: Olivia Chen\nSubject: Quarterly report\n\nPlease send your final campaign summaries to the regional office by Friday. Ms. Park will review each report before the department meeting. If you need additional data, contact the analytics team as soon as possible.",
            transcriptEn: nil,
            transcriptVi: nil,
            questions: [
                ToeicPracticeQuestion(
                    id: "p6-q1",
                    numberLabel: "Câu 131",
                    prompt: "When should the campaign summaries be sent?",
                    options: ["By Friday", "After the meeting", "Next month", "Before the office opens"],
                    correctIndex: 0,
                    explanationVi: "Câu đầu yêu cầu gửi bản tổng kết chiến dịch trước hoặc trong thứ Sáu."
                ),
                ToeicPracticeQuestion(
                    id: "p6-q2",
                    numberLabel: "Câu 132",
                    prompt: "Who will review each report?",
                    options: ["Olivia Chen", "Ms. Park", "The analytics team", "The regional director"],
                    correctIndex: 1,
                    explanationVi: "Email nêu rõ Ms. Park sẽ xem lại từng báo cáo trước cuộc họp."
                )
            ]
        ),
        ToeicPartItem(
            id: "part-7",
            partNumber: 7,
            skillGroup: .reading,
            title: "Part 7",
            vietnameseName: "Đọc hiểu đoạn văn",
            descriptionVi: "Đọc email, thông báo, lịch trình và xác định thông tin suy luận nhanh.",
            questionFormat: "Đoạn đơn & đoạn kép • Highlight từ khóa",
            progress: 0.41,
            accent: .coral,
            audioTitle: nil,
            audioDuration: nil,
            visualCaption: nil,
            passageTitle: "MEMO • Nâng cấp hệ thống thẻ ra vào",
            passageBody: "To: All Staff\nFrom: Facilities Management\nDate: October 14\nSubject: Updated Building Access Cards\n\nStarting Monday, October 21, the main lobby turnstiles will require the new encrypted employee badges. Current cards will stop working at 6:00 P.M. on Sunday.\n\nStaff members who have not yet picked up their replacement badge may visit Reception Desk B between 8:30 A.M. and 4:30 P.M. this Thursday or Friday. Please bring your existing ID card for quick exchange.",
            transcriptEn: nil,
            transcriptVi: nil,
            questions: [
                ToeicPracticeQuestion(
                    id: "p7-q1",
                    numberLabel: "Câu 147",
                    prompt: "What is the main purpose of this memo?",
                    options: [
                        "To announce a change in office working hours",
                        "To inform employees about replacing access badges",
                        "To recruit receptionists for Desk B",
                        "To report a lobby security incident"
                    ],
                    correctIndex: 1,
                    explanationVi: "Tiêu đề và đoạn 1 nêu rõ từ thứ Hai 21/10 cổng sảnh chính dùng thẻ mã hóa mới và hướng dẫn nhân viên đổi thẻ."
                ),
                ToeicPracticeQuestion(
                    id: "p7-q2",
                    numberLabel: "Câu 148",
                    prompt: "What should staff bring when collecting the new card?",
                    options: [
                        "A signed manager form",
                        "Their existing ID card",
                        "A printed copy of the memo",
                        "Their parking receipt"
                    ],
                    correctIndex: 1,
                    explanationVi: "Câu cuối ghi rõ “Please bring your existing ID card for quick exchange.”"
                )
            ]
        )
    ]

    static let todayTasks: [TodayTaskItem] = [
        TodayTaskItem(
            id: "t-1",
            title: "Luyện nghe Part 1–4",
            subtitle: "Mô tả tranh, hỏi đáp & hội thoại",
            durationLabel: "35–45 phút",
            tag: "Luyện nghe",
            icon: "headphones",
            accent: .teal,
            destination: .toeicPartPractice(toeicParts[0]),
            isCompleted: false
        ),
        TodayTaskItem(
            id: "t-2",
            title: "Luyện đọc Part 5–7",
            subtitle: "Hoàn thành câu & đọc hiểu văn bản",
            durationLabel: "40–50 phút",
            tag: "Luyện đọc",
            icon: "book.closed.fill",
            accent: .coral,
            destination: .toeicPartPractice(toeicParts[4]),
            isCompleted: false
        ),
        TodayTaskItem(
            id: "t-3",
            title: "Từ vựng: Hợp đồng & Đàm phán",
            subtitle: "Flashcard và bài tập củng cố",
            durationLabel: "20–30 phút",
            tag: "Từ vựng + chữa lỗi",
            icon: "character.book.closed.fill",
            accent: .gold,
            destination: .vocabDetail(vocabLists[0]),
            isCompleted: false
        )
    ]

    static let weeklyDays: [WeeklyStudyDay] = [
        WeeklyStudyDay(id: "mon", shortLabel: "T2", minutes: 35, isToday: false, isCompleted: true),
        WeeklyStudyDay(id: "tue", shortLabel: "T3", minutes: 42, isToday: false, isCompleted: true),
        WeeklyStudyDay(id: "wed", shortLabel: "T4", minutes: 28, isToday: false, isCompleted: true),
        WeeklyStudyDay(id: "thu", shortLabel: "T5", minutes: 0, isToday: true, isCompleted: false),
        WeeklyStudyDay(id: "fri", shortLabel: "T6", minutes: 0, isToday: false, isCompleted: false),
        WeeklyStudyDay(id: "sat", shortLabel: "T7", minutes: 0, isToday: false, isCompleted: false),
        WeeklyStudyDay(id: "sun", shortLabel: "CN", minutes: 0, isToday: false, isCompleted: false)
    ]

    static let reviewDecks: [ReviewDeckItem] = [
        ReviewDeckItem(
            id: "rd-1",
            title: "Thẻ từ vựng đến hạn",
            subtitle: "List 01 & List 02 • Ưu tiên từ dễ nhầm",
            dueCount: 18,
            estimatedMinutes: 7,
            icon: "rectangle.on.rectangle.angled",
            accent: .blue,
            destination: .flashcards(listTitle: "Bộ ôn nhanh hôm nay")
        ),
        ReviewDeckItem(
            id: "rd-2",
            title: "Trắc nghiệm phản xạ nhanh",
            subtitle: "4 câu chọn nghĩa & điền từ theo ngữ cảnh",
            dueCount: 12,
            estimatedMinutes: 5,
            icon: "checkmark.seal.fill",
            accent: .teal,
            destination: .vocabQuiz(listTitle: "Ôn nhanh từ vựng TOEIC")
        ),
        ReviewDeckItem(
            id: "rd-3",
            title: "Nghe chép chế độ HARD",
            subtitle: "Luyện bắt từ khóa nối âm hay bỏ sót",
            dueCount: 6,
            estimatedMinutes: 8,
            icon: "waveform",
            accent: .coral,
            destination: .dictationSession(lesson: dictationLessons[0], initialMode: .hard)
        ),
        ReviewDeckItem(
            id: "rd-4",
            title: "Bẫy ngữ pháp Part 5",
            subtitle: "Đảo ngữ điều kiện & rút gọn bị động",
            dueCount: 9,
            estimatedMinutes: 6,
            icon: "sparkles",
            accent: .gold,
            destination: .grammarDetail(grammarTopics[2])
        )
    ]

    static let weakAreas: [WeakAreaItem] = [
        WeakAreaItem(
            id: "wa-1",
            category: "Từ vựng",
            title: "obligate / stipulate / provision",
            detail: "Nhóm từ hợp đồng hay nhầm nghĩa khi đọc nhanh Part 7",
            accent: .coral,
            destination: .vocabDetail(vocabLists[0])
        ),
        WeakAreaItem(
            id: "wa-2",
            category: "Ngữ pháp",
            title: "Rút gọn mệnh đề quan hệ V-ing / V3-ed",
            detail: "Cần chú ý danh từ chủ động hay bị động trước chỗ trống",
            accent: .teal,
            destination: .grammarDetail(grammarTopics[1])
        ),
        WeakAreaItem(
            id: "wa-3",
            category: "Nghe hiểu",
            title: "Part 3 • Câu hỏi hành động tiếp theo",
            detail: "Thường nằm ở 2 lượt lời cuối trong đoạn hội thoại",
            accent: .blue,
            destination: .toeicPartPractice(toeicParts[2])
        )
    ]

    static let skillBreakdown: [SkillProgressItem] = [
        SkillProgressItem(id: "sk-1", name: "Từ vựng TOEIC", completedLabel: "420 / 600 từ mẫu", percent: 0.70, icon: "character.book.closed.fill", accent: .blue),
        SkillProgressItem(id: "sk-2", name: "Ngữ pháp trọng tâm", completedLabel: "11 / 18 chủ điểm", percent: 0.61, icon: "list.bullet.rectangle.portrait.fill", accent: .teal),
        SkillProgressItem(id: "sk-3", name: "Nghe chép chính tả", completedLabel: "36 / 60 đoạn mẫu", percent: 0.60, icon: "waveform", accent: .coral),
        SkillProgressItem(id: "sk-4", name: "Nghe & Đọc Parts 1–7", completedLabel: "48 / 90 bài tập", percent: 0.53, icon: "headphones", accent: .gold)
    ]

    static let milestones: [MilestoneBadge] = [
        MilestoneBadge(id: "m-1", title: "Chuỗi 12 ngày", subtitle: "Học đều mỗi sáng", icon: "flame.fill", accent: .gold),
        MilestoneBadge(id: "m-2", title: "100% List 01", subtitle: "Hoàn thành Quiz mẫu", icon: "rosette", accent: .blue),
        MilestoneBadge(id: "m-3", title: "Tai nhạy Part 2", subtitle: "Đạt 90% Dictation", icon: "mic.fill", accent: .coral)
    ]
}
