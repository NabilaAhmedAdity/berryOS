.globl GetSystemTimerBase
GetSystemTimerBase: 
	ldr r0,=0x20003000
	mov pc,lr

/*
* GetTimeStamp gets the current timestamp of the system timer, and returns it
* in registers r0 and r1, with r1 being the most significant 32 bits.
* C++ Signature: u64 GetTimeStamp()
*/
.globl GetTimeStamp
GetTimeStamp:
	push {lr}
	bl GetSystemTimerBase
	ldrd r0,r1,[r0,#4]
	pop {pc}

/*
* Wait waits at least a specified number of microseconds before returning.
* The duration to wait is given in r0.
* C++ Signature: void Wait(u32 delayInMicroSeconds)
*/
.globl Wait
Wait:
	delay .req r2
	mov delay,r0	
	push {lr}
	bl GetTimeStamp
	start .req r3
	mov start,r0

	loop$:
		bl GetTimeStamp
		elapsed .req r1
		sub elapsed,r0,start
		cmp elapsed,delay
		.unreq elapsed
		bls loop$
		
	.unreq delay
	.unreq start
	pop {pc}


