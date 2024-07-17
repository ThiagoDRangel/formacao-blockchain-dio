pragma solidity ^0.8.0;

interface IERC20 {
    // Getters
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    // Functions
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DIOToken is IERC20 {
    string public constant name = "VVToken";
    string public constant symbol = "VVT";
    uint8 public constant decimals = 18;

    uint256 private _totalSupply = 10 ether;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;

    constructor() {
        _balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint256) {
        return _balances[tokenOwner];
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= _balances[msg.sender], "Insufficient balance");
        _balances[msg.sender] -= numTokens;
        _balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        _allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= _balances[owner], "Insufficient balance");
        require(numTokens <= _allowed[owner][msg.sender], "Allowance exceeded");

        _balances[owner] -= numTokens;
        _allowed[owner][msg.sender] -= numTokens;
        _balances[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
