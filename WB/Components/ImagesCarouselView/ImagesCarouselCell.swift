import UIKit

final class ImagesCarouselCell: UICollectionViewCell {
    static var reuseIdentifier = String(describing: ImagesCarouselCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = ColorPalette.gray
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(with image: Image) {
        imageView.image = image.uiImage
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
