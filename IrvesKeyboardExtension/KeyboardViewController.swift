import UIKit
import AudioToolbox

class KeyboardViewController: UIInputViewController {

    // MARK: - State
    enum KeyboardMode {
        case letters
        case numbers
        case stickers
        case emoji
    }

    enum Language {
        case mongolian
        case english
    }

    private var mode: KeyboardMode = .letters
    private var language: Language = .mongolian
    private var isShifted: Bool = false
    private var isCapsLock: Bool = false

    private var deleteTimer: Timer?
    private var deleteRepeatTimer: Timer?
    private var spacePanStart: CGPoint = .zero

    // MARK: - UI Elements
    private let mainStackView = UIStackView()
    private let toolbarView = UIStackView()
    private let rowsStackView = UIStackView()
    private var stickersCollectionView: UICollectionView?
    private var toastLabel: UILabel?

    // Stickers Data
    struct StickerItem: Codable {
        let id: String
        let src: String
        let label: String
        let category: String
        let unicode: String
    }
    private var stickers: [StickerItem] = []

    // Standard Emojis
    private let commonEmojis: [String] = [
        "😊", "😂", "🤣", "❤️", "😍", "🥰", "😘", "😭", "🥺", "😎",
        "👍", "👎", "👏", "🙏", "🔥", "✨", "🎉", "💯", "🇲🇳", "🌟",
        "💪", "🥳", "🤔", "🙄", "😴", "😷", "🤤", "🤯", "🥶", "🤩",
        "🤝", "✌️", "🤞", "🫶", "💔", "💖", "💙", "💛", "🌈", "☀️"
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStickers()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        renderCurrentMode()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        renderCurrentMode()
    }

