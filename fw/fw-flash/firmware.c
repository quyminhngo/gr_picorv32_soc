#include <stdint.h>
#include <stdbool.h>

// a pointer to this is a null pointer, but the compiler does not
// know that because "sram" is a linker symbol from sections.lds.
extern uint32_t sram;

typedef struct
{
    volatile uint32_t DATA;
    volatile uint32_t CLKDIV;
} PICOUART;

typedef struct
{
    union
    {
        volatile uint32_t REG;
        volatile uint16_t IOW;
        struct
        {
            volatile uint8_t IO;
            volatile uint8_t OE;
            volatile uint8_t CFG;
            volatile uint8_t EN;
        };
    };
} PICOQSPI;

#define io_read(base_addr, offset) (*((base_addr) + (offset)))
#define io_write(base_addr, offset, data) (*((base_addr) + (offset)) = data)

#define QSPI0 ((PICOQSPI *)0x81000000)

/* GPIO*/
#define GPIO_BASE_ADDR ((volatile uint32_t *)0x82000000)
#define GPIO_OE_OFFSET 0
#define GPIO_IE_OFFSET 1
#define GPIO_DATA_OFFSET 2

#define FLASHIO_ENTRY_ADDR ((void *)0x80000054)
void (*spi_flashio)(uint8_t *pdata, int length, int wren) = FLASHIO_ENTRY_ADDR;

/* UART Driver*/
#define UART0 ((PICOUART *)0x83000000)
int putchar(int c)
{
    if (c == '\n')
        UART0->DATA = '\r';
    UART0->DATA = c;

    return c;
}

void print(const char *p)
{
    while (*p)
        putchar(*(p++));
}

void print_hex(uint32_t v, int digits)
{
    for (int i = 7; i >= 0; i--)
    {
        char c = "0123456789abcdef"[(v >> (4 * i)) & 15];
        if (c == '0' && i >= digits)
            continue;
        putchar(c);
        digits = i;
    }
}

void print_dec(uint32_t v)
{
    if (v >= 100)
    {
        print(">=100");
        return;
    }

    if (v >= 90)
    {
        putchar('9');
        v -= 90;
    }
    else if (v >= 80)
    {
        putchar('8');
        v -= 80;
    }
    else if (v >= 70)
    {
        putchar('7');
        v -= 70;
    }
    else if (v >= 60)
    {
        putchar('6');
        v -= 60;
    }
    else if (v >= 50)
    {
        putchar('5');
        v -= 50;
    }
    else if (v >= 40)
    {
        putchar('4');
        v -= 40;
    }
    else if (v >= 30)
    {
        putchar('3');
        v -= 30;
    }
    else if (v >= 20)
    {
        putchar('2');
        v -= 20;
    }
    else if (v >= 10)
    {
        putchar('1');
        v -= 10;
    }

    if (v >= 9)
    {
        putchar('9');
        v -= 9;
    }
    else if (v >= 8)
    {
        putchar('8');
        v -= 8;
    }
    else if (v >= 7)
    {
        putchar('7');
        v -= 7;
    }
    else if (v >= 6)
    {
        putchar('6');
        v -= 6;
    }
    else if (v >= 5)
    {
        putchar('5');
        v -= 5;
    }
    else if (v >= 4)
    {
        putchar('4');
        v -= 4;
    }
    else if (v >= 3)
    {
        putchar('3');
        v -= 3;
    }
    else if (v >= 2)
    {
        putchar('2');
        v -= 2;
    }
    else if (v >= 1)
    {
        putchar('1');
        v -= 1;
    }
    else
        putchar('0');
}

char getchar_prompt(char *prompt)
{
    int32_t c = -1;

    uint32_t cycles_begin, cycles_now, cycles;
    __asm__ volatile("rdcycle %0" : "=r"(cycles_begin));

    if (prompt)
        print(prompt);

    // if (prompt)
    // GPIO0->OUT = ~0;
    // reg_leds = ~0;

    while (c == -1)
    {
        __asm__ volatile("rdcycle %0" : "=r"(cycles_now));
        cycles = cycles_now - cycles_begin;
        if (cycles > 12000000)
        {
            if (prompt)
                print(prompt);
            cycles_begin = cycles_now;
            // if (prompt)
            // GPIO0->OUT = ~GPIO0->OUT;
            // reg_leds = ~reg_leds;
        }
        c = UART0->DATA;
    }
    // if (prompt)
    // GPIO0->OUT = 0;
    // reg_leds = 0;
    return c;
}

char getchar()
{
    return getchar_prompt(0);
}

#define QSPI_REG_CRM 0x00100000
#define QSPI_REG_DSPI 0x00400000

void cmd_set_crm(int on)
{
    if (on)
    {
        QSPI0->REG |= QSPI_REG_CRM;
    }
    else
    {
        QSPI0->REG &= ~QSPI_REG_CRM;
    }
}

int cmd_get_crm()
{
    return QSPI0->REG & QSPI_REG_CRM;
}

void cmd_set_dspi(int on)
{
    if (on)
    {
        QSPI0->REG |= QSPI_REG_DSPI;
    }
    else
    {
        QSPI0->REG &= ~QSPI_REG_DSPI;
    }
}

int cmd_get_dspi()
{
    return QSPI0->REG & QSPI_REG_DSPI;
}

void cmd_read_flash_id()
{
    int pre_dspi = cmd_get_dspi();

    cmd_set_dspi(0);

    uint8_t buffer[4] = {0x9F, /* zeros */};
    spi_flashio(buffer, 4, 0);

    for (int i = 1; i <= 3; i++)
    {
        putchar(' ');
        print_hex(buffer[i], 2);
    }
    putchar('\n');

    cmd_set_dspi(pre_dspi);
}

// --------------------------------------------------------

