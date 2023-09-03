import UIKit

final class LoadingDisplayer: UIViewController,
                              LoadingDisplayable {
    private let loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.style = .large
        indicator.color = .darkGray
        
        indicator.startAnimating()
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loadingActivityIndicator)
        view.addSubview(blurEffectView)
        
        setUpConstraints()
    }
    
    func showLoading(in viewController: UIViewController) {
        viewController.add(self)
    }
    
    func hideLoading() {
        remove()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            loadingActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
