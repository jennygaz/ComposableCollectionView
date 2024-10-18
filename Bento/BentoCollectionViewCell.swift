//
//  BentoCollectionViewCell.swift
//  Bento
//

import UIKit

final class BentoCollectionViewCell: UICollectionViewCell {
    // MARK: - Identifier
    static let identifier: String = "BentoCollectionViewCell"

    // MARK: - Properties
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16.0
        return imageView
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Deprecated in favour of dependency injection")
    }

    // MARK: - Public Methods
    public func configure(with imageURL: String) {
        guard let uiImage = UIImage(named: imageURL) else {
            let placeholder = UIImage(systemName: "photo")
            self.imageView.image = placeholder
            return
        }
        self.imageView.image = uiImage
    }

    // MARK: - Private Methods
    private func configureConstraints() {
        let viewConstraints: [NSLayoutConstraint] = [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
}
