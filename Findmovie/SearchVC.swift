//
//  ViewController.swift
//  TabBar2.0
//
//  Created by Kaung Thu Khant on 11/6/21.
//

import UIKit
import SafariServices

class SearchVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var movies = [Movie]()
    var moviesList = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTVCell.nib(), forCellReuseIdentifier: MovieTVCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies(){
        // make the text from keyboard goes away
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "+")
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=cefa557c9e390fe95c90c906a05d79f1&query=\(query)")!,
                                   completionHandler: {data, response, error in
                                    guard let data = data, error == nil else {
                                        print("error")
                                        return
                                    }
            var result: MovieResult?
            // decode json into swift
            // data contains the info from API
            // decode that into MovieResult format
            // assign that formated data to result
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("error \(error)")
            }
            
            guard let finalResult = result else{
                return
            }
            
            self.moviesList = finalResult.results
            
            let newMovies = finalResult.results
            self.movies.append(contentsOf: newMovies)
            
            // refresh data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }).resume()
        
    }
    
    
    func imdb(movieID: Int){
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=cefa557c9e390fe95c90c906a05d79f1&language=en-US")!, completionHandler: {data, response, error in
            guard let data = data, error == nil else{
                print("error in searching for imdb id")
                return
            }
            var movieIMDBID: imdbResult?
            do {
                movieIMDBID = try JSONDecoder().decode(imdbResult.self, from: data)
            }
            catch {
                print("error \(error)")
            }
            
            guard let finalID = movieIMDBID else{
                return
            }
            
            // to go around the error of Ambiguous use of 'dispatch_get_main_queue()'
            // cause from Xcode UIView.init(frame:) must be used from main thread only error
            DispatchQueue.global(qos: .background).async {

                // Background Thread

                DispatchQueue.main.async {
                    let url = "https://www.imdb.com/title/\(finalID.imdb_id)"
                    let vc = SFSafariViewController(url: URL(string: url)!)
                    self.present(vc, animated: true)
                }
            }
        }).resume()
    }
    
    enum Result{
        case success(Data)
        case badResponse(HTTPURLResponse)
        case error(Error)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTVCell.identifier, for: indexPath) as! MovieTVCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        imdb(movieID: moviesList[indexPath.row].id)
    }
    
    // set the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }


}

struct MovieResult: Codable {
    let page: Int
    var results: [Movie] = []
}
struct Movie: Codable{
    let original_title: String
    let release_date: String
    let vote_average: Float
    let poster_path: String?
    let id: Int
}

struct imdbResult: Codable{
    let imdb_id: String
}






