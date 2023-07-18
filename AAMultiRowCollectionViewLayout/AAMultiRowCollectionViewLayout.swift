//
//  AAMultiRowCollectionViewLayout.swift
//  AAMultiRowCollectionViewLayout
//
//  Created by muhammad azher on 18/07/2023.
//

import UIKit

public protocol AAMultiRowCollectionViewLayoutDelegate: AnyObject {
    func sizeForItemAt(section: Int) -> NSCollectionLayoutSize
    func contentInsets(for section: Int) -> NSDirectionalEdgeInsets
    func spacingBetweenItems(in section: Int) -> CGFloat
    func scrollingBehavior(in section: Int) -> ScrollingBehavior
    func heightForHeader(in section: Int) -> CGFloat
    func heightForFooter(in section: Int) -> CGFloat
    func spacingBetweenSections() -> CGFloat
    func numberOfRows(in section: Int) -> Int
    func spacingBetweenRows(in section: Int) -> CGFloat
    func registerHeadersInLayout() -> [UICollectionReusableView.Type]
    func registerFootersInLayout() -> [UICollectionReusableView.Type]
    func registerSectionBackgroundViewsInLayout() -> [UICollectionReusableView.Type]
}

extension AAMultiRowCollectionViewLayoutDelegate {
    public func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    public func spacingBetweenSections() -> CGFloat {
        return 5
    }
    
    public func heightForFooter(in section: Int) -> CGFloat {
        return 44
    }
    
    public func heightForHeader(in section: Int) -> CGFloat {
        return 44
    }
    
    public func scrollingBehavior(in section: Int) -> ScrollingBehavior {
        return .vertical
    }
    
    public func spacingBetweenItems(in section: Int) -> CGFloat {
        return 5
    }
    
    public func contentInsets(for section: Int) -> NSDirectionalEdgeInsets {
        return .zero
    }
    
    public func spacingBetweenRows(in section: Int) -> CGFloat {
        return 5
    }
    public func registerSectionBackgroundViewsInLayout() -> [UICollectionReusableView.Type] {
        return []
    }
    public func registerFootersInLayout() -> [UICollectionReusableView.Type] {
        return []
    }
    public func registerHeadersInLayout() -> [UICollectionReusableView.Type] {
        return []
    }
}

public enum ScrollingBehavior {
    case horizontal
    case vertical
}

public class AAMultiRowCollectionViewLayout: UICollectionViewLayout {
    private var layoutDelegate: AAMultiRowCollectionViewLayoutDelegate?
    public var configuration: AAMultiRowCollectionViewLayoutConfiguration?
    
    public override init() {
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createLayout(
        delegate: AAMultiRowCollectionViewLayoutDelegate, in collectionView: UICollectionView
    ) -> UICollectionViewLayout {
        layoutDelegate = delegate
        let layoutConfiguration = AAMultiRowCollectionViewLayoutConfiguration()
        if let headers = layoutDelegate?.registerHeadersInLayout() {
            layoutConfiguration.sectionHeaderIdentifiers = headers
            for header in headers {
                collectionView.register(view: header.self, ofKind: UICollectionView.elementKindSectionHeader)
            }
        }
        if let footers = layoutDelegate?.registerFootersInLayout() {
            layoutConfiguration.sectionFooterIdentifiers = footers
            for footer in footers {
                collectionView.register(view: footer.self, ofKind: UICollectionView.elementKindSectionFooter)
            }
        }
        layoutConfiguration.sectionBackgroundIdentifiers = layoutDelegate?.registerSectionBackgroundViewsInLayout()
        
        configuration = layoutConfiguration
        
        
        let layout = configuration?.createLayout(layoutDelegate: layoutDelegate) ?? UICollectionViewLayout()
        registerSupplementaryViews(with: layout)
        
        return layout
    }
    
    private func registerSupplementaryViews(with layout: UICollectionViewLayout) {
        configuration?.registerSupplementaryViews(with: layout)
    }
}

public class AAMultiRowCollectionViewLayoutConfiguration {
    public var sectionHeaderIdentifiers: [UICollectionReusableView.Type]?
    public var sectionFooterIdentifiers: [UICollectionReusableView.Type]?
    public var sectionBackgroundIdentifiers: [UICollectionReusableView.Type]?
    
