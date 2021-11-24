//
//  MovieTVCell.swift
//  Findmovie
//
//  Created by Kaung Thu Khant on 11/17/21.
//

import UIKit

class MovieTVCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearAndGenreLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "MovieTVCell"
    
    // nib is a way to represent the cell, xib file
    static func nib() -> UINib {
        return UINib(nibName: "MovieTVCell", bundle: nil)
    }
    
    func configure(with model: Movie){
        self.titleLabel.text = model.original_title
        self.yearAndGenreLabel.text = model.release_date
        /*
        var ppath = ""
        if let url = model.poster_path else {
            ppath = "/3o7MpOaDkeAcvxqEjgbIcXrcepB.jpg"
        }
        let data = try! Data(contentsOf: URL(string: url)!)
        self.posterImageView.image = UIImage(data: data)
        */
         self.ratingLabel.text = "\(model.vote_average)"
    }
    
}
