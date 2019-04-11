library IEEE; use IEEE.STD_LOGIC_1164.all;

entity zeroext5 is -- zero extender
  port(	a: in STD_LOGIC_VECTOR (4 downto 0);
        y: out STD_LOGIC_VECTOR (31 downto 0));
end;

architecture behave of zeronext5 is -- Adds 27 bits
begin
  y <= X"000000" & "000" & a; -- Doesn't mind of sign of argument
end;
