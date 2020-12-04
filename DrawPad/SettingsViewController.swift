
import UIKit

protocol SettingsViewControllerDelegate: class {
  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
  
  @IBOutlet weak var sliderBrush: UISlider!
  @IBOutlet weak var sliderOpacity: UISlider!
  @IBOutlet weak var previewImageView: UIImageView!
  @IBOutlet weak var labelBrush: UILabel!
  @IBOutlet weak var labelOpacity: UILabel!
  
  weak var delegate: SettingsViewControllerDelegate?
  
  var brush: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sliderBrush.value = Float(brush)
    labelBrush.text = String(format: "%.1f", brush)
    sliderOpacity.value = Float(opacity)
    labelOpacity .text = String(format: "%.1f", opacity)
    
    drawPreview()
    
  }
  func drawPreview(){
    UIGraphicsBeginImageContext(previewImageView.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    context.setLineCap(.round)
    context.setLineWidth(brush)
    context.move(to: CGPoint(x: 45, y: 45))
    context.addLine(to: CGPoint(x: 45, y:45))
    context.strokePath()
    previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  // ACTIONS
  
  @IBAction func closePressed(_ sender: Any) {
    delegate?.settingsViewControllerFinished(self)
  }
  
  @IBAction func brushChanged(_ sender: UISlider) {
    brush = CGFloat(sender.value)
    labelBrush.text = String(format: "%.1f", brush)
    drawPreview()
  }
  
  @IBAction func opacityChanged(_ sender: UISlider) {
    opacity = CGFloat(sender.value)
    labelOpacity.text = String(format: "%.1f", opacity)
    drawPreview()
  }
}
