//
//  AlbumTableViewCell.swift
//  NikeTest1
//
//  Created by Miles Fishman on 3/7/21.
//

import Foundation
import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    var albumImageView: UIImageView = UIImageView()
    
    var model: AlbumObjectModel? = nil {
        didSet {
            guard let model = model else { return }
            textLabel?.text = model.name
            detailTextLabel?.text = model.artistName
            loadImage(from: model.artworkUrl100)
        }
    }
    
    private let api: UtilityAPI = API.instance
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from urlString: String) {
        albumImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        accessoryView = albumImageView
        accessoryView?.startSpinner()
        
        api.fetchImageData(from: urlString) { [weak self] (result) in
            guard let self = self else { return }
            self.accessoryView?.endSpinner()
            
            switch result {
            case .success(let data):
                guard let imageData = data else { return }
                self.albumImageView.image = UIImage(data: imageData)
                
            case .failure(let err):
                print(err.message)
            }
        }
    }
}
