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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = ""
        translateTextView.text = ""

    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {

        //1. 버튼을 누르면 해당 텍뷰.텍스트가 어떤 언어인지 응답 받기
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "RlwTxOqSWMaHHOAGCMH8",
            "X-Naver-Client-Secret": APIKey.naverKey
        ]
        let parameters: Parameters = [
            "query": textView.text ?? ""
        ]
        AF.request(url, method: .post, parameters: parameters ,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}
