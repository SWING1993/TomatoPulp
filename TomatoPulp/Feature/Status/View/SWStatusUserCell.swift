//
//  SWStatusUserCell.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWStatusUserCell: UICollectionViewCell {
    let avatarView = UIImageView()
    let nicknameLabel = QMUILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatarView.contentMode = .scaleAspectFill
        avatarView.backgroundColor = Color.red.accent4
        self.contentView.addSubview(avatarView)
        
        nicknameLabel.textColor = Color.darkText.primary
        nicknameLabel.font = UIFont.PFSCMedium(aSize: 14)
        self.contentView.addSubview(nicknameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.snp.makeConstraints { maker in
            maker.width.height.equalTo(35)
            maker.centerY.equalTo(self.contentView)
            maker.left.equalTo(15)
        }
        
        nicknameLabel.snp.makeConstraints { maker in
            maker.width.equalTo(250)
            maker.height.equalTo(35)
            maker.centerY.equalTo(self.contentView)
            maker.left.equalTo(avatarView.snp.right).offset(15)
        }
    }
}
