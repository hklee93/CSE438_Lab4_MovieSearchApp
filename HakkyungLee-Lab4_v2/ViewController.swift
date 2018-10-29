//
//  ViewController.swift
//  HakkyungLee-Lab4_v2
//
//  Created by Hakkyung on 2018. 10. 18..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//
//  References:
//  Free tab bar images from https://icons8.com/ios
//  CollectionView from https://www.youtube.com/watch?time_continue=958&v=nPf5X5z0eA4
//  The movie data from https://www.themoviedb.org
//  Popup from https://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift
//  Sharing data between views from https://stackoverflow.com/questions/27651507/passing-data-between-tab-viewed-controllers-in-swift
//  Wrapper for sqlite from https://github.com/ccgus/fmdb


import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBOutlet weak var theSpinner: UIActivityIndicatorView!
    
    var fetchResult:[APIResults] = []
    var theImageCache:[UIImage] = []
    var lang:String = "en"
    var adult:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let cellSize = UIScreen.main.bounds.width / 3 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
        layout.itemSize = CGSize(width: cellSize, height: cellSize + cellSize / 2)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        theCollectionView.collectionViewLayout = layout
        
        searchBar.delegate = self
        setupCollectionView()
        theSpinner.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        lang = Lang.shared.lang
        adult = Lang.shared.switchVal
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        theImageCache = []
        theCollectionView.reloadData()
        searchBar.resignFirstResponder()
        
        theSpinner.isHidden = false
        theSpinner.startAnimating()
        let searchWord = searchBar.text!
        
        DispatchQueue.global().async {
            
            self.fetchDataForCollectionView(keyword: searchWord)
            
            DispatchQueue.main.async {
                
                self.theSpinner.stopAnimating()
                self.theSpinner.isHidden = true
                self.theCollectionView.reloadData()
            }
        }
    }
        
    func setupCollectionView(){
        
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
    }
    
    func fetchDataForCollectionView(keyword: String){
        
        let apiKey:String = "1a0641d65157900ca431780435771d34"
        let cleanedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let dataQuery:String = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=\(lang)&query=\(cleanedKeyword!)&include_adult=\(adult)"
        let url = URL(string: dataQuery)
        if(url != nil){
        
            let data = try! Data(contentsOf: url!)
            fetchResult = [try! JSONDecoder().decode(APIResults.self, from: data)]
            var isEmpty:Bool = false
            
            if(fetchResult[0].results.count == 0){
                
                isEmpty = true
                DispatchQueue.main.async {
                 
                    let alert = UIAlertController(title: "Alert", message: "Result Not Found!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.theSpinner.isHidden = true
                }
            }
            theImageCache = []
            cacheImage(isEmpty: isEmpty)
        }
    }
    
    func cacheImage(isEmpty: Bool){
        
        if(isEmpty == false){
            
            let baseURL:String = "https://image.tmdb.org/t/p/w154"
            for i in 0..<fetchResult[0].results.count{
                
                if(fetchResult[0].results[i].poster_path != nil){
                    
                    let imagePath:String = fetchResult[0].results[i].poster_path!
                    let imageQuery:String = baseURL + imagePath
                    let url = URL(string: imageQuery)
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    theImageCache.append(image!)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return theImageCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MyCollectionViewCell
        let movie = fetchResult[0].results[indexPath.section * 3 + indexPath.row]
        
        if(theImageCache.count == 0){
            
            cell.myCellImageView.image = nil
            cell.theTextView.text = nil
        }
        
        cell.myCellImageView.image = theImageCache[indexPath.row]
        cell.theTextView.text = movie.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "DetailedView") as! DetailedViewController
        
        let movie = fetchResult[0].results[indexPath.section * 3 + indexPath.row]
        
        detailedVC.id = movie.id
        detailedVC.movieTitle = movie.title
        detailedVC.imagePath = movie.poster_path
        detailedVC.date = movie.release_date
        detailedVC.voteCount = movie.vote_count
        detailedVC.voteAvg = movie.vote_average
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */


}

