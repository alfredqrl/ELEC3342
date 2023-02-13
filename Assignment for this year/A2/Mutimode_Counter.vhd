LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Mutimode_Counter is
    port (
        clk : IN std_logic;
        mode : IN std_logic;
        reset : IN std_logic;
        q : OUT std_logic_vector(9 downto 0)
    );
end entity Mutimode_Counter;

architecture rtl of Mutimode_Counter is
    signal cnt : unsigned(9 downto 0);
begin
    q <= std_logic_vector (cnt); 
    proc_cnt: process(clk, reset)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                cnt <= (others => '0');
            else
                if (mode = '0') then
                    cnt <= cnt + 2;
                elsif (mode = '1') then
                    cnt <= cnt + 1;
                end if;
            end if;
            if (cnt > "1111111111") then 
                cnt <= "0000000000";
            end if;
        end if;
    end process;

end architecture rtl;