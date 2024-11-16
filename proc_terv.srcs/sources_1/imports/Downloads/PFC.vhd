----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:36 11/21/2019 
-- Design Name: 
-- Module Name:    PFC - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PFC is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Instr_code : in  STD_LOGIC_VECTOR (5 downto 0);
           Branch_addr : in  STD_LOGIC_VECTOR (11 downto 0);
           Int_req : in  STD_LOGIC;
           Carry : in  STD_LOGIC;
           Zero : in  STD_LOGIC;
           En_Intr : in  STD_LOGIC;
           Instr_phase : out  STD_LOGIC_VECTOR (2 downto 0);
           Execute : out  STD_LOGIC;
           Int_Ack : out  STD_LOGIC;
           Mux_Sel : out  STD_LOGIC_VECTOR (2 downto 0);
           Sel_Addr : out  STD_LOGIC;
           PortId_Sel : out  STD_LOGIC;
           RW : out  STD_LOGIC;
           Mrd : out  STD_LOGIC;
           Mwr : out  STD_LOGIC;
           IOrd : out  STD_LOGIC;
           IOwr : out  STD_LOGIC;
           Instr_addr : out  STD_LOGIC_VECTOR (11 downto 0));
end PFC;

architecture Behavioral of PFC is

signal JUMPstatus : std_logic;
signal CALLstatus : std_logic;
signal RETURNstatus : std_logic;
signal INTstatus : std_logic;
signal intreset : std_logic;

signal phasenum : std_logic_vector (2 downto 0);
type stack is array (31 downto 0) of std_logic_vector (11 downto 0);

signal branchvalue : std_logic_vector(7 downto 0);


begin

branchvalue <= Instr_code&carry&zero;

branchstatus: process (branchvalue, clk, reset)
begin
	if reset = '1' then
		JUMPstatus <= '0';
		CALLstatus <= '0';
		Returnstatus <= '0';
	elsif clk'event and clk ='1' then
		case (branchvalue) is
		when "11001001" => -- jump z
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0'; 
		when "11001011" => -- jump z
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0'; 
		when "11011010" => -- jump nz
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0'; 
		when "11011000" => -- jump nz
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0'; 
		when "11101011" => -- jump c
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0';
		when "11101010" => -- jump c
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0';
		when "11111001" => -- jump nc
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0';
		when "11111000" => -- jump nc
			JUMPstatus <= '1';
			CALLstatus <= '0';
			Returnstatus <= '0';
		
		when "11000001" => -- call z
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0'; 
		when "11000011" => -- call z
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0'; 
		when "11010010" => -- call nz
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0'; 
		when "11010000" => -- call nz
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0'; 
		when "11100011" => -- call c
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0';
		when "11100010" => -- call c
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0';
		when "11110001" => -- call nc
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0';
		when "11110000" => -- call nc
			JUMPstatus <= '0';
			CALLstatus <= '1';
			Returnstatus <= '0';	
			
		when "11000101" => -- return z
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1'; 
		when "11000111" => -- return z
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1'; 
		when "11010110" => -- return nz
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1'; 
		when "11010100" => -- return nz
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1'; 
		when "11100111" => -- return c
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1';
		when "11100110" => -- return c
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1';
		when "11110101" => -- return nc
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1';
		when "11110100" => -- return nc
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '1';	
		
		when others =>
			JUMPstatus <= '0';
			CALLstatus <= '0';
			Returnstatus <= '0';	
			case (branchvalue(7 downto 2)) is
				when "100010" => -- jump
					JUMPstatus <= '1';
					CALLstatus <= '0';
					Returnstatus <= '0';	
				when "100000" => --call
					JUMPstatus <= '0';
					CALLstatus <= '1';
					Returnstatus <= '0';	
				when "100101" => --return 
					JUMPstatus <= '0';
					CALLstatus <= '0';
					Returnstatus <= '1';	
				when "101001" => -- retruni e
					JUMPstatus <= '0';
					CALLstatus <= '0';
					Returnstatus <= '1';	
					
				when others => null;
			end case;
			
		end case;
	end if;
end process;

Int_status : process(clk, reset, Int_req, En_intr,intreset)
begin
	if reset = '1' then
		INTstatus <= '0';
		Int_ack <= '0';
	elsif clk'event and clk = '1' then
		if En_intr = '1' and Int_req = '1' then
			INTstatus <= '1';
			Int_ack <= '1';
		else
			Int_ack <= '0';
			if intreset = '1' then
				INTstatus <= '0';
			end if;
		end if;
	end if;
		
end process;

programflowcontrol : process (clk, reset, JUMPstatus, CALLstatus, RETURNstatus, INTstatus)
variable stackmem : stack := ( others => ( others=>'0' ) );
variable stackpointer : integer range 0 to 31 := 0;
variable programcounter : std_logic_vector(11 downto 0) := x"000";
begin
	if reset = '1' then
		stackmem := ( others => ( others => '0' ) );
		stackpointer := 0;
		programcounter := x"000";
	elsif clk'event and clk = '0' then
		if phasenum = "001" then
			programcounter := programcounter+1;
			
			if jumpstatus = '1' then
				programcounter := Branch_addr;
			end if;
			
			if CALLstatus = '1' then
				stackmem(stackpointer):=programcounter;
				programcounter := Branch_addr;
				stackpointer := stackpointer + 1;
			end if;
			
			if RETURNstatus = '1' then
				stackpointer := stackpointer - 1;
				programcounter := stackmem(stackpointer);
			end if;
			
			if INTstatus = '1' then
				stackmem(stackpointer):=programcounter;
				stackpointer := stackpointer + 1;
				programcounter := x"3ff";
				intreset <= '1';
			else
				intreset <= '0';
			end if;
		
			
		end if;
	end if;
	instr_addr <= programcounter;
	
