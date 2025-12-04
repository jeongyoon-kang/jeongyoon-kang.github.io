---
layout: single
title: "Exceptional Control Flow(ECF) - Introduction"
categories: system-sw 
---

# Exceptional Control Flow (ECF)

### Introduction
안녕하세요. 이번 포스팅은 System SW에서 예외적인 제어흐름에 대해 다루는 내용입니다.
<br>

프로세서는 전원을 처음 공급하는 시점부터 전원을 끌 때까지 프로그램 카운터는 순차적으로 증가합니다. 무슨 말인가 싶지만 이건 단순히 binary로 된 instruction들을 하나씩 실행한다는 의미입니다. 

이건 가장 간단한 형태의 제어흐름입니다. 실제로는  jump, call, return과 같은 instruction들이  제어흐름의 변화를 발생시킵니다. 이런 내용은 단순히 전자과 혹은 컴퓨터 공학과 1학년때 했던 컴퓨터 프로그래밍에서 이미 배운 기본적인 내용입니다.

여기서는 이런 내용을 다루기 보다는 시스템 레벨에서 제어흐름을 이해하기 위한 것들을 다룰 것입니다. 일반적인 컴퓨터 시스템에서는 사용자가 실행하는 프로그램 외에도 시스템 전반에서 자원관리 프로세스들이 실행되면서 프로세서에서 실행되는 제어흐름이 바뀌게 됩니다.

컴퓨터 시스템에서는 프로그램에 따른 제어흐름과 관련없는 시스템 상태의 변화에도 반응할 수 있어야 합니다. 예를 들어서 HW Interrupt가 발생한 경우, 제어흐름은 interrupt handler로 넘어가게 될 것입니다. 

이 외에도 HW timer는 용도에 따라 주기적으로 interrupt를 발생시키기도 하고, 시스템은 이를 처리해줘야합니다. 네트워크 패킷들이 도착하면 이를 처리해서 메모리에 저장하기도 해야합니다. 

현대의 시스템들은 제어흐름의 갑작스런 변화를 만드는 방법으로 Exception을 발생시키고 이를 처리하는 handler가 호출되어 처리하게 됩니다. 

예외적인 흐름은 위의 HW interrupt와 관련된 것 외에도 운영체제 커널에서는 프로세스를 관리하기 위해 context switching을 통해 제어흐름을 다른 프로세스에게 넘겨주기도 합니다.

혹은 프로그램을 실행하다가 문제가 생겨서 ctrl+c를 눌러서 종료하는 경우 실행 프로세스에 시그널을 주는 것인데 이런 것들도 예외적 제어흐름을 발생시키는 것입니다.

이런 복잡한 내용들을 이해하는 것이 발생한 에러에 대한 원인을 찾는데 도움이 될 것입니다.

Exceptional Control Flow를 이해해야하는 중요한 이유는 아래와 같습니다.
>ECF를 이해하면 SW에서 `시스템`이라는 개념을 이해할 수 있다.<br> ECF는 운영체제가 I/O, process, virtual memory를 구현하기 위해 사용하는 기본적인 방법입니다. 이 내부 알고리즘이 어떻게 되어있고 동작 흐름을 알기 위해서는 이 과정을 이해해야 합니다.

>SW에서 동시성을 이해하는 데 도움이 됩니다. 최신 프로그램들은 대다수가 multi process, multi thread로 구동하도록 되어있습니다. 또한 이 뿐만 아니라 process간 signal을 주고 받으면서 다양한 service를 제공합니다. 

왜 이 내용을 공부해야하는지 배경, 이유를 설명하다보니 서론이 길었습니다.
<br> 그럼 본격적으로 개념 설명으로 들어가겠습니다.

---
---

## Exception의 종류
Exception의 종류는 4가지로 나눌 수 있습니다.
<br>
1. Interrupt
2. Trap
3. Fault
4. Abort

그 특징은 아래 테이블과 같습니다.

| Class | Cause | Async/sync | Return behavior |  
|---|---|---|---|
| Interrupt | Signal from I/O device | Async | Always return to next instruction |
| Trap | Intentional exception | Sync | Always return to next instruction | 
| Fault | Potentially recoverable error | Sync | Might return to current instruction |
| Abort | Nonrecoverable error | Sync | Never returns |

테이블에서 Async/sync에 대한 설명은 아래와 같습니다.
<br>**Async exception**은 프로세서 외부에 있는 입출력 디바이스 내 이벤트의 결과로 발생합니다.
<br>**Sync exception**은 Instruction을 실행한 결과로 발생한 것입니다.

---
### Interrupt

