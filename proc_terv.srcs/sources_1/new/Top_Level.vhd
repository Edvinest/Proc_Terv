----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2024 03:51:44 PM
-- Design Name: 
-- Module Name: Top_Level - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_Level is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (3 downto 0));
end Top_Level;

architecture Behavioral of Top_Level is

component CPU
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           PortDataIn : in STD_LOGIC_VECTOR (15 downto 0);
           Interrupt : in STD_LOGIC;
           Instruction : in STD_LOGIC_VECTOR (17 downto 0);
           PortDataOut : out STD_LOGIC_VECTOR (15 downto 0);
           PortID : out STD_LOGIC_VECTOR (7 downto 0);
           ReadStrobe : out STD_LOGIC;
           WriteStrobe : out STD_LOGIC;
           Interrupt_acknowledge : out STD_LOGIC;
           Instruction_Address : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component memoria is
  generic(             C_FAMILY : string := "7S"; 
              C_RAM_SIZE_KWORDS : integer := 2;
           C_JTAG_LOADER_ENABLE : integer := 0);
  Port (      address : in std_logic_vector(11 downto 0);
          instruction : out std_logic_vector(17 downto 0);
               enable : in std_logic;
                  rdl : out std_logic;                    
                  clk : in std_logic);
  end component;

signal PortDataIn : std_logic_vector (15 downto 0);
signal PortDataOut : std_logic_vector (15 downto 0);
signal Instruction : std_logic_vector (17 downto 0);
signal Port_ID : std_logic_vector (7 downto 0);
signal Read_strobe : std_logic;
signal Write_strobe : std_logic;
signal Instruction_Address : std_logic_vector(11 downto 0);

begin

process(clk, Write_strobe, Port_ID)
    begin
        if clk'event and clk='1' then
            if Write_strobe = '1' and Port_ID=x"06" then
                led <= PortDataOut(3 downto 0);
            end if;
        end if;
end process;

process(clk, Read_strobe, Port_ID)
    begin
        if clk'event and clk = '1' then
            if Read_strobe = '1' and Port_ID=x"05" then
                PortDataIn <= "000000000000"&btn;
            end if;
        end if;
end process;


processzor : CPU
    Port Map(
           clk => clk,
           reset => reset,
           PortDataIn => PortDataIn,
           Interrupt => '0',
           Instruction => Instruction,
           PortDataOut => PortDataOut,
           PortID => Port_ID,
           ReadStrobe => Read_strobe,
           WriteStrobe => Write_strobe,
           Interrupt_acknowledge => open,
           Instruction_Address => Instruction_Address
    );
    
mem: memoria
  generic map(             
           C_FAMILY => "7S", 
           C_RAM_SIZE_KWORDS => 2,
           C_JTAG_LOADER_ENABLE => 0)
  Port map(      
          address => Instruction_Address,
          instruction => Instruction,
               enable => '1',
                  rdl => open,                   
                  clk => clk
);


end Behavioral;
