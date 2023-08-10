//
//  TranslationViewController.swift
//  APIProject
//
//  Created by 박소진 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

class PapagoViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBOutlet var requestButton: UIButton!
    
    let headers: HTTPHeaders = [
        "X-Naver-Client-Id": "RlwTxOqSWMaHHOAGCMH8",
        "X-Naver-Client-Secret": APIKey.naverKey
    ]
    var langCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false

    }
    func callLangCode() {
        
        //1. 버튼을 누르면 해당 텍뷰.텍스트가 어떤 언어인지 응답 받기
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let parameters: Parameters = [
            "query": textView.text ?? ""
        ]
        AF.request(url, method: .post, parameters: parameters ,headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                if statusCode == 200 {
                    self.langCode = json["langCode"].stringValue
                }
                
            case .failure(let error):
                print(error)
            }
        }

    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        callLangCode()
        
        //2. 입력한 텍뷰.텍스트가 한국어로 번역
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let parameters: Parameters = [
            "source": langCode,
            "target": "ko",
            "text": textView.text ?? ""
        ]
        AF.request(url, method: .post, parameters: parameters ,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                switch statusCode {
                case 200:
                    let data = json["message"]["result"]["translatedText"].stringValue
                    self.translateTextView.text = data
                default:
                    print("잠시 후..")
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}
