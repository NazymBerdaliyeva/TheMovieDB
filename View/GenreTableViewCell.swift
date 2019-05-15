//
//  GenreTableViewCell.swift
//  TheMovieDB
//
//  Created by mac on 5/2/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class GenreTableViewCell: UITableViewCell {

    lazy var genreLabel: UILabel = {
        var label = UILabel()
//        label.text = "Документальный"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    func configureViews(){
        contentView.addSubview(genreLabel)
    }
    
    func configureConstraints(){
        let width = AppDelegate.mainWidth
        
        genreLabel.easy.layout(
            CenterX(),
            Top(width*0.053)
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
