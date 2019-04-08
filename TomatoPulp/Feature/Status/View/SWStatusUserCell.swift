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
    let timeLabel = QMUILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 17.5
        avatarView.layer.borderColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1).cgColor
        avatarView.layer.borderWidth = 0.5
        self.contentView.addSubview(avatarView)
        
        nicknameLabel.textColor = Color.blue.accent3
        nicknameLabel.font = UIFont.PFSCMedium(aSize: 13.5)
        self.contentView.addSubview(nicknameLabel)
        
        timeLabel.textColor = Color.darkText.secondary
        timeLabel.font = UIFont.PFSCLight(aSize: 12)
        self.contentView.addSubview(timeLabel)
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
            maker.height.equalTo(18)
            maker.bottom.equalTo(self.contentView.snp.centerY)
            maker.left.equalTo(avatarView.snp.right).offset(10)
        }
        
        timeLabel.snp.makeConstraints { maker in
            maker.width.equalTo(250)
            maker.top.equalTo(nicknameLabel.snp.bottom)
            maker.height.equalTo(18)
            maker.left.equalTo(avatarView.snp.right).offset(10)
        }
    }
}
