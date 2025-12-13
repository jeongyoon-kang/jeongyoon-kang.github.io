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

Master, Slave에 대한 개념은 아실거라 생각합니다만, 한번 짚고 넘어가자면 Master는 데이터 전송을 시작하는 주체이고 Slave는 Master의 요청에 응답하는 주체입니다. 따라서 위 그림의 Data flow는 왼쪽에서 오른쪽입니다. Valid와 Data는 → 방향인데 ready의 경우 그 반대인 ← 방향으로 되어있습니다. ready의 의미는 slave 단에서 master의 응답을 받을 준비가 되었다라는 것을 알리는 신호 역할이기에 그렇습니다.

우선 Valid와 Data에 대해 간단하게 설명하자면, Valid와 Data는 Cycle마다 함께 쌍으로 움직입니다. 위의 basic module에서 valid를 저장하는 F/F가 1으로 set 되어있다면 Data F/F의 내용이 유효하다는 의미입니다. 만약 Valid가 0으로 set 되어있다면 Data F/F의 내용은 유효한 값이 아닌 쓰레기 값이라는 의미입니다. 

이제 Ready 신호에 대해 살펴보겠습니다. Ready의 경우 Valid F/F의 출력과 Slave단의 ready 신호가 서로 ORing 되어서 Valid, Data F/F의 Enable 신호로 들어갑니다. 왜 이렇게 하면 Valid/Ready Handshake가 되는지 한번 알아봅시다.

현재 Valid F/F이 0인 경우에는 Data F/F에 있는 값은 의미있는 값이 아닙니다. 따라서 Master로부터 데이터를 받아도 문제가 생기지 않습니다. 그럼 Valid F/F가 1인 경우는 어떻게 될까요? Valid F/F가 1이라는건 현재 Data F/F이 가지고 있는 값이 유효한 데이터라는 것이고 이는 Data flow상 다음 clk의 edge에 slave 모듈로 넘겨줘야합니다. 그럼 slave에서 ready가 0이라면 다음 clk edge에 Slave Data F/F으로 넘겨주면 안되겠지요? 만약 넘겨주게 되면 이미 기존에 Slave의 Data F/F가 지니고 있는 값이 무시되겠지요. 따라서 이 때는 Slave로 넘겨주는 것이 아닌 현 F/F에서 값을 계속 유지해줘야합니다. 이제 반대로 slave에서 ready를 1로 띄워준다면 어떻게 될까요? Slave에서 받을 준비가 되었다니 Valid와 Data를 그대로 다음 clk edge에 넘겨주면 됩니다.

이해를 위해 말로 설명했지만, 진리표로 보는 것이 조금 더 쉬울 수 있습니다. 아래 표에서 신호는 Valid/Ready Handshake Basic Module 내 신호입니다.
이미 설명을 보고 이해하신 분은 m_valid가 0이라면 m_ready는 don't care라는 것을 눈치채신 분도 계실 것입니다.

|m_valid|m_ready|s_ready|description|
|---|---|---|---|
| 0 | X | 1 | 현재 Data F/F의 값이 유효하지 않음 따라서 ready에 무관하게 data를 받을 수 있음 |
| 1 | 0 | 0 | 현재 Data F/F값이 유효한 상황, 뒤에 연결된 모듈에서 Data를 받을 수 있는 상황이 아님 |
| 1 | 1 | 1 | 현재 Data F/F값이 유효한 상황, 뒤에 연결된 모듈에서 Data를 받을 수 있음 (next clk edge에서 뒷 모듈에 넘겨주고 앞 모듈로 data를 받아오는 것이 가능한 상황) |

## Critical Path

![alt text](/assets/images/2025-12-10-rtl-handshake2/cascade_blackbox_module.png)


하지만 위 그림처럼 handshake interface를 가지는 module들을 cascade 구조로 연결해주면 timing 관점에서 문제가 생길 수 있습니다. 

![alt text](/assets/images/2025-12-10-rtl-handshake2/critical_path_candidate.png)

Valid, Data는 F/F으로 인해 registered output이지만, ready 신호는 아닙니다. 따라서 이런 구조가 깊어진다면 ready signal path가 critical path가 될 가능성이 높아집니다. 따라서 이런 부분도 중간에 register를 심어줘서 pipelining 해주는 것이 필요합니다. 이걸 해결하는 방법은 추후 skid buffer편으로 찾아오겠습니다. 

## Verilog 실습

