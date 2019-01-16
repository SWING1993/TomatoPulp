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

class HttpUtils {
    static let `default` = HttpUtils()
    /// 超时时间
    private var host: String {
        return "http://swing1993.xyz:8080/tomato"
    }
    private var timeoutIntervalForRequest: TimeInterval = 25
    private var encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    private var headers: HTTPHeaders = HTTPHeaders.init(["Content-Type" : "application/json"])
    
    func request(_ url: String,  method: HTTPMethod = .get, params: Parameters? = nil) -> HttpTaskUtils {
        let taskManager: HttpTaskUtils = HttpTaskUtils().request("\(host)\(url)", method: method, params: params, encoding: encoding, headers: headers)
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
            dataRequest = AF.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
        return self
    }

    /// 响应String
    public func response(success: @escaping (Any?)->(), failure: @escaping (String)->()) {
        dataRequest?.responseString(completionHandler: { response in
            response.result.ifSuccess {
                if let httpResult = HttpResponse<Any>.deserialize(from: response.result.value) {
                    if httpResult.success {
                        success(httpResult.result)
                    } else {
                        failure(httpResult.message!)
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
    
    required init() {}
}
