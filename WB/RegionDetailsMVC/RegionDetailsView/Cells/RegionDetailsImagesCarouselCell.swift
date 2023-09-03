import UIKit

final class RegionDetailsImagesCarouselCell: UITableViewCell,
                                             RegionDetailsCellConfigurable {
    static var reuseIdentifier = String(describing: RegionDetailsImagesCarouselCell.self)
    
    private let imagesCarouselView: ImagesCarouselView = {
        let imagesCarouselView = ImagesCarouselView()
        imagesCarouselView.translatesAutoresizingMaskIntoConstraints = false
        return imagesCarouselView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ColorPalette.appBackground
        
        addSubview(imagesCarouselView)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: RegionDetailsCellData) {
        guard case let .images(images) = data else { return }
        imagesCarouselView.configure(with: images)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imagesCarouselView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.verticalInset
            ),
            imagesCarouselView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constants.verticalInset
            ),
            imagesCarouselView.topAnchor.constraint(equalTo: topAnchor),
            imagesCarouselView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
    }
}

private enum Constants {
    static let verticalInset = 10.0
}
