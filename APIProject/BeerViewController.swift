//
//  ViewController.swift
//  APIProject
//
//  Created by 박소진 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class BeerViewController: UIViewController {

    @IBOutlet var beerCollectionView: UICollectionView!
    var beerList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                print("JSON: \(json)")
                
                let beerName = json[0]["name"].stringValue
                let beerName2 = json[1]["name"].stringValue
                let beerName3 = json[2]["name"].stringValue
                
                self.beerList.append(contentsOf: [beerName, beerName2, beerName3])
                
                print(beerName,beerName2,beerName3,"되나요")
                
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
        
        cell.beerImage.backgroundColor = .cyan
        cell.beerTitle.text = beerList[indexPath.item]
        cell.beerTitle.backgroundColor = .yellow
        
        return cell
    }
    
    func setCollectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 4)

        layout.itemSize = CGSize(width: width / 3, height: width / 1.7)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        beerCollectionView.collectionViewLayout = layout
    }
}

