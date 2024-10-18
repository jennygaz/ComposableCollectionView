//
//  BentoCollectionViewController.swift
//  Bento
//
//  Created by Jenny Gallegos Cardenas on 16/10/24.
//

import UIKit

private let reuseIdentifier = "Cell"

final class BentoCollectionViewController: UIViewController {
    // MARK: - Types
    internal typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    internal typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    // MARK: - Properties
    private(set) var dataSource: UICollectionViewDiffableDataSource<Int, String>?
    private(set) var collectionView: UICollectionView?
    var elements: [String]
    var delegate: BentoCollectionViewDelegate?

    private var totalNumberOfSections: Int {
        let roundedResult = Double(Double(elements.count) / 4.0).rounded(.up)
        return Int(roundedResult)
    }

    private var numberOfItemsPerSection: Int { 4 }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        
        // Do any additional setup after loading the view.
    }
    
    init(elements: [String], delegate: BentoCollectionViewDelegate? = nil) {
        self.elements = elements
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    public func appendItems(_ receivedItems: [String]) {
        let toAdd = Array(Set(receivedItems).subtracting(Set(elements)))
        elements.append(contentsOf: toAdd)
        var snapshot = Snapshot()
        let snapshotElements = computeSectionsAndItems()
        snapshot.appendSections(snapshotElements.keys.sorted())
        snapshotElements.forEach { sectionIndex, values in
            snapshot.appendItems(values, toSection: sectionIndex)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    public func removeItems(_ receivedItems: [String]) {
        let toRemove = Array(Set(receivedItems).intersection(Set(elements)))
        elements.removeAll { toRemove.contains($0) }
        var snapshot = Snapshot()
        let snapshotElements = computeSectionsAndItems()
        snapshot.appendSections(snapshotElements.keys.sorted())
        snapshotElements.forEach { sectionIndex, values in
            snapshot.appendItems(values, toSection: sectionIndex)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    public func updateItems(diffingWith receivedItems: [String]) {
        let toRemove = Array(Set(elements).subtracting(Set(receivedItems)))
        let toAdd = Array(Set(receivedItems).subtracting(Set(elements)))
        guard !toRemove.isEmpty || !toAdd.isEmpty else { return }
        appendItems(toAdd)
        removeItems(toRemove)
    }

    // MARK: - Private Methods
    private func configureHierarchy() {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BentoCollectionViewCell.self, forCellWithReuseIdentifier: BentoCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
        self.collectionView = collectionView
    }

    private func computeSectionsAndItems() -> [Int: [String]] {
        let sections = Array(1...totalNumberOfSections)
        var indexOffset = 0
        var result: [Int: [String]] = [:]
        sections.dropLast().forEach { sectionIndex in
            let maxIndex = indexOffset + numberOfItemsPerSection
            let slice = Array(elements[indexOffset..<maxIndex])
            result[sectionIndex] = slice
            indexOffset += numberOfItemsPerSection
        }
        if indexOffset < elements.count {
            result[sections.last!] = Array(elements[indexOffset..<elements.count])
        }
        return result
    }
    
    private func configureDataSource() {
        guard let collectionView else { return }
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BentoCollectionViewCell.identifier, for: indexPath) as? BentoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: itemIdentifier)
            return cell
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        let sectionsAndItems = computeSectionsAndItems()
        snapshot.appendSections(sectionsAndItems.keys.sorted())
        sectionsAndItems.forEach { sectionIndex, values in
            snapshot.appendItems(values, toSection: sectionIndex)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
//extension BentoCollectionViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return Int(Double(Double(elements.count) / 4.0).rounded(.up))
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        
//        // Configure the cell
//        
//        return cell
//    }
//}

// MARK: - Layout
extension BentoCollectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { index, layoutEnvironment in
            let isOddSection = index % 2 == 1 // On true, place the tall cell at the end; otherwise, the opposite
            // Items
            let tallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / 3.0),
                heightDimension: .fractionalHeight(1.0)))
            tallItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let wideItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)))
            wideItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)))
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            // Groups
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.5)),
                repeatingSubitem: smallItem,
                count: 2)
            let wideGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(2.0 / 3.0),
                    heightDimension: .fractionalHeight(1.0)),
                subitems: [wideItem, horizontalGroup])
            
            // Put the section together
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0 / 3.0)),
                subitems: isOddSection ? [wideGroup, tallItem] : [tallItem, wideGroup])
            let section = NSCollectionLayoutSection(group: containerGroup)
            return section
            
        }, configuration: config)
        return layout
    }
}

extension BentoCollectionViewController: UICollectionViewDelegate {
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

@available(iOS 17, *)
#Preview("Bento") {
    let items: [String] = [
        "stock_image_01",
        "stock_image_02",
        "stock_image_03",
        "stock_image_04",
        "stock_image_05",
        "stock_image_06",
        "stock_image_07",
        "stock_image_08",
        "stock_image_09",
        "stock_image_10"
    ]
    let newItems: [String] = [
        "stock_image_01",
        "stock_image_02",
        "stock_image_03",
        "stock_image_04",
        "stock_image_05",
        "stock_image_07",
        "stock_image_08",
        "stock_image_09",
        "stock_image_10",
        "stock_image_11",
        "stock_image_12"
    ]
    let vc = BentoCollectionViewController(elements: items)
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        vc.updateItems(diffingWith: newItems)
    }
    return vc
}
