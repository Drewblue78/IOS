
import Foundation
import UIKit

enum Pencil {
  case eraser
  
  init?(tag: Int) {
    switch tag {
    
    case 11:
      self = .eraser
    default:
      return nil
    }
  }
  var color: UIColor {
    switch self {
    
    case .eraser:
      return .white
    
    }
  }
}
