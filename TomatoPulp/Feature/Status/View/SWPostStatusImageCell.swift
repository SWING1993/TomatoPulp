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
    open var deleteImageHandle: ((Int) -> (Void))?

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
        let imageHeight = SWStatusImageCell.defaultImageHeight()
        let firstRect = CGRect.init(x: SWStatusImageCell.leftPadding, y: SWStatusImageCell.viewPadding, width: imageHeight, height: imageHeight)
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.layer.borderWidth = 0.5
            imageView.layer.borderColor = UIColor.init(red: 231/255, green: 231/255, blue: 231/255, alpha: 1).cgColor
            imageView.image = images[i]
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            let xOffset = col * (imageHeight + SWStatusImageCell.viewPadding)
            let yOffset = row * (imageHeight + SWStatusImageCell.viewPadding)
            imageView.frame = firstRect.offsetBy(dx: xOffset, dy: yOffset)
            contentView.addSubview(imageView)
            
            let deleteButton = UIButton.init(type: .custom)
            deleteButton.setImage(UIImage.init(named: "image_delete"), for: .normal)
            deleteButton.tag = i
            deleteButton.addTarget(self, action: #selector(handleToDeleteImage), for: .touchUpInside)
            deleteButton.frame = CGRect.init(x: imageView.bounds.size.width - 30, y: 0, width: 30, height: 30)
            imageView.addSubview(deleteButton)
        }
        
        if images.count == 0 {
            addImageButton.frame = firstRect
            contentView.addSubview(addImageButton)
        } else if images.count < 9 {
            let col = CGFloat((images.count) % 3)
            let row = CGFloat((images.count) / 3)
            let xOffset = col * (imageHeight + SWStatusImageCell.viewPadding)
            let yOffset = row * (imageHeight + SWStatusImageCell.viewPadding)
            addImageButton.frame = firstRect.offsetBy(dx: xOffset, dy: yOffset)
            contentView.addSubview(addImageButton)
        }
    }
    
    static func cellHeight(count: Int) -> CGFloat {
        var imageCount = count
        if imageCount < 9 {
            imageCount = imageCount + 1
        }
        var row: CGFloat = 0
        if imageCount <= 0 {
            row = 0
        } else if imageCount <= 3 {
            row = 1
        } else if imageCount <= 6 {
            row = 2
        } else {
            row = 3
        }
        let height = row * (SWStatusImageCell.defaultImageHeight() + SWStatusImageCell.viewPadding) + SWStatusImageCell.viewPadding
        return height
    }
    
    @objc
    func handleToDeleteImage(button: UIButton) {
        if let deleteImageHandle = self.deleteImageHandle {
            deleteImageHandle(button.tag)
        }
    }
}
