//
//  SearchView.swift
//  ApplePark
//
//  Created by 강승우 on 10/8/24.
//

import SwiftUI

enum field {
    case search
}

struct SearchView: View {
    
    @State private var isTruncated: Bool? = nil
    @State private var isExpended: Bool = false
    @State private var scrollPosition: CGPoint = .zero
    @State var searchText: String = ""
    @State var isSearching: Bool = false
    @State var recentWatchView: [String] = []
    @FocusState var focusField: field?
    
    // 더미데이터----------------------------------
    @State var recentSearchList: [String] = [
        "iPhone 16 Pro", "iPhone 16", "Apple Watch", "AirPods", "iPad Pro", "iPad Air", "iPhone 모델 비교하기", "Apple Trade In", "케이스 & 보호장비", "AirTag", "Apple One"
    ]
    let recommandSearchList: [String] = [
        "iPhone 16 Pro", "iPhone 16", "Apple Watch", "AirPods", "iPad Pro", "iPad Air", "iPhone 모델 비교하기", "Apple Trade In", "케이스 & 보호장비", "AirTag", "Apple One"
    ]
    
    let productList: [String] = [
        "Apple Watch", "Apple Watch Studio", "Apple Watch Series 10", "Apple Watch Ultra 2", "Apple Watch SE", "Apple Watch Hermes", "Apple Watch Hermes Ultra 2", "AppleCare+", "Apple Arcade",
    ]
    //------------------------------------------
    
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                ScrollView {
                    if !isSearching {
                        HStack {
                            Text("검색")
                                .font(.system(size: 34, weight: .bold))
                            Spacer()
                        }
                        .padding()
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.searchViewBG)
                                .frame(width: isSearching ? proxy.size.width * 0.78 : proxy.size.width * 0.92)
                                .frame(height: proxy.size.height * 0.05)
                            HStack {
                                Image(systemName:"magnifyingglass")
                                    .foregroundStyle(.gray)
                                TextField("제품 및 매장 검색", text: $searchText)
                                    .focused($focusField, equals: .search)
                                    .frame(width: isSearching ? proxy.size.width * 0.56 : proxy.size.width * 0.72)
                                    .autocorrectionDisabled()
                                    .onChange(of: searchText) { value in
                                        if !value.isEmpty {
                                            isSearching = true
                                        }
                                    }
                                
                                
                                if searchText.isEmpty {
                                    Image(systemName: "microphone.fill")
                                        .foregroundStyle(.gray)
                                } else {
                                    clearTextButton()
                                        .foregroundStyle(.gray)
                                }
                            }
                            .frame(width: isSearching ? proxy.size.width * 0.78 : proxy.size.width * 0.92)
                            .frame(height: proxy.size.height * 0.05)
                            
                            
                            if !isSearching {
                                Rectangle()
                                    .foregroundStyle(.black.opacity(0.0001))
                                    .frame(width: isSearching ? proxy.size.width * 0.76 : proxy.size.width * 0.92)
                                    .frame(height: proxy.size.height * 0.05)
                                    .onTapGesture {
                                        isSearching = true
                                        self.focusField = .search
                                    }
                            }
                        }
                        .animation(.easeInOut, value: isSearching)
                        //                        .transition(.move(edge: .top))
                        
                        if isSearching {
                            Button {
                                print("click cancle")
                                searchText = ""
                                isSearching = false
                            } label : {
                                Text("취소")
                                    .padding(10)
                            }
                        }
                    }
                    .frame(width: proxy.size.width)
                    
                    if isSearching {
                        Divider()
                    }
                    
                    if !isSearching {
                        if !recentWatchView.isEmpty {
                            ZStack {
                                publicHeader("최근 본 정보")
                                HStack {
                                    Spacer()
                                    Button {
                                        recentWatchView.removeAll()
                                    } label : {
                                        Text("지우기")
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        Section(header : publicHeader("검색 시도")) {
                            ForEach(recommandSearchList, id:\.self) { search in
                                recommandSearchButton(search)
                            }
                        }
                    }
                    
                    else { // 검색중일때
                        if searchText.isEmpty {
                            Button {
                                print("근처 매장 찾기")
                            } label : {
                                HStack {
                                    Image(systemName: "location.circle.fill")
                                    Text("근처 매장 찾기")
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .font(.system(size: 22))
                                .foregroundStyle(.gray)
                                .frame(width: proxy.size.width)
                            }
                            
                            Divider()
                            
                            if !recentSearchList.isEmpty {
                                HStack {
                                    Text("최근 검색")
                                        .font(.system(size: 24, weight: .bold))
                                    Spacer()
                                    Button {
                                        self.recentSearchList.removeAll()
                                    } label : {
                                        Text("지우기")
                                    }
                                }
                                .padding()
                                
                                Divider()
                                
                                ForEach(recentSearchList, id:\.self) { search in
                                    Button {
                                        searchText = search
                                    } label : {
                                        VStack {
                                            HStack {
                                                Image(systemName: "magnifyingglass")
                                                Text(search)
                                                Spacer()
                                            }
                                            .font(.system(size: 22))
                                            .foregroundStyle(.gray)
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            
                                            Divider()
                                        }
                                    }
                                }
                            }
                            
                        } else {
                            ForEach(searchResult(self.searchText), id:\.self) { search in
                                Button {
                                    searchText = search
                                } label : {
                                    VStack {
                                        HStack{
                                            Image(systemName: "magnifyingglass")
                                            HStack(spacing:0) {
                                                Text(search.prefix(self.searchText.count))
                                                    .bold()
                                                    .foregroundStyle(.black)
                                                Text(search.suffix(search.count - self.searchText.count))
                                                    .foregroundStyle(.gray)
                                            }
                                            Spacer()
                                        }
                                        .font(.system(size: 24))
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        
                                        Divider()
                                    }
                                }
                                
                            }
                        }
                    }
                }
                //                .navigationTitle(isSearching ? "" : "검색")
                .toolbarTitleDisplayMode(.automatic)
            }
        }
    }
}
// 8 62 72
extension SearchView {
    
    private func searchResult(_ search: String) -> [String] {
        var len = search.count
        let result: [String] = productList.filter { product in
            return product.lowercased().prefix(len) == search.lowercased()
        }
        
        return result;
    }
    
    @ViewBuilder
    private func publicHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .bold))
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    private func recommandSearchButton(_ text: String) -> some View {
        Button {
            self.searchText = text
        } label: {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                Text(text)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .font(.system(size: 20))
            
        }
    }
    
    @ViewBuilder
    private func clearTextButton() -> some View {
        Button {
            self.searchText = ""
        } label : {
            Image(systemName: "x.circle.fill")
        }
    }
}

#Preview {
    SearchView()
}
