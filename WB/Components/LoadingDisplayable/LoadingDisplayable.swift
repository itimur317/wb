import UIKit

protocol LoadingDisplayable: AnyObject {
    func showLoading(in viewController: UIViewController)
    func hideLoading()
}
