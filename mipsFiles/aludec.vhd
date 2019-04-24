library IEEE; use IEEE.STD_LOGIC_1164.all;

entity aludec is -- ALU control decoder
	port (funct: in STD_LOGIC_VECTOR (5 downto 0);
			aluop: in STD_LOGIC_VECTOR (2 downto 0);
			alucontrol: out STD_LOGIC_VECTOR (5 downto 0));
end;

architecture behave of aludec is
begin
process (aluop, funct) begin
	case aluop is
		when "000" => alucontrol <= "100000"; -- add (for 1b/sb/addi)
		when "001" => alucontrol <= "100010"; -- sub (for beq)
    when "010" => alucontrol <= "001000"; -- and
    when "011" => alucontrol <= "100101"; -- or
    when "100" => alucontrol <= "100110"; -- xor
    when "101" => alucontrol <= "100111"; -- nor
    when "110" => alucontrol <= "101010"; -- SLT
		when others => alucontrol <= funct; -- R-type instructions
	end case;
end process;
end;
