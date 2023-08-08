//
//  ViewController.swift
//  APIProject
//
//  Created by 박소진 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Beer {
    var title: String
    var imageURL: String
}

class BeerViewController: UIViewController {

    @IBOutlet var beerCollectionView: UICollectionView!
    var beerList: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "맥주"
        
        beerCollectionView.delegate = self
        beerCollectionView.dataSource = self
        
        let nib = UINib(nibName: "BeerCollectionViewCell", bundle: nil)
        beerCollectionView.register(nib, forCellWithReuseIdentifier: "BeerCollectionViewCell")
        
        setCollectionViewLayout()
        callRequest()
        
    }
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for i in json.arrayValue {
                    let beerName = i["name"].stringValue
                    let beerImage = i["image_url"].stringValue
                    if beerImage.contains("\\") {
                        let removeSlash = "\\".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    }
                    let data = Beer(title: beerName, imageURL: beerImage)
                    self.beerList.append(data)
                }
                
                self.beerCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }


}

extension BeerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell", for: indexPath) as? BeerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let imageURL = URL(string: beerList[indexPath.item].imageURL)
        
        cell.beerImage.kf.setImage(with: imageURL)
        cell.beerTitle.text = beerList[indexPath.item].title
        cell.beerTitle.font = .boldSystemFont(ofSize: 13)
        
        return cell
    }
    
    func setCollectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 4)

        layout.itemSize = CGSize(width: width / 3, height: width / 1.4)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        beerCollectionView.collectionViewLayout = layout
    }
}

