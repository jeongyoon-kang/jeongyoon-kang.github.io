---
layout: single
title: "RTL Simulator의 동작 원리"
categories: verilog
---

# RTL Simulator의 동작 원리

안녕하세요. 이번 포스팅에서는 RTL Simulator의 내부 동작 원리에 대해 다루어볼까 합니다.

Verilog를 배울 때 "sequential logic은 `<=`, combinational logic은 `=`을 사용하라"고 배우셨을 겁니다. 사실 학교에서도 왜 그런지 설명해주시긴 하지만, 내용이 어렵다 보니 주입식 교육에 익숙한 방식대로 그냥 받아들이고 넘어가는 경우가 많습니다. 저 또한 그랬습니다.

문제는 이 원리를 제대로 이해하지 못하면 실전에서 많은 시간을 낭비하게 된다는 것입니다. 분명 RTL 코드를 제대로 작성했다고 생각했는데 waveform이 예상과 다르게 나오는 경우를 마주하게 됩니다. 이럴 때 simulator의 동작 원리를 알고 있다면 빠르게 원인을 파악할 수 있지만, 그렇지 않다면 원인도 모른 채 시간을 소비하게 됩니다.

이번 포스팅에서는 simulator가 어떻게 동작하는지, 그리고 **왜 sequential logic은 `<=`를, combinational logic은 `=`를 사용해야 하는지** 원론적으로 다뤄보겠습니다.

---

## 1. Verilog Simulator의 동작 원리 (Delta Cycle)

Verilog Simulator는 같은 시뮬레이션 시간(예: 10ns) 내에서도 **여러 단계(Region)**로 나눠 순차적으로 실행합니다. 이를 **Delta Cycle**이라고 합니다.

### Event Region 종류와 실행 순서

시뮬레이션 시간 T=10ns인 상황에서, simulator는 delta cycle 동안 다음 순서로 작업을 수행합니다:

1. **Active Region (활성 영역)**
   - Blocking 할당(`=`)을 즉시 실행하여 변수 값을 즉시 업데이트
   - Non-blocking 할당(`<=`)의 RHS(우변)를 평가하고, LHS(좌변) 업데이트는 NBA Region으로 예약
   - Continuous assignment(`assign`)를 평가하여 wire 값을 즉시 업데이트
   - **중요**: 같은 블록 내에서는 위→아래 순서로 실행
   - **중요**: 서로 다른 always/initial 블록 간의 실행 순서는 **정의되어 있지 않음 (undefined)**

2. **Inactive Region (비활성 영역)**
   - `#0` 지연과 같은 명시적 zero-delay 작업을 실행

3. **NBA Region (Non-Blocking Assignment 영역)**
   - Active Region에서 예약된 Non-blocking 할당의 LHS 업데이트를 실제로 수행
   - 이 영역에서 register 값들이 실제로 변경됨

4. **Monitor Region (모니터 영역)**
   - `$monitor`, `$strobe` 등의 모니터링/디버깅 명령어를 실행
   - 모든 업데이트가 완료된 후 최종 값을 출력

---

### 예시 1: Blocking vs Non-blocking 기본 동작

```verilog
// 초기값: a=2, b=3, c=4
always @(posedge clk) begin
    a = 1;      // (1) Blocking: a에 즉시 1 할당
    b <= a;     // (2) Non-blocking: RHS 평가(a=1) → NBA에 "b=1" 예약
    c <= b;     // (3) Non-blocking: RHS 평가(b=3) → NBA에 "c=3" 예약
end
```

**T = 10ns 실행 과정:**

| Region | 실행 내용 | 변수 상태 |
|--------|----------|----------|
| Active | `a = 1` 즉시 실행 | a=1, b=3, c=4 |
| Active | `b <= a` RHS 평가 → NBA에 "b←1" 예약 | a=1, b=3, c=4 |
| Active | `c <= b` RHS 평가 → NBA에 "c←3" 예약 | a=1, b=3, c=4 |
| NBA | b ← 1 업데이트 | a=1, b=1, c=4 |
| NBA | c ← 3 업데이트 | a=1, b=1, c=3 |

**최종 결과: a=1, b=1, c=3**

> **핵심**: Non-blocking 할당(`<=`)은 RHS를 **현재 시점**에 평가하지만, LHS 업데이트는 **NBA Region까지 지연**됩니다. 따라서 `c <= b`에서 b를 읽을 때는 아직 업데이트 전의 값(3)을 읽게 됩니다.

---

### 예시 2: RHS에 연산이 포함된 경우

