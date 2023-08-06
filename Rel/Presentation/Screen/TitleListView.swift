//
//  TitleListView.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/06.
//

import SwiftUI

struct TitleListView: View {
    @Binding var filteredTitles: [Title]

    var body: some View {
        List {
            Section(header: Text("Filtered Titles")) {
                ForEach(filteredTitles, id: \.self) { title in
                    VStack {
                        Text(title.name)
                            .font(.headline)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("著者: \(title.author)")
                            .font(.caption)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("ジャンル: \(title.genre)")
                            .font(.caption)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("巻数: \(title.volumes)")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}
