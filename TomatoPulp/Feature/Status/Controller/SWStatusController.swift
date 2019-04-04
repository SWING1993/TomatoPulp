//
//  SWStatusController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWStatusController: QMUICommonViewController {

    fileprivate var tableView: TableView!
    fileprivate var postButton: IconButton!
    fileprivate var collectionView: UICollectionView!
    fileprivate var adapter: ListAdapter!
    fileprivate var dataSource: Array<SWStatusModel>!
    
    override func didInitialize() {
        super.didInitialize()
        dataSource = Array()
        for index in 0...6 {
            let model = SWStatusModel()
            model.id = Int64(index)
            model.content = "开心 happy"
            dataSource.append(model)
        }
    }
    
    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
        prepareCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

fileprivate extension SWStatusController {
    
    func prepareNavigationItem() {
        postButton = IconButton(image: Icon.cm.photoCamera)
        postButton.addTarget(self, action: #selector(handleToPostStatus), for: .touchUpInside)
        navigationItem.titleLabel.text = "Status"
        navigationItem.detailLabel.text = "👿👿👿"
        navigationItem.rightViews = [postButton]
    }
    
    func prepareCollectionView() {
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = Color.red.accent1
        view.addSubview(collectionView)
        adapter = ListAdapter.init(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
}

fileprivate extension SWStatusController {
    
    @objc
    func handleToPostStatus() {
        let controller = AppNavigationController(rootViewController: SWPostStatusController())
        self.present(controller, animated: true) {
            
        }
    }
}


extension SWStatusController : ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let controller = SWStatusSectionController()
        return controller
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
