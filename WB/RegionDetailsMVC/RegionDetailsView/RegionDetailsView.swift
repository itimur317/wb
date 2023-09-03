import UIKit

protocol RegionDetailsViewDelegate: AnyObject {
    func didReact(on regionDetails: RegionDetails)
}

final class RegionDetailsView: UIView,
                               UITableViewDataSource,
                               RegionDetailsCellDelegate {
    weak var delegate: RegionDetailsViewDelegate?
    
    private var regionDetails: RegionDetails?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorPalette.appBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(
            RegionDetailsCell.self,
            forCellReuseIdentifier: RegionDetailsCell.reuseIdentifier
        )
        tableView.register(
            RegionDetailsImagesCarouselCell.self,
            forCellReuseIdentifier: RegionDetailsImagesCarouselCell.reuseIdentifier
        )
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var cellsData: [RegionDetailsCellData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorPalette.appBackground
        
        addSubview(tableView)
        setUpConstraints()
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(_ regionDetails: RegionDetails) {
        if self.regionDetails == regionDetails { return }
        self.regionDetails = regionDetails
        
        cellsData = [
            .images(regionDetails.images),
            .details(regionDetails, self)
        ]
        tableView.reloadData()
    }
    
    private func setUpContent() {
        tableView.dataSource = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension RegionDetailsView {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        cellsData.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellsData[indexPath.row].reuseIdentifier,
            for: indexPath
        ) as? (UITableViewCell & RegionDetailsCellConfigurable) else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        cell.configure(with: cellsData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - RegionDetailsCellDelegate
extension RegionDetailsView {
    func didReact(on regionDetails: RegionDetails) {
        delegate?.didReact(on: regionDetails)
    }
}
