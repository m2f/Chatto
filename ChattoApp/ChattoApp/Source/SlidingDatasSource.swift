/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import Foundation

public enum InsertPosition {
    case top
    case bottom
}

public class SlidingDataSource<Element> {
    
    private var pageSize: Int
    private var windowOffset: Int
    private var windowCount: Int
    private var itemGenerator: ((_ index: Int) -> Element)?
    public var items = [Element]()
    private var itemsOffset: Int
    
    internal var itemsInWindow = [Element]()
    
    private var lastStartOffset = 0
    private var lastItemsCount = 0
    
    public init(count: Int, pageSize: Int, itemGenerator: ((_ index: Int) -> Element)?) {
        self.windowOffset = count
        self.itemsOffset = count
        self.windowCount = 0
        self.pageSize = pageSize
        self.itemGenerator = itemGenerator
        self.generateItems(startIndex: 0, count: min(pageSize, count), position: .top)
    }
    
    public convenience init(items: [Element], pageSize: Int) {
        self.init(count: 0, pageSize: pageSize, itemGenerator: nil)
        for item in items {
            self.insertItem(item, position: .bottom)
        }
    }
    
    private func generateItems(startIndex: Int, count: Int, position: InsertPosition) {
        guard count > 0 else { return }
        guard let itemGenerator = self.itemGenerator else {
            fatalError("Can't create messages without a generator")
        }
        let endIndex = startIndex + count
        for index in startIndex..<endIndex {
            self.insertItem(itemGenerator(index), position: .top)
        }
    }
    
    public func insertItem(_ item: Element, position: InsertPosition) {
        if position == .top {
            self.items.insert(item, at: 0)
            let shouldExpandWindow = self.itemsOffset == self.windowOffset
            self.itemsOffset -= 1
            if shouldExpandWindow {
                self.windowOffset -= 1
                self.windowCount += 1
            }
        } else {
            let shouldExpandWindow = self.itemsOffset + self.items.count == self.windowOffset + self.windowCount
            if shouldExpandWindow {
                self.windowCount += 1
            }
            self.items.append(item)
        }
    }
    
    public func getWindowItems() -> [Element] {
        
        let startOffset = self.windowOffset - self.itemsOffset
        let endOffset = startOffset + windowCount
        let currentItemsCount = items.count
        
        if currentItemsCount == lastItemsCount + 1 {
            //a new item is added so append and return
            itemsInWindow.append(items[lastItemsCount])
            lastItemsCount = currentItemsCount
            lastStartOffset = startOffset
            return itemsInWindow
            
        } else if currentItemsCount == lastItemsCount && startOffset == lastStartOffset {
            //update of existing items so return the same items
            return itemsInWindow
        }
        print("wo: \(self.windowOffset) wc: \(self.windowCount) io: \(self.itemsOffset) ic: \(self.items.count) \(startOffset) \(endOffset)")

        //since the offsets are different we copy and return all
        itemsInWindow = Array(items[startOffset..<endOffset])
        lastItemsCount = currentItemsCount
        lastStartOffset = startOffset
        return itemsInWindow
    }

    
    public func hasPrevious() -> Bool {
        return self.windowOffset > 0
    }
    
    public func hasMore() -> Bool {
        return self.windowOffset + self.windowCount < self.itemsOffset + self.items.count
    }
    
    public func loadPrevious() {
        let previousWindowOffset = self.windowOffset
        let previousWindowCount = self.windowCount
        let nextWindowOffset = max(0, self.windowOffset - self.pageSize)
        let messagesNeeded = self.itemsOffset - nextWindowOffset
        if messagesNeeded > 0 {
            self.generateItems(startIndex: items.count, count: messagesNeeded, position: .top)
        }
        let newItemsCount = previousWindowOffset - nextWindowOffset
        self.windowOffset = nextWindowOffset
        self.windowCount = previousWindowCount + newItemsCount
    }
    
    public func loadNext() {
        guard self.items.count > 0 else { return }
        let itemCountAfterWindow = self.itemsOffset + self.items.count - self.windowOffset - self.windowCount
        self.windowCount += min(self.pageSize, itemCountAfterWindow)
    }
    
    @discardableResult
    public func adjustWindow(focusPosition: Double, maxWindowSize: Int) -> Bool {
        assert(0 <= focusPosition && focusPosition <= 1, "")
        guard 0 <= focusPosition && focusPosition <= 1 else {
            assert(false, "focus should be in the [0, 1] interval")
            return false
        }
        let sizeDiff = self.windowCount - maxWindowSize
        guard sizeDiff > 0 else { return false }
        self.windowOffset +=  Int(focusPosition * Double(sizeDiff))
        self.windowCount = maxWindowSize
        return true
    }
}
