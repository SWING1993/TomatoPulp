//
//  SWSSRViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import Alamofire.Swift

class SWSSRViewController: UIViewController {

    fileprivate var tableView: TableView!
    
    fileprivate var users: Array<SWSSRUser> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        prepareTableView()
        setupSSRUserData()
    }

    
}

fileprivate extension SWSSRViewController {
    
    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        view.layout(tableView).edges()
    }
    
    func setupSSRUserData() {
        AF.request("http://swing1993.xyz:8080/tomato/ssr/user", method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
            //网络请求
            response.result.ifSuccess {
                if let httpResult = AppHttpResponse.deserialize(from: response.result.value) {
                    if httpResult.success {
                    
                        self.users.removeAll()
                        let userJsonsString: String? = httpResult.result as? String
                        if let users: [SWSSRUser] = [SWSSRUser].deserialize(from: userJsonsString) as? [SWSSRUser] {
                            users.forEach({ (user) in
                                print(user.user)
                                self.users.append(user)
                            })
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            response.result.ifFailure({
            })
        })
    }
    
}

extension SWSSRViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

extension SWSSRViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let user: SWSSRUser = self.users[indexPath.row]
        cell?.imageView?.image = UIImage.init(named: "robot-solid")?.resize(toWidth: 25)?.tint(with: user.enable ? Color.green.base : Color.red.base)
        cell?.textLabel?.text = user.user
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 14)
//        cell?.detailTextLabel?.text = bot.FilePath
        cell?.detailTextLabel?.font = Font.italicSystemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        let botSwitch: Switch = Switch(state: .off, style: .light, size: .small)
        botSwitch.isOn = user.enable
        botSwitch.tag = indexPath.row
//        botSwitch.delegate = self
        cell?.accessoryView = botSwitch
        
        return cell!
    }
    
}

