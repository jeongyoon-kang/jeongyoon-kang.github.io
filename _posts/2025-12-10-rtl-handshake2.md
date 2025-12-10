---
layout: single
title: "AMBA - Handshake2"
categories: amba
---

# Handshake Interface

안녕하세요. 이번 포스팅에서는 Handshake interface를 직접 verilog로 작성해보고 testbench로 그 파형을 확인해보겠습니다. 

**Environment**
>Vivado 2025.2 version <br> Ubuntu 24.04 <br> 환경변수에 Vivado bin 등록

아래 그림은 이전 글에서 보셨을 것입니다. 앞으로 이 그림은 많이 나올테니 눈에 계속 익히시는 것을 추천합니다. 

![alt text](/assets/images/2025-12-10-rtl-handshake2/handshake_img.png)

그럼 이제 interface schematic을 보겠습니다.


![alt text](/assets/images/2025-12-10-rtl-handshake2/handshake_schematic.png)