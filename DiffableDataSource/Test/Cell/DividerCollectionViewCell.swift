//
//  DividerCollectionViewCell.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/20.
//

import UIKit

struct DividerCollectionCellItem: CellItem {
    let color: UIColor
    let constant: CGFloat

    init(color: UIColor = .systemGray5, constant: CGFloat = 1) {
        self.color = color
        self.constant = constant
    }
}

class DividerCollectionViewCell: UICollectionViewCell, CellConfigurable {
    @IBOutlet var dividerView: UIView!
    @IBOutlet var dividerViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setItem(_ item: CellItem) {
        guard let item = item as? DividerCollectionCellItem else { return }
        dividerView.backgroundColor = item.color
        dividerViewHeightConstraint.constant = item.constant
    }
}
