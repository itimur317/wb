import UIKit

protocol RegionListViewDelegate: AnyObject {
    func didSelect(_ regionDetails: RegionDetails)
    func didReact(on regionDetails: RegionDetails)
}

final class RegionListView: UIView,
                            UITableViewDataSource,
                            UITableViewDelegate,
                            RegionListViewCellDelegate {
    weak var delegate: RegionListViewDelegate?
    
    private var regionList: RegionList = []
    
    private var cellHeight = UITableView.automaticDimension
    private let listTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorPalette.appBackground
        tableView.separatorStyle = .none
        tableView.register(
            RegionListViewCell.self,
            forCellReuseIdentifier: RegionListViewCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorPalette.appBackground
        addSubview(listTableView)
        setUpConstraints()
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(_ regionList: RegionList) {
        if self.regionList == regionList { return }
        self.regionList = regionList
        
        listTableView.reloadData()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            listTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listTableView.topAnchor.constraint(equalTo: topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpContent() {
        listTableView.delegate = self
        listTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate
extension RegionListView {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        cellHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        delegate?.didSelect(regionList[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension RegionListView {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        regionList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RegionListViewCell.reuseIdentifier,
            for: indexPath
        ) as? RegionListViewCell else { return UITableViewCell() }
        
        cell.configure(with: regionList[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

// MARK: - RegionListViewCellDelegate
extension RegionListView {
    func cell(_ height: CGFloat) {
        cellHeight = height
    }
    
    func didReact(on regionDetails: RegionDetails) {
        delegate?.didReact(on: regionDetails)
    }
}
