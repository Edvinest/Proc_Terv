LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IFDEC_tb IS
-- Testbench has no ports
END IFDEC_tb;

ARCHITECTURE Behavioral OF IFDEC_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT IFDEC
    PORT(
        reset          : IN  std_logic;
        Instr_Phase    : IN  std_logic_vector(2 downto 0);
        Instruction    : IN  std_logic_vector(17 downto 0);
        Sx_Addr        : OUT std_logic_vector(3 downto 0);
        Sy_Addr        : OUT std_logic_vector(3 downto 0);
        DMemAddr_dir   : OUT std_logic_vector(5 downto 0);
        ENInterrupt    : OUT std_logic;
        PortID_dir     : OUT std_logic_vector(7 downto 0);
        Branch_Addr    : OUT std_logic_vector(11 downto 0);
        AL_Instr_Ext   : OUT std_logic_vector(3 downto 0);
        KK_const       : OUT std_logic_vector(7 downto 0);
        Instr_code     : OUT std_logic_vector(5 downto 0)
    );
    END COMPONENT;

    -- Inputs
    SIGNAL reset          : std_logic := '0';
    SIGNAL Instr_Phase    : std_logic_vector(2 downto 0) := (others => '0');
    SIGNAL Instruction    : std_logic_vector(17 downto 0) := (others => '0');

    -- Outputs
    SIGNAL Sx_Addr        : std_logic_vector(3 downto 0);
    SIGNAL Sy_Addr        : std_logic_vector(3 downto 0);
    SIGNAL DMemAddr_dir   : std_logic_vector(5 downto 0);
    SIGNAL ENInterrupt    : std_logic;
    SIGNAL PortID_dir     : std_logic_vector(7 downto 0);
    SIGNAL Branch_Addr    : std_logic_vector(11 downto 0);
    SIGNAL AL_Instr_Ext   : std_logic_vector(3 downto 0);
    SIGNAL KK_const       : std_logic_vector(7 downto 0);
    SIGNAL Instr_code     : std_logic_vector(5 downto 0);

    -- Clock period definition (not needed here since there is no clock input)

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: IFDEC PORT MAP (
        reset          => reset,
        Instr_Phase    => Instr_Phase,
        Instruction    => Instruction,
        Sx_Addr        => Sx_Addr,
        Sy_Addr        => Sy_Addr,
        DMemAddr_dir   => DMemAddr_dir,
        ENInterrupt    => ENInterrupt,
        PortID_dir     => PortID_dir,
        Branch_Addr    => Branch_Addr,
        AL_Instr_Ext   => AL_Instr_Ext,
        KK_const       => KK_const,
        Instr_code     => Instr_code
    );

    -- Stimulus process
    stimulus: PROCESS
    BEGIN
        -- Test reset functionality
        reset <= '1';
        WAIT FOR 10 ns;
        reset <= '0';
        WAIT FOR 10 ns;

        -- Test case 1: Instruction phase = "000", Load instruction
        Instr_Phase <= "000";
        Instruction <= "000001110100100000"; -- Load, Sx_Addr = "1110", KK_const = "01001000"
        WAIT FOR 10 ns;

        -- Test case 2: Instruction phase = "000", Add instruction
        Instruction <= "000011110100100001"; -- Add, Sx_Addr = "1110", KK_const = "01001000"
        WAIT FOR 10 ns;

        -- Test case 3: Instruction phase = "000", Branch instruction
        Instruction <= "100010000000111111"; -- Branch, Branch_Addr = "000000111111"
        WAIT FOR 10 ns;

        -- Test case 4: Instruction phase = "000", Other cases
        Instruction <= "001001110100111100"; -- Input, Sx_Addr = "1110", PortID_dir = "01001111"
        WAIT FOR 10 ns;

        -- Test reset again
        reset <= '1';
        WAIT FOR 10 ns;
        reset <= '0';
        WAIT FOR 10 ns;

        -- Finish simulation
        WAIT;
    END PROCESS;

END Behavioral;
