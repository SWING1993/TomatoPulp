//
//  SWStatusSectionController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

class SWStatusSectionController: ListSectionController {
    
    fileprivate let cellsBeforeComments = 4
    var model: SWStatusModel!
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = self.collectionContext?.containerSize.width
        var height: CGFloat = 0.0
        if index == 0 {
            height = 45.0
        } else {
            height = 140.0
        }
        return CGSize.init(width: width!, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            let cell: SWStatusUserCell = self.collectionContext?.dequeueReusableCell(of: SWStatusUserCell.self, for: self, at:index) as! SWStatusUserCell
            return cell
        }
        let cell: SWStatusTextCell = self.collectionContext?.dequeueReusableCell(of: SWStatusTextCell.self, for: self, at:index) as! SWStatusTextCell
        return cell
    }
    
    override func didUpdate(to object: Any) {
        model = object as? SWStatusModel
        print(model.content)
    }

}
