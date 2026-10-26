// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract CortexAccount {
    constructor(address _enrtyPoint) {
        entryPoint = IEntryPoint(_enrtyPoint);
        owner = msg.sender;
    }

    // erros

    error AccessDenied(address sender, uint256 time);
    error callFailed(uint256 time);

    // modifiers

    modifier chackRights() {
        if (msg.sender != address(entryPoint) && msg.sender != owner) {
            revert AccessDenied(msg.sender, block.timestamp);
        }
        _;
    }

    // structs
    struct UserOperation {
        address sender;
        uint256 nonce;
        bytes initCode;
        bytes callData;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        uint256 maxFeePerGas;
        uint256 maxPriotrityFeePerGas;
        bytes paymasterAndData;
        bytes signature;
    }
    // varibles
    address public owner;
    IEntryPoint public immutable entryPoint;

    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
        external
        returns (uint256 validationData)
    {
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);

        if (msg.sender != address(entryPoint)) {
            return 1;
        }

        address signer = ECDSA.recover(ethSignedMessageHash, userOp.signature);

        if (signer != owner) {
            return 1;
        }
        return 0;
    }

    function execute(address to, uint256 value, bytes calldata data) external chackRights {
        (bool call,) = payable(to).call{value: value}(data);
        if (call != true) {
            revert callFailed(block.timestamp);
        }
    }
}
