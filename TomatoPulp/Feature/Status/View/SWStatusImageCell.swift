//
//  SWStatusImageCell.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/8.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

class SWStatusImageCell: UICollectionViewCell {
    
    open var showImagesHandle: ((Array<String>, Int) -> (Void))?
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
        let imageHeight = SWStatusImageCell.imageHeight(count: imageUrls.count)
        let firstRect = CGRect.init(x: SWStatusImageCell.leftPadding, y: SWStatusImageCell.viewPadding, width: imageHeight, height: imageHeight)
        for i in 0..<imageUrls.count {
            let imageUrl = imageUrls[i]
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            imageView.af_setImage(withURL: URL(string: imageUrl)!)
            var col = CGFloat(i % 3)
            var row = CGFloat(i / 3)
            if imageUrls.count == 4 {
                col = CGFloat(i % 2)
                row = CGFloat(i / 2)
            }
            let xOffset = col * (imageHeight + SWStatusImageCell.viewPadding)
            let yOffset = row * (imageHeight + SWStatusImageCell.viewPadding)
            imageView.frame = firstRect.offsetBy(dx: xOffset, dy: yOffset)
            contentView.addSubview(imageView)
            imageView.bk_(whenTapped: {
                if let showImagesHandle = self.showImagesHandle {
                    showImagesHandle(imageUrls, imageView.tag)
                }
            })
        }
    }
    
    static func imageHeight(count: Int) -> CGFloat {
        var height: CGFloat = 0.0
        let screenWidth = UIScreen.main.bounds.width
        if count == 1 {
            height = screenWidth - 2 * SWStatusImageCell.leftPadding
        } else if count == 4 {
            height = (screenWidth - 2 * SWStatusImageCell.leftPadding - SWStatusImageCell.viewPadding)/2
        } else {
            height = (screenWidth - 2 * (SWStatusImageCell.leftPadding + SWStatusImageCell.viewPadding))/3
        }
        return height
    }
    
    /// 9宫格布局
    ///
    /// - Returns: 单张图片高度
    static func defaultImageHeight() -> CGFloat {
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
        let height = row * (SWStatusImageCell.imageHeight(count: count) + SWStatusImageCell.viewPadding)
//            + SWStatusImageCell.viewPadding
        return height
    }
}
