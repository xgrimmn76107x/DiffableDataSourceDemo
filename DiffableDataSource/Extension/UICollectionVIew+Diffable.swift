//
//  UICollectionVIew+Diffable.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/18.
//

import UIKit

extension UICollectionView {
    func registerCell(_ cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    /// Convenience function for registering cell to UITableView
    func registerCellNib(_ cellType: UICollectionViewCell.Type) {
        register(UINib(nibName: cellType.identifier, bundle: nil), forCellWithReuseIdentifier: cellType.identifier)
    }
    
    func registerHeaderNib(_ headerFooterType: UICollectionReusableView.Type) {
        register(UINib(nibName: headerFooterType.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerFooterType.identifier)
    }
    
    func registerFooterNib(_ headerFooterType: UICollectionReusableView.Type) {
        register(UINib(nibName: headerFooterType.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: headerFooterType.identifier)
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            fatalError("Error dequeuing cell for identifier \(Cell.identifier)")
        }
        return cell
    }
}

protocol TypeIdentifier {
    static var identifier: String { get }
}

extension TypeIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: TypeIdentifier {}

extension UIView: TypeIdentifier {}

protocol CellConfigurable {
    func setItem(_ item: CellItem)
}

protocol CellItem {}
