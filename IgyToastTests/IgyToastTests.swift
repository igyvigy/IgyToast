
import XCTest
import IgyToast

class IgyToastTests: XCTestCase {

    override func setUp() {}

    override func tearDown() { }

    func test() {
      
      let bundle = Bundle(for: ToastVC.self)
      let nib = UINib(nibName: "ToastVC", bundle: bundle)
      dump(nib)
      assert(bundle != nil)
      assert(nib != nil)
      
      
    }

    func testPerformanceExample() {
      
        self.measure {
          
        }
    }

}
