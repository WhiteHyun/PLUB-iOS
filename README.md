# PLUB

<!-- ![image](https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/920bda8d-9f51-4e18-943f-263b6d9339ab) -->

<div align="center">

<img src="https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/444bf417-584d-42c4-a3c1-966b27e452a6" width="20%"/>

취미 생활, 소모임을 구하고 싶다면?

🎳🎠 **Play our Club!** Plubbing 하세요! 🥽⚽

</div>

## 🍎 Our Team

|               🧑‍💻 홍승현               |              🧑‍💻 이건준               |              👩‍💻 김수빈               |
| :-----------------------------------: | :----------------------------------: | :----------------------------------: |
| ![](https://github.com/WhiteHyun.png) | ![](https://github.com/dlrjswns.png) | ![](https://github.com/soobin-k.png) |

<br/>

## ⚙️ 개발환경 및 라이브러리

[![swift](https://img.shields.io/badge/swift-5.7-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-14.0-blue)]()
[![rxswift](https://img.shields.io/badge/RxSwift-6.5.0-green)]()
[![firebase](https://img.shields.io/badge/Firebase-10.0.0-red)]()
[![snapkit](https://img.shields.io/badge/SnapKit-5.6.0-yellow)]()

<br/>

## 🌟 프로젝트 주요 기능

### 🔑 로그인

> Kakao, Google, Apple 계정으로 회원가입, 로그인을 할 수 있어요!

|                                                                           온보딩 화면                                                                            |                                                                           로그인 화면                                                                            |                                                 로그인 시도 화면                                                  |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------: |
| ![Simulator Screenshot - iPhone 15 Pro Max - 2023-11-11 at 17 03 35](https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/23ddd595-a98a-4b87-88b5-057b6132107e) | ![Simulator Screenshot - iPhone 15 Pro Max - 2023-11-11 at 17 03 42](https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/da3f5963-6720-4c36-9baf-20dced38ea58) | ![IMG_96BB5A76E93A-1](https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/9e9209bd-3bea-48e3-be48-b7b642df181d) |

</br>

### 🚪 모임 활동

> 관심사에 맞게 모임에 들어가거나 만들어보세요.
> 그리고 모임에서 여러 사람들과 소통하세요!

|                                             홈 화면                                             |                                         모임 생성 화면                                          |                                                   댓글 작성 화면                                                    |
| :---------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: |
| ![](https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/ad7072e1-dba7-4a19-8b17-92a7674d2069) | ![](https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/d3e27ba3-71f0-444d-8f7c-43c463ff9e2c) | <img src="https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/5fbadc1d-0878-4387-b322-db8bd1dc508f" width="50%"/> |

<br/>

## 🛠️ 아키텍쳐

![image](https://github.com/WhiteHyun/PLUB-iOS/assets/57972338/a1d5cc11-f93f-46bc-b608-ed2e8f221221)

> **MVVM**

- MVVM을 도입하여 뷰컨트롤러와 뷰는 화면을 그리는 역할에만 집중했고, 데이터 관리, 로직의 실행은 뷰모델에서 진행되도록 했습니다.
- UIKit 요소가 없어도 뷰에 보여질 값들을 뷰모델을 단독으로 단위 테스트하여 확인하고 검증할 수 있게 했습니다.

> **UseCase**

- Service와 Router를 사용하여 네트워크 및 외부 프레임워크 요청을 처리, 레이어별 책임을 명확히 구분했습니다.
- ViewModel의 일부 기능을 UseCase로 분리하고 Adapter패턴을 적용하여 뷰의 재사용성과 유지보수성을 높였습니다.

> **Input/Output Modeling**

- 뷰모델을 Input(AnyObserver)과 Output(AnyObservable)로 구상하여 뷰의 이벤트들을 Input에 바인딩하고, 뷰에 보여질 데이터를 Output에 바인딩했습니다.
- 일관되고 직관적인 구조를 유지해 뷰모델의 코드 가독성이 높아졌습니다.

<br/>

## 🔥 기술적 도전

### RxSwift

- 연속된 escaping closure를 피하고, 선언형 프로그래밍에서 제공하는 높은 가독성과 rx 오퍼레이터의 효율적인 비동기처리를 위해 RxSwift를 사용하게 되었습니다.
- 데이터가 발생하는 시점에서부터 뷰에 그려지기까지 하나의 큰 스트림으로 데이터를 바인딩해주었습니다.

### 재사용 가능한 View & ViewController 상속

- 기능에 따라 화면 구성이 조금씩 차이가 있어 공통적인 부분은 상위 View Controller로부터 상속 받고 다른 구성 요소에 대하여 재정의할 수 있도록 하였습니다.
- 여러 화면에서 공통적으로 사용되는 UI 등은 별도의 Custom Class로 정의하여 View의 재사용성을 높이고자 하였습니다.
