//
//  gameListCell.swift
//  HW3_GameApp
//
//  Created by Zeynep Nur Altın on 26.05.2024.
//

import UIKit

class gameListCell: UITableViewCell {
    
    static let identifier = "gameListCell"
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(withModel model : Results){
        self.gameTitleLabel.text = model.name
        self.gameReleasedLabel.text = model.released
        
        if let rating = model.rating {
            self.gameRatingLabel.text = String(rating)
        } else {
            print("Rating error")
        }
        
        if let urlString = model.backgroundImage{
            if let url = URL(string: urlString){
                self.gameImage.kf.setImage(with: url)
            } else {
                print("image error")
            }
        }
    }
    
}
