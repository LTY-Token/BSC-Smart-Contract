pragma solidity ^0.6.12;

import "./libraries/ReflectToken.sol";
import "./interfaces/IUniswapV2Factory.sol";
import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IUniswapV2Router02.sol";
import "./interfaces/ILedgity.sol";
import "./interfaces/IReserve.sol";


contract Ledgity is ILedgity, ReflectToken {
    using SafeMath for uint256;

    uint256 public numTokensToSwap;
    bool public inSwapAndLiquify;
    enum FeeDestination {
        Liquify,
        Collect
    }
    FeeDestination public feeDestination = FeeDestination.Liquify;


    mapping(address => bool) _isDex;
    mapping(address => bool) public isExcludedFromDexFee;
    mapping(address => uint256) public lastTransactionAt;
    uint256 public maxTransactionSizePercentNumerator = 5;
    uint256 public maxTransactionSizePercentDenominator = 10000;

    IUniswapV2Pair public uniswapV2Pair;
    IReserve public reserve;

    constructor(address routerAddress, address usdcAddress) public ReflectToken("Ledgity", "LTY", 2760000000 * 10**18) {
        numTokensToSwap = totalSupply().mul(15).div(10000);
        isExcludedFromDexFee[owner()] = true;
        isExcludedFromDexFee[address(this)] = true;

        uniswapV2Pair = IUniswapV2Pair(
            IUniswapV2Factory(IUniswapV2Router02(routerAddress).factory())
                .createPair(address(this), usdcAddress)
        );
        setDex(address(uniswapV2Pair), true);
    }

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    function initialize(address reserveAddress) public onlyOwner {
        reserve = IReserve(reserveAddress);
        isExcludedFromDexFee[address(reserve)] = true;
    }

    function setDex(address target, bool isDex) public onlyOwner {
        _isDex[target] = isDex;
    }

    function setFeeDestination(FeeDestination fd) public onlyOwner {
        feeDestination = fd;
    }

    function setIsExcludedFromDexFee(address account, bool isExcluded) public onlyOwner {
        isExcludedFromDexFee[account] = isExcluded;
    }

    function setNumTokensToSwap(uint256 _numTokensToSwap) public onlyOwner {
        numTokensToSwap = _numTokensToSwap;
    }

    function setMaxTransactionSizePercent(uint256 numerator, uint256 denominator) public onlyOwner {
        maxTransactionSizePercentNumerator = numerator;
        maxTransactionSizePercentDenominator = denominator;
    }

    function burn(uint256 amount) public override returns (bool) {
        // TODO
        revert("Ledgity: not implemented");
        return false;
    }

    function _calculateReflectionFee(address sender, address recipient, uint256 amount) internal override view returns (uint256) {
        if (_isDex[recipient] && !isExcludedFromDexFee[sender]) {
            return amount.mul(4).div(100);
        }
        return 0;
    }

    function _calculateAccumulationFee(address sender, address recipient, uint256 amount) internal override view returns (uint256) {
        if (_isDex[sender] && !isExcludedFromDexFee[recipient]) {
            return amount.mul(4).div(100);
        }
        if (_isDex[recipient] && !isExcludedFromDexFee[sender]) {
            return amount.mul(6).div(100);
        }
        return 0;
    }

    function _swapAndLiquifyOrCollect(uint256 contractTokenBalance) private lockTheSwap {
        _transfer(address(this), address(reserve), contractTokenBalance);
        if (feeDestination == FeeDestination.Liquify) {
            reserve.swapAndLiquify(contractTokenBalance);
        } else if (feeDestination == FeeDestination.Collect) {
            reserve.swapAndCollect(contractTokenBalance);
        } else {
            revert("Ledgity: invalid feeDestination");
        }
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        // TODO: generalize this
        require(
            sender == owner() || sender == address(uniswapV2Pair) || sender == address(reserve) || lastTransactionAt[sender] < block.timestamp.sub(15 minutes),
            "Ledgity: only one transaction per 15 minutes"
        );
        lastTransactionAt[sender] = block.timestamp;
        require(
            sender == owner() || sender == address(uniswapV2Pair) || sender == address(this) || sender == address(reserve) || amount <= _maxTransactionSize(),
            "Ledgity: max transaction size exceeded"
        );
        super._transfer(sender, recipient, amount);

        uint256 contractTokenBalance = balanceOf(address(this));
        if (
            contractTokenBalance >= numTokensToSwap &&
            !inSwapAndLiquify &&
            sender != address(uniswapV2Pair)
        ) {
            _swapAndLiquifyOrCollect(contractTokenBalance);
        }
    }

    function _maxTransactionSize() private view returns (uint256) {
        return totalSupply().mul(maxTransactionSizePercentNumerator).div(maxTransactionSizePercentDenominator);
    }
}
