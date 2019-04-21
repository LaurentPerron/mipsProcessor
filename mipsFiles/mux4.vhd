library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity mux4 is
  generic (width: integer)
  port(d0, d1, d2, d3: in STD_LOGIC_VECTOR(width-1 downto 0);
       s:              in STD_LOGIC_VECTOR(width- 1 downto 0);
       y:              in STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture struct of mux4 is
  component mux2
    generic (width: integer)
    port (d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
          s: in STD_LOGIC;
          y: out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  signal low, high: STD_LOGIC_VECTOR(1 downto 0);
begin
  lowmux: mux2 port map(d0, d1, s(0), low);
  highmux: mux2 port map(d2, d3, s(0), high);
  finalmux: mux2 port map(low, high, s(1), y);
end;
