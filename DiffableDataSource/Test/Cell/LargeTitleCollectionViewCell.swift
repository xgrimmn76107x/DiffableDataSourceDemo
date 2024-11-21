//
//  LargeTitleCollectionViewCell.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/21.
//

import UIKit

class LargeTitleCollectionViewCellItem: CellItem, Hashable {
    var text: String
    var textColor: UIColor
    
    init(text: String, textColor: UIColor = .label) {
        self.text = text
        self.textColor = textColor
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: LargeTitleCollectionViewCellItem, rhs: LargeTitleCollectionViewCellItem) -> Bool {
        lhs.text == rhs.text
    }
}

class LargeTitleCollectionViewCell: UICollectionViewCell, CellConfigurable {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setItem(_ item: CellItem) {
        guard let item = item as? LargeTitleCollectionViewCellItem else { return }
        titleLabel.text = item.text
        titleLabel.textColor = item.textColor
    }

}