```verilog
// 초기값: a=5, b=10, c=0, d=0
always @(posedge clk) begin
    a = b + 2;      // (1) Blocking: 10+2=12를 즉시 a에 할당
    c <= a + b;     // (2) Non-blocking: 12+10=22를 NBA에 예약
    d <= a * 2;     // (3) Non-blocking: 12*2=24를 NBA에 예약
    b = a - 5;      // (4) Blocking: 12-5=7을 즉시 b에 할당
end
```

**실행 과정:**

| Region | 실행 내용 | 변수 상태 |
|--------|----------|----------|
| Active | `a = b + 2` → a=12 | a=12, b=10, c=0, d=0 |
| Active | `c <= a + b` → NBA에 "c←22" 예약 | a=12, b=10, c=0, d=0 |
| Active | `d <= a * 2` → NBA에 "d←24" 예약 | a=12, b=10, c=0, d=0 |
| Active | `b = a - 5` → b=7 | a=12, b=7, c=0, d=0 |
| NBA | c ← 22, d ← 24 업데이트 | a=12, b=7, c=22, d=24 |

**최종 결과: a=12, b=7, c=22, d=24**

> **핵심**: Non-blocking의 RHS에 연산이 있어도 마찬가지입니다. Active Region에서 **현재 변수 값들을 읽고 즉시 계산**하지만, 결과를 LHS에 쓰는 것은 NBA Region에서 수행됩니다.

---

### 예시 3: Wire(Continuous Assignment)와 Register의 상호작용

```verilog
// Combinational logic (wire)
wire [7:0] sum;
wire [7:0] product;
assign sum = a + b;
assign product = a * 2;

// Sequential logic (register)
reg [7:0] a, b, c, d;
// 초기값: a=5, b=10, c=0, d=0

always @(posedge clk) begin
    a <= 3;           // (1) NBA에 "a←3" 예약
    b <= 7;           // (2) NBA에 "b←7" 예약
    c <= sum;         // (3) sum(=15) 읽어서 NBA에 "c←15" 예약
    d <= product;     // (4) product(=10) 읽어서 NBA에 "d←10" 예약
end
```

**실행 과정:**

| Region | 실행 내용 |
|--------|----------|
| Active | `a <= 3` RHS 평가 → NBA에 예약 (a는 아직 5) |
| Active | `b <= 7` RHS 평가 → NBA에 예약 (b는 아직 10) |
| Active | `assign sum = a + b` → sum = 5+10 = 15 |
| Active | `assign product = a * 2` → product = 5*2 = 10 |
| Active | `c <= sum` → sum(15) 읽어서 NBA에 "c←15" 예약 |
| Active | `d <= product` → product(10) 읽어서 NBA에 "d←10" 예약 |
| NBA | a←3, b←7, c←15, d←10 업데이트 |
| NBA | a, b 변경으로 sum=10, product=6 재계산 |

**최종 결과:**
- a=3, b=7, c=15, d=10
- sum=10, product=6 (NBA 이후 재계산된 값)

> **핵심**: `c <= sum`에서 sum을 읽는 시점은 Active Region이므로, **a와 b가 업데이트되기 전의 sum 값(15)**을 읽습니다. 이것이 register가 wire 값을 **한 클럭 전의 값으로 capture**하는 이유입니다.

---

## 2. Sequential Logic에서 Non-blocking(`<=`)을 써야 하는 이유

### 실제 하드웨어의 동작

실제 하드웨어에서 Flip-Flop들은 클럭 엣지가 발생하면 **모두 동시에** 입력을 샘플링합니다. 어떤 FF가 먼저 동작하고 다른 FF가 나중에 동작하는 것이 아닙니다.

```
        ┌─────┐         ┌─────┐
   A ──►│ FF1 ├──► B ──►│ FF2 ├──► C
        └──┬──┘         └──┬──┘
           │               │
    clk ───┴───────────────┘
           ↑
      동시에 샘플링
```

클럭 엣지 순간:
- FF1은 A의 **현재 값**을 샘플링하여 B로 출력
- FF2는 B의 **현재 값**(FF1이 업데이트하기 전의 값)을 샘플링하여 C로 출력

### 문제: Blocking 할당 사용 시 Race Condition

```verilog
// 초기값: a=0, b=1
always @(posedge clk) begin
    a = b;
end

always @(posedge clk) begin
    b = a;
end
```

두 always 블록 모두 같은 `posedge clk`에 트리거되어 **같은 Active Region**에서 실행됩니다.

**IEEE 1364 표준의 핵심 문제:**
> Active Region 내에서 **여러 always 블록의 실행 순서는 정의되어 있지 않습니다 (undefined)**.

**Case 1: 첫 번째 블록이 먼저 실행**
```
a = b  →  a = 1
b = a  →  b = 1 (업데이트된 a 값 읽음)
최종: a=1, b=1
```

