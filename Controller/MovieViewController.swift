//
//  MovieViewController.swift
//  TheMovieDB
//
//  Created by mac on 4/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class MovieViewController: UIViewController {
    
    var popularMovies = [Movie]()
    var upcomingMovies = [Movie]()
    var movies = [Movie]()
    
    lazy var moviesTableView: UITableView = {
        var tableView  = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        return tableView
    }()
    lazy var categorySegmentedControl: UISegmentedControl = {
        let items = ["Популярные" , "Скоро на экранах"]
        var segmentedControl = UISegmentedControl(items : items)
        segmentedControl.center = self.view.center
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.tintColor = UIColor.purple
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)

        return segmentedControl
    }()
    
    func configureViews(){
        self.view.addSubview(moviesTableView)
    }
    
    func configureConstraints(){
        moviesTableView.easy.layout (
            Top(0),
            Bottom(44),
            Left(0),
            Right(0)
        )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=02da584cad2ae31b564d940582770598"
        fetchMovie(jsonUrlString: url) { (results: [Movie]) in
            for result in results {
                self.popularMovies.append(result)
            }
        }
        self.movies = popularMovies
        setupNavBar()
        configureViews()
        configureConstraints()
        self.moviesTableView.dataSource = self
        self.moviesTableView.reloadData()
    }
  
    
    func setupNavBar(){
        self.navigationItem.titleView = categorySegmentedControl
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(tappedButton))
    }
    
    @objc func tappedButton(){
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            self.movies.removeAll()
            movies = popularMovies
            self.moviesTableView.reloadData()
        case 1:
            self.movies.removeAll()
            let url = "https://api.themoviedb.org/3/movie/upcoming?api_key=02da584cad2ae31b564d940582770598"
                    fetchMovie(jsonUrlString: url) { (results: [Movie]) in
                        for result in results {
                            self.upcomingMovies.append(result)
                        }
             }
            self.movies = upcomingMovies
            
            self.moviesTableView.reloadData()
        default:
            break
        }
    }
    
    func fetchMovie(jsonUrlString: String, completion: @escaping ([Movie]) -> ()) {
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
                            self.movies = movie
                            self.moviesTableView.reloadData()
                    }
                    
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                
                completion(movieDictionary)
                
            }
        }.resume()
    }
}

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableViewCell
        let imageUrl = "https://image.tmdb.org/t/p/w500" + self.movies[indexPath.row].poster_path!
        if let url = URL(string: imageUrl){
            DispatchQueue.main.async {
                cell.posterImageView.setImage(from: url)
            }
        }
        
        cell.titleLabel.text = movies[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = DetailViewController()
        detailVc.movieId = movies[indexPath.row].id
        self.navigationController?.pushViewController(detailVc, animated: true)
        
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 400
    }
}
extension UIImageView {
    func setImage(from url: URL) {
        let urlSession = URLSession(configuration: .default)
        urlSession.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                DispatchQueue.main.async {
                self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
