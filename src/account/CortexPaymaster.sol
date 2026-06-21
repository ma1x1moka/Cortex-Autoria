// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "./CortexAccount.sol";
import "../core/Autoria.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";
import {IPaymaster} from "account-abstraction/interfaces/IPaymaster.sol";

contract CortexPaymaster is IPaymaster {
    constructor(address _cortexAccount, address _autoria, address _entryPoint) {
        cortexAccount = CortexAccount(_cortexAccount);
        autoria = Autoria(_autoria);
        entryPoint = IEntryPoint(_entryPoint);
    }
    // variabless

    IEntryPoint public immutable entryPoint;

    CortexAccount public cortexAccount;
    Autoria public autoria;

    // functions
    function validatePaymasterUserOp(CortexAccount.UserOperation calldata user0p, bytes32 user0pHash, uint256 maxCost)
        external
        returns (bytes memory context, uint256 validationData)
    {
        if (autoria.getDealAddress(user0p.sender).length == 0) {
            return (bytes(""), 1);
        } else {
            return (bytes(""), 0);
        }
    }

    function postOp(PostOpMode mode, bytes calldata context, uint256 actualGasCost, uint256 actualUserOpFeePerGas)
        external
    {
        uint256 RepDiscount = 10;
        uint256 Rep = autoria.reputation(seller);
        if (RepDiscount >= Rep) {
            uint256 discountCost = actualGasCost - Rep;
        }
    }

    receive() external payable {
        entryPoint.depositTo{value: msg.value}(address(this));
    }
}
