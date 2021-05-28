pragma solidity ^0.6.0;


abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /*
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /*
     * @dev Returns the amount of tokens owned by account.
     */
    function balanceOf(address account) external view returns (uint256);

    /*
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /*
     * @dev Returns the remaining number of tokens that spender will be
     * allowed to spend on behalf of owner through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /*
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /*
     * @dev Moves amount tokens from sender to recipient using the
     * allowance mechanism. amount is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /*
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /*
     * @dev Emitted when the allowance of a spender for an owner is set by
     * a call to {approve}. value is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



/*
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /*
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's + operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    
    /*
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /*
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's - operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /*
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /*
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's / operator. Note: this function uses a
     * revert opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /*
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /*
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's % operator. This function uses a revert
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    
    /*
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/*
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * onlyOwner, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /*
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /*
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /*
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /*
     * @dev Leaves the contract without owner. It will not be possible to call
     * onlyOwner functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (newOwner).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Factory {
  event PairCreated(address indexed token0, address indexed token1, address pair, uint);

  function getPair(address tokenA, address tokenB) external view returns (address pair);
  function allPairs(uint) external view returns (address pair);
  function allPairsLength() external view returns (uint);

  function feeTo() external view returns (address);
  function feeToSetter() external view returns (address);

  function createPair(address tokenA, address tokenB) external returns (address pair);
}


contract REFLECTDEMO is Context, IERC20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _Owned;
    address[] private _owners;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isIncluded;
    address[] private _included;
    address[] private _dex;
   
   uint256 private _AllTotal = 5 * 10**6 * 10**7;
    uint256 private _Total = 5 * 10**6 * 10**7;
    uint256 private _FeeTotal;
    uint256 private _BurnTotal;
    uint256 private _FeeCurent;

    string private _name = 'REFLECT DEMO TOKEN';
    string private _symbol = 'RDEX';
    uint8 private _decimals = 9;
    
    uint256 private _taxFee = 5;
    uint256 private _burnFee = 5;
    uint256 private _maxTxAmount = 2500e9;
    
    IUniswapV2Factory uniswapFactory;

    constructor () public {
        _Owned[_msgSender()] = _Total;
        _owners.push(_msgSender());
        
        emit Transfer(address(0), _msgSender(), _Total);
    }
    
     function setFactoryAddress(address contractAddress) public {
         uniswapFactory = IUniswapV2Factory(contractAddress);
     }
     
    function getAllPairsLength() public view returns(uint){
        return uniswapFactory.allPairsLength();
    }
    
    function getAllPairs(uint num) public view returns(address){
         return uniswapFactory.allPairs(num);
    }
    
    function getPairForToken(address token0, address token1) public view returns(address){
         return uniswapFactory.getPair(token0, token1);
    }
    
    function feeCurent() public view returns(uint256) {
        return _FeeCurent;
    }
    
    function includedAccounts() public view returns(address [] memory) {
        return _included;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function MaxTxAmount() public view returns (uint256) {
        return _maxTxAmount;
    }
    
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _Total;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _Owned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function isIncluded(address account) public view returns (bool) {
        return _isIncluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _FeeTotal;
    }

    function totalBurn() public view returns (uint256) {
        return _BurnTotal;
    }

    // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4        
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2        90000000000 98250000000  8250000000 33%
    // 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db       180000000000 196500000000 16500000000 66%
    // 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB       180000000000                (не в списке) 0%
    //                                                                            25000000000 1% (остаток)
    // 0x617F2E2fD72FD9D5503197092aC168c91465E7f2
    // 0x17F6AD8Ef982297579C203069C1DbfFE4348c372

    function includeAccount(address account) external onlyOwner() {
        require(!_isIncluded[account], "Account is already included");
        _isIncluded[account] = true;
        _included.push(account);
    }

    function excludeAccount(address account) external onlyOwner() {
        require(_isIncluded[account], "Account is already excluded");
        for (uint256 i = 0; i < _included.length; i++) {
            if (_included[i] == account) {
                _included[i] = _included[_included.length - 1];
                _isIncluded[account] = false;
                _included.pop();
                break;
            }
        }
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function getOwners() view public returns(address [] memory) {
        return _owners;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if(_Owned[recipient] == 0) {
            _owners.push(recipient);
        }
        
        if(sender != owner() && recipient != owner())
            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
        
            _transferStandard(sender, recipient, amount);
    }

    // Стандартные вариант передачи токенов
    function _transferStandard(address sender, address recipient, uint256 amount) private {
        _Owned[sender] = _Owned[sender].sub(amount);
        
       if(_Total > _AllTotal.mul(30).div(100)) {
            for (uint256 i = 0; i < _dex.length; i++) {
                if (_dex[i] == recipient) {
                    uint256 burn = amount.mul(10).div(100);
                    amount = amount.sub(burn);
                    _Total = _Total.sub(burn);
                    _BurnTotal = _BurnTotal.add(burn);
                    break;
                }
            }
       }
        _Owned[recipient] = _Owned[recipient].add(amount);
   
        emit Transfer(sender, recipient, amount);
    }
    
    // Посчитать комиссии
    function getTax(uint256 amount) private view returns(uint256 burn, uint256 tax, uint256 transferAmount) {
        burn =  amount.mul(_burnFee).div(100);
        tax = amount.mul(_taxFee).div(100);
        transferAmount = amount.sub(burn).sub(tax);
        
        return (burn, tax, transferAmount);
    }
    
    // Применить комиссии
    function addTax(uint256 burn, uint256 tax) internal returns (bool) {
        _BurnTotal = _BurnTotal.add(burn);
        _FeeTotal = _FeeTotal.add(tax);
        _FeeCurent = _FeeCurent.add(tax);
        _Total = _Total.sub(burn);
        
        return true;
    }
    
    // Распред между Всеми кроме Получателя Отправителя
    function reflectTokens(address sender, address recipient ) public returns(bool) {
        if(_owners.length < 3) return false;
        
        uint256 forOne = _FeeCurent.div(_owners.length.sub(2));
        _FeeCurent = _FeeCurent.sub(forOne.mul(_owners.length.sub(2)));
          for (uint256 i = 0; i < _owners.length; i++) {
              if(_owners[i] != sender && _owners[i] != recipient)
                _Owned[_owners[i]] = _Owned[_owners[i]].add(forOne);
        }
        return true;
    }
    
    // Распред между Списком акаунтов
    function reflectTokensToIncluded() public returns(bool) {
        if(_included.length < 1) return false;
        uint256 forOne = _FeeCurent.div(_included.length);
        _FeeCurent = _FeeCurent.sub(forOne.mul(_included.length));
          for (uint256 i = 0; i < _included.length; i++) {
                _Owned[_included[i]] = _Owned[_included[i]].add(forOne);
        }
        return true;
    }
    
    // Распред между списком акаунтов в зависимости от Доли Владения (проценты)
        function reflectTokensToIncludedWithPercent() public returns(bool) {
        uint256 sharedOwnership = 0;
        for (uint256 i = 0; i < _included.length; i++) {
                sharedOwnership = sharedOwnership.add(_Owned[_included[i]]);
        }
        uint256 spendedFee = 0;
          for (uint256 i = 0; i < _included.length; i++) {
              uint256 percent = _Owned[_included[i]].mul(100).div(sharedOwnership);
              uint256 amount = _FeeCurent.mul(percent).div(100);
              _Owned[_included[i]] = _Owned[_included[i]].add(amount);
              spendedFee =spendedFee.add(amount);
        }
        _FeeCurent = _FeeCurent.sub(spendedFee);
        
    }
    
    // function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
    //     uint256 currentRate =  _getRate();
    //     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
    //     uint256 rBurn =  tBurn.mul(currentRate);
    //     _rOwned[sender] = _rOwned[sender].sub(rAmount);
    //     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
    //     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    //     _reflectFee(rFee, rBurn, tFee, tBurn);
    //     emit Transfer(sender, recipient, tTransferAmount);
    // }

    // function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
    //     uint256 currentRate =  _getRate();
    //     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
    //     uint256 rBurn =  tBurn.mul(currentRate);
        
    //     _reflectFee(rFee, rBurn, tFee, tBurn);
    //     _tOwned[sender] = _tOwned[sender].sub(tAmount);
    //     _rOwned[sender] = _rOwned[sender].sub(rAmount);
    //     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        
    //     emit Transfer(sender, recipient, tTransferAmount);
    // }

    // function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
    //     uint256 currentRate =  _getRate();
    //     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
    //     uint256 rBurn =  tBurn.mul(currentRate);
    //     _tOwned[sender] = _tOwned[sender].sub(tAmount);
    //     _rOwned[sender] = _rOwned[sender].sub(rAmount);
    //     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
    //     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    //     _reflectFee(rFee, rBurn, tFee, tBurn);
    //     emit Transfer(sender, recipient, tTransferAmount);
    // }

    
    
    function _getTaxFee() private view returns(uint256) {
        return _taxFee;
    }

    function _getMaxTxAmount() private view returns(uint256) {
        return _maxTxAmount;
    }
    
    function _setTaxFee(uint256 taxFee) external onlyOwner() {
        require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
        _taxFee = taxFee;
    }
    
    function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
        require(maxTxAmount >= 9000e9 , 'maxTxAmount should be greater than 9000e9');
        _maxTxAmount = maxTxAmount;
    }
    
    function setDex(address dex) public onlyOwner returns(bool) {
        _dex.push(dex);
        return true;
    }
    
    function getDex() public view returns(address [] memory) {
        return _dex;
    }
    /*
    // mainnet
    const factory = '0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95'
    
    // testnets
    const ropsten = '0x9c83dCE8CA20E9aAF9D3efc003b2ea62aBC08351'
    const rinkeby = ''
    const kovan = '0xD3E51Ef092B2845f10401a0159B2B96e8B6c3D30'
    const görli = '0x6Ce570d02D73d4c384b46135E87f8C592A8c86dA'
    */
    function findSwapPair(address token0, address token1) public pure returns(address) {
        address factory =0xf5D915570BC477f9B8D6C0E980aA81757A3AaC36; //rinkeby
        // address token0 = 0xCAFE000000000000000000000000000000000000; // change me!
        // address token1 = 0xF00D000000000000000000000000000000000000; // change me!
        
        address pair = address(uint(keccak256(abi.encodePacked(
          hex'ff',
          factory,
          keccak256(abi.encodePacked(token0, token1)),
          hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'
        ))));
        
        return pair;
    }
}
    