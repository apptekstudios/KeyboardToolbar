import UIKit

/// Toolbar to be displayed above the keyboard.
///
/// Set an instance of this view as the `inputAccessoryView` on a text view or text field to display tools above the keyboard.
public final class KeyboardToolbarView: UIInputView, UIInputViewAudioFeedback {
    /// Tool groups to be displayed in the toolbar.
    public var groups: [KeyboardToolGroup] = [] {
        didSet {
            reloadBarButtonItems()
        }
    }
    /// Duration a user should long press an item to present the tool picker.
    public var showToolPickerDelay: TimeInterval = 0.5 {
        didSet {
            if showToolPickerDelay != oldValue {
                for button in toolButtons {
                    button.showToolPickerDelay = showToolPickerDelay
                }
            }
        }
    }
    /// Enables clicks when selecting a tool.
    public var enableInputClicksWhenVisible: Bool {
        return true
    }

    private var toolbarLeadingConstraint: NSLayoutConstraint?
    private var toolbarTrailingConstraint: NSLayoutConstraint?
    private let toolbar: UIToolbar = {
        let this = UIToolbar()
        this.translatesAutoresizingMaskIntoConstraints = false
        this.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        this.setShadowImage(UIImage(), forToolbarPosition: .any)
        return this
    }()
    private var toolButtons: [KeyboardToolButton] {
        let items = toolbar.items ?? []
        return items.compactMap { barButtonItem in
            return barButtonItem.customView as? KeyboardToolButton
        }
    }

    /// Initializes a new toolbar to be shown above a keyboard.
    public init() {
        super.init(frame: .zero, inputViewStyle: .keyboard)
        setupView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        addSubview(toolbar)
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        toolbar.setContentCompressionResistancePriority(.required, for: .vertical)
        // Not using safeAreaLayoutGuide here as it is not set correctly on first open of keyboard
        let leading =  toolbar.leadingAnchor.constraint(equalTo: leadingAnchor)
        toolbarLeadingConstraint = leading
        let trailing = toolbar.trailingAnchor.constraint(equalTo: trailingAnchor)
        toolbarTrailingConstraint = trailing
        NSLayoutConstraint.activate([
           leading,
            trailing,
            toolbar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
           toolbar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -2)
        ])
        sizeToFit()
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        
        toolbarLeadingConstraint?.constant = InputToolMargin.rawValue
        toolbarTrailingConstraint?.constant = InputToolMargin.rawValue * -1
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsUpdateConstraints()
        sizeToFit()
    }
    
    public override var intrinsicContentSize: CGSize {
        return .zero
    }
}

private extension KeyboardToolbarView {
    private func reloadBarButtonItems() {
        let toolbarEdgePadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
        var barButtonItems: [UIBarButtonItem] = [.fixedSpace(-toolbarEdgePadding)]
        for (idx, group) in groups.enumerated() {
            for (idx, item) in group.items.enumerated() {
                let button = KeyboardToolButton(item: item)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.showToolPickerDelay = showToolPickerDelay
                barButtonItems += [UIBarButtonItem(customView: button)]
                if group.spacing != 0 && idx < group.items.count - 1 {
                    barButtonItems += [.fixedSpace(group.spacing)]
                }
            }
            if let fixedSpace = group.fixedSpaceAfter {
                barButtonItems += [.fixedSpace(fixedSpace)]
            } else if idx < groups.count - 1 {
                barButtonItems += [.flexibleSpace()]
            }
        }
        barButtonItems += [.fixedSpace(-toolbarEdgePadding)]
        toolbar.items = barButtonItems
    }
}
