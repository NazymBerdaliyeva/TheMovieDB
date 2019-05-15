//
//  MoviesByGenreViewController.swift
//  TheMovieDB
//
//  Created by mac on 5/2/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class MoviesByGenreViewController: UIViewController {
    
    var movies = [Movie]()
    var genreId: Int?
    
    lazy var MovieCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var view: UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let size = (self.view.frame.width - 4) / 2
        flowLayout.itemSize = CGSize(width: size, height: size)
        view.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieId")
        return view
    }()
    
    func configureView() {
        self.view.addSubview(MovieCollectionView)
        self.view.backgroundColor = .white
    }
    
    func configureConstraints() {
        let width = AppDelegate.mainWidth
        let height = AppDelegate.mainHeight
        
        MovieCollectionView.easy.layout (
            Width(width),
            Height(height),
            CenterX(),
            Top(width*0.061)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if genreId != nil {
            fetchMovies(genreId: genreId!) { (results: [Movie]) in
                for result in results {
                    self.movies.append(result)
                }
            }
        }
        configureView()
        configureConstraints()
        self.MovieCollectionView.dataSource = self
        self.MovieCollectionView.reloadData()
    }
    func fetchMovies(genreId: Int, completion: @escaping ([Movie]) -> ()) {
        let jsonUrlString = "https://api.themoviedb.org/3/discover/movie?api_key=02da584cad2ae31b564d940582770598&with_genres=" + String(genreId)
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                var movieDictionary: [Movie] = []
                guard let data = data else { return }
                do {
                    let movieObject = try JSONDecoder().decode(PopularMovie.self, from: data)
                    guard let movObj = movieObject.results else {return}
                    movieDictionary = movObj
                    
                    guard let movie = movieDictionary as? [Movie] else {return}
                    self.movies = movie
                     DispatchQueue.main.async {
                    self.MovieCollectionView.reloadData()
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                completion(movieDictionary)
            }
            }.resume()
    }
}
extension MoviesByGenreViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie: Movie
        movie = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieId", for: indexPath) as! MovieCollectionViewCell
        let imageUrl = "https://image.tmdb.org/t/p/w500" + movie.poster_path!
        if let url = URL(string: imageUrl){
            DispatchQueue.main.async {
                cell.posterImageView.setImage(from: url)
            }
        }
        return cell
    }
}
extension MoviesByGenreViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: Movie
        movie = movies[indexPath.row]
        let detailVc = DetailViewController()
        detailVc.movieId = movie.id
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}
