//
//  BinaryTree.swift
//  twentyquestions
//
//  Created by Steven Curtis on 08/03/2017.
//  Copyright © 2017 Steven Curtis. All rights reserved.
//

import Foundation



class QTree {
    var question: String!
    var yes: QTree? = nil
    var no: QTree? = nil
    weak var parent: QTree? = nil
    
    init(value: String) {
        self.question = value
    }
    
    convenience init(question: String, yesData: QTree, noData: QTree) {
        self.init(value: question)
        self.question = question
        self.yes = yesData
        self.no = noData
        self.yes?.parent = self
        self.no?.parent = self
    }
    
    convenience init(question: String, yesData: String, noData: String) {
        self.init(value: question)
        self.question = question
        self.yes = QTree(value: yesData)
        self.no = QTree(value: noData)
        self.yes?.parent = self
        self.no?.parent = self
    }
    
    public func insertYesData(newData: String) {
        if let yes = yes {yes.insertYesData(newData: newData)}
        else {
            yes = QTree(value: newData)
            yes?.parent = self
        }
    }
    public func insertNoData(newData: String) {
        if let no = no {no.insertYesData(newData: newData)}
        else{
            no = QTree(value: newData)
            no?.parent = self
        }
    }
    public func head() -> String {
        return question
    }
    
    public func append(newTree: QTree, direction: String) {
        if (direction == "Y")
        {
            self.yes = newTree
            self.yes?.parent = self
        }
        else{
            self.no = newTree
            self.no?.parent = self
        }
    }
    
    public func isQuestion() -> Bool {
        if self.no==nil && self.yes==nil
        {
            return false
        }
        return true
    }
}


func recursiveLevelOrder(root: QTree?) -> [[String]] {
    if root == nil {
        return []
    }
    return recursiveLevelOrder(queue: [root!], resultSoFar: [])
}

func recursiveLevelOrder(queue: [QTree], resultSoFar: [[String]]) -> [[String]] {
    var result: [String] = []
    var queueNext: [QTree] = []
    for node in queue {
        result.append(node.question)
        if node.yes != nil {
            queueNext.append(node.yes!)
        }
        if node.no != nil {
            queueNext.append(node.no!)
        }
    }
    if queueNext.count == 0 {
        return resultSoFar + [result]
    } else {
        return recursiveLevelOrder(queue: queueNext, resultSoFar: resultSoFar + [result])
    }
}
