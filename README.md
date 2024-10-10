# 🍏 ApplePark 🍏

<div align=center> 
  <br>
<img src="https://github.com/user-attachments/assets/9d38c454-5bc9-4c45-b70a-7a4151a8d5c2" width="400" height="200"/>
<br><br>
  🚀 Park 준영 Manager와 함께하는 AppleStore 제작 코딩 🚀
</div>
<br>

---
# 🔩 주요기능
- **📱 소비자용 iOS App**
  - Apple Inc.의 디바이스와 관련 악세사리 판매
  - 정보 제공 및 주문 결제

<br>

- **📢 시스템 관리자용 iPad App**
  - 소비자 데이터 관리

<br>

- **🔥 Firebase로 Back-end 구축**
  - Auth 활용한 로그인 및 회원정보 관리
  - Firestore로 데이터 구축 및 연결

<br><br>

# 🖥️ 주요 작동 화면
|For You|제품|검색|장바구니|
|---|---|---|---|
|<img src = "https://github.com/user-attachments/assets/91140b1a-9515-4ab8-aff3-65fdf4f136c4" weight="200" height="400"/>|<img src = "https://github.com/user-attachments/assets/b9e9c45b-16c3-4d74-9aad-7f9484064491" weight="200" height="400"/>|<img src="https://github.com/user-attachments/assets/80a1b259-0728-491f-accf-382df3b102fb" weight="200" height="400"/>|<img src = "https://github.com/user-attachments/assets/ffea11d4-9305-46f9-9c7c-484696c6f91f" weight="200" height="400"/>|

**For You 탭**
- 사용자가 최근에 찾아본 정보 및 디바이스 표시
- 사용자 맞춤 app store 및 apple 기기 소개

**제품 탭**
- 여러 제품의 최신 정보부터, 세부 설명까지 확인할 수 있는 탭
- 제품 상세 탭에서 원하는 디바이스를 장바구니에 담는 탭

**검색 탭**
- 사용자의 최근 검색 활동 확인
- 입력한 검색어의 연관 검색어 표시

**장바구니 탭**
- 장바구니에 담은 상품을 확인하고 구매하는 탭
- 장바구니부터, 주문, 결제까지 하는 탭
<br><br><br>

# Firebase 🔥
- Authentication
- Firestore Database
- 🖇️ https://console.firebase.google.com/project/applestore-clone-f9d07/overview?hl=ko

# Authentication 👥
**구글 로그인으로 사용자 관리**

