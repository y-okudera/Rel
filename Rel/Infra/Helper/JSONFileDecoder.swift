//
//  JSONFileDecoder.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import Foundation

enum JSONFileDecoder {

    /// JSONファイルをデコードする
    /// - Parameters:
    ///   - outputType: 出力先のタイプ
    ///   - jsonFileName: JSONファイル名（拡張子付き）sample.json
    ///   - bundle: JSONファイルのBundle
    /// - Returns: デコード結果
    static func decode<T: Decodable>(to outputType: T.Type, jsonFileName: String, bundle: Bundle) -> T? {
        guard let json = readJSON(jsonFileName: jsonFileName, bundle: bundle) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(T.self, from: json)
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }

    /// JSONファイルのテキストを読み込む
    /// - Parameter jsonFileName: JSONファイル名（拡張子付き）sample.json
    /// - Returns: JSONファイルのテキスト
    private static func readJSON(jsonFileName: String, bundle: Bundle) -> Data? {
        let urlPath = URL(fileURLWithPath: jsonFileName)
        let fileName = (urlPath.lastPathComponent as NSString).deletingPathExtension

        guard let jsonPath = bundle.path(forResource: fileName, ofType: urlPath.pathExtension),
              let fileHandle = FileHandle(forReadingAtPath: jsonPath) else {
            assertionFailure("File not found. pathForResource: \(fileName) ofType: \(urlPath.pathExtension)")
            return nil
        }
        return fileHandle.readDataToEndOfFile()
    }
}
