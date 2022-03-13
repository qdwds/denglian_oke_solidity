//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
//* 发行一个 ERC721 Token
//* 使用 ether.js 解析 ERC721 转账事件(加分项：记录到数据库中，可方便查询用户持有的所有NFTs)
//* (或)使用 TheGraph 解析 ERC721 转账事件
import "hardhat/console.sol";


interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }
    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId ) external;
    function transferFrom( address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
contract NFTs is IERC165 ,IERC721, IERC721Metadata{
    string private _name;
    string private _symbol;

    //  令牌ID 对饮到持有者地址
    mapping(uint256 => address) private _owners;
    //  持有者对应到令牌
    mapping(address => uint256) private _balances;
    //  ID 授权
    mapping(uint256 => address) private _tokenApprovals;
    //  是否授权
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(uint256 => string) private _tokenURIs;
    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(bytes4  interfaceId) public view virtual override returns(bool) {
        // console.log(type(IERC165).interfaceId);
        return (interfaceId == type(IERC165).interfaceId);
    }

    function name() public view virtual override returns(string memory) {
        return _name;
    }
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    function tokenURI(uint256 tokenId)  public view virtual override returns(string memory){
        require(_owners[tokenId] != address(0), "ERC721Metadata: URI query for nonexistent token");
        //  始终 = “” ？？？？
        string memory baseURI = _baseURI();
        // return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId)) : "";
    }
     function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    //  当前用户持有的内容
    function balanceOf(address owner) public view virtual override returns(uint256){
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    //  当前NFTs id 持有的的address
    function ownerOf(uint256 tokenId) public view virtual override returns(address) {
        require(_owners[tokenId] != address(0), "ERC721: owner query for nonexistent token");
        return _owners[tokenId];
    }

    //  授权
    function approve(address to, uint256 tokenId) public virtual override {
        require(to != NFTs.ownerOf(tokenId), "ERC721: approval to current owner");
        require(msg.sender == NFTs.ownerOf(tokenId) ||isApprovedForAll(NFTs.ownerOf(tokenId), msg.sender), "ERC721: approve caller is not owner nor approved for all");
        _approve(to, tokenId);
    }
    //  获取授权id的 address
    function getApproved(uint256 tokenId) public view virtual override returns(address){
        require(_owners[tokenId] != address(0),  "ERC721: approved query for nonexistent token");
        return _tokenApprovals[tokenId];
    }

    //   mes.sender -> b_addr 授权
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(msg.sender != operator, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
     // 是否授权
    function isApprovedForAll(address owner, address operator) public view virtual override returns(bool) {
        return _operatorApprovals[owner][operator];
    }
    function transferFrom(address from, address to, uint256 tokenId) public virtual override{
        //  是否已经授权
        require(_isApprovedForAll(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }
    //  严格模式 授权之后才能转账
    function safeTransferFrom(address from,address to,uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public virtual override {
        require(_isApprovedForAll(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
    // 是否授权
    function _isApprovedForAll(address spender, uint256 tokenId) internal view virtual returns(bool){
        require(_owners[tokenId] != address(0), "ERC721: operator query for nonexistent token");
        address owner = NFTs.ownerOf(tokenId);   // 根据id 查改address
        //  持有id一样  || 已经授权 || 授权的ID的地址 是当前 address
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }
    //  转账    
    function _transfer(address from, address to, uint256 tokenId) internal virtual{
        //  不能给自己转账
        require(NFTs.ownerOf(tokenId) == from,  "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
        // 转账之前
        // _beforeTokenTransfer(from, to, tokenId);

        // 把原有的 授权内容 清空
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);

        //  交易结束之后
        // _afterTokenTransfer(from, to, tokenId);
    }
    //  转移 授权 ID 到指定address
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(NFTs.ownerOf(tokenId), to, tokenId);
    }
    //  
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual{
        _transfer(from, to, tokenId);
        // require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    //  是否为合约？
    // function _checkOnERC721Received(
    //     address from,
    //     address to,
    //     uint256 tokenId,
    //     bytes memory _data
    // ) private returns (bool) {
    //     if (to.isContract()) {
    //         try IERC721Receiver(to).onERC721Received(msg.sender(), from, tokenId, _data) returns (bytes4 retval) {
    //             return retval == IERC721Receiver.onERC721Received.selector;
    //         } catch (bytes memory reason) {
    //             if (reason.length == 0) {
    //                 revert("ERC721: transfer to non ERC721Receiver implementer");
    //             } else {
    //                 assembly {
    //                     revert(add(32, reason), mload(reason))
    //                 }
    //             }
    //         }
    //     } else {
    //         return true;
    //     }
    // }
    function _mint(address to, uint256 tokenId) internal virtual{
        require(to != address(0), "ERC721: mint to the zero address");
        require(_owners[tokenId] == address(0), "ERC721: token already minted");
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }


    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    function awardItem(address player, string memory tokenURI) public returns(uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_owners[tokenId] != address(0), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }
}
 