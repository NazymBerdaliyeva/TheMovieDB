//
//  DetailViewController.swift
//  TheMovieDB
//
//  Created by mac on 4/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class DetailViewController: UIViewController {
    
    var movieId: Int?
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 367, height: 667 * 0.719))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "film")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Action, Fantasy"
        return label
    }()
    
    func configureView() {
        [posterImageView, titleLabel, overviewLabel, releaseYearLabel,
         genreLabel].forEach {
            self.view.addSubview($0)
        }
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func configureConstraints() {
        let width = AppDelegate.mainWidth
        let height = AppDelegate.mainHeight
        
        posterImageView.easy.layout (
            Top(0),
            Height(height*0.719),
            Left(0),
            Right(0)
        )
        titleLabel.easy.layout (
            Top(0.0059).to(posterImageView),
            Left(width*0.026),
            Right(width*0.026)
        )
        releaseYearLabel.easy.layout (
            Top(0.0059).to(titleLabel),
            Left(width*0.026),
            Right(width*0.026)
        )
        overviewLabel.easy.layout (
            Top(0.0059).to(releaseYearLabel),
            Left(width*0.026),
            Right(width*0.026)
        )
        genreLabel.easy.layout (
            Top(0.0059).to(overviewLabel),
            Left(width*0.026),
            Right(width*0.026)
        )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetails(movieId: movieId!)
        configureView()
        configureConstraints()
    }
    
    func fetchMovieDetails(movieId: Int) {
        let jsonUrlString = "https://api.themoviedb.org/3/movie/" + String(movieId) + "?api_key=02da584cad2ae31b564d940582770598"
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                print("hereee")
                guard let data = data else { return }
                do {
                    let movieObject = try JSONDecoder().decode(MovieDetails.self, from: data)
                    let imageUrl = "https://image.tmdb.org/t/p/w500" + movieObject.poster_path!
                    
                    
                    DispatchQueue.main.async {
                        if let url = URL(string: imageUrl){
                            self.posterImageView.setImage(from: url)
                        }
                        self.titleLabel.text = movieObject.title
                        self.releaseYearLabel.text = movieObject.release_date
                        self.overviewLabel.text = movieObject.overview
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                
            }
            }.resume()
    }
}
