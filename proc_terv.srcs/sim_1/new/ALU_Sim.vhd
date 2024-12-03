----------------------------------------------------------------------------------
-- Testbench for ALU_0
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_Sim is
end ALU_Sim;

architecture Behavioral of ALU_Sim is

    component ALU_0
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            OP1         : in  STD_LOGIC_VECTOR (15 downto 0);
            OP2         : in  STD_LOGIC_VECTOR (15 downto 0);
            Instr_code  : in  STD_LOGIC_VECTOR (5 downto 0);
            Al_Instr_Ext: in  STD_LOGIC_VECTOR (3 downto 0);
            KK_Const    : in  STD_LOGIC_VECTOR (7 downto 0);
            Execute     : in  STD_LOGIC;
            Carry       : out STD_LOGIC;
            Zero        : out STD_LOGIC;
            ALU_Result  : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk         : STD_LOGIC := '0';
    signal reset       : STD_LOGIC := '0';
    signal OP1         : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal OP2         : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Instr_code  : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal Al_Instr_Ext: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal KK_Const    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Execute     : STD_LOGIC := '0';
    signal Carry       : STD_LOGIC;
    signal Zero        : STD_LOGIC;
    signal ALU_Result  : STD_LOGIC_VECTOR(15 downto 0);
    constant clk_period: time := 10 ns;

begin

    -- DUT instantiation
    uut: ALU_0
        port map (
            clk         => clk,
            reset       => reset,
            OP1         => OP1,
            OP2         => OP2,
            Instr_code  => Instr_code,
            Al_Instr_Ext=> Al_Instr_Ext,
            KK_Const    => KK_Const,
            Execute     => Execute,
            Carry       => Carry,
            Zero        => Zero,
            ALU_Result  => ALU_Result
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Test case 1: Add sX, sY
        OP1 <= x"0003";
        OP2 <= x"0002";
        Instr_code <= "010000";  -- Add sX, sY
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period * 2;

        -- Test case 2: Add sX, KK
        OP1 <= x"0005";
        KK_Const <= x"01";
        Instr_code <= "010001";  -- Add sX, KK
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period * 2;

        -- Test case 3: And sX, sY
        OP1 <= x"000F";
        OP2 <= x"00F0";
        Instr_code <= "000010";  -- And sX, sY
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period * 2;

        -- Test case 4: Or sX, KK
        OP1 <= x"0003";
        KK_Const <= x"0C";
        Instr_code <= "000101";  -- Or sX, KK
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period * 2;

        -- Test case 5: Multiply sX, KK
        OP1 <= x"0002";
        KK_Const <= x"03";
        Instr_code <= "001101";  -- Mult8 sX, KK
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period * 2;

        -- Test case 6: Compare sX, KK
        OP1 <= x"0002";
        KK_Const <= x"02";
        Instr_code <= "011101";  -- Compare sX, KK
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period * 2;

        -- Test case 7: Sub sX, KK
        OP1 <= x"0005";
        KK_Const <= x"03";
        Instr_code <= "011001";  -- Sub sX, KK
        Execute <= '1';
        wait for clk_period;
        Execute <= '0';
        wait for clk_period * 2;

        -- End simulation
        wait;
    end process;

end Behavioral;
