//
//  SWUserBGView.swift
//  TomatoPulp
//
//  Created by YZL-SWING on 2019/6/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

class SWUserBGView: UIView {

    let avatarView: UIImageView = UIImageView()
    let nicknameLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareAvatarView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareAvatarView() {
        avatarView.isUserInteractionEnabled = true
        avatarView.layer.cornerRadius = 50
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1).cgColor
        avatarView.layer.borderWidth = 0.5
        self.addSubview(avatarView)
        
        nicknameLabel.font = UIFont.PFSCRegular(aSize: 13)
        nicknameLabel.textAlignment = .center
        self.addSubview(nicknameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarView.snp.makeConstraints { maker in
            maker.centerX.equalTo(self)
            maker.bottom.equalTo(self.snp.centerY)
            maker.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        nicknameLabel.snp.makeConstraints { maker in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.top.equalTo(avatarView.snp.bottom).offset(15)
            maker.height.equalTo(20)
        }
    }
    


}
