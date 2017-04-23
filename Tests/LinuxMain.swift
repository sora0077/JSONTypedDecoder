import XCTest
@testable import AlterTests

XCTMain([
    testCase(JSONTypedDecoderTests.allTests),
    testCase(DecodableTests.allTests),
    testCase(DecodeWithRootKeyPathTests.allTests),
    testCase(NestedObjectParsingTests.allTests)
])
