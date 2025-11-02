// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GovernGuardTrap.sol";

contract GovernGuardTrapTest is Test {
    GovernGuardTrap public trap;

    function setUp() public {
        trap = new GovernGuardTrap();
    }

    function testTrapExists() public {
        assertEq(trap.SPIKE_THRESHOLD_PERCENT(), 50);
    }
}
