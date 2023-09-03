import UIKit

protocol ErrorDisplayable: AnyObject {
    func presentAlert(
        with error: NetworkError,
        in viewController: UIViewController,
        completion: (() -> Void)?
    )
}
