//
//  TestTableViewController.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/25.
//

import UIKit

class TestTableViewController: UITableViewController {

    private var likeViewModel = LikeDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func asdfasdfadsf(_ sender: Any) {
        print("NOPE!")
        likeViewModel.removeAllLikeItems()
        tableView.reloadData()
    }

    @IBAction func alertPLUS(_ sender: UIButton) {
        print("TlqkfRJ")
        let alertController = UIAlertController(title: "Add List Item", message: "Add an item that you need to do.", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?[0], let text = textField.text, let textFieldSecond = alertController.textFields?[1], let textSecond = textFieldSecond.text  else {
                // execute code if textField doesn't exist
                return
            }
            
            // url -> text / name -> textSecond
            self?.likeViewModel.addLikeItems(url: text, isLiked: false, name: textSecond)
            self?.tableView.reloadData()
        }

        alertController.addTextField { textField in
            textField.placeholder = "url"
        }

        alertController.addTextField { textField in
            textField.placeholder = "name"
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likeViewModel.likeItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TestCellID", for: indexPath) as? CoreTestTableViewCell else {return UITableViewCell.init()}
        cell.urlLabel.text = likeViewModel.likeItems[indexPath.row].url
        cell.nameLabel.text = likeViewModel.likeItems[indexPath.row].nameLike
        cell.isLikedLabel.text = likeViewModel.likeItems[indexPath.row].isLiked ? "♥" : "♡"
        return cell
    }
    
    // MARK: - 삭제
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            likeViewModel.removeLikeItems(url: likeViewModel.likeItems[indexPath.row].url)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
