//
//  ViewController.swift
//  SozlukUygulamasi
//
//  Created by İlker Kaya on 30.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    @IBOutlet weak var kelimeTableView: UITableView!
    
    var kelimeListesi = [Kelimeler]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        veritabaniKopyala()
        tumKelimelerAl()
        
        kelimeTableView.delegate = self
        kelimeTableView.dataSource = self
        
        searchbar.delegate = self
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        
        let gidilecekVC = segue.destination as! KelimeDetayViewController
        
        gidilecekVC.kelime = kelimeListesi[indeks!]
    }
    
    func veritabaniKopyala(){
        let bundleYolu = Bundle.main.path(forResource: "sozluk", ofType: ".sqlite")
        
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!
        
        let fileManager = FileManager.default
        
        let kopyanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("sozluk.sqlite")
        
        if fileManager.fileExists(atPath: kopyanacakYer.path){
            print("Veritabanı zaten var kopyalamaya gerek yok")
        }else{
            do{
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyanacakYer.path)
            }catch{
                print(error)
            }
        }
        
    }
    func tumKelimelerAl(){
        let url = URL(string: "http://kasimadalan.pe.hu/sozluk/tum_kelimeler.php")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("hata")
                return
            }
            
            do{
                let cevap = try JSONDecoder().decode(SozlukCevap.self, from: data!)
                if let gelenKelimeListesi = cevap.kelimeler {
                    self.kelimeListesi = gelenKelimeListesi
                }
                DispatchQueue.main.async {
                    self.kelimeTableView.reloadData()
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    func aramaYap(aramaKelimesi:String){
        var request = URLRequest(url: URL(string: "http://kasimadalan.pe.hu/sozluk/kelime_ara.php")!)
        request.httpMethod = "POST"
        
        let postString = "ingilizce=\(aramaKelimesi)"
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || data == nil {
                print("hata")
                return
            }
            
            do{
                let cevap = try JSONDecoder().decode(SozlukCevap.self, from: data!)
                if let gelenKelimeListesi = cevap.kelimeler {
                    self.kelimeListesi = gelenKelimeListesi
                }
                DispatchQueue.main.async {
                    self.kelimeTableView.reloadData()
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kelimeListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kelime = kelimeListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kelimeHucre", for: indexPath) as! KelimeTableViewCell
        
        cell.ingilizcelabel.text = kelime.ingilizce
        cell.turkcelabel.text = kelime.turkce
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toKelimeDetay", sender: indexPath.row)
        
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama Sonucu : \(searchText)")
        
        aramaYap(aramaKelimesi: searchText)
        
        
        kelimeTableView.reloadData()
    }
}

