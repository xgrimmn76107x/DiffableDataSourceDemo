//
//  UIViewController+Diffable.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/21.
//
import UIKit

// MARK: - Snackbar

extension UIViewController {
    @objc var additionalBottomHeight: CGFloat { 0 }

    func showSnackbar(message: String, actionTitle: String? = nil, actionCallback: (() -> Void)? = nil) {
        let snackbar = Snackbar(message: message, actionTitle: actionTitle, actionCallback: actionCallback)
        view.addSubview(snackbar)
        snackbar.translatesAutoresizingMaskIntoConstraints = false
        snackbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        snackbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        let constant: CGFloat = additionalBottomHeight + 16
        snackbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
        let autoHide = actionTitle == nil
        snackbar.show {
            if autoHide {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    snackbar.hide()
                }
            }
        }
    }
}
