// SPDX-License-Identifier: UNLICENSED
/*

                         ┌───────────┐
                         │ HOLOGRAPH │
                         └───────────┘
╔═════════════════════════════════════════════════════════════╗
║                                                             ║
║                            / ^ \                            ║
║                            ~~*~~            ¸               ║
║                         [ '<>:<>' ]         │░░░            ║
║               ╔╗           _/"\_           ╔╣               ║
║             ┌─╬╬─┐          """          ┌─╬╬─┐             ║
║          ┌─┬┘ ╠╣ └┬─┐       \_/       ┌─┬┘ ╠╣ └┬─┐          ║
║       ┌─┬┘ │  ╠╣  │ └┬─┐           ┌─┬┘ │  ╠╣  │ └┬─┐       ║
║    ┌─┬┘ │  │  ╠╣  │  │ └┬─┐     ┌─┬┘ │  │  ╠╣  │  │ └┬─┐    ║
║ ┌─┬┘ │  │  │  ╠╣  │  │  │ └┬┐ ┌┬┘ │  │  │  ╠╣  │  │  │ └┬─┐ ║
╠┬┘ │  │  │  │  ╠╣  │  │  │  │└¤┘│  │  │  │  ╠╣  │  │  │  │ └┬╣
║│  │  │  │  │  ╠╣  │  │  │  │   │  │  │  │  ╠╣  │  │  │  │  │║
╠╩══╩══╩══╩══╩══╬╬══╩══╩══╩══╩═══╩══╩══╩══╩══╬╬══╩══╩══╩══╩══╩╣
╠┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴╬╬┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴╬╬┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴╣
║               ╠╣                           ╠╣               ║
║               ╠╣                           ╠╣               ║
║    ,          ╠╣     ,        ,'      *    ╠╣               ║
║~~~~~^~~~~~~~~┌╬╬┐~~~^~~~~~~~~^^~~~~~~~~^~~┌╬╬┐~~~~~~~^~~~~~~║
╚══════════════╩╩╩╩═════════════════════════╩╩╩╩══════════════╝
     - one protocol, one bridge = infinite possibilities -


 ***************************************************************

 DISCLAIMER: U.S Patent Pending

 LICENSE: Holograph Limited Public License (H-LPL)

 https://holograph.xyz/licenses/h-lpl/1.0.0

 This license governs use of the accompanying software. If you
 use the software, you accept this license. If you do not accept
 the license, you are not permitted to use the software.

 1. Definitions

 The terms "reproduce," "reproduction," "derivative works," and
 "distribution" have the same meaning here as under U.S.
 copyright law. A "contribution" is the original software, or
 any additions or changes to the software. A "contributor" is
 any person that distributes its contribution under this
 license. "Licensed patents" are a contributor’s patent claims
 that read directly on its contribution.

 2. Grant of Rights

 A) Copyright Grant- Subject to the terms of this license,
 including the license conditions and limitations in sections 3
 and 4, each contributor grants you a non-exclusive, worldwide,
 royalty-free copyright license to reproduce its contribution,
 prepare derivative works of its contribution, and distribute
 its contribution or any derivative works that you create.
 B) Patent Grant- Subject to the terms of this license,
 including the license conditions and limitations in section 3,
 each contributor grants you a non-exclusive, worldwide,
 royalty-free license under its licensed patents to make, have
 made, use, sell, offer for sale, import, and/or otherwise
 dispose of its contribution in the software or derivative works
 of the contribution in the software.

 3. Conditions and Limitations

 A) No Trademark License- This license does not grant you rights
 to use any contributors’ name, logo, or trademarks.
 B) If you bring a patent claim against any contributor over
 patents that you claim are infringed by the software, your
 patent license from such contributor is terminated with
 immediate effect.
 C) If you distribute any portion of the software, you must
 retain all copyright, patent, trademark, and attribution
 notices that are present in the software.
 D) If you distribute any portion of the software in source code
 form, you may do so only under this license by including a
 complete copy of this license with your distribution. If you
 distribute any portion of the software in compiled or object
 code form, you may only do so under a license that complies
 with this license.
 E) The software is licensed “as-is.” You bear all risks of
 using it. The contributors give no express warranties,
 guarantees, or conditions. You may have additional consumer
 rights under your local laws which this license cannot change.
 To the extent permitted under your local laws, the contributors
 exclude all implied warranties, including those of
 merchantability, fitness for a particular purpose and
 non-infringement.

 4. (F) Platform Limitation- The licenses granted in sections
 2.A & 2.B extend only to the software or derivative works that
 you create that run on a Holograph system product.

 ***************************************************************

*/