git repo에서 lab1_valid_interface 코드를 handshake 기반 모듈로 바꿔보면서 실습하는 시간을 가지겠습니다
소스 코드는 아래 레포에서 clone해서 사용하시거나, 코드 스니펫을 참고하길 바랍니다.
[Git Repo](https://github.com/jeongyoon-kang/RTL.git)

 lab1_valid_interface의 schematic은 아래와 같습니다. 입력을 받아서 자신에 대해 곱하여서 3-stage를 거치면 입력에 대해 8제곱을 한 값이 출력으로 나오게 되는 모듈입니다.
![alt text](/assets/images/2025-12-10-rtl-handshake2/valid_module_schmetic.png)

아래 그림은 lab1_valid_interface의 검증 흐름입니다. test vector를 주입하고 그 결과를 reference 결과와 비교하면서 scoreboard에 pass/fail을 남기게 됩니다.
lab1에 대해서는 따로 다룬 포스팅은 없습니다만, 따로 해보고 싶으신 분은 그림을 참고해서 스스로 진행해보셔도 좋습니다.
![alt text](/assets/images/2025-12-10-rtl-handshake2/valid_test_flow.png)


이제 아래와 같이 ready signal을 추가해서 valid/ready handshake interface로 완성하는 시간을 가져보겠습니다.
![alt text](/assets/images/2025-12-10-rtl-handshake2/handshake_module_schmetic.png)


lab1_valid_interface의 코드는 아래와 같습니다. 여기서 간단하게 or gate에 대한 combination logic을 추가하고 register logic을 수정하면 끝입니다.

```verilog
//==============================================================================
// File name    : basic.v
// Description  : [Brief description of what this module does]
//
// Author       : [Jeongyoon Kang]
// Email        : [goneki9713@naver.com]
// Date         : 2025-12-13
// Version      : 1.0
//
// History:
//   2025-12-13 - [Jeongyoon Kang] - Initial version: Simple Vaild interface example
//
// Parameters:
//   PARAM_NAME  - [Description]
//
// Notes:
//   - [Any important notes about this module]
//   - [Design decisions, limitations, or usage guidelines]
//==============================================================================

`timescale 1ns/1ps
`default_nettype none

module power #(
    parameter DATA_WIDTH = 32
)(
    // Clock and Reset
    input  wire                     clk,
    input  wire                     reset_n,

    // Input Interface
    input  wire                     i_valid,
    input  wire  [DATA_WIDTH-1:0]   i_data,

    // Output Interface
    output wire                     o_valid,
    output wire  [63:0]   o_data
);

//🟩: Stage
//🟧: Combinational logic
//🟦: Sequential logic


//=============================================================================
// Internal Signal Declarations
//=============================================================================

//-----------------------------------------------------------------------------
// 🟩Stage 0
//-----------------------------------------------------------------------------
// 🟧Combinational signals (intermediate values, NOT registers)

    wire [63:0] power_of_2;

// 🟦Sequential signals (actual flip-flops)

    reg [2:0] r_valid;
    reg [63:0] r_power_of_2;

//-----------------------------------------------------------------------------
// 🟩Stage 1
//-----------------------------------------------------------------------------
// 🟧Combinational signals (intermediate values, NOT registers)

    wire [63:0] power_of_4;

// 🟦Sequential signals (actual flip-flops)

    // reg [2:0] r_valid;
    reg [63:0] r_power_of_4;

//-----------------------------------------------------------------------------
// 🟩Stage 2
//-----------------------------------------------------------------------------
// 🟧Combinational signals (intermediate values, NOT registers)

    wire [63:0] power_of_8;

// 🟦Sequential signals (actual flip-flops)

    // reg [2:0] r_valid;
    reg [63:0] r_power_of_8;



//=============================================================================
// 🟧Combinational Logic
//=============================================================================

// 🟩Stage 0

    assign power_of_2 = i_data * i_data;


// 🟩Stage 1

    assign power_of_4 = r_power_of_2 * r_power_of_2;


// 🟩Stage 2

    assign power_of_8 = r_power_of_4 * r_power_of_4;


//=============================================================================
// 🟦Sequential Logic (Registers)
//=============================================================================

// 🟩Stage 0

    //
    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            r_valid[0] <= 1'b0; 
        end 
        else begin
            r_valid[0] <= i_valid;
        end
    end

    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            r_power_of_2 <= 'b0;
        end
        else begin
            r_power_of_2 <= power_of_2;
        end
    end


// 🟩Stage 1

    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            r_valid[1] <= 1'b0;
        end
        else begin
            r_valid[1] <= r_valid[0];
        end
    end

    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            r_power_of_4 <= 'b0;
        end
        else begin
            r_power_of_4 <= power_of_4;
        end
    end


// 🟩Stage 2

    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            r_valid[2] <= 1'b0;
        end
        else begin
            r_valid[2] <= r_valid[1];
        end
    end

    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            r_power_of_8 <= 'b0;
        end
        else begin
            r_power_of_8 <= power_of_8;
        end
    end



//=============================================================================
// Output Assign(Must be registered output!)
//=============================================================================

    assign o_valid = r_valid[2];
    assign o_data = r_power_of_8;


//=============================================================================
// Assertions (for simulation/formal verification)
//=============================================================================
`ifdef FORMAL
    // Add formal properties here
`endif

`ifdef SIMULATION
    // Add simulation assertions here
`endif

endmodule

`default_nettype wire

```