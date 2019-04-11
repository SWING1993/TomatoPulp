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
    
    func configImageCell(imageUrls: Array<String>) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        let imageHeight = SWStatusImageCell.imageHeight()
        let firstRect = CGRect.init(x: SWStatusImageCell.leftPadding, y: SWStatusImageCell.viewPadding, width: imageHeight, height: imageHeight)
        for i in 0..<imageUrls.count {
            let imageUrl = imageUrls[i]
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.af_setImage(withURL: URL(string: imageUrl)!)
            let col = CGFloat(i % 3)
            let row = CGFloat(i / 3)
            let xOffset = col * (imageHeight + SWStatusImageCell.viewPadding)
            let yOffset = row * (imageHeight + SWStatusImageCell.viewPadding)
            imageView.frame = firstRect.offsetBy(dx: xOffset, dy: yOffset)
            contentView.addSubview(imageView)
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
        } else if count <= 3 {
            row = 1
        } else if count <= 6 {
            row = 2
        } else {
            row = 3
        }
        let height = row * (SWStatusImageCell.imageHeight() + SWStatusImageCell.viewPadding) + SWStatusImageCell.viewPadding
        return height
    }
}