    // MARK: - Data Loading
    private func loadStickers() {
        // Try to load stickers.json from bundle
        if let url = Bundle.main.url(forResource: "stickers", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let list = try? JSONDecoder().decode([StickerItem].self, from: data) {
            self.stickers = list
        } else {
            // Fallback list of 40 mascots
            self.stickers = (0...35).map { i in
                let id = String(format: "mascot-%02d", i)
                return StickerItem(id: id, src: "\(id).png", label: "Ирвэс \(i)", category: "mascot", unicode: "😊")
            }
        }
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = isDarkMode ? UIColor(white: 0.12, alpha: 1.0) : UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1.0)

        mainStackView.axis = .vertical
        mainStackView.spacing = 6
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])

        // 1. Top Toolbar
        setupToolbar()
        mainStackView.addArrangedSubview(toolbarView)

        // 2. Keyboard Rows Stack
        rowsStackView.axis = .vertical
        rowsStackView.spacing = 6
        rowsStackView.alignment = .fill
        rowsStackView.distribution = .fillEqually
        mainStackView.addArrangedSubview(rowsStackView)
    }

    private func setupToolbar() {
        toolbarView.axis = .horizontal
        toolbarView.spacing = 6
        toolbarView.distribution = .fill
        toolbarView.alignment = .center
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = "ИРВЭС"
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        titleLabel.textColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0) // Irves Blue
        toolbarView.addArrangedSubview(titleLabel)

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        toolbarView.addArrangedSubview(spacer)

        // Stickers Tab Button
        let btnStickers = createToolbarButton(title: "🐆 Гүемхэн") { [weak self] in
            self?.toggleMode(.stickers)
        }
        toolbarView.addArrangedSubview(btnStickers)

        // Emoji Tab Button
        let btnEmoji = createToolbarButton(title: "😊") { [weak self] in
            self?.toggleMode(.emoji)
        }
        toolbarView.addArrangedSubview(btnEmoji)

        // Keyboard Letters Button
        let btnLetters = createToolbarButton(title: "АБВ") { [weak self] in
            self?.mode = .letters
            self?.renderCurrentMode()
        }
        toolbarView.addArrangedSubview(btnLetters)
    }

    private func createToolbarButton(title: String, action: @escaping () -> Void) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        btn.tintColor = isDarkMode ? .white : UIColor(white: 0.15, alpha: 1.0)
        btn.backgroundColor = isDarkMode ? UIColor(white: 0.22, alpha: 1.0) : UIColor.white
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        btn.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return btn
    }

    // MARK: - Mode Switching
    private func toggleMode(_ target: KeyboardMode) {
        if mode == target {
            mode = .letters
        } else {
            mode = target
        }
        renderCurrentMode()
    }

    private func renderCurrentMode() {
        // Clear rows
        rowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stickersCollectionView?.removeFromSuperview()
        stickersCollectionView = nil

        switch mode {
        case .letters:
            renderLettersKeyboard()
        case .numbers:
            renderNumbersKeyboard()
        case .stickers:
            renderStickersGrid()
        case .emoji:
            renderEmojiGrid()
        }
    }

    // MARK: - Keyboards Layout Rendering
    private func renderLettersKeyboard() {
        let rows: [[String]]
        if language == .mongolian {
            rows = [
                ["ф", "ц", "у", "ж", "э", "н", "г", "ш", "ү", "з", "к", "ъ"],
                ["й", "ы", "б", "ө", "а", "х", "р", "о", "л", "д", "п"],
                ["я", "ч", "ё", "с", "м", "и", "т", "ь", "в", "ю"]
            ]
        } else {
            rows = [
                ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                ["z", "x", "c", "v", "b", "n", "m"]
            ]
        }

        // Row 1
        addRow(keys: rows[0])

        // Row 2
        addRow(keys: rows[1])

        // Row 3 with Shift & Delete
        let row3 = UIStackView()
        row3.axis = .horizontal
        row3.spacing = 4
        row3.distribution = .fillProportionally

        // Shift Key
        let shiftKey = createSpecialKey(title: isShifted ? (isCapsLock ? "⇪" : "⇧ ON") : "⇧", flex: 1.3) { [weak self] in
            self?.handleShift()
        }
        if isShifted {
            shiftKey.backgroundColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
            shiftKey.tintColor = .white
        }
        row3.addArrangedSubview(shiftKey)

        // Row 3 Letters
        for key in rows[2] {
            let keyBtn = createCharKey(title: key)
            row3.addArrangedSubview(keyBtn)
        }

        // Delete Key
        let delKey = createSpecialKey(title: "⌫", flex: 1.3) { [weak self] in
            self?.handleDelete()
        }
        setupDeleteLongPress(button: delKey)
        row3.addArrangedSubview(delKey)

        rowsStackView.addArrangedSubview(row3)

        // Bottom Row: 123 | Globe | Space (with Swipe) | . | Return
        renderBottomRow()
    }

    private func renderNumbersKeyboard() {
        let rows = [
            ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
            ["@", "#", "₮", "%", "&", "*", "(", ")", "-", "+"],
            ["_", "/", ":", ";", "\"", "'", "?", "!", ".", ","]
        ]

        addRow(keys: rows[0])
        addRow(keys: rows[1])

        let row3 = UIStackView()
        row3.axis = .horizontal
        row3.spacing = 4
        row3.distribution = .fillProportionally

        let numToggle = createSpecialKey(title: "#+=", flex: 1.3) { [weak self] in
            self?.playClickSound()
        }
        row3.addArrangedSubview(numToggle)

        for key in rows[2] {
            let keyBtn = createCharKey(title: key)
            row3.addArrangedSubview(keyBtn)
        }

        let delKey = createSpecialKey(title: "⌫", flex: 1.3) { [weak self] in
            self?.handleDelete()
        }
        setupDeleteLongPress(button: delKey)
        row3.addArrangedSubview(delKey)

        rowsStackView.addArrangedSubview(row3)

        renderBottomRow()
    }

    private func renderBottomRow() {
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 4
        bottomRow.distribution = .fill

        // 123 / АБВ toggle
        let modeBtn = createSpecialKey(title: mode == .numbers ? (language == .mongolian ? "АБВ" : "ABC") : "123", flex: 1.2) { [weak self] in
            guard let self = self else { return }
            self.mode = self.mode == .numbers ? .letters : .numbers
            self.renderCurrentMode()
        }
        modeBtn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        bottomRow.addArrangedSubview(modeBtn)

        // Globe / Next Keyboard
        let globeBtn = createSpecialKey(title: "🌐", flex: 1.0) { [weak self] in
            self?.advanceToNextInputMode()
        }
        globeBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bottomRow.addArrangedSubview(globeBtn)

        // Spacebar with drag gesture for language change
        let spaceLabel = language == .mongolian ? "‹ Монгол ›" : "‹ English ›"
        let spaceBtn = createSpaceKey(title: spaceLabel)
        bottomRow.addArrangedSubview(spaceBtn)

        // Comma or Period key
        let dotBtn = createCharKey(title: ".")
        dotBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bottomRow.addArrangedSubview(dotBtn)

        // Return Key
        let returnBtn = createSpecialKey(title: "↵", flex: 1.4) { [weak self] in
            self?.playClickSound()
            self?.textDocumentProxy.insertText("\n")
        }
        returnBtn.widthAnchor.constraint(equalToConstant: 64).isActive = true
        returnBtn.backgroundColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
        returnBtn.tintColor = .white
        bottomRow.addArrangedSubview(returnBtn)

        rowsStackView.addArrangedSubview(bottomRow)
    }

    private func addRow(keys: [String]) {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.spacing = 4
        rowStack.distribution = .fillEqually
        for key in keys {
            let keyBtn = createCharKey(title: key)
            rowStack.addArrangedSubview(keyBtn)
        }
        rowsStackView.addArrangedSubview(rowStack)
    }

    // MARK: - Key Creators
    private func createCharKey(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        let displayTitle = (isShifted || isCapsLock) ? title.uppercased() : title.lowercased()
        btn.setTitle(displayTitle, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        btn.tintColor = isDarkMode ? .white : .black
        btn.backgroundColor = isDarkMode ? UIColor(white: 0.28, alpha: 1.0) : .white
        btn.layer.cornerRadius = 5
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.25
        btn.layer.shadowRadius = 1
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)

        btn.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.playClickSound()
            self.triggerHaptic()
            self.textDocumentProxy.insertText(displayTitle)
            if self.isShifted && !self.isCapsLock {
                self.isShifted = false
                self.renderCurrentMode()
            }
        }, for: .touchUpInside)

        return btn
    }

    private func createSpecialKey(title: String, flex: CGFloat, action: @escaping () -> Void) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btn.tintColor = isDarkMode ? .white : UIColor(white: 0.1, alpha: 1.0)
        btn.backgroundColor = isDarkMode ? UIColor(white: 0.2, alpha: 1.0) : UIColor(red: 0.72, green: 0.74, blue: 0.76, alpha: 1.0)
        btn.layer.cornerRadius = 5
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 1
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)

        btn.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return btn
    }

    private func createSpaceKey(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.tintColor = isDarkMode ? UIColor(white: 0.8, alpha: 1.0) : UIColor(white: 0.3, alpha: 1.0)
        btn.backgroundColor = isDarkMode ? UIColor(white: 0.28, alpha: 1.0) : .white
        btn.layer.cornerRadius = 5
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowRadius = 1
        btn.layer.shadowOffset = CGSize(width: 0, height: 1)

        // Tap for space
        btn.addAction(UIAction { [weak self] _ in
            self?.playClickSound()
            self?.triggerHaptic()
            self?.textDocumentProxy.insertText(" ")
        }, for: .touchUpInside)

        // Swipe pan gesture for language switch
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleSpacePan(_:)))
        btn.addGestureRecognizer(pan)

        return btn
    }

    // MARK: - Gestures & Actions
    @objc private func handleSpacePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if gesture.state == .ended {
            if abs(translation.x) > 40 {
                // Switch language
                language = (language == .mongolian) ? .english : .mongolian
                triggerHaptic()
                renderCurrentMode()
            }
        }
    }

    private func handleShift() {
        triggerHaptic()
        if isShifted && !isCapsLock {
            isCapsLock = true
        } else if isCapsLock {
            isCapsLock = false
            isShifted = false
        } else {
            isShifted = true
        }
        renderCurrentMode()
    }

    private func handleDelete() {
        playClickSound()
        triggerHaptic()
        textDocumentProxy.deleteBackward()
    }

    private func setupDeleteLongPress(button: UIButton) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleDeleteLongPress(_:)))
        longPress.minimumPressDuration = 0.3
        button.addGestureRecognizer(longPress)
    }

    @objc private func handleDeleteLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            deleteRepeatTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { [weak self] _ in
                self?.handleDelete()
            }
        case .ended, .cancelled:
            deleteRepeatTimer?.invalidate()
            deleteRepeatTimer = nil
        default:
            break
        }
    }

    // MARK: - Stickers Grid
    private func renderStickersGrid() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(StickerCell.self, forCellWithReuseIdentifier: "StickerCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.heightAnchor.constraint(equalToConstant: 180).isActive = true

        stickersCollectionView = cv
        rowsStackView.addArrangedSubview(cv)
    }

    // MARK: - Emoji Grid
    private func renderEmojiGrid() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.heightAnchor.constraint(equalToConstant: 180).isActive = true

        rowsStackView.addArrangedSubview(cv)
    }

    // MARK: - Helpers & Feedback
    private var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }

    private func playClickSound() {
        AudioServicesPlaySystemSound(1104)
    }

    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    private func showToast(message: String) {
        toastLabel?.removeFromSuperview()
        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 32),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
        toastLabel = label

        UIView.animate(withDuration: 0.3, delay: 1.8, options: .curveEaseOut) {
            label.alpha = 0
        } completion: { _ in
            label.removeFromSuperview()
        }
    }
}

