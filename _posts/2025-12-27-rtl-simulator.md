---
layout: single
title: "RTL Simulator"
categories: verilog
---


# RTL Simulator

안녕하세요. 이번 포스팅에서는 RTL Simulator의 내부 동작 원리에 대해 다루어볼까 합니다.

여러분은 Verilog를 배울 때 `<=`는 sequential logic을, `=`은 combinational logic을 작성할 때 사용한다고 배우셨을 것입니다. 사실 학교에서도 교수님들이 Verilog Simulator가 어떻게 동작하는지 설명해주시긴 하지만, 제 경험상 현장 강의에서 이 부분을 제대로 듣거나 이해하는 학생들은 거의 없었던 것 같습니다. 저 또한 그 학생 중 한 명이었습니다.

문제는 이렇게 simulator의 동작 원리를 모르면 실전에서 많은 시간을 낭비하게 된다는 것입니다. 분명 module도 제대로 작성했고 testbench도 잘 작성했다고 생각했는데, waveform과 결과가 예상과 다르게 나오는 경우를 마주하게 됩니다. 이럴 때마다 "왜 안돼?"라며 원인도 모른 채 해매며 귀중한 시간을 소비하게 되죠. 특히 module은 문제가 없는데 testbench에서의 미묘한 실수 때문에 발생한 문제인 경우, 이를 알아챌 수 있는 능력이 없다면 정말 답답한 상황에 빠지게 됩니다.

이번 포스팅은 바로 그런 분들을 위한 것입니다. Simulator가 어떻게 동작하는지 이해한다면, testbench를 작성할 때 흔히 발생하는 실수들을 미연에 방지할 수 있고, 문제가 발생했을 때도 빠르게 원인을 파악할 수 있습니다. 결과적으로 디버깅에 소요되는 시간을 크게 줄여 생산성을 향상시킬 수 있습니다.



