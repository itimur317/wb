import UIKit

final class ImagesCarouselView: UIView,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout,
                                UIScrollViewDelegate {
    private var images: [Image] = []
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewFlowLayout
        )
        collectionView.register(
            ImagesCarouselCell.self,
            forCellWithReuseIdentifier: ImagesCarouselCell.reuseIdentifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = ColorPalette.appBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(didChangedValue), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorPalette.appBackground
        
        addSubview(collectionView)
        addSubview(pageControl)
        setUpContent()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with images: [Image]) {
        if self.images == images { return }
        
        self.images = images
        pageControl.numberOfPages = images.count
        
        collectionView.reloadData()
    }
    
    private func setUpContent() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 435 / 1024)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc
    private func didChangedValue(_ sender: Any) {
        collectionView.scrollToItem(
            at: IndexPath(row: pageControl.currentPage, section: 0),
            at: .bottom,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagesCarouselView {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: bounds.width, height: bounds.height)
    }
}

// MARK: - UICollectionViewDataSource
extension ImagesCarouselView {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImagesCarouselCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesCarouselCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: images[indexPath.row])
        print("indexP", indexPath)
        //        pageControl.currentPage = indexPath.row
        return cell
    }
}
