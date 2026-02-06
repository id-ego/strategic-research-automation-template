# Sprint 06: 화이트라벨 솔루션 - 마케팅 에이전시 B2B2C 전략

## Opportunity Title
**화이트라벨 솔루션: 마케팅 에이전시 대상 B2B2C 전략으로 확장**

## Executive Summary
ANAKONN의 Ankk는 현재 B2C(소상공인 직접 판매) 모델이지만, 마케팅 에이전시 대상 B2B2C 모델로 확장하면 훨씬 빠른 성장과 높은 ARR을 달성할 수 있습니다. 한국에는 수천 개의 마케팅 에이전시, 광고 대행사, 웹 에이전시가 있으며, 이들은 다수의 소상공인 클라이언트를 관리합니다. Ankk를 화이트라벨 솔루션으로 제공하면, 에이전시가 자사 브랜드로 서비스를 재판매할 수 있고, Ankk는 에이전시당 수십~수백 개의 최종 고객을 한 번에 확보할 수 있습니다.

## Business Value

### Market Opportunity
- **타겟 시장**: 한국의 마케팅 에이전시, 광고 대행사, 웹 에이전시 (약 5,000~10,000개)
- **Pain Point**: 에이전시는 여러 클라이언트의 SNS/이메일 마케팅을 수동으로 관리, 효율성 낮음
- **Solution**: 에이전시가 Ankk를 자사 브랜드로 재판매 → 클라이언트 관리 자동화 + 추가 매출원
- **Leverage**: 에이전시 1개 = 평균 20~100개 최종 고객 (빠른 확산)

### Revenue Potential
- **B2B2C 모델**: 에이전시에 월 구독료 + 최종 고객당 추가 요금
- **Pricing**:
  - 에이전시 기본료: 월 100만원 (최대 50개 클라이언트)
  - 추가 클라이언트: 개당 월 2만원
- **Target**:
  - Year 1: 50개 에이전시 × 월 100만원 × 12개월 = 6억원
  - Year 2: 200개 에이전시 × 월 150만원 × 12개월 = 36억원
  - Year 3: 500개 에이전시 × 월 200만원 × 12개월 = 120억원

### Competitive Advantage
- **한국 시장 특화**: 네이버/카카오 통합으로 글로벌 도구 대비 우위
- **All-in-One**: 콘텐츠 생성 + 발행 + 분석 + CRM을 단일 플랫폼에서 제공
- **화이트라벨**: 에이전시가 자사 브랜드로 재판매 가능

## Technical Feasibility

### Current Capabilities
- 멀티채널 콘텐츠 생성 및 발행
- AI 콘텐츠 생성
- 성과 분석 기능

### Required Enhancements

#### 1. 멀티테넌시 아키텍처 (Multi-Tenancy)
- **기능**:
  - 에이전시 계정: 여러 클라이언트 관리
  - 클라이언트 계정: 각 클라이언트의 데이터 격리
  - 권한 관리: 에이전시 관리자, 팀원, 클라이언트 역할 분리
- **기술 스택**:
  - Database: 논리적 격리 (Tenant ID) 또는 물리적 격리 (Database per Tenant)
  - Auth: Auth0, AWS Cognito (멀티테넌트 지원)

#### 2. 화이트라벨 브랜딩
- **기능**:
  - 에이전시가 로고, 색상, 도메인을 커스터마이징
  - 예: agency-a.com, agency-b.com (각각 독립적인 브랜딩)
  - 이메일, 알림, 대시보드에 에이전시 브랜드 적용
