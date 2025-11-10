// Мова: Verilog
// Автор Лук'яненко Вадим
// Завдання: Лабораторна робота, Варіант 18 (SPI Master) [cite: 49]


/*
 * =======================================================================
 * Модуль: spi_master
 * -----------------------------------------------------------------------
 * Опис:
 * Реалізує логіку SPI Master-пристрою (Варіант 18).
 * Працює в режимі 0 (CPOL=0, CPHA=0).
 * Генерує тактові імпульси (o_sck) та керує потоком даних[cite: 26].
 * =======================================================================
 */
module spi_master (
    /* * --- Порти ---
     * Всі порти описані згідно вимог до коментування.
     */
    
    // --- Системні сигнали ---
    input wire i_clk,       // Головний тактовий сигнал (високошвидкісний)
    input wire i_rst_n,     // Асинхронний активний низький ресет

    // --- Інтерфейс керування ---
    input wire        i_start_tx, // Вхідний сигнал "Старт" для початку транзакції
    input wire [7:0]  i_tx_data,  // Вхідні 8-бітні дані для відправки
    output reg        o_tx_done,  // Вихідний прапор: "Готово" (транзакція завершена)
    output reg [7:0]  o_rx_data,  // Вихідні 8-бітні дані, що були отримані

    // --- SPI фізичні лінії ---
    output reg o_sck,       // Вихід: SPI Clock (генерується модулем)
    output reg o_mosi,      // Вихід: Master Out Slave In
    input wire i_miso,       // Вхід: Master In Slave Out
    output reg o_ss         // Вихід: Slave Select
);

    /*
     * --- Внутрішні регістри та параметри --- 
     */

    // --- Параметри FSM (Діаграма станів) ---
    // Описують 5 станів нашої FSM [cite: 21]
    localparam S_IDLE       = 3'b000; // 0: Очікування
    localparam S_DATA_SETUP = 3'b001; // 1: Підготовка біта (виставити MOSI)
    localparam S_CLK_HIGH   = 3'b010; // 2: SCK = 1 (Slave читає)
    localparam S_CLK_LOW    = 3'b011; // 3: SCK = 0 (Master читає, зсув)
    localparam S_DONE       = 3'b100; // 4: Завершення

    // --- Внутрішні регістри ---
    reg [2:0] state;          // Регістр для зберігання поточного стану FSM
    reg [7:0] tx_shift_reg;   // Регістр зсуву для передачі (Tx)
    reg [7:0] rx_shift_reg;   // Регістр зсуву для прийому (Rx)
    reg [2:0] bit_counter;    // Лічильник бітів (від 7 до 0)
    
    /*
     * --- Логічний блок FSM --- 
     * Реалізує поведінкову модель FSM, описану на Етапі 1.
     */
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Асинхронне скидання (ресет)
            state          <= S_IDLE;
            o_sck          <= 1'b0; // CPOL=0
            o_ss           <= 1'b1; // SS неактивний
            o_mosi         <= 1'b0;
            o_tx_done      <= 1'b0;
            bit_counter    <= 3'd7;
            tx_shift_reg   <= 8'd0;
            rx_shift_reg   <= 8'd0;
            o_rx_data      <= 8'd0;
        end else begin
            // Синхронна логіка по i_clk
            o_tx_done <= 1'b0; // Скидаємо прапор "Готово" за замовчуванням

            case (state)
                // Стан 1: Очікування [cite: 21]
                S_IDLE: begin
                    o_sck <= 1'b0; // CPOL=0
                    o_ss  <= 1'b1; // SS неактивний
                    
                    if (i_start_tx) begin
                        o_ss         <= 1'b0; // Активуємо Slave
                        tx_shift_reg <= i_tx_data;  // Завантажуємо дані
                        bit_counter  <= 3'd7;      // Скидаємо лічильник (8 біт)
                        rx_shift_reg <= 8'd0;      // Чистимо регістр прийому
                        state        <= S_DATA_SETUP; // Переходимо до відправки
                    end
                end

                // Стан 2: Підготовка біта [cite: 21]
                S_DATA_SETUP: begin
                    o_sck  <= 1'b0;
                    o_mosi <= tx_shift_reg[7]; // Виставляємо старший біт
                    state  <= S_CLK_HIGH;
                end

                // Стан 3: SCK Високий (Slave читає) [cite: 21]
                S_CLK_HIGH: begin
                    o_sck <= 1'b1;
                    // У цей момент (posedge sck) Slave читає o_mosi
                    state <= S_CLK_LOW;
                end
                
                // Стан 4: SCK Низький (Master читає, зсув) [cite: 21]
                S_CLK_LOW: begin
                    o_sck <= 1'b0;
                    
                    // 1. Читаємо MISO (CPHA=0, читаємо на другому фронті, тобто negedge)
                    rx_shift_reg <= {rx_shift_reg[6:0], i_miso};
                    
                    // 2. Зсуваємо регістр передачі (Tx)
                    tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                    
                    // 3. Зменшуємо лічильник
                    bit_counter <= bit_counter - 1;

                    if (bit_counter == 3'd0) begin
                        state <= S_DONE; // Всі 8 біт передано
                    end else begin
                        state <= S_DATA_SETUP; // Йдемо на наступний біт
                    end
                end

                // Стан 5: Завершення [cite: 21]
                S_DONE: begin
                    o_ss      <= 1'b1; // Деактивуємо Slave
                    o_sck     <= 1'b0;
                    o_tx_done <= 1'b1; // Встановлюємо прапор "Готово"
                    o_rx_data <= rx_shift_reg; // Виставляємо прийняті дані
                    state     <= S_IDLE; // Повертаємось в очікування
                end
                
                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
