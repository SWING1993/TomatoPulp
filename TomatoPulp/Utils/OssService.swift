//
//  OssService.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/2/12.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import AliyunOSSiOS
import Async

class OssService {
    
    let AccessKeySecret = ""
    let AccessKeyId = ""
    let EndPoint = "https://oss-cn-beijing.aliyuncs.com"
    let BUCKET_NAME = "mybucket-swing"
    let UrlPrefixed = "https://mybucket-swing.oss-cn-beijing.aliyuncs.com/"
    let Characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

    var isCancelled = false;
    var putRequest: OSSPutObjectRequest?
    var client: OSSClient?
    
    init() {
        self.ossInit()
    }
    
    /// 初始化获取OSSClient
    func ossInit() -> Void {
        let credential = OSSCustomSignerCredentialProvider.init { (contentToSign, error) -> String? in
            // 您需要在这里依照OSS规定的签名算法，实现加签一串字符内容，并把得到的签名传拼接上AccessKeyId后返回
            // 一般实现是，将字符内容post到您的业务服务器，然后返回签名
            // 如果因为某种原因加签失败，描述error信息后，返回nil
            let signature = OSSUtil.calBase64Sha1(withData: contentToSign, withSecret: self.AccessKeySecret)
            return "OSS \(self.AccessKeyId):\(String(describing: signature!))"
        }
        client = OSSClient.init(endpoint: EndPoint, credentialProvider: credential!)
    }
    
    func putImage(image: UIImage, compression: Bool, succees: @escaping (String) ->(), failed: @escaping (NSError) -> ()) -> Void {
        self.putRequest = OSSPutObjectRequest()
        self.putRequest?.bucketName = self.BUCKET_NAME
        if compression {
            self.putRequest?.objectKey = "\(fileNmae(length: 10)).jpg"
            self.putRequest?.uploadingData = image.jpegData(compressionQuality: 0.5)!
        } else {
            self.putRequest?.objectKey = "\(fileNmae(length: 10)).png"
            self.putRequest?.uploadingData = image.pngData()!
        }
        self.putRequest?.uploadProgress = {bytesSent, totalBytesSent, totalBytesExpectedToSend in
//            print(bytesSent,totalBytesSent,totalBytesExpectedToSend)
        }
        if let putRequest = self.putRequest {
            let task = self.client?.putObject(putRequest)
            task?.continue({ task -> Any? in
                if let putError = task.error {
                    failed(putError as NSError)
                } else {
                    let urlStr = "\(self.UrlPrefixed)\(putRequest.objectKey)"
                    succees(urlStr)
                }
                self.putRequest = nil
                return nil
            })
        }
    }
    
    func putImages(images: Array<UIImage>, compression: Bool, succees: @escaping (Array<String>) ->(), failed: @escaping (NSError) -> ()) -> Void {
        var imageUrls = Array<String>()
        for index in 0..<images.count {
            let image = images[index]
            self.putImage(image: image, compression: compression, succees: { url in
                print(url)
                imageUrls.append(url)
                if imageUrls.count >= images.count {
                    succees(imageUrls)
                }
            }) { error in
                print(error.description)
                failed(error)
                return
            }
        }
    }
    
    func normalRequestCancel() {
        if let putRequest = self.putRequest {
            putRequest.cancel()
        }
    }
    
    func fileNmae(length: Int) -> String {
        let components = NSCalendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: Date())
        var string = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(Characters.count)))
            string.append(Characters[index])
        }
        return "tomato-pulp/\(String(describing: components.year!))/\(String(describing: components.month!))/\(String(describing: components.day!))/\(string)"
    }

}
