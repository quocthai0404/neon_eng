import SwiftUI

enum NeonTheme {
    // MARK: - Brand & Accents
    static let primaryBlue = Color(red: 0.114, green: 0.306, blue: 0.847) // #1D4ED8
    static let primaryBlueDeep = Color(red: 0.118, green: 0.251, blue: 0.686) // #1E40AF
    static let primaryBlueSoft = Color(red: 0.937, green: 0.965, blue: 1.000) // #EFF6FF

    static let teal = Color(red: 0.051, green: 0.486, blue: 0.400) // #0D7C66
    static let tealSoft = Color(red: 0.902, green: 0.961, blue: 0.945) // #E6F5F1

    static let coral = Color(red: 0.761, green: 0.255, blue: 0.047) // #C2410C
    static let coralSoft = Color(red: 1.000, green: 0.941, blue: 0.922) // #FFF0EB

    static let gold = Color(red: 0.302, green: 0.486, blue: 0.059) // #4D7C0F
    static let goldSoft = Color(red: 0.945, green: 0.973, blue: 0.894) // #F1F8E4

    static let successGreen = Color(red: 0.098, green: 0.635, blue: 0.353)
    static let successSoft = Color(red: 0.902, green: 0.976, blue: 0.933)

    // MARK: - Light Airy Surfaces
    static let canvas = Color(red: 0.969, green: 0.980, blue: 0.976) // #F7FAF9
    static let surface = Color.white
    static let subtleSurface = Color(red: 0.937, green: 0.957, blue: 0.949) // #EFF4F2
    static let border = Color(red: 0.808, green: 0.847, blue: 0.831) // #CED8D4

    // MARK: - Typography Colors
    static let textPrimary = Color(red: 0.067, green: 0.094, blue: 0.110) // #11181C
    static let textSecondary = Color(red: 0.200, green: 0.235, blue: 0.259) // #333C42
    static let textMuted = Color(red: 0.345, green: 0.388, blue: 0.416) // #58636A

    // MARK: - Layout Constants
    static let cardCornerRadius: CGFloat = 24
    static let rowCornerRadius: CGFloat = 20
    static let controlCornerRadius: CGFloat = 26
    static let horizontalPadding: CGFloat = 16
}

// MARK: - Accent Style Helper

enum NeonAccent: String, Hashable {
    case blue
    case teal
    case coral
    case gold
    case green

    var color: Color {
        switch self {
        case .blue: return NeonTheme.primaryBlue
        case .teal: return NeonTheme.teal
        case .coral: return NeonTheme.coral
        case .gold: return NeonTheme.gold
        case .green: return NeonTheme.successGreen
        }
    }

    var softColor: Color {
        switch self {
        case .blue: return NeonTheme.primaryBlueSoft
        case .teal: return NeonTheme.tealSoft
        case .coral: return NeonTheme.coralSoft
        case .gold: return NeonTheme.goldSoft
        case .green: return NeonTheme.successSoft
        }
    }
}

// MARK: - Reusable Card Surface

struct NeonCardModifier: ViewModifier {
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = NeonTheme.cardCornerRadius
    var background: Color = NeonTheme.surface

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(NeonTheme.border.opacity(0.65), lineWidth: 1)
            )
    }
}

extension View {
    func neonCard(
        padding: CGFloat = 16,
        cornerRadius: CGFloat = NeonTheme.cardCornerRadius,
        background: Color = NeonTheme.surface
    ) -> some View {
        modifier(NeonCardModifier(padding: padding, cornerRadius: cornerRadius, background: background))
    }

    func neonScreenBackground() -> some View {
        background(NeonTheme.canvas.ignoresSafeArea())
    }
}

// MARK: - Button Styles

struct NeonPrimaryButtonStyle: ButtonStyle {
    var accent: Color = NeonTheme.primaryBlue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .default, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .background(
                Capsule()
                    .fill(accent.opacity(configuration.isPressed ? 0.85 : 1.0))
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

struct NeonSoftButtonStyle: ButtonStyle {
    var accent: NeonAccent = .blue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.subheadline, design: .default, weight: .semibold))
            .foregroundStyle(accent.color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(accent.softColor.opacity(configuration.isPressed ? 0.72 : 1.0))
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1.0)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}

// MARK: - Shared UI Components

struct NeonPillBadge: View {
    let text: String
    var icon: String? = nil
    var accent: NeonAccent = .blue

    var body: some View {
        HStack(spacing: 5) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
            }
            Text(text)
                .font(.system(.caption, design: .default, weight: .semibold))
        }
        .foregroundStyle(accent.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Capsule().fill(accent.softColor))
    }
}

struct NeonIconBadge: View {
    let systemImage: String
    var accent: NeonAccent = .blue
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: size * 0.44, weight: .semibold))
            .foregroundStyle(accent.color)
            .frame(width: size, height: size)
            .background(
                RoundedRectangle(cornerRadius: size * 0.32, style: .continuous)
                    .fill(accent.softColor)
            )
    }
}

