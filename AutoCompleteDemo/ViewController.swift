//
//  ViewController.swift
//  AutoCompleteDemo
//
//  Created by masco bazar on 1/1/22.
//

import UIKit

class CellClass: UITableViewCell {
}

class ViewController: UIViewController {
//    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var myTextField: UITextField!
    
    var searching = false
    var allCountry = ["Afghanistan", "Armenia","Australia","Austria", "Bangladesh","Belize", "Belgium","China","Colombia","Dominica"]
    
    var filteredCountry = [String]()
    
    let transparentView = UIView()
    let tableViewDropDown = UITableView()
    
    var selectedButton = UITextField()
//    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableViewDropDown.delegate = self
        tableViewDropDown.dataSource = self
        tableViewDropDown.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        myTextField.addTarget(self, action: #selector(searchRecord), for: .editingChanged)
        
    }

    @objc func searchRecord(sender:UITextField ){
        self.filteredCountry.removeAll()
        let searchData: Int = myTextField.text!.count
        if searchData != 0 {
            searching = true
            for country in allCountry
            {
                if let fruitToSearch = myTextField.text
                {
                    let range = country.lowercased().range(of: fruitToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.filteredCountry.append(country)
                    }
                }
            }
        }else{
            filteredCountry = allCountry
            searching = false
        }
        selectedButton = myTextField
        addTransparentView(frames: myTextField.frame)
        
        tableViewDropDown.reloadData()
    }

    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableViewDropDown.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableViewDropDown)
        tableViewDropDown.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableViewDropDown.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableViewDropDown.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.filteredCountry.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableViewDropDown.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return filteredCountry.count
        }else{
            return allCountry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewDropDown.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if searching {
            cell.textLabel?.text = filteredCountry[indexPath.row]
        }else{
            cell.textLabel?.text = allCountry[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedButton.text = filteredCountry[indexPath.row]
        removeTransparentView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myTextField.resignFirstResponder()
        return true
    }
    
}

