
build/fw-flash.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <crtStart>:
   0:	0a00006f          	j	a0 <crtInit>
   4:	00000013          	nop
   8:	00000013          	nop
   c:	00000013          	nop

00000010 <trap_entry>:
  10:	fe112e23          	sw	ra,-4(sp)
  14:	fe512c23          	sw	t0,-8(sp)
  18:	fe612a23          	sw	t1,-12(sp)
  1c:	fe712823          	sw	t2,-16(sp)
  20:	fea12623          	sw	a0,-20(sp)
  24:	feb12423          	sw	a1,-24(sp)
  28:	fec12223          	sw	a2,-28(sp)
  2c:	fed12023          	sw	a3,-32(sp)
  30:	fce12e23          	sw	a4,-36(sp)
  34:	fcf12c23          	sw	a5,-40(sp)
  38:	fd012a23          	sw	a6,-44(sp)
  3c:	fd112823          	sw	a7,-48(sp)
  40:	fdc12623          	sw	t3,-52(sp)
  44:	fdd12423          	sw	t4,-56(sp)
  48:	fde12223          	sw	t5,-60(sp)
  4c:	fdf12023          	sw	t6,-64(sp)
  50:	fc010113          	addi	sp,sp,-64
  54:	364000ef          	jal	ra,3b8 <irqCallback>
  58:	03c12083          	lw	ra,60(sp)
  5c:	03812283          	lw	t0,56(sp)
  60:	03412303          	lw	t1,52(sp)
  64:	03012383          	lw	t2,48(sp)
  68:	02c12503          	lw	a0,44(sp)
  6c:	02812583          	lw	a1,40(sp)
  70:	02412603          	lw	a2,36(sp)
  74:	02012683          	lw	a3,32(sp)
  78:	01c12703          	lw	a4,28(sp)
  7c:	01812783          	lw	a5,24(sp)
  80:	01412803          	lw	a6,20(sp)
  84:	01012883          	lw	a7,16(sp)
  88:	00c12e03          	lw	t3,12(sp)
  8c:	00812e83          	lw	t4,8(sp)
  90:	00412f03          	lw	t5,4(sp)
  94:	00012f83          	lw	t6,0(sp)
  98:	04010113          	addi	sp,sp,64
  9c:	30200073          	mret

000000a0 <crtInit>:
  a0:	40000197          	auipc	gp,0x40000
  a4:	76018193          	addi	gp,gp,1888 # 40000800 <__global_pointer$>
  a8:	c0018113          	addi	sp,gp,-1024 # 40000400 <_stack_start>
  ac:	00000517          	auipc	a0,0x0
  b0:	35050513          	addi	a0,a0,848 # 3fc <_etext>
  b4:	40000597          	auipc	a1,0x40000
  b8:	f4c58593          	addi	a1,a1,-180 # 40000000 <_end>
  bc:	40000617          	auipc	a2,0x40000
  c0:	f4460613          	addi	a2,a2,-188 # 40000000 <_end>
  c4:	00c5dc63          	bge	a1,a2,dc <bss_init>

000000c8 <loop_init_data>:
  c8:	00052683          	lw	a3,0(a0)
  cc:	00d5a023          	sw	a3,0(a1)
  d0:	00450513          	addi	a0,a0,4
  d4:	00458593          	addi	a1,a1,4
  d8:	fec5c8e3          	blt	a1,a2,c8 <loop_init_data>

000000dc <bss_init>:
  dc:	40000517          	auipc	a0,0x40000
  e0:	f2450513          	addi	a0,a0,-220 # 40000000 <_end>
  e4:	40000597          	auipc	a1,0x40000
  e8:	f1c58593          	addi	a1,a1,-228 # 40000000 <_end>

000000ec <bss_loop>:
  ec:	00b50863          	beq	a0,a1,fc <bss_done>
  f0:	00052023          	sw	zero,0(a0)
  f4:	00450513          	addi	a0,a0,4
  f8:	ff5ff06f          	j	ec <bss_loop>

000000fc <bss_done>:
  fc:	3fc00513          	li	a0,1020
 100:	ffc10113          	addi	sp,sp,-4

