//
//  SearchBar.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

// Source:
// https://medium.com/@axelhodler/creating-a-search-bar-for-swiftui-e216fe8c8c7f
//

final class SearchCoordinator: NSObject, UISearchBarDelegate {
    @Binding var text: String
    
    init(text: Binding<String>) {
        _text = text
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        text = searchText
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    func makeCoordinator() -> SearchCoordinator {
        SearchCoordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
