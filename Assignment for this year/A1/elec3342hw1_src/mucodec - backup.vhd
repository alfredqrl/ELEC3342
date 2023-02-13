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
use ieee.std_logic_arith.all;


entity mucodec is
    port (
        din     : IN std_logic_vector(2 downto 0);
        valid   : IN std_logic;
        clr     : IN std_logic := '0';
        clk     : IN std_logic;
        dout    : OUT std_logic_vector(7 downto 0);
        dvalid  : OUT std_logic;
        error   : OUT std_logic);
end mucodec;

architecture Behavioral of mucodec is
    type state_type is (St_RESET, St_ERROR, BOSA, BOSB, BOSC, EOSA, EOSB, EOSC, EXECUTEA, EXECUTEB);
    signal state, next_state : state_type := St_RESET;
    signal siga : std_logic_vector(2 downto 0):= "000";
    signal sigb : std_logic_vector(2 downto 0):= "111";

    
    -- Define additional signal needed here as needed
begin
    sync_process: process (clk, clr)
    begin
       
        if clr = '1' then
            state <= St_RESET;
        elsif rising_edge(clk) then
            state <= next_state;

        end if;
    end process;
    
    signal_apply : process (din, siga, sigb, clk, state)
    
    begin 
        if rising_edge(clk) then
            if (valid = '1') then
            case (state) is
                when(EXECUTEA)=>
                    siga <= din;
                when(EXECUTEB)=>
                    sigb <= din;
                when others=>
        end case;
        end if;
        end if;
    end process;

    state_logic: process (state, din, siga, sigb, valid)
        
    begin
         
        -- Next State Logic
        -- Complete the following:
        next_state <= state;
        if (valid ='1') then
        --state <= St_RESET;
        case(state) is
            when St_RESET =>
                report "dqedw";
                
                if din = "000" then
                    report "woshiyuanzhenghaobaba";
                    next_state <= BOSA;
--                else 
--                    next_state <= St_RESET;
                end if;
            when BOSA =>
            
                if din = "111" then
                    report "BOSA";
                    next_state <= BOSB;
--                else 
--                    next_state <= St_RESET;
                end if;
            when BOSB =>
                if din = "000" then
                    report "BOSB";
                    next_state <= BOSC;
--                else 
--                    next_state <= St_RESET;
                end if;
            when BOSC =>
                if din = "111" then
                    report "BOSC";
                    next_state <= EXECUTEA;
--                else 
--                    next_state <= St_RESET;
                    
                end if;
                
--           when BOSD =>
--                report "BOSD";
--                next_state <= EXECUTEA;
            
           when EXECUTEA =>
            -- todo: bjd lol
                report "EXCUTA";
   
                if din = "111" then
                    report "111222";
                    next_state <= EOSA;
                elsif din = "000" then
                    report "000";
                    next_state <= St_ERROR;
                elsif siga = sigb then
                    next_state <= St_ERROR;
                else 
                    report "else";
                    next_state <= EXECUTEB;
                    
                end if;
                
            
            when EXECUTEB =>
                if din = "000" or din = "111" then
                    report "000 or 111";
                    next_state <= St_ERROR;
                else
                    report "else1";
                end if;
                    
                --if siga = sigb then
                    --eport "siga = sigb";
                    --next_state <= St_ERROR;
                --else
                    --report "Else2";
                    next_state <= EXECUTEA;
                --end if;
                
            when EOSA =>
                if din = "000" then
                    report "000/";
                    next_state <= EOSB;
                else
                    report "Else/";
                    next_state <= St_ERROR;
                end if;
            when EOSB =>
                if din = "111" then
                    report "111//";
                    next_state <= EOSC;
                else
                    report "Else//";
                    next_state <= St_ERROR;
                end if;
            when EOSC =>
                if din = "000" then
                    report "000///";
                    next_state <= St_RESET;
                else
                    report "Else///";
                    next_state <= St_ERROR;
                end if;

            -- Put your code here
            when St_ERROR =>
                report "ERROR";
                next_state <= St_RESET;

            when others =>
           

        end case;
        end if;
    end process;

    output_logic: process (state, din,siga, sigb)
    
    
    begin
      -- Put your code here
      if state = St_ERROR then
        error <= '1';
      else
        error <='0';
      end if;
      case (state) is
        --when St_ERROR =>
            --error <= '1';
        when EXECUTEB =>
            dout <= "00000000";
            --if (valid = '1') then
            --dvalid <= '0';
                if din = "000" then
                    dvalid <= '0';
                elsif din = "111" then
                    dvalid <= '0';
            else 
                dvalid <= '1';
                --siga <= din;
            --end if;
            end if;
            
        when EXECUTEA =>
            --if (valid = '1') then
            if din = "000" or din = "111" then
                dvalid <= '0';
            else 
                --sigb <= din;
            end if;
            if siga = sigb then
                dvalid <= '0';
            else
                dvalid <= '1';
                case (siga) is
                        when "001" =>
                            case (sigb) is 
                                when "010" =>
                                    dout <= "01000001";
                                when "011" =>
                                    dout <= "01000010";
                                when "100" =>
                                    dout <= "01000011";
                                when "101" =>
                                    dout <= "01000100";
                                when "110" =>
                                    dout <= "01000101";
                                when others =>
                            end case;
                        when "010" =>
                            case (sigb) is 
                                when "001" =>
                                    dout <= "01000110";
                                when "011" =>
                                    dout <= "01000111";
                                when "100" =>
                                    dout <= "01001000";
                                when "101" =>
                                    dout <= "01001001";
                                when "110" =>
                                    dout <= "01001010";
                                when others =>
                            end case;
                        when "011" =>
                            case (sigb) is 
                                when "001" =>
                                    dout <= "01001011";
                                when "010" =>
                                    dout <= "01001100";
                                when "100" =>
                                    dout <= "01001101";
                                when "101" =>
                                    dout <= "01001110";
                                when "110" =>
                                    dout <= "01001111";
                                when others =>
                            end case;
                        when "100" =>
                            case (sigb) is 
                                when "001" =>
                                    dout <= "01010000";
                                when "010" =>
                                    dout <= "01010001";
                                when "011" =>
                                    dout <= "01010010";
                                when "101" =>
                                    dout <= "01010011";
                                when "110" =>
                                    dout <= "01010100";
                                when others =>
                            end case;
                        when "101" =>
                            case (sigb) is 
                                when "001" =>
                                    dout <= "01010101";
                                when "010" =>
                                    dout <= "01010110";
                                when "011" =>
                                    dout <= "01010111";
                                when "100" =>
                                    dout <= "01011000";
                                when "110" =>
                                    dout <= "01011001";
                                when others =>
                            end case;
                        when "110" =>
                            case (sigb) is
                                when "001" =>
                                    dout <= "01011010";
                                when "010" =>
                                    dout <= "00100001";
                                when "011" =>
                                    dout <= "00101110";
                                when "100" =>
                                    dout <= "00111111";
                                when "101" =>
                                    dout <= "00100000";
                                when others =>
                            end case;
                       when others=>
                       end case;
  
             end if;
        
        --end if;
    when others =>   
    end case;
    end process;


end Behavioral;