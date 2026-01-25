---
layout: single
title: "AMBA - skid buffer"
categories: amba
---


# Skid buffer

안녕하세요. 이번 포스팅은 [AMBA - Handshake2](/amba/rtl-handshake2)에 이어서 skid buffer에 대해 다루겠습니다.
지난 포스팅에서 valid/ready handshake interface에 대해 살펴보았는데요, 그 때 ready 신호쪽에는 따로 register로 끊어지는 부분이 없고 combinational logic으로만 전파되는 구조였습니다. 이렇게 valid/ready interface module을 여러 개 붙이게 되면, 연결된 module 수에 비례해서 combinational logic delay가 누적될 것입니다. 연산기나 제어 module에서는 pipelining 기법이나 register 삽입을 통해 critial path를 열심히 최적화해서 fmax를 높여왔지만, 정작 ready 신호 때문에 fmax에 병목이 생길 수 있습니다. 그래서 ready 신호의 combinational logic delay를 적어도 한번은 끊어준다면 이런 상황은 피할 수 있습니다. 물론 매 module마다 skid buffer를 넣게 되면 전체 회로의 latency가 높아지기 때문에 적절히 어디에 어떻게 삽입할지는 설계할 때 고려하셔야 합니다. 하지만 그 때 가서 이런 module의 필요성을 느끼고 만들려고 시도하면 생각보다 잘 되지 않을 수 있습니다. 따라서 이런 상황을 대비해서 미리 module을 하나 설계해두고 가는 것도 좋은 선택이 될 수 있습니다.

## 일반적인 Critical Path 해결 방법

회로 설계에서 timing closure를 위해 critical path를 끊어내는 것은 매우 중요합니다. 일반적으로 combinational logic이 길어지면 clock frequency를 높이기 어려워지고, 이를 해결하기 위해 중간에 Register(F/F)를 삽입하여 path를 나누게 됩니다. 이에 대한 예시는 아래와 같은 그림처럼 될 것입니다.

![alt text](/assets/images/2026-01-24-skid-buffer/valid_module_schmetic.png)

입력에 대해 8승을 구하는 모듈인데 multiply logic을 단순히 cascading 해주면 combinational logic delay가 길어질 것이고 fmax는 낮아질 것입니다.
이를 3개의 단계로 나눠서 각 단계별로 제곱을 구하고 이 값이 유효하다는 valid 신호도 이에 맞게 register를 심어주면 됩니다.

위 그림처럼 단순한 data path의 경우, 중간에 register를 삽입하면 간단하게 critical path를 끊어낼 수 있습니다. 입력 데이터가 들어오면 한 clock cycle 후에 register를 거쳐 출력으로 나가게 됩니다. latency가 1 cycle 증가하지만 timing은 개선됩니다.

## Valid/Ready Interface에서의 문제점

하지만 valid/ready interface에서는 상황이 달라집니다. 단순히 data path에 register를 삽입하는 것만으로는 해결되지 않는 문제가 있습니다.

Valid와 Data는 producer module(upstream)에서 consumer module(downstream) 방향으로 이어집니다.<br>하지만 Ready신호는 consumer module에서 producer module 방향으로 이어집니다.

그렇다면 단순히 ready path 사이에 register를 삽입하면 어떻게 될까요?

![alt text](/assets/images/2026-01-24-skid-buffer/wrong_skid.png)

위 그림에 대한 timing diagram을 보면서 이해해봅시다.

![alt text](/assets/images/2026-01-24-skid-buffer/wrong_skidbuffer_timing_diagram.png)

위 그림에서 consumer가 4cycle 동안 read 신호를 assert하였습니다. producer에서 data를 계속 밀고 들어오는 상황이라면 4clcye 동안 4개의 data를 빼줄 수 있어야합니다. consumer에서 assert한 4cycle은 producer로 전달되기까지 1cycle latency가 존재합니다. producer에 도착하기 이전에 이미 consumer는 main module에서 데이터를 가져가고 있습니다. 따라서 producer가 데이터를 밀기도 전에 consumer는 이미 main module에서 D1을 2번 읽어버립니다. 그리고 producer에서 밀어준 D4 데이터는 main module에서 capture하지 못하게 됩니다. 

이러한 문제로 인해 원래 동작과 틀어지는 결과를 만들게 됩니다. 
>1. Consumer에서는 같은 데이터를 2번 처리하는 결과
>2. Producer에서 밀고 들어오는 데이터를 놓치는 결과

위 2가지 문제를 제거하기 위해 skid buffer를 설계하는 것은 매우 중요합니다.

이름의 유래는 다음과 같습니다. <br>
 **"미끄러져 나온" 데이터**를 임시로 저장하는 것이 skid buffer입니다. "Skid"라는 이름이 붙은 이유도 여기서 유래합니다 - backpressure가 전파되기 전에 미끄러져 나온(skid) 데이터를 잡아두는 버퍼인 것입니다.

