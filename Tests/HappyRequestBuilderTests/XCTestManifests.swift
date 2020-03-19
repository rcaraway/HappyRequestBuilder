import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HappyRequestBuilderTests.allTests),
    ]
}
#endif