[git repo](https://github.com/jeongyoon-kang/RTL.git) 에서 lab3로 들어가시면 아래에서 얘기한 것에 대해 직접 실습하고 결과를 확인하실 수 있습니다.




## Verilog Simulator Event Regions (IEEE 1364 Standard)

Verilog Simulator는 같은 시뮬레이션 시간 (예: 10ns) 내에서도 **여러 단계(Region)**으로 나눠 순차적으로 실행합니다. 이를 ***Delta Cycle*** 이라고 합니다. 

### Event Region 종류와 실행 순서

자 시뮬레이션 시간이 T=10ns 인 상황에 실제로 Simulator는 이 delta만큼의 짧은 시간동안 무엇을 하는지 그리고 그 작업들의 순서를 알아보도록 하겠습니다.

delta cycle 동안 실행되는 작업과 그 순서는 아래와 같습니다.

1. **Active Region (활성 영역)**
   - Blocking 할당(`=`)을 즉시 실행하여 변수 값을 즉시 업데이트
   - Non-blocking 할당(`<=`)의 RHS(우변)를 평가하여 결과를 계산하고, LHS(좌변) 업데이트는 NBA Region으로 예약
   - Continuous assignment(`assign`)를 평가하여 wire 값을 즉시 업데이트
   - 대부분의 Verilog 코드가 이 영역에서 실행됨

2. **Inactive Region (비활성 영역)**
   - `#0` 지연과 같은 명시적 zero-delay 작업을 실행
   - 명시적 지연이 없으면 이 영역은 건너뜀

3. **NBA Region (Non-Blocking Assignment 영역)**
   - Active Region에서 예약된 Non-blocking 할당의 LHS 업데이트를 실제로 수행
   - 이 영역에서 register 값들이 실제로 변경됨
   - Register 값이 변경되면 이에 의존하는 continuous assignment가 다시 평가됨

4. **Monitor Region (모니터 영역)**
   - `$monitor`, `$strobe` 등의 모니터링/디버깅 명령어를 실행
   - 모든 업데이트가 완료된 후 최종 값을 출력


---
**예시1: Blocking vs Non-blocking**

```verilog
// a(2), b(3), c(4) 인 상황
always@(posedge clk)begin
    a = 1;      // (1) Active: LHS인 변수 a에 즉시 1로 업데이트
    b <= a;     // (2) Active: RHS evaluation → NBA에 "b=1" 작업을 스케줄링. 현재 b의 값은 아직 3이다. 
    c <= b;     // (3) Active: RHS evaluation → NBA에 "c=현재 b값(3)" 작업을 스케줄링.
end
```

**T = 10ns 실행과정:**

**Active Region:**
1. `a = 1` 실행 → a는 즉시 1이 됨.
2. `b <= a` 의 RHS 평가 → a를 읽음 (a=1) → "b에 1을 쓰기"라는 작업을 NBA Region에 예약
3. `c <= b` 의 RHS 평가 → b를 읽음 (아직 옛날 값: 3) → "c에 옛날 b값(3) 쓰기"라는 작업을 NBA Region에 예약

**Inactive Region:**
코드에 `#n` 지연이 없으므로 이 영역에서 실행될 작업 없음.

**NBA Region:**
1. b ← 1 업데이트 (Active Region에서 예약한 것)
2. c ← 3 업데이트 (Active Region에서 예약한 이전 b값)

**Monitor Region:**
실행할 monitor 작업 없음.

**최종 결과:**
- a = 1 (Active Region에서 즉시 업데이트)
- b = 1 (NBA Region에서 업데이트)
- c = 3 (NBA Region에서 이전 b값으로 업데이트)

> **핵심:** Non-blocking 할당(`<=`)은 RHS를 현재 시점에 평가하지만, LHS 업데이트는 NBA Region까지 지연됩니다. 따라서 `c <= b`에서 b를 읽을 때는 아직 업데이트 전의 옛날 값(3)을 읽게 됩니다.

---

**예시2: RHS에 연산이 포함된 경우**

```verilog
// a(5), b(10), c(0), d(0) 인 상황
always@(posedge clk)begin
    a = b + 2;      // (1) Blocking: b(10) + 2 = 12를 즉시 a에 할당
    c <= a + b;     // (2) Non-blocking: RHS 평가 → a(12) + b(10) = 22를 NBA에 스케줄링
    d <= a * 2;     // (3) Non-blocking: RHS 평가 → a(12) * 2 = 24를 NBA에 스케줄링
    b = a - 5;      // (4) Blocking: a(12) - 5 = 7을 즉시 b에 할당
end
```

**T = 10ns 실행과정:**

**Active Region:**
1. `a = b + 2` 실행
   - 현재 b값(10)을 읽음 → 10 + 2 = 12 계산
   - a에 즉시 12 할당 (a = 12)

2. `c <= a + b` 의 RHS 평가
   - 현재 a값(12)과 b값(10)을 읽음 → 12 + 10 = 22 계산
   - "c에 22를 쓰기" 작업을 NBA Region에 예약
   - **현재 c는 아직 0**

3. `d <= a * 2` 의 RHS 평가
   - 현재 a값(12)을 읽음 → 12 * 2 = 24 계산
   - "d에 24를 쓰기" 작업을 NBA Region에 예약
   - **현재 d는 아직 0**

4. `b = a - 5` 실행
   - 현재 a값(12)을 읽음 → 12 - 5 = 7 계산
   - b에 즉시 7 할당 (b = 7)

**Inactive Region:**
실행할 작업 없음.

**NBA Region:**
1. c ← 22 업데이트 (Active Region에서 예약한 것)
2. d ← 24 업데이트 (Active Region에서 예약한 것)

**Monitor Region:**
실행할 monitor 작업 없음.

**최종 결과:**
- a = 12 (Active Region에서 즉시 업데이트)
- b = 7 (Active Region에서 즉시 업데이트)
- c = 22 (NBA Region에서 업데이트)
- d = 24 (NBA Region에서 업데이트)

> **핵심:** Non-blocking 할당의 RHS에 연산이 있어도 마찬가지입니다. Active Region에서 **현재 변수 값들을 읽고 즉시 계산**하지만, 그 결과를 LHS에 쓰는 것은 NBA Region까지 미뤄집니다. 따라서 (2)번에서 c에 22를 쓰기로 예약한 후, (3)번에서 d를 계산할 때 c는 여전히 0입니다.

---

**예시3: Continuous Assignment (wire)와 Register의 상호작용**

```verilog
// Combinational logic (wire)
wire [7:0] sum;
wire [7:0] product;
assign sum = a + b;
assign product = a * 2;

// Sequential logic (register)
reg [7:0] a, b, c, d;
// a(5), b(10), c(0), d(0) 인 상황
always@(posedge clk) begin
    a <= 3;           // (1) Non-blocking: "a에 3 쓰기"를 NBA에 스케줄링
    b <= 7;           // (2) Non-blocking: "b에 7 쓰기"를 NBA에 스케줄링
    c <= sum;         // (3) Non-blocking: sum을 읽어서 "c에 sum값 쓰기"를 NBA에 스케줄링
    d <= product;     // (4) Non-blocking: product를 읽어서 "d에 product값 쓰기"를 NBA에 스케줄링
end
```

**T = 10ns 실행과정:**

**Active Region:**
1. `a <= 3` 의 RHS 평가
   - "a에 3을 쓰기" 작업을 NBA Region에 예약
   - **현재 a는 아직 5**

2. `b <= 7` 의 RHS 평가
   - "b에 7을 쓰기" 작업을 NBA Region에 예약
   - **현재 b는 아직 10**

3. `assign sum = a + b` 평가 (continuous assignment)
   - 현재 a(5) + b(10) = 15
   - **sum은 즉시 15가 됨**

4. `assign product = a * 2` 평가 (continuous assignment)
   - 현재 a(5) * 2 = 10
   - **product는 즉시 10이 됨**

5. `c <= sum` 의 RHS 평가
   - 현재 sum값(15)을 읽음
   - "c에 15를 쓰기" 작업을 NBA Region에 예약
   - **현재 c는 아직 0**

6. `d <= product` 의 RHS 평가
   - 현재 product값(10)을 읽음
   - "d에 10을 쓰기" 작업을 NBA Region에 예약
   - **현재 d는 아직 0**

**Inactive Region:**
실행할 작업 없음.

**NBA Region:**
1. a ← 3 업데이트
2. b ← 7 업데이트
3. c ← 15 업데이트
4. d ← 10 업데이트

이제 a와 b가 변경되었으므로, **continuous assignment가 다시 평가됨**:
- `sum = a(3) + b(7) = 10` (sum 업데이트)
- `product = a(3) * 2 = 6` (product 업데이트)

**Monitor Region:**
실행할 monitor 작업 없음.

**최종 결과:**
- a = 3 (NBA Region에서 업데이트)
- b = 7 (NBA Region에서 업데이트)
- c = 15 (NBA Region에서 업데이트, **이전 sum값**)
- d = 10 (NBA Region에서 업데이트, **이전 product값**)
- sum = 10 (NBA Region에서 a, b 변경 후 재평가)
- product = 6 (NBA Region에서 a 변경 후 재평가)

> **핵심:** Wire의 continuous assignment는 입력(a, b)이 변할 때마다 즉시 재평가됩니다. 하지만 `c <= sum`에서 sum을 읽는 시점은 Active Region이므로, **a와 b가 아직 업데이트되기 전의 옛날 sum값(15)**을 읽게 됩니다. a와 b가 NBA Region에서 업데이트된 후 sum이 10으로 변경되지만, c에는 이미 15가 쓰여질 예정이므로 이 변경사항이 반영되지 않습니다. 이것이 바로 register가 wire 값을 **한 클럭 전의 값으로 capture**하는 이유입니다.

---

## Race Condition (경쟁 상태)

IEEE 1364 표준에서 정의한 Delta Cycle을 이해했다면, 이제 **왜 Blocking 할당을 사용하면 Race Condition이 발생하는지** 알아보겠습니다.

### 문제 상황: 여러 Always 블록에서 같은 변수 사용

```verilog
// 초기값: a=0, b=1
// 두 개의 separate always 블록
always @(posedge clk) begin
    a = b;
end

always @(posedge clk) begin
    b = a;
end
```

### Race Condition 발생 원인

두 always 블록 모두 같은 `posedge clk`에 트리거되어 **같은 Active Region**에 들어갑니다.

**IEEE 1364 표준의 핵심 문제:**
> Active Region 내에서 **여러 always 블록의 실행 순서는 정의되어 있지 않습니다 (undefined)**. 시뮬레이터마다, 실행마다 순서가 달라질 수 있습니다.

따라서 Blocking 할당(`=`)을 사용하면 실행 순서에 따라 결과가 달라지는 **비결정적(non-deterministic) 동작**이 발생합니다:

**Case 1: 첫 번째 블록을 먼저 실행하는 경우**
```
Active Region:
1. a = b  →  a = 1 (즉시 반영)
2. b = a  →  b = 1 (업데이트된 a값 읽음)

최종 결과: a = 1, b = 1
```

**Case 2: 두 번째 블록을 먼저 실행하는 경우**
```
Active Region:
1. b = a  →  b = 0 (즉시 반영)
2. a = b  →  a = 0 (업데이트된 b값 읽음)

최종 결과: a = 0, b = 0
```

> **문제의 본질:** 같은 코드, 같은 입력인데도 **실행 순서에 따라 결과가 달라집니다**. 이것이 바로 Race Condition입니다.

### 해결책: Non-blocking 할당 사용

```verilog
// 초기값: a=0, b=1
always @(posedge clk) begin
    a <= b;
end

always @(posedge clk) begin
    b <= a;
end
```

**Non-blocking 할당으로 수정한 경우:**

```
Active Region (실행 순서 무관):
- a <= b의 RHS 평가: 현재 b값(1)을 읽어서 NBA Region에 "a에 1 쓰기" 예약
- b <= a의 RHS 평가: 현재 a값(0)을 읽어서 NBA Region에 "b에 0 쓰기" 예약

NBA Region:
- a ← 1 업데이트
- b ← 0 업데이트

최종 결과: a = 1, b = 0 (실행 순서와 무관하게 항상 동일)
```

> **핵심:** Non-blocking 할당(`<=`)은 Active Region에서 RHS를 평가할 때 **현재 값(업데이트 전 값)**을 읽고, LHS 업데이트는 NBA Region에서 수행하므로, **always 블록의 실행 순서와 무관하게 결과가 일정**합니다. 이것이 Sequential logic을 작성할 때 Non-blocking 할당을 사용해야 하는 이유입니다.

### IEEE 1364 표준의 권고사항

IEEE 1364 표준은 다음과 같이 권고합니다:

1. **Sequential logic (always @(posedge clk))**: Non-blocking 할당(`<=`) 사용
2. **Combinational logic (always @(*))**: Blocking 할당(`=`) 사용
3. **같은 변수에 대해 여러 always 블록에서 할당 금지**

이 규칙을 따르면 Race Condition을 방지하고 예측 가능한(deterministic) 시뮬레이션 결과를 얻을 수 있습니다.


