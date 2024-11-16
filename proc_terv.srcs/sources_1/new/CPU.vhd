----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2024 05:39:39 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
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
           Interrupt_Address : out STD_LOGIC_VECTOR (11 downto 0));
end CPU;

architecture Behavioral of CPU is

component RegBlock
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           SX_addr : in STD_LOGIC_VECTOR (3 downto 0);
           SY_addr : in STD_LOGIC_VECTOR (3 downto 0);
           Dataxin : in STD_LOGIC_VECTOR (15 downto 0);
           RW : in STD_LOGIC;
           DataoutX : out STD_LOGIC_VECTOR (15 downto 0);
           DataoutY : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component DataMem_0
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           DataoutX : in STD_LOGIC_VECTOR (15 downto 0);
           DmemAddr_dir : in STD_LOGIC_VECTOR (5 downto 0);
           DmemAddr_indir : in STD_LOGIC_VECTOR (5 downto 0);
           SelAddr : in STD_LOGIC;
           MR : in STD_LOGIC;
           MW : in STD_LOGIC;
           DataMemOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component IFDEC 
    Port ( reset : in STD_LOGIC;
           Instr_Phase : in STD_LOGIC_VECTOR (2 downto 0);
           Instruction : in STD_LOGIC_VECTOR (17 downto 0);
           Sx_Addr : out STD_LOGIC_VECTOR (3 downto 0);
           Sy_Addr : out STD_LOGIC_VECTOR (3 downto 0);
           DMemAddr_dir : out STD_LOGIC_VECTOR (5 downto 0);
           ENInterrupt : out STD_LOGIC;
           PortID_dir : out STD_LOGIC_VECTOR (7 downto 0);
           Branch_Addr : out STD_LOGIC_VECTOR (11 downto 0);
           AL_Instr_Ext : out STD_LOGIC_VECTOR (3 downto 0);
           KK_const : out STD_LOGIC_VECTOR (7 downto 0);
           Instr_code : out STD_LOGIC_VECTOR (5 downto 0));
end component;

component ALU_0
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           OP1 : in STD_LOGIC_VECTOR (15 downto 0);
           OP2 : in STD_LOGIC_VECTOR (15 downto 0);
           Instr_code : in STD_LOGIC_VECTOR (5 downto 0);
           Al_Instr_Ext : in STD_LOGIC_VECTOR (3 downto 0);
           KK_Const : in STD_LOGIC_VECTOR (7 downto 0);
           Execute : in STD_LOGIC;
           Carry : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALU_Result : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component PFC
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
end component;

component PortLogic_0
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
end component;

    -- Shared signal declarations across components with the same name
    signal SxAddr           : STD_LOGIC_VECTOR(3 downto 0);
    signal SyAddr           : STD_LOGIC_VECTOR(3 downto 0);
    signal RW               : STD_LOGIC;
    signal Data_Out_x       : STD_LOGIC_VECTOR(15 downto 0);
    signal Data_Out_y       : STD_LOGIC_VECTOR(15 downto 0);
    signal PortID_dir       : STD_LOGIC_VECTOR(7 downto 0);
    signal PortID_indir     : STD_LOGIC_VECTOR(7 downto 0);
    signal PortID_sel       : STD_LOGIC;
    signal IORD             : STD_LOGIC;
    signal IOWR             : STD_LOGIC;
    signal DataOutX         : STD_LOGIC_VECTOR(15 downto 0);
    signal Rd_strobe        : STD_LOGIC;
    signal Wr_strobe        : STD_LOGIC;
    signal PortIntoCPU      : STD_LOGIC_VECTOR(15 downto 0);
    signal Instr_code       : STD_LOGIC_VECTOR(5 downto 0);
    signal Branch_addr      : STD_LOGIC_VECTOR(11 downto 0);
    signal Carry            : STD_LOGIC;
    signal Zero             : STD_LOGIC;
    signal En_Intr          : STD_LOGIC;
    signal Instr_phase      : STD_LOGIC_VECTOR(2 downto 0);
    signal Execute          : STD_LOGIC;
    signal Int_Ack          : STD_LOGIC;
    signal Mux_Sel          : STD_LOGIC_VECTOR(2 downto 0);
    signal Sel_Addr         : STD_LOGIC;
    signal KK_const         : STD_LOGIC_VECTOR(7 downto 0);
    signal DMemAddr_dir     : STD_LOGIC_VECTOR(5 downto 0);
    signal Instr_addr       : STD_LOGIC_VECTOR(11 downto 0);
    signal DataMemOut       : STD_LOGIC_VECTOR(15 downto 0);
    signal AL_Instr_Ext     : STD_LOGIC_VECTOR(3 downto 0);
    signal ALU_Result       : STD_LOGIC_VECTOR(15 downto 0);


