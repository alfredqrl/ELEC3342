library ieee;
use ieee.std_logic_1164.all;
entity chkdiv3 is
port (
    n : in std_logic_vector(4 downto 0);
    d : out std_logic);
end chkdiv3;
architecture rtl of chkdiv3 is
begin
    d <= ( (not n(0)) and (not n(1)) and (not n(2)) and (not n(3)) and (not n(4)) ) or
    ( (not n(0)) and (not n(1)) and (not n(2)) and n(3) and n(4) ) or
    ( (not n(0)) and (not n(1)) and n(2) and n(3) and (not n(4)) ) or
    ( (not n(0)) and n(1) and (not n(2)) and (not n(3)) and n(4) ) or
    ( (not n(0)) and n(1) and n(2) and (not n(3)) and (not n(4)) ) or
    ( (not n(0)) and n(1) and n(2) and n(3) and n(4) ) or
    ( n(0) and (not n(1)) and (not n(2)) and n(3) and (not n(4)) ) or
    ( n(0) and (not n(1)) and n(2) and (not n(3)) and n(4) ) or
    ( n(0) and n(1) and (not n(2)) and (not n(3)) and (not n(4)) ) or
    ( n(0) and n(1) and (not n(2)) and n(3) and n(4) ) or
    ( n(0) and n(1) and n(2) and n(3) and (not n(4)) );
end rtl;