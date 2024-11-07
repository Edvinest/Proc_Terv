----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2024 02:43:10 PM
-- Design Name: 
-- Module Name: PortLogic_0 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PortLogic_0 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           PortID_dir : in STD_LOGIC_VECTOR (7 downto 0);
           PortID_indir : in STD_LOGIC_VECTOR (7 downto 0);
           PortDataIn : in STD_LOGIC_VECTOR (15 downto 0);
           PortID_sel : in STD_LOGIC;
           IORD : in STD_LOGIC;
           IOWR : in STD_LOGIC;
           DataOutX : in STD_LOGIC_VECTOR (15 downto 0);
           PortID : out STD_LOGIC_VECTOR (7 downto 0);
           PortDataOut : out STD_LOGIC_VECTOR (15 downto 0);
           Rd_strobe : out STD_LOGIC;
           Wr_strobe : out STD_LOGIC;
           PortIntoCPU : out STD_LOGIC_VECTOR (15 downto 0));
end PortLogic_0;

architecture Behavioral of PortLogic_0 is

signal counter : integer range 0 to 2 := 0;

begin

PortID <= PortID_dir when PortID_sel = '0' else PortID_indir;

process(clk, reset, IORD, IOWR)
begin
    if reset = '1' or IOWR = '0' or IOWR = '0' then
        counter <= 0;
    else
        if falling_edge(clk) then
            if counter < 2 then
                counter <= counter + 1;
            else 
                counter <= 0;
            end if;
        end if;
    end if;
end process;

process(clk, reset, counter ,IORD, IOWR)

    begin        
        if reset = '1' then
            PortDataOut <= (others => '0');
            PortIntoCPU <= (others => '0');
            
        else
            if falling_edge(clk) then
                if IORD = '1' and IOWR = '0' then
                    case counter is
                        when 0 =>
                            null;
                        when 1 =>
                            Rd_strobe <= '1';
                        when 2 =>
                            PortIntoCPU <= PortDataIn;
                        end case;
                elsif IORD = '0' then
                        Rd_strobe <= '0';
                end if;
                
                if IORD = '0' and IOWR = '1' then
                    case counter is        
                        when 0 =>
                            null;
                        when 1 =>
                            PortDataOut <= DataOutX;
                        when 2 =>
                            Wr_strobe <= '1';
                        end case;
                elsif IOWR = '0' then
                        Wr_strobe <= '0';
                end if;
            end if;
        end if;
        
end process;
end Behavioral;
