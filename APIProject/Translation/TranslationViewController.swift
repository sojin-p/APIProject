//
//  TranslationViewController.swift
//  APIProject
//
//  Created by 박소진 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslationViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var translateTextView: UITextView!
    @IBAction func requestButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        
        //1. 버튼을 누르면 해당 텍뷰.텍스트가 어떤 언어인지 응답 받기
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": "RlwTxOqSWMaHHOAGCMH8",
            "X-Naver-Client-Secret": ""
        ]
        AF.request(url, method: .post, headers: headers).validate().responseJSON { response in
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
