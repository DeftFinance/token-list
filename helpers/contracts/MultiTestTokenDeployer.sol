// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {TestToken} from "./TestToken.sol";

contract MultiTestTokenDeployer {
    struct TokenInitData {
        string name;
        string symbol;
        uint8 decimals;
        uint256 mintCap;
        uint256 maxSupply;
    }

    struct TokenData {
        TokenInitData tokenInitData;
        address tokenAddress;
    }

    event DeployedTokens(TokenData[] tokensData);

    function deploy(TokenInitData[] calldata tokens) external {
        address account = msg.sender;
        uint256 length = tokens.length;
        TokenData[] memory tokensData = new TokenData[](length);
        require(length < 26);

        for (uint256 i; i < length; ) {
            tokensData[i] = TokenData(
                tokens[i],
                address(
                    new TestToken(
                        tokens[i].name,
                        tokens[i].symbol,
                        tokens[i].decimals,
                        tokens[i].mintCap,
                        tokens[i].maxSupply
                    )
                )
            );

            TestToken(tokensData[i].tokenAddress).mint();
            TestToken(tokensData[i].tokenAddress).transfer(
                account,
                tokens[i].mintCap * (10**tokens[i].decimals)
            );

            unchecked {
                i++;
            }
        }

        emit DeployedTokens(tokensData);
    }
}
