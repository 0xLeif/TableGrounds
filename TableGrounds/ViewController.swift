//
//  ViewController.swift
//  TableGrounds
//
//  Created by Zach Eriksen on 4/15/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

let json = """
[
{
"title": "Demo Post",
"description": "Gumbo beet greens corn soko endive gumbo gourd. Parsley shallot courgette tatsoi pea sprouts fava bean collard greens dandelion okra wakame tomato. Dandelion cucumber earthnut pea peanut soko zucchini.",
"author": "Leif",
"tags": ["Demo", "Example", "EX"]
},
{
"title": "What is UX Design?",
"description": "Nori grape silver beet broccoli kombu beet greens fava bean potato quandong celery. Bunya nuts black-eyed pea prairie turnip leek lentil turnip greens parsnip. Sea lettuce lettuce water chestnut eggplant winter purslane fennel azuki bean earthnut pea sierra leone bologi leek soko chicory celtuce parsley jícama salsify.",
"author": "Suzy",
"tags": ["Celery", "quandong", "swiss", "chard"]
},
{
"title": "Demo Post 3",
"description": "Nori grape silver beet broccoli kombu beet greens fava bean potato quandong celery. Bunya nuts black-eyed pea prairie turnip leek lentil turnip greens parsnip. Sea lettuce lettuce water chestnut eggplant winter purslane fennel azuki bean earthnut pea sierra leone bologi leek soko chicory celtuce parsley jícama salsify.",
"author": "Bunya",
"tags": ["Bunyaunya", "BunyaunyaBunyaunya", "BunyaunyaBunyaunyaBunyaunyaBunyaunyaBunyaunyaBunyaunya"]
},
{
"title": "Demo Post 4",
"description": "Celery quandong swiss chard chicory earthnut pea potato. Salsify taro catsear garlic gram celery bitterleaf wattle seed collard greens nori. Grape wattle seed kombu beetroot horseradish carrot squash brussels sprout chard.",
"author": "Salsify",
"tags": ["wattle", "quandong", "etc"]
},
{
"title": "Demo Post 5",
"description": "Pea horseradish azuki bean lettuce avocado asparagus okra. Kohlrabi radish okra azuki bean corn fava bean mustard tigernut jícama green bean celtuce collard greens avocado quandong fennel gumbo black-eyed pea. Grape silver beet watercress potato tigernut corn groundnut. Chickweed okra pea winter purslane coriander yarrow sweet pepper radish garlic brussels sprout groundnut summer purslane earthnut pea tomato spring onion azuki bean gourd. Gumbo kakadu plum komatsuna black-eyed pea green bean zucchini gourd winter purslane silver beet rock melon radish asparagus spinach.",
"author": "Chickweed",
"tags": ["Dekomatsunamo", "komatsuna", "EXkomatsuna"]
},
{
"title": "Demo Post 6",
"description": "Beetroot water spinach okra water chestnut ricebean pea catsear courgette summer purslane. Water spinach arugula pea tatsoi aubergine spring onion bush tomato kale radicchio turnip chicory salsify pea sprouts fava bean. Dandelion zucchini burdock yarrow chickpea dandelion sorrel courgette turnip greens tigernut soybean radish artichoke wattle seed endive groundnut broccoli arugula.",
"author": "Water",
"tags": ["Water", "Water", "Water"]
},
{
"title": "Demo Post 7",
"description": "Soko radicchio bunya nuts gram dulse silver beet parsnip napa cabbage lotus root sea lettuce brussels sprout cabbage. Catsear cauliflower garbanzo yarrow salsify chicory garlic bell pepper napa cabbage lettuce tomato kale arugula melon sierra leone bologi rutabaga tigernut. Sea lettuce gumbo grape kale kombu cauliflower salsify kohlrabi okra sea lettuce broccoli celery lotus root carrot winter purslane turnip greens garlic. Jícama garlic courgette coriander radicchio plantain scallion cauliflower fava bean desert raisin spring onion chicory bunya nuts. Sea lettuce water spinach gram fava bean leek dandelion silver beet eggplant bush tomato.",
"author": "Catsear",
"tags": ["sea", "spinach"]
}
]
"""

struct SomeVM {
    var text = "Leif"
}

class SomeVC: UIViewController {
    var viewModel = SomeVM()
    
    lazy var label = Label(self.viewModel.text)
    lazy var field = Field(value: self.viewModel.text, placeholder: "", keyboardType: .default).inputHandler { [weak self] (value) in
        self?.viewModel.text = value
    }
    
