//
//  ContentView.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/04.
//

import SwiftUI

struct ContentView: View {
    @State private var titleName: String = ""
    @State private var authorName: String = ""
    @State private var genre: String = ""
    @State private var publishedYearFrom: Int = 1980
    @State private var publishedYearTo: Int = Calendar.current.component(.year, from: Date())
    @State private var lastUpdatedDateFrom: Date = {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        let lastMonth1st = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: oneMonthAgo)) ?? Date()
        return Calendar.current.startOfDay(for: lastMonth1st)
    }()
    @State private var lastUpdatedDateTo = Calendar.current.startOfDay(for: Date())
    @State private var isOpenedOnly: Bool = true
    @State private var filteredTitles: [Title] = []
    private let titleRepository: TitleRepository = .init(realmAccess: .init(realm: .encrypted))
    
    var body: some View {
        TabView {
            SettingView(
                titleName: $titleName,
                authorName: $authorName,
                genre: $genre,
                publishedYearFrom: $publishedYearFrom,
                publishedYearTo: $publishedYearTo,
                lastUpdatedDateFrom: $lastUpdatedDateFrom,
                lastUpdatedDateTo: $lastUpdatedDateTo,
                isOpenedOnly: $isOpenedOnly,
                filteredTitles: $filteredTitles,
                titleRepository: titleRepository,
                findTitles: {
                    findTitles()
                }
            )
            .tabItem {
                Label("Setting", systemImage: "gearshape")
            }
            
            TitleListView(filteredTitles: $filteredTitles)
                .tabItem {
                    Label("TitleList", systemImage: "list.dash")
                }
        }
        .onAppear {
            findTitles()
        }
        .onChange(of: titleName) { newValue in
            findTitles()
        }
        .onChange(of: authorName) { newValue in
            findTitles()
        }
        .onChange(of: genre) { newValue in
            findTitles()
        }
        .onChange(of: publishedYearFrom) { newValue in
            findTitles()
        }
        .onChange(of: publishedYearTo) { newValue in
            findTitles()
        }
        .onChange(of: lastUpdatedDateFrom) { newValue in
            findTitles()
        }
        .onChange(of: lastUpdatedDateTo) { newValue in
            findTitles()
        }
        .onChange(of: isOpenedOnly) { newValue in
            findTitles()
        }
    }
    
    private func findTitles() {
        print("findTitles")
        self.filteredTitles = self.titleRepository.find(
            filter: .init(
                name: self.titleName.isEmpty ? nil : .init(contains: self.titleName),
                author: self.authorName.isEmpty ? nil : .init(contains: self.authorName),
                genre: self.genre.isEmpty ? nil : .init(contains: self.genre),
                publishedYear: IntFilter(between: (min: self.publishedYearFrom, max: self.publishedYearTo)),
                isOpened: BoolFilter(equals: self.isOpenedOnly ? true : nil),
                updatedAt: DateFilter(between: (min: self.lastUpdatedDateFrom, max: self.lastUpdatedDateTo))
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
