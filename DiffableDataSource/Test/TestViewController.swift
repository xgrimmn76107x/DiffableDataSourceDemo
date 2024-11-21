//
//  TestViewController.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/18.
//

import UIKit

class TestListRow: Hashable {
    let id: String
    var item: TestCellDataSource
    
    init(id: String = UUID().uuidString, item: TestCellDataSource) {
        self.id = id
        self.item = item
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TestListRow, rhs: TestListRow) -> Bool {
        return lhs.id == rhs.id
    }
}

protocol TestCellDataSource: CellItem {
    func getType() -> TestViewController.DataSourceType
}

class TestViewController: UIViewController {
    enum DataSourceType: CaseIterable {
        case text
        case largeTitle
        
        var title: String {
            switch self {
            case .text:
                return "Text Cell"
            case .largeTitle:
                return "Large Title Cell"
            }
        }
    }
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TestListRow>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, TestListRow>

    private lazy var dataSource: DataSource = makeDataSource()
    private var counter: Int = 0
    private var selectCellItem: DataSourceType = .text {
        didSet {
            selectCellItemButton.setTitle(selectCellItem.title, for: .normal)
        }
    }
    
    @IBOutlet var selectCellItemButton: UIButton!
    @IBOutlet var indexTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVariable()
        initLayout()
        applySnapshot()
    }
    
    private func initVariable() {
        DataSourceType.allCases.forEach { collectionView.registerCellNib(cellClass(for: $0)) }
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        
        selectCellItem = .text
        let options = DataSourceType.allCases.map {
            return switch $0 {
            case .text:
                UIAction(title: "Text", image: UIImage(systemName: "text.badge.plus")) { _ in
                    self.selectCellItem = .text
                }
            case .largeTitle:
                UIAction(title: "Large Title", image: UIImage(systemName: "text.badge.plus")) { _ in
                    self.selectCellItem = .largeTitle
                }
            }
        }
        let menu = UIMenu(title: "選擇一個選項", children: options)
        selectCellItemButton.menu = menu
        selectCellItemButton.showsMenuAsPrimaryAction = true
    }
    
    private func initLayout() {
        addButton.layer.cornerRadius = 5
        removeButton.layer.cornerRadius = 5
        selectCellItemButton.layer.cornerRadius = 5
    }
    
    func cellClass(for type: DataSourceType) -> UICollectionViewCell.Type {
        switch type {
        case .text: return TextCollectionViewCell.self
        case .largeTitle: return LargeTitleCollectionViewCell.self
        }
    }
    
    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, row in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellClass(for: row.item.getType()).identifier, for: indexPath)
            if let cell = cell as? CellConfigurable {
                cell.setItem(row.item)
            }
            return cell
        }
    }
    
    private func makeDataSourceCellRegistration() -> DataSource {
        let testCellRegistration = UICollectionView.CellRegistration<TextCollectionViewCell, TestCellDataSource>(cellNib: .init(nibName: TextCollectionViewCell.identifier, bundle: nil)) { cell, _, item in
            cell.setItem(item)
        }
        let largeTitleCellRegistration = UICollectionView.CellRegistration<LargeTitleCollectionViewCell, TestCellDataSource>(cellNib: .init(nibName: LargeTitleCollectionViewCell.identifier, bundle: nil)) { cell, _, item in
            cell.setItem(item)
        }
        return DataSource(collectionView: collectionView) { collectionView, indexPath, row in
            switch row.item.getType() {
            case .text:
                return collectionView.dequeueConfiguredReusableCell(using: testCellRegistration, for: indexPath, item: row.item)
            case .largeTitle:
                return collectionView.dequeueConfiguredReusableCell(using: largeTitleCellRegistration, for: indexPath, item: row.item)
            }
        }
    }
    
    private func applySnapshot() {
        counter += 2
        let dataArray: [TestListRow] = [
            .init(item: LargeTitleCollectionViewCellItem(text: "Large Title")),
            .init(item: TextCollectionCellItem(text: "\(counter)")),
        ]
        DispatchQueue.main.async { [self] in
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(dataArray)
            dataSource.apply(snapshot)
        }
    }
    
    private func addNewItem(after afterItem: TestListRow) {
        var snapshot = dataSource.snapshot()
        counter += 1
        let item: TestListRow = switch selectCellItem {
        case .text:
            .init(item: TextCollectionCellItem(text: "Item #\(counter)"))
        case .largeTitle:
            .init(item: LargeTitleCollectionViewCellItem(text: "Item #\(counter)"))
        }
        snapshot.insertItems([item], afterItem: afterItem)
        dataSource.apply(snapshot)
    }
    
    private func appendItem(_ item: TestListRow) {
        var snapshot = dataSource.snapshot()
        counter += 1
        snapshot.appendItems([item])
        dataSource.apply(snapshot)
    }
    
    private func removeItem(_ item: TestListRow) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([item])
        dataSource.apply(snapshot)
    }
    
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index <= dataSource.snapshot().itemIdentifiers.count
    }
    
    @IBAction func clickAddItemButton(_ sender: Any) {
        guard let text = indexTextField.text,
              let index = Int(text),
              isValidIndex(index) else {
            showSnackbar(message: "Index out of range (0-\(dataSource.snapshot().itemIdentifiers.count - 1))")
            return
        }
        if let item = dataSource.snapshot().itemIdentifiers[safe: index] {
            addNewItem(after: item)
        } else {
            let item: TestListRow = switch selectCellItem {
            case .text:
                .init(item: TextCollectionCellItem(text: "Item #\(counter)"))
            case .largeTitle:
                .init(item: LargeTitleCollectionViewCellItem(text: "Item #\(counter)"))
            }
            appendItem(item)
        }
    }
    
    @IBAction func clickRemoveItemButton(_ sender: UIButton) {
        guard let text = indexTextField.text,
              let index = Int(text),
              let item = dataSource.snapshot().itemIdentifiers[safe: index] else {
            showSnackbar(message: "Index out of range (0-\(dataSource.snapshot().itemIdentifiers.count))")
            return
        }
        removeItem(item)
    }
}

extension TestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let row = dataSource.itemIdentifier(for: indexPath), let textItem = row.item as? TextCollectionCellItem else { return }
        textItem.textColor = .random()
        textItem.text = .random(lengthRange: 5...200)
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([row])
        dataSource.apply(snapshot)
    }
}

// MARK: - CellItem Extensions

extension TextCollectionCellItem: TestCellDataSource {
    func getType() -> TestViewController.DataSourceType { .text }
}

extension LargeTitleCollectionViewCellItem: TestCellDataSource {
    func getType() -> TestViewController.DataSourceType { .largeTitle }
}