    public init() {}
    
    public func createLayout(layoutDelegate: AAMultiRowCollectionViewLayoutDelegate?) -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = layoutDelegate?.spacingBetweenSections() ?? 0
//        config.contentInsetsReference = .safeArea
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            
            let layoutSize = layoutDelegate?.sizeForItemAt(section: sectionIndex) ?? NSCollectionLayoutSize(
                widthDimension: .estimated(1),
                heightDimension: .estimated(1)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            
            let numberOfRowsInSection = layoutDelegate?.numberOfRows(in: sectionIndex) ?? 1
            if numberOfRowsInSection > 1 {
                item.contentInsets.bottom = layoutDelegate?.spacingBetweenRows(in: sectionIndex) ?? 0
            }
            
            var groups: [NSCollectionLayoutGroup] = []
            for _ in 0..<numberOfRowsInSection {
                let innerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: layoutSize.widthDimension,
                        heightDimension: layoutSize.heightDimension
                    ),
                    subitems: [item]
                )
                groups.append(innerGroup)
            }
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: layoutSize.widthDimension,
                    heightDimension: numberOfRowsInSection == 1 ? layoutSize.heightDimension : .absolute(layoutSize.heightDimension.dimension * CGFloat(numberOfRowsInSection))
                ),
                subitems: groups
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            if let behavior = layoutDelegate?.scrollingBehavior(in: sectionIndex), behavior == .vertical {
                section.orthogonalScrollingBehavior = .none
            } else if numberOfRowsInSection > 1 {
                section.orthogonalScrollingBehavior = .groupPagingCentered
            } else {
                section.orthogonalScrollingBehavior = .continuous
            }
            
            section.contentInsets = layoutDelegate?.contentInsets(for: sectionIndex) ?? .zero
            section.interGroupSpacing = layoutDelegate?.spacingBetweenItems(in: sectionIndex) ?? 0
            
            var supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
            
            if let headerIdentifiers = self.sectionHeaderIdentifiers {
                for _ in headerIdentifiers {
                    let headerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(layoutDelegate?.heightForHeader(in: sectionIndex) ?? 0)
                    )
                    
                    let header = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top
                    )
                    supplementaryItems.append(header)
                }
            }
            
            if let footerIdentifiers = self.sectionFooterIdentifiers {
                for _ in footerIdentifiers {
                    let footerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(layoutDelegate?.heightForFooter(in: sectionIndex) ?? 0)
                    )
                    
                    let footer = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: footerSize,
                        elementKind: UICollectionView.elementKindSectionFooter,
                        alignment: .bottom
                    )
                    supplementaryItems.append(footer)
                }
            }
            
            section.boundarySupplementaryItems = supplementaryItems
            
            if let sectionBackgroundIdentifiers = self.sectionBackgroundIdentifiers {
                for backgroundIdentifier in sectionBackgroundIdentifiers {
                    let sectionBackground = NSCollectionLayoutDecorationItem.background(
                        elementKind: backgroundIdentifier.className
                    )
                    section.decorationItems = [sectionBackground]
                }
            }
            
            return section
        }, configuration: config)
        
        return layout
    }
    
    public func registerSupplementaryViews(with layout: UICollectionViewLayout) {
        if let sectionHeaderIdentifiers = self.sectionHeaderIdentifiers {
            for headerIdentifier in sectionHeaderIdentifiers {
                layout.register(
                    UINib(nibName: headerIdentifier.className, bundle: nil),
                    forDecorationViewOfKind: UICollectionView.elementKindSectionHeader
                )
            }
        }
        
        if let sectionFooterIdentifiers = self.sectionFooterIdentifiers {
            for footerIdentifier in sectionFooterIdentifiers {
                layout.register(
                    UINib(nibName: footerIdentifier.className, bundle: nil),
                    forDecorationViewOfKind: UICollectionView.elementKindSectionFooter
                )
            }
        }
        
        if let sectionBackgroundIdentifiers = self.sectionBackgroundIdentifiers {
            for backgroundIdentifier in sectionBackgroundIdentifiers {
                layout.register(
                    UINib(nibName: backgroundIdentifier.className, bundle: nil),
                    forDecorationViewOfKind: backgroundIdentifier.className
                )
            }
        }
    }
}

