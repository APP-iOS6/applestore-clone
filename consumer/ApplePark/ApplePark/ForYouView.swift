//
//  ForYouView.swift
//  AppleStoreForYou
//
//  Created by Mac on 10/7/24.
//

import SwiftUI

struct ExploreItem: Identifiable {
    let id = UUID()
    var icon: String
    var title: String
    var description: String
    var iconColor: Color
}

struct Store: Identifiable {
    let id = UUID()
    let name: String
    let region: String
    let address: String
    let hours: String
    let distance: String
    let duration: String
    var imageName: String
}

// 더 살펴보기 항목
var exploreItems: [ExploreItem] = [
    ExploreItem(icon: "square.badge.plus", title: "주문 관련 실시간 업데이트를 받아보세요.", description: "알림을 켜고 주문 관련 최신 정보를 받아보세요.", iconColor: .red), // Color로 변경
    ExploreItem(icon: "applelogo", title: "나에게 맞춘 Apple Store.", description: "더 다양한 기능과 나에게 맞춘 서비스를 경험하려면 '기기'와 '서비스'를 활성화하세요.", iconColor: .gray), // Color로 변경
    ExploreItem(icon: "iphone", title: "사용 중인 iPhone을 최신 모델과 비교해보세요.", description: "크기, 성능, 카메라, 내구성 등을 나란히 비교해볼 수 있습니다.", iconColor: .black) // Color로 변경
]

//// Apple Store 매장 리스트
//var stores: [Store] = [
//    Store(name: "홍대", region: "서울", address: "서울 마포구 홍대거리", hours: "오전 10:00 - 오후 10:00", distance: "20km", duration: "14분", imageName: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R764.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic"),
//    Store(name: "명동", region: "서울", address: "서울 중구 명동길", hours: "오전 10:00 - 오후 10:00", distance: "19km", duration: "21분", imageName: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R764.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic"),
//    Store(name: "여의도", region: "서울", address: "서울 영등포구 여의도동", hours: "오전 10:00 - 오후 10:00", distance: "24km", duration: "17분", imageName: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R764.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic"),
//    Store(name: "강남", region: "서울", address: "서울 강남구 가로수길", hours: "오전 10:00 - 오후 10:00", distance: "32km", duration: "22분", imageName: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R764.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic"),
//    Store(name: "홍대", region: "서울", address: "서울 마포구 홍대거리", hours: "오전 10:00 - 오후 10:00", distance: "20km", duration: "14분", imageName: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R764.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic"),
//    Store(name: "명동", region: "서울", address: "서울 중구 명동길", hours: "오전 10:00 - 오후 10:00", distance: "19km", duration: "21분", imageName: "https://rtlimages.apple.com/cmc/dieter/store/16_9/R764.png?resize=672:378&output-format=jpg&output-quality=85&interpolation=progressive-bicubic"),
//]

struct ForYouView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var scrollPosition: CGPoint = .zero
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("For You")
                            .font(.system(size: 32, weight: .bold))
                        Spacer()
                        
                        Button {
                            if authManager.authenticationState == .unauthenticated  {
                                Task {
                                    await authManager.signInWithGoogle()
                                }
                            }
                        } label: {
                            VStack{
                                Image(systemName: "person.circle")
                                    .font(.system(size: 32, weight: .bold))
                                Text(authManager.authenticationState == .unauthenticated ? "Login" : "Logout")
                                    .font(.caption2)
                            }
                        }
                    }
                    .padding()
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.scrollPosition = value
                    }
                    
                    Text("최근 활동")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .padding(.top, 20)
                    
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    
                    //                    LazyVGrid(columns: columns, spacing: 20) {
                    //                        ForEach(sampleCustomers[0].recentlyViewedProducts, id: \.self) { item in
                    //
                    //                            // item id로 불러오는 로직
                    //
                    //                            NavigationLink(destination: ProductDetailView(item: item)) {
                    //                                RecentItemCard(imageName: item., title: item.title)
                    //                            }
                    //                            .buttonStyle(PlainButtonStyle())
                    //                        }
                    //                    }
                    //                    .padding(.horizontal)
                    
                    Text("더 살펴보기")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        ForEach(exploreItems) { item in
                            Button {
                                
                            } label: {
                                ExploreCard(icon: item.icon, title: item.title, description: item.description, iconColor: Color(item.iconColor))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .coordinateSpace(name: "scroll")
            .navigationTitle(scrollPosition.y < 0 ? "For You" : "")
            .background(Color(red: 243 / 255, green: 242 / 255, blue: 248 / 255))
        }
    }
}

struct RecentItemCard: View {
    var imageName: String
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "eye.circle")
                    .foregroundColor(.green)
                Text("최근 본 정보")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.white)
            
            AsyncImage(url: URL(string: imageName)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } placeholder: {
                ProgressView()
                    .frame(height: 100)
            }
            
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .default))
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .frame(height: 90, alignment: .top)
        }
        .frame(width: 174, height: 280)
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct ExploreCard: View {
    var icon: String
    var title: String
    var description: String
    var iconColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(iconColor)
                .padding()
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(.black)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 360, height: 115)
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    ForYouView()
}
