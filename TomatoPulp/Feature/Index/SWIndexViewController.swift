//
//  SWIndexViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import Alamofire.Swift

class SWIndexViewController: UIViewController {

    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    fileprivate var fabButton: FABButton!
    
    let v1 = UIView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        v1.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        v1.motionIdentifier = "v1"
        v1.backgroundColor = .purple
        view.addSubview(v1)
        
        prepareMenuButton()
        prepareStarButton()
        prepareSearchButton()
        prepareNavigationItem()
        prepareFABButton()
        setupASFBotData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate extension SWIndexViewController {
    
    func setupASFBotData() {
        let parameters: Parameters = ["pathname": "/root/ArchiSteamFarm/asf_linux/config"]
        AF.request("http://swing1993.xyz:8080/tomato/asf/findAll", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
            //网络请求
            response.result.ifSuccess {
                if let httpResult = AppHttpResponse.deserialize(from: response.result.value) {
                    if httpResult.success {
                        let botJsons: Array<String> = httpResult.result as! Array
                        for botJson in botJsons {
//                            print("bot:\(botJson)")
                            if let bot = SWASFBot.deserialize(from: botJson) {
                                print(bot.filename!)
                                if bot.filename! == "10446627.json" {
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            response.result.ifFailure({
            })
        })
    }
    
//    func update() {
//        let ZZ_parameters: Parameters = ["filename": "/Users/songguohua/Desktop/ASF.json", "content": bot.toJSONString()!]
//        AF.request("http://localhost:8081/asf/save", method: .post, parameters: ZZ_parameters, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
//
//        })
//    }
    
    func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
    }
    
    func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star)
    }
    
    func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search)
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Material"
        navigationItem.detailLabel.text = "Build Beautiful Software"
        
        navigationItem.leftViews = [menuButton]
        navigationItem.rightViews = [starButton, searchButton]
    }
    
    func prepareFABButton() {
        fabButton = FABButton(image: Icon.cm.moreHorizontal)
        fabButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        view.layout(fabButton).width(64).height(64).bottom(24).right(24)
    }
}

fileprivate extension SWIndexViewController {
    @objc
    func handleNextButton() {
        
    }
}
