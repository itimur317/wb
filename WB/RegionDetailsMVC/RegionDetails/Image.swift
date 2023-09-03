import UIKit

struct Image {
    let url: URL
    let uiImage: UIImage?
    
    init(
        url: URL,
        uiImage: UIImage? = nil
    ) {
        self.url = url
        self.uiImage = uiImage
    }
}
