# Neon English iOS Stitch Reference

## Source

- Stitch project: `projects/4757481470228297368` — **TOEIC Study Workspace Dashboard**.
- The project contains separate desktop concepts and a 19-screen iPhone set. For native iOS implementation, use the `MOBILE`, 390 × 884 screens listed below; do not shrink the desktop screens into phone layouts.
- The approved **Neon English — Brand & Logo System** screen is `node_12926058529540440067`. Its default, dark, and tinted iOS AppIcon masters are exported at 1024 × 1024 in `NeonEnglish/Assets.xcassets/AppIcon.appiconset/`; keep this Stitch artwork as the source of truth instead of redrawing the mark.
- Screen HTML can be retrieved through Codex Stitch MCP with `get_screen`, then `download_file` using `htmlCode.name`.
- Codex Stitch MCP access was verified on 2026-11-26. Authentication is provided by a user-global header helper; never copy the API key into this repository or print it.

## iPhone Screen Map

| Screen | Stitch screen ID |
| --- | --- |
| Hôm nay | `node_16925731583121001313` |
| Học | `node_12056440497938415038` |
| Từ vựng · Danh sách | `node_15244190044097837139` |
| Từ vựng · Chi tiết | `node_14207800211296561997` |
| Từ vựng · Flashcard | `node_16384413295702603132` |
| Từ vựng · Trắc nghiệm | `node_12356912607289169632` |
| Từ vựng · Ghép cặp | `node_15134518945670717087` |
| Từ vựng · Điền từ | `node_3333823574939754781` |
| Từ vựng · Nghe từ | `node_4112927675828159732` |
| Ngữ pháp · Chủ điểm | `node_4350710006528701890` |
| Ngữ pháp · Lý thuyết | `node_5263472974500300659` |
| Ngữ pháp · Thực hành | `node_16542123110736270889` |
| Nghe chép · Chọn bài | `node_11888092222605280835` |
| Nghe chép · Thực hành | `node_12680617837574375362` |
| Luyện nghe · Part 1–4 | `node_15373050514725553009` |
| Luyện đọc · Part 5–7 | `node_13010479213371796909` |
| Kết quả & Chữa lỗi | `node_894160767339399255` |
| Ôn tập | `node_10637222574523825295` |
| Tiến độ | `node_7183354403103616934` |

Full MCP resource name: `projects/4757481470228297368/screens/{screen-id}`.
HTML file resource name: `projects/4757481470228297368/files/{screen-id}`.

## Mobile Design Contract

- Compose for a 390 × 884 iPhone viewport with the status area/Dynamic Island, safe-area spacing, and a four-item bottom tab bar on the top-level tabs: Hôm nay, Học, Ôn tập, Tiến độ. Practice/detail flows use compact back/action navigation instead of the root tab bar where shown.
- Bright cool-mint canvas `#F7FAF9`; ink `#11181C`; secondary text `#333C42`; white/soft mint surfaces. Primary cobalt `#1D4ED8`, Listening/Dictation jade `#0D7C66`, Vocabulary citrus `#4D7C0F`, and Reading/review coral `#C2410C`.
- Use Be Vietnam Pro for Vietnamese UI and Source Code Pro for IPA, timers, and tabular values when fonts are bundled. Keep Vietnamese diacritics intact.
- The shared design-system markdown describes desktop shapes, but the actual iPhone HTML is the source of truth for mobile geometry: `.ne-surface` is 24 px, `.ne-row` is 20 px, and primary touch actions are at least 52 px high with full-pill corners. Do not apply the desktop 0–8 px radius rule to these iPhone screens.
- Keep the mobile surfaces bright and uncluttered. The shared design system rules out gradients, glassmorphism, heavy shadows, and purple-dominant styling. Use whitespace and tonal surfaces, not a stack of nested cards.
- Keep all app functionality presentation-only for this phase. Mock state and local navigation are allowed; backend, cloud DB, imported course data, persistent tracking, and Study4 integration are not.

## Retrieval And Verification Status

- `get_project`, `list_screens`, `get_screen`, and `download_file` all succeeded through Codex Stitch MCP on 2026-11-26.
- HTML for all 19 mobile screens was retrieved and used to align SwiftUI screen structure, navigation, content hierarchy, and available image assets. The Hôm nay screen was rendered at 390 × 884 to verify the delivered HTML.
- The Stitch response did not include screenshot files for these screens. Pixel-level visual comparison and iOS Simulator review remain pending; do not claim Simulator verification.
- The image-led vocabulary flashcard and Listening Part 1 use the corresponding images retrieved from their Stitch screens. Retrieve the exact referenced asset before adding any additional image-led native screen.