**Case 2: 두 번째 블록이 먼저 실행**
```
b = a  →  b = 0
a = b  →  a = 0 (업데이트된 b 값 읽음)
최종: a=0, b=0
```

> **같은 코드, 같은 입력인데 실행 순서에 따라 결과가 달라집니다.** 이것이 Race Condition입니다.

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

**실행 과정 (순서 무관):**

| Region | 실행 내용 |
|--------|----------|
| Active | `a <= b` RHS 평가 → b(=1) 읽음 → NBA에 "a←1" 예약 |
| Active | `b <= a` RHS 평가 → a(=0) 읽음 → NBA에 "b←0" 예약 |
| NBA | a ← 1 업데이트 |
| NBA | b ← 0 업데이트 |

**최종 결과: a=1, b=0 (실행 순서와 무관하게 항상 동일)**

> **핵심**: Non-blocking 할당은 Active Region에서 RHS를 평가할 때 **현재 값(업데이트 전 값)**을 읽고, LHS 업데이트는 NBA Region에서 수행합니다. 따라서 **always 블록의 실행 순서와 무관하게 결과가 일정**합니다. 이것이 실제 하드웨어의 "동시 샘플링" 동작을 정확히 재현합니다.

---

## 3. Combinational Logic에서 Blocking(`=`)을 써야 하는 이유

### 실제 하드웨어의 동작

조합논리 회로에서 신호는 게이트를 **순차적으로 통과**하며 전파됩니다.

```
        ┌─────┐      ┌─────┐
   A ──►│     │      │     │
        │ AND ├──►X──│ OR  ├──► Y
   B ──►│     │      │     │
        └─────┘  C──►│     │
                     └─────┘

실제 동작: A,B → X 계산 → X,C → Y 계산 (순차적 전파)
```

### Blocking 할당이 적합한 이유

```verilog
// Combinational logic
always @(*) begin
    x = a & b;      // (1) x를 먼저 계산
    y = x | c;      // (2) x의 결과를 사용하여 y 계산
end
```

Blocking 할당을 사용하면:
1. `x = a & b` 실행 → x가 즉시 업데이트됨
2. `y = x | c` 실행 → 업데이트된 x 값을 사용하여 y 계산

이는 실제 하드웨어에서 신호가 순차적으로 전파되는 동작과 일치합니다.

### Non-blocking 사용 시 문제점

```verilog
// 잘못된 예시: Combinational logic에 non-blocking 사용
always @(*) begin
    x <= a & b;     // (1) NBA에 "x ← a&b" 예약
    y <= x | c;     // (2) x의 **이전 값**을 읽어서 NBA에 예약
end
```

Non-blocking을 사용하면:
1. `x <= a & b` → x의 업데이트를 NBA에 예약 (x는 아직 이전 값)
2. `y <= x | c` → **이전 x 값**을 읽어서 y 계산

결과적으로 y는 **한 delta cycle 전의 x 값**을 기반으로 계산되어, 의도치 않은 동작이 발생합니다.

---

## 4. 정리

| 회로 유형 | 하드웨어 특성 | Simulator에서 재현하려면 | 사용할 할당 |
|-----------|--------------|------------------------|------------|
| Sequential Logic | 모든 FF가 클럭 엣지에 **동시에** 샘플링 | 실행 순서와 무관하게 "현재 값"을 읽어야 함 | `<=` (non-blocking) |
| Combinational Logic | 신호가 게이트를 **순차적으로** 통과 | 위→아래 순서대로 즉시 반영되어야 함 | `=` (blocking) |

### IEEE 1364 표준의 권고사항

1. **Sequential logic (`always @(posedge clk)`)**: Non-blocking 할당(`<=`) 사용
2. **Combinational logic (`always @(*)`)**: Blocking 할당(`=`) 사용
3. **같은 변수에 대해 여러 always 블록에서 할당 금지**

이 규칙을 따르면 Race Condition을 방지하고 예측 가능한(deterministic) 시뮬레이션 결과를 얻을 수 있습니다.

---

## 다음 글 예고

이번 글에서는 RTL 설계 시 blocking과 non-blocking을 구분해야 하는 이유를 다뤘습니다. 다음 글에서는 **Testbench 작성 시 발생하는 Race Condition**에 대해 다루겠습니다. Testbench의 initial 블록과 DUT의 always 블록 간에도 실행 순서가 undefined이기 때문에, 신호를 어떻게 drive하느냐에 따라 예상치 못한 결과가 발생할 수 있습니다.

[다음 글: Testbench에서의 Race Condition](/verilog/rtl-simulator2)

---