import XCTest
@testable import AlterTests

XCTMain([
    testCase(AlterTests.allTests),
    testCase(DecodableTests.allTests),
    testCase(DecodeWithRootKeyPathTests.allTests),
    testCase(NestedObjectParsingTests.allTests)
])