00000104 <ctors_loop>:
 104:	3fc00593          	li	a1,1020
 108:	00b50e63          	beq	a0,a1,124 <ctors_done>
 10c:	00052683          	lw	a3,0(a0)
 110:	00450513          	addi	a0,a0,4
 114:	00a12023          	sw	a0,0(sp)
 118:	000680e7          	jalr	a3
 11c:	00012503          	lw	a0,0(sp)
 120:	fe5ff06f          	j	104 <ctors_loop>

00000124 <ctors_done>:
 124:	00410113          	addi	sp,sp,4
 128:	008000ef          	jal	ra,130 <main>

0000012c <infinitLoop>:
 12c:	0000006f          	j	12c <infinitLoop>

00000130 <main>:
//  abc defg
// 0111 1011

int main()
{
    io_write(GPIO_BASE_ADDR, GPIO_OE_OFFSET, 0x3F);
 130:	820007b7          	lui	a5,0x82000
 134:	03f00713          	li	a4,63
 138:	00e7a023          	sw	a4,0(a5) # 82000000 <__global_pointer$+0x41fff800>
    io_write(GPIO_BASE_ADDR, GPIO_IE_OFFSET, 0x00);
 13c:	0007a223          	sw	zero,4(a5)
    io_write(GPIO_BASE_ADDR, GPIO_DATA_OFFSET, 0x15);
 140:	01500713          	li	a4,21
 144:	00e7a423          	sw	a4,8(a5)
    io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);
 148:	303387b7          	lui	a5,0x30338
 14c:	e7b78793          	addi	a5,a5,-389 # 30337e7b <_stack_size+0x30337a7b>

    int j = 0;
    while (1)
    {
        /* code */
        for (int i = 0; i < 50000; i++)
 150:	0000ceb7          	lui	t4,0xc
            case 11:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d337e7b);

                break;
            case 12:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x337e7b6d);
 154:	337e8fb7          	lui	t6,0x337e8
    io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);
 158:	c0000737          	lui	a4,0xc0000
            case 14:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b6d7e7e);

                break;
            case 15:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d7e7e79);
 15c:	6d7e88b7          	lui	a7,0x6d7e8
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b6d7e7e);
 160:	7b6d8837          	lui	a6,0x7b6d8
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7e7b6d7e);
 164:	7e7b7537          	lui	a0,0x7e7b7
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d337e7b);
 168:	6d3385b7          	lui	a1,0x6d338
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x016d337e);
 16c:	016d3637          	lui	a2,0x16d3
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x01016d33);
 170:	010176b7          	lui	a3,0x1017
    io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);
 174:	00f72023          	sw	a5,0(a4) # c0000000 <__global_pointer$+0x7ffff800>
    int j = 0;
 178:	3bc00f13          	li	t5,956
 17c:	00000793          	li	a5,0
        for (int i = 0; i < 50000; i++)
 180:	350e8e13          	addi	t3,t4,848 # c350 <_stack_size+0xbf50>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d7e7e79);
 184:	e7988893          	addi	a7,a7,-391 # 6d7e7e79 <__global_pointer$+0x2d7e7679>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b6d7e7e);
 188:	e7e80813          	addi	a6,a6,-386 # 7b6d7e7e <__global_pointer$+0x3b6d767e>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7e7b6d7e);
 18c:	d7e50513          	addi	a0,a0,-642 # 7e7b6d7e <__global_pointer$+0x3e7b657e>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x337e7b6d);
 190:	b6df8313          	addi	t1,t6,-1171 # 337e7b6d <_stack_size+0x337e776d>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d337e7b);
 194:	e7b58593          	addi	a1,a1,-389 # 6d337e7b <__global_pointer$+0x2d33767b>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x016d337e);
 198:	37e60613          	addi	a2,a2,894 # 16d337e <_stack_size+0x16d2f7e>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x01016d33);
 19c:	d3368693          	addi	a3,a3,-717 # 1016d33 <_stack_size+0x1016933>
            switch (j)
 1a0:	00f00713          	li	a4,15
 1a4:	00f76a63          	bltu	a4,a5,1b8 <main+0x88>
 1a8:	00279713          	slli	a4,a5,0x2
 1ac:	00ef0733          	add	a4,t5,a4
 1b0:	00072703          	lw	a4,0(a4)
 1b4:	00070067          	jr	a4
 1b8:	00100793          	li	a5,1
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x00000030);
 1bc:	c00002b7          	lui	t0,0xc0000
 1c0:	03000713          	li	a4,48
 1c4:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
        for (int i = 0; i < 50000; i++)
 1c8:	00178793          	addi	a5,a5,1
 1cc:	ffc79ce3          	bne	a5,t3,1c4 <main+0x94>
 1d0:	00100793          	li	a5,1
 1d4:	fcdff06f          	j	1a0 <main+0x70>
            switch (j)
 1d8:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d7e7e79);
 1dc:	c0000737          	lui	a4,0xc0000
 1e0:	01172023          	sw	a7,0(a4) # c0000000 <__global_pointer$+0x7ffff800>

                break;
 1e4:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 1e8:	fe079ce3          	bnez	a5,1e0 <main+0xb0>
 1ec:	01000793          	li	a5,16
 1f0:	fb1ff06f          	j	1a0 <main+0x70>
            switch (j)
 1f4:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b6d7e7e);
 1f8:	c0000737          	lui	a4,0xc0000
 1fc:	01072023          	sw	a6,0(a4) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 200:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 204:	fe079ce3          	bnez	a5,1fc <main+0xcc>
 208:	00f00793          	li	a5,15
 20c:	f95ff06f          	j	1a0 <main+0x70>
            switch (j)
 210:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7e7b6d7e);
 214:	c0000737          	lui	a4,0xc0000
 218:	00a72023          	sw	a0,0(a4) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 21c:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 220:	fe079ce3          	bnez	a5,218 <main+0xe8>
 224:	00e00793          	li	a5,14
 228:	f79ff06f          	j	1a0 <main+0x70>
            switch (j)
 22c:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x337e7b6d);
 230:	c0000737          	lui	a4,0xc0000
 234:	00672023          	sw	t1,0(a4) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 238:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 23c:	fe079ce3          	bnez	a5,234 <main+0x104>
 240:	00d00793          	li	a5,13
 244:	f5dff06f          	j	1a0 <main+0x70>
            switch (j)
 248:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d337e7b);
 24c:	c0000737          	lui	a4,0xc0000
 250:	00b72023          	sw	a1,0(a4) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 254:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 258:	fe079ce3          	bnez	a5,250 <main+0x120>
 25c:	00c00793          	li	a5,12
 260:	f41ff06f          	j	1a0 <main+0x70>
            switch (j)
 264:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x016d337e);
 268:	c0000737          	lui	a4,0xc0000
 26c:	00c72023          	sw	a2,0(a4) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 270:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 274:	fe079ce3          	bnez	a5,26c <main+0x13c>
 278:	00b00793          	li	a5,11
 27c:	f25ff06f          	j	1a0 <main+0x70>
            switch (j)
 280:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x01016d33);
 284:	c0000737          	lui	a4,0xc0000
 288:	00d72023          	sw	a3,0(a4) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 28c:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 290:	fe079ce3          	bnez	a5,288 <main+0x158>
 294:	00a00793          	li	a5,10
 298:	f09ff06f          	j	1a0 <main+0x70>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x0101016d);
 29c:	01010737          	lui	a4,0x1010
            switch (j)
 2a0:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x0101016d);
 2a4:	c00002b7          	lui	t0,0xc0000
 2a8:	16d70713          	addi	a4,a4,365 # 101016d <_stack_size+0x100fd6d>
 2ac:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 2b0:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 2b4:	fe079ce3          	bnez	a5,2ac <main+0x17c>
 2b8:	00900793          	li	a5,9
 2bc:	ee5ff06f          	j	1a0 <main+0x70>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x01010101);
 2c0:	01010737          	lui	a4,0x1010
            switch (j)
 2c4:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x01010101);
 2c8:	c00002b7          	lui	t0,0xc0000
 2cc:	10170713          	addi	a4,a4,257 # 1010101 <_stack_size+0x100fd01>
 2d0:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 2d4:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 2d8:	fe079ce3          	bnez	a5,2d0 <main+0x1a0>
 2dc:	00800793          	li	a5,8
 2e0:	ec1ff06f          	j	1a0 <main+0x70>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b010101);
 2e4:	7b010737          	lui	a4,0x7b010
            switch (j)
 2e8:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b010101);
 2ec:	c00002b7          	lui	t0,0xc0000
 2f0:	10170713          	addi	a4,a4,257 # 7b010101 <__global_pointer$+0x3b00f901>
 2f4:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 2f8:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 2fc:	fe079ce3          	bnez	a5,2f4 <main+0x1c4>
 300:	00700793          	li	a5,7
 304:	e9dff06f          	j	1a0 <main+0x70>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7e7b0101);
 308:	7e7b0737          	lui	a4,0x7e7b0
            switch (j)
 30c:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7e7b0101);
 310:	c00002b7          	lui	t0,0xc0000
 314:	10170713          	addi	a4,a4,257 # 7e7b0101 <__global_pointer$+0x3e7af901>
 318:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 31c:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 320:	fe079ce3          	bnez	a5,318 <main+0x1e8>
 324:	00600793          	li	a5,6
 328:	e79ff06f          	j	1a0 <main+0x70>
            switch (j)
 32c:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x337e7b01);
 330:	c00002b7          	lui	t0,0xc0000
 334:	b01f8713          	addi	a4,t6,-1279
 338:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 33c:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 340:	fe079ce3          	bnez	a5,338 <main+0x208>
 344:	00500793          	li	a5,5
 348:	e59ff06f          	j	1a0 <main+0x70>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);
 34c:	30338737          	lui	a4,0x30338
            switch (j)
 350:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);
 354:	c00002b7          	lui	t0,0xc0000
 358:	e7b70713          	addi	a4,a4,-389 # 30337e7b <_stack_size+0x30337a7b>
 35c:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 360:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 364:	fe079ce3          	bnez	a5,35c <main+0x22c>
 368:	00400793          	li	a5,4
 36c:	e35ff06f          	j	1a0 <main+0x70>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x0030337e);
 370:	00303737          	lui	a4,0x303
            switch (j)
 374:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x0030337e);
 378:	c00002b7          	lui	t0,0xc0000
 37c:	37e70713          	addi	a4,a4,894 # 30337e <_stack_size+0x302f7e>
 380:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 384:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 388:	fe079ce3          	bnez	a5,380 <main+0x250>
 38c:	00300793          	li	a5,3
 390:	e11ff06f          	j	1a0 <main+0x70>
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x00003033);
 394:	00003737          	lui	a4,0x3
            switch (j)
 398:	350e8793          	addi	a5,t4,848
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x00003033);
 39c:	c00002b7          	lui	t0,0xc0000
 3a0:	03370713          	addi	a4,a4,51 # 3033 <_stack_size+0x2c33>
 3a4:	00e2a023          	sw	a4,0(t0) # c0000000 <__global_pointer$+0x7ffff800>
                break;
 3a8:	fff78793          	addi	a5,a5,-1
        for (int i = 0; i < 50000; i++)
 3ac:	fe079ce3          	bnez	a5,3a4 <main+0x274>
 3b0:	00200793          	li	a5,2
 3b4:	dedff06f          	j	1a0 <main+0x70>

