//
//  ViewController.swift
//  HW3_GameApp
//
//  Created by Zeynep Nur Altın on 20.05.2024.
//

import UIKit
import Kingfisher

class HomePageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var GameListSearchBar: UISearchBar!
    @IBOutlet weak var SliderCollectionView: UICollectionView!
    @IBOutlet weak var SliderPageControl: UIPageControl!
    @IBOutlet weak var GameListLabel: UILabel!
    @IBOutlet weak var GameListTableView: UITableView!
    @IBOutlet weak var GameListCollectionView: UICollectionView!

    var games = [Results]()
    var imgArray = [String]()
    var timer : Timer?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameListTableView.delegate = self
        GameListTableView.dataSource = self
        GameListCollectionView.delegate = self
        GameListCollectionView.dataSource = self
        SliderCollectionView.delegate = self
        SliderCollectionView.dataSource = self
        GameListTableView.register(UINib(nibName: gameListCell.identifier, bundle: nil), forCellReuseIdentifier: gameListCell.identifier)
        startTimer()
        
        ParsingJson { data in
            self.games = data
            let top3RatedGames = self.findTop3RatedGames(results: data)
            self.imgArray = top3RatedGames.compactMap { $0.backgroundImage ?? "" }
            DispatchQueue.main.async {
                self.SliderPageControl.numberOfPages = self.imgArray.count
                self.SliderCollectionView.reloadData()
                self.GameListTableView.reloadData() 
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == SliderCollectionView{
            imgArray.count
        } else {
            1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == SliderCollectionView{
            let sliderCell = SliderCollectionView.dequeueReusableCell(withReuseIdentifier: "sliderImageCell", for: indexPath) as! SliderCollectionViewCell
            if let url = URL(string: imgArray[currentIndex]){
                sliderCell.SliderImageView.kf.setImage(with: url)
            }
            return sliderCell
        } else {
            let gameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCollectionViewCell", for: indexPath)
            return gameCollectionViewCell
        }
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

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: gameListCell.identifier, for: indexPath) as? gameListCell else {
                return UITableViewCell()
        }
        cell.configure(withModel: games[indexPath.row])
        cell.contentView.backgroundColor = UIColor.yellow
        return cell
    }
}
