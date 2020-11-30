
import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
  @IBOutlet weak var show: UISwitch!
  
  @IBOutlet weak var menu: UIStackView!
  var lastPoint = CGPoint.zero
  var color = UIColor.black
  var brushWidth: CGFloat = 10.0
  var opacity:CGFloat = 1.0
  var swiped = false
  
  
  // MARK: - Actions
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func switchChanged(_ sender: UISwitch) {
    menu.isHidden = !show.isOn
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    guard let touch = touches.first else {
      return
    }
    swiped = false
    lastPoint = touch.location(in: view)
  }
  var imagePicker = UIImagePickerController()
  @IBAction func imageChoose(_ sender: Any) {
    imagePicker.delegate = self
    imagePicker.sourceType = .savedPhotosAlbum
    imagePicker.allowsEditing = false
    present(imagePicker, animated: true, completion: nil)
  }
  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)
    
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    context.strokePath()
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = true
    let currentPoint = touch.location(in: view)
    drawLine(from: lastPoint, to: currentPoint)
    
    lastPoint = currentPoint
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      drawLine(from: lastPoint, to: lastPoint)
    }
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempImageView.image = nil
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navController = segue.destination as? UINavigationController
    else {
      return
    }
    if let settingsController = navController.topViewController as? SettingsViewController{
      settingsController.delegate = self
      settingsController.brush = brushWidth
      settingsController.opacity = opacity
    }
    if let colorController = navController.topViewController as? ColorViewController{
      colorController.delegate = self
    }
  }
  
  @IBAction func resetPressed(_ sender: Any) {
    mainImageView.image = nil
  }
  
  @IBAction func sharePressed(_ sender: Any) {
    guard let image = mainImageView.image else {
      return
    }
    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    present(activity, animated: true)
  }
  
  @IBAction func pencilPressed(_ sender: UIButton) {
    guard let pencil = Pencil(tag: sender.tag) else {
      return
    }
    color = pencil.color
    if pencil == .eraser {
      opacity = 1.0
    }
  }
  
  
  @IBAction func save(_ sender: Any) {
    let image = mainImageView.image!
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    
  }
}
//  - SettingsViewControllerDelegate

extension ViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
    brushWidth = settingsViewController.brush
    opacity = settingsViewController.opacity
    dismiss(animated: true)
  }
}

extension ViewController: ColorViewControllerDelegate {
  func colorViewControllerFinished(_ colorViewController: ColorViewController) {
    color = UIColor(red: colorViewController.red, green: colorViewController.green, blue: colorViewController.blue, alpha: 1.0)
    dismiss(animated: true)
  }
  
  
}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    self.dismiss(animated: true, completion: nil)
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    guard let image = info[.originalImage] as? UIImage else { return }
    //        mainImageView.image = image
    if let img = image.cgImage{
      tempImageView.image?.draw(in: view.bounds)
      context.draw(img, in: CGRect(x: 0, y: 0, width: img.width, height: img.height))
      tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      tempImageView.alpha = opacity
      UIGraphicsEndImageContext()
    }
  }
  
}


