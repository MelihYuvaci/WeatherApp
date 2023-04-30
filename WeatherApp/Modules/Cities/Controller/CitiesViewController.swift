//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Melih Yuvacı on 30.04.2023.
//

import UIKit

class CitiesViewController: UIViewController{
    
    
    @IBOutlet weak var tableView: UITableView!
    private var items = ["Manisa","Kayseri","Ankara"]
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(.init(nibName: "CitiesCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.delegate = self
        tableView.dataSource = self
        weatherManager.delegate = self
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Şehir Ekleyin", message: "Hangi Şehirin Hava Durumunu Görmek İstiyorusanız Ekleyiniz", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Şehir girin"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let textField = alertController.textFields?.first,
               let text = textField.text {
                self.items.append(text)
                self.tableView.reloadData()
                print("Eklendi: \(text)")
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension CitiesViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            if let indexPath = self.tableView.indexPathsForVisibleRows?.first(where: { $0.row == self.items.firstIndex(of: weather.cityName) }) {
                if let cell = self.tableView.cellForRow(at: indexPath) as? CitiesCell {
                    cell.cityLabel.text = weather.cityName
                    cell.conditionImageView.image = UIImage(named: weather.conditionName)
                    cell.tempratureLabel.text = "\(weather.temperatureString)°"
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: - Configure

extension CitiesViewController {
    func configureCell(_ cell: CitiesCell, indexPath: IndexPath) {
        let city = items[indexPath.row]
        cell.cityLabel.text = city
        weatherManager.fetchWeather(cityName: city)
    }
}

//MARK: - UITableViewDelegate

extension CitiesViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //TODO
        navigationController?.popViewController(animated: true)
        
    }
}

//MARK: - UITableViewDataSource

extension CitiesViewController : UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! CitiesCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let alertController = UIAlertController(title: "Delete?", message: "Are you want to delete this city", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "NO", style: .default))
            alertController.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { _ in
                self.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            present(alertController, animated: true)
        }
    }
    
}