아래는 interrupt가 발생했을 때 제어흐름 도식입니다. 
1. Interrupt는 프로세서에서 프로그램의 Instruction을 처리하는 도중, 프로세서 입장에서는 예상할 수 없는 타이밍에 Interrupt pin이 assert 되면서 발생합니다.
2. 프로세서가 instruction을 처리하는 중간에 Interrupt service routine (ISR)으로 jump를 해야합니다.
3. 이 때는 아래 그림과 같이 현재 처리하는 Instruction을 완료하고 ISR로 jump 합니다. 
4. ISR을 수행하고 돌아와서 이어서 다음 instruction을 진행합니다.

이 때 ISR로 전환할 때 현재 프로세스의 상태를 저장하고 가는 세부적인 메커니즘이 있습니다. 이는 기회가 있으면 assembly 수준 interrupt 제어흐름에 대해서도 추후 포스팅하겠습니다.


Interrupt는 명시적으로 HW exception이라 말하는 사람도 있고 혹은 HW Interrupt라고 말하는 사람도 있습니다.
이 모든게 같은 내용입니다.

![alt text](/assets/images/2025-12-3-ch8-1-exception/Interrupt_handle_flow.png)

---

### Trap & System call

아래는 trap이 발생했을 때 제어흐름 도식입니다.<br>
Interrupt가 발생했을 때 제어흐름과 유사한 부분이 있습니다.<br>
하지만 Trap은 **의도적인 예외사항**입니다. <br>즉, 어떤 instruction을 실행한 결과로 발생합니다. Interrupt의 경우, instruction 실행의 결과가 아니라 외부 I/O에 의해 비동기적으로 발생한 것이라는 부분에서 개념적으로 차이가 있습니다.
<br>Interrupt와 마찬가지로 발생했을 경우 이를 처리해주는 handler로 jump하게 됩니다. 

Trap에서 가장 중요한 것은 시스템 콜 (syscall)입니다. 이 기능은 user level application과 kernel 사이의 procedure (subroutine)와 같은 인터페이스를 제공하는 것입니다.<br> user level에서 `read`, `write`, `open`, `close`, `execve`, `fork`와 같은 함수를 호출하면, 이에 대한 procedure가 kernel 상에 구현체가 있는데 이것이 수행되는 것입니다. 

프로그래머 관점에서 syscall은 보통의 함수 호출과 동일합니다. 하지만 실제 구현은 다른 부분이 존재합니다. 보통의 함수는 사용자 모드에서 돌아가며, 이 모드에서는 실행할 수 있는 instruction들이 제한적입니다. Syscall은 커널 모드에서 돌아가며, 커널 내에서 정의된 스택에 접근하며, 특권을 가진 instruction을 실행할 수 있습니다.

이에 대한 자세한 내용은 추후 업로드 되는 글에서 다루겠습니다. 또한 device driver를 다루는 category에서 한번 더 소개하겠습니다.


![alt text](/assets/images/2025-12-3-ch8-1-exception/trap_handle_flow.png)

---

### Fault

Fault는 에러가 발생했을 때 handler가 이를 처리하여 복구할 수 있는 예외입니다. Handler가 fault를 성공적으로 처리하면 fault를 일으킨 현재 instruction을 다시 실행합니다.

오류가 발생하면 프로세서는 제어를 fault handler로 넘겨줍니다. (fault handler로 jump한다는 의미입니다.) 만일 handler가 존재하고 이 에러 상황을 해결할 수 있다면 이를 처리하고 오류가 발생한 instruction으로 돌아와서 다시 실행하게 됩니다. 

만약 위 조건이 아니라면 (fault handler가 없거나 처리할 수 없는 상황이라면) abort routine으로 return해서 오류를 발생시킨 프로그램을 종료시킵니다.



![alt text](/assets/images/2025-12-3-ch8-1-exception/fault_handle_flow.png)


Fault의 가장 대표적인 사례는 **page fault**입니다. Page fault는 instruction이 가상 메모리 주소를 참조했을 때 대응되는 물리 메모리 page가 존재하지 않으면 발생합니다.

Page fault가 발생하는 주요 상황들은 다음과 같습니다:

1. **Page swap으로 인한 경우**: 물리 메모리가 부족해서 일부 page들이 disk의 swap space로 evict된 상태에서, 프로그램이 해당 page에 접근하려고 할 때 발생합니다. 이 경우 page fault handler는 disk에서 해당 page를 다시 물리 메모리로 load한 후, fault가 발생한 instruction으로 돌아가서 다시 실행하게 됩니다.

