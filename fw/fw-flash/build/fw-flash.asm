
build/fw-flash.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <crtStart>:
.global crtStart
.global main
.global irqCallback

crtStart:
  j crtInit
   0:	0a00006f          	j	a0 <crtInit>
  nop
   4:	00000013          	nop
  nop
   8:	00000013          	nop
  nop
   c:	00000013          	nop

00000010 <trap_entry>:
// x0 is constant
// x2 is sp (always changing)
// x3-4 are gp, tp (fixed through program)
// x8-9, x18-27 are callee-saved registers
trap_entry:
  sw x1,  - 1*4(sp)
  10:	fe112e23          	sw	ra,-4(sp)
  sw x5,  - 2*4(sp)
  14:	fe512c23          	sw	t0,-8(sp)
  sw x6,  - 3*4(sp)
  18:	fe612a23          	sw	t1,-12(sp)
  sw x7,  - 4*4(sp)
  1c:	fe712823          	sw	t2,-16(sp)
  sw x10, - 5*4(sp)
  20:	fea12623          	sw	a0,-20(sp)
  sw x11, - 6*4(sp)
  24:	feb12423          	sw	a1,-24(sp)
  sw x12, - 7*4(sp)
  28:	fec12223          	sw	a2,-28(sp)
  sw x13, - 8*4(sp)
  2c:	fed12023          	sw	a3,-32(sp)
  sw x14, - 9*4(sp)
  30:	fce12e23          	sw	a4,-36(sp)
  sw x15, -10*4(sp)
  34:	fcf12c23          	sw	a5,-40(sp)
  sw x16, -11*4(sp)
  38:	fd012a23          	sw	a6,-44(sp)
  sw x17, -12*4(sp)
  3c:	fd112823          	sw	a7,-48(sp)
  sw x28, -13*4(sp)
  40:	fdc12623          	sw	t3,-52(sp)
  sw x29, -14*4(sp)
  44:	fdd12423          	sw	t4,-56(sp)
  sw x30, -15*4(sp)
  48:	fde12223          	sw	t5,-60(sp)
  sw x31, -16*4(sp)
  4c:	fdf12023          	sw	t6,-64(sp)
  addi sp,sp,-16*4
  50:	fc010113          	addi	sp,sp,-64
  call irqCallback
  54:	158000ef          	jal	ra,1ac <irqCallback>
  lw x1 , 15*4(sp)
  58:	03c12083          	lw	ra,60(sp)
  lw x5,  14*4(sp)
  5c:	03812283          	lw	t0,56(sp)
  lw x6,  13*4(sp)
  60:	03412303          	lw	t1,52(sp)
  lw x7,  12*4(sp)
  64:	03012383          	lw	t2,48(sp)
  lw x10, 11*4(sp)
  68:	02c12503          	lw	a0,44(sp)
  lw x11, 10*4(sp)
  6c:	02812583          	lw	a1,40(sp)
  lw x12,  9*4(sp)
  70:	02412603          	lw	a2,36(sp)
  lw x13,  8*4(sp)
  74:	02012683          	lw	a3,32(sp)
  lw x14,  7*4(sp)
  78:	01c12703          	lw	a4,28(sp)
  lw x15,  6*4(sp)
  7c:	01812783          	lw	a5,24(sp)
  lw x16,  5*4(sp)
  80:	01412803          	lw	a6,20(sp)
  lw x17,  4*4(sp)
  84:	01012883          	lw	a7,16(sp)
  lw x28,  3*4(sp)
  88:	00c12e03          	lw	t3,12(sp)
  lw x29,  2*4(sp)
  8c:	00812e83          	lw	t4,8(sp)
  lw x30,  1*4(sp)
  90:	00412f03          	lw	t5,4(sp)
  lw x31,  0*4(sp)
  94:	00012f83          	lw	t6,0(sp)
  addi sp,sp,16*4
  98:	04010113          	addi	sp,sp,64
  mret
  9c:	30200073          	mret

000000a0 <crtInit>:
  .text

crtInit:
  .option push
  .option norelax
  la gp, __global_pointer$
  a0:	40000197          	auipc	gp,0x40000
  a4:	76018193          	addi	gp,gp,1888 # 40000800 <__global_pointer$>
  .option pop
  la sp, _stack_start
  a8:	c0018113          	addi	sp,gp,-1024 # 40000400 <_stack_start>

# copy data section
  la a0, _sidata
  ac:	00000517          	auipc	a0,0x0
  b0:	10450513          	addi	a0,a0,260 # 1b0 <_etext>
  la a1, _sdata
  b4:	40000597          	auipc	a1,0x40000
  b8:	f4c58593          	addi	a1,a1,-180 # 40000000 <_end>
  la a2, _edata
  bc:	40000617          	auipc	a2,0x40000
  c0:	f4460613          	addi	a2,a2,-188 # 40000000 <_end>
  bge a1, a2, end_init_data
  c4:	00c5dc63          	bge	a1,a2,dc <bss_init>

000000c8 <loop_init_data>:
loop_init_data:
  lw a3, 0(a0)
  c8:	00052683          	lw	a3,0(a0)
  sw a3, 0(a1)
  cc:	00d5a023          	sw	a3,0(a1)
  addi a0, a0, 4
  d0:	00450513          	addi	a0,a0,4
  addi a1, a1, 4
  d4:	00458593          	addi	a1,a1,4
  blt a1, a2, loop_init_data
  d8:	fec5c8e3          	blt	a1,a2,c8 <loop_init_data>

