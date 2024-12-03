library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PortLogic_tb is
end PortLogic_tb;

architecture sim of PortLogic_tb is
    -- Signals to connect to the PortLogic UUT
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal PortID_dir   : std_logic_vector(7 downto 0) := (others => '0');
    signal PortID_indir : std_logic_vector(7 downto 0) := (others => '1');
    signal PortDataIn   : std_logic_vector(15 downto 0) := (others => '0');
    signal PortID_sel   : std_logic := '0';
    signal IORD         : std_logic := '1';
    signal IOWR         : std_logic := '1';
    signal DataOutX     : std_logic_vector(15 downto 0) := (others => '0');
    signal PortID       : std_logic_vector(7 downto 0);
    signal PortDataOut  : std_logic_vector(15 downto 0);
    signal Rd_strobe    : std_logic;
    signal Wr_strobe    : std_logic;
    signal PortIntoCPU  : std_logic_vector(15 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;
    
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
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: PortLogic_0
        port map (
            clk         => clk,
            reset       => reset,
            PortID_dir  => PortID_dir,
            PortID_indir => PortID_indir,
            PortDataIn  => PortDataIn,
            PortID_sel  => PortID_sel,
            IORD        => IORD,
            IOWR        => IOWR,
            DataOutX    => DataOutX,
            PortID      => PortID,
            PortDataOut => PortDataOut,
            Rd_strobe   => Rd_strobe,
            Wr_strobe   => Wr_strobe,
            PortIntoCPU => PortIntoCPU
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test Process
    test_process : process
    begin
         -- Test case 1: Reset behavior
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Test case 2: Direct and indirect PortID selection
        PortID_sel <= '0';
        wait for clk_period;
        assert (PortID = PortID_dir) report "PortID_dir not selected correctly" severity error;

        PortID_sel <= '1';
        wait for clk_period;
        assert (PortID = PortID_indir) report "PortID_indir not selected correctly" severity error;

        -- Test case 3: Read operation
        PortDataIn <= x"ABCD";
        IORD <= '1';
        IOWR <= '0';
        wait for clk_period;
        assert (Rd_strobe = '1' and PortIntoCPU = x"ABCD") report "Read operation failed" severity error;

        -- Test case 4: Write operation
        DataOutX <= x"1234";
        IORD <= '0';
        IOWR <= '1';
        wait for clk_period;
        assert (Wr_strobe = '1' and PortDataOut = x"1234") report "Write operation failed" severity error;

        -- End simulation
        wait;
   end process;
end sim;