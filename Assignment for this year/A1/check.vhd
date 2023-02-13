library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;


entity chkdiv3_tb is
end chkdiv3_tb;


architecture tb of chkdiv3_tb is
    component chkdiv3 is
        port (
            n : in std_logic_vector(4 downto 0);
            d : out std_logic);
    end component chkdiv3;

    signal n : std_logic_vector(4 downto 0);
    signal d : std_logic;
    signal test_value : integer;
    signal d_error : std_logic;
    signal sim_finish : std_logic;

begin
    cd3 : chkdiv3 port map(n, d);
    n <= std_logic_vector(to_unsigned(test_value, 5));
    d_error <= (d xor '1') when ( (test_value mod 3) = 0 ) else (d xor '0');
    sim_finish <= '1' when n = "11111" else '0';

    process begin
        for i in 0 to 31 loop
            test_value <= i;
            wait for 10 ns;
        end loop;
        finish;
    end process;
end tb;