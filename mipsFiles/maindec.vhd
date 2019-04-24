library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
	port (op: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
			branch: out STD_LOGIC;
      alusrc: out STD_LOGIC_VECTOR(1 downto 0);
                                     -- AluSRC est devenue sur 2 bits au lieu
                                     -- de 1. à changer dans l'ensemble des
                                     -- parties qui l'utilise. Équivaut à rajouter
                                     -- des 0 partout
			regdst: out STD_LOGIC_VECTOR (1 downto 0);
      regwrite: out STD_LOGIC;
			jump: out STD_LOGIC_VECTOR (1 downto 0);
			aluop: out STD_LOGIC_VECTOR (2 downto 0));
end;

architecture behave of maindec is
	signal controls: STD_LOGIC_VECTOR(8 downto 0); -- length = 9 + 1 + 1 + 1 + 1
begin                                            -- length = 13
process(op) begin
	case op is
		when "000000" => controls <= "1010000000111"; -- Rtyp \ jr, sll, srl
		when "100011" => controls <= "1000100100000"; -- LW
		when "101011" => controls <= "0100101000000"; -- SW
		when "000100" => controls <= "0110010100001"; -- BEQ
		when "001000" => controls <= "1000100000000"; -- ADDI
		when "000010" => controls <= "0110010101000"; -- J
    when "001000" => controls <= "1001000000010"; -- andi
    when "000011" => controls <= "1100000001111"; -- jal
    when "001111" => controls <= "1001100000000"; -- lui
    when "001101" => controls <= "1000100000011"; -- ori
    when "001010" => controls <= "1000100000110"; -- slti
		when others => controls <= "---------"; -- illegal op
	end case;
end process;

	regwrite <= controls(12);
	regdst <= controls(11 downto 10); -- deviendra 2 bits
	alusrc <= controls(9 downto 8); -- deviendra 2 bits
	branch <= controls(7);
	memwrite <= controls(6);
	memtoreg <= controls(5);
	jump <= controls(4 downto 3);  -- deviendra 2 bits
	aluop <= controls(2 downto 0); -- deviendra 3 bits
end;
