//
//  SearchViewController.swift
//  TheMovieDB
//
//  Created by mac on 5/2/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class SearchViewController: UIViewController {

    var movies = [Movie]()
    var searchResult = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var MovieCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var view: UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let size = (self.view.frame.width - 4) / 3
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
        setupNavBar()
        configureView()
        configureConstraints()
    }
    
    func setupNavBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "What would you like to find?"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func searchMovie(searchText: String, completion: @escaping ([Movie]) -> ()) {
        let jsonUrlString = "https://api.themoviedb.org/3/search/movie?api_key=02da584cad2ae31b564d940582770598&query=" + searchText
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
                    
                    DispatchQueue.main.async {
                            guard let movie = movieDictionary as? [Movie] else {return}
                            self.searchResult = movie
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
extension SearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return searchResult.count
        }
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieId", for: indexPath) as! MovieCollectionViewCell
        let movie : Movie
        if isFiltering() {
            movie = searchResult[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        if movie.poster_path != nil {
            let imageUrl = "https://image.tmdb.org/t/p/w500" + movie.poster_path!
            if let url = URL(string: imageUrl){
                DispatchQueue.main.async {
                    cell.posterImageView.setImage(from: url)
                }
            }
        } else {
            let placeholderImage = UIImage(named: "film")
            cell.posterImageView.image = placeholderImage
        }
        return cell
    }
}
extension SearchViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: Movie
        if isFiltering() {
            movie = searchResult[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        let detailVc = DetailViewController()
        detailVc.movieId = movie.id
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        searchMovie(searchText: searchController.searchBar.text!) { (results: [Movie]) in
            for result in results {
                self.searchResult.append(result)
            }
        }
        MovieCollectionView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
