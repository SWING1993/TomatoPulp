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
    private var timeoutIntervalForRequest: TimeInterval = 25
    private var encoding: ParameterEncoding = URLEncoding(destination: .queryString)
    private var headers: HTTPHeaders = HTTPHeaders.init(["Content-Type" : "application/json"])
    
    func request(_ url: String,  method: HTTPMethod = .get, params: Parameters? = nil) -> HttpTaskUtils {
        let tempParam = params == nil ? [:] : params!
        let taskManager: HttpTaskUtils = HttpTaskUtils().request(url, method: method, params: tempParam, encoding: encoding, headers: headers)
        return taskManager
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
    public func response(success: @escaping (_ response: Any)->(), failure: @escaping (_ errorMsg: String)->()) {
        dataRequest?.responseString(completionHandler: { response in
            response.result.ifSuccess {
                if let httpResult = AppHttpResponse.deserialize(from: response.result.value) {
                    if httpResult.success {
                        success(httpResult.result as Any)
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
class HttpResponse<Value>: HandyJSON {
    
    var success: Bool = false
    var message : String?
    var error: String?
    var time: String?
    var result: Value?
    
    required init() {}
}
