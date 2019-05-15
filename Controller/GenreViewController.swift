//
//  GenreViewController.swift
//  TheMovieDB
//
//  Created by mac on 4/29/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import EasyPeasy

class GenreViewController: UIViewController {
    
    var genres = [Genre]()
    
    lazy var genresTableView: UITableView = {
        var tableView  = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(GenreTableViewCell.self, forCellReuseIdentifier: "genreCell")
        return tableView
    }()
    
    func configureViews(){
        self.view.addSubview(genresTableView)
    }
    
    func configureConstraints(){
        genresTableView.easy.layout (
            Top(0),
            Bottom(44),
            Left(0),
            Right(0)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        fetchGenre()
        setupNavBar()
        configureViews()
        configureConstraints()
        self.genresTableView.dataSource = self
        self.genresTableView.reloadData()
    }
    
    func setupNavBar(){
    }
    
    func fetchGenre() {
        let jsonUrlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=02da584cad2ae31b564d940582770598"
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                var genreDictionary: [Genre] = []
                guard let data = data else { return }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return}
                    guard let dictionary = json["genres"] as? [[String: Any]] else {return}
                    
                    for genre in dictionary {
                        genreDictionary.append(Genre(json: genre))
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                DispatchQueue.main.async {
                        guard let genre = genreDictionary as? [Genre] else {return}
                        self.genres = genre
                        self.genresTableView.reloadData()
                }
            }
        }.resume()
    }
}

extension GenreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell") as! GenreTableViewCell
        cell.genreLabel.text = genres[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre: Genre
         genre = genres[indexPath.row]
        let detailVc = MoviesByGenreViewController()
        detailVc.genreId = genre.id
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension GenreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 400
    }
}
