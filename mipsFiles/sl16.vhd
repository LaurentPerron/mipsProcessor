library IEEE; use IEEE.STD_LOGIC_1164.all;

entity sl16 is -- shift left by 16
  port (a: in STD_LOGIC_VECTOR (31 downto 0);
        y: out STD_LOGIC_VECTOR (31 downto 0));
end;

architecture behave of sl16 is
begin
  y <= a(15 downto 0) & X"0000";
end;