end process;

instrphasecounter: process (clk, reset,phasenum)
begin
	if reset = '1' then
		phasenum <= "000";
	elsif clk'event and clk = '0' then
		if phasenum < "110" then 
			phasenum <= phasenum + 1;
		else
			phasenum <= "000";
		end if;
	end if;
	instr_phase <= phasenum;
end process;

controlsiggenerator : process (clk, reset, phasenum, instr_code)
begin

	if reset = '1' then
		mux_sel <= "000";
		execute <= '0';
		sel_addr <= '0';
		portid_sel <= '0';
		rw <= '0';
		mrd <= '0';
		mwr <= '0';
		iord <= '0';
		iowr <= '0';
	elsif clk'event and clk = '1' then
		case (instr_code) is
			when "000001" => -- LOAD sx, kk
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "011";
					when "010" => rw <= '1';
					when "011" => rw <= '0';
					when "100" => null;
					when "101" => null;
					when others => null;
				end case;
				
			when "000000" => --LOAD sx, sy
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "100";
					when "010" => rw <= '1';
					when "011" => rw <= '0';
					when "100" => null;
					when "101" => null;
					when others => null;
				end case;
				
			when "000010" | "000100" | "000110" | "001100" | "010000" | "010010" | "011000" | "011010" => --AND, OR, XOR, MULT8, ADD, ADDCY, SUB, SUBCY sx, sy
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "010";
					when "010" => execute <= '1';
					when "011" => execute <= '0';
					when "100" => rw <= '1'; 
					when "101" => rw <= '0';
					when others => null;
				end case;
				
			when "000011" | "000101" | "000111" | "001101" | "010001" | "010011" | "011001" | "011011" | "010100"=> --AND, OR, XOR, MULT8, ADD, ADDCY, SUB, SUBCY SS sx, kk
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "010";
					when "010" => execute <= '1';
					when "011" => execute <= '0';
					when "100" => rw <= '1';
					when "101" => rw <= '0';
					when others => null;
				end case;
						
			when "001001" =>--INPUT sx, PP
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "001"; portid_sel <= '0'; iord <= '1';
					when "010" => iord <= '1';
					when "011" => iord <= '1';
					when "100" => rw <= '1'; iord <= '0';
					when "101" => rw <= '0';
					when others => null;
				end case;
				
			when "001000" => --INPUT sx, sy
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "001"; portid_sel <= '1'; iord <= '1';
					when "010" => iord <= '1';
					when "011" => iord <= '1';
					when "100" => rw <= '1'; iord <= '0';
					when "101" => rw <= '0';
					when others => null;
				end case;
			
			when "101101" =>--OUTPUT sx, PP
				case (phasenum) is
					when "000" => null;
					when "001" => portid_sel <= '0'; iowr <= '1';
					when "010" => iowr <= '1';
					when "011" => iowr <= '1';
					when "100" => iowr <= '0';
					when "101" => null;
					when others => null;
				end case;
				
			when "101100" => --OUTPUT sx, sy
				case (phasenum) is
					when "000" => null;
					when "001" => portid_sel <= '1'; iowr <= '1';
					when "010" => iowr <= '1';
					when "011" => iowr <= '1';
					when "100" => iowr <= '0';
					when "101" => null;
					when others => null;
				end case;
			
			when "001011" => --FETCH cx, sa
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "000"; sel_addr<= '0';
					when "010" => mrd <= '1'; mwr <= '0';
					when "011" => mrd <= '0'; mwr <= '0';
					when "100" => rw <= '1';
					when "101" => rw <= '0';
					when others => null;
				end case;
				
			when "001010" => --FETCH sx, sy
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "000"; sel_addr<= '1';
					when "010" => mrd <= '1'; mwr <= '0';
					when "011" => mrd <= '0'; mwr <= '0';
					when "100" => rw <= '1';
					when "101" => rw <= '0';
					when others => null;
				end case;
			
			when "101111" => --STORE cx, sa
				case (phasenum) is
					when "000" => null;
					when "001" => sel_addr<= '0';
					when "010" => mrd <= '0'; mwr <= '1';
					when "011" => mrd <= '0'; mwr <= '0';
					when "100" => null;
					when "101" => null;
					when others => null;
				end case;
			
			when "101110" => --STORE sx, sy
				case (phasenum) is
					when "000" => null;
					when "001" => sel_addr<= '1';
					when "010" => mrd <= '0'; mwr <= '1';
					when "011" => mrd <= '0'; mwr <= '0';
					when "100" => null;
					when "101" => null;
					when others => null;
				end case;
			
			when "011101" => --COMP sx, kk
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "010";
					when "010" => execute <= '1';
					when "011" => execute <= '0';
					when "100" => null;
					when "101" => null;
					when others => null;
				end case;

			
			when "011100" => --COMP sx, sy
				case (phasenum) is
					when "000" => null;
					when "001" => mux_sel <= "010";
					when "010" => execute <= '1';
					when "011" => execute <= '0';
					when "100" => null;
					when "101" => null;
					when others => null;
				end case;
			
			when others =>
				mux_sel <= "000";
				execute <= '0';
				sel_addr <= '0';
				portid_sel <= '0';
				rw <= '0';
				mrd <= '0';
				mwr <= '0';
				iord <= '0';
				iowr <= '0';
		end case;
	end if;
end process;


end Behavioral;

