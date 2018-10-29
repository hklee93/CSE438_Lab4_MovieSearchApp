//
//  FavoriteViewController.swift
//  HakkyungLee-Lab4_v2
//
//  Created by Hakkyung on 2018. 10. 21..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//
//  Reference:
//  deleting: https://stackoverflow.com/questions/40156274/deleting-a-row-from-a-uitableview-in-swift-3
//  right swipe: https://chariotsolutions.com/blog/post/uitableview-swipe-actions-in-ios-11/

import UIKit

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var myTableView: UITableView!
    var theData:[Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        grabFromDB()
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return theData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = theData[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            
            let movieID = theData[indexPath.row].id!
            deleteFromDB(id: movieID)
            theData.remove(at: indexPath.row)
            myTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "DetailedView") as! DetailedViewController
        
        let movie = theData[indexPath.row]
        
        detailedVC.id = movie.id
        detailedVC.movieTitle = movie.title
        detailedVC.imagePath = movie.poster_path
        detailedVC.date = movie.release_date
        detailedVC.voteCount = movie.vote_count
        detailedVC.voteAvg = movie.vote_average
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let rightSwipe = self.contextualRightSwipe(forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [rightSwipe])
    }
    
    func contextualRightSwipe(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction{
        
        let action = UIContextualAction(style: .normal, title: "Trailer"){
            
            (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.launchWebView(indexPath: indexPath)
            completionHandler(true)
        }
        
        action.backgroundColor = UIColor.blue
        return action
    }
    
    func launchWebView(indexPath: IndexPath){
        
        let webVC = storyboard!.instantiateViewController(withIdentifier: "MyWebView") as! WebViewController
        
        let baseURL:String = "https://m.youtube.com/results?q="
        let title:String = theData[indexPath.row].title
        let cleaned = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalURL:String = baseURL + cleaned!
        let url = URL(string: finalURL)!
        let myURLRequest = URLRequest(url: url)
        webVC.myURLRequest = myURLRequest
        
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func grabFromDB(){
        
        let thePath = Bundle.main.path(forResource: "favorites", ofType: "db")
        let contactDB = FMDatabase(path: thePath)
        
        if !(contactDB.open()){
            
            print("Unable to open database")
            return
        }
        else{
            
            theData = []
            do{
                let results = try contactDB.executeQuery("SELECT * FROM movie", values: nil)
                while(results.next()){
                    
                    let movie = Movie(vote_count: Int(results.int(forColumn: "VOTE_COUNT")), id: Int(results.int(forColumn: "ID")), vote_average: results.double(forColumn: "VOTE_AVG"), title: results.string(forColumn: "TITLE")!, poster_path: results.string(forColumn: "POSTER_PATH")!, overview: "", release_date: results.string(forColumn: "DATE")!)
                    
                    theData.append(movie)
                    print("Loaded from DB")
                }
            }
            catch let error as NSError{
                
                print("failed \(error)")
            }
        }
        
        contactDB.close()
    }
    
    func deleteFromDB(id: Int){
        
        let thePath = Bundle.main.path(forResource: "favorites", ofType: "db")
        let contactDB = FMDatabase(path: thePath)
        
        if !(contactDB.open()){
            
            print("Unable to open database")
            return
        }
        else{
            
            do{
                _ = try contactDB.executeUpdate("DELETE FROM movie WHERE ID = (?)", values: [id])
                print("Deleted from DB")
            }
            catch let error as NSError{
                
                print("failed \(error)")
            }
        }
        
        contactDB.close()
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
