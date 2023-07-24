//
//  CollectionViewController.swift
//  AAMultiRowCollectionViewLayoutExample
//
//  Created by muhammad azher on 18/07/2023.
//

import UIKit
import AAMultiRowCollectionViewLayout

private let reuseIdentifier = "CollectionViewCell"

class CollectionViewController: UICollectionViewController {

    
    var list = [String]()
    
    var shouldReloadSection = false
    var layout = AAMultiRowCollectionViewLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        list.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's")
        list.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,")
        list.append("but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
        list.append("Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur,")
        list.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's")
        list.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's")
        list.append("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's")
        
        
        collectionView.register(cellType: TagCollectionViewCell.self)
        collectionView.collectionViewLayout = layout.createLayout(delegate: self, in: self.collectionView)
        
        collectionView.backgroundColor = .white.withAlphaComponent(0.2)

        // Do any additional setup after loading the view.
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
    
        // Configure the cell
        let str = list[indexPath.item]
        if indexPath.section % 2 == 0 {
            cell.titleLabel.text = str
            cell.titleLabel.numberOfLines = 0
        }
        else {
            cell.titleLabel.text = "Tag \(indexPath.item)"
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableView(HeaderCollectionReusableView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            headerView.titleLabel.text = "Section Header \(indexPath.section)"
            headerView.titleLabel.textColor = .white
            return headerView
        }
        else if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableView(FooterCollectionReusableView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
            footerView.titleLabel.text = "Section Footer \(indexPath.section)"
            footerView.titleLabel.textColor = .white
            return footerView
        }
        return UICollectionReusableView()
    }
}






extension CollectionViewController: AAMultiRowCollectionViewLayoutDelegate {
    func sizeForItemAt(section: Int) -> NSCollectionLayoutSize {
        if section == 0 {
            return .init(widthDimension: .absolute(self.collectionView.frame.width - 40), heightDimension: .absolute(80))
        }
        else if section % 2 == 0 {
            return .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        }
        return .init(widthDimension: .estimated(100), heightDimension: .absolute(44))
    }
    func contentInsets(for section: Int) -> NSDirectionalEdgeInsets {
        return .init(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    func spacingBetweenItems(in section: Int) -> CGFloat {
        return 5
    }
    func scrollingBehavior(in section: Int) -> ScrollingBehavior {
        if section == 0 {
            return .horizontal
        }
        if section % 2 == 0 {
            return .vertical
        }
        return .horizontal
    }
    func heightForHeader(in section: Int) -> CGFloat {
        return 44
    }
    func heightForFooter(in section: Int) -> CGFloat {
        return 44
    }
    func spacingBetweenSections() -> CGFloat {
        return 5
    }
    func numberOfRows(in section: Int) -> Int {
        if section == 0 { return 3 }
        return 1
    }
    
    func registerHeadersInLayout() -> [UICollectionReusableView.Type] {
        return [HeaderCollectionReusableView.self]
    }
    func registerFootersInLayout() -> [UICollectionReusableView.Type] {
        return [FooterCollectionReusableView.self]
    }
    func registerSectionBackgroundViewsInLayout() -> [UICollectionReusableView.Type] {
        return [OddSectionBackgroundView.self]
    }
    
    func registerSectionBackgroundViewInLayout(in section: Int) -> UICollectionReusableView.Type? {
        if section == 0 {
            return nil
        }
        return OddSectionBackgroundView.self
    }
}
