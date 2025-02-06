import Foundation

enum Frame: String, CaseIterable {
    case four_one = "4 X 1"
    case two_two = "2 X 2"
    
    var size: CGSize {
        switch self {
        case .four_one:
            return CGSize(width: 250, height: 700)
        case .two_two:
            return CGSize(width: 400, height: 600)
        }
    }
}
