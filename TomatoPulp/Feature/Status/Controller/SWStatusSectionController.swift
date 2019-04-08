//
//  SWStatusSectionController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWStatusSectionController: ListSectionController {
    
    fileprivate let cellsBeforeComments = 4
    var model: SWStatusModel!
    
    override func numberOfItems() -> Int {
        return cellsBeforeComments
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = self.collectionContext?.containerSize.width
        var height: CGFloat = 0.0
        if index == 0 {
            height = 45.0
        } else if index == 1 {
            height = SWStatusTextCell.cellHeight(text: model.content, width: width! - 30)
        } else if index == 2  {
            height = SWStatusImageCell.cellHeight(count: 1)
        } else {
            height = 20
        }
        return CGSize.init(width: width!, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            let cell: SWStatusUserCell = self.collectionContext?.dequeueReusableCell(of: SWStatusUserCell.self, for: self, at:index) as! SWStatusUserCell
            if model.avatarUrl.count > 0 {
                cell.avatarView.af_setImage(withURL: URL(string: model.avatarUrl)!)
            }
            cell.nicknameLabel.text = model.nickname
            cell.timeLabel.text = NSDate.init(timeIntervalSince1970: TimeInterval(model.created/1000)).stringByMessageDate()
            return cell
        } else if index == 1 {
            let cell: SWStatusTextCell = self.collectionContext?.dequeueReusableCell(of: SWStatusTextCell.self, for: self, at:index) as! SWStatusTextCell
            cell.contentLabel.text = model.content
            return cell
        } else if index == 2 {
            let cell: SWStatusImageCell = self.collectionContext?.dequeueReusableCell(of: SWStatusImageCell.self, for: self, at:index) as! SWStatusImageCell
            cell.configImageCell(count: 1)
            return cell
        }
        let cell: SWStatusLineCell = self.collectionContext?.dequeueReusableCell(of: SWStatusLineCell.self, for: self, at:index) as! SWStatusLineCell
        return cell
    }
    
    override func didUpdate(to object: Any) {
        model = object as? SWStatusModel
    }
}