// MARK: - UICollectionView Data Source & Delegate
extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .stickers {
            return stickers.count
        } else {
            return commonEmojis.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if mode == .stickers {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
            let item = stickers[indexPath.item]
            cell.configure(with: item.id)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
            cell.configure(emoji: commonEmojis[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHaptic()
        if mode == .stickers {
            let item = stickers[indexPath.item]
            copyStickerToClipboard(id: item.id)
        } else {
            let emoji = commonEmojis[indexPath.item]
            playClickSound()
            textDocumentProxy.insertText(emoji)
        }
    }

    private func copyStickerToClipboard(id: String) {
        // Find image in Bundle
        if let imagePath = Bundle.main.path(forResource: id, ofType: "png", inDirectory: "Stickers") ?? Bundle.main.path(forResource: id, ofType: "png"),
           let image = UIImage(contentsOfFile: imagePath) {
            UIPasteboard.general.image = image
            showToast(message: "Гүемхэн хуулагдлаа! 📋 Чатдаа Paste хийнэ үү")
        } else {
            showToast(message: "Гүемхэн хуулагдлаа! 📋")
        }
    }
}

// MARK: - Sticker Cell
class StickerCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with id: String) {
        if let path = Bundle.main.path(forResource: id, ofType: "png", inDirectory: "Stickers") ?? Bundle.main.path(forResource: id, ofType: "png") {
            imageView.image = UIImage(contentsOfFile: path)
        } else {
            imageView.image = nil
        }
    }
}

// MARK: - Emoji Cell
class EmojiCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(emoji: String) {
        label.text = emoji
    }
}
