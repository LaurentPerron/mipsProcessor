library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
	port (op: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
			branch: out STD_LOGIC;
      alusrc: out STD_LOGIC_VECTOR(2 downto 0);
                                     -- AluSRC est devenue sur 3 bits au lieu
                                     -- de 1. à changer dans l'ensemble des
                                     -- parties qui l'utilise. Équivaut à rajouter
                                     -- des 0 partout
			regdst: out STD_LOGIC_VECTOR (1 downto 0);
      regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR (1 downto 0);
			aluop: out STD_LOGIC_VECTOR (1 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(8 downto 0); -- length = 9 + 2 + 1 + 1
begin                                            -- length = 13
process(op) begin
	case op is
		when "000000" => controls <= "110000010"; -- Rtyp \ A conserver ?
		when "100011" => controls <= "101001000"; -- LW
		when "101011" => controls <= "001010000"; -- SW
		when "000100" => controls <= "000100001"; -- BEQ
		when "001000" => controls <= "101000000"; -- ADDI
		when "000010" => controls <= "000000100"; -- J
    when "001000" => controls <=            ; -- andi
    when "000000" => controls <=            ; -- jr \ meme op que R-type
    when "000011" => controls <=            ; -- jal
    when "001111" => controls <=            ; -- lui
    when "001101" => controls <=            ; -- ori
    when "000000" => controls <=            ; -- sll \ meme op que R-type
    when "000010" => controls <=            ; -- srl
    when "001010" => controls <=            ; -- slti
		when others => controls <= "---------"; -- illegal op
	end case;
end process;

	regwrite <= controls(8);
	regdst <= controls(7); -- deviendra 2 bits
	alusrc <= controls(6); -- deviendra 3 bits
	branch <= controls(5);
	memwrite <= controls(4);
	memtoreg <= controls(3);
	jump <= controls(2);  -- deviendra 2 bits
	aluop <= controls(1 downto 0);
end;
