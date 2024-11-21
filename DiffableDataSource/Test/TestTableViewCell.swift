//
//  TestTableViewCell.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/18.
//

import UIKit

struct TestCellItem: Hashable {
    let text: String
}

class TestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setItem(_ item: TestCellItem) {
        
    }
}
