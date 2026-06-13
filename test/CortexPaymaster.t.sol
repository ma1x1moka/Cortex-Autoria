// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "forge-std/Test.sol";
// import "../src/core/MaliciousUser.sol";
import "../src/core/Autoria.sol";
import "../src/account/CortexPaymaster.sol";
import "../src/account/CortexAccount.sol";
import {
    MessageHashUtils
} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract CrtxPaymasterTest is Test {
    // variables

    CortexAccount public CrtxAcc;
    Autoria public autoria;
    CortexPaymaster public CrtxPay;

    // adresses
    address entryPoint = makeAddr("entryPoint");
    address seller = makeAddr("seller");

    function setUp() public {
        autoria = new Autoria();

        CrtxAcc = new CortexAccount(entryPoint);

        CrtxPay = new CortexPaymaster(
            address(CrtxAcc),
            address(autoria),
            entryPoint
        );
    }

    function testvalidatePaymasterUser0p() public {
        vm.deal(seller, 20 ether);
        vm.prank(seller);

        autoria.createAnnouncement{value: 20}(200, 20);

        CortexAccount.UserOperation memory user0p = CortexAccount
            .UserOperation({
                sender: seller,
                nonce: 0,
                initCode: (""),
                callData: (""),
                callGasLimit: 0,
                verificationGasLimit: 0,
                preVerificationGas: 0,
                maxFeePerGas: 0,
                maxPriotrityFeePerGas: 0,
                paymasterAndData: (""),
                signature: ("")
            });

        (, uint256 result) = CrtxPay.validatePaymasterUserOp(
            user0p,
            bytes32(0),
            0
        );
        assertEq(result, 0);
    }

    function testvalidatePaymasterUser0p_result1() public {
        vm.deal(seller, 20 ether);
        vm.prank(seller);

        CortexAccount.UserOperation memory user0p = CortexAccount
            .UserOperation({
                sender: seller,
                nonce: 0,
                initCode: (""),
                callData: (""),
                callGasLimit: 0,
                verificationGasLimit: 0,
                preVerificationGas: 0,
                maxFeePerGas: 0,
                maxPriotrityFeePerGas: 0,
                paymasterAndData: (""),
                signature: ("")
            });

        (, uint256 result) = CrtxPay.validatePaymasterUserOp(
            user0p,
            bytes32(0),
            0
        );
        assertEq(result, 1);
    }
}
