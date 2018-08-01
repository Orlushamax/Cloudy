//
//  ForecastViewController.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

protocol ForecastViewType: class {
    func showForecast(forecast: [[Forecast]])
    func showCityList(cityList: [City])
    func activityIndicatorStartAnimating()
    func activityIndicatorStopAnimating()
    func showNoDataAlert()
}

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var dataManger: ForecastDataManager?
    private var forecast = [[Forecast]]()
    private var cityArray = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColletcionView()
        setupTableView()
        dataManger = ForecastDataManager(view: self)
        dataManger?.getCityList()
        dataManger?.getWeeklyWeather(cityName: cityArray.first!.name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationController()
    }
    
    private func setupColletcionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.registerReusableCell(CityCollectionViewCell.self)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.setContentOffset(tableView.contentOffset, animated: false)
    }
    
    private func setupNavigationController() {
        let rightButtonItem = UIBarButtonItem(title: "Add city", style: .done, target: self, action: #selector(showAddCity))
        rightButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButtonItem
        let logo = UIImage(named: "cloud")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    @objc private func showAddCity() {
        let ac = UIAlertController(title: "Enter city name", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        
        let okAction = UIAlertAction(title: "Add City", style: .default, handler: { (action) in
            let cityTextField = ac.textFields![0] as UITextField
            guard let cityName = cityTextField.text?.uppercaseFirstCharacter() else { return }
            if !cityName.isEmpty {
                let city = City(name: cityName)
                self.dataManger?.saveCityToRealm(city: city)
                self.dataManger?.getCityList()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
}

extension ForecastViewController: ForecastViewType {
    
    func showForecast(forecast: [[Forecast]]) {
        self.forecast = forecast
        self.tableView.reloadData()
    }
    
    func showCityList(cityList: [City]) {
        self.cityArray = cityList
        collectionView.reloadData()
    }
    
    func activityIndicatorStartAnimating() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func activityIndicatorStopAnimating() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNoDataAlert() {
        self.alert(message: nil, title: "There is no weather forecast about this city")
    }
}

extension ForecastViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return forecast[section].first?.date.stringToDate(format: "yyyy-MM-dd HH:mm:ss")?.dayOfWeek(format: "EEEE, MMM d, yyyy") ?? ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        let forecast = self.forecast[indexPath.section][indexPath.row]
        configureCell(withModel: forecast, cell: cell)
        return cell
    }
    
    private func configureCell(withModel forecast: Forecast, cell: UITableViewCell) {
        cell.selectionStyle = .none

        let time = forecast.date.stringToDate(format: "yyyy-MM-dd HH:mm:ss")?.dateString(format: "HH:mm")
        cell.textLabel?.text = time
        var subtitle = [String]()
        let temperature = ("🌡 \(forecast.temp) °C")
        subtitle.append(temperature)
        let wind = ("🌬 \(forecast.windSpeed) m/s")
        subtitle.append(wind)
        cell.detailTextLabel?.text = subtitle.joined(separator: " ")

        let placeholderImage = UIImage(named: "WeatherIconPlaceholder")

        if let image = forecast.weather.first?.icon {
            if let url = URL(string: "https://openweathermap.org/img/w/\(image).png") {
                cell.imageView?.sd_setImage(with: url, placeholderImage: placeholderImage, options: .refreshCached, completed: nil)
            }
        } else {
            cell.imageView?.image = placeholderImage
        }
    }
}

extension ForecastViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CityCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue CityCollectionViewCell ***")
        }
        cell.configureSelf(withModel: cityArray[indexPath.row])
        return cell
    }
}

extension ForecastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.height - 25, height: self.collectionView.frame.size.height - 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let city = cityArray[indexPath.row]
        dataManger?.getWeeklyWeather(cityName: city.name)
    }
}





