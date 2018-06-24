
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

protocol changeCityDelegate{
    func userEnteredACityName(city : String)
}

class ChangeCityViewController: UIViewController {
    
    
    var delegate2 : changeCityDelegate?
   
    @IBOutlet weak var changeCityTextField: UITextField!

     @IBAction func getWeatherPressed(_ sender: AnyObject) {
        let cityEntered = changeCityTextField.text!
      
        delegate2?.userEnteredACityName(city : cityEntered)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
