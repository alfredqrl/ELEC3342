LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY lock IS
    PORT (
        btn1 : IN STD_LOGIC;
        btn2 : IN STD_LOGIC;
        btn3 : IN STD_LOGIC;
        engage : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        locked : OUT STD_LOGIC;
        error : OUT STD_LOGIC);
END lock;

ARCHITECTURE rtl OF lock IS
    TYPE state_type IS (s_open, s_engaged, s_ok1, s_ok2, s_ok3, s_error);
    SIGNAL state, next_state : state_type;
BEGIN

    SYNC_PROC : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            if clr = '1' then
                state <= s_engaged;
                
                
            else
                state <= next_state;
            end if;
        END IF;
    END PROCESS;

    NEXT_STATE_DECODE : PROCESS (state, btn1, btn2, btn3, engage)
    BEGIN
        next_state <= state;
        case state is
            when s_open =>
                if (engage = '1') then
                    next_state <= s_engaged;
                else
                    next_state <= s_open;
                end if;
            when s_engaged =>
                if (btn1 = '1' and btn2 = '0' and btn3 = '0') then
                    next_state <= s_ok1;
                else
                    if (btn1 = '0' and btn2 = '0' and btn3 = '0') then
                        next_state <= s_engaged;
                    else
                        next_state <= s_error;
                    end if;
                end if;    
            when s_ok1 =>
                if (btn1 = '0' and btn2 = '0' and btn3 = '1') then
                    next_state <= s_ok2;
                else
                    if (btn1 = '0' and btn2 = '0' and btn3 = '0') then
                        next_state <= s_ok1;
                    else
                        next_state <= s_error;
                    end if;
                end if;  
            when s_ok2 =>
                if (btn1 = '0' and btn2 = '1' and btn3 = '0') then
                    next_state <= s_ok3;
                else
                    if (btn1 = '0' and btn2 = '0' and btn3 = '0') then
                        next_state <= s_ok2;
                    else
                        next_state <= s_error;
                    end if;
                end if;
            when s_ok3 => 
                if (btn1 = '1' and btn2 = '0' and btn3 = '0') then
                    next_state <= s_open;
                else
                    if (btn1 = '0' and btn2 = '0' and btn3 = '0') then
                        next_state <= s_ok3;
                    else
                        next_state <= s_error;
                    end if;
                end if;
            when s_error =>
                if (btn1 = '1' and btn2 = '0' and btn3 = '1') then
                    next_state <= s_engaged;
                else
                    next_state <= s_error;
                end if;
            when others =>
                
        
        end case;
    END PROCESS;

    OUTPUT_DECODE : PROCESS (state)
    BEGIN
        case state is
            when s_error =>
                locked <= '1';
                error <= '1';
            when s_open =>
                locked <= '0';
                error <= '0';
            when others =>
                locked <= '1';
                error <= '0';
        end case;
    END PROCESS;

END rtl;