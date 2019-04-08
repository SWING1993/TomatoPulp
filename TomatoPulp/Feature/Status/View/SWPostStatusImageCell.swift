//
//  SWPostStatusImageCell.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/8.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWPostStatusImageCell: TableViewCell {
    
    let addImageButton: QMUIButton = QMUIButton.init()
    open var addImageHandle: (() -> (Void))?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addImageButton.layer.borderWidth = 0.5
        addImageButton.layer.borderColor = UIColor.init(red: 231/255, green: 231/255, blue: 231/255, alpha: 1).cgColor
        addImageButton.setImage(UIImage.init(named: "image_add"), for: .normal)
        addImageButton.addTarget(self, action: #selector(handleToAddImages), for: .touchUpInside)

    }
    
    @objc
    func handleToAddImages() {
        if let addImageHandle = self.addImageHandle {
            addImageHandle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configImageCell(images: Array<UIImage>) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        let imageHeight = SWStatusImageCell.imageHeight()
        let firstRect = CGRect.init(x: SWStatusImageCell.leftPadding, y: SWStatusImageCell.viewPadding, width: imageHeight, height: imageHeight)
        var lastView = UIImageView()
        for i in 0..<images.count {
            let view = UIImageView()
            view.backgroundColor = UIColor.qmui_random()
            contentView.addSubview(view)
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            let xOffset = col * (imageHeight + SWStatusImageCell.viewPadding)
            let yOffset = row * (imageHeight + SWStatusImageCell.viewPadding)
            view.frame = firstRect.offsetBy(dx: xOffset, dy: yOffset)
            view.image = images[i]
            lastView = view
        }
        
        contentView.addSubview(addImageButton)
        if images.count < 9 {
            if images.count == 0 {
                addImageButton.frame = firstRect
            } else {
                let row = CGFloat((images.count - 1) / 3)
                let col = CGFloat((images.count - 1) % 3)
                let xOffset = col * (imageHeight + SWStatusImageCell.viewPadding)
                let yOffset = row * (imageHeight + SWStatusImageCell.viewPadding)
                addImageButton.frame = lastView.frame.offsetBy(dx: xOffset, dy: yOffset)
            }
        }
    }
    
    static func cellHeight(count: Int) -> CGFloat {
        var imageCount = count
        if imageCount < 9 {
            imageCount = imageCount + 1
        }
        let col = CGFloat(imageCount / 3)
        let height = col * (SWStatusImageCell.imageHeight() + SWStatusImageCell.viewPadding) + SWStatusImageCell.viewPadding
        print(height)
        return height
    }
}
