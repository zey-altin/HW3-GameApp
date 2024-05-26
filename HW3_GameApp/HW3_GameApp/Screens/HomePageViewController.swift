//
//  ViewController.swift
//  HW3_GameApp
//
//  Created by Zeynep Nur Altın on 20.05.2024.
//

import UIKit
import Kingfisher

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var SliderCollectionView: UICollectionView!
    @IBOutlet weak var SliderPageControl: UIPageControl!
    
    var games = [Results]()
    var imgArray = [String]()
    var timer : Timer?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SliderCollectionView.delegate = self
        SliderCollectionView.dataSource = self
        startTimer()
        
        ParsingJson { data in
            self.games = data
            let top3RatedGames = self.findTop3RatedGames(results: data)
            self.imgArray = top3RatedGames.compactMap { $0.backgroundImage ?? "" }
            DispatchQueue.main.async {
                self.SliderPageControl.numberOfPages = self.imgArray.count
                self.SliderCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SliderCollectionView.dequeueReusableCell(withReuseIdentifier: "sliderImageCell", for: indexPath) as! SliderCollectionViewCell
        if let url = URL(string: imgArray[currentIndex]){
            cell.SliderImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    //Timer for slider
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(gameToIndex), userInfo: nil, repeats: true)
    }
    
    @objc func gameToIndex() {
        if currentIndex == imgArray.count - 1 {
            currentIndex = -1
        } else {
            currentIndex += 1
            SliderCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            SliderPageControl.currentPage = currentIndex
        }
    }
    
    //width and height constant for slider images
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: SliderCollectionView.frame.width, height: SliderCollectionView.frame.height)
    }
    
    //space value constant between slider images
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func findTop3RatedGames(results: [Results]) -> [Results]{
        let sortedResults = results.sorted { $0.rating ?? 0 > $1.rating ?? 0 }
        return Array(sortedResults.prefix(3))
    }
}

