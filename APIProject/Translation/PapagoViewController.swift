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
    @IBOutlet var textField: UITextField!
    
    let pickerView = UIPickerView()
    
    let headers: HTTPHeaders = [
        "X-Naver-Client-Id": "RlwTxOqSWMaHHOAGCMH8",
        "X-Naver-Client-Secret": APIKey.naverKey
    ]
    var langCode: String = ""
    let placeholder = "번역할 내용을 입력하세요."
    
    let targetLang : KeyValuePairs = ["한국어": "ko", "영어": "en", "일본어": "ja", "중국어 간체": "zh-CN", "중국어 번체": "zh-TW", "베트남어": "vi", "인도네시아어": "id", "태국어": "th", "독일어": "de", "러시아어": "ru", "스페인어": "es", "이탈리아어": "it", "프랑스어": "fr", ]
    var targetCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.inputView = pickerView
        textField.tintColor = .clear
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.placeholder = "번역할 언어를 선택하세요."
        
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.delegate = self
        
        translateTextView.text = ""
        translateTextView.isEditable = false
        
        pickerView.delegate = self
        pickerView.dataSource = self

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
        //2. 입력한 텍뷰.텍스트가 한국어로 번역
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let parameters: Parameters = [
            "source": langCode,
            "target": targetCode,
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
        
        view.endEditing(true)
        
    }

}

extension PapagoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return targetLang.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return targetLang[row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = targetLang[row].key
        targetCode = targetLang[row].value
    }
    
}

extension PapagoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        callLangCode()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}