struct NeonProgressBar: View {
    let progress: Double
    var accent: Color = NeonTheme.primaryBlue
    var height: CGFloat = 8

    private var clamped: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(NeonTheme.subtleSurface)
                Capsule()
                    .fill(accent)
                    .frame(width: max(height, proxy.size.width * clamped))
            }
        }
        .frame(height: height)
    }
}

struct NeonRingProgress: View {
    let progress: Double
    var accent: Color = NeonTheme.primaryBlue
    var lineWidth: CGFloat = 7
    var size: CGFloat = 56
    var label: String? = nil

    private var clamped: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(NeonTheme.subtleSurface, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(accent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            if let label {
                Text(label)
                    .font(.system(size: size * 0.24, weight: .bold, design: .default))
                    .foregroundStyle(NeonTheme.textPrimary)
            }
        }
        .frame(width: size, height: size)
    }
}

struct NeonSectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var trailingText: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(.title3, design: .default, weight: .bold))
                    .foregroundStyle(NeonTheme.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.system(.caption, design: .default))
                        .foregroundStyle(NeonTheme.textSecondary)
                }
            }
            Spacer()
            if let trailingText {
                Text(trailingText)
                    .font(.system(.caption, design: .default, weight: .semibold))
                    .foregroundStyle(NeonTheme.primaryBlue)
            }
        }
    }
}

struct NeonBrandChip: View {
    var body: some View {
        HStack(spacing: 6) {
            NeonBrandSymbol(size: 22)
            Text("Neon English")
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(NeonTheme.textPrimary)
        }
    }
}

struct NeonBrandSymbol: View {
    var size: CGFloat = 24

    var body: some View {
        ZStack {
            Capsule()
                .fill(NeonTheme.primaryBlue)
                .frame(width: size * 0.23, height: size * 0.72)
                .rotationEffect(.degrees(25))
                .offset(x: -size * 0.22, y: size * 0.08)
            Capsule()
                .fill(NeonTheme.teal)
                .frame(width: size * 0.23, height: size * 0.60)
                .rotationEffect(.degrees(25))
                .offset(x: size * 0.02, y: size * 0.06)
            Circle()
                .fill(NeonTheme.gold)
                .frame(width: size * 0.20, height: size * 0.20)
                .offset(x: size * 0.30, y: -size * 0.28)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

struct NeonMockAudioBar: View {
    let title: String
    let durationLabel: String
    var accent: NeonAccent = .blue

    @State private var isPlaying = false
    @State private var speedIndex = 1
    @State private var progress: Double = 0.34

    private let speeds = ["0.8x", "1.0x", "1.2x"]
    private let bars: [CGFloat] = [10, 18, 26, 14, 24, 30, 16, 22, 28, 12, 20, 26, 16, 24, 14, 18, 26, 12]

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.78)) {
                        isPlaying.toggle()
                        if isPlaying && progress >= 0.92 {
                            progress = 0.15
                        } else if isPlaying {
                            progress = min(progress + 0.14, 0.92)
                        }
                    }
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(accent.color))
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(title)
                            .font(.system(.caption, design: .default, weight: .semibold))
                            .foregroundStyle(NeonTheme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Text(isPlaying ? "Đang phát mẫu" : durationLabel)
                            .font(.system(.caption2, design: .default, weight: .medium))
                            .foregroundStyle(NeonTheme.textSecondary)
                    }

                    HStack(alignment: .center, spacing: 3) {
                        ForEach(Array(bars.enumerated()), id: \.offset) { index, height in
                            let filled = Double(index) / Double(bars.count) <= progress
                            Capsule()
                                .fill(filled ? accent.color : NeonTheme.border)
                                .frame(maxWidth: .infinity)
                                .frame(height: isPlaying ? max(8, height * (index.isMultiple(of: 2) ? 1.0 : 0.78)) : height * 0.72)
                        }
                    }
                    .frame(height: 26)
                }

                Button {
                    speedIndex = (speedIndex + 1) % speeds.count
                } label: {
                    Text(speeds[speedIndex])
                        .font(.system(.caption, design: .default, weight: .bold))
                        .foregroundStyle(accent.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(accent.softColor))
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 12) {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        progress = max(0.05, progress - 0.18)
                    }
                } label: {
                    Label("Lùi 3s", systemImage: "gobackward.5")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(NeonTheme.textSecondary)
                }
                .buttonStyle(.plain)

                Slider(value: $progress, in: 0...1)
                    .tint(accent.color)

                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        progress = 0.08
                        isPlaying = true
                    }
                } label: {
                    Label("Nghe lại", systemImage: "arrow.counterclockwise")
                        .font(.system(.caption, design: .default, weight: .semibold))
                        .foregroundStyle(accent.color)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(NeonTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(NeonTheme.border.opacity(0.8), lineWidth: 1)
        )
    }
}
