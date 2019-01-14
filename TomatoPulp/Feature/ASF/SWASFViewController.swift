//
//  SWASFViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/13.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import Alamofire.Swift

class SWASFViewController: UIViewController {
    
    fileprivate var tableView: TableView!
    
    fileprivate var asf: SWASF = SWASF()
    
    fileprivate var bots: Array<SWASFBot> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        prepareTableView()
        
        setupASFBotData()
    }
    

}

fileprivate extension SWASFViewController {
    
    func setupASFBotData() {
        let parameters: Parameters = ["pathname": "/root/ArchiSteamFarm/asf_linux/config"]
        AF.request("http://swing1993.xyz:8080/tomato/asf/findBots", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
            //网络请求
            response.result.ifSuccess {
                if let httpResult = AppHttpResponse.deserialize(from: response.result.value) {
                    if httpResult.success {
                        let resultDict: Dictionary<String, Any> = httpResult.result as! Dictionary<String, Any>
                        
                        if let asf:SWASF = SWASF.deserialize(from: resultDict["asf"] as? String) {
                            self.asf = asf
                            print("asf:\(self.asf.FilePath)")
                        }
                        
                        let botJsons: Array<String> = resultDict["bots"] as! Array<String>
                        self.bots.removeAll()
                        for botJson in botJsons {
                            if let bot: SWASFBot = SWASFBot.deserialize(from: botJson) {
                                print(bot.FileName)
                                self.bots.append(bot)
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            response.result.ifFailure({
            })
        })
    }
    
    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        view.layout(tableView).edges()
    }
}

extension SWASFViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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
        cell?.imageView?.image = UIImage.init(named: "robot-solid")?.resize(toWidth: 25)?.tint(with: bot.Enabled ? Color.green.base : Color.red.base)
        cell?.textLabel?.text = bot.SteamLogin
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 14)
        cell?.detailTextLabel?.text = bot.FilePath
        cell?.detailTextLabel?.font = Font.italicSystemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        let botSwitch: Switch = Switch(state: .off, style: .light, size: .small)
        botSwitch.isOn = bot.Enabled
        botSwitch.tag = indexPath.row
        botSwitch.delegate = self
        cell?.accessoryView = botSwitch
        
        return cell!
    }
    
}

extension SWASFViewController: SwitchDelegate {
    func switchDidChangeState(control: Switch, state: SwitchState) {
        print("Switch changed state to: ", .on == state ? "on" : "off")
        let bot: SWASFBot = self.bots[control.tag]
        bot.Enabled = control.isOn
        let parameters: Parameters = ["filename": bot.FilePath, "content": bot.toJSONString()!]
        AF.request("http://swing1993.xyz:8080/tomato/asf/save", method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
            print(response.result.value!)
            self.setupASFBotData()
        })
    }
}
