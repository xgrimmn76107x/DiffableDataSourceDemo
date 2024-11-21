//
//  SnackBar.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/21.
//

import UIKit

private let kInOffset: CGFloat = 50
private let kOutOffset: CGFloat = 100

class Snackbar: UIView {
    typealias ActionCallback = () -> Void

    private let container: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 12
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private let actionTitle: String?
    private let actionCallback: ActionCallback?
    
    init(message: String, actionTitle: String? = nil, actionCallback: ActionCallback? = nil) {
        self.actionTitle = actionTitle
        self.actionCallback = actionCallback
        
        super.init(frame: .zero)
        initLayout()
        setMessage(message)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initLayout() {
        backgroundColor = UIColor.black
        layer.cornerRadius = 4
        layer.cornerCurve = .continuous
        clipsToBounds = true
        container.addArrangedSubview(label)
        
        var inset: UIEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    
        if let actionTitle {
            container.addArrangedSubview(actionButton(title: actionTitle), withHeight: 32)
            inset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        }
        
        container.pin(to: self, with: inset)
    }
    
    private func actionButton(title: String) -> UIButton {
        var configuration: UIButton.Configuration = .plain()
        configuration.title = title
        configuration.titleAlignment = .center
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { input in
            var output = input
            output.font = .systemFont(ofSize: 16)
            return output
        }
        configuration.baseForegroundColor = .systemRed
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)

        let button: UIButton = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(clickedActionButton), for: .touchUpInside)
        button.configurationUpdateHandler = { sender in
            switch sender.state {
            case .normal:
                sender.alpha = 1
            case .highlighted, .selected:
                sender.alpha = 0.6
            default: break
            }
        }
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }

    private func setMessage(_ message: String) {
        label.text = message
    }
    
    @objc private func clickedActionButton() {
        actionCallback?()
        hide()
    }
    
    // MARK: Public
    
    func show(completion: (() -> Void)? = nil) {
        alpha = 0.5
        transform = transform.translatedBy(x: 0, y: kInOffset)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
            transform = .identity
            alpha = 1.0
        } completion: { position in
            if position == .end {
                completion?()
            }
        }
    }
    
    func hide() {
        alpha = 1
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
            transform = transform.translatedBy(x: 0, y: kOutOffset)
            alpha = 0.2
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
