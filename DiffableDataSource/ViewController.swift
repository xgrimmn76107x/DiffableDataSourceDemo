//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by JayHsia on 2024/11/18.
//

import UIKit

struct Child: Hashable {
    let item: String
}

struct Parent: Hashable {
    let item: String
    let childItems: [Child]
}

enum OutlineItem: Hashable {
    case parent(Parent)
    case child(Child)
}

class ViewController: UIViewController {
    typealias Snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>
    typealias DataSource = UICollectionViewDiffableDataSource<String, OutlineItem>
    
    var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        initVariable()
    }
    
    private func initVariable() {
        collectionView.dataSource = dataSource

        var sectionSnapshot = Snapshot()
        
        let dataArray: [Parent] = [
            .init(item: "First", childItems: Array(0 ... 4).map { Child(item: String($0)) }),
            .init(item: "Second", childItems: Array(5 ... 10).map { Child(item: String($0)) }),
            .init(item: "Third", childItems: Array(11 ... 13).map { Child(item: String($0)) }),
        ]

        for data in dataArray {
            let header = OutlineItem.parent(data)
            sectionSnapshot.append([header])
            sectionSnapshot.append(data.childItems.map { OutlineItem.child($0) }, to: header)

            sectionSnapshot.expand([header])
        }
        dataSource.apply(sectionSnapshot, to: "Root", animatingDifferences: false, completion: nil)
        
        dataSource.reorderingHandlers.canReorderItem = { _ in true }
        dataSource.reorderingHandlers.didReorder = { transaction in
            
        }
    }
    
    private func initLayout() {
        view.addSubview(collectionView)
        collectionView
            .setAnchor(\.topAnchor, .equal, to: view.topAnchor)
            .setAnchor(\.bottomAnchor, .equal, to: view.bottomAnchor)
            .setAnchor(\.leadingAnchor, .equal, to: view.leadingAnchor)
            .setAnchor(\.trailingAnchor, .equal, to: view.trailingAnchor)
    }
    
    func makeDataSource() -> DataSource {
        let parentRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Parent> { cell, _, item in
                
            var content = cell.defaultContentConfiguration()
            content.text = item.item
            cell.contentConfiguration = content
                
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerDisclosureOption)]
        }

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Child> { cell, _, item in
                
            var content = cell.defaultContentConfiguration()
            content.text = item.item
            cell.indentationLevel = 2
            cell.contentConfiguration = content
            cell.accessories = [.reorder(displayed: .always)]
        }
            
        return DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case .parent(let parentItem):
                    let cell = collectionView.dequeueConfiguredReusableCell(
                        using: parentRegistration,
                        for: indexPath,
                        item: parentItem
                    )
                    return cell

                case .child(let childItem):
                    let cell = collectionView.dequeueConfiguredReusableCell(
                        using: cellRegistration,
                        for: indexPath,
                        item: childItem
                    )
                    return cell
                }
            }
        )
    }
}
