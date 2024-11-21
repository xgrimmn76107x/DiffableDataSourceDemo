//
//  UIView+Diffable.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/18.
//

import UIKit

extension UIStackView {
    func addArrangedSubview(_ view: UIView, withHeight height: CGFloat) {
        addArrangedSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

extension UIView {
    func pin(to container: UIView, with padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        frame = container.frame
        container.addSubview(self)

        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: padding.left).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -padding.right).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: padding.top).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: -padding.bottom).isActive = true
    }
    
    @discardableResult
    func setConstraint<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType>(
        _ keyPath: KeyPath<UIView, LayoutType>,
        _ relation: NSLayoutConstraint.Relation,
        to anchor: LayoutType,
        constant: CGFloat = 0,
        mutiplier: CGFloat? = nil,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        if let mutiplier = mutiplier,
           let dimension = self[keyPath: keyPath] as? NSLayoutDimension,
           let anchor = anchor as? NSLayoutDimension {
            switch relation {
            case .equal:
                constraint = dimension.constraint(equalTo: anchor, multiplier: mutiplier, constant: constant)
            case .greaterThanOrEqual:
                constraint = dimension.constraint(greaterThanOrEqualTo: anchor, multiplier: mutiplier, constant: constant)
            case .lessThanOrEqual:
                constraint = dimension.constraint(lessThanOrEqualTo: anchor, multiplier: mutiplier, constant: constant)
            default:
                constraint = NSLayoutConstraint()
            }
        } else {
            switch relation {
            case .equal:
                constraint = self[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
            case .greaterThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(greaterThanOrEqualTo: anchor, constant: constant)
            case .lessThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(lessThanOrEqualTo: anchor, constant: constant)
            default:
                constraint = NSLayoutConstraint()
            }
        }
        translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setConstraint(
        _ keyPath: KeyPath<UIView, NSLayoutDimension>,
        _ relation: NSLayoutConstraint.Relation,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        let dimension: NSLayoutDimension = self[keyPath: keyPath]
        switch relation {
        case .equal:
            constraint = dimension.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
        default:
            constraint = NSLayoutConstraint()
        }
        translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setAnchor(
        _ keyPath: KeyPath<UIView, NSLayoutDimension>,
        _ relation: NSLayoutConstraint.Relation,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> UIView {
        setConstraint(keyPath, relation, constant: constant, priority: priority)
        return self
    }

    @discardableResult
    func setAnchor<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType>(
        _ keyPath: KeyPath<UIView, LayoutType>,
        _ relation: NSLayoutConstraint.Relation,
        to anchor: LayoutType,
        constant: CGFloat = 0,
        mutiplier: CGFloat? = nil,
        priority: UILayoutPriority = .required
    ) -> UIView {
        setConstraint(keyPath, relation, to: anchor, constant: constant, mutiplier: mutiplier, priority: priority)
        return self
    }
}
