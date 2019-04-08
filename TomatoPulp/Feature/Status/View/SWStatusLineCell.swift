//
//  SWStatusLineCell.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/8.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

class SWStatusLineCell: UICollectionViewCell {
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lineView.backgroundColor = UIColor.init(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        self.contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(0)
            maker.height.equalTo(1);
        }
    }
}
