//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Melih Yuvacı on 30.04.2023.
//

import UIKit
import UserNotifications


final class CitiesViewController: UIViewController{
    
    //MARK: - Outlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Properties
    
    private var items = ["Mersin","Ankara","Rize"]
    private var weatherManager = WeatherManager()
    private let center = UNUserNotificationCenter.current()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Actions
    
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
                self.createNotfications(city: text)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
//MARK: - Configure

extension CitiesViewController {
    private func configure(){
        tableView.register(.init(nibName: "CitiesCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.delegate = self
        tableView.dataSource = self
        weatherManager.delegate = self
        center.delegate = self
    }
    
    private func configureCell(_ cell: CitiesCell, indexPath: IndexPath) {
        let city = items[indexPath.row]
        cell.cityLabel.text = city
        weatherManager.fetchWeather(cityName: city)
    }
    private func createNotfications(city: String) {
        // CONTENT
        let content = UNMutableNotificationContent()
        content.title = "Şehir Eklendi ✅"
        content.body = "\(city) hava durumlarınızın arasına eklendi detayları için şehrinize tıklayabilirsiniz 🎊"
        content.sound = UNNotificationSound.default
        
        // TRIGGER
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.4, repeats: false)
        
        // CUSTOM ACTIONS
        
        // Define Action
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        
        // Create Category
        let category = UNNotificationCategory(identifier: "MyNotificationsCategory", actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        // Register Category
        center.setNotificationCategories([category])
        content.categoryIdentifier =  "MyNotificationsCategory"
        
        // REQUEST
        let identifier = "FirstUserNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Something wrong")
            }
        }
    }
}

//MARK: - WeatherManagerDelegate

extension CitiesViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            if let indexPath = self.tableView.indexPathsForVisibleRows?.first(where: { $0.row == self.items.firstIndex(of: weather.cityName) }) {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? CitiesCell else { return }
                cell.cityLabel.text = weather.cityName
                cell.conditionImageView.image = UIImage(named: weather.conditionName)
                cell.tempratureLabel.text = "\(weather.temperatureString)°"
                cell.descriptionLabel.text = weather.description
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}



//MARK: - UITableViewDelegate

extension CitiesViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController else { return }
        vc.selectedCity = items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension CitiesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? CitiesCell else { return UITableViewCell() }
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

//MARK: - UNUserNotificationCenterDelegate

extension CitiesViewController : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
