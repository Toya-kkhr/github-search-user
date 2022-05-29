//
//  ViewController.swift
//  iOS-task
//
//  Created by Toya on 2022/05/23.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let baseURL = "https://api.github.com/"
    
    var searchUsers: [SearchUsers.items] = []
    var allUsers: [AllUsers] = []
    var alert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        allGetUser()
        
    }
    
    private func setUp() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        searchBar.delegate = self
        
        navigationItem.title = "Github Search User"
        
    }

    private func searchGetUser(q: String) {
        AF.request(baseURL + "search/users?q=\(q)")
            .responseDecodable(of: SearchUsers.self) { res in
            
            switch res.result {
            case .success(let data):
                self.searchUsers = data.items
                self.tableView.reloadData()
                self.dismissIndicator()
                
            case .failure(let err):
                print("Error: ", err)
                self.dismissIndicator()
                self.alert(title: "エラー", message: "情報の取得に失敗しました。\n (半角英数・記号　で入力してください。)")
                
            }
        }
    }
    
    private func allGetUser() {
        
        AF.request(baseURL + "users")
            .responseDecodable(of: [AllUsers].self) { res in
            
            switch res.result {
            case .success(let data):
                self.allUsers = data.self
                self.tableView.reloadData()
                self.dismissIndicator()
                
            case .failure(let err):
                print("Error: ", err)
                self.dismissIndicator()
                self.alert(title: "エラー", message: "情報の取得に失敗しました。\n 時間をおいて再度お試し下さい。")
            }
        }
    }
}

//MARK: - tableview delegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchBar.text == "" {
            return self.allUsers.count
        } else {
            return self.searchUsers.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.imageView?.layer.cornerRadius = 50
        cell.imageView?.clipsToBounds = true
        
        if searchBar.text == "" {
            let allUsers = self.allUsers[indexPath.row]
            let allImage = UIImage(url: allUsers.avatar_url)
            cell.imageView?.image = allImage
            cell.textLabel?.text = allUsers.login
            cell.detailTextLabel?.text = allUsers.type
        } else {
            let searchUsers = self.searchUsers[indexPath.row]
            let searchImage = UIImage(url: searchUsers.avatar_url)
            cell.imageView?.image = searchImage
            cell.textLabel?.text = searchUsers.login
            cell.detailTextLabel?.text = searchUsers.type
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let webView = self.storyboard?.instantiateViewController(withIdentifier: "webView") as! WebViewController
        
        if searchBar.text == "" {
            webView.urlString = allUsers[indexPath.row].html_url
        } else {
            webView.urlString = searchUsers[indexPath.row].html_url
        }
        
        navigationController?.pushViewController(webView, animated: true)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - searchbar delegate
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        startIndicator()
        
        if let text = searchBar.text {
            
            if text == "" {
                allGetUser()
            
            } else {
                searchGetUser(q: text)
            }
        }
    }
}

//MARK: - loading func
extension ViewController {
    
    func startIndicator() {

        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .white

        loadingIndicator.center = self.view.center
        let grayOutView = UIView(frame: self.view.frame)
        grayOutView.backgroundColor = .black
        grayOutView.alpha = 0.6

        // 他のViewと被らない値を代入
        grayOutView.tag = 999

        grayOutView.addSubview(loadingIndicator)
        self.view.addSubview(grayOutView)
        self.view.bringSubviewToFront(grayOutView)

        loadingIndicator.startAnimating()
    }

    func dismissIndicator() {
        self.view.subviews.first(where: { $0.tag == 999 })?.removeFromSuperview()
    }
}

//MARK: - alert func
extension ViewController {
    func alert(title:String, message:String) {
        alert = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alert, animated: true)
    }
}

//MARK: - result empty func
extension ViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "条件に一致するユーザーが \n 見つかりませんでした。"
        
        let attr: [NSAttributedString.Key: Any] =
        [
            .font: UIFont.boldSystemFont(ofSize: 19)
        ]
        
        return NSAttributedString(string: text, attributes: attr)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = UIImage(named: "shiba")!
        
        func resize(image: UIImage, width: Double) -> UIImage {
                
            // オリジナル画像のサイズからアスペクト比を計算
            let aspectScale = image.size.height / image.size.width
            
            // widthからアスペクト比を元にリサイズ後のサイズを取得
            let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
            
            // リサイズ後のUIImageを生成して返却
            UIGraphicsBeginImageContext(resizedSize)
            image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resizedImage!
        }
        return resize(image: image, width: view.frame.size.width)
    }
}
