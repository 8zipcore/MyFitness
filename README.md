# 1. Project Overview (프로젝트 개요)
- 프로젝트 이름: MyFitness
- 프로젝트 설명: 하루 1분만 투자해서 기록해는 운동 회고 어플리케이션

# 2. Team Members (팀원 및 팀 소개)
| 강대훈 | 하재준 | 홍승아 |
|:------:|:------:|:------:|
| <img src="https://github.com/user-attachments/assets/e97f2591-de89-4990-96d3-7d6f74ab0e45" alt="강대훈" width="150"> | <img src="https://github.com/user-attachments/assets/860a4008-ca16-48e5-9b15-06815d2dd1e0" alt="하재준" width="150"> | <img src="https://github.com/user-attachments/assets/55458ebd-db5a-445b-8a72-b611f2cc903d" alt="홍승아" width="150"> |
| iOS | iOS | iOS |
| [GitHub](https://github.com/kanghun1121) | [GitHub](https://github.com/haejaejoon) | [GitHub](https://github.com/8zipcore) |

<br/>

# 3. Key Features (주요 기능)
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

# 4. 프로젝트 구조
```plaintext
/MyFitness
├── Assets.xcassets
│   ├── AccentColor.colorset
│   ├── AppIcon.appiconset
│   └── Contents.json
├── Documentation.docc
│   └── MyFitness.md
├── Extension
│   ├── Color+.swift
│   └── Date+.swift
├── Model
│   ├── Category.swift
│   ├── CategoryCount.swift
│   ├── ExerciseCount.swift
│   ├── ExerciseType.swift
│   ├── Period.swift
│   ├── Restropect.swift
│   ├── WeekOrMonth.swift
│   ├── WorkoutItem.swift
│   └── WorkoutTimeData.swift
├── Test
│   ├── DTO.swift
│   └── DummyData.json
├── ViewModel
│   ├── CalendarViewModel.swift
│   ├── RetrospectViewModel.swift
│   ├── RetrospectWriteViewModel.swift
│   ├── SearchViewModel.swift
│   └── StatisticsViewModel.swift
├── Views
```

<br/>

# 5. Tasks & Responsibilities (작업 및 역할 분담)
|  |  | |
|-----------------|-----------------|-----------------|
| 강대훈    |  <img src="https://github.com/user-attachments/assets/e97f2591-de89-4990-96d3-7d6f74ab0e45" alt="강대훈" width="150">| <ul><li>회고 화면 개발</li><li>통계 화면 개발</li><li>데이터 스키마 작성</li></ul>     |
| 하재준   |  <img src="https://github.com/user-attachments/assets/860a4008-ca16-48e5-9b15-06815d2dd1e0" alt="하재준" width="150">| <ul><li>검색 화면 개발</li><li>PPT 작성</li><li>Spacker</li></ul> |
| 홍승아   |  <img src="https://github.com/user-attachments/assets/55458ebd-db5a-445b-8a72-b611f2cc903d" alt="홍승아" width="150">   |<ul><li>더미 데이터 수집</li><li>메인 화면 개발</li><li>회고 화면 개발</li>  |



