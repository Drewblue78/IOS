
import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
  
  var lastPoint = CGPoint.zero
  var color = UIColor.black
  var brushWidth: CGFloat = 10.0
  var opacity:CGFloat = 1.0
  var swiped = false
  
  // MARK: - Actions
  
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
    guard
      let navController = segue.destination as? UINavigationController,
      let settingsController = navController.topViewController as?
    SettingsViewController
    else {
      return
    }
    settingsController.delegate = self
    settingsController.brush = brushWidth
    settingsController.opacity = opacity
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
}
//  - SettingsViewControllerDelegate

extension ViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
    brushWidth = settingsViewController.brush
    opacity = settingsViewController.opacity
    color = UIColor(red: settingsViewController.red, green: settingsViewController.green, blue: settingsViewController.blue, alpha: 1.0)
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
        guard let image = info[.editedImage] as? UIImage else { return }
        tempImageView.image?.draw(in: view.bounds)
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
}

func saveImage(image: UIImage) -> Bool {
    guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
        return false
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return false
    }
    do {
        try data.write(to: directory.appendingPathComponent("fileName.png")!)
        return true
    } catch {
        print(error.localizedDescription)
        return false
    }
}
let success = saveImage(image: UIImage(named: "image.png")!)

  

