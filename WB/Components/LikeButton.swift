import UIKit

final class LikeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImage(named: "heart")
        self.setImage(image, for: .normal)
        self.tintColor = ColorPalette.text
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
        self.backgroundColor = ColorPalette.appBackground
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isLiked: Bool) {
        isLiked
        ? markAsLiked()
        : markAsUnliked()
    }
    
    private func markAsLiked() {
        self.setImage(UIImage(named: "heart.fill"), for: .normal)
    }
    
    private func markAsUnliked() {
        self.setImage(UIImage(named: "heart"), for: .normal)
    }
}
