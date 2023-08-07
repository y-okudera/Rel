//
//  SettingView.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import RealmSwift
import SwiftUI

struct SettingView: View {
    @Binding var titleName: String
    @Binding var authorName: String
    @Binding var genre: String
    @Binding var publishedYearFrom: Int
    @Binding var publishedYearTo: Int
    @Binding var lastUpdatedDateFrom: Date
    @Binding var lastUpdatedDateTo: Date
    @Binding var isOpenedOnly: Bool
    @Binding var filteredTitles: [Title]
    @ObservedResults(Title.self, configuration: Realm.encrypted.configuration) var allTitles
    private var titleRepository: TitleRepository
    private var findTitles: () -> Void

    init(
        titleName: Binding<String>,
        authorName: Binding<String>,
        genre: Binding<String>,
        publishedYearFrom: Binding<Int>,
        publishedYearTo: Binding<Int>,
        lastUpdatedDateFrom: Binding<Date>,
        lastUpdatedDateTo: Binding<Date>,
        isOpenedOnly: Binding<Bool>,
        filteredTitles: Binding<[Title]>,
        titleRepository: TitleRepository,
        findTitles: @escaping () -> Void
    ) {
        self._titleName = titleName
        self._authorName = authorName
        self._genre = genre
        self._publishedYearFrom = publishedYearFrom
        self._publishedYearTo = publishedYearTo
        self._lastUpdatedDateFrom = lastUpdatedDateFrom
        self._lastUpdatedDateTo = lastUpdatedDateTo
        self._isOpenedOnly = isOpenedOnly
        self._filteredTitles = filteredTitles
        self.titleRepository = titleRepository
        self.findTitles = findTitles
    }

    // 現在の年を取得
    private var currentYear: Int {
        return Calendar.current.component(.year, from: Date())
    }

    var availableYears: [Int] {
        Array(1980...currentYear)
    }

    var body: some View {
        Form {
            Section(header: Text("検索条件")) {
                Group {
                    TextField("作品名", text: $titleName)
                    TextField("著者名", text: $authorName)
                    TextField("ジャンル", text: $genre)
                }

                Group {
                    // 公開年のPicker（from）
                    Picker("公開年 From", selection: $publishedYearFrom) {
                        ForEach(availableYears, id: \.self) { year in
                            Text(String(year))
                        }
                    }

                    // 公開年のPicker（to）
                    Picker("公開年 To", selection: $publishedYearTo) {
                        ForEach(availableYears, id: \.self) { year in
                            Text(String(year))
                        }
                    }
                }

                Group {
                    // 最終更新日の入力をDatePickerで（from）
                    DatePicker("最終更新日 From", selection: $lastUpdatedDateFrom, displayedComponents: .date)
                        .onChange(of: lastUpdatedDateFrom, perform: { newValue in
                            lastUpdatedDateFrom = Calendar.current.startOfDay(for: newValue)
                        })

                    // 最終更新日の入力をDatePickerで（to）
                    DatePicker("最終更新日 To", selection: $lastUpdatedDateTo, displayedComponents: .date)
                        .onChange(of: lastUpdatedDateTo, perform: { newValue in
                            lastUpdatedDateTo = Calendar.current.startOfDay(for: newValue)
                        })
                }

                Toggle("公開中のみ", isOn: $isOpenedOnly)

                Group {
                    Button("DBを空にする") {
                        titleRepository.deleteAllTitles()
                        findTitles()
                    }

                    Button("StubをDBに保存する") {
                        let titles = JSONFileDecoder.decode(to: [Title].self, jsonFileName: "titles.json", bundle: .main) ?? []
                        titleRepository.updateList(titles: titles)
                        findTitles()
                    }
                }

                Group {
                    Text("\(filteredTitles.count)件の検索結果")

                    Text("全\(allTitles.count)件のデータ")
                }
            }
        }
    }
}