2. **Lazy allocation으로 인한 경우**: 현대 OS에서는 `malloc`이나 `mmap`으로 메모리를 할당받아도 실제로는 물리 메모리를 즉시 할당하지 않습니다. 프로그램이 실제로 해당 페이지에 처음으로 쓰기를 시도하는 순간 page fault가 발생하고, 그때서야 OS가 물리 메모리를 할당해줍니다.

가상 메모리와 page fault에 대한 자세한 메커니즘은 추후 가상메모리 파트에서 다루겠습니다.


### Abort

Abort는 DRAM, SRAM이 고장날 때 발생하는 패리티 에러와 HW에서 발생하는 복구할 수 없는 치명적인 에러에서 발생합니다. Abort handler는 절대로 응용프로그램으로 제어를 리턴하지 않습니다.

![alt text](/assets/images/2025-12-3-ch8-1-exception/abort_handle_flow.png)

---
---


## Linux/x86-64 시스템에서 예외상황

| Exception number | Description | Exception class|
|---|---|---|
| 0 | Divide error | Fault |
| 13 | General protection fault | Fault |
| 14 | Page fault | Fault |
| 18 | Machine check | Abort |
| 32-255 | OS-defined exceptions | Interrupt or trap |

x86-64 architecture에는 256개의 서로 다른 예외 종류가 있습니다. 0~31 범위의 숫자들은 Intel architecture에서 정의된 예외들에 대응되며, 모든 x86-64 시스템에서 동일합니다. 나머지 32~255 범위는 운영체제에서 정의된 interrupt와 trap에 대응됩니다. 

### Linux/x86-64 Fault & Abort

**divide error**
> 나누기 에러 (예외 0)는 0으로 나누려고 할 때, 또는 나눗셈 결과가 register에 담을 수 없을 정도로 큰 경우에 발생합니다. (나눗셈 결과가 register 크기를 초과한 경우) <br> 이런 경우 divide error에 대해 복구는 없고 프로그램을 중단하게 됩니다. 보통 Linux shell에서는 이를 Floating point exception이라고 보고합니다.<br> 아래 코드를 빌드하고 실행해보면 그 결과를 확인할 수 있습니다.

```c
#include <stdio.h>

int main() {
    int a = 100;
    int b = 0;
    
    printf("정수 나누기 0 실행: %d / %d\n", a, b);
    int result = a / b;  // Floating point exception 발생
    
    printf("결과: %d\n", result);
    return 0;
}
```

```bash
정수 나누기 0 실행: 100 / 0
Floating point exception (core dumped)
```

**General protection fault**
> 악명 높은 오류입니다. 보통 C 프로그래밍을 하다보면 보고 싶지 않은 오류 중 하나입니다. <br>`segmentation fault`를 출력하면서 프로세스가 종료되는 상황을 종종 볼 수 있습니다. <br>이는 여러 가지 이유로 발생하는데, 보통 프로그램이 가상메모리의 정의되지 않은 영역을 참조하거나, 프로그램이 read-only 텍스트 세그먼트에 쓰려고 할 때 발생합니다. <br>Linux에서는 이 fault를 별도로 복구하려는 시도를 하지 않습니다.

**Page fault**
> page fault는 fault 발생 instruction이 재시작되는 예외의 사례입니다. <br>Handler는 필요한 가상메모리의 해당 페이지를 디스크에서 물리메모리의 페이지로 매핑하고 fault가 발생한 instuction을 다시 시작합니다.<br>자세한 내용은 이후 가상메모리 파트에서 다루겠습니다.

**Machine check**
> Machine check는 하드웨어가 물리적으로 고장나서 복구할 수 없는 치명적인 에러입니다. <br>주요 발생 원인:<br>1. 메모리 비트 오류 (RAM 칩 결함으로 데이터가 잘못 읽히는 경우)<br>2. CPU 내부 오류 (CPU 회로 문제로 계산 결과가 잘못 나오는 경우)<br>3. 버스 에러 (CPU-메모리 간 데이터 전송 중 신호 오류)<br>소프트웨어 버그는 코드를 고치면 되지만, 하드웨어가 물리적으로 망가진 것은 운영체제가 어떻게 할 수 없기 때문에 machine check error를 발생시키고 abort routine을 통해 시스템을 종료합니다.

### Linux/x86-64 Syscall
Linux는 파일을 읽거나 쓸 때, 혹은 새로운 프로세스를 만들 때 응용프로그램이 사용할 수 있는 수백 개의 시스템 콜을 제공합니다. <br>아래 테이블은 자주 사용되는 Linux system call 중 일부를 보여줍니다. <br> 각 system call은 kernel jump table의 offset에 대응되는 유일한 정수를 갖습니다. (이 jump table은 exception table과는 다릅니다.)

