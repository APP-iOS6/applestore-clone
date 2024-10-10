//
//  PersonalizedAppleStoreView.swift
//  AppleStoreForYou
//
//  Created by Mac on 10/8/24.
//

import SwiftUI
import MapKit

struct PersonalizedAppleStoreView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
//            VStack {
//                SearchBar(text: $searchText)
//                
//                Picker("View", selection: $selectedTab) {
//                    Text("목록").tag(0)
//                    Text("지도").tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//                
//                // 선택된 탭에 따라 다른 뷰를 표시
//                if selectedTab == 0 {
//                    VStack(alignment: .leading) {
//                        Text("근처 매장")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                            .padding(.leading, 40)
//                        
//                        List(stores.filter {
//                            searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased())
//                        }) { store in
//                            StoreRow(store: store)
//                        }
//                    }
//                } else {
//                    MapView(stores: stores)
//                }
//            }
//            .navigationTitle("매장 찾기")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("도시, 우편번호, 이름으로 검색", text: $text)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct StoreRow: View {
    let store: Store
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: store.imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(store.name)
                    .font(.subheadline)
                Text(store.region)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(store.hours)
                    .font(.caption)
                HStack {
                    Text(store.distance)
                    Text("|")
                    Text(store.duration)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct MapView: UIViewRepresentable {
    let stores: [Store]
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        var annotations = [MKPointAnnotation]()
        
        for store in stores {
            let annotation = MKPointAnnotation()
            annotation.title = store.name
            annotation.subtitle = store.address
            annotation.coordinate = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
            annotations.append(annotation)
        }
        
        uiView.showAnnotations(annotations, animated: true)
    }
}
#Preview {
    PersonalizedAppleStoreView()
}
