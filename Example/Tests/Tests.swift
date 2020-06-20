import XCTest
@testable import CMBottomGestureView

class Tests: XCTestCase {
  
  
  
  override func setUp() {
    super.setUp()
    
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // given
    let maxHeight: CGFloat = 600.0
    let minHeight: CGFloat = 200.0
    
    let viewController = UIViewController()
    let bottom = CMBottomGestureView(presentedView: viewController.view,
                                     maxHeight: maxHeight,
                                     minHeight: minHeight,
                                     swipeDownType: .stayBottom)
    
    XCTAssertEqual(bottom.frame.height, maxHeight)
    
    let minOriginY = UIScreen.main.bounds.height - minHeight
    let maxOriginY = UIScreen.main.bounds.height - maxHeight
    XCTAssertEqual(minOriginY, bottom.originY(.close))
    XCTAssertEqual(maxOriginY, bottom.originY(.open))
    
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
