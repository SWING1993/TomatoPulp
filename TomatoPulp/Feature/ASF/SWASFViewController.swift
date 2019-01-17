//
//  SWASFViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/13.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWASFViewController: QMUICommonViewController {
    
    fileprivate var settingButton: IconButton = IconButton.init(image: Icon.cm.settings)

    fileprivate var tableView: TableView!
    
    fileprivate var asf: SWASF = SWASF()
    
    fileprivate var bots: Array<SWASFBot> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       self.showEmptyView(withText: "SteamBot为空", detailText: "请检查网络", buttonTitle: nil, buttonAction: nil)

        prepareTableView()
        
        prepareNavigationItem()
        
        setupASFBotData()
    }
    
}

fileprivate extension SWASFViewController {

    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        view.layout(tableView).edges()
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "ArchiSteamFarm"
        navigationItem.detailLabel.text = "前所未有的挂卡体验"
        settingButton.addTarget(self, action: #selector(handleToASFSetting), for: .touchUpInside)
        navigationItem.rightViews = [settingButton]
    }
    
    func setupASFBotData() {
        self.showProgreeHUD("加载中...")
        HttpUtils.default.request("/asf/findBots").response(success: { result in
            self.hideHUD()
            let resultDict: Dictionary<String, Any> = result as! Dictionary<String, Any>
            if let asf:SWASF = SWASF.deserialize(from: resultDict["asf"] as? String) {
                self.asf = asf
                print("asf:\(self.asf.FileName)")
            }
            
            let botJsons: Array<String> = resultDict["bots"] as! Array<String>
            self.bots.removeAll()
            for botJson in botJsons {
                if let bot: SWASFBot = SWASFBot.deserialize(from: botJson) {
                    print(bot.FileName)
                    self.bots.append(bot)
                }
            }
            self.bots.sort(by: { (bot1, bot2) -> Bool in
                return bot1.SteamLogin < bot2.SteamLogin
            })
            self.tableView.reloadData()
            self.hideEmptyView()
        }) { msg in
            self.hideHUD()
            self.showTextHUD(msg, dismissAfterDelay: 3)
        }
    }
}

extension SWASFViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "steam bots"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bot: SWASFBot = self.bots[indexPath.row]
        let controller: SWASFBotSettingViewController = SWASFBotSettingViewController()
        controller.asfBot = bot
        controller.saved = {
            self.setupASFBotData()
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SWASFViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bots.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let bot: SWASFBot = self.bots[indexPath.row]
        cell?.imageView?.image = UIImage.init(named: "robot-solid")?.resize(toWidth: 25)?.tint(with: bot.Enabled ? Color.green.base : Color.blueGrey.lighten4)
        cell?.textLabel?.text = bot.SteamLogin
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 13)
        cell?.detailTextLabel?.text = bot.FileName
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
}


fileprivate extension SWASFViewController {
    
    @objc
    func handleToASFSetting() {
        let controller: SWASFSettingViewController = SWASFSettingViewController()
        controller.asf = self.asf
        navigationController?.pushViewController(controller, animated: true)
    }

}
