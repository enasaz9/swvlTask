//
//  MoviesPresenter.swift
//  GuessTheMovie
//
//  Created by Enas Ahmed Zaki on 22/05/2022.
//

import Foundation

protocol MoviesPresenter: AnyObject {
    init(view: MoviesView)
    func getAllMovies()
    func getRandomMovie()
    func answerSubmitted()
}

class MoviesViewPresenter: MoviesPresenter {
    
    
    weak var view: MoviesView?
    var allMovies: [Movie] = []
   
    var randomMovie: Movie!
    var answer: String!
    required init(view: MoviesView) {
        self.view = view
    }
    
    func getAllMovies() {
        self.view?.showLoader()
        
        let request = MyRequest.init(urlStr: API_URLs.getMovies.rawValue)
        
        NetworkClient.get(request: request) { [weak self] (result: Result<Data, Error>) in
            // Call view to stop the loader
            self?.view?.hideLoader()
            
            switch result {
            case .failure(let error):
                if let error = error as? NetworkError {
                    switch error {
                    case .noData:
                        self?.view?.presentAlert(title: "Error", description: error.localizedDescription)
                        
                    case .networkError:
                        self?.view?.presentAlert(title: "Error", description: error.localizedDescription)
                        
                    }
                } else {
                    self?.view?.presentAlert(title: "Error", description: error.localizedDescription)
                }
                
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let moviesResults = try decoder.decode([Movie].self, from: response)
                    print(moviesResults)
                    
                    self?.allMovies = moviesResults
                    self?.getRandomMovie()
                } catch let error {
                    print("Error: ", error)
                }
            }
        }
    }
    
    func getRandomMovie() {
        self.randomMovie = self.allMovies.randomElement() ?? Movie(name: "The Wolf Of ....", image: "the-wolf-of-wallstreet.jpg", wrongAnswers: [])
        
        self.view?.onRandomMovieRetrieval()
    }
    
    
    func answerSubmitted() {
        var msg = "Answer is correct"
        
        if randomMovie.wrongAnswers.contains(answer) {
           msg = "Answer is not correct"
        }
        
        self.view?.showSubmittionAlert(message: msg)
    }
    
    
}