000000dc <bss_init>:
end_init_data:

bss_init:
  la a0, _bss_start
  dc:	40000517          	auipc	a0,0x40000
  e0:	f2450513          	addi	a0,a0,-220 # 40000000 <_end>
  la a1, _bss_end
  e4:	40000597          	auipc	a1,0x40000
  e8:	f1c58593          	addi	a1,a1,-228 # 40000000 <_end>

000000ec <bss_loop>:
bss_loop:
  beq a0,a1,bss_done
  ec:	00b50863          	beq	a0,a1,fc <bss_done>
  sw zero,0(a0)
  f0:	00052023          	sw	zero,0(a0)
  add a0,a0,4
  f4:	00450513          	addi	a0,a0,4
  j bss_loop
  f8:	ff5ff06f          	j	ec <bss_loop>

000000fc <bss_done>:
bss_done:

ctors_init:
  la a0, _ctors_start
  fc:	1b000513          	li	a0,432
  addi sp,sp,-4
 100:	ffc10113          	addi	sp,sp,-4

00000104 <ctors_loop>:
ctors_loop:
  la a1, _ctors_end
 104:	1b000593          	li	a1,432
  beq a0,a1,ctors_done
 108:	00b50e63          	beq	a0,a1,124 <ctors_done>
  lw a3,0(a0)
 10c:	00052683          	lw	a3,0(a0)
  add a0,a0,4
 110:	00450513          	addi	a0,a0,4
  sw a0,0(sp)
 114:	00a12023          	sw	a0,0(sp)
  jalr  a3
 118:	000680e7          	jalr	a3
  lw a0,0(sp)
 11c:	00012503          	lw	a0,0(sp)
  j ctors_loop
 120:	fe5ff06f          	j	104 <ctors_loop>

00000124 <ctors_done>:
ctors_done:
  addi sp,sp,4
 124:	00410113          	addi	sp,sp,4

  call main
 128:	008000ef          	jal	ra,130 <main>

0000012c <infinitLoop>:
infinitLoop:
  j infinitLoop
 12c:	0000006f          	j	12c <infinitLoop>

00000130 <main>:
#define CLK_FREQ 25175000
#define UART_BAUD 115200

void main()
{
    UART0->CLKDIV = CLK_FREQ / UART_BAUD - 2;
 130:	830007b7          	lui	a5,0x83000
 134:	0d800713          	li	a4,216
 138:	00e7a223          	sw	a4,4(a5) # 83000004 <__global_pointer$+0x42fff804>

    GPIO0->OE = 0x3F;
 13c:	820007b7          	lui	a5,0x82000
 140:	03f00713          	li	a4,63
 144:	00e7a423          	sw	a4,8(a5) # 82000008 <__global_pointer$+0x41fff808>
    GPIO0->OUT = 0x3F;
 148:	00e7a023          	sw	a4,0(a5)
        QSPI0->REG |= QSPI_REG_CRM;
 14c:	81000737          	lui	a4,0x81000
 150:	00072783          	lw	a5,0(a4) # 81000000 <__global_pointer$+0x40fff800>
 154:	001006b7          	lui	a3,0x100
        QSPI0->REG |= QSPI_REG_DSPI;
 158:	004005b7          	lui	a1,0x400
        QSPI0->REG |= QSPI_REG_CRM;
 15c:	00d7e7b3          	or	a5,a5,a3
 160:	00f72023          	sw	a5,0(a4)
        QSPI0->REG |= QSPI_REG_DSPI;
 164:	00072683          	lw	a3,0(a4)
{
 168:	00018637          	lui	a2,0x18
    cmd_set_dspi(1);
    while (1)
    {
        /* code */
        for (int i = 0; i < 100000; i++)
            GPIO0->OUT ^= 0x00000001;
 16c:	820007b7          	lui	a5,0x82000
        QSPI0->REG |= QSPI_REG_DSPI;
 170:	00b6e6b3          	or	a3,a3,a1
 174:	00d72023          	sw	a3,0(a4)
{
 178:	6a060693          	addi	a3,a2,1696 # 186a0 <_stack_size+0x182a0>
            GPIO0->OUT ^= 0x00000001;
 17c:	0007a703          	lw	a4,0(a5) # 82000000 <__global_pointer$+0x41fff800>
 180:	fff68693          	addi	a3,a3,-1 # fffff <_stack_size+0xffbff>
 184:	00174713          	xori	a4,a4,1
 188:	00e7a023          	sw	a4,0(a5)
        for (int i = 0; i < 100000; i++)
 18c:	fe0698e3          	bnez	a3,17c <main+0x4c>
 190:	6a060693          	addi	a3,a2,1696
        for (int i = 0; i < 100000; i++)
            GPIO0->OUT ^= 0x00000010;
 194:	0007a703          	lw	a4,0(a5)
 198:	fff68693          	addi	a3,a3,-1
 19c:	01074713          	xori	a4,a4,16
 1a0:	00e7a023          	sw	a4,0(a5)
        for (int i = 0; i < 100000; i++)
 1a4:	fe0698e3          	bnez	a3,194 <main+0x64>
 1a8:	fd1ff06f          	j	178 <main+0x48>

000001ac <irqCallback>:
    }
}

void irqCallback()
{
 1ac:	00008067          	ret
