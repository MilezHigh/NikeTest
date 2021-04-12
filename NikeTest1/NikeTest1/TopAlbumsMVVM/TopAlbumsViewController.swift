//
//  ViewController.swift
//  NikeTest1
//
//  Created by Miles Fishman on 3/6/21.
//

import UIKit

class TopAlbumsViewController: UIViewController {
    
    private var tableView: UITableView?
    private var feedResults: [RSSFeedObjectModel] = []
    
    var viewModel: TopAlbumsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTableView()
        loadData()
    }
}

// MARK: - Helper Methods
extension TopAlbumsViewController {
    func setupController() {
        view.backgroundColor = .white
        title = "Top Albums Feed"
    }
    
    func setupTableView() {
        let tableV = UITableView(frame: view.bounds)
        tableV.accessibilityIdentifier = "TobAlbumsTableView"
        tableV.center = view.center
        tableV.tableFooterView = UIView()
        tableV.delegate = self
        tableV.dataSource = self
        tableV.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            tableV.topAnchor.constraint(equalTo: view.topAnchor),
            tableV.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableV.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableV.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        tableView = tableV
        
        guard let table = tableView else { return }
        view.addSubview(table)
        NSLayoutConstraint.activate(constraints)
    }
    
    func loadData() {
        guard let viewModel = viewModel else { return }
        view.startSpinner()
        viewModel.fetchRSSFeed { [weak self] (result) in
            guard let self = self, let table = self.tableView else { return }
            self.view.endSpinner()

            switch result {
            case .success(let results):
                self.feedResults = results
                table.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - UITableView Methods
extension TopAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlbumTableViewCell(style: .subtitle, reuseIdentifier: "FeedTableViewCell")
        cell.model = feedResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? AlbumTableViewCell else { return }
        let model = feedResults[indexPath.row]
        let detailsViewModel = TopAlbumDetailViewModel(album: model, headerImageData: cell.albumImageView.image?.pngData())
        let detailsController = TopAlbumDetailViewController()
        detailsController.viewModel = detailsViewModel
        
        navigationItem.backButtonTitle = "Back"
        navigationController?.pushViewController(detailsController, animated: true)
    }
}

extension UIView {
    
    func startSpinner() {
        guard subviews.filter({ $0 is UIActivityIndicatorView }).first == nil else { return }
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .gray
        spinner.center = center
        addSubview(spinner)
        spinner.startAnimating()
    }
    
    func endSpinner() {
        guard let spinner = subviews.filter({ $0 is UIActivityIndicatorView }).first else { return }
        spinner.removeFromSuperview()
    }
    
}