| Number | Name | Description | Number | Name | Description |
|---|---|---|---|---|---|
| 0 | `read` | Read file | 33 | `pause` | Suspend process until signal arrives |
| 1 | `write` | Write file | 37 | `alarm` | Schedule delivery of alarm signal |
| 2 | `open` | Open file | 39 | `getpid` | Get process ID |
| 3 | `close` | Close file | 57 | `fork` | Create process |
| 4 | `stat` | Get info about file | 59 | `execve` | Execute a program |
| 9 | `mmap` | Map memory page to file | 60 | `_exit` | Terminate process |
| 12 | `brk` | Reset the top of the heap | 61 | `wait4` | Wait for a process to terminate |
| 32 | `dup2` | Copy file descriptor | 62 | `kill` | Send signal to a process |


**심화1**

C 프로그램은 syscall 함수를 사용해서 직접 시스템 콜을 호출할 수 있습니다.
<br>아래가 그 예시 코드입니다.
```c
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

int main() {
    // syscall로 getpid 직접 호출
    pid_t pid = syscall(SYS_getpid);
    printf("My PID: %d\n", pid);
    
    return 0;
}
```
```bash
kjy@kjy-VirtualBox:~/SystemSoftware/test$ ./syscall
My PID: 14354
```

하지만 이렇게 사용하는 일은 거의 없습니다. 표준 C 라이브러리는 대부분의 system call에 대해 편리한 wrapper 함수를 제공합니다.<br> 래퍼 함수는 인자들을 패키징하고, 적절한 syscall instruction으로 trap을 발생시키고 호출하는 프로세스로 syscall의 return status를 전달합니다. 

**심화2**

아래 예시는 간단한 system call을 호출하는 C 코드와 assembly 코드입니다.<br>
프로그램의 기계어 수준 표현을 공부했다면 calling convention을 알고 있을 것입니다.
<br> procedure를 호출할 때 register 혹은 stack으로 인자를 넘깁니다.<br>
Linux system call은 전달되는 모든 인자들을 stack보다는 general register를 통해 전달합니다.<br>
관습적으로 %rax는 system call 번호를 보관하며 %rdi, %rsi, %rdx, %r10, %r8, %r9에 최대 6개의 인자들을 보관할 수 있습니다.<br> system call이 완료되고 return할 때, %rcx, %r11 값들은 지워지고 %rax는 return 값을 보관합니다.
>왜 %rcx, %r11이 지워지는지 궁금할 수 있습니다.
<br> x86-64의 `syscall` instruction이 실행될 때, %rcx에는 return address가, %r11에는 RFLAGS 값이 자동으로 저장됩니다. 커널에서 `sysret`으로 복귀할 때 이 값들을 사용하므로, 사용자 프로그램 입장에서는 이 레지스터들의 원래 값이 보존되지 않습니다. 따라서 calling convention 상 caller-saved register로 취급됩니다.

아래 코드를 실행하면 printf("Hello, world\n")를 실행한 것과 동일한 결과가 나옵니다.
>여기서도 write로 어떻게 printf 한 것과 같은 결과가 나오는지 궁금할 수 있습니다.
<br>간단하게 설명하면 `write`의 첫 번째 인자 값의 의미는 출력을 `stdout`으로 보낸다는 것이고, 두 번째 인자의 의미는 `write`로 가는 바이트의 배열이고, 세 번째 인자는 write할 바이트 수를 나타냅니다. 
```c
int main(){
    write(1, "hello, world\n", 13);
    _exit(0);
}
```


```bash
.section .data
string:
.ascii "hello, world\n"
string_end:
.equ len, string_end - string
.section .text
.globl main
main:
                        #First, call write(1, "hello, world\n", 13)
movq $1, %rax           #write is system call 1
movq $1, %rdi           #Arg1: stdout has descriptor 1
movq $string, %rsi      #Arg2: hello world string
movq $len, %rdx         #Arg3: string length
syscall                 #Make the system call
                        #Next, call _exit(0)
movq $60, %rax          #_exit is system call 60
movq $0, %rdi           #Arg1: exit status is 0
syscall                 #Make the system call
```




---



오늘은 간단하게 Exception Control Flow의 개념을 소개했습니다. 앞으로 더 deep dive를 할텐데 많은 기대 부탁드리겠습니다. 
<br>최대한 내용상 오류가 없도록 검토하였습니다. 만약 오류가 있다면 댓글 혹은 메일 주시면 감사하겠습니다.