//
//  Random+Diffable.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/21.
//
import UIKit

extension String {
    static func random(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in characters.randomElement()! })
    }

    static func random(lengthRange: ClosedRange<Int>) -> String {
        let length = Int.random(in: lengthRange)
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in characters.randomElement()! })
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0 ... 1),
            green: CGFloat.random(in: 0 ... 1),
            blue: CGFloat.random(in: 0 ... 1),
            alpha: 1.0
        )
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