begin

    -- RegisterBlock instance
    RegisterBlock_inst: RegBlock
        port map (
            Clk => clk,
            Reset => Reset,
            Dataxin => PortDataIn,
            SX_addr => SxAddr,
            SY_addr => SyAddr,
            RW => RW,
            DataoutX => Data_Out_x,
            DataoutY => Data_Out_y
        );

    -- PortLogic instance
    PortLogic_inst: PortLogic_0
        port map (
            clk => clk,
            reset => Reset,
            PortID_dir => PortID_dir,
            PortID_indir => PortID_indir,
            PortDataIn => PortDataIn,
            PortID_sel => PortID_sel,
            IORD => IORD,
            IOWR => IOWR,
            DataOutX => DataOutX,
            PortID => PortID,
            PortDataOut => PortDataOut,
            Rd_strobe => Rd_strobe,
            Wr_strobe => Wr_strobe,
            PortIntoCPU => PortIntoCPU
        );

    -- PFC instance
    PFC_inst: PFC
        port map (
            clk => clk,
            reset => Reset,
            Instr_code => Instr_code,
            Branch_addr => Branch_addr,
            Int_req => interrupt,
            Carry => Carry,
            Zero => Zero,
            En_Intr => En_Intr,
            Instr_phase => Instr_phase,
            Execute => Execute,
            Int_Ack => Int_Ack,
            Mux_Sel => Mux_Sel,
            Sel_Addr => Sel_Addr,
            PortId_Sel => PortID_sel,
            RW => RW,
            Mrd => IORD,
            Mwr => IOWR,
            IOrd => IORD,
            IOwr => IOWR,
            Instr_addr => Instr_addr
        );

    -- Mux instance
    Mux_inst: DxInMux
        port map (
            MUX_Sel => Mux_Sel,
            DataMemOut => DataMemOut,
            PortIntoCPU => PortIntoCPU,
            ALUresult => ALU_Result,
            KK_const => KK_const,
            DataOut_Y => Data_Out_y,
            DataOutMUX => PortDataOut
        );

    -- IfAndDec instance
    IfAndDec_inst: IFDEC
        port map (
            reset => Reset,
            Instr_Phase => Instr_phase,
            Instruction => instruction,
            SX_Addr => SxAddr,
            SY_Addr => SyAddr,
            DMemAddr_dir => DMemAddr_dir,
            ENInterrupt => En_Intr,
            Instr_code => Instr_code,
            PortID_dir => PortID_dir,
            Branch_Addr => Branch_addr,
            AL_Instr_Ext => AL_Instr_Ext,
            KK_const => KK_const
        );

    -- DataMemory instance
    DataMemory_inst: DataMem_0
        port map (
            Clk => clk,
            reset => Reset,
            DataOutX => Data_Out_x,
            DataOutY => DMemAddr_dir,
            DMemAdd_Dir => DMemAddr_dir,
            SelAddr => Sel_Addr,
            MRd => IORD,
            MWr => IOWR,
            DataMemOut => DataMemOut
        );

    -- ALU instance
    ALU_inst: ALU_0
        port map (
            clk => clk,
            reset => Reset,
            OP1 => Data_Out_x,
            OP2 => Data_Out_y,
            Instr_code => Instr_code,
            Al_Instr_Ext => AL_Instr_Ext,
            KK_const => KK_const,
            Execute => Execute,
            Carry => Carry,
            Zero => Zero,
            ALU_Result => ALU_Result
        );


end Behavioral;
