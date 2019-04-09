//
//  SWStatusImageCell.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/8.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

class SWStatusImageCell: UICollectionViewCell {
    
    static let viewPadding: CGFloat = 10.0
    static let leftPadding: CGFloat = 15.0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configImageCell(count: Int) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        let imageHeight = SWStatusImageCell.imageHeight()
        let firstRect = CGRect.init(x: SWStatusImageCell.leftPadding, y: SWStatusImageCell.viewPadding, width: imageHeight, height: imageHeight)
        for i in 0..<count {
            let view = UIView()
            view.backgroundColor = UIColor.qmui_random()
            contentView.addSubview(view)
            let col = CGFloat(i % 3)
            let row = CGFloat(i / 3)
            let xOffset = col * (imageHeight + SWStatusImageCell.viewPadding)
            let yOffset = row * (imageHeight + SWStatusImageCell.viewPadding)
            view.frame = firstRect.offsetBy(dx: xOffset, dy: yOffset)
        }
    }
    
    static func imageHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let height = (screenWidth - 2 * (SWStatusImageCell.leftPadding + SWStatusImageCell.viewPadding))/3
        return height
    }
    
    static func cellHeight(count: Int) -> CGFloat {
        var row: CGFloat = 0
        if count <= 0 {
            row = 0
        } else if count >= 7 {
            row = 3
        } else {
            row = CGFloat(count / 3) + 1
        }
        let height = row * (SWStatusImageCell.imageHeight() + SWStatusImageCell.viewPadding) + SWStatusImageCell.viewPadding
        return height
    }
}
