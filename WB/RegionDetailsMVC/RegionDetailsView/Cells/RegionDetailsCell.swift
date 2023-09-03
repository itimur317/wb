import UIKit

protocol RegionDetailsCellDelegate: AnyObject {
    func didReact(on regionDetails: RegionDetails)
}

final class RegionDetailsCell: UITableViewCell,
                               RegionDetailsCellConfigurable {
    static var reuseIdentifier = String(describing: RegionDetailsCell.self)
    
    private var regionDetails: RegionDetails?
    weak var delegate: RegionDetailsCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorPalette.text
        label.backgroundColor = ColorPalette.appBackground
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = ColorPalette.gray
        label.backgroundColor = ColorPalette.appBackground
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ColorPalette.appBackground
        contentView.isUserInteractionEnabled = true
        
        addSubview(likeButton)
        addSubview(titleLabel)
        addSubview(viewsCountLabel)
        
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        regionDetails = nil
        
        titleLabel.text = nil
        viewsCountLabel.text = nil
        likeButton.configure(isLiked: false)
    }
    
    func configure(with data: RegionDetailsCellData) {
        guard case let .details(regionDetails, delegate) = data else { return }
        
        self.delegate = delegate
        self.regionDetails = regionDetails
        
        titleLabel.text = regionDetails.title
        viewsCountLabel.text = configureViewsCountText(
            with: regionDetails.viewsCount
        )
        likeButton.configure(isLiked: regionDetails.isLiked)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.standartInset
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.standartInset
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: likeButton.leadingAnchor,
                constant: -Constants.standartInset
            )
        ])
        
        NSLayoutConstraint.activate([
            viewsCountLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor
            ),
            viewsCountLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            viewsCountLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor
            ),
            viewsCountLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constants.standartInset
            )
        ])
        
        NSLayoutConstraint.activate([
            likeButton.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            likeButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constants.buttonTrailingInset
            ),
            likeButton.widthAnchor.constraint(
                equalToConstant: Constants.buttonSize
            ),
            likeButton.heightAnchor.constraint(
                equalToConstant: Constants.buttonSize
            )
        ])
    }
    
    private func configureViewsCountText(with count: Int) -> String {
        let times = (count % 10 == 2 || count % 10 == 3 || count % 10 == 4)
        ? "раза"
        : "раз"
        
        return "Просмотрено \(count) \(times)"
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
    static let standartInset = 10.0
    
    static let buttonTrailingInset = 22.2
    static let buttonSize = 25.0
}
