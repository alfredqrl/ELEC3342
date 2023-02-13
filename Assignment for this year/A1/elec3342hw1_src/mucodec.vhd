----------------------------------------------------------------------------------
-- Course: ELEC3342
-- Module Name: mucodec - Behavioral
-- Project Name: Template for Music Code Decoder for Homework 1
-- Created By: hso
-- Author: Bao Junda, Jiang Feiyu
-- Copyright (C) 2022 Hayden So
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
ENTITY mucodec IS
    PORT (
        din : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        valid : IN STD_LOGIC;
        clr : IN STD_LOGIC := '0';
        clk : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        dvalid : OUT STD_LOGIC;
        error : OUT STD_LOGIC);
END mucodec;

ARCHITECTURE Behavioral OF mucodec IS
    TYPE state_type IS (St_RESET, St_ERROR, BOSA, BOSB, BOSC, EOSA, EOSB, EOSC, EXECUTEA, EXECUTEB);
    SIGNAL state, next_state : state_type := St_RESET;
    SIGNAL siga : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL sigb : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
    SIGNAL out_with : STD_LOGIC := '0';
    -- Define additional signal needed here as needed
BEGIN
    sync_process : PROCESS (clk, clr)
    BEGIN

        IF clr = '1' THEN
            state <= St_RESET;
        ELSIF rising_edge(clk) THEN
            state <= next_state;

        END IF;
    END PROCESS;

    signal_apply : PROCESS (din, siga, sigb, clk, state)

    BEGIN
        IF rising_edge(clk) THEN
            IF (valid = '1') THEN
                CASE (state) IS
                    WHEN(EXECUTEA) =>
                        siga <= din;
                    WHEN(EXECUTEB) =>
                        sigb <= din;
                    WHEN OTHERS =>
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    state_logic : PROCESS (state, din, siga, sigb, valid, out_with)

    BEGIN

        -- Next State Logic
        -- Complete the following:
        next_state <= state;
        IF (valid = '1') THEN
            CASE(state) IS
                WHEN St_RESET =>
                IF din = "000" THEN
                    next_state <= BOSA;
                END IF;
                WHEN BOSA =>
                IF din = "111" THEN
                    next_state <= BOSB;
                END IF;
                WHEN BOSB =>
                IF din = "000" THEN
                    next_state <= BOSC;
                END IF;
                WHEN BOSC =>
                IF din = "111" THEN
                    next_state <= EXECUTEA;
                END IF;
                WHEN EXECUTEA =>
                IF din = "111" THEN
                    next_state <= EOSA;
                ELSIF din = "000" THEN
                    next_state <= St_ERROR;
                ELSIF siga = sigb THEN
                    next_state <= St_ERROR;
                ELSE
                    next_state <= EXECUTEB;
                END IF;

                WHEN EXECUTEB =>
                IF din = "000" OR din = "111" THEN
                    next_state <= St_ERROR;
                ELSE
                    next_state <= EXECUTEA;
                END IF;

                WHEN EOSA =>
                IF din = "000" THEN
                    next_state <= EOSB;
                ELSE
                    next_state <= St_ERROR;
                END IF;
                WHEN EOSB =>
                IF din = "111" THEN
                    next_state <= EOSC;
                ELSE
                    next_state <= St_ERROR;
                END IF;
                WHEN EOSC =>
                IF din = "000" THEN
                    next_state <= St_RESET;
                ELSE
                    next_state <= St_ERROR;
                END IF;

                -- Put your code here
                WHEN St_ERROR =>
                next_state <= St_RESET;

                WHEN OTHERS =>
            END CASE;
        END IF;
    END PROCESS;

    output_logic : PROCESS (state, din, siga, sigb, out_with)
    BEGIN
        -- Put your code here
        IF state = St_ERROR THEN
            error <= '1';
        ELSE
            error <= '0';
        END IF;
        CASE (state) IS
            WHEN EXECUTEB =>
                dout <= "00000000";
                IF din = "000" THEN
                    out_with <= '0';
                ELSIF din = "111" THEN
                    out_with <= '0';
                ELSE
                    --out_with <= '1';
                    out_with <= '1';
                END IF;

            WHEN EXECUTEA =>
                IF din = "000" OR din = "111" THEN
                    out_with <= '0';
                ELSE
                END IF;
                IF siga = sigb THEN
                    out_with <= '0';
                ELSE
                    --out_with <= '1';
                    out_with <= '1';
                    CASE (siga) IS
                        WHEN "001" =>
                            CASE (sigb) IS
                                WHEN "010" =>
                                    dout <= "01000001";
                                WHEN "011" =>
                                    dout <= "01000010";
                                WHEN "100" =>
                                    dout <= "01000011";
                                WHEN "101" =>
                                    dout <= "01000100";
                                WHEN "110" =>
                                    dout <= "01000101";
                                WHEN OTHERS =>
                            END CASE;
                        WHEN "010" =>
                            CASE (sigb) IS
                                WHEN "001" =>
                                    dout <= "01000110";
                                WHEN "011" =>
                                    dout <= "01000111";
                                WHEN "100" =>
                                    dout <= "01001000";
                                WHEN "101" =>
                                    dout <= "01001001";
                                WHEN "110" =>
                                    dout <= "01001010";
                                WHEN OTHERS =>
                            END CASE;
                        WHEN "011" =>
                            CASE (sigb) IS
                                WHEN "001" =>
                                    dout <= "01001011";
                                WHEN "010" =>
                                    dout <= "01001100";
                                WHEN "100" =>
                                    dout <= "01001101";
                                WHEN "101" =>
                                    dout <= "01001110";
                                WHEN "110" =>
                                    dout <= "01001111";
                                WHEN OTHERS =>
                            END CASE;
                        WHEN "100" =>
                            CASE (sigb) IS
                                WHEN "001" =>
                                    dout <= "01010000";
                                WHEN "010" =>
                                    dout <= "01010001";
                                WHEN "011" =>
                                    dout <= "01010010";
                                WHEN "101" =>
                                    dout <= "01010011";
                                WHEN "110" =>
                                    dout <= "01010100";
                                WHEN OTHERS =>
                            END CASE;
                        WHEN "101" =>
                            CASE (sigb) IS
                                WHEN "001" =>
                                    dout <= "01010101";
                                WHEN "010" =>
                                    dout <= "01010110";
                                WHEN "011" =>
                                    dout <= "01010111";
                                WHEN "100" =>
                                    dout <= "01011000";
                                WHEN "110" =>
                                    dout <= "01011001";
                                WHEN OTHERS =>
                            END CASE;
                        WHEN "110" =>
                            CASE (sigb) IS
                                WHEN "001" =>
                                    dout <= "01011010";
                                WHEN "010" =>
                                    dout <= "00100001";
                                WHEN "011" =>
                                    dout <= "00101110";
                                WHEN "100" =>
                                    dout <= "00111111";
                                WHEN "101" =>
                                    dout <= "00100000";
                                WHEN OTHERS =>
                            END CASE;
                        WHEN OTHERS =>
                    END CASE;

                END IF;

            WHEN OTHERS =>
        END CASE;
        if rising_edge (clk) then
            if out_with = '1' then
                out_with <= '0';
        end if;
        end if;
    END PROCESS;

    clear_dvalid: process(clk, out_with)
    begin
        if rising_edge (clk) then
            dvalid <= out_with;
        end if;
    end process;

END Behavioral;