pragma solidity 0.8.13;

import "../abstract/Admin.sol";
import "../abstract/Initializable.sol";
import "../abstract/Owner.sol";

import "../enum/HolographERC721Event.sol";
import "../enum/InterfaceType.sol";

import "../interface/ERC165.sol";
import "../interface/ERC721.sol";
import "../interface/HolographERC721Interface.sol";
import "../interface/ERC721Metadata.sol";
import "../interface/ERC721TokenReceiver.sol";
import "../interface/Holographable.sol";
import "../interface/HolographedERC721.sol";
import "../interface/HolographInterface.sol";
import "../interface/HolographerInterface.sol";
import "../interface/HolographRegistryInterface.sol";
import "../interface/InitializableInterface.sol";
import "../interface/HolographInterfacesInterface.sol";
import "../interface/PA1DInterface.sol";
import "../interface/Ownable.sol";

/**
 * @title Holograph Bridgeable ERC-721 Collection
 * @author CXIP-Labs
 * @notice A smart contract for minting and managing Holograph Bridgeable ERC721 NFTs.
 * @dev The entire logic and functionality of the smart contract is self-contained.
 */
contract HolographERC721 is Admin, Owner, HolographERC721Interface, Initializable {
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.holograph')) - 1)
   */
  bytes32 constant _holographSlot = 0xb4107f746e9496e8452accc7de63d1c5e14c19f510932daa04077cd49e8bd77a;
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.sourceContract')) - 1)
   */
  bytes32 constant _sourceContractSlot = 0x27d542086d1e831d40b749e7f5509a626c3047a36d160781c40d5acc83e5b074;

  /**
   * @dev Configuration for events to trigger for source smart contract.
   */
  uint256 private _eventConfig;

  /**
   * @dev Collection name.
   */
  string private _name;

  /**
   * @dev Collection symbol.
   */
  string private _symbol;

  /**
   * @dev Collection royalty base points.
   */
  uint16 private _bps;

  /**
   * @dev Array of all token ids in collection.
   */
  uint256[] private _allTokens;

  /**
   * @dev Map of token id to array index of _ownedTokens.
   */
  mapping(uint256 => uint256) private _ownedTokensIndex;

  /**
   * @dev Token id to wallet (owner) address map.
   */
  mapping(uint256 => address) private _tokenOwner;

  /**
   * @dev 1-to-1 map of token id that was assigned an approved operator address.
   */
  mapping(uint256 => address) private _tokenApprovals;

  /**
   * @dev Map of total tokens owner by a specific address.
   */
  mapping(address => uint256) private _ownedTokensCount;

  /**
   * @dev Map of array of token ids owned by a specific address.
   */
  mapping(address => uint256[]) private _ownedTokens;

  /**
   * @notice Map of full operator approval for a particular address.
   * @dev Usually utilised for supporting marketplace proxy wallets.
   */
  mapping(address => mapping(address => bool)) private _operatorApprovals;

  /**
   * @dev Mapping from token id to position in the allTokens array.
   */
  mapping(uint256 => uint256) private _allTokensIndex;

  /**
   * @dev Mapping of all token ids that have been burned. This is to prevent re-minting of same token ids.
   */
  mapping(uint256 => bool) private _burnedTokens;

  /**
   * @notice Only allow calls from bridge smart contract.
   */
  modifier onlyBridge() {
    require(msg.sender == _holograph().getBridge(), "ERC721: bridge only call");
    _;
  }

  /**
   * @notice Only allow calls from source smart contract.
   */
  modifier onlySource() {
    address sourceContract;
    assembly {
      sourceContract := sload(_sourceContractSlot)
    }
    require(msg.sender == sourceContract, "ERC721: source only call");
    _;
  }

  /**
   * @dev Constructor is left empty and init is used instead
   */
  constructor() {}

  /**
   * @notice Used internally to initialize the contract instead of through a constructor
   * @dev This function is called by the deployer/factory when creating a contract
   * @param initPayload abi encoded payload to use for contract initilaization
   */
  function init(bytes memory initPayload) external override returns (bytes4) {
    require(!_isInitialized(), "ERC721: already initialized");
    InitializableInterface sourceContract;
    assembly {
      sstore(_ownerSlot, caller())
      sourceContract := sload(_sourceContractSlot)
    }
    (
      string memory contractName,
      string memory contractSymbol,
      uint16 contractBps,
      uint256 eventConfig,
      bool skipInit,
      bytes memory initCode
    ) = abi.decode(initPayload, (string, string, uint16, uint256, bool, bytes));
    _name = contractName;
    _symbol = contractSymbol;
    _bps = contractBps;
    _eventConfig = eventConfig;
    if (!skipInit) {
      require(sourceContract.init(initCode) == InitializableInterface.init.selector, "ERC721: could not init source");
      (bool success, bytes memory returnData) = _royalties().delegatecall(
        abi.encodeWithSignature("initPA1D(bytes)", abi.encode(address(this), uint256(contractBps)))
      );
      bytes4 selector = abi.decode(returnData, (bytes4));
      require(success && selector == InitializableInterface.init.selector, "ERC721: coud not init PA1D");
    }

    _setInitialized();
    return InitializableInterface.init.selector;
  }

  /**
   * @notice Gets a base64 encoded contract JSON file.
   * @return string The URI.
   */
  function contractURI() external view returns (string memory) {
    return HolographInterfacesInterface(_interfaces()).contractURI(_name, "", "", _bps, address(this));
  }

  /**
   * @notice Gets the name of the collection.
   * @return string The collection name.
   */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
   * @notice Shows the interfaces the contracts support
   * @dev Must add new 4 byte interface Ids here to acknowledge support
   * @param interfaceId ERC165 style 4 byte interfaceId.
   * @return bool True if supported.
   */
  function supportsInterface(bytes4 interfaceId) external view returns (bool) {
    HolographInterfacesInterface interfaces = HolographInterfacesInterface(_interfaces());
    ERC165 erc165Contract;
    assembly {
      erc165Contract := sload(_sourceContractSlot)
    }
    if (
      interfaces.supportsInterface(InterfaceType.ERC721, interfaceId) || // check global interfaces
      interfaces.supportsInterface(InterfaceType.PA1D, interfaceId) || // check if royalties supports interface
      erc165Contract.supportsInterface(interfaceId) // check if source supports interface
    ) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * @notice Gets the collection's symbol.
   * @return string The symbol.
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
   * @notice Get's the URI of the token.
   * @dev Defaults the the Arweave URI
   * @return string The URI.
   */
  function tokenURI(uint256 tokenId) external view returns (string memory) {
    require(_exists(tokenId), "ERC721: token does not exist");
    ERC721Metadata sourceContract;
    assembly {
      sourceContract := sload(_sourceContractSlot)
    }
    return sourceContract.tokenURI(tokenId);
  }

  /**
   * @notice Get list of tokens owned by wallet.
   * @param wallet The wallet address to get tokens for.
   * @return uint256[] Returns an array of token ids owned by wallet.
   */
  function tokensOfOwner(address wallet) external view returns (uint256[] memory) {
    return _ownedTokens[wallet];
  }

  /**
   * @notice Get set length list, starting from index, for tokens owned by wallet.
   * @param wallet The wallet address to get tokens for.
   * @param index The index to start enumeration from.
   * @param length The length of returned results.
   * @return tokenIds uint256[] Returns a set length array of token ids owned by wallet.
   */
  function tokensOfOwner(
    address wallet,
    uint256 index,
    uint256 length
  ) external view returns (uint256[] memory tokenIds) {
    uint256 supply = _ownedTokensCount[wallet];
    if (index + length > supply) {
      length = supply - index;
    }
    tokenIds = new uint256[](length);
    for (uint256 i = 0; i < length; i++) {
      tokenIds[i] = _ownedTokens[wallet][index + i];
    }
  }

  /**
   * @notice Adds a new address to the token's approval list.
   * @dev Requires the sender to be in the approved addresses.
   * @param to The address to approve.
   * @param tokenId The affected token.
   */
  function approve(address to, uint256 tokenId) external payable {
    address tokenOwner = _tokenOwner[tokenId];
    require(to != tokenOwner, "ERC721: cannot approve self");
    require(_isApproved(msg.sender, tokenId), "ERC721: not approved sender");
    if (_isEventRegistered(HolographERC721Event.beforeApprove)) {
      require(SourceERC721().beforeApprove(tokenOwner, to, tokenId));
    }
    _tokenApprovals[tokenId] = to;
    emit Approval(tokenOwner, to, tokenId);
    if (_isEventRegistered(HolographERC721Event.afterApprove)) {
      require(SourceERC721().afterApprove(tokenOwner, to, tokenId));
    }
  }

  /**
   * @notice Burns the token.
   * @dev The sender must be the owner or approved.
   * @param tokenId The token to burn.
   */
  function burn(uint256 tokenId) external {
    require(_isApproved(msg.sender, tokenId), "ERC721: not approved sender");
    address wallet = _tokenOwner[tokenId];
    if (_isEventRegistered(HolographERC721Event.beforeBurn)) {
      require(SourceERC721().beforeBurn(wallet, tokenId));
    }
    _burn(wallet, tokenId);
    if (_isEventRegistered(HolographERC721Event.afterBurn)) {
      require(SourceERC721().afterBurn(wallet, tokenId));
    }
  }

  function bridgeIn(uint32 fromChain, bytes calldata payload) external onlyBridge returns (bytes4) {
    (address from, address to, uint256 tokenId, bytes memory data) = abi.decode(
      payload,
      (address, address, uint256, bytes)
    );
    require(!_exists(tokenId), "ERC721: token already exists");
    delete _burnedTokens[tokenId];
    _mint(to, tokenId);
    if (_isEventRegistered(HolographERC721Event.bridgeIn)) {
      require(SourceERC721().bridgeIn(fromChain, from, to, tokenId, data), "HOLOGRAPH: bridge in failed");
    }
    return Holographable.bridgeIn.selector;
  }

  function bridgeOut(
    uint32 toChain,
    address sender,
    bytes calldata payload
  ) external onlyBridge returns (bytes4 selector, bytes memory data) {
    (address from, address to, uint256 tokenId) = abi.decode(payload, (address, address, uint256));
    require(to != address(0), "ERC721: zero address");
    require(_isApproved(sender, tokenId), "ERC721: sender not approved");
    require(from == _tokenOwner[tokenId], "ERC721: from is not owner");
    if (_isEventRegistered(HolographERC721Event.bridgeOut)) {
      data = SourceERC721().bridgeOut(toChain, from, to, tokenId);
    }
    _burn(from, tokenId);
    return (Holographable.bridgeOut.selector, abi.encode(from, to, tokenId, data));
  }

  /**
   * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
   * are aware of the ERC721 protocol to prevent tokens from being forever locked.
   * @param from cannot be the zero address.
   * @param to cannot be the zero address.
   * @param tokenId token must exist and be owned by `from`.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external payable {
    safeTransferFrom(from, to, tokenId, "");
  }

  /**
   * @notice Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
   * @dev Since it's not being used, the _data variable is commented out to avoid compiler warnings.
   * are aware of the ERC721 protocol to prevent tokens from being forever locked.
   * @param from cannot be the zero address.
   * @param to cannot be the zero address.
   * @param tokenId token must exist and be owned by `from`.
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) public payable {
    require(_isApproved(msg.sender, tokenId), "ERC721: not approved sender");
    if (_isEventRegistered(HolographERC721Event.beforeSafeTransfer)) {
      require(SourceERC721().beforeSafeTransfer(from, to, tokenId, data));
    }
    _transferFrom(from, to, tokenId);
    if (_isContract(to)) {
      require(
        (ERC165(to).supportsInterface(ERC165.supportsInterface.selector) &&
          ERC165(to).supportsInterface(ERC721TokenReceiver.onERC721Received.selector) &&
          ERC721TokenReceiver(to).onERC721Received(address(this), from, tokenId, data) ==
          ERC721TokenReceiver.onERC721Received.selector),
        "ERC721: onERC721Received fail"
      );
    }
    if (_isEventRegistered(HolographERC721Event.afterSafeTransfer)) {
      require(SourceERC721().afterSafeTransfer(from, to, tokenId, data));
    }
  }

  /**
   * @notice Adds a new approved operator.
   * @dev Allows platforms to sell/transfer all your NFTs. Used with proxy contracts like OpenSea/Rarible.
   * @param to The address to approve.
   * @param approved Turn on or off approval status.
   */
  function setApprovalForAll(address to, bool approved) external {
    require(to != msg.sender, "ERC721: cannot approve self");
    if (_isEventRegistered(HolographERC721Event.beforeApprovalAll)) {
      require(SourceERC721().beforeApprovalAll(to, approved));
    }
    _operatorApprovals[msg.sender][to] = approved;
    emit ApprovalForAll(msg.sender, to, approved);
    if (_isEventRegistered(HolographERC721Event.afterApprovalAll)) {
      require(SourceERC721().afterApprovalAll(to, approved));
    }
  }

  /**
   * @dev Allows for source smart contract to burn a token.
   *  Note: this is put in place to make sure that custom logic could be implemented for merging, gamification, etc.
   *  Note: token cannot be burned if it's locked by bridge.
   */
  function sourceBurn(uint256 tokenId) external onlySource {
    address wallet = _tokenOwner[tokenId];
    _burn(wallet, tokenId);
  }

  /**
   * @dev Allows for source smart contract to mint a token.
   */
  function sourceMint(address to, uint224 tokenId) external onlySource {
    // uint32 is reserved for chain id to be used
    // we need to get current chain id, and prepend it to tokenId
    // this will prevent possible tokenId overlap if minting simultaneously on multiple chains is possible
    uint256 token = uint256(bytes32(abi.encodePacked(_chain(), tokenId)));
    require(!_burnedTokens[token], "ERC721: can't mint burned token");
    _mint(to, token);
  }

  /**
   * @dev Allows source to get the prepend for their tokenIds.
   */
  function sourceGetChainPrepend() external view onlySource returns (uint256) {
    return uint256(bytes32(abi.encodePacked(_chain(), uint224(0))));
  }

  /**
   * @dev Allows for source smart contract to mint a batch of tokens.
   */
  //   function sourceMintBatch(address to, uint224[] calldata tokenIds) external onlySource {
  //     require(tokenIds.length < 1000, "ERC721: max batch size is 1000");
  //     uint32 chain = _chain();
  //     uint256 token;
  //     for (uint256 i = 0; i < tokenIds.length; i++) {
  //       require(!_burnedTokens[token], "ERC721: can't mint burned token");
  //       token = uint256(bytes32(abi.encodePacked(chain, tokenIds[i])));
  //       require(!_burnedTokens[token], "ERC721: can't mint burned token");
  //       _mint(to, token);
  //     }
  //   }

  /**
   * @dev Allows for source smart contract to mint a batch of tokens.
   */
  //   function sourceMintBatch(address[] calldata wallets, uint224[] calldata tokenIds) external onlySource {
  //     require(wallets.length == tokenIds.length, "ERC721: array length missmatch");
  //     require(tokenIds.length < 1000, "ERC721: max batch size is 1000");
  //     uint32 chain = _chain();
  //     uint256 token;
  //     for (uint256 i = 0; i < tokenIds.length; i++) {
  //       token = uint256(bytes32(abi.encodePacked(chain, tokenIds[i])));
  //       require(!_burnedTokens[token], "ERC721: can't mint burned token");
  //       _mint(wallets[i], token);
  //     }
  //   }

  /**
   * @dev Allows for source smart contract to mint a batch of tokens.
   */
  //   function sourceMintBatchIncremental(
  //     address to,
  //     uint224 startingTokenId,
  //     uint256 length
  //   ) external onlySource {
  //     uint32 chain = _chain();
  //     uint256 token;
  //     for (uint256 i = 0; i < length; i++) {
  //       token = uint256(bytes32(abi.encodePacked(chain, startingTokenId)));
  //       require(!_burnedTokens[token], "ERC721: can't mint burned token");
  //       _mint(to, token);
  //       startingTokenId++;
  //     }
  //   }

  /**
   * @dev Allows for source smart contract to transfer a token.
   *  Note: this is put in place to make sure that custom logic could be implemented for merging, gamification, etc.
   *  Note: token cannot be transfered if it's locked by bridge.
   */
  function sourceTransfer(address to, uint256 tokenId) external onlySource {
    address wallet = _tokenOwner[tokenId];
    _transferFrom(wallet, to, tokenId);
  }

  /**
   * @notice Transfers `tokenId` token from `msg.sender` to `to`.
   * @dev WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
   * @param to cannot be the zero address.
   * @param tokenId token must be owned by `from`.
   */
  function transfer(address to, uint256 tokenId) external payable {
    transferFrom(msg.sender, to, tokenId, "");
  }

  /**
   * @notice Transfers `tokenId` token from `from` to `to`.
   * @dev WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
   * @param from  cannot be the zero address.
   * @param to cannot be the zero address.
   * @param tokenId token must be owned by `from`.
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public payable {
    transferFrom(from, to, tokenId, "");
  }

  /**
   * @notice Transfers `tokenId` token from `from` to `to`.
   * @dev WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
   * @dev Since it's not being used, the _data variable is commented out to avoid compiler warnings.
   * @param from  cannot be the zero address.
   * @param to cannot be the zero address.
   * @param tokenId token must be owned by `from`.
   * @param data additional data to pass.
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) public payable {
    require(_isApproved(msg.sender, tokenId), "ERC721: not approved sender");
    if (_isEventRegistered(HolographERC721Event.beforeTransfer)) {
      require(SourceERC721().beforeTransfer(from, to, tokenId, data));
    }
    _transferFrom(from, to, tokenId);
    if (_isEventRegistered(HolographERC721Event.afterTransfer)) {
      require(SourceERC721().afterTransfer(from, to, tokenId, data));
    }
  }

  /**
   * @notice Get total number of tokens owned by wallet.
   * @dev Used to see total amount of tokens owned by a specific wallet.
   * @param wallet Address for which to get token balance.
   * @return uint256 Returns an integer, representing total amount of tokens held by address.
   */
  function balanceOf(address wallet) public view returns (uint256) {
    require(wallet != address(0), "ERC721: zero address");
    return _ownedTokensCount[wallet];
  }

  function burned(uint256 tokenId) public view returns (bool) {
    return _burnedTokens[tokenId];
  }

  /**
   * @notice Decimal places to have for totalSupply.
   * @dev Since ERC721s are single, we use 0 as the decimal places to make sure a round number for totalSupply.
   * @return uint256 Returns the number of decimal places to have for totalSupply.
   */
  function decimals() external pure returns (uint256) {
    return 0;
  }

  function exists(uint256 tokenId) public view returns (bool) {
    return _tokenOwner[tokenId] != address(0);
  }

  /**
   * @notice Gets the approved address for the token.
   * @dev Single operator set for a specific token. Usually used for one-time very specific authorisations.
   * @param tokenId Token id to get approved operator for.
   * @return address Approved address for token.
   */
  function getApproved(uint256 tokenId) external view returns (address) {
    return _tokenApprovals[tokenId];
  }

  /**
   * @notice Checks if the address is approved.
   * @dev Includes references to OpenSea and Rarible marketplace proxies.
   * @param wallet Address of the wallet.
   * @param operator Address of the marketplace operator.
   * @return bool True if approved.
   */
  function isApprovedForAll(address wallet, address operator) external view returns (bool) {
    return _operatorApprovals[wallet][operator];
  }

  /**
   * @notice Checks who the owner of a token is.
   * @dev The token must exist.
   * @param tokenId The token to look up.
   * @return address Owner of the token.
   */
  function ownerOf(uint256 tokenId) external view returns (address) {
    address tokenOwner = _tokenOwner[tokenId];
    require(tokenOwner != address(0), "ERC721: token does not exist");
    return tokenOwner;
  }

  /**
   * @notice Get token by index.
   * @dev Used in conjunction with totalSupply function to iterate over all tokens in collection.
   * @param index Index of token in array.
   * @return uint256 Returns the token id of token located at that index.
   */
  function tokenByIndex(uint256 index) external view returns (uint256) {
    require(index < _allTokens.length, "ERC721: index out of bounds");
    return _allTokens[index];
  }

  /**
   * @notice Get set length list, starting from index, for all tokens.
   * @param index The index to start enumeration from.
   * @param length The length of returned results.
   * @return tokenIds uint256[] Returns a set length array of token ids minted.
   */
  function tokens(uint256 index, uint256 length) external view returns (uint256[] memory tokenIds) {
    uint256 supply = _allTokens.length;
    if (index + length > supply) {
      length = supply - index;
    }
    tokenIds = new uint256[](length);
    for (uint256 i = 0; i < length; i++) {
      tokenIds[i] = _allTokens[index + i];
    }
  }

  /**
   * @notice Get token from wallet by index instead of token id.
   * @dev Helpful for wallet token enumeration where token id info is not yet available. Use in conjunction with balanceOf function.
   * @param wallet Specific address for which to get token for.
   * @param index Index of token in array.
   * @return uint256 Returns the token id of token located at that index in specified wallet.
   */
  function tokenOfOwnerByIndex(address wallet, uint256 index) external view returns (uint256) {
    require(index < balanceOf(wallet), "ERC721: index out of bounds");
    return _ownedTokens[wallet][index];
  }

  /**
   * @notice Total amount of tokens in the collection.
   * @dev Ignores burned tokens.
   * @return uint256 Returns the total number of active (not burned) tokens.
   */
  function totalSupply() external view returns (uint256) {
    return _allTokens.length;
  }

  /**
   * @notice Empty function that is triggered by external contract on NFT transfer.
   * @dev We have this blank function in place to make sure that external contract sending in NFTs don't error out.
   * @dev Since it's not being used, the _operator variable is commented out to avoid compiler warnings.
   * @dev Since it's not being used, the _from variable is commented out to avoid compiler warnings.
   * @dev Since it's not being used, the _tokenId variable is commented out to avoid compiler warnings.
   * @dev Since it's not being used, the _data variable is commented out to avoid compiler warnings.
   * @return bytes4 Returns the interfaceId of onERC721Received.
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  ) external returns (bytes4) {
    require(_isContract(_operator), "ERC721: operator not contract");
    if (_isEventRegistered(HolographERC721Event.beforeOnERC721Received)) {
      require(SourceERC721().beforeOnERC721Received(_operator, _from, address(this), _tokenId, _data));
    }
    try HolographERC721Interface(_operator).ownerOf(_tokenId) returns (address tokenOwner) {
      require(tokenOwner == address(this), "ERC721: contract not token owner");
    } catch {
      revert("ERC721: token does not exist");
    }
    if (_isEventRegistered(HolographERC721Event.afterOnERC721Received)) {
      require(SourceERC721().afterOnERC721Received(_operator, _from, address(this), _tokenId, _data));
    }
    return ERC721TokenReceiver.onERC721Received.selector;
  }

  /**
   * @dev Add a newly minted token into managed list of tokens.
   * @param to Address of token owner for which to add the token.
   * @param tokenId Id of token to add.
   */
  function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
    _ownedTokensIndex[tokenId] = _ownedTokensCount[to];
    _ownedTokensCount[to]++;
    _ownedTokens[to].push(tokenId);
    _allTokensIndex[tokenId] = _allTokens.length;
    _allTokens.push(tokenId);
  }

  /**
   * @notice Burns the token.
   * @dev All validation needs to be done before calling this function.
   * @param wallet Address of current token owner.
   * @param tokenId The token to burn.
   */
  function _burn(address wallet, uint256 tokenId) private {
    _clearApproval(tokenId);
    _tokenOwner[tokenId] = address(0);
    emit Transfer(wallet, address(0), tokenId);
    _removeTokenFromOwnerEnumeration(wallet, tokenId);
    _burnedTokens[tokenId] = true;
  }

  /**
   * @notice Deletes a token from the approval list.
   * @dev Removes from count.
   * @param tokenId T.
   */
  function _clearApproval(uint256 tokenId) private {
    delete _tokenApprovals[tokenId];
  }

  /**
   * @notice Mints an NFT.
   * @dev Can to mint the token to the zero address and the token cannot already exist.
   * @param to Address to mint to.
   * @param tokenId The new token.
   */
  function _mint(address to, uint256 tokenId) private {
    require(tokenId > 0, "ERC721: token id cannot be zero");
    require(to != address(0), "ERC721: minting to burn address");
    require(!_exists(tokenId), "ERC721: token already exists");
    require(!_burnedTokens[tokenId], "ERC721: token has been burned");
    _tokenOwner[tokenId] = to;
    emit Transfer(address(0), to, tokenId);
    _addTokenToOwnerEnumeration(to, tokenId);
  }

  function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
    uint256 lastTokenIndex = _allTokens.length - 1;
    uint256 tokenIndex = _allTokensIndex[tokenId];
    uint256 lastTokenId = _allTokens[lastTokenIndex];
    _allTokens[tokenIndex] = lastTokenId;
    _allTokensIndex[lastTokenId] = tokenIndex;
    delete _allTokensIndex[tokenId];
    delete _allTokens[lastTokenIndex];
    _allTokens.pop();
  }

  /**
   * @dev Remove a token from managed list of tokens.
   * @param from Address of token owner for which to remove the token.
   * @param tokenId Id of token to remove.
   */
  function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
    _removeTokenFromAllTokensEnumeration(tokenId);
    _ownedTokensCount[from]--;
    uint256 lastTokenIndex = _ownedTokensCount[from];
    uint256 tokenIndex = _ownedTokensIndex[tokenId];
    if (tokenIndex != lastTokenIndex) {
      uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
      _ownedTokens[from][tokenIndex] = lastTokenId;
      _ownedTokensIndex[lastTokenId] = tokenIndex;
    }
    if (lastTokenIndex == 0) {
      delete _ownedTokens[from];
    } else {
      delete _ownedTokens[from][lastTokenIndex];
      _ownedTokens[from].pop();
    }
  }

  /**
   * @dev Primary private function that handles the transfer/mint/burn functionality.
   * @param from Address from where token is being transferred. Zero address means it is being minted.
   * @param to Address to whom the token is being transferred. Zero address means it is being burned.
   * @param tokenId Id of token that is being transferred/minted/burned.
   */
  function _transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) private {
    require(_tokenOwner[tokenId] == from, "ERC721: token not owned");
    require(to != address(0), "ERC721: use burn instead");
    _clearApproval(tokenId);
    _tokenOwner[tokenId] = to;
    emit Transfer(from, to, tokenId);
    _removeTokenFromOwnerEnumeration(from, tokenId);
    _addTokenToOwnerEnumeration(to, tokenId);
  }

  function _chain() private view returns (uint32) {
    uint32 currentChain = HolographInterface(HolographerInterface(payable(address(this))).getHolograph())
      .getHolographChainId();
    if (currentChain != HolographerInterface(payable(address(this))).getOriginChain()) {
      return currentChain;
    }
    return uint32(0);
  }

  /**
   * @notice Checks if the token owner exists.
   * @dev If the address is the zero address no owner exists.
   * @param tokenId The affected token.
   * @return bool True if it exists.
   */
  function _exists(uint256 tokenId) private view returns (bool) {
    address tokenOwner = _tokenOwner[tokenId];
    return tokenOwner != address(0);
  }

  /**
   * @notice Checks if the address is an approved one.
   * @dev Uses inlined checks for different usecases of approval.
   * @param spender Address of the spender.
   * @param tokenId The affected token.
   * @return bool True if approved.
   */
  function _isApproved(address spender, uint256 tokenId) private view returns (bool) {
    require(_exists(tokenId), "ERC721: token does not exist");
    address tokenOwner = _tokenOwner[tokenId];
    return (spender == tokenOwner || _tokenApprovals[tokenId] == spender || _operatorApprovals[tokenOwner][spender]);
  }

  function _isContract(address contractAddress) private view returns (bool) {
    bytes32 codehash;
    assembly {
      codehash := extcodehash(contractAddress)
    }
    return (codehash != 0x0 && codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
  }

  /**
   * @dev Get the source smart contract as bridgeable interface.
   */
  function SourceERC721() private view returns (HolographedERC721 sourceContract) {
    assembly {
      sourceContract := sload(_sourceContractSlot)
    }
  }

  /**
   * @dev Get the interfaces contract address.
   */
  function _interfaces() private view returns (address) {
    return _holograph().getInterfaces();
  }

  function owner() public view override returns (address) {
    Ownable ownableContract;
    assembly {
      ownableContract := sload(_sourceContractSlot)
    }
    return ownableContract.owner();
  }

  function _holograph() private view returns (HolographInterface holograph) {
    assembly {
      holograph := sload(_holographSlot)
    }
  }

  /**
   * @dev Get the bridge contract address.
   */
  function _royalties() private view returns (address) {
    return
      HolographRegistryInterface(_holograph().getRegistry()).getContractTypeAddress(
        0x0000000000000000000000000000000000000000000000000000000050413144
      );
  }

  /**
   * @dev Purposefully left empty, to prevent running out of gas errors when receiving native token payments.
   */
  receive() external payable {}

  /**
   * @notice Fallback to the source contract.
   * @dev Any function call that is not covered here, will automatically be sent over to the source contract.
   */
  fallback() external payable {
    // we check if royalties support the function, send there, otherwise revert to source
    address _target;
    if (HolographInterfacesInterface(_interfaces()).supportsInterface(InterfaceType.PA1D, msg.sig)) {
      _target = _royalties();
      assembly {
        calldatacopy(0, 0, calldatasize())
        let result := delegatecall(gas(), _target, 0, calldatasize(), 0, 0)
        returndatacopy(0, 0, returndatasize())
        switch result
        case 0 {
          revert(0, returndatasize())
        }
        default {
          return(0, returndatasize())
        }
      }
    } else {
      assembly {
        calldatacopy(0, 0, calldatasize())
        mstore(calldatasize(), caller())
        let result := call(gas(), sload(_sourceContractSlot), callvalue(), 0, add(calldatasize(), 32), 0, 0)
        returndatacopy(0, 0, returndatasize())
        switch result
        case 0 {
          revert(0, returndatasize())
        }
        default {
          return(0, returndatasize())
        }
      }
    }
  }

  function _isEventRegistered(HolographERC721Event _eventName) private view returns (bool) {
    return ((_eventConfig >> uint256(_eventName)) & uint256(1) == 1 ? true : false);
  }
}