### Skid Buffer의 동작 원리

Skid buffer의 핵심 아이디어는 간단합니다. Ready 신호가 deassert되었을 때, 이미 전송 중인 데이터를 임시로 저장할 수 있는 별도의 버퍼(skid register)를 두는 것입니다.

#### 기본 구조

Skid buffer는 다음과 같은 구성요소를 가집니다:

1. **Main Register**: 일반적인 데이터 전달 경로에 있는 레지스터
2. **Skid Register**: 백프레셔 발생 시 "미끄러져 나온" 데이터를 임시 저장하는 레지스터
3. **MUX**: Skid register와 입력 데이터 중 하나를 선택
4. **Control Logic**: 어떤 레지스터를 사용할지 결정하는 FSM

#### 동작 시나리오

**Case 1: 정상 동작 (Consumer ready = 1)**

Consumer가 데이터를 받을 준비가 되어 있으면, 데이터는 main register를 통해 바로 전달됩니다. Skid register는 사용되지 않습니다.

```
producer_data → Main Register → consumer_data
                (skid register 비어있음)
```

**Case 2: Backpressure 발생 (consumer ready: 1→0)**

Consumer이 갑자기 ready를 deassert하면, 이미 valid로 전송 중이던 데이터가 있을 수 있습니다. 이 데이터를 skid register에 저장합니다.

```
producer_data → Skid Register (저장!)
                Main Register → consumer (대기 중)
```

이때 중요한 점은 **producer에게 보내는 ready 신호는 1 cycle 뒤에 deassert**된다는 것입니다. 이 1 cycle 동안 들어온 데이터가 바로 "skid"된 데이터이고, 이를 skid register가 잡아둡니다.

**Case 3: Backpressure 해제 (consumer ready: 0→1)**

Downstream이 다시 ready를 assert하면, 먼저 skid register에 저장된 데이터를 내보냅니다. Skid register가 비워진 후에야 새로운 producer 데이터를 받을 수 있습니다.

```
Skid Register → Main Register → consumer_data (skid 데이터 먼저!)
procuder_data (잠시 대기)
```

#### 핵심 포인트

1. **Ready 신호의 등록(Registering)**: Downstream의 ready 신호가 upstream으로 전달될 때 1 cycle 지연됩니다. 이것이 critical path를 끊어주는 핵심입니다.

2. **데이터 손실 방지**: Ready가 늦게 전파되는 1 cycle 동안 들어온 데이터를 skid register가 보관하므로 데이터 손실이 없습니다.

3. **중복 처리 방지**: Skid register에 유효한 데이터가 있으면 해당 데이터를 먼저 처리하므로, consumer이 같은 데이터를 두 번 읽는 일이 없습니다.

4. **Throughput 유지**: Backpressure가 없는 정상 상황에서는 매 cycle 데이터 전송이 가능합니다 (throughput = 1).


그럼 제일 처음 그림에서 valid, data를 받아줄 register, ready 신호를 끊어줄 register을 추가로 삽입해줘야할 것입니다. 그리고 skid buffer의 상태를 나타내는 Status register도 사용해줍시다. 물론 Status Register가 꼭 필요한건 아니지만, 연습하는 느낌으로 추가해줍시다.

설계하면 아래와 같이 skid buffer가 완성됩니다. 이런 설계도를 보고 Verilog로 module을 만드는건 일도 아닐 것입니다. 하지만 중간 과정이 없고 왜 이런 control signal이 나온지 과정이 없으면 다른 엔지니어들은 만든 엔지니어의 의도와 생각을 읽으면서 봐야할 것입니다. 저는 이런 상황을 방지하기 위해 설계도에 진리표 풀이, k-map을 추가합니다. 
![alt text](/assets/images/2026-01-24-skid-buffer/skid_buffer_schmetic.png)

아래 그림은 skid buffer에서 Status Register의 상태 변화를 나타낸 진리표입니다.<br>
![alt text](/assets/images/2026-01-24-skid-buffer/skid_buffer_status_register.png)

아래 그림은 Status Register와 입력에 따른 Producer 방향 ready signal register 부분 입니다.<br>
![alt text](/assets/images/2026-01-24-skid-buffer/slave_ready_register_logic.png)


이에 대한 testbench와 full code는 [git repo](https://github.com/jeongyoon-kang/AXI/tree/main/src/peri_ip/skid_buffer)에서 확인할 수 있습니다. 

직접 설계해보고 이에 대한 testbench도 작성해서 검증해보시길 바랍니다. 그리고 제가 설계한 것과 동일한 결과가 나오는지 확인해보시길 바랍니다.