    deinit {
        print("SomeVD DEINIT")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Hello World"
        
        view
            .background(color: .white)
            .embed {
                VStack(distribution: .fillEqually) {
                    [
                    label,
                    field,
                    Button("Update") { [weak self] in
                        self?.label.text = self?.viewModel.text ?? ""
                        },
                    Spacer()
                    ]
                }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        label.text?.append(contentsOf: "+")
    }
}

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = json.data(using: .utf8),
            let demoPosts = try? JSONDecoder().decode([Post].self, from: data) else {
                return
                
        }
        
        Navigate.shared.configure(controller: navigationController)
            .set(title: "TableGrounds")
            .setRight(barButton: UIBarButtonItem {
                Button("Leak?") {
                    Navigate.shared.go(SomeVC(), style: .push)
                }
            })
        
        view.embed {
            Button("Go") {
                Navigate.shared.go(from: self, to: UIViewController {
                    let table = TableView()
                    
                    table.register(cells: [PostCell.self])
                        .canEditRowAtIndexPath { _ in true }
                        .shouldHighlightRowAtIndexPath { _ in true }
                        .didSelectRowAtIndexPath { print($0) }
                        .leadingSwipeActionsConfigurationForRowAtIndexPath { (path) -> UISwipeActionsConfiguration in
                            UISwipeActionsConfiguration(actions: [
                                UIContextualAction(style: .normal, title: "Some Action", handler: { (action, view, comp) in
                                    
                                    view.backgroundColor = .cyan
                                    table.update { (data) -> [[CellDisplayable]] in
                                        var newData = data
                                        var post = newData[path.section][path.row] as? Post
                                        post?.title = "New Title from Swipe!"
                                        newData[path.section][path.row] = post!
                                        return newData
                                    }.reloadData()
                                    
                                    comp(true)
                                }).configure {
                                    $0.backgroundColor = .blue
                                    
                                }
                            ])
                    }
                    .canMoveRowAtIndexPath { _ in true }
                    .moveRowAtSourceIndexPathToDestinationIndexPath { (from, to) in
                        table.update { (data) -> [[CellDisplayable]] in
                            var newData = data
                            let toData = newData[to.section][to.row]
                            newData[to.section][to.row] = newData[from.section][from.row]
                            newData[from.section][from.row] = toData
                            return newData
                        }.reloadData()
                    }
                    
                    // Test Move
//                    table.isEditing = true
                    
                    table.append {
                        [
                            demoPosts
                        ]
                    }
                    .reloadData()
                    
                    
                    return UIView {
                        table
                    }
                }, style: .push)
            }
        }
    }
}

struct Post {
    var title: String
    let description: String
    let author: String
    let tags: [String]
}

extension Post: Codable { }
extension Post: CellDisplayable {
    var cellID: String {
        PostCell.ID
    }
}

class PostCell: UITableViewCell {
    let titleLabel = Label.title1("")
    let descriptionLabel = Label.caption1("")
    let authorLabel = Label.headline("")
}

extension PostCell: TableViewCell {
    func update(forData data: CellDisplayable) {
        guard let data = data as? Post else {
            return
        }
        
        titleLabel.text = data.title
        authorLabel.text = data.author
        descriptionLabel.text = data.description
    }
    
    func configure(forData data: CellDisplayable) {
        let olURL = URL(string: "https://dev.oneleif.com/static/media/homeLogo.d382f3f4.png")
        
        contentView
            .clear()
            .embed(withPadding: 16) {
                VStack(withSpacing: 4) {
                    [
//                        LoadingImage(olURL)
//                            .frame(height: 164)
//                            .contentMode(.scaleAspectFit)
//                            .padding(32),
                        titleLabel,
                        authorLabel,
                        descriptionLabel
                            .number(ofLines: 5)
                    ]
                }
                .padding(16)
                .background(color: .clear)
                .layer(borderWidth: 1)
                .layer(borderColor: UIColor.gray.withAlphaComponent(0.1).cgColor)
                .layer(cornerRadius: 8)
                .layer(shadowColor: UIColor.gray.cgColor)
                .layer(shadowOpacity: 0.75)
                .layer(shadowRadius: 3)
                .layer(shadowOffset: CGSize(width: 5, height: 5))
                
        }
    }
    
    static var ID: String {
        "Post"
    }
}
