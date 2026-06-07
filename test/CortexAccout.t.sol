// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;
import "forge-std/Test.sol";
import "../src/core/MaliciousUser.sol";
import "../src/account/CortexAccount.sol";
import {
    MessageHashUtils
} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract CortexAccTest is Test {
    CortexAccount public CrtxAcc;
    //address

    address owner = vm.addr(17);
    address attacker = makeAddr("attacker");
    address entryPoint = makeAddr("entryPoint");
    address getter = makeAddr("getter");

    receive() external payable {}

    function setUp() public {
        vm.prank(owner);
        CrtxAcc = new CortexAccount(entryPoint);
    }

    // struct Create

    // happy patch
    function testvalidateUserOp() public {
        uint256 privateKay = 17;
        bytes32 massageHash = keccak256("owners sign");
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(
            massageHash
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(17, ethSignedHash);

        CortexAccount.UserOperation memory user0p = CortexAccount
            .UserOperation({
                sender: owner,
                nonce: 0,
                initCode: (""),
                callData: (""),
                callGasLimit: 0,
                verificationGasLimit: 0,
                preVerificationGas: 0,
                maxFeePerGas: 0,
                maxPriotrityFeePerGas: 0,
                paymasterAndData: (""),
                signature: (abi.encodePacked(r, s, v))
            });

        vm.startPrank(entryPoint);
        uint256 result = CrtxAcc.validateUserOp(user0p, massageHash, 0);

        assertEq(result, 0);
    }

    function testEcecute() public {
        uint256 balancebefore = address(this).balance;
        vm.startPrank(owner);
        vm.deal(address(CrtxAcc), 21 ether);

        CrtxAcc.execute(address(this), 20 wei, (""));
        assertEq(address(this).balance, balancebefore + 20 wei);
    }
}
