//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by mac on 5/1/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class MovieTableViewCell: UITableViewCell {

    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.image = UIImage(named: "film")
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        //label.text = "Звездные войны"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        var label = UILabel()
        //label.text = "Action, Adventure, Science Fiction"
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    func configureViews(){
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        }


    func configureConstraints(){
        let width = AppDelegate.mainWidth
        let height = AppDelegate.mainHeight
        
        posterImageView.easy.layout(
            Left(width*0.056),
            Width(width*0.24),
            Height(height*0.17),
            Top(height*0.02),
            Bottom(height*0.02)
        )
        titleLabel.easy.layout(
            Left(width*0.03).to(posterImageView),
            Right(width*0.056),
            Top(height*0.02)
        )
        genreLabel.easy.layout(
            Top(height*0.02).to(titleLabel),
            Left(width*0.03).to(posterImageView),
            Right(width*0.056)
        )
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

