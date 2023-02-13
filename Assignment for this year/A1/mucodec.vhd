----------------------------------------------------------------------------------
-- Course: ELEC3342
-- Module Name: mucodec - Behavioral
-- Project Name: Template for Music Code Decoder for Homework 1
-- Created By: hso
--
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

entity mucodec is
    port (
        din     : IN std_logic_vector(2 downto 0);
        valid   : IN std_logic;
        clr     : IN std_logic;
        clk     : IN std_logic;
        dout    : OUT std_logic_vector(7 downto 0);
        dvalid  : OUT std_logic;
        error   : OUT std_logic);
end mucodec;

architecture Behavioral of mucodec is
    type state_type is (St_RESET, St_ERROR, wf2, wf1, B1, B2, B3, E1, E2, E3);
    signal state, next_state : state_type := St_RESET;
    signal digit1, digit2: std_logic_vector(2 downto 0);
    signal output, error_output: std_logic := '0';
    -- Define additional signal needed here as needed
begin
    dvalid<='0';
    sync_process: process (clk, clr)
    begin
        if clr = '1' then
        state<=ST_RESET;
        -- Your code here
        elsif rising_edge(clk) then
          -- Put your code here
        state<=next_state;
        end if;
    end process;

    state_logic: process (state, valid)
    begin
        -- Next State Logic
        -- Complete the following:
        if valid = '1' then
        case(state) is
            when St_RESET =>
            error_output<='0';
            if din = "000" then
                next_state <= B1;
            else
                next_state <= ST_RESET;
            end if;
            when St_ERROR =>
                error_output<='1';
                next_state <= ST_RESET;
            when wf1 =>
                if din = "001" or din = "010" or din = "011" or din = "100" or din = "101" or din = "110" then
                    digit1<=din;
                    next_state <= wf1;
                elsif din = "111" then
                    next_state <= E1;
                else
                    next_state <= ST_ERROR;
                end if;
            when wf2 =>
                if (din = "001" or din = "010" or din = "011" or din = "100" or din = "101" or din = "110") and din /=digit1 then
                    digit2<=din;
                    next_state <= wf1;
                    output <= '1';
                else
                    next_state <= ST_ERROR;
                end if;
            when B1 =>
                if din = "111" then
                    next_state <= B2;
                else
                    next_state <= ST_RESET;
                end if;
            when B2 =>
                if din = "000" then
                    next_state <= B3;
                else
                    next_state <= ST_RESET;
                end if;
            when B3 =>
                if din = "111" then
                    next_state <= wf1;
                else
                    next_state <= ST_RESET;
                end if;
            when E1 =>
                if din = "000" then
                    next_state <= E2;
                else
                    next_state <= ST_ERROR;
                end if;
            when E2 =>
                if din = "111" then
                    next_state <= E2;
                else
                    next_state <= ST_ERROR;
                end if;
            when others =>
                if din = "000" then
                    next_state <= ST_RESET;
                else
                    next_state <= ST_ERROR;
                end if;
        end case;
        end if;
    end process;

    output_logic: process (output, error_output)
    begin
        if output='1' then
            case digit1 is
                when "001" =>
                case digit2 is
                    when "010" =>
                    dout <= "01000001";
                    when "011" =>
                    dout <= "01000010";
                    when "100" =>
                    dout <= "01000011";
                    when "101" =>
                    dout <= "01000100";
                    when others =>
                    dout <= "01000101";
                end case;
                when "010" =>
                case digit2 is
                    when "001" =>
                    dout <= "01000110";
                    when "011" =>
                    dout <= "01000111";
                    when "100" =>
                    dout <= "01001000";
                    when "101" =>
                    dout <= "01001001";
                    when others =>
                    dout <= "01001010";
                end case;
                when "011" =>
                case digit2 is
                    when "001" =>
                    dout <= "01001011";
                    when "010" =>
                    dout <= "01001100";
                    when "100" =>
                    dout <= "01001101";
                    when "101" =>
                    dout <= "01001110";
                    when others =>
                    dout <= "01001111";
                end case;
                when "100" =>
                case digit2 is
                    when "001" =>
                    dout <= "01010000";
                    when "010" =>
                    dout <= "01010001";
                    when "011" =>
                    dout <= "01010010";
                    when "101" =>
                    dout <= "01010011";
                    when others =>
                    dout <= "01010100";
                end case;
                when "101" =>
                case digit2 is
                    when "001" =>
                    dout <= "01010101";
                    when "010" =>
                    dout <= "01010110";
                    when "011" =>
                    dout <= "01010111";
                    when "100" =>
                    dout <= "01011000";
                    when others =>
                    dout <= "01011001";
                end case;
                when others =>
                case digit2 is
                    when "001" =>
                    dout <= "01011010";
                    when "010" =>
                    dout <= "00100001";
                    when "011" =>
                    dout <= "00101110";
                    when "100" =>
                    dout <= "00111111";
                    when others =>
                    dout <= "00100000";
                end case;
            end case;
            output<='0';
            dvalid<='1';
        elsif error_output='1' then
            error<='1';
        elsif error_output='0' then
            error<='0';
        
        end if;
    end process;


end Behavioral;
