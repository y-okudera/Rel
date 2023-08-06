//
//  Rel_devTests.swift
//  Rel-devTests
//
//  Created by Yuki Okudera on 2023/08/05.
//

import XCTest
@testable import Rel_dev

final class Rel_devTests: XCTestCase {

    var realmAccess: RealmAccess!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        realmAccess = RealmAccess(realm: .inMemory)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        realmAccess = nil
    }

    func testRealmHelpers() throws {
        let t1 = Title(id: 0, name: "name", author: "author", genre: "genre", publishedYear: 2000, volumes: 30, isOpened: false, createdAt: Date(), updatedAt: nil)
        realmAccess.create(object: t1) { error in
            XCTFail(error.localizedDescription)
        }

        let t2 = Title(id: 1, name: "name", author: "author", genre: "genre", publishedYear: 2000, volumes: 30, isOpened: false, createdAt: Date(), updatedAt: nil)
        realmAccess.create(object: t2) { error in
            XCTFail(error.localizedDescription)
        }

        let fetchResult = realmAccess.find(objectType: Title.self)
        XCTAssertEqual(fetchResult.count, 2)

        realmAccess.delete(objectType: Title.self, primaryKey: t1.id)
        let refetchResult = realmAccess.find(objectType: Title.self)
        XCTAssertEqual(refetchResult.count, 1)
    }

    func testRealmWriteAsync() {
        let count = 10_000
        let exp = XCTestExpectation(description: "")
        exp.expectedFulfillmentCount = count

        // Unmanaged objects
        let data = Array(0..<count).map { Title(id: $0, name: "name", author: "author", genre: "genre", publishedYear: 2000, volumes: 30, isOpened: false, createdAt: Date(), updatedAt: nil) }

        // Unmanaged objects -> Managed objects
        realmAccess.update(objects: data) { error in
            XCTFail(error.localizedDescription)
        }

        for i in 0..<count {
            DispatchQueue.main.async {
                print("[他の非同期処理]", i , Thread.main)
            }
        }

        for title in data {
            // Asynchronous execution of updates to Managed objects in other threads.
            realmAccess.writeAsync(title) { realm, threadConfined in
                guard let object = threadConfined else {
                    return
                }
                object.isOpened = true
                if let result = realm.object(ofType: Title.self, forPrimaryKey: object.id) {
                    print("[非同期更新後] id: \(result.id), isOpened: \(result.isOpened)", Thread.current)
                }
                exp.fulfill()
            } errorHandler: { error in
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [exp], timeout: 60.0)
    }

}
