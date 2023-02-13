----------------------------------------------------------------------------------
-- Company: Computer Architecture and System Research (CASR), HKU
-- Engineer: Jiajun Wu
-- 
-- Create Date: 09/09/2022 06:20:56 PM
-- Design Name: system top
-- Module Name: top - Behavioral
-- Project Name: Music Decoder
-- Target Devices: Xilinx Basys3
-- Tool Versions: Vivado 2022.1
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY symb_det IS
    PORT (
        clk : IN STD_LOGIC; -- input clock 96kHz
        clr : IN STD_LOGIC; -- input synchronized reset
        adc_data : IN STD_LOGIC_VECTOR(11 DOWNTO 0); -- input 12-bit ADC data
        symbol_valid : OUT STD_LOGIC;
        symbol_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- output 3-bit detection symbol
        data_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END symb_det;

ARCHITECTURE Behavioral OF symb_det IS
    -- define your signals here
    SIGNAL last_data : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
    SIGNAL gate : STD_LOGIC := '0';
    SIGNAL chk : STD_LOGIC;
    SIGNAL clk_count : unsigned(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tmp : STD_LOGIC;
    SIGNAL total_count : unsigned(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    tmp <= '1' WHEN (clk_count = x"00000000") ELSE
        '0';
    -- handle the case in detect new wave

    proc_sample_wava : PROCESS (clk, gate, last_data, adc_data, total_count)
    BEGIN
        IF (clr = '0') THEN
            IF rising_edge(clk) THEN
                IF (clk_count = x"00000000") THEN
                    total_count <= (OTHERS => '0');
                    gate <= '0';
                ELSIF (clk_count = x"0000176F") THEN
                    total_count <= (OTHERS => '0');

                ELSE
                    IF (gate = '0') THEN

                        IF (last_data(11) = '0') THEN
                            IF (adc_data(11) = '1') THEN
                                gate <= '1';
                                total_count <= total_count + 1;
                            END IF;
                        END IF;

                    ELSIF (gate = '1') THEN
                        IF (last_data(11) = '0') THEN
                            IF (adc_data(11) = '1') THEN
                                gate <= '0';
                                total_count <= total_count + 1;
                            END IF;
                        END IF;
                    END IF;
                    --last_data <= adc_data;
                END IF;
            END IF;
        ELSE
            total_count <= (OTHERS => '0');
            gate <= '0';
            -- last_data <= (OTHERS => '0');
        END IF;
    END PROCESS proc_sample_wava;

    proc_change_last_to_current : PROCESS (clk, clr, last_data, adc_data)
    BEGIN
        IF (clr = '1') THEN
            last_data <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            last_data <= adc_data;
        END IF;

    END PROCESS proc_change_last_to_current;

    -- handle the case when gate eqauls to 1, the clk_count ++
    proc_add_counter : PROCESS (clk, gate, last_data, adc_data)
    BEGIN
        IF (clr = '0') THEN
            IF rising_edge(clk) THEN
                -- if (gate = '1') then
                --if (last_data(11) = '0') then
                --if (adc_data(11) = '1') then
                --clk_count <= clk_count + 1;
                --end if;   
                --end if; 
                -- end if;
                IF (clk_count = x"0000176F") THEN
                    clk_count <= (OTHERS => '0');
                ELSE
                    clk_count <= clk_count + 1;
                END IF;
            END IF;
        ELSE
            clk_count <= (OTHERS => '0');
        END IF;

    END PROCESS proc_add_counter;

    proc_valid : PROCESS (clk, clk_count)
    BEGIN
        IF rising_edge(clk) THEN
            IF (clk_count = x"0000176F") THEN
                symbol_valid <= '1';
            ELSE
                symbol_valid <= '0';
            END IF;
        END IF;

    END PROCESS proc_valid;
    -- frequency measurement using zero crossing detection
    proc_p2n : PROCESS (clk, total_count, clk_count)
    BEGIN
        IF rising_edge(clk) THEN
            IF (clk_count = x"0000176F") THEN
                --report "cao";
                --cycle_count := cycle_count / 2;
                --symbol_valid <= '0';
                IF (total_count > 31) AND (total_count < 35) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "000";

                ELSIF (total_count > 39) AND (total_count < 43) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "001";

                ELSIF (total_count > 47) AND (total_count < 51) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "010";

                ELSIF (total_count > 60) AND (total_count < 64) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "011";

                ELSIF (total_count > 71) AND (total_count < 75) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "100";

                ELSIF (total_count > 85) AND (total_count < 89) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "101";

                ELSIF (total_count > 107) AND (total_count < 111) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "110";

                ELSIF (total_count > 128) AND (total_count < 132) THEN
                    --symbol_valid <= '1';
                    symbol_out <= "111";
                    --ELSE
                    --report "taz";
                    --symbol_valid <= '0';

                END IF;

            END IF;
        END IF;

    END PROCESS proc_p2n;

    -- generate enable signals based on 16Hz symbol rate
    proc_16hz_enable : PROCESS (clk)

    BEGIN
    END PROCESS proc_16hz_enable;

    --output the detected symbols based on 16 Hz rate

END Behavioral;