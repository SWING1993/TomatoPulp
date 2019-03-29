//
//  HttpUtils.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/16.
//  Copyright © 2019 songguohua. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON
import Async

class HttpUtils {
    static let `default` = HttpUtils()
    
    private var host: String {
        #if DEBUG
        return "http://localhost:8080"
        #else
        return "http://118.24.216.163:8080/orange"
        #endif
    }
    /// 超时时间
    private var timeoutIntervalForRequest: TimeInterval = 25
    private var encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    private var headers: HTTPHeaders = ["Content-Type" : "application/json"]
    
    // SIGN_KEY
    private var SIGN_KEY: String = "signature_secret"
    // ACCESS_KEY
    private var ACCESS_KEY: String = "accessKey"
    // ACCESS_SECRET
    private var ACCESS_SECRET: String = "!@#orange"
    // md5盐值，用于混淆
    private var signSalt: String = "orange!@#"
    
    func request(_ url: String,  method: HTTPMethod = .get, params: Parameters? = nil) -> HttpTaskUtils {
        
        // 参数签名
        var temp: String = ""
        if let keys = params?.keys {
            var array: Array<String> = Array(keys)
            array.sort(){
                $0 < $1
            }
            array.forEach { value in
                temp.append("\(value)&")
            }
        }
        temp.append("\(ACCESS_KEY)=\(ACCESS_SECRET)\(signSalt)")
        
        var signatureParams = Parameters();
        if let args = params {
            args.forEach { (arg) in
                signatureParams[arg.key] = arg.value
            }
        }
        headers[SIGN_KEY] = temp.md5()

        // 请求头
        headers["token"] = clientShared.user.token
        headers["uid"] = "\(clientShared.user.id)"
//        print("headers:\(headers)")

        let taskManager: HttpTaskUtils = HttpTaskUtils().request("\(host)\(url)", method: method, params: signatureParams, encoding: encoding, headers: headers)
        return taskManager
    }
    
    static func transformedValue(value: Int64) -> String {
        var result: Double = Double.init(value)
        var multiplyFactor :Int = 0;
        let tokens: Array<String> = ["Bytes", "KB", "MB", "GB","TB"]
        while result > 1024 {
            multiplyFactor = multiplyFactor + 1
            result = result/1024
        }
        return "\(String(format: "%.2f", result))\(tokens[multiplyFactor])"
    }
}

// MARK: - 请求任务
public class HttpTaskUtils {
    fileprivate var dataRequest: DataRequest?
    fileprivate var completionClosure: (()->())?
    
    @discardableResult
    fileprivate func request(
        _ url: String,
        method: HTTPMethod = .get,
        params: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> HttpTaskUtils {
            dataRequest = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
        return self
    }

    /// 响应String
    public func response(success: @escaping (Any?)->(), failure: @escaping (String)->()) {
        dataRequest?.responseString(completionHandler: { response in
//            QMUIConsole.log("response.result.value as Any")
            response.result.ifSuccess {
                if let httpResult = HttpResponse<Any>.deserialize(from: response.result.value) {
                    if httpResult.success {
                        success(httpResult.result)
                    } else {
                        failure(httpResult.message!)
                        if httpResult.code == 10002 || httpResult.code == 10003 {
                            // token无效，
                            clientShared.removeUserInfo()
                            Async.main{
                                let app = UIApplication.shared.delegate as! AppDelegate
                                app.toLogin()
                            }
                        }
                    }
                } else {
                    failure("服务器错误")
                }
            }
            response.result.ifFailure {
                if let errorMsg = response.error?.localizedDescription {
                    failure(errorMsg)
                } else {
                    failure("服务器错误")
                }
            }
        })
    }
    
}

//// MARK: - Result
class HttpResponse<T>: HandyJSON {
    
    var success: Bool = false
    var message : String?
    var error: String?
    var time: String?
    var result: T?
    var code: Int = 0
    
    required init() {}
}
