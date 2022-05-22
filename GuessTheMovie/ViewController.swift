//
//  ViewController.swift
//  CompleteTheMovieTitle
//
//  Created by Osama Gamal on 25/05/2021.
//

import UIKit

protocol MoviesView: AnyObject {
    func onRandomMovieRetrieval()
    func showSubmittionAlert(message: String)
    func presentAlert(title: String, description: String)
    func showLoader()
    func hideLoader()
}


class ViewController: UIViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    
    var moviesViewPresenter: MoviesViewPresenter?
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    func initialSetup() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        moviesViewPresenter = MoviesViewPresenter.init(view: self)
        moviesViewPresenter?.getAllMovies()
    }
    
    
    @IBAction func answerTapped(_ sender: UIButton) {
       
        self.moviesViewPresenter?.answer = sender.currentTitle
        self.moviesViewPresenter?.answerSubmitted()
        
    }
}

extension ViewController: MoviesView {
   
    func onRandomMovieRetrieval() {
        
        DispatchQueue.main.async {
            
            if let movie = self.moviesViewPresenter?.randomMovie {
                let name =  movie.name.components(separatedBy: " ")
                let missingWord = name.last ?? ""
                
                self.movieTitleLabel.text = movie.name.replacingOccurrences(of: missingWord, with: "......")
                                
                self.movieImageView.image = UIImage(named: movie.image)
                var answers = movie.wrongAnswers
                answers.append(missingWord)
                answers.shuffle()
                
                
                self.answer1.setTitle(answers[0], for: .normal)
                self.answer2.setTitle(answers[1], for: .normal)
                self.answer3.setTitle(answers[2], for: .normal)
                self.answer4.setTitle(answers[3], for: .normal)
            }
        }
    }
    
    func showSubmittionAlert(message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Another Random Quiz", style: .default, handler: { [weak self] _ in
            
            self?.moviesViewPresenter?.getRandomMovie()
            self?.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func presentAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
  
}
