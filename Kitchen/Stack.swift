//
//  Stack.swift
//  Kitchen
//
//  Created by Hikaru Watanabe on 2/15/16.
//  Copyright © 2016 Hikaru Watanabe. All rights reserved.
//

import Foundation

struct Stack<Element>{
  var items = [Element]()
  
  mutating func push(item:Element){
    items.insert(item, atIndex: 0)
  }
  
  mutating func pop() -> Element{
    return items.removeFirst()
  }

  func empty() -> Bool{
    return (items.count == 0)
  }
  
  mutating func reset(){
    items.removeAll()
  }
}