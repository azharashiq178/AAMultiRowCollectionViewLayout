//
//  UICollectionViewExtensions.swift
//  AAMultiRowCollectionViewLayoutExample
//
//  Created by muhammad azher on 18/07/2023.
//

import Foundation
import UIKit
extension UICollectionView {

    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.className, bundle: Bundle(for: cellType))
        register(nib, forCellWithReuseIdentifier: cellType.className)
    }
    
    func register(cellsType: [UICollectionViewCell.Type]) {
        cellsType.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T
        else {
            fatalError("Couldn't find UICollectionViewCell for \(T.className), make sure the cell is registered with table view")
        }
        return cell
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.className, for: indexPath) as? T
        else {
            fatalError("Couldn't find UICollectionViewCell for \(cellType.className), make sure the cell is registered with table view")
        }
        return cell
    }
}

extension UICollectionView {
    
    func registerView<T: UICollectionReusableView>(viewType: T.Type, ofKind: String) {
        let nib = UINib(nibName: viewType.className, bundle: Bundle(for: viewType))
        register(nib, forSupplementaryViewOfKind: ofKind, withReuseIdentifier: viewType.className)
    }
    
    func register(view: UICollectionReusableView.Type, ofKind: String) {
        registerView(viewType: view, ofKind: ofKind)
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(_ viewType: T.Type,
                                                            ofKind: String,
                                                            for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: viewType.className, for: indexPath) as? T
        else {
            fatalError("Couldn't find UICollectionViewCell for \(viewType.className), make sure the cell is registered with table view")
        }
        return cell
    }
}





protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
