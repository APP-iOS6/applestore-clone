# Firebase 🔥
- Authentication
- Firestore Database
- 🖇️ https://console.firebase.google.com/project/applestore-clone-f9d07/overview?hl=ko

# 개발자 💻
| 👑     | 🧑🏻‍💻     | 👩🏻‍💻     |
|----------|----------|----------|
| 김수은   | 김종혁   | 김수민   |

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
