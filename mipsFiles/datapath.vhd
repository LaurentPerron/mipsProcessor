library IEEE; use IEEE.STD_LOGIC_1164.all; use
IEEE.STD_LOGIC_ARITH.all;

entity datapath is -- MIPS datapath
	port(	clk, reset: in STD_LOGIC;
			memtoreg, pcsrc: in STD_LOGIC;
			alusrc, regdst: in STD_LOGIC_VECTOR (1 downto 0) ;
			regwrite: in STD_LOGIC;
      jump: in STD_LOGIC_VECTOR (1 downto 0);
			alucontrol: in STD_LOGIC_VECTOR (5 downto 0);
			zero, overflow: out STD_LOGIC;
			pc: buffer STD_LOGIC_VECTOR (31 downto 0);
			instr: in STD_LOGIC_VECTOR(31 downto 0); -- 32 bits instruction
			aluout, writedata: buffer STD_LOGIC_VECTOR (31 downto 0); -- output
			readdata: in STD_LOGIC_VECTOR(31 downto 0));
end;

architecture struct of datapath is
	component alu
		port(	a, b: in STD_LOGIC_VECTOR(31 downto 0);
        f: in STD_LOGIC_VECTOR (5 downto 0);
        shamt: in STD_LOGIC_VECTOR (4 downto 0);
				z, o : out STD_LOGIC;
				y: buffer STD_LOGIC_VECTOR(31 downto 0));
	end component;
	component regfile
		port(	clk: in STD_LOGIC;
				we3: in STD_LOGIC;
				ra1, ra2, wa3: in STD_LOGIC_VECTOR (4 downto 0);
				wd3: in STD_LOGIC_VECTOR (31 downto 0);
				rd1, rd2: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component adder
		port(	a, b: in STD_LOGIC_VECTOR (31 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component sl2
		port(	a: in STD_LOGIC_VECTOR (31 downto 0);
				y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	component signext
		port(	a: in STD_LOGIC_VECTOR (15 downto 0);
          y: out STD_LOGIC_VECTOR (31 downto 0));
	end component;
  component zeroext16 is
      port(	a: in STD_LOGIC_VECTOR (15 downto 0);
            y: out STD_LOGIC_VECTOR (31 downto 0));
    end component;
	component flopr generic (width: integer);
		port(	clk, reset: in STD_LOGIC;
				d: in STD_LOGIC_VECTOR (width-1 downto 0);
				q: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	component mux2 generic (width: integer);
		port(	d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
				s: in STD_LOGIC;
				y: out STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
  component mux4 is
    generic (width: integer)
      port(d0, d1, d2, d3: in STD_LOGIC_VECTOR(width-1 downto 0);
           s:              in STD_LOGIC_VECTOR(1 downto 0);
           y:              in STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
	signal writereg, ra, nullreg: STD_LOGIC_VECTOR (4 downto 0);
	signal pcjump, pcnext, pcnextbr, pcplus4, pcbranch: STD_LOGIC_VECTOR (31 downto 0);
	signal signimm, signimmsh, zeroimm, upperimm: STD_LOGIC_VECTOR (31 downto 0);
	signal srca, srcb, result: STD_LOGIC_VECTOR (31 downto 0);

begin
-- next PC logic
	pcjump <= pcplus4 (31 downto 28) & instr (25 downto 0) & "00";
-- return register logic
  ra <= "11111";
	pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc);
	pcadd1: adder port map(pc, X"00000004", pcplus4);
	immsh: sl2 port map(signimm, signimmsh);
	pcadd2: adder port map(pcplus4, signimmsh, pcbranch);
	pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, pcsrc, pcnextbr);
  -- pcmux changed
	pcmux: mux4 generic map(32) port map(pcnextbr, pcjump, srca, X"00000000", jump, pcnext); --mux4
  -- new pcplus4 mux for jal instruction
  jalmux: mux4 generic map(32) port map(result, pcplus4, X"00000000", X"00000000", jump, writereg);
-- register file logic
	rf: regfile port map(clk, regwrite, instr(25 downto 21),instr(20 downto 16), writereg, result, srca, writedata);
  -- write register mux changed
	wrmux: mux4 generic map(5) port map(instr(20 downto 16),instr(15 downto 11), ra, nullreg, regdst, writereg); --mux4
	resmux: mux2 generic map(32) port map(aluout, readdata, memtoreg, result);
	se: signext port map(instr(15 downto 0), signimm);
  ze: zeroext16 port map(instr(15 downto 0), zeroimm);
  lui: sl2 port map(signimm, upperimm);
-- ALU logic
  -- alucontrol mux changed
	srcbmux: mux4 generic map (32) port map(writedata, signimm, zeroimm, upperim, alusrc, srcb); --mux4
	mainalu: alu port map(srca, srcb, alucontrol, instr(10 downto 6), zero, overflow, aluout);
end;
