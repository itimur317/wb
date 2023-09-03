import UIKit

final class ErrorDisplayer: ErrorDisplayable {
    func presentAlert(
        with error: NetworkError,
        in viewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: Constants.errorTitle,
            message: error.rawValue,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: Constants.repeatTitle,
            style: .default
        ) { _ in
            completion?()
        })
        
        alert.addAction(UIAlertAction(
            title: Constants.cancelTitle,
            style: .cancel
        ))
        
        viewController.present(alert, animated: true)
    }
}

private enum Constants {
    static let errorTitle: String = "Ошибка"
    
    static let repeatTitle: String = "Повторить"
    static let cancelTitle: String = "Закрыть"
}
