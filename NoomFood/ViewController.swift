//
//  ViewController.swift
//  NoomFood
//
//  Created by Scott Marchington on 10/1/21.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FoodCell.self, forCellReuseIdentifier: "FOOD")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    var food: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        search(text: "chicken")
    }
    
    func setupView() {
        var constraints: [NSLayoutConstraint] = []
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        constraints += [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        constraints += [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        view.setNeedsLayout()
    }
}


// MARK: - API Interaction
private extension ViewController {
    func search(text: String) {
        APIClient().searchFood(text: text) { [weak self] result in
            switch result {
            case let .success(food):
                self?.handleSuccess(food: food)
            case let .failure(error):
                self?.handleFailure(error: error)
            }
        }
    }
    
    func handleSuccess(food: [Food]) {
        self.food = food
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func handleFailure(error: APIClient.Error) {
        self.food = []
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        // do something with error
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return food.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FOOD", for: indexPath)
        guard let foodCell = cell as? FoodCell else {
            fatalError()
        }

        foodCell.label.text = food[indexPath.row].name

        return foodCell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFood = food[indexPath.row]
        let alert = UIAlertController(title: "FOOD!", message: "You selected \(selectedFood.name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
