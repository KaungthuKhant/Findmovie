//
//  ViewController.swift
//  TabBar2.0
//
//  Created by Kaung Thu Khant on 11/6/21.
//

import SwiftUI


struct ContentView: View {
    var body: some View{
        NavigationView{
            ScrollView{
                HStack{
                    ForEach(0..<10){ num in
                        Text(num.description)
                    }
                }
            }.navigationTitle("Movie Carousel")
        }
    }
}

struct ContentViewPreview: PreviewProvider{
    static var previews: some View {
        ContentView()
    }
}



class HomeVC: UIViewController {
    
    var moviesList = [TrendingMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMovies()
    }
    
    // show trending movies
    
    func searchMovies(){
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=cefa557c9e390fe95c90c906a05d79f1")!,
                                   completionHandler: {data, response, error in
                                    guard let data = data, error == nil else {
                                        print("error")
                                        return
                                    }
            var result: TrendingMovieResult?
            // decode json into swift
            // data contains the info from API
            // decode that into MovieResult format
            // assign that formated data to result
            do {
                result = try JSONDecoder().decode(TrendingMovieResult.self, from: data)
            }
            catch {
                print("error \(error)")
            }
            
            guard let finalResult = result else{
                return
            }
            
            self.moviesList = finalResult.results
            
            let newMovies = finalResult.results
            //self.movies.append(contentsOf: newMovies)
            print("testing")
            print(finalResult.page)
            print(newMovies[0].original_title!)
            if (newMovies[1].original_title == nil){
                print(newMovies[1].original_name!)
            }
            else{
                print(newMovies[1].original_name!)
            }
        }).resume()
        
    }
}



struct TrendingMovieResult: Codable {
    let page: Int
    var results: [TrendingMovie] = []
}
struct TrendingMovie: Codable{
    let original_title: String?
    let release_date: String?
    let vote_average: Float?
    let poster_path: String?
    let original_name: String?
    let id: Int
}
