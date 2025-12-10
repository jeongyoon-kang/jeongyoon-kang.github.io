---
layout: single
title: "AMBA - Handshake1"
categories: amba
---


# Introduction

안녕하세요. 이 카테고리에서는 AMBA에 대해 다룰 예정입니다. 본 포스팅에서는 본격적으로 AMBA에 들어가기 전에 handshake를 이해하는 시간을 가져보겠습니다.

아마 대부분 학부에서 Verilog를 이용한 디지털 시스템 설계 그리고 마이크로프로세서, 컴퓨터 구조에 대한 수업을 이수했을 것입니다. 그러면 각 모듈을 설계하고 F/F을 중간에 삽입해서 pipeline을 설계해보셨을 것입니다. 

데이터를 input으로 받아서 처리하는 모듈을 만든다고 생각해봅시다. 이 때 이 TOP module 내부에는 여러 submodule로 이루어질 것입니다. submodule간 역할을 정해서 각자 역할에 맞게 데이터를 처리하고 후속 module로 넘겨줄 것입니다.

## 왜 Handshake가 필요한가?

간단한 pipeline을 설계할 때, flip-flop을 두고 각 stage의 latency를 모두 정확히 알고 있다면 클럭에 맞춰 데이터가 순차적으로 전달되므로 별도의 제어 신호가 필요하지 않을 것입니다. 하지만 실제 설계에서는 다음과 같은 문제들이 발생합니다:

![alt text](/assets/images/2025-12-10-rtl-handshake/no_interface.png)

1. **가변적인 latency**: 모든 연산의 latency를 정확히 예측하기 어렵거나, 연산에 따라 latency가 달라질 수 있습니다.
2. **복잡한 timing 계산**: 여러 모듈이 연결된 복잡한 시스템에서 모든 timing을 일일이 따지기는 매우 어렵습니다.

이러한 상황에서 **valid 신호**를 사용하면 간단하게 문제를 해결할 수 있습니다. 송신 모듈이 출력 데이터가 유효할 때 valid 신호를 high로 설정하면, 수신 모듈은 언제 데이터를 읽어야 하는지 명확하게 알 수 있습니다.

![alt text](/assets/images/2025-12-10-rtl-handshake/valid_interface.png)

하지만 valid 신호만으로는 충분하지 않습니다. 만약 수신 모듈이 데이터를 받을 수 없는 상황(stall)인데도 송신 모듈이 계속 데이터를 보내면 어떻게 될까요? 데이터가 손실되거나 처리되지 못하는 문제가 발생합니다.

이를 해결하기 위해 **ready 신호**가 도입됩니다. 수신 모듈이 데이터를 받을 준비가 되었을 때 ready 신호를 high로 설정합니다. 그러면 송신 모듈은 ready 신호를 확인하고 데이터를 전송할 수 있습니다.

결과적으로, **valid와 ready가 모두 high인 순간**에만 데이터가 전달되도록 하면 안정적인 데이터 전송이 가능합니다. 이것이 바로 **handshake 프로토콜**의 핵심 원리입니다. 

![alt text](/assets/images/2025-12-10-rtl-handshake/handshake_interface.png)



Timing diagram을 한번 보겠습니다.
어떤 data를 master module에서 slave module로 넘겨주는 상황입니다. valid와 ready가 모두 high일 때 clk의 rising edge에 data가 master → slave로 넘어가게 됩니다.

![alt text](/assets/images/2025-12-10-rtl-handshake/handshake_timing.png)

Handshake interface를 이용하면 데이터를 손실없이 master에서 slave로 넘길 수 있습니다. 이런 장점만 생각하고 무차별적으로 사용하는 것은 지양해야합니다. 만약 module A, module B, module C가 있는 상항에서 module C가 데이터를 처리하는데 소모되는 cycle이 A,B 보다 많고, 이로 인해 ready를 늦게 set한다면 A,B는 C로 인해 stall이 발생하게 됩니다. 따라서 이런 interface를 이용하는 경우에는 module 간 bottleneck이 어디에서 발생하는지 잘 확인해야합니다.

이번 포스팅에서는 간단하게 valid-ready handshake interface에 대해 알아보았습니다. 다음 포스팅에서는 직접 verilog로 waveform을 보면서 실습해보는 시간을 가지겠습니다.
