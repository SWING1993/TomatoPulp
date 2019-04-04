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
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = self.collectionContext?.containerSize.width
        return CGSize.init(width: width!, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = self.collectionContext?.dequeueReusableCell(of: UICollectionViewCell.self, for: self, at:index)
        cell?.backgroundColor = UIColor.qmui_random()
        return cell!
    }
    
    override func didUpdate(to object: Any) {
        model = object as? SWStatusModel
        print(model.content)
    }

}