000003b8 <irqCallback>:
    }
}

void irqCallback()
{
 3b8:	00008067          	ret
 3bc:	01bc                	addi	a5,sp,200
 3be:	0000                	unimp
 3c0:	0394                	addi	a3,sp,448
 3c2:	0000                	unimp
 3c4:	0370                	addi	a2,sp,396
 3c6:	0000                	unimp
 3c8:	034c                	addi	a1,sp,388
 3ca:	0000                	unimp
 3cc:	032c                	addi	a1,sp,392
 3ce:	0000                	unimp
 3d0:	0308                	addi	a0,sp,384
 3d2:	0000                	unimp
 3d4:	02e4                	addi	s1,sp,332
 3d6:	0000                	unimp
 3d8:	02c0                	addi	s0,sp,324
 3da:	0000                	unimp
 3dc:	029c                	addi	a5,sp,320
 3de:	0000                	unimp
 3e0:	0280                	addi	s0,sp,320
 3e2:	0000                	unimp
 3e4:	0264                	addi	s1,sp,268
 3e6:	0000                	unimp
 3e8:	0248                	addi	a0,sp,260
 3ea:	0000                	unimp
 3ec:	022c                	addi	a1,sp,264
 3ee:	0000                	unimp
 3f0:	0210                	addi	a2,sp,256
 3f2:	0000                	unimp
 3f4:	01f4                	addi	a3,sp,204
 3f6:	0000                	unimp
 3f8:	01d8                	addi	a4,sp,196
	...
