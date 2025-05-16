![Static Badge](https://img.shields.io/badge/iOS_-17.0%2B-blue)
![Static Badge](https://img.shields.io/badge/Xcode_-16.0%2B-blue)

<p align="center">
  <img src="https://velog.velcdn.com/images/findjayu/post/b2691f26-4f6a-4e41-a4c3-08a3bc3e0e9c/image.png" alt="샘플 이미지" width="150"/>
</p>

<div align="center">

# My Fitness  
사용자의 운동 루틴을 기록하고 분석할 수 있도록 도와주는 운동 회고 iOS 앱
</div>


## 실행방법
저장소 클론하기

터미널을 열고 다음 명령어를 입력하여 저장소를 클론합니다:
```
git clone https://github.com/8zipcore/MyFitness.git myFitness
```
클론한 디렉토리로 이동하여 `MyFitness.xcodeproj` 파일을 더블 클릭하거나, 터미널에서 다음 명령어를 입력하여 Xcode에서 프로젝트를 엽니다:
```
cd myFitness
open MyFitness.xcodeproj
```
Xcode에서 상단의 실행 버튼(▶️)을 클릭하여 시뮬레이터 또는 연결된 iOS 기기에서 앱을 실행합니다.

<br/>

## 1. Project Overview (프로젝트 개요)

**MyFitness**는 운동 기록과 회고로 맞춤 운동 루틴을 돕는 앱입니다.  
세트, 반복, 중량, 시간 등을 기록하고, 회고는 캘린더에서 날짜별로 확인할 수 있습니다.

### 🛠️ 추가 지원 기능
- **다크 모드** : 시스템 다크 모드에 자동 대응  
- **아이패드 지원** : 세로·가로 방향 모두 최적화된 UI 제공

## 2. 화면 설계

<p align="center">
  <img src="https://velog.velcdn.com/images/findjayu/post/e018d3d0-0f19-4e41-9fa6-c6db8b0d740b/image.png" alt="샘플 이미지" width="800"/>
</p>

## 3. Key Features (주요 기능)

- **메인화면**
    - 캘린더 UI를 통해 기록한 회고와 운동을 쉽게 확인할 수 있습니다.
    <br/>
- **회고 생성 화면**
    - 운동을 무산소, 유산소 운동으로 구분하여 기록할 수 있습니다.
    - 간단한 회고를 작성하고 확인할 수 있습니다.
    <br/>
- **검색 화면**
    - 작성된 회고를 검색 화면에서 쉽게 검색하고 확인할 수 있습니다.
    - 북마크 기능 지원을 통해서 원하는 회고를 빠르게 찾아볼 수 있습니다.
    <br/>
- **통계 화면**
    - 통계 화면을 통해서 다양한 기록과 그래프를 확인할 수 있습니다.

## 4. 프로젝트 구조
```plaintext
/MyFitness
├── Assets.xcassets
├── Documentation.docc
├── Extension
│   ├── Color+.swift
│   └── Date+.swift
├── Model
│   ├── Category.swift
│   ├── ExerciseCount.swift
│   ├── ExerciseType.swift
│   ├── Period.swift
│   ├── Restropect.swift
│   ├── WeekOrMonth.swift
│   ├── WorkoutItem.swift
│   └── WorkoutTimeData.swift
├── MyFitnessApp.swift
├── ViewModel
│   ├── CalendarViewModel.swift
│   ├── RetrospectViewModel.swift
│   ├── RetrospectWriteViewModel.swift
│   ├── SearchViewModel.swift
│   └── StatisticsViewModel.swift
└── Views
    ├── Main
    │   ├── Components
    │   └── MainView.swift
    ├── Retrospect
    │   ├── Components
    │   └── RetrospectView.swift
    ├── Search
    │   ├── Components
    │   └── SearchView.swift
    └── Statistics
        ├── Components
        └── StatisticsView.swift
```

<br/>


## 5. Tasks & Responsibilities (작업 및 역할 분담)
| 강대훈 | 하재준 | 홍승아 |
|:------:|:------:|:------:|
| <img src="https://github.com/user-attachments/assets/e97f2591-de89-4990-96d3-7d6f74ab0e45" alt="강대훈" width="150"> | <img src="https://github.com/user-attachments/assets/860a4008-ca16-48e5-9b15-06815d2dd1e0" alt="하재준" width="150"> | <img src="https://github.com/user-attachments/assets/55458ebd-db5a-445b-8a72-b611f2cc903d" alt="홍승아" width="150"> |
| [@kanghun1121](https://github.com/kanghun1121) | [@haejaejoon](https://github.com/haejaejoon) | [@8zipcore](https://github.com/8zipcore) |
| <ul><li>회고 화면 개발</li><li>통계 화면 개발</li><li>데이터 스키마 작성</li></ul> | <ul><li>검색 화면 개발</li><li>PPT 작성</li><li>Speaker</li></ul> | <ul><li>통계 화면 개발</li><li>메인 화면 개발</li><li>데이터 수집</li></ul> |


<br/>
