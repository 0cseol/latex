%%
%% CNU Thesis Template for LaTeX - 
%% modified from KAIST Thesis Template for LaTeX
%%
%% @version      0.4
%% @releasedate  Nov 12th, 2004
%%
%% @author       Chae, Seugbyung 채승병
%%               mailto:chess@cnu.ac.kr
%% @author		 Lee, Byungjoon 이병준
%% 				 mailto:bjlee@etri.re.kr
%%
%% @requirements
%%    current distribution of teTeX, fpTeX, MikTeX
%%		+ Hangul-ucs 2.6.0 or higher
%%	  (please see http://faq.ktug.or.kr/faq/Hangul-ucs)
%%
%% Karnes Kim, converted to Hangul-ucs version.
%%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{cnu-ecs}
    [2011/03/02 v0.5 Standard CNU Thesis document class, Hangul-ucs version]

%% 옵션 설정을 위한 boolean 변수선언
\newif\if@isDoctor
\newif\if@isKorean
\newif\if@isFinal
\newif\if@PDFdoc\@PDFdocfalse

%% 새 옵션 모음 - doctor|master, korean|english, final|draft
\DeclareOption{doctor} {\@isDoctortrue}
\DeclareOption{master} {\@isDoctorfalse}
\DeclareOption{korean} {\@isKoreantrue}
\DeclareOption{english}{\@isKoreanfalse}
\DeclareOption{final}  {\@isFinaltrue}
\DeclareOption{draft}  {\@isFinalfalse}
\DeclareOption{pdfdoc} {\@PDFdoctrue}

%% leqno,fleqn,openbib 옵션은 그대로 report 클래스에 전달
\DeclareOption{leqno}  {\PassOptionsToClass{leqno}  {report}}
\DeclareOption{fleqn}  {\PassOptionsToClass{fleqn}  {report}}
\DeclareOption{openbib}{\PassOptionsToClass{openbib}{report}}

%% 페이지 번호 임시 저장용
\newcounter{pagemarker}                          
\setcounter{pagemarker}{1}

\ExecuteOptions{doctor,korean,final}         % doctor,korean,final이 기본값
\ProcessOptions

%% 10pt,a4paper,onecolumn,oneside 옵션으로 report 클래스 불러오기
\LoadClass[10pt,a4paper,onecolumn,oneside]{report}

\RequirePackage{ifthen}       % 추가 패키지 설정

%%%% Hangul-ucs preamble.......
\RequirePackage[nonfrench]{dhucs}
\RequirePackage[default]{dhucs-interword}
\RequirePackage{ifpdf}
\RequirePackage{xstring}
\ifpdf % pdftex
  \pdfmapfile{+unttf-pdftex-dhucs.map} % default fonts map
  \RequirePackage[pdftex]{graphicx}
 \if@PDFdoc
  \RequirePackage{dhucs-ucshyper}
  \hypersetup{%
  	colorlinks=true,%
	plainpages=false,%
	pdfpagelabels=true,%
  }
 \else
  \RequirePackage[bookmarks=false,colorlinks=false,plainpages=false]{hyperref}
 \fi
\else % dvipdfmx
  \RequirePackage{graphicx}
  \DeclareGraphicsExtensions{.eps,.pdf,.jpg}
  \DeclareGraphicsRule{.pdf}{eps}{.bb}{}
  \DeclareGraphicsRule{.jpg}{eps}{.bb}{}
 \if@PDFdoc
  \RequirePackage{dhucs-ucshyper}
  \hypersetup{%
     dvipdfm=true,
     colorlinks=true,
     plainpages=false,
     pdfpagelabels=true
  }
 \else
  \RequirePackage[dvipdfm,bookmarks=false,colorlinks=false,plainpages=false]{hyperref}
 \fi
\fi
%% for compatability to HLaTeX
\let\gt\sffamily
\DeclareTextFontCommand{\textgt}{\gt}
%%%% end of Hangul-ucs preamble

\AtBeginDocument{%                           % \begin{document}와 함께 실행
    \checkparameters                        % 문서 변수가 올바른지 점검
    \if@isFinal                             % final 옵션이 지정되어 있으면
        \makefrontcover \maketitle         % 앞표지, 속표지 생성
        \makeapproval                      % 제출승인서, 심사완료검인 생성
    \else \fi }
\AtEndDocument{}                             % \end{document}와 함께 실행

%% 출력용지 여백 설정 - A4 출력을 기본으로 4 x 6배판 재단
\setlength{\topmargin}     {4.6mm}
\setlength{\headheight}    {10mm}
\setlength{\headsep}       {10mm}
\setlength{\oddsidemargin} {11.6mm}
\setlength{\textheight}    {195mm}
\setlength{\textwidth}     {140mm}
\setlength{\footskip}      {12mm}

%% 줄간격 설정
%\renewcommand{\baselinestretch}{1.9}
\linespread{1.9}

%% 본문이 영어로 되어있는지 한글로 되어있는지 설정
\newcommand{\@korean}{korean}
\newcommand{\@english}{english}
\newcommand{\@textlang}{}                    % 텍스트 기본언어 변수선언
\if@isKorean                                 % korean 옵션이 지정되어 있으면
    \let\@textlang\@korean                  % 텍스트 기본언어는 한글
\else                                        % english 옵션이 지정되어 있으면
    \let\@textlang\@english                 % 텍스트 기본언어는 영문
\fi

%% 충남대학교 공식 영문명칭
\newcommand{\@cnu}{Chungnam National University}

%%
%% 문서 정보 변수 정의
%%

% @command title 논문 제목
% @options [default: (none)]
% - korean: 한글제목 | english: 영문제목
\renewcommand{\title}[2][korean] {%
    \ifthenelse{\equal{#1}{korean}}%
        {\newcommand{\@titleKor}{#2}}{}%
    \ifthenelse{\equal{#1}{english}}%
        {\newcommand{\@titleEng}{#2}}{}%
}
\@onlypreamble{\title}

% @command author 저자 이름
% @param family_name, given_name 성, 이름을 구분해서 입력
% @options [default: (none)]
% - korean: 한글이름 | chinese: 한문이름 | english: 영문이름
\renewcommand{\author}[3][korean] {%
    \ifthenelse{\equal{#1}{korean}}
        {\newcommand{\@authorKorFN}{#2}
         \newcommand{\@authorKorGN}{#3}
         \newcommand{\@authorKor}{#2\ #3}}{}%
    \ifthenelse{\equal{#1}{english}}
        {\newcommand{\@authorEngFN}{#2}
         \newcommand{\@authorEngGN}{#3}
         \newcommand{\@authorEng}{#2, #3}}{}%
}
\@onlypreamble{\author}

% @command advisor 지도교수 이름 (복수가능)
% @options [default: major]
% - major: 주 지도교수  | coopr: 부 지도교수 (공동지도교수 경우)
\newcommand{\advisor}[4][major]{%
    \ifthenelse{\equal{#1}{major}} {%       % 주 지도교수이면
        \newcommand{\@advisorMajorKor}{#2} % 한글이름 저장
        \newcommand{\@advisorMajorEng}{#3} % 영문이름 저장
        % nosign을 명시하지 않으면 주 지도교수가 서명한 것으로 간주
        \ifthenelse{\equal{#4}{nosign}}{}{%
            \newcommand{\@advisorSigned}{\@advisorMajorEng}} }{}%
    \ifthenelse{\equal{#1}{coopr}} {%       % 부 지도교수이면
        \newcommand{\@advisorCooprKor}{#2} % 한글이름 저장
        \newcommand{\@advisorCooprEng}{#3} % 영문이름 저장
        % signed를 명시해야 부 지도교수가 서명한 것으로 간주
        \ifthenelse{\equal{#4}{signed}}{%
            \newcommand{\@advisorSigned}{\@advisorCooprEng}}{} }{}%
}
\@onlypreamble{\advisor}

% @command department 학과이름 - 아래 표에 따라 코드를 입력
%
% 물리학과          PH          생물과학과        BS
% 수학전공          MA          응용수학전공      AM
% 화학과            CH          기계공학전공      ME
% 항공우주공학전공  AE          산업공학과        IE
% 산업디자인학과    ID          원자력양자공학과  NQE
% 재료공학과        MS          전기및전자전공    EE
% 전산전공          CS          건설및환경공학과  CE
% 바이오시스템학과  BiS         생명화학공학과    CBE
% 경영공학전공      MT          경영정보공학전공  MIS
% 신소재공학과      AME         자동화및설계공학  ADE
% 정보및통신공학    ICE         테크노경영        TM
% 경영정보          IS          통신경영/정책     TP
% 금융공학          FE          환경경영/정책     GM
%
\newcommand{\@degreeCode}{}          % 학위 영문코드
\newcommand{\@degreeName}{}          % 학위명
\newcommand{\@affFullNameKor}{}      % 학과/전공 한글이름
\newcommand{\@affFullNameEng}{}      % 학과/전공 영문이름
\newcommand{\@affFullNameEngCover}{} % 학과/전공 영문이름(표지용)
\newcommand{\@deptNameKor}{}
\newcommand{\@deptNameEng}{}
\newcommand{\@deptNameChn}{}
\newcommand{\@divNameKor}{}
\newcommand{\@divNameEng}{}
\newcommand{\@divNameChn}{}
\newcommand{\@progNameKor}{}
\newcommand{\@progNameEng}{}
\newcommand{\@degreeField}{}
\newcommand{\@degreePrefix}{\ifthenelse{\boolean{@isDoctor}}{D\_}{M\_}}
\newcommand{\department}[1] {%
    \ifthenelse{\equal{#1}{PH}}
        {\renewcommand{\@degreeCode}{\@degreePrefix #1}%
         \renewcommand{\@deptNameKor}{물리학}%
         \renewcommand{\@deptNameEng}{Physics}
         \renewcommand{\@degreeField}{science}} {}%
    \ifthenelse{\equal{#1}{BS}}
        {\renewcommand{\@degreeCode}{\@degreePrefix #1}%
         \renewcommand{\@deptNameKor}{생물과학}%
         \renewcommand{\@deptNameEng}{Biological Sciences}
         \renewcommand{\@degreeField}{science}} {}%
    \ifthenelse{\equal{#1}{MA}}
        {\renewcommand{\@degreeCode}{\@degreePrefix #1}%
         \renewcommand{\@deptNameKor}{수학}%
         \renewcommand{\@deptNameEng}{Mathematics}%
         \renewcommand{\@divNameKor}{수학}%
         \renewcommand{\@divNameEng}{Mathematics}
         \renewcommand{\@degreeField}{science}} {}%
    \ifthenelse{\equal{#1}{AM}}
        {\renewcommand{\@degreeCode}{\@degreePrefix #1}%
         \renewcommand{\@deptNameKor}{수학}%
         \renewcommand{\@deptNameEng}{Mathematics}%
         \renewcommand{\@divNameKor}{응용수학}%
         \renewcommand{\@divNameEng}{Applied Mathematics}
         \renewcommand{\@degreeField}{science}} {}%
    \ifthenelse{\equal{#1}{CH}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{화학}%
         \renewcommand{\@deptNameEng}{Chemistry}
         \renewcommand{\@degreeField}{science}} {}%
    \ifthenelse{\equal{#1}{ME}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{기계공학}%
         \renewcommand{\@deptNameEng}{Mechanical Engineering}%
         \renewcommand{\@divNameKor}{기계공학}%
         \renewcommand{\@divNameEng}{Mechanical Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{AE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{기계공학}%
         \renewcommand{\@deptNameEng}{Mechanical Engineering}%
         \renewcommand{\@divNameKor}{항공우주공학}%
         \renewcommand{\@divNameEng}{Aerospace Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{CE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{건설 및 환경공학}%
         \renewcommand{\@deptNameEng}{Civil and Environmental Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{BiS}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{바이오시스템학}%
         \renewcommand{\@deptNameEng}{BioSystems}
         \renewcommand{\@degreeField}{science}} {}%
    \ifthenelse{\equal{#1}{IE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{산업공학}%
         \renewcommand{\@deptNameEng}{Industrial Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{ID}}
        {\renewcommand{\@degreeCode}{%
            % 산업디자인학과는 이상하게 석-박사간 코드가 다름
            \ifthenelse{\equal{\@degree}{master}}{MID}{DDS}}%
         \renewcommand{\@deptNameKor}{산업디자인학}%
         \renewcommand{\@deptNameEng}{Industrial Design}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{CBE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{생명화학공학}%
         \renewcommand{\@deptNameEng}{Chemical and Biomolecular Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{NQE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{원자력 및 양자공학}%
         \renewcommand{\@deptNameEng}{Nuclear and Quantum Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{MS}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{재료공학}%
         \renewcommand{\@deptNameEng}{Material Science and Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{EE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{전자전산학}%
         \renewcommand{\@deptNameEng}{Electrical Engineering and
                                Computer Science}%
         \renewcommand{\@divNameKor}{전기및전자공학}%
         \renewcommand{\@divNameEng}{Electrical Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{CSE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{컴퓨터공학}%
         \renewcommand{\@deptNameChn}{컴퓨터工學}%
         \renewcommand{\@deptNameEng}{Computer Engineering}%
         \renewcommand{\@divNameKor}{통신및보안}%
         \renewcommand{\@divNameChn}{通信및保安}%
         \renewcommand{\@divNameEng}{Computer Communication and Security}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{AME}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{신소재공학}%
         \renewcommand{\@deptNameEng}{Advanced Materials Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{ADE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{자동화및설계공학}%
         \renewcommand{\@deptNameEng}{Automation and Design Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{ICE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{정보및통신공학}%
         \renewcommand{\@deptNameEng}{Information and Communication
                                Engineering}
         \renewcommand{\@degreeField}{engineering}} {}%
    \ifthenelse{\equal{#1}{IM}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@deptNameKor}{산업경영학}%
         \renewcommand{\@deptNameEng}{Industrial Management}
         \renewcommand{\@degreeField}{business}} {}%
    \ifthenelse{\equal{#1}{MT}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@divNameKor}{경영공학}%
         \renewcommand{\@divNameEng}{Management Engineering}
         \renewcommand{\@degreeField}{business}} {}%
    \ifthenelse{\equal{#1}{IS}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@progNameKor}{경영정보}%
         \renewcommand{\@progNameEng}{Management Information Systems}
         \renewcommand{\@degreeField}{business}} {}%
    \ifthenelse{\equal{#1}{TM}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@progNameKor}{테크노경영}%
         \renewcommand{\@progNameEng}{Technology Management}
         \renewcommand{\@degreeField}{business}} {}%
    \ifthenelse{\equal{#1}{TP}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@progNameKor}{통신경영/정책}%
         \renewcommand{\@progNameEng}{Telecommunications Management and
                                Policy}
         \renewcommand{\@degreeField}{business}} {}%
    \ifthenelse{\equal{#1}{FE}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@progNameKor}{금융공학}%
         \renewcommand{\@progNameEng}{Financial Engineering}
         \renewcommand{\@degreeField}{business}} {}%
    \ifthenelse{\equal{#1}{GM}}
        {\renewcommand{\@degreeCode}{\@degreePrefix#1}%
         \renewcommand{\@progNameKor}{환경경영/정책}%
         \renewcommand{\@progNameEng}{Green Management and Policy}
         \renewcommand{\@degreeField}{business}} {}%

    \renewcommand{\@affFullNameKor}{%               % 학과/전공 한글이름
        \ifthenelse{\equal{\@deptNameKor}{}} {}{\@deptNameKor 과}%
        \ifthenelse{\equal{\@divNameKor}{}} {}{ \@divNameKor 전공}%
        \ifthenelse{\equal{\@progNameKor}{}} {}{\@progNameKor 전공}%
    }
    \renewcommand{\@affFullNameEng}{%               % 학과/전공 영문이름
        \ifthenelse{\equal{\@deptNameEng}{}}
            {\ifthenelse{\equal{\@divNameEng}{}}
                {}{Division of \@divNameEng}}%   % 전공(division)명
            {Department of \@deptNameEng          % 학과명
             \ifthenelse{\equal{\@divNameEng}{}}
                {}{,\ Division of \@divNameEng}} % 학과명 + 전공(division)명
        \ifthenelse{\equal{\@progNameEng}{}}
            {}{\@progNameEng\ Program}%           % 전공(program)명
    }
    \renewcommand{\@affFullNameEngCover}{%          % 학과/전공 영문이름
        \ifthenelse{\equal{\@deptNameEng}{}}       % (표지인쇄용)
            {\ifthenelse{\equal{\@divNameEng}{}}
                {}{Division of \@divNameEng}}%
            {Department of \@deptNameEng
             \ifthenelse{\equal{\@divNameEng}{}}
                {}{%
                \ifthenelse{\equal{#1}{MA}\or\equal{#1}{AM}}%
                    {\ }{\\ }%            % MA나 AM은 짧으므로 공백문자
                Division of \@divNameEng} }% 나머지는 길므로 개행문자 삽입
        \ifthenelse{\equal{\@progNameEng}{}}
            {}{\@progNameEng\ Program}%
    }
    \renewcommand{\@degreeName}{%                       % 학위 영문이름
        \ifthenelse{\boolean{@isDoctor}}
            {Doctor of Philosophy} {%                 % 박사는 모두 Ph.D.
            \ifthenelse{\equal{\@degreeField}{science}}
                {Master of Science}{}%               % 이학석사는 M.S.
            \ifthenelse{\equal{\@degreeField}{engineering}}
                {Master of Engineering}{}%           % 공학석사는 M.E.
            \ifthenelse{\equal{\@degreeField}{business}}
                {Master of Business Administration}{}% 경영학석사는 M.B.A.
        }
    }
}
\@onlypreamble{\department}

% @command studentid 학번
\newcommand{\studentid}[1]{\newcommand{\@studentID}{#1}}
\@onlypreamble{\studentid}

\newcommand{\submitdate}[3] {%
    \newcommand{\@submitYear}{#1}
    \newcommand{\@submitMonth}{#2}
    \newcommand{\@submitDay}{#3}
}
\@onlypreamble{\submitdate}

% @command approvaldate 지도교수논문승인일
% @param year,month,day 연,월,일 순으로 입력
\newcommand{\approvaldate}[3] {%
    \newcommand{\@approvalYear}{#1}
    \newcommand{\@approvalMonth}{#2}
    \newcommand{\@approvalDay}{#3}
}
\@onlypreamble{\approvaldate}

% @command refereedate 심사위원논문심사일
% @param year,month,day 연,월,일 순으로 입력
\newcommand{\refereedate}[3] {%
    \newcommand{\@refereeYear}{#1}
    \newcommand{\@refereeMonth}{#2}
    \newcommand{\@refereeDay}{#3}
}
\@onlypreamble{\refereedate}

% @command gradyear 졸업년도
\newcommand{\gradyear}[2]{
	\newcommand{\@gradYear}{#1}
	\newcommand{\@gradMonth}{#2}
	\newcommand{\@gradMonthStr}{%
		\ifthenelse{\equal{#2}{1}}{January}{}%
		\ifthenelse{\equal{#2}{2}}{February}{}%
		\ifthenelse{\equal{#2}{3}}{March}{}%
		\ifthenelse{\equal{#2}{4}}{April}{}%
		\ifthenelse{\equal{#2}{5}}{May}{}%
		\ifthenelse{\equal{#2}{6}}{June}{}%
		\ifthenelse{\equal{#2}{7}}{July}{}%
		\ifthenelse{\equal{#2}{8}}{August}{}%
		\ifthenelse{\equal{#2}{9}}{September}{}%
		\ifthenelse{\equal{#2}{10}}{October}{}%
		\ifthenelse{\equal{#2}{11}}{November}{}%
		\ifthenelse{\equal{#2}{12}}{December}{}%
		}
}
\@onlypreamble{\gradyear}

%%
%% 필요한 정보 중에 누락된 것이 없는지 점검 --> 제작중. 아직 불완전.
%%
\newcommand{\checkparameters}{%
    \@ifundefined{@titleKor}{%
        \ClassError{cnu}{The korean title is not found}{}}{}
    \@ifundefined{@titleEng}{%
        \ClassError{cnu}{The english title is not found}{}}{}
    \@ifundefined{@authorKor}{%
        \ClassError{cnu}{The korean name of the author is not found}{}}{}
    \@ifundefined{@authorEng}{%
        \ClassError{cnu}{The english name of the author is not found}{}}{}
    \@ifundefined{@advisorMajorKor}{%
        \ClassError{cnu}{The korean name of the major advisor is not found}{}}{}
    \@ifundefined{@advisorMajorEng}{%
        \ClassError{cnu}{The english name of the major advisor is not found}{}}{}
}

%%
%% 앞표지 생성
%%
\newcommand{\makefrontcover}{%
    \renewcommand{\baselinestretch}{1.3}%
    \thispagestyle{empty} \noindent%
    \begin{minipage}[t][19mm][t]{\textwidth}
        \begin{center}
            \Large
            \if@isDoctor
                박 사 학 위 논 문%%\\ Doctoral Thesis
            \else
                석 사 학 위 논 문%%\\ Master's Thesis
            \fi
        \end{center}
    \end{minipage}\\[0mm]
    \begin{minipage}[t][45mm][t]{\textwidth}
        \begin{center}
            \huge  \@titleKor \\[15pt]
            %%\Large \@titleEng
        \end{center}
    \end{minipage}\\[0mm]
	\begin{minipage}[t][11mm][t]{\textwidth}
		\begin{center}
		\Large 
			충남대학교 대학원
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][20mm][t]{\textwidth}
		\begin{center}
		\Large 
			\@deptNameKor 과\ \  \@divNameKor 전공
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][25mm][t]{\textwidth}
		\begin{center}
		\Large 
			\@authorKorFN\ \@authorKorGN 
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][45mm][t]{\textwidth}
		\begin{center}
		\Large 
			지도교수\hspace{15pt} \@advisorMajorKor
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][20mm][t]{\textwidth}
		\begin{center}
		\LARGE 
			\@gradYear\ 년 \@gradMonth\ 월
		\end{center}
	\end{minipage}\\[0mm]
    \newpage
	\chapter*{}
	\pagestyle{empty}
	\newpage 
}

%%
%% 속표지 생성
%%
\renewcommand{\maketitle}{%
    \renewcommand{\baselinestretch}{1.3}%
    \thispagestyle{empty} \noindent%
    \begin{minipage}[t][40mm][t]{\textwidth}
        \begin{center}
            \huge  \@titleKor 
        \end{center}
    \end{minipage}\\[0mm]
	\begin{minipage}[t][35mm][t]{\textwidth}
		\begin{center}
		\Large 
			지도교수\hspace{15pt} \@advisorMajorKor
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][30mm][t]{\textwidth}
		\begin{center}
		\LARGE 
			이 논문을 
            \if@isDoctor
			공학박사학위
            \else
			공학석사학위
            \fi \\
			청구논문으로 제출함
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][25mm][t]{\textwidth}
		\begin{center}
		\Large 
			\@submitYear\ 년 \@submitMonth\ 월
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][15mm][t]{\textwidth}
		\begin{center}
		\Large 
			충남대학교 대학원
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][15mm][t]{\textwidth}
		\begin{center}
		\Large 
			\@deptNameKor 과\ \  \@divNameKor 전공
		\end{center}
	\end{minipage}\\[0mm]
	\begin{minipage}[t][25mm][t]{\textwidth}
		\begin{center}
		\Large 
			\@authorKorFN\ \@authorKorGN 
		\end{center}
	\end{minipage}\\[0mm]
	\newpage
	\chapter*{}
	\pagestyle{empty}
	\newpage 
}

%%
%% 학위논문  심사완료 검인서 생성
%%
\newcommand{\makeapproval}{%
    % 학위논문 심사완료 검인서
    \newpage \thispagestyle{empty} \noindent
    \begin{minipage}[t][45mm][t]{\textwidth}
        \begin{center}
            \huge 
			\vspace{1cm}
			\@authorKorFN\StrDel{\@authorKorGN}{ }의 
            \if@isDoctor
			공학박사학위
            \else
			공학석사학위
			\fi\\
			청구논문을 인준함
        \end{center}
    \end{minipage}\\[0mm]
    \parbox[t][10mm][t]{\textwidth}{\mbox{}}       % 10mm 공백삽입
    \begin{minipage}[t][20mm][t]{\textwidth}
        \Large 
		\begin{center}
		\@approvalYear\ 년 \@approvalMonth\ 월 \\[7mm]
		논문심사위원회
		\end{center}
    \end{minipage}\\[0mm]
    \begin{minipage}[t][80mm][t]{\textwidth}
        \Large
        \begin{center}
        \newcommand{\@nameWidth}{95pt}
        \begin{tabular}{lll}                 % 심사위원명단
        \\[10pt]위원장 & \ \makebox[\@nameWidth][s]{}  & .\\ \cline{2-3}
        위\hspace{10pt} 원  & \ \makebox[\@nameWidth][s]{} & .\\ \cline{2-3}
        위\hspace{10pt} 원  & \ \makebox[\@nameWidth][s]{} & .\\ \cline{2-3}
		\if@isDoctor
        위\hspace{10pt} 원  & \ \makebox[\@nameWidth][s]{} & .\\ \cline{2-3}
        위\hspace{10pt} 원  & \ \makebox[\@nameWidth][s]{} & .\\ \cline{2-3}
		\fi
        \end{tabular}
        \end{center}
    \end{minipage} 
    \begin{minipage}[t][10mm][t]{\textwidth}	
		\begin{center}
		\LARGE
		충 남 대 학 교\hspace{15pt} 대 학 원
		\end{center}
	\end{minipage}
	\hfill 
	\newpage
	\chapter*{}
	\pagestyle{empty}
	\newpage 
	\pagestyle{plain}
}

%%
%% 한글요약문 생성
%%

\newenvironment{summary}{%              % 요약문 생성 환경
	\ifthenelse{\isodd{\value{page} + 1}}{
		\clearpage
		\chapter*{}
		\pagestyle{plain}
		\newpage 
	}{
		\clearpage
	}
    \newcommand{\@tempbreak}{}
    \let\@tempbreak\linebreak
    \renewcommand{\linebreak}{\ }      % \linebreak 명령 바꿔치기
    \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{요약문 (국문)}
    \begin{quote}
        \begin{center}
            \noindent 
			\Large \textsf{\@titleKor} \\[10mm]
			\textsf{\@authorKorFN \ \@authorKorGN} \\[13mm]
			\large
			충남대학교 대학원 \@deptNameKor 과 \@divNameKor 전공 \\
			( 지도교수  \@advisorMajorKor \ )\\[15mm]
        \end{center}
    \end{quote}% \setlength{\parindent}{0pt}
}{  \let\linebreak\@tempbreak          			% \linebreak 명령 되돌리기
	\newpage
}

%%
%% 초록(abstract)페이지 생성
%%
\renewenvironment{abstract}{%
	\renewcommand{\thefootnote}{\fnsymbol{footnote}}
	\renewcommand{\baselinestretch}{1.0}
	\renewcommand{\abstractname}{ABSTRACT}
	\begin{center}
	\Large
	\textbf{\abstractname}\footnotemark[1] \\[10mm]
	\@titleEng \\[10mm]
	\large
	\@authorEngGN\ \@authorEngFN \\[10mm]
	Department of \@deptNameEng, Graduate School \\
	Chungnam National University \\
	Daejeon, Korea\\[10mm]
	( Supervised by Professor \@advisorMajorEng\ )\\[10mm]
	\end{center}
	
	\if@isKorean
    	\if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{요약문 (영문)}% 초록을 목차(TOC)에 삽입
	\else
    	\if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{Abstract}% 초록을 목차(TOC)에 삽입
	\fi
	
	\renewcommand{\baselinestretch}{1.2}
	\normalfont
}{ \renewcommand{\baselinestretch}{1.0}
	\footnotetext[1]{\normalsize 
	A dissertation submitted to the committee of Graduate School,
	Chungnam National University in a partial fulfillment of the requirements for the 
	degree of Doctor of Philosophy conferred in \@gradMonthStr\ \@gradYear.}
	\newpage 
	% \pagenumbering{arabic}              % 페이지 아라비아 수자 포맷
	\let\linebreak\@tempbreak                    % \linebreak 명령 복원
}

%%
%% 목차 일괄 생성
%%
\newcommand{\makecontents}{%            % TOC, LOT, LOF 생성
    \tableofcontents
    \listoftables
    \listoffigures
}

%%
%% 감사의 글 및 이력서 생성
%%
\newcommand{\acknowledgement}{%                 % 감사의 글
    \chapter*{감 사 의\ \ 글}
    \pagestyle{empty}
}

\newcommand{\curriculumvitae}[1][default]{%     % 이력서
    \newcommand{\@ccvlang}{#1}
    \ifthenelse{\equal{#1}{default}}            % 아무 옵션을 설정하지 않으면
        {\let\@ccvlang\@textlang}{}           % 논문 언어대로 이력서 언어설정
    \ifthenelse{\equal{\@ccvlang}{\@korean}}
        {\chapter*{이 력 서}}                 % korean  옵션일 경우
        {\chapter*{Curriculum Vitae}}         % english 옵션일 경우
    \pagestyle{empty}
}

%%
%% 이력서 내부 요소 생성
%%
    \newenvironment{personaldata}{%            % 개인정보
        \begin{list}{}{%
            \setlength{\labelwidth}{70pt}
            \setlength{\leftmargin}{\labelwidth}
            \addtolength{\leftmargin}{\labelsep}
            \setlength{\parsep}{0pt}
            \renewcommand{\makelabel}[1]{\textgt{##1\ \ :\ }}}
        \newcommand{\name}[1]{%               % 이름
            \ifx\@ccvlang\@korean
                \def\@arg{[이\hfill름]}
            \else
                \def\@arg{[Name\hfill]}
            \fi
            \expandafter\item\@arg ##1}
        \newcommand{\dateofbirth}[3]{%        % 생년월일
            \ifx\@ccvlang\@korean
                \def\@arg{[생\hfill년\hfill월\hfill일]}
                \expandafter\item\@arg ##1년 ##2월 ##3일
            \else
                \def\@arg{[Date of Birth\hfill]}
                \expandafter\item\@arg \@dateUSenglish{##1}{##2}{##3}
            \fi}
        \newcommand{\birthplace}[1]{%         % 출생지
            \ifx\@ccvlang\@korean
                \def\@arg{[출\hfill생\hfill지]}
            \else
                \def\@arg{[Birthplace\hfill]}
            \fi
            \expandafter\item\@arg ##1}
        \newcommand{\domicile}[1]{%           % 본적지
            \ifx\@ccvlang\@korean
                \def\@arg{[본\hfill적\hfill지]}
            \else
                \def\@arg{[Domicile\hfill]}
            \fi
            \expandafter\item\@arg ##1}
        \newcommand{\address}[1]{%            % 주소지
            \ifx\@ccvlang\@korean
                \def\@arg{[주\hfill소]}
            \else
                \def\@arg{[Address\hfill]}
            \fi
            \expandafter\item\@arg ##1}
        \newcommand{\email}[1]{%              % E-mail
            \ifx\@ccvlang\@korean
                \def\@arg{[E-mail\hfill주\hfill소]}
            \else
                \def\@arg{[E-mail\hfill]}
            \fi
            \expandafter\item\@arg ##1}
        % 이력서에 집어넣을 추가 필드가 필요하면 위를 참고하여 만들어 쓸 것.
        % \newcommand{(필드명령)}[1]{%
        %   \ifx\@ccvlang\@korean
        %       \def\@arg{[(한글필드명)]}
        %   \else
        %       \def\@arg{[(영문필드명)]}
        %   \fi
        %   \expandafter\item\@arg ##1}
    }{\end{list}}

    \newenvironment{education}{%               % 학력
        \vspace*{5mm} \noindent
        \ifx\@ccvlang\@korean
            \begin{center}
                \makebox[2cm][s]{\textbf{\large 학 력}}
            \end{center}
        \else \textbf{\large Educations} \fi
        \begin{list}{}{%
            \setlength{\labelwidth}{95pt}
            \setlength{\leftmargin}{\labelwidth}
            \addtolength{\leftmargin}{\labelsep}
            \setlength{\parsep}{0pt}
            \renewcommand{\makelabel}[1]{\textgt{##1\hfill\ }}}
    }{\end{list}}

    \newenvironment{career}{%                  % 경력
        \vspace*{5mm} \noindent
        \ifx\@ccvlang\@korean
            \begin{center}
                \makebox[2cm][s]{\textbf{\large 경 력}}
            \end{center}
        \else \textbf{\large Career} \fi
        \begin{list}{}{%
            \setlength{\labelwidth}{95pt}
            \setlength{\leftmargin}{\labelwidth}
            \addtolength{\leftmargin}{\labelsep}
            \setlength{\parsep}{\z@}
            \renewcommand{\makelabel}[1]{\textgt{##1\hfill\ }}}
    }{\end{list}}

    \newcounter{itemnum1}
    \newenvironment{activity}{%                % 학회활동
        \vspace*{5mm} \noindent
        \ifx\@ccvlang\@korean
            \begin{center}
                \makebox[2cm][s]{\textbf{\large 학 회 활 동}}
            \end{center}
        \else \textbf{\large Academic Activities} \fi
        \begin{list}{}{%
            \usecounter{itemnum1}
            \setlength{\labelwidth}{1.5em}
            \setlength{\leftmargin}{\labelwidth}
            \addtolength{\leftmargin}{\labelsep}
            \setlength{\parsep}{\z@}
            \renewcommand{\makelabel}{\textgt{\arabic{itemnum1}.\ }}}
    }{\end{list}}

    \newcounter{itemnum2}
    \newenvironment{publication}{%             % 연구업적
        \vspace*{5mm} \noindent
        \ifx\@ccvlang\@korean
            \begin{center}
                \makebox[2cm][s]{\textbf{\large 연 구 업 적}}
            \end{center}
        \else \textbf{\large Publications} \fi
        \begin{list}{}{%
            \usecounter{itemnum2}
            \setlength{\labelwidth}{1.5em}
            \setlength{\leftmargin}{\labelwidth}
            \addtolength{\leftmargin}{\labelsep}
            \setlength{\parsep}{\z@}
            \renewcommand{\makelabel}{\textgt{\arabic{itemnum2}.\ }}}
    }{\end{list}}

%%
%% 헤딩 재설정
%%
\renewcommand{\contentsname}{%
    \if@isKorean 목 차       \else Contents        \fi}
\renewcommand{\listfigurename}{%
    \if@isKorean 그 림 목 차 \else List of Figures \fi}
\renewcommand{\listtablename}{%
    \if@isKorean 표 목 차    \else List of Tables  \fi}
\renewcommand{\bibname}{%
    \if@isKorean 참 고 문 헌 \else References      \fi}

%%
%% \part 재정의 - 아예 쓰지 못하게 막아버림. 이 명령을 호출하면 에러 발생.
%%
\renewcommand\part{%
    \secdef\@part\@spart}
\def\@part[#1]#2{%
    \ClassError{cnu}{The use of \protect\part\space is prohibited.
        \MessageBreak Consider the use of \protect\chapter\space instead}{}
}
\def\@spart#1{%
    \ClassError{cnu}{The use of \protect\part\space is prohibited.
        \MessageBreak Consider the use of \protect\chapter\space instead}{}
}

%%
%% \chapter 재정의 - report 클래스로부터 복사하여 일부 수정
%%
\renewcommand\chapter{%
    \if@openright\cleardoublepage\else\clearpage\fi
%   \thispagestyle{plain}%
    \global\@topnum\z@
    \@afterindentfalse
%   \if@isKorean \parindent\z@ \else \fi % <-- 추가할지 여부 고민중
    \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
        \refstepcounter{chapter}%
        \typeout{\@chapapp\space\thechapter.}%
        \addcontentsline{toc}{chapter}{%
            \if@isKorean
                \protect\numberline{제 \thechapter\ 장}#1
            \else
                \protect\numberline{\thechapter}#1
            \fi
        }% <-- 목차에 나타나는 형식 - 변경사항
    \else
        \addcontentsline{toc}{chapter}{#1}%
    \fi
    \chaptermark{#1}%
    \addtocontents{lof}{\protect\addvspace{10\p@}}%
    \addtocontents{lot}{\protect\addvspace{10\p@}}%
    \if@twocolumn
        \@topnewpage[\@makechapterhead{#2}]%
    \else
        \@makechapterhead{#2}%
        \@afterheading%
    \fi
}
\def\@makechapterhead#1{% <-- 전체 변경
    \vspace*{10\p@}
%    {\centering \parindent\z@ \LARGE\bfseries
%    \ifthenelse{\equal{\@textlang}{korean}}
%        {제\hspace{1.4ex}\thechapter\hspace{1.4ex}장\hspace{2ex}}
%        {\thechapter.\hspace{1ex}}
%    \\#1\par}
    {\parindent\z@ \LARGE\bfseries
    \ifthenelse{\equal{\@textlang}{korean}}
        {제\hspace{1.4ex}\thechapter\hspace{1.4ex}장\hspace{2ex}\vspace{2ex}}
        {\thechapter.\hspace{1ex}\vspace{2ex}}
    \\#1\par}
    \vspace*{60\p@}
}
\def\@schapter#1{%
    \if@twocolumn
        \@topnewpage[\@makeschapterhead{#1}]%
    \else
        \@makeschapterhead{#1}%
        \@afterheading
    \fi}
\def\@makeschapterhead#1{% <-- 전체 변경
    \vspace*{10\p@}
    {\centering \parindent\z@ \LARGE\bfseries #1\par}
    \vspace*{20\p@}
}

%%
%% 표와 그림 표기에 쓰이는 표제어 재정의
%%
%%\renewcommand\tablename{\ifthenelse{\equal{\@textlang}{korean}}{표}{Table}}
%%\renewcommand\figurename{\ifthenelse{\equal{\@textlang}{korean}}{그림}{Figure}}

%%
%% \tableofcontents 재정의 - report 클래스로부터 복사하여 일부 수정
%%
\renewcommand\tableofcontents{%
    \if@twocolumn
        \@restonecoltrue\onecolumn
    \else
        \@restonecolfalse
    \fi
    \chapter*{\contentsname
        \@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \pagenumbering{roman}                         % roman 페이지번호로 복원
    \setcounter{page}{\value{pagemarker}}         % pagemarker에 저장된 값으로
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
    \newpage \setcounter{pagemarker}{\value{page}}% pagemarker에 다시 저장
    \pagenumbering{arabic}                        % arabic 페이지번호로 재시작
}

%%
%% \listoftables 재정의 - report 클래스로부터 복사하여 일부 수정
%%
\renewcommand\listoftables{%
    \if@twocolumn
        \@restonecoltrue\onecolumn
    \else
        \@restonecolfalse
    \fi
    \chapter*{\listtablename}%
    \@mkboth{\MakeUppercase\listtablename}{\MakeUppercase\listtablename}%
    \pagenumbering{roman}                         % roman 페이지번호로 복원
    \setcounter{page}{\value{pagemarker}}         % pagemarker에 저장된 값으로
    \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{\listtablename}% 목차(TOC)에 추가
    \@starttoc{lot}%
    \if@restonecol\twocolumn\fi
    \newpage \setcounter{pagemarker}{\value{page}}% pagemarker에 다시 저장
    \pagenumbering{arabic}                        % arabic 페이지번호로 재시작
}

%%
%% \listoffigures 재정의 - report 클래스로부터 복사하여 일부 수정
%%
\renewcommand\listoffigures{%
    \if@twocolumn
        \@restonecoltrue\onecolumn
    \else
        \@restonecolfalse
    \fi
    \chapter*{\listfigurename}%
    \@mkboth{\MakeUppercase\listfigurename}{\MakeUppercase\listfigurename}%
    \pagenumbering{roman}                         % roman 페이지번호로 복원
    \setcounter{page}{\value{pagemarker}}         % pagemarker에 저장된 값으로
    \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{\listfigurename}% 목차(TOC)에 추가
    \@starttoc{lof}%
    \if@restonecol\twocolumn\fi
    \newpage \setcounter{pagemarker}{\value{page}}% pagemarker에 다시 저장
    \pagenumbering{arabic}                        % arabic 페이지번호로 재시작
}

%%
%% 목차에 나오는 형식 - report 클래스로부터 복사하여 일부 수정
%%
\renewcommand*\l@chapter[2]{%
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip 1.0em \@plus\p@
        \if@isKorean                     % <-- 변경 부분
            \setlength\@tempdima{5.0em} % korean  옵션일 때는 5.0em
        \else
            \setlength\@tempdima{1.5em} % english 옵션일 때는 1.5em
        \fi
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \large \sffamily \bfseries
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi}

\if@isKorean % 한글이면 각종 치수를 변경
    \renewcommand*\l@section{\@dottedtocline{1}{2.7em}{2.3em}}
    \renewcommand*\l@subsection{\@dottedtocline{2}{5.0em}{3.2em}}
    \renewcommand*\l@subsubsection{\@dottedtocline{3}{8.2em}{4.1em}}
    \renewcommand*\l@paragraph{\@dottedtocline{4}{11.2em}{5em}}
    \renewcommand*\l@subparagraph{\@dottedtocline{5}{13.2em}{6em}}
\else \fi     % 영문이면 가만히 내버려둠

%%
%% thebibliography 환경 재정의 - report 클래스로부터 복사하여 일부 수정
%%
\renewenvironment{thebibliography}[1]{%
    \chapter*{\bibname}%
    \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
    \if@PDFdoc\phantomsection\fi\addcontentsline{toc}{chapter}{\bibname}%
    \list{\@biblabel{\@arabic\c@enumiv}}%
        {\settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \@openbib@code
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}}%
    \sloppy
    \clubpenalty4000
    \@clubpenalty \clubpenalty
    \widowpenalty4000%
    \sfcode`\.\@m%
}{  \label{paperlastpagelabel}     % <-- 추가 부분: 마지막 페이지 위치 지정
    \def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
    \endlist
}

%%
%% 한국식 날짜 표기 -> 영문식 날짜 표기
%%
\newcommand{\@dateUSenglish}[3]{%  % 미국식 날짜 표기
    \newcommand{\@year}{#1}%
    \newcommand{\@month}{#2}%
    \newcommand{\@day}{#3}%
    \ifcase\@month \or
        January \or February \or March \or April \or May \or June \or
        July \or August \or September \or October \or November \or December \fi
    \@day, \@year
}
\newcommand{\@dateBRenglish}[3]{%  % 영국식 날짜 표기
    \newcommand{\@year}{#1}%
    \newcommand{\@month}{#2}%
    \newcommand{\@day}{#3}%
    \@day\ifcase\@day \or
        st\or nd\or rd\or th\or th\or th\or th\or th\or th\or th\or
        st\or nd\or rd\or th\or th\or th\or th\or th\or th\or th\or
        st\or nd\or rd\or th\or th\or th\or th\or th\or th\or th\or th\fi
    \space\ifcase\@month \or
        January\or February\or March\or April\or May\or June\or
        July\or August\or September\or October\or November\or December\fi,
    \@year
}
