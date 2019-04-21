library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD_LOGIC_UNSIGNED.all;

entity mux8 is
  generic (width: integer)
  port(d0,d1,d2,d3,d4,d5,d6,d7    : in STD_LOGIC_VECTOR (width- 1 downto 0);
       s        : in STD_LOGIC_VECTOR (width- 2 downto 0);
       y        : out STD_LOGIC_VECTOR (width- 1 downto 0));
end;

architecture struct of mux8 is
  component   mux4
    generic (width: integer)
    port(d0, d1, d2, d3: in STD_LOGIC_VECTOR(width-1 downto 0);
         s:              in STD_LOGIC_VECTOR(width- 1 downto 0);
         y:              in STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  component  mux2 is -- two-input multiplexer
    generic (width: integer);
    port (d0, d1: in STD_LOGIC_VECTOR(width-1 downto 0);
          s: in STD_LOGIC;
          y: out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  signal low, high : STD_LOGIC_VECTOR (1 downto 0);
begin
  lowmux: mux4 port map(d0, d1, d2, d3, s(1 downto 0), low);
  highmux: mux4 port map(d4, d5, d6, d7 s(1 downto 0), high);
  finalmux: mux2 port map(low, high, s(2), y);
end;