- **기술 스택**:
  - Frontend: 동적 테마 (CSS Variables, Styled Components)
  - Domain: CNAME 설정, SSL 인증서 자동 발급 (Let's Encrypt)

#### 3. 통합 대시보드 (Agency Dashboard)
- **기능**:
  - 에이전시가 모든 클라이언트의 성과를 한눈에 조회
  - 클라이언트별 월별 리포트 자동 생성
  - 비용 청구 자동화 (클라이언트당 사용량 추적)
- **기술 스택**:
  - Dashboard: React, Chart.js
  - Billing: Stripe, 또는 자체 빌링 시스템

#### 4. API 제공
- **기능**:
  - 에이전시가 자체 시스템과 Ankk를 연동
  - 예: 에이전시의 CRM → Ankk API → 콘텐츠 자동 발행
- **기술 스택**:
  - REST API, GraphQL
  - API Documentation: Swagger, Redoc

#### 5. 리셀러 프로그램
- **기능**:
  - 에이전시가 최종 고객에게 재판매 시 마진 설정
  - 예: Ankk 원가 월 10만원 → 에이전시가 월 15만원에 재판매 → 5만원 마진
- **구현**:
  - 리셀러 포털 (에이전시 전용 관리 페이지)
  - 자동 청구 및 정산

### Technology Stack
- **Backend**: 기존 Ankk 아키텍처에 멀티테넌시 추가
- **Database**: PostgreSQL (Tenant ID 기반 격리)
- **Auth**: Auth0, AWS Cognito
- **Frontend**: React (동적 테마)
- **Billing**: Stripe, Chargebee
- **API**: REST API, GraphQL

### Development Complexity
- **난이도**: Medium-High
- **예상 기간**: 5-8개월
- **리스크**: 멀티테넌시 보안 이슈, 데이터 격리 실패

## Market Potential

### Target Segments
1. **마케팅 에이전시**: 소상공인 대상 마케팅 대행사 (3,000~5,000개)
2. **광고 대행사**: 디지털 광고 중심 대행사 (1,000~2,000개)
3. **웹 에이전시**: 웹사이트 제작 + 마케팅 패키지 제공 (2,000~3,000개)

### Market Trends 2026
- **에이전시 디지털 전환**: 수동 관리 → 자동화 도구 도입 증가
- **클라이언트 수 증가**: 에이전시당 평균 클라이언트 수 증가 (효율성 필수)
- **화이트라벨 수요**: 에이전시가 자사 브랜드로 서비스 제공하려는 니즈 증가

### Competitive Landscape
- **글로벌 도구**: Hootsuite, Buffer (화이트라벨 제공, 가격 높음)
- **한국 솔루션**: 대부분 화이트라벨 미제공 또는 기능 제한적
- **Ankk 차별화**: 한국 시장 특화 + 저가격 + 네이버/카카오 통합 + 화이트라벨

## Strategic Importance

### Why Now?
1. **B2C 한계**: 소상공인 직접 판매는 CAC 높고 확산 느림
2. **B2B2C 레버리지**: 에이전시 1개 = 수십~수백 개 최종 고객
3. **에이전시 니즈**: 마케팅 에이전시도 자동화 도구 필요성 증가
4. **정부 지원**: 소상공인 디지털 전환 지원사업에 에이전시 참여 가능

### Alignment with Company Goals
- **빠른 확산**: B2B2C 모델로 고객 확보 속도 10배 증가
- **ARR 증가**: 에이전시당 월 100만원 이상, LTV 높음
- **브랜드 인지도**: 에이전시를 통한 간접 브랜드 노출

## Go-to-Market Strategy

### Phase 1: 멀티테넌시 개발 (3-5개월)
- 멀티테넌트 아키텍처 구축
- 에이전시 대시보드 MVP
- 베타 테스트 (에이전시 5개)

### Phase 2: 화이트라벨 출시 (6-8개월)
- 화이트라벨 브랜딩 기능
- API 제공
- 리셀러 프로그램 오픈

### Phase 3: 확산 (9-12개월)
- 에이전시 파트너십 확대 (50개 → 200개)
- 케이스 스터디 및 마케팅
- 엔터프라이즈 플랜 (대형 에이전시 대상)

## Key Metrics

### Success Criteria
- **에이전시 확보**: Year 1에 50개 에이전시 파트너십
- **최종 고객 확보**: 에이전시당 평균 30개 최종 고객
- **ARR 성장**: Year 1에 6억원, Year 2에 36억원
- **Retention**: 에이전시 이탈률 5% 이하

### Financial Projections
- **Year 1**: 50개 에이전시 × 월 100만원 × 12개월 = 6억원
- **Year 2**: 200개 에이전시 × 월 150만원 × 12개월 = 36억원
- **Year 3**: 500개 에이전시 × 월 200만원 × 12개월 = 120억원

## Risks and Mitigation

### Key Risks
1. **멀티테넌시 보안**: 데이터 격리 실패 시 치명적
2. **에이전시 확보**: 초기 에이전시 확보가 어려울 수 있음
3. **경쟁 심화**: 글로벌 도구(Hootsuite)도 한국 시장 진입 가능성

### Mitigation Strategies
- **보안 강화**: 데이터 격리 철저, 정기 보안 감사
- **파트너십 전략**: 초기 에이전시에 무료/할인 제공, 케이스 스터디 제작
- **차별화 강화**: 네이버/카카오 통합, 한국어 지원, 저가격

## References
1. [국내 CRM 솔루션 및 마케팅 에이전시 동향](https://salesmap.kr/blog/top-7-crm-2024-korea)
2. [화이트라벨 마케팅 자동화 사례](https://www.cio.com/article/3531451/sns%EC%99%80-%ED%86%B5%ED%95%A9%ED%95%98%EB%A9%B4-%EC%8B%9C%EB%84%88%EC%A7%80-%EC%97%85-%EC%9D%B4%EB%A9%94%EC%9D%BC-%EB%A7%88%EC%BC%80%ED%8C%85-sw-14%EC%84%A0.html)
3. [B2B2C 비즈니스 모델](https://www.gttkorea.com/news/articleView.html?idxno=22311)
4. [2026년 소상공인 지원사업 (에이전시 참여 가능)](https://www.mss.go.kr/site/smba/ex/bbs/View.do?cbIdx=86&bcIdx=1064370&parentSeq=1064370)
