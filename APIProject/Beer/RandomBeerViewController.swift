//
//  RandomBeerViewController.swift
//  APIProject
//
//  Created by 박소진 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class RandomBeerViewController: UIViewController {

    @IBOutlet var randomTitle: UILabel!
    @IBOutlet var beerImage: UIImageView!
    @IBOutlet var beerName: UILabel!
    @IBOutlet var beerDescription: UITextView!
    @IBOutlet var randomButton: UIButton!
    
    var randomBeer: [Beer] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        callRandomRequest()
        configureButton()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomTitle.text = "오늘은 이 맥주를 추천합니다!"
        randomTitle.font = .boldSystemFont(ofSize: 20)

    }
    
    @IBAction func randomButtonClicked(_ sender: UIButton) {
        callRandomRequest()
    }
    
    func callRandomRequest() {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let beerName = json[0]["name"].stringValue
                let image = json[0]["image_url"].stringValue
                let description = json[0]["description"].stringValue
//                
//                if image.contains("\\") {
//                    let removeSlash = "\\".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                }
//                
                self.beerName.text = beerName
                self.beerName.font = .boldSystemFont(ofSize: 17)
                self.beerName.numberOfLines = 0
                self.beerDescription.text = description
                
                let url = URL(string: image)
                self.beerImage.kf.setImage(with: url)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureButton() {
        var config = UIButton.Configuration.plain()
        config.title = "다른 맥주 추천받기"
        config.image = UIImage(systemName: "hand.thumbsup")
        config.baseForegroundColor = .black
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.buttonSize = .mini
        
        randomButton.configuration = config
        randomButton.layer.borderWidth = 1
        randomButton.layer.borderColor = UIColor.black.cgColor
        randomButton.backgroundColor = .systemGray6
        randomButton.layer.cornerRadius = 20
    }
}
