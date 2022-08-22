# ToDoApp

`할 일을 기록`하고, 기록 후 `완료 체크`표시와 `삭제`가 가능한 ios 어플리케이션.

<div>
    <span>
        <img src="https://user-images.githubusercontent.com/75922558/185871050-2f2b11cf-6195-4609-b24e-5eb0523e6cc1.png" width="180"/>
    </span>
    <span>
        <img src="https://user-images.githubusercontent.com/75922558/185870914-28f96488-f003-4b03-9358-0fe7f4781112.png" width="180"/>
    </span>
    <span>
        <img src="https://user-images.githubusercontent.com/75922558/185870928-0710a185-9aec-4416-8967-df837c202a05.png" width="180"/>
    </span>
    <span>
        <img src="https://user-images.githubusercontent.com/75922558/185870951-024c4e3e-7ac4-44a8-aa88-2004212ee64c.png" width="180"/>
    </span>
    <span>
        <img src="https://user-images.githubusercontent.com/75922558/185870952-1d6a8ef1-9bf6-411b-9072-57d695c99a3b.png" width="180"/>
    </span>
</div>

## 🚀 어플리케이션 제작

- 기간 : 2022.08.08 ~ 2022.08.20
- 언어 : Swift5
- 디자인패턴 : [MVVM](#-mvvm-패턴)
- 비동기 프로그래밍을 위한 라이브러리 : [RxSwift](https://reactivex.io/)
- DataBase : [Realm](https://www.mongodb.com/docs/realm/sdk/swift/)
- UI 라이브러리 : Snapkit
- library dependancy manager: Cocoapods

## 📋 기능

- 할 일 작성 후 리스트에 `추가` [👀 더보기](#-할-일-추가)
- `완료`된 할 일은 `취소선과 체크아이콘`으로 표시 [👀 더보기](#-할-일-완료-체크-기능)
- `편집화면`에서 목록 `개별 삭제` 또는 `전체 삭제` 가능 [👀 더보기](#📍-할-일-삭제-기능)
- 할 일 작성시 `중요도` 선택 가능
- 중요도에 따라 색깔을 다르게 표시 (`중요도 : 높음 - 빨강, 보통 - 노랑, 낮음 - 초록`)
- `앱을 끄고 난 후 다시 켜도` 이전 할 일 리스트가 보이도록 데이터를 `데이터베이스에 저장` [👀 더보기](#📍-데이터-저장---realm)

<!-- ## 📍 MVVM 패턴

> Model - View - ViewModel

![WeatherMate_MVVM](https://user-images.githubusercontent.com/75922558/183399149-7f6c6536-46a0-4eb3-bc39-28da337f7874.png) -->

## 📍 할 일 추가

![add](https://user-images.githubusercontent.com/75922558/185876957-9bac21ed-8307-4452-b40d-b441589bb4c1.gif)

### 구현 요소

할 일을 추가 후 `저장 버튼` 클릭 시 `Realm` DB에 저장되게 한다. 이때, 데이터가 비어있으면 데이터가 저장 되지 않고 에러 메시지를 뷰에 토스트로 띄운다. 제대로 데이터가 저장되면 `add뷰가 dismiss 되고, 홈뷰에 데이터셀이 그려진다.` 홈뷰에서는 데이터가 없으면 초기 이미지가 그려지고, 데이터가 있으면 데이터 테이블 셀들이 그려진다.

### 구현 방법

데이터 옵저버블 생성후, addTask 함수에서 map을 통해 validation 체크 후 옵저버블의 데이터를 realm에 저장하여 리턴한다.

<details>
<summary>코드 보기</summary>

```swift
// repository
func addTask(task: TasksData) -> Observable<[TasksData]> {
  return Observable<[TasksData]>.create { observer -> Disposable in
    self.tasks.append(task)
    self.tasksSubject.onNext(self.tasks)
    observer.onNext(self.tasks)

    try! self.realm.write {
      self.realm.add(task)
    }

    return Disposables.create()
  }
}

// view model
func transform(input: Input) -> Output {
  let tasks = PublishSubject<[TasksData]>.init()
  let validationError = PublishSubject<String>.init()

  input.addTask
    .withUnretained(self)
    .flatMap{ (vm, data) -> Observable<[TasksData]> in
      if data.task == "" {
        validationError.onNext("할일을 입력해주세요!")
        return Observable.empty()
      } else if data.priority?.rawValue == TasksPriority.none.rawValue {
        validationError.onNext("중요도를 선택해주세요!")
        return Observable.empty()
      }
      return vm.tasksRepository.addTask(task: data)
    }
    .subscribe(onNext: { data in
      print(data)
      tasks.onNext(data)
    })
    .disposed(by: self.disposeBag)


  return Output(tasks : tasks,
                validationError: validationError)
}

// view
output.tasks
    .withUnretained(self)
    .subscribe(onNext: { (vc, data) in
        vc.dismiss(animated: false)
    })
    .disposed(by: disposeBag)

output.validationError
    .withUnretained(self)
    .subscribe(onNext: { (vc, msg) in
        vc.view.makeToast(msg)
    })
    .disposed(by: disposeBag)
```

</details>

## 📍 할 일 완료 체크 기능

![check](https://user-images.githubusercontent.com/75922558/185876934-f1c71791-d2a8-4e6e-8fed-ef3c30ecea2c.gif)

## 📍 할 일 삭제 기능

개별 삭제와 전체 삭제

![delete](https://user-images.githubusercontent.com/75922558/185876946-8f9c9ce5-52e1-49f8-8c64-0c88873189bd.gif)
![deleteAll](https://user-images.githubusercontent.com/75922558/185876953-3f7c5c0e-9c3d-4069-98bd-a612550969ce.gif)

## 📍 데이터 저장 - Realm

![Simulator Screen Recording - iPhone 11 - 2022-08-22 at 17 00 26](https://user-images.githubusercontent.com/75922558/185870954-dc916169-aa35-4002-ad8a-7fcc80c6eeca.gif)
