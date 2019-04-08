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
//        for index in 0...2 {
//            let model = SWStatusModel()
//            model.nickname = "SuperMAN"
//            model.id = Int64(index)
//
//            if index == 0 {
//                model.content = "Android虽然已经是使用人数最多的手机平台，但谷歌也被甲骨文Java、Linux内核效率、欧盟乐此不疲的反垄断审查折腾得够呛，可能是为了让自己完全抽身，Fuchsia OS应运而生。Fuchsia操作系统不再使用Linux内核，而是基于Zircon微核，采用Flutter引擎+Dart语言编写。更惊人的是，它定位在跨平台（手机、PC、IoT等），支持ARM/x86体系，甚至有望兼容Android、ChromeOS平台的程序。在AOSP的存储库中，Fuchsia OS的代码增加了760MB，涉及对977个文件的更改以及新增用于调试开发的SDK。有趣的是，目前的测试设备是“Walleye”，熟悉的朋友可能知道，这是谷歌Pixel 2手机的代号。不过，Fuchsia OS距离完工最快还有3年时间。今年中旬，有接近该项目的消息人士透露，Fuchsia OS需要5年左右的时间实现大规模推广开。"
//            } else {
//                 model.content = "因为这些不同的机制能够用一种相同的方式处理，可以很容易的声明成链（chain）并且把它们联合在一起，用更少的代码和状态连接它们。\n更多关于RAC里的概念可以查看Framework Overview."
//            }
//            dataSource.append(model)
//        }
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
        navigationItem.titleLabel.text = "Status"
        navigationItem.detailLabel.text = "👿👿👿"
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
        let controller = AppNavigationController(rootViewController: SWPostStatusController())
        self.present(controller, animated: true) {
            
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
