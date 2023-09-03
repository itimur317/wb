import UIKit

protocol RegionListViewCellDelegate: AnyObject {
    func cell(_ height: CGFloat)
    func didReact(on regionDetails: RegionDetails)
}

final class RegionListViewCell: UITableViewCell {
    static var reuseIdentifier = String(describing: RegionListViewCell.self)
    
    weak var delegate: RegionListViewCellDelegate?
    private var regionDetails: RegionDetails?
    
    private let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorPalette.text
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        label.backgroundColor = ColorPalette.appBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let regionImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = Constants.regionImageViewCornerRadius
        imageView.layer.masksToBounds = true
        
        imageView.backgroundColor = ColorPalette.background
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        contentView.isUserInteractionEnabled = true
        backgroundColor = ColorPalette.appBackground
        
        addSubview(title)
        addSubview(regionImageView)
        addSubview(likeButton)
        
        setUpConstraints()
        delegate?.cell(frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        regionDetails = nil
        title.text = nil
        regionImageView.image = nil
    }
    
    func configure(with regionDetails: RegionDetails) {
        self.regionDetails = regionDetails
        
        title.text = regionDetails.title
        likeButton.configure(isLiked: regionDetails.isLiked)
        regionImageView.image = regionDetails.images.first?.uiImage
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            regionImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.regionImageViewInset
            ),
            regionImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.regionImageViewInset
            ),
            regionImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constants.regionImageViewInset
            ),
            regionImageView.heightAnchor.constraint(
                equalTo: regionImageView.widthAnchor,
                multiplier: Constants.regionImageViewResolution
            )
        ])
        
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(
                equalTo: regionImageView.trailingAnchor,
                constant: -Constants.standartInset
            ),
            likeButton.topAnchor.constraint(
                equalTo: regionImageView.bottomAnchor,
                constant: Constants.standartInset
            ),
            likeButton.widthAnchor.constraint(
                equalToConstant: Constants.likeButtonSize
            ),
            likeButton.heightAnchor.constraint(
                equalToConstant: Constants.likeButtonSize
            ),
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(
                equalTo: regionImageView.leadingAnchor
            ),
            title.trailingAnchor.constraint(
                equalTo: likeButton.leadingAnchor,
                constant: -Constants.standartInset
            ),
            title.topAnchor.constraint(
                equalTo: regionImageView.bottomAnchor,
                constant: Constants.standartInset
            ),
            title.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constants.standartInset
            )
        ])
    }
    
    @objc
    private func didTapLikeButton(_ sender: Any) {
        guard let regionDetails else { return }
        
        delegate?.didReact(
            on: regionDetails.isLiked
            ? regionDetails.markedAsUnliked()
            : regionDetails.markedAsLiked()
        )
    }
}

private enum Constants {
    static let labelFontSize = 20.0
    static let regionImageViewCornerRadius = 10.0
    
    static let regionImageViewInset = 15.0
    static let regionImageViewResolution: CGFloat = 435 / 1024
    
    static let likeButtonSize = 20.0
    static let standartInset = 10.0
}
