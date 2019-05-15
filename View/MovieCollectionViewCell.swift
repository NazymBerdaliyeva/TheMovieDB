//
//  MovieCollectionViewCell.swift
//  TheMovieDB
//
//  Created by mac on 5/2/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class MovieCollectionViewCell: UICollectionViewCell {
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 210/255.5, green: 210/255.5, blue: 210/255.5, alpha: 1.0)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "film")
        return imageView
    }()
    
    func configureViews(){
        self.contentView.addSubview(posterImageView)
    }
    
    func configureConstraints(){
        let width = AppDelegate.mainWidth
        
        posterImageView.easy.layout(
            CenterX(),
            Top(width*0.032),
            Height(width*0.36),
            Width(width*0.36),
            Right(5)
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
