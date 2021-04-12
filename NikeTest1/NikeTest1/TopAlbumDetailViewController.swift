//
//  TopAlbumDetailViewController.swift
//  NikeTest1
//
//  Created by Miles Fishman on 3/8/21.
//

import Foundation
import UIKit
import MediaPlayer

class TopAlbumDetailViewController: UIViewController {
    var headerImageView: UIImageView = UIImageView()
    var labelsStackView: UIStackView = UIStackView()
    var albumNameLabel: UILabel = UILabel()
    var artistNameLabel: UILabel = UILabel()
    var musicGenreLabel: UILabel = UILabel()
    var releaseDate: UILabel = UILabel()
    var copyrightLabel: UILabel = UILabel()
    var scrollView: UIScrollView = UIScrollView()
    var scrollViewInnerView: UIView = UIView()
    var albumLinkButton: UIButton = UIButton()

    var viewModel: TopAlbumDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupController()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.bounds.height))
        scrollView.accessibilityIdentifier = "AlbumDetailScrollView"
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: view.bounds.height)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(constraints)

        scrollViewInnerView.translatesAutoresizingMaskIntoConstraints = false
        let innerConstraints = [
            scrollViewInnerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewInnerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ]
        scrollView.addSubview(scrollViewInnerView)
        NSLayoutConstraint.activate(innerConstraints)
    }
    
    func setupController() {
        view.backgroundColor = .white
        title = viewModel?.album.artistName
        
        API.instance.fetchImageData(from: viewModel?.album.artworkUrl100 ?? "") { [weak self] (result) in
            guard let self = self else { return }
            
            var image: UIImage?
            
            switch result {
            case .success(let data):
                guard let data = data else { return }
                image = UIImage(data: data)
            
            case .failure(let error):
                print(error.message)
            }
            
            self.setupHeader(image: image)
            self.setupStackView()
            self.setupButton()
        }
    }
    
    func setupHeader(image: UIImage?) {
        headerImageView.image = image
        headerImageView.accessibilityIdentifier = "AlbumDetailImageView"
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.clipsToBounds = true
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            headerImageView.topAnchor.constraint(equalTo: scrollViewInnerView.topAnchor,constant: 20),
            headerImageView.leadingAnchor.constraint(equalTo: scrollViewInnerView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: scrollViewInnerView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 4)
        ]
        scrollViewInnerView.addSubview(headerImageView)
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupStackView() {
        let labels = [ albumNameLabel,artistNameLabel,musicGenreLabel,releaseDate,copyrightLabel ]
            .map({ label -> UILabel in
                label.numberOfLines = 0
                label.textColor = .black
                label.font = UIFont.systemFont(ofSize: 12)
                return label
            })
        let stackView = UIStackView(arrangedSubviews: labels)
        
        guard let viewModel = viewModel else { return }
        albumNameLabel.accessibilityIdentifier = "AlbumNameLabel"
        albumNameLabel.text = "Album:\n" + viewModel.album.name
        
        artistNameLabel.accessibilityIdentifier = "ArtistNameLabel"
        artistNameLabel.text = "Artist:\n" + viewModel.album.artistName
        
        musicGenreLabel.accessibilityIdentifier = "AlbumGenreLabel"
        musicGenreLabel.text = "Genre:\n" + (viewModel.album.genres.first?.name ?? "N/A")
        
        releaseDate.accessibilityIdentifier = "AlbumReleaseDateLabel"
        releaseDate.text = "Release Date:\n" + viewModel.album.releaseDate
        
        copyrightLabel.accessibilityIdentifier = "AlbumCopyrightLabel"
        copyrightLabel.text = "Copyright:\n" + viewModel.album.copyright
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            stackView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor,constant: 40),
            stackView.leadingAnchor.constraint(equalTo: scrollViewInnerView.leadingAnchor,constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollViewInnerView.trailingAnchor,constant: -20)
        ]
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        scrollViewInnerView.addSubview(stackView)
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupButton() {
        albumLinkButton.translatesAutoresizingMaskIntoConstraints = false
        let buttonConstraints = [
            albumLinkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            albumLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            albumLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            albumLinkButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        albumLinkButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        albumLinkButton.setTitle("Album Link", for: .normal)
        albumLinkButton.backgroundColor = .black
        view.addSubview(albumLinkButton)
        NSLayoutConstraint.activate(buttonConstraints)
    }
    
    @objc private func buttonPressed() {
        let mp = MPMusicPlayerApplicationController.systemMusicPlayer
        let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [viewModel?.album.id ?? ""])
        mp.openToPlay(descriptor)
    }
}
