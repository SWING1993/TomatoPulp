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

    fileprivate var postButton: IconButton!
    fileprivate var collectionView: UICollectionView!
    fileprivate var adapter: ListAdapter!
    fileprivate var dataSource: Array<SWStatusModel>!
    fileprivate var pageNum: Int = 1
    
    override func didInitialize() {
        super.didInitialize()
        dataSource = Array()
    }
    
    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
        prepareCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showEmptyViewWithLoading()
        self.setupSatausListRequest(showHUD: false)
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
        navigationItem.titleLabel.text = "状态"
        navigationItem.rightViews = [postButton]
    }
    
    func prepareCollectionView() {
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = Color.white
        collectionView.mj_header = SWRefreshHeader()
        collectionView.mj_header.refreshingBlock = {
            self.pageNum = 1;
            self.setupSatausListRequest(showHUD: false)
        }
        collectionView.mj_footer = SWRefreshFooter()
        collectionView.mj_footer.refreshingBlock = {
            self.pageNum = self.pageNum + 1;
            self.setupSatausListRequest(showHUD: false)
        }
        view.addSubview(collectionView)
        adapter = ListAdapter.init(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
}

fileprivate extension SWStatusController {
    
    @objc
    func handleToPostStatus() {
        let controller = SWPostStatusController()
        controller.complete = {
            self.setupSatausListRequest(showHUD: true)
        }
        let navController = AppNavigationController(rootViewController: controller)        
        self.present(navController, animated: true) {
            
        }
    }
    
    @objc func setupSatausListRequest(showHUD: Bool) {
        if showHUD {
            self.showProgreeHUD("加载中...")
        }
        HttpUtils.default.request("/status", method: .get, params: ["pageNum":pageNum]).response(success: { result in
            if showHUD {
                self.hideHUD()
            }
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
            if self.pageNum <= 1 {
                self.dataSource.removeAll()
            }
            if let dict = result as? [String: Any] {
                if let list: Array<[String: Any]> = dict["list"] as? Array<[String: Any]> {
                    list.forEach({ (obj) in
                        if let model = SWStatusModel.deserialize(from: obj) {
                            if model.imageUrls.isEmpty == false {
                                model.images = model.imageUrls.components(separatedBy: ",")
                            }
                            self.dataSource.append(model)
                        }
                    })
                }
            }
            if self.dataSource.count <= 0 {
                self.showEmptyView(withText: "", detailText: "暂无更多消息", buttonTitle: "刷新", buttonAction:#selector (self.setupSatausListRequest(showHUD:)))
            } else {
                self.hideEmptyView()
            }
            self.adapter.reloadData(completion: nil)
        }) { errorMsg in
            if showHUD {
                self.hideHUD()
            }
            self.showTextHUD(errorMsg, dismissAfterDelay: 3)
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.mj_footer.endRefreshing()
            if self.dataSource.count <= 0 {
                self.showEmptyView(withText: "", detailText: "网络错误", buttonTitle: "刷新", buttonAction:#selector (self.setupSatausListRequest(showHUD:)))
            }
            self.adapter.reloadData(completion: nil)
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
