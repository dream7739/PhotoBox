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
