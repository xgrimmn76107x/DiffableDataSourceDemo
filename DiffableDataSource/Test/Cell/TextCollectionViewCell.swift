//
//  TestCollectionViewCell.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/18.
//

import UIKit

class TextCollectionCellItem: CellItem, Hashable {
    var text: String
    var textColor: UIColor
    
    init(text: String, textColor: UIColor = .label) {
        self.text = text
        self.textColor = textColor
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: TextCollectionCellItem, rhs: TextCollectionCellItem) -> Bool {
        lhs.text == rhs.text
    }
}

class TextCollectionViewCell: UICollectionViewCell, CellConfigurable {
    @IBOutlet var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setItem(_ item: CellItem) {
        guard let item = item as? TextCollectionCellItem else { return }
        textLabel.text = item.text
        textLabel.textColor = item.textColor
    }
}
