
import Foundation

extension Array {
  public subscript(safe index: Int) -> Element? {
    get {
      return index < count && index >= 0 ? self[index] : nil
    } set {
      if let element = newValue, index < count {
        setElement(element, at: index)
      }
    }
  }
  
  public mutating func setElement(_ element: Element, at index: Int) {
    self[index] = element
  }
  
  ///
  /// Inserts element at position or in the end if array not big enough.
  ///
  public mutating func insertIfPossible(_ newElement: Element, at position: Int) {
    position < self.count ? self.insert(newElement, at: position) : self.append(newElement)
  }
}

// MARK: - Hashable
extension Array where Element: Hashable {
  public var uniqueObjects: [Element] {
    return Array(Set(self))
  }
  public var withoutDuplicates: [Element] {
    return Array(Set(self))
  }
}

extension Array where Element == String {
  public func reduce(separator: String) -> String {
    let reduced = self.reduce("") { (result, element) -> String in
      return result == "" ? element : result + separator + element
    }
    return reduced
  }
}

// MARK: - Equatable

public enum ArrayChangeExistenceAction { case insert, remove, change }

extension Array where Element: Equatable {
  public typealias ArrayChangeExistenceCompletion = (_ action: ArrayChangeExistenceAction, _ element: Element, _ index: Int) -> Void
  
  public mutating func moveElementToTheEnd(_ element: Element, completion: ArrayChangeExistenceCompletion? = nil) {
    self.remove(element)
    completion?(.remove, element, index(of: element)!)
    self.append(element)
    completion?(.insert, element, count - 1)
  }
  
  public mutating func changeExistence(_ element: Element, index: Int? = nil, completion: ArrayChangeExistenceCompletion? = nil) {
    if contains(element) {
      let index = self.index(of: element)!
      remove(at: index)
      completion?(.remove, element, index)
    } else {
      index == nil ? append(element) : insert(element, at: index!)
      completion?(.insert, element, index ?? count - 1)
    }
  }
  
  public mutating func changeExistence(_ elements: [Element], completion: ArrayChangeExistenceCompletion? = nil) {
    elements.forEach { element in
      if contains(element) {
        let idx = index(of: element)!
        remove(at: idx)
        completion?(.remove, element, idx)
      } else {
        append(element)
        completion?(.insert, element, count - 1)
      }
    }
  }
  
  public mutating func remove(_ element: Element, completion: ArrayChangeExistenceCompletion? = nil) {
    guard let index = index(of: element) else { return }
    remove(at: index)
    completion?(.remove, element, index)
  }
  
  public mutating func remove(_ elements: [Element]) {
    elements.forEach { self.remove($0) }
  }
  
  public mutating func change(_ element: Element, completion: ArrayChangeExistenceCompletion? = nil) {
    var new = self
    let idx = index(of: element)!
    self.forEach {
      new.append( $0 == element ? element : $0 )
    }
    self = new
    completion?(.change, element, idx)
  }
  
  public mutating func change(_ elements: [Element], completion: ArrayChangeExistenceCompletion? = nil) {
    elements.forEach { element in
      change(element, completion: completion)
    }
  }
  
  ///
  /// Returns Array which consist of elements which are meets 2 or more times.
  ///
  public var duplicatedElements: [Element] {
    var arr = [Element]()
    
    for (index, element) in self.enumerated() {
      if arr.contains(element) { continue }
      for (innerIndex, innerElement) in self.enumerated() {
        if innerIndex == index { continue }
        if arr.contains(element) { break }
        
        if element == innerElement {
          arr.append(element)
        }
      }
    }
    
    return arr
  }
}
