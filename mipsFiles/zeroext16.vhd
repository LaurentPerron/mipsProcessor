library IEEE; use IEEE.STD_LOGIC_1164.all;

entity zeroext16 is -- zero extender
  port(	a: in STD_LOGIC_VECTOR (15 downto 0);
        y: out STD_LOGIC_VECTOR (31 downto 0));
end;

architecture behave of zeronext16 is -- adds 16 bits
begin
  y <= X"0000" & a; -- Doesn't mind of sign of argument
end;