uint32_t cmd_benchmark(bool verbose, uint32_t *instns_p)
{
    uint8_t data[256];
    uint32_t *words = (void *)data;

    uint32_t x32 = 314159265;

    uint32_t cycles_begin, cycles_end;
    uint32_t instns_begin, instns_end;
    __asm__ volatile("rdcycle %0" : "=r"(cycles_begin));
    __asm__ volatile("rdinstret %0" : "=r"(instns_begin));

    for (int i = 0; i < 20; i++)
    {
        for (int k = 0; k < 256; k++)
        {
            x32 ^= x32 << 13;
            x32 ^= x32 >> 17;
            x32 ^= x32 << 5;
            data[k] = x32;
        }

        for (int k = 0, p = 0; k < 256; k++)
        {
            if (data[k])
                data[p++] = k;
        }

        for (int k = 0, p = 0; k < 64; k++)
        {
            x32 = x32 ^ words[k];
        }
    }

    __asm__ volatile("rdcycle %0" : "=r"(cycles_end));
    __asm__ volatile("rdinstret %0" : "=r"(instns_end));

    if (verbose)
    {
        print("Cycles: 0x");
        print_hex(cycles_end - cycles_begin, 8);
        putchar('\n');

        print("Instns: 0x");
        print_hex(instns_end - instns_begin, 8);
        putchar('\n');

        print("Chksum: 0x");
        print_hex(x32, 8);
        putchar('\n');
    }

    if (instns_p)
        *instns_p = instns_end - instns_begin;

    return cycles_end - cycles_begin;
}
void cmd_benchmark_all()
{
    uint32_t instns = 0;

    print("default        ");

    cmd_set_dspi(0);
    cmd_set_crm(0);

    print(": ");
    print_hex(cmd_benchmark(false, &instns), 8);
    putchar('\n');

    print("dspi-");
    print_dec(0);
    print("         ");

    cmd_set_dspi(1);

    print(": ");
    print_hex(cmd_benchmark(false, &instns), 8);
    putchar('\n');

    print("dspi-crm-");
    print_dec(0);
    print("     ");

    cmd_set_crm(1);

    print(": ");
    print_hex(cmd_benchmark(false, &instns), 8);
    putchar('\n');

    print("instns         : ");
    print_hex(instns, 8);
    putchar('\n');
}

volatile int i;
// --------------------------------------------------------

#define CLK_FREQ 25175000
#define UART_BAUD 115200

// LED MUX
#define LED_MUX_BASE ((volatile uint32_t *)0xC0000000)
#define LED_MUX_DATA_OFFSET 0
//   -- a --
//  |       |
//  f       b
//  |       |
//   -- g --
//  |       |
//  e       c  ---
//  |       |  -d-
//   -- d --   ---

//     +----+------------------------------|------|
//     | Số| d - a - b - c - d - e - f - g | Hex  |
//     +----+-- -- -- -- -- -- -- -- -- -- + ---- +
//     | 0 | 0 - 1 - 1 - 1 - 1 - 1 - 1 - 0 | 0x7E | 0
//     | 1 | 0 - 0 - 1 - 1 - 0 - 0 - 0 - 0 | 0x30 | 1
//     | 2 | 0 - 1 - 1 - 0 - 1 - 1 - 0 - 1 | 0x6D | 2
//     | 3 | 0 - 1 - 1 - 1 - 1 - 0 - 0 - 1 | 0x79 | 3
//     | 4 | 0 - 0 - 1 - 1 - 0 - 0 - 1 - 1 | 0x33 | 4
//     | 5 | 0 - 1 - 0 - 1 - 1 - 0 - 1 - 1 | 0x5B | 5
//     | 6 | 0 - 1 - 0 - 1 - 1 - 1 - 1 - 1 | 0x5F | 6
//     | 7 | 0 - 1 - 1 - 1 - 0 - 0 - 0 - 0 | 0x70 | 7
//     | 8 | 0 - 1 - 1 - 1 - 1 - 1 - 1 - 1 | 0x7F | 8
//     | 9 | 0 - 1 - 1 - 1 - 0 - 0 - 1 - 1 | 0x7B | 9
//     +----+-- -- -- -- -- -- -- -- -- -- + ---- +
// 0000 1000
//  abc defg
// 0111 1011

int main()
{
    io_write(GPIO_BASE_ADDR, GPIO_OE_OFFSET, 0x3F);
    io_write(GPIO_BASE_ADDR, GPIO_IE_OFFSET, 0x00);
    io_write(GPIO_BASE_ADDR, GPIO_DATA_OFFSET, 0x15);
    io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);

    int j = 0;
    while (1)
    {
        /* code */
        for (int i = 0; i < 50000; i++)
        {
            // io_write(GPIO_BASE_ADDR, GPIO_DATA_OFFSET, 0x00);
            switch (j)
            {
            case 0:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x00000030);
                break;
            case 1:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x00003033);

                break;
            case 2:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x0030337e);

                break;
            case 3:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);
                break;
            case 4:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x337e7b01);
                break;
            case 5:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7e7b0101);
                break;
            case 6:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b010101);
                break;
            case 7:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x01010101);
                break;
            case 8:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x0101016d);
                break;
            case 9:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x01016d33);

                break;
            case 10:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x016d337e);

                break;
            case 11:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d337e7b);

                break;
            case 12:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x337e7b6d);

                break;
            case 13:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7e7b6d7e);

                break;
            case 14:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x7b6d7e7e);

                break;
            case 15:
                io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x6d7e7e79);

                break;
            default:
                j = 0;
                break;
            }
            // io_write(LED_MUX_BASE, LED_MUX_DATA_OFFSET, 0x30337e7b);
        }
        j++;
    }
}

void irqCallback()
{
}