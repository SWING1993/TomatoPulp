//
//  SWStatusTextCell.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWStatusTextCell: UICollectionViewCell {
    let contentLabel = QMUILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentLabel.textColor = Color.darkText.primary
        contentLabel.font = UIFont.PFSCRegular(aSize: 13.5)
        contentLabel.numberOfLines = 0
        self.contentView.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(0)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
        }
    }
    
    static func cellHeight(text: String, width: CGFloat) -> CGFloat {
        let contentLabel = QMUILabel()
        contentLabel.font = UIFont.PFSCRegular(aSize: 13.5)
        contentLabel.text = text
        contentLabel.numberOfLines = 0
        let cellSize = contentLabel.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        return cellSize.height
    }
    
}
