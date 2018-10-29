//
//  DetailedViewController.swift
//  HakkyungLee-Lab4_v2
//
//  Created by Hakkyung on 2018. 10. 21..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    var id: Int!
    var movieTitle: String!
    var imagePath: String!
    var date: String!
    var voteCount: Int!
    var voteAvg: Double!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        self.title = movieTitle!
        dateLabel.text = "Released: \(date!)"
        countLabel.text = "Votes: \(voteCount!)"
        avgLabel.text = "Vote Average: \(voteAvg!)"
        fetchImage()
    }
    
    func fetchImage(){
        
        let baseURL:String = "https://image.tmdb.org/t/p/w500"
        if let imagePath:String = self.imagePath{
            
            let imageQuery:String = baseURL + imagePath
            let url = URL(string: imageQuery)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            imageView.image = image
        }
        else{
            
            imageView.image = nil
        }
    }
    @IBAction func addToFavorites(_ sender: Any) {
        
        let thePath = Bundle.main.path(forResource: "favorites", ofType: "db")
        let contactDB = FMDatabase(path: thePath)
        
        if !(contactDB.open()){
            
            print("Unable to open database")
            return
        }
        else{
            
            do{
                
                try contactDB.executeUpdate("INSERT INTO movie (ID, TITLE, VOTE_COUNT, VOTE_AVG, POSTER_PATH, DATE) values (?, ?, ?, ?, ?, ?)", values: [id!, movieTitle!, voteCount!, voteAvg!, imagePath!, date!])
                print("Inserted into DB")
            }
            catch let error as NSError{
                
                print("failed \(error)")
            }
        }
        
        let alert = UIAlertController(title: "Message", message: "Added to Favorites!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
