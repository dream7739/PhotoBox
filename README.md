# PhotoBox
마음에 드는 사진을 색상별로 간직하는 앱

|트랜드 사진|사진 추천|사진 검색|사진 상세|즐겨찾기|
|--------|-----|------------|-----|--------|
|<img width = "200" src = "https://github.com/user-attachments/assets/be68760a-25d4-48ba-a7dc-77e9cd76660b">|<img width = "200" src = "https://github.com/user-attachments/assets/72ed4f2a-9418-40c4-a9ce-d3c03e080a81">|<img width = "200" src = "https://github.com/user-attachments/assets/6138b95e-0c8c-4982-9a56-ef94fc5044cd">|<img width = "200" src = "https://github.com/user-attachments/assets/4df4c445-d7fa-4b56-af38-68292d11a466">|<img width = "200" src = "https://github.com/user-attachments/assets/39e05f69-f6d0-466a-9e43-7fd99e41fe20">|

## 프로젝트 환경
- 인원: 1명
- 기간: 2024.07.22 - 2024.07.29
- 버전: iOS 15+ 

## 기술 스택
- iOS: UIKit, Custom Observable
- Architecture: MVVM, Delegate, Observer
- DB & Network : Realm, Alamofire
- ETC: NetworkMonitor, UIWindow 
  
## 핵심 기능
- 트랜드 사진: 토픽별 트랜드 사진 확인
- 사진 추천: 랜덤 사진 추천
- 사진 검색: 사진 검색 및 컬러별 필터링
- 사진 상세: 사진 상세정보 확인 및 조회•다운로드 그래프 
- 즐겨찾기: 좋아요한 사진 모아보기
  
## 주요 기술
- Closure와 didSet을 활용한 Custom Observable 구성 및 비동기 처리
- DispatchGroup의 enter-leave 방식을 통한 비동기 작업 그룹화 및 화면 동기화 처리
- NetworkMonitor를 통한 네트워크 단절 시점 파악 및 UIWindow와 Delegate를 사용한 네트워크 재요청 처리
- Realm의 NSPredicate를 통해 다중 필터 조건을 사용한 데이터 조회 
- NotificationCenter을 통한 데이터 변경사항 관찰 및 실시간 UI 동기화
- CompositionalLayout과 DiffableDataSource을 사용한 다중 섹션 컬렉션뷰 구성
- BaseViewController를 사용한 공통 로직 관리 및 상속을 통해 중복코드 방지
- Content Compression Resistance Priority를 사용한 동적 레이아웃 구성
- final 키워드와 private 접근제어자를 통한 컴파일 최적화
  
## 트러블 슈팅
### 1. 네트워크 단절 시점 파악과 요청 재시도
  > 비행기모드나 오프라인 상태일 경우 네트워크이 불가능한 상황에 대한 대응
- NetworkMonitor를 사용한 네트워크 단절 시점 파악
- UIWindow를 사용하여 여러 화면에서 공통으로 사용할 수 있는 NetworkWindow 생성
- 최상단 화면을 찾고 delegate를 사용해 해당 화면에서 요청을 재시도
> NetworkMonitor
```swift
final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    var isConnected = false
    
    private init(){ }
    
    func startMonitoring(){
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isConnected = true
            } else{
                self?.isConnected = false
                self?.presentNetworkWindow()
            }
        }
    }
    
    func presentNetworkWindow(){
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let networkWindow = NetworkWindow(windowScene: windowScene)
                networkWindow.makeKeyAndVisible()
                
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.networkWindow = networkWindow
            }
        }
    }
    
    func dismissNetworkWindow(){
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.networkWindow = nil
            }
        }
    }
}
```

### 2. 지그재그 형태의 CollectionView 커스텀 시 셀의 컨텐츠가 사라지는 오류
> layoutAttributesForItemAt 함수를 override 하여 frame.y값을 변경하면서 collectionView의 bounds를 넘어가는 현상
- layoutAttributesForElements를 오버라이딩하여 bounds 변경 될 때 레이아웃을 무효화 

> ZigzagFlowLayout
```swift
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.indexPath.item % 2 != 0 {
                    layoutAttribute.frame.origin.y += 20
                }
            }
        }
        return attributes
    }

```
  
## 회고
- RealmProtocol 프로토콜 구성에 대한 아쉬움. Generic 타입이 아닌 구체 타입을 사용해서 범용성이 떨어진다고 생각됨
- Realm의 오류 처리가 print로만 되어있는 부분에 대한 아쉬움. do-catch를 통해 변경할 수 있을 것이라고 생각됨 