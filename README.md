```
book/
├── structure/              사용자 정의 매크로(\newcommand) 저장 - 반복 스타일(색, 강조) 통합
│   ├── preamble.tex         패키지/옵션(폰트, 여백 등) 설정 - def.sty 자체를 포함하여 main에서 preamble만 호출
│   ├── base.sty             기초 매크로 (굵게, 색 강조 등)
│   ├── highlight.sty        형광펜, 강조 관련 매크로
│   ├── box.sty              박스, 틀, 테두리 등 시각적 요소
│   ├── table.sty            표 스타일, 줄 간격 등
│   └── README.md            지금 이 문서. 구조 및 규칙 설명
│
├── book_일반물리학/
│   ├── main/
│   │   ├── main.tex          메인 조립 파일
│   │   ├── main.pdf          pdf로 산출
│   │   └── ...               기타 파일은 자동 삭제 처리함
│   │
│   ├── chapters/             본문 내용
│   │   ├── chapter01.tex
│   │   ├── chapter02.tex
│   │   └── ...
│   │
│   ├── appendix/             부록 - 넘버링, 양식이 다르기 때문에 따로 별도 체계 위해 분리
│   │   ├── appendix01.tex    실험 방법 요약 - 이때 \appendix를 써야 하는데, 문서 상태가 전환되므로 한 번만 써야 함
│   │   ├── appendix02.tex    추가 그래프 모음
│   │   ├── appendix03.tex    설문지 원본, 코드 목록 등을 분리해서 사용
│   │   └── ...
│   │
│   ├── includes/
│   │   ├── title.tex         제목, 저자 등 표지글
│   │   └── figures.tex       미리 그림 선언하여 본문에서 끌어오도록 함(간결한 함수는 table.sty에서 선언)
│   │
│   ├── figures/              그림(.png, .pdf 등) 파일 모음
│   │
│   ├── tables/               표
│   │   ├── summarydata.tex   표를 tex 파일로 제작
│   │   └── ...
│   │
│   └── bib/                  참고문헌 - 아무렇게나 써도 추후 정렬(참조순, 가나다순 등)할 수 있음
│       ├── references.bib    메인 참고문헌 (책, 논문 등 전통적 자료)
│       ├── websites.bib      웹사이트 출처 (블로그, 통계청, 공식 발표 등)
│       └── papers.bib        학술 논문만 따로 구분
│
└── 모든 경로 해석은 main.tex 기준이므로, structure의 파일에 가려면 두 단계 상위 계열로 올라가야 함.
    예를 들어 다음과 같이 사용함.
    \input{../../structure/preamble.tex}
```
