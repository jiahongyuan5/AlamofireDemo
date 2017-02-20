//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by 贾宏远 on 2017/2/20.
//  Copyright © 2017年 xinguangnet. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleGetButtonAction(_ sender: UIButton) {
        Alamofire.request("http://rap.taobao.org/mockjsdata/12318/vly/resource/getCityList").responseJSON { (response) in
            print(response.request ?? "request")
            print(response.response ?? "response")
            print(response.data ?? "data")
            print(response.result)
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            
        }
        
    }
    
    @IBAction func handlePostButtonAction(_ sender: UIButton) {
        Alamofire.request("http://rap.taobao.org/mockjsdata/12318/vly/resource/getCityList", method: .post, parameters: ["citycode": "10010"], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func handleUploadButtonAction(_ sender: UIButton) {
        guard let fileURL = Bundle.main.url(forResource: "1", withExtension: "jpg") else {
            return
        }
        let uploadURL = "http://picupload.service.weibo.com/interface/pic_upload.php"
        Alamofire.upload(fileURL, to: uploadURL).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
        guard let data = "upload data demo".data(using: .utf8) else {
            return
        }
        Alamofire.upload(data, to: "http://picupload.service.weibo.com/interface/pic_upload.php").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func handleUploadFormDataButtonAction(_ sender: UIButton) {
        guard let data = "upload data demo".data(using: .utf8) else {
            return
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "testData", fileName: "image.png", mimeType: "image/png")
        }, to: "http://picupload.service.weibo.com/interface/pic_upload.php") { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @IBAction func handleDownloadButtonAction(_ sender: UIButton) {
        Alamofire.download("https://httpbin.org/image/png").responseData { (response) in
            if let data = response.result.value {
                let image = UIImage(data: data)
            }
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("pig.png")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download("https://httpbin.org/image/png", to: destination).response { (response) in
            if response.error == nil, let imagePath = response.destinationURL?.path {
                let image = UIImage(contentsOfFile: imagePath)
            }
        }
        
        Alamofire.download("https://httpbin.org/image/png").downloadProgress { (progress) in
            print(progress.fractionCompleted)
        }.responseData { (response) in
            if let data = response.result.value {
                let image = UIImage(data: data)
            }
        }

    }
    

}

