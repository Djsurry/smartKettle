//
//  ViewController.swift
//  Smart Kettle
//
//  Created by David Surry on 2018-05-08.
//  Copyright © 2018 deejpake Studios. All rights reserved.
//
// DAVID IF U EVER NEED TO GO BACK TO HOW IT WAS
// MAKE IT SO WHEN U CLICK A BUTTON IT CALLS
// UPDATELOOP. ALSO CALL A LABEL CURRENT TEMP
// THE CODE IS SAVED IN A FILE IN THE CPP
// SMART KETTLE FOLDER
import UIKit
import Alamofire

func makeTea(callback: @escaping (_:String)->Void) -> Void {
    let url = "http://192.168.2.40:5000/start"
    Alamofire.request(url).responseJSON { response in
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
            
        }
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)") // original server data as UTF8 string
            callback(utf8Text)
        }
    }
    
}
func removeTime() -> Void {
    let url = "http://192.168.2.40:5000/rmAlarm"
    Alamofire.request(url).responseJSON { response in
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
            
        }
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)") // original server data as UTF8 string
        }
    }
    
}
func makeTimerTea(time: String) -> Void {
    let parameters: Parameters = ["time": time]
    let url = "http://192.168.2.40:5000/timer"
    Alamofire.request(url, parameters: parameters).responseJSON { response in
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
            
        }
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)") // original server data as UTF8 string
            
        }
    }
    
}


func makeList() -> Array<String>{
    var list = [String]()
    for i in 0...59{
        if i < 10{
            list.append("0\(String(i))")
        }else{
            list.append(String(i))
        }
    }
    return list
}
func swapTime(hour: Int, min: Int, am: Bool) -> String{
    var hour = hour
    if am{
        if hour == 12{
            hour = 0
        }
    }else{
        if hour != 12{
            hour += 12
        }
    
    }
    return "\(hour) \(min)"
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var hour: String?
    var min: String?
    var meridiem: String?
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    @IBOutlet weak var teaStatus: UILabel!
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button: UIButton!
    let hours = ["1", "2", "3" ,"4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let minutes = makeList()
    let meridiems = ["AM", "PM"]
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1{
            return hours.count
        }else if pickerView == pickerView2{
            return minutes.count
        }else if pickerView == pickerView3{
            return meridiems.count
        }else{
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView == pickerView1{
            return hours[row]
        }else if pickerView == pickerView2{
            return minutes[row]
        }else if pickerView == pickerView3{
            return meridiems[row]
        }else{
            return "1"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        if pickerView == pickerView1{
            hour = hours[row]
            print(hour)
        }else if pickerView == pickerView2{
            min = minutes[row]
            print(min)
        }else if pickerView == pickerView3{
            meridiem = meridiems[row]
            print(meridiem)
        }
    }
    
    func callback1(result: String){
        if result == "failed: water"{
            teaStatus.text = "Tea making failed. Not enough water"
        }else if result == "failed: already in use"{
            teaStatus.text = "Tea making failed. Already in use"
        }else if result == "success"{
            teaStatus.text = "Tea is Ready"
        }
        button2.setTitle("Reset",for: .normal)
    }

    
    @IBAction func startTimer(_ sender: UIButton) {
        
        if button.currentTitle! == "Set Time"{
            
            if meridiem == nil{
                meridiem = "AM"
            }
            if hour == nil{
                hour = "1"
            }
            if min == nil{
                min = "00"
            }
            let hour24 = swapTime(hour: Int(hour!)!, min: Int(min!)!, am: meridiem == "AM")
            makeTimerTea(time: hour24)
            timeLbl.text = "Tea will be ready at \(hour!):\(min!) \(meridiem!)"
            print("Tea will be ready at \(hour)!:\(min)! \(meridiem)")
            pickerView1.isHidden = true
            pickerView2.isHidden = true
            pickerView3.isHidden = true
            button.setTitle("Press to reset",for: .normal)
        }else{
            pickerView1.isHidden = false
            pickerView2.isHidden = false
            pickerView3.isHidden = false
            timeLbl.text = nil
            removeTime()
            button.setTitle("Set Time",for: .normal)
        }
    }
  
    
    @IBAction func makeTea(_ sender: UIButton) {
        if button2.currentTitle! == "Make Tea Now"{
            teaStatus.text = "Tea is being made"
            Smart_Kettle.makeTea(callback: callback1)
            
            
        }else{
            teaStatus.text = nil
            button2.setTitle("Make Tea Now",for: .normal)
        }
        
    }
    
    
  
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView3.delegate = self
        pickerView3.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        
    }

        

}

