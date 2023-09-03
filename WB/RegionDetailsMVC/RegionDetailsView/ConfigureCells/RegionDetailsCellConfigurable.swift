import Foundation

protocol RegionDetailsCellConfigurable {
    static var reuseIdentifier: String { get }
    
    func configure(with data: RegionDetailsCellData)
}
