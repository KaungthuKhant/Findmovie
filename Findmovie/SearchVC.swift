//
//  ViewController.swift
//  TabBar2.0
//
//  Created by Kaung Thu Khant on 11/6/21.
//

import UIKit

class SearchVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var movies = [Movie]()
    
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
        
        print(text)
        
        let query = text.replacingOccurrences(of: " ", with: "+")
        
        movies.removeAll()
        
        //let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=cefa557c9e390fe95c90c906a05d79f1&query=\(query)")
        
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
            
            print("It works: ")
            print(finalResult.results[0].original_title)
            print(finalResult.results[1].original_title)
            print(finalResult.results[2].original_title)
            
            let newMovies = finalResult.results
            self.movies.append(contentsOf: newMovies)
            
            // refresh data
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
        }).resume()
        
    }
     
    
    enum Result{
        case success(Data)
        case badResponse(HTTPURLResponse)
        case error(Error)
    }
    
    /*
    func searchMovies(completionHandler: @escaping (Result) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=cefa557c9e390fe95c90c906a05d79f1&query=the+avengers")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.error(error))
                return
            }
            let response = response as! HTTPURLResponse
            let data = data!
            guard response.statusCode == 200, ["application/json"].contains(response.mimeType ?? "") else {
                completionHandler(.badResponse(response))
                return
            }
            completionHandler(.success(data))
            print("success")
        }
        task.resume()
    }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("this function is called")
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTVCell.identifier, for: indexPath) as! MovieTVCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // show movie details
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
}
