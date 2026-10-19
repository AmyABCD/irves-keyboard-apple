import SwiftUI

struct StickerItem: Identifiable, Codable {
    let id: String
    let src: String
    let label: String
    let category: String
    let unicode: String
}

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var testText = ""
    @State private var toastMessage: String?
    @State private var stickers: [StickerItem] = []

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Bar
                HStack(spacing: 12) {
                    Image(systemName: "keyboard.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.blue)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("ИРВЭС ГАР")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.primary)
                        Text("Монгол · English · 54 Гүемхэн стикер")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button(action: openSettings) {
                        Label("Тохиргоо", systemImage: "gearshape.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.12))
                            .foregroundColor(.blue)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(UIColor.secondarySystemBackground))

                // Picker Tabs
                Picker("Хэсэг", selection: $selectedTab) {
                    Text("Заавар").tag(0)
                    Text("Турших").tag(1)
                    Text("Гүемхэн (54)").tag(2)
                    Text("Mac хувилбар").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                // Tab Content
                TabView(selection: $selectedTab) {
                    instructionsView.tag(0)
                    testTypingView.tag(1)
                    stickersGridView.tag(2)
                    macGuideView.tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationBarHidden(true)
            .overlay(
                // Toast overlay
                Group {
                    if let msg = toastMessage {
                        VStack {
                            Spacer()
                            Text(msg)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.black.opacity(0.85))
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .padding(.bottom, 24)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            )
            .onAppear(perform: loadStickers)
        }
    }

    // MARK: - 1. Instructions View
    private var instructionsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Banner
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                        Text("iPhone / iPad дээр гарыг асаах заавар")
                            .font(.system(size: 16, weight: .bold))
                    }
                    Text("Ирвэс гарыг суулгасны дараа iOS-ийн тохиргоонд нэг удаа бүртгэж идэвхжүүлнэ.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.08))
                .cornerRadius(12)

                // Step 1
                HStack(alignment: .top, spacing: 14) {
                    CircleStepNumber(number: "1")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Тохиргоо руу орох")
                            .font(.system(size: 15, weight: .bold))
                        Text("iPhone-ийн **Settings (Тохиргоо) -> General (Ерөнхий) -> Keyboard (Гар) -> Keyboards (Гарууд)** цэс рүү орно.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                // Step 2
                HStack(alignment: .top, spacing: 14) {
                    CircleStepNumber(number: "2")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ирвэс гарыг нэмэх")
                            .font(.system(size: 15, weight: .bold))
                        Text("**Add New Keyboard... (Шинэ гар нэмэх)** товчийг дараад жагсаалтаас **Ирвэс (Irves Keyboard)**-г сонгоно.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                // Step 3
                HStack(alignment: .top, spacing: 14) {
                    CircleStepNumber(number: "3")
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Бүтэн эрх олгох (Allow Full Access)")
                            .font(.system(size: 15, weight: .bold))
                        Text("Нэмэгдсэн **Ирвэс** дээр дарж **Allow Full Access (Бүтэн эрх олгох)**-г асаана. Энэ нь стикер зургийг түр санах ой руу (Clipboard) хуулж Messenger, Telegram, WhatsApp руу шууд наах боломжийг олгоно.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                // Quick Launch Button
                Button(action: openSettings) {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.up.right.square.fill")
                        Text("Тохиргоо нээх")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                // Feature Highlights
                VStack(alignment: .leading, spacing: 10) {
                    Text("Онцлог боломжууд:")
                        .font(.system(size: 15, weight: .bold))

                    FeatureRow(icon: "hand.draw.fill", title: "Spacebar шударч хэл солих", desc: "Монгол ба Англи хэлийг зайны товч дээр хуруугаараа зүүн/баруун чирч хурдан сэлгэнэ.")
                    FeatureRow(icon: "face.smiling.fill", title: "54 Ирвэс Стикер", desc: "Стикер цэснээс сонгоод чатдаа шууд Paste хийнэ.")
                    FeatureRow(icon: "speaker.wave.2.fill", title: "Дуу болон чичиргээ", desc: "Товч дарахад хүрэлцэх мэдрэмж (Haptic feedback) өгнө.")
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding(16)
        }
    }

    // MARK: - 2. Test Typing View
    private var testTypingView: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Энд туршиж бичнэ үү:")
                    .font(.system(size: 15, weight: .bold))
                Text("Доорх талбар дээр товшиход Ирвэс гар гарч ирнэ. Space дээр хуруугаа чирч хэлээ сольж, стикер дээр дарж үзээрэй.")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 12)

            TextEditor(text: $testText)
                .padding(8)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 16)

            HStack {
                Button(action: { testText = "" }) {
                    Label("Арилгах", systemImage: "trash")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.red)
                }
                Spacer()
                Button(action: {
                    UIPasteboard.general.string = testText
                    showToast("Текст хуулагдлаа! 📋")
                }) {
                    Label("Текст хуулах", systemImage: "doc.on.doc")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 18)

            Spacer()
        }
    }

    // MARK: - 3. Stickers Grid View
    private var stickersGridView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Гүем, Гүемхэн стикерийн цомог (Нийт \(stickers.count))")
                    .font(.system(size: 15, weight: .bold))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                Text("Гүемхэн дээрээ товшиж түр санах ойд хуулаад Messenger, Instagram, Telegram чатандаа нааж (Paste) болно.")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)

                let columns = [
                    GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 12)
                ]

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(stickers) { item in
                        VStack(spacing: 4) {
                            if let img = loadStickerImage(named: item.id) {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(width: 70, height: 70)
                                    .overlay(Text(item.unicode).font(.title))
                            }
                            Text(item.label)
                                .font(.system(size: 10, weight: .medium))
                                .lineLimit(1)
                                .foregroundColor(.primary)
                        }
                        .padding(6)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .onTapGesture {
                            copySticker(item: item)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 24)
        }
    }

    // MARK: - 4. Mac Guide View
    private var macGuideView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "laptopcomputer")
                        .font(.title2)
                        .foregroundColor(.purple)
                    Text("macOS (MacBook, iMac) дээр суулгах")
                        .font(.system(size: 16, weight: .bold))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.purple.opacity(0.08))
                .cornerRadius(12)

                Text("Mac компьютер дээр Ирвэс гарын байрлалыг ашиглахад ямар нэг апп суулгах шаардлагагүй. macOS-ийн системийн түвшинд ажилладаг `Irves_Mongolian.keylayout` файлыг ашиглана.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Суулгах 3 алхам:")
                        .font(.system(size: 15, weight: .bold))

                    HStack(alignment: .top, spacing: 10) {
                        Text("1.")
                            .fontWeight(.bold)
                        Text("Finder нээгээд дээрх цэснээс **Go -> Go to Folder...** (эсвэл **Cmd + Shift + G**) дарна.")
                    }
                    HStack(alignment: .top, spacing: 10) {
                        Text("2.")
                            .fontWeight(.bold)
                        Text("`~/Library/Keyboard Layouts/` гэж бичээд Enter дарна. Гарч ирсэн хавтас руу `Irves_Mongolian.keylayout` файлыг хуулж тавина.")
                    }
                    HStack(alignment: .top, spacing: 10) {
                        Text("3.")
                            .fontWeight(.bold)
                        Text("**System Settings -> Keyboard -> Text Input -> Input Sources -> Edit...** цэс рүү ороод **+** дарж, **Others** хэсгээс **Irves Mongolian**-г сонгоод Add дарна.")
                    }
                }
                .font(.system(size: 14))
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)

                Text("Таны Mac дээр стандарт Монгол кирилл гарын байрлал идэвхжиж, `Control + Space` товчоор хэлээ сольж ашиглах боломжтой болно!")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
    }

    // MARK: - Actions & Helpers
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func showToast(_ msg: String) {
        withAnimation {
            toastMessage = msg
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                toastMessage = nil
            }
        }
    }

    private func copySticker(item: StickerItem) {
        if let img = loadStickerImage(named: item.id) {
            UIPasteboard.general.image = img
            showToast("'\(item.label)' стикер хуулагдлаа! 📋")
        } else {
            showToast("Стикер хуулагдлаа! 📋")
        }
    }

    private func loadStickerImage(named id: String) -> UIImage? {
        if let path = Bundle.main.path(forResource: id, ofType: "png", inDirectory: "Stickers") ?? Bundle.main.path(forResource: id, ofType: "png") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }

    private func loadStickers() {
        if let url = Bundle.main.url(forResource: "stickers", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let list = try? JSONDecoder().decode([StickerItem].self, from: data) {
            self.stickers = list
        } else {
            self.stickers = (0...35).map { i in
                let id = String(format: "mascot-%02d", i)
                return StickerItem(id: id, src: "\(id).png", label: "Ирвэс \(i)", category: "mascot", unicode: "😊")
            }
        }
    }
}

// MARK: - Supporting Views
struct CircleStepNumber: View {
    let number: String
    var body: some View {
        Text(number)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 26, height: 26)
            .background(Color.blue)
            .clipShape(Circle())
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let desc: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