![image](https://github.com/user-attachments/assets/50cdff00-8126-4c4f-bb8d-b774bddb8260)


# Firestore Structure 🗂️

**User / Item 컬렉션으로 데이터를 관리합니다.**

## (1) User 컬렉션
```markdown
📦 User (컬렉션)
┣ 📜 [user_email_1] (문서)
┃ ┣ 📂 profileinfo (컬렉션)
┃ ┃ ┣ 📜 nickname
┃ ┃ ┣ 📜 recentlyViewedProducts
┃ ┃ ┣ 📜 registrationDate
┃ ┣ 📂 Order (컬렉션)
┃ ┃ ┣ 📜 [order_document_1]
┃ ┃ ┃ ┣ 📜 accountNumber
┃ ┃ ┃ ┣ 📜 bankName
┃ ┃ ┃ ┣ 📜 color
┃ ┃ ┃ ┣ 📜 hasAppleCarePlus
┃ ┃ ┃ ┣ 📜 imageURL
┃ ┃ ┃ ┣ 📜 isPay
┃ ┃ ┃ ┣ 📜 itemId
┃ ┃ ┃ ┣ 📜 orderDate
┃ ┃ ┃ ┣ 📜 phoneNumber
┃ ┃ ┃ ┣ 📜 productName
┃ ┃ ┃ ┣ 📜 quantity
┃ ┃ ┃ ┣ 📜 shippingAddress
┃ ┃ ┃ ┣ 📜 trackingNumber
┃ ┃ ┃ ┣ 📜 unitPrice
┃ ┃ ┣ 📜 [order_document_2]
┃ ┃ ┃ ┣ 📜 accountNumber
┃ ┃ ┃ ┣ 📜 bankName
┃ ┃ ┃ ┣ 📜 color
┃ ┃ ┃ ┣ 📜 hasAppleCarePlus
┃ ┃ ┃ ┣ 📜 imageURL
┃ ┃ ┃ ┣ 📜 isPay
┃ ┃ ┃ ┣ 📜 itemId
┃ ┃ ┃ ┣ 📜 orderDate
┃ ┃ ┃ ┣ 📜 phoneNumber
┃ ┃ ┃ ┣ 📜 productName
┃ ┃ ┃ ┣ 📜 quantity
┃ ┃ ┃ ┣ 📜 shippingAddress
┃ ┃ ┃ ┣ 📜 trackingNumber
┃ ┃ ┃ ┣ 📜 unitPrice
```

## (2) Item 컬렉션
```markdown
📦 Item (컬렉션)
┣ 📜 [itemid_1] (문서)
┃ ┣ 📜 category
┃ ┣ 📜 color
┃ ┣ 📜 description
┃ ┣ 📜 imageURL
┃ ┣ 📜 isAvailable
┃ ┣ 📜 name
┃ ┣ 📜 price
┃ ┣ 📜 stockQuantity
┃
┣ 📜 [itemid_2] (문서)
┃ ┣ 📜 category
┃ ┣ 📜 color
┃ ┣ 📜 description
┃ ┣ 📜 imageURL
┃ ┣ 📜 isAvailable
┃ ┣ 📜 name
┃ ┣ 📜 price
┃ ┣ 📜 stockQuantity
```

# ⭐️ 네바오 강사님의 백만불짜리 피드백
**UX시나리오 개선사항**
- 장바구니 탭에 badge로 숫자 보이기
- 무통장 입금은 쇼핑몰 법인의 계좌를 알려주고 끝내야한다

**applestore-clone-admin**
- 파일들 폴더 정리는 해줍시다
- protocol ItemStoreType 같은 처리는 매우 바람직함
- CustomView의 주석화된 코드는 과감히 지웁시다. git 기록에서 다시 꺼낼 수 있어요.

**applestore-clone-consumer**
- 여기도 폴더 정리좀 합시다
- Functions.swift 파일이름은 위험. ViewBuilders 같은 거로 합시다
- ProductCategoryView 처럼 길어지는 내용은 서브뷰 처리할 수 있을까 고민해봅시다

**applestore-clone-models**
- struct, class마다 잘게 파일들을 나눠주세요

<br><br>

# ⚙️ 작동환경
- **Xcode** 16.0
- **iOS** 15.0 ~ 18.0
- 프로젝트를 실행하기 위해서는, GoogleService-info.plist 파일이 필요로 합니다.
  해당 문의는 PM에게 따로 연락주시길 바랍니다. (j77777y@naver.com)
<br><br><br>

# 🍏 팀 구성
## 👑 Parkjoonyoung Manager, 박준영 <a href="https://github.com/PlayTheApp"><button>GitHub</button> 👑

### 📱 consumer 개발팀
|⭐️신현우⭐️|강승우|구영진|배문성|홍지수|
|---|---|---|---|---|
|<a href="https://github.com/show2633"><button>GitHub</button>|<a href="https://github.com/kangsw1025"><button>GitHub</button>|<a href="https://github.com/skdmlp"><button>GitHub</button>|GitHub|<a href="https://github.com/jisooohh"><button>GitHub</button>|

<br>

### 📢 admin 개발팀
|⭐️김정원⭐️|이정민|홍재민|
|---|---|---|
|<a href="https://github.com/gadisom"><button>GitHub</button>|<a href="https://github.com/Jeolmi123"><button>GitHub</button>|<a href="https://github.com/IUCyH"><button>GitHub</button>|

<br>

### 🔥 Firebase 개발팀
|⭐️김수은⭐️|김종혁|김수민|
|---|---|---|
|<a href="https://github.com/sueunal"><button>GitHub</button>|<a href="https://github.com/bbell428"><button>GitHub</button>|<a href="https://github.com/sumchive"><button>GitHub</button>|

<br><br><br>

# 📄 라이선스
Licensed under the [MIT](LICENSE) license.
