import UIKit

protocol RegionDetailsViewControllerDelegate: AnyObject {
    func didReact(on regionDetails: RegionDetails)
    func didUpdateImages(on regionDetails: RegionDetails)
}

final class RegionDetailsViewController: UIViewController,
                                         RegionDetailsViewDelegate {
    weak var delegate: RegionDetailsViewControllerDelegate?
    
    private let regionDetailsView = RegionDetailsView()
    
    private let errorDisplayer: ErrorDisplayable
    private let loadingDisplayer: LoadingDisplayable
    
    private let imageProvider: ImageProviding
    
    private var regionDetails: RegionDetails
    
    init(
        regionDetails: RegionDetails,
        imageProvider: ImageProviding,
        errorDisplayer: ErrorDisplayable = ErrorDisplayer(),
        loadingDisplayer: LoadingDisplayable = LoadingDisplayer()
    ) {
        self.regionDetails = regionDetails
        self.imageProvider = imageProvider
        self.errorDisplayer = errorDisplayer
        self.loadingDisplayer = loadingDisplayer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.appBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        setUpRegionDetailsView()
        setUpContent()
    }
    
    func configure(with delegate: RegionDetailsViewControllerDelegate) {
        self.delegate = delegate
    }
    
    private func setUpRegionDetailsView() {
        regionDetailsView.delegate = self
        regionDetailsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(regionDetailsView)
        NSLayoutConstraint.activate([
            regionDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            regionDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            regionDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            regionDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        regionDetailsView.display(regionDetails)
    }
    
    private func setUpContent() {
        for (index, image) in regionDetails.images.enumerated() where image.uiImage == nil {
            imageProvider.loadImage(by: image.url) { imageResult in
                guard case let .success(loadedImage) = imageResult else { return }
                let updateRegionDetails = self.regionDetails.withUpdated(loadedImage, at: index)
                self.regionDetails = updateRegionDetails
                self.delegate?.didUpdateImages(on: updateRegionDetails)
                self.regionDetailsView.display(updateRegionDetails)
            }
        }
    }
}

// MARK: - RegionDetailsViewDelegate
extension RegionDetailsViewController {
    func didReact(on regionDetails: RegionDetails) {
        self.regionDetails = regionDetails
        delegate?.didReact(on: regionDetails)
        regionDetailsView.display(regionDetails)
    }
}
