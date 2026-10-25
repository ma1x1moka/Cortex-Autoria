// SPDX-License-Identifier: MIT
// SANDBOX FOR PRACTICE SYNTAX
pragma solidity ^0.8.27;

// 1- bytes calldata to bytes4
contract Decoder {
    function snbx1(bytes calldata data) external returns (bytes4) {
        bytes4 selector = bytes4(data);
        return selector;
    }

    function snbx2(bytes calldata data) external returns (uint256) {
        uint256 id = abi.decode(data[4:], (uint256));
        return id;
    }

    function sndx3(bytes calldata data) external returns (uint256) {
        bytes4 mustBe = bytes4(keccak256("payForCar(uint256)"));
        if (mustBe == bytes4(data)) {
            uint256 id = abi.decode(data[4:], (uint256));
            return id;
        } else {
            revert();
        }
    }

    function snbx4(bytes calldata data) external returns (uint256) {
        (address _to, uint256 _value, bytes memory innie) = abi.decode(data[4:], (address, uint256, bytes));

        uint256 DealId;
        assembly {
            DealId := mload(add(innie, 0x24))
        }

        return DealId;
    }

    // // Задача 1 (в Decoder.sol, новая функция snbx5):

    // Напиши функцию snbx5, которая:
    // - принимает address to и uint256 amount
    // - возвращает bytes memory — закодированный вызов функции payForCar(uint256) у контракта to, как будто это callData, который потом можно передать в .call()

    // Подсказка-направление (не решение): тебе нужен abi.encodeWithSelector или abi.encodeWithSignature — выбери сам, какой удобнее, и подумай, зачем там вообще нужен to, если по факту в bytes он не попадёт (это на будущее, для следующего шага).

    // Пиши в Sublime, компилируй через forge build, кидай сюда код и что выдал компилятор/тест.

    function snbx5(address komenskeho21, uint256 amount) external returns (bytes memory) {
        bytes4 selector = bytes4(keccak256("payForCar(uint256)"));

        bytes memory result = abi.encodeWithSelector(selector, amount);

        return result;
    }
}

