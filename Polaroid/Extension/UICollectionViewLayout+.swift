//
//  UICollectionViewLayout+.swift
//  Polaroid
//
//  Created by 홍정민 on 7/26/24.
//

import UIKit

extension UICollectionViewLayout {
    static func createBasicLayout(_ view: UIView) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 2
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let width = (view.bounds.width - spacing) / 2
        layout.itemSize = CGSize(width: width , height: width * 1.3)
        return layout
    }
}

class ZigzagFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .vertical
        self.minimumLineSpacing = 16
        self.minimumInteritemSpacing = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.indexPath.item % 2 != 0 {
                    layoutAttribute.frame.origin.y += 20
                }
            }
        }
        return attributes
    }
    
}
