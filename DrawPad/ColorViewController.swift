
import Foundation

import UIKit

protocol ColorViewControllerDelegate: class {
  func colorViewControllerFinished(_ colorViewController: ColorViewController)
}

class ColorViewController: UIViewController {
  
  @IBOutlet weak var previewImageView: UIImageView!
  @IBOutlet weak var sliderRed: UISlider!
  @IBOutlet weak var sliderGreen: UISlider!
  @IBOutlet weak var sliderBlue: UISlider!
  @IBOutlet weak var labelRed: UILabel!
  @IBOutlet weak var labelGreen: UILabel!
  @IBOutlet weak var labelBlue: UILabel!
  
  weak var delegate: ColorViewControllerDelegate?
  
  var brush: CGFloat = 50.0
  var opacity: CGFloat = 1.0
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sliderRed.value = Float(red * 255.0)
    labelRed.text = Int(sliderRed.value).description
    sliderGreen.value = Float(green * 255.0)
    labelGreen.text = Int(sliderGreen.value).description
    sliderBlue.value = Float(blue * 255.0)
    labelBlue.text = Int(sliderBlue.value).description
    
    drawPreview()
  }
  
  func drawPreview(){
    UIGraphicsBeginImageContext(previewImageView.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    
    context.setLineCap(.round)
    context.setLineWidth(brush)
    context.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor)
    context.move(to: CGPoint(x: 45, y: 45))
    context.addLine(to: CGPoint(x: 45, y:45))
    context.strokePath()
    previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  // ACTIONS
  
  @IBAction func closePressed(_ sender: Any) {
    delegate?.colorViewControllerFinished(self)
  }
  
  @IBAction func colorChanged(_ sender: UISlider) {
    red = CGFloat(sliderRed.value / 255.0)
    labelRed.text = Int(sliderRed.value).description
    green = CGFloat(sliderGreen.value / 255.0)
    labelGreen.text = Int(sliderGreen.value).description
    blue = CGFloat(sliderBlue.value / 255.0)
    labelBlue.text = Int(sliderBlue.value).description
    
    drawPreview()
  }
}
