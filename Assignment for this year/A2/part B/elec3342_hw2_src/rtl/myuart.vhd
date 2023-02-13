LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY myuart IS
  PORT (
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wen : IN STD_LOGIC;
    clk : in std_logic;
    clr : in std_logic;
    sout : OUT STD_LOGIC;
    busy : out std_logic );
END myuart;

ARCHITECTURE Behavioral OF myuart IS

  TYPE state_type IS (reset, idle, start, stop, S0, S1, S2, S3, S4, S5, S6, S7);
  SIGNAL state, next_state : state_type;

  SIGNAL counter : INTEGER := 0;
  SIGNAL input : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL flag : STD_LOGIC;
BEGIN
  proc_statereg : PROCESS (clk, clr, wen)
  BEGIN
    IF (clr = '1') THEN
      state <= idle;
      counter <= 0;
    END IF;
    IF (rising_edge(clk)) THEN
      counter <= counter + 1;
      IF (wen = '1') THEN
        state <= start;
      ELSIF (counter MOD 5 = 0) THEN
        state <= next_state;
      END IF;
    END IF;

  END PROCESS;

  

  proc_ns : PROCESS (state, counter, wen)

  BEGIN
    IF (wen = '1') THEN
      FOR i IN 7 DOWNTO 0 LOOP
        input(i) <= din(i);
      END LOOP;
      flag <= '1';
    END IF;
    
    IF (counter MOD 5 = 0) THEN

      CASE state IS
        WHEN idle => next_state <= state;
        WHEN reset => next_state <= idle;
        WHEN start => next_state <= S0;
        WHEN S0 => next_state <= S1;
        WHEN S1 => next_state <= S2;
        WHEN S2 => next_state <= S3;
        WHEN S3 => next_state <= S4;
        WHEN S4 => next_state <= S5;
        WHEN S5 => next_state <= S6;
        WHEN S6 => next_state <= S7;
        WHEN S7 => next_state <= stop;
        WHEN stop =>
          next_state <= idle;
          flag <= '0';
        WHEN OTHERS =>
      END CASE;
    END IF;
  END PROCESS;
  
  proc_output : PROCESS (state)
  BEGIN
    busy <= '1';
    sout <= '1';

    CASE state IS
      WHEN idle =>
        sout <= '1';
        busy <= '0';

      WHEN reset =>
        sout <= '0';
        busy <= '0';

      WHEN start =>
        sout <= '0';

      WHEN S0 =>
        sout <= input(0);

      WHEN S1 =>
        sout <= input(1);

      WHEN S2 =>
        sout <= input(2);

      WHEN S3 =>
        sout <= input(3);

      WHEN S4 =>
        sout <= input(4);

      WHEN S5 =>
        sout <= input(5);

      WHEN S6 =>
        sout <= input(6);

      WHEN S7 =>
        sout <= input(7);

      WHEN stop =>
        sout <= '1';

      WHEN OTHERS =>

    END CASE;
  END PROCESS;
END Behavioral;