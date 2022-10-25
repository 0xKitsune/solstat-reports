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

import "./abstract/Admin.sol";
import "./abstract/Initializable.sol";

import "./interface/CrossChainMessageInterface.sol";
import "./interface/HolographBridgeInterface.sol";
import "./interface/HolographERC20Interface.sol";
import "./interface/HolographInterface.sol";
import "./interface/HolographOperatorInterface.sol";
import "./interface/HolographRegistryInterface.sol";
import "./interface/InitializableInterface.sol";
import "./interface/HolographInterfacesInterface.sol";
import "./interface/Ownable.sol";

import "./struct/OperatorJob.sol";

/**
 * @title Holograph Operator
 * @author https://github.com/holographxyz
 * @notice Participate in the Holograph Protocol by becoming an Operator
 * @dev This contract allows operators to bond utility tokens and help execute operator jobs
 */
contract HolographOperator is Admin, Initializable, HolographOperatorInterface {
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.bridge')) - 1)
   */
  bytes32 constant _bridgeSlot = 0xeb87cbb21687feb327e3d58c6c16d552231d12c7a0e8115042a4165fac8a77f9;
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.holograph')) - 1)
   */
  bytes32 constant _holographSlot = 0xb4107f746e9496e8452accc7de63d1c5e14c19f510932daa04077cd49e8bd77a;
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.interfaces')) - 1)
   */
  bytes32 constant _interfacesSlot = 0xbd3084b8c09da87ad159c247a60e209784196be2530cecbbd8f337fdd1848827;
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.jobNonce')) - 1)
   */
  bytes32 constant _jobNonceSlot = 0x1cda64803f3b43503042e00863791e8d996666552d5855a78d53ee1dd4b3286d;
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.messagingModule')) - 1)
   */
  bytes32 constant _messagingModuleSlot = 0x54176250282e65985d205704ffce44a59efe61f7afd99e29fda50f55b48c061a;
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.registry')) - 1)
   */
  bytes32 constant _registrySlot = 0xce8e75d5c5227ce29a4ee170160bb296e5dea6934b80a9bd723f7ef1e7c850e7;
  /**
   * @dev bytes32(uint256(keccak256('eip1967.Holograph.utilityToken')) - 1)
   */
  bytes32 constant _utilityTokenSlot = 0xbf76518d46db472b71aa7677a0908b8016f3dee568415ffa24055f9a670f9c37;

  /**
   * @dev Internal number (in seconds), used for defining a window for operator to execute the job
   */
  uint256 private _blockTime;

  /**
   * @dev Minimum amount of tokens needed for bonding
   */
  uint256 private _baseBondAmount;

  /**
   * @dev The multiplier used for calculating bonding amount for pods
   */
  uint256 private _podMultiplier;

  /**
   * @dev The threshold used for limiting number of operators in a pod
   */
  uint256 private _operatorThreshold;

  /**
   * @dev The threshold step used for increasing bond amount once threshold is reached
   */
  uint256 private _operatorThresholdStep;

  /**
   * @dev The threshold divisor used for increasing bond amount once threshold is reached
   */
  uint256 private _operatorThresholdDivisor;

  /**
   * @dev Internal counter of all cross-chain messages received
   */
  uint256 private _inboundMessageCounter;

  /**
   * @dev Internal mapping of operator job details for a specific job hash
   */
  mapping(bytes32 => uint256) private _operatorJobs;

  /**
   * @dev Internal mapping of operator job details for a specific job hash
   */
  mapping(bytes32 => bool) private _failedJobs;

  /**
   * @dev Internal mapping of operator addresses, used for temp storage when defining an operator job
   */
  mapping(uint256 => address) private _operatorTempStorage;

  /**
   * @dev Internal index used for storing/referencing operator temp storage
   */
  uint32 private _operatorTempStorageCounter;

  /**
   * @dev Multi-dimensional array of available operators
   */
  address[][] private _operatorPods;

  /**
   * @dev Internal mapping of bonded operators, to prevent double bonding
   */
  mapping(address => uint256) private _bondedOperators;

  /**
   * @dev Internal mapping of bonded operators, to prevent double bonding
   */
  mapping(address => uint256) private _operatorPodIndex;

  /**
   * @dev Internal mapping of bonded operator amounts
   */
  mapping(address => uint256) private _bondedAmounts;

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
    require(!_isInitialized(), "HOLOGRAPH: already initialized");
    (address bridge, address holograph, address interfaces, address registry, address utilityToken) = abi.decode(
      initPayload,
      (address, address, address, address, address)
    );
    assembly {
      sstore(_adminSlot, origin())
      sstore(_bridgeSlot, bridge)
      sstore(_holographSlot, holograph)
      sstore(_interfacesSlot, interfaces)
      sstore(_registrySlot, registry)
      sstore(_utilityTokenSlot, utilityToken)
    }
    _blockTime = 60; // 60 seconds allowed for execution
    unchecked {
      _baseBondAmount = 100 * (10**18); // one single token unit * 100
    }
    // how much to increase bond amount per pod
    _podMultiplier = 2; // 1, 4, 16, 64
    // starting pod max amount
    _operatorThreshold = 1000;
    // how often to increase price per each operator
    _operatorThresholdStep = 10;
    // we want to multiply by decimals, but instead will have to divide
    _operatorThresholdDivisor = 100; // == * 0.01
    // set first operator for each pod as zero address
    _operatorPods = [[address(0)]];
    // mark zero address as bonded operator, to prevent abuse
    _bondedOperators[address(0)] = 1;
    _setInitialized();
    return InitializableInterface.init.selector;
  }

  /**
   * @dev temp function, used for quicker updates/resets during development
   *      NOT PART OF FINAL CODE !!!
   */
  function resetOperator(
    uint256 blockTime,
    uint256 baseBondAmount,
    uint256 podMultiplier,
    uint256 operatorThreshold,
    uint256 operatorThresholdStep,
    uint256 operatorThresholdDivisor
  ) external onlyAdmin {
    _blockTime = blockTime;
    _baseBondAmount = baseBondAmount;
    _podMultiplier = podMultiplier;
    _operatorThreshold = operatorThreshold;
    _operatorThresholdStep = operatorThresholdStep;
    _operatorThresholdDivisor = operatorThresholdDivisor;
    _operatorPods = [[address(0)]];
    _bondedOperators[address(0)] = 1;
  }

  /**
   * @notice Execute an available operator job
   * @dev When making this call, if operating criteria is not met, the call will revert
   * @param bridgeInRequestPayload the entire cross chain message payload
   */
  function executeJob(bytes calldata bridgeInRequestPayload) external payable {
    /**
     * @dev derive the payload hash for use in mappings
     */
    bytes32 hash = keccak256(bridgeInRequestPayload);
    /**
     * @dev check that job exists
     */
    require(_operatorJobs[hash] > 0, "HOLOGRAPH: invalid job");
    uint256 gasLimit = 0;
    uint256 gasPrice = 0;
    assembly {
      /**
       * @dev extract gasLimit
       */
      gasLimit := calldataload(sub(add(bridgeInRequestPayload.offset, bridgeInRequestPayload.length), 0x40))
      /**
       * @dev extract gasPrice
       */
      gasPrice := calldataload(sub(add(bridgeInRequestPayload.offset, bridgeInRequestPayload.length), 0x20))
    }
    /**
     * @dev unpack bitwise packed operator job details
     */
    OperatorJob memory job = getJobDetails(hash);
    /**
     * @dev to prevent replay attacks, remove job from mapping
     */
    delete _operatorJobs[hash];
    /**
     * @dev check that a specific operator was selected for the job
     */
    if (job.operator != address(0)) {
      /**
       * @dev switch pod to index based value
       */
      uint256 pod = job.pod - 1;
      /**
       * @dev check if sender is not the selected primary operator
       */
      if (job.operator != msg.sender) {
        /**
         * @dev sender is not selected operator, need to check if allowed to do job
         */
        uint256 elapsedTime = block.timestamp - uint256(job.startTimestamp);
        uint256 timeDifference = elapsedTime / job.blockTimes;
        /**
         * @dev validate that initial selected operator time slot is still active
         */
        require(timeDifference > 0, "HOLOGRAPH: operator has time");
        /**
         * @dev check that the selected missed the time slot due to a gas spike
         */
        require(gasPrice >= tx.gasprice, "HOLOGRAPH: gas spike detected");
        /**
         * @dev check if time is within fallback operator slots
         */
        if (timeDifference < 6) {
          uint256 podIndex = uint256(job.fallbackOperators[timeDifference - 1]);
          /**
           * @dev do a quick sanity check to make sure operator did not leave from index or is a zero address
           */
          if (podIndex > 0 && podIndex < _operatorPods[pod].length) {
            address fallbackOperator = _operatorPods[pod][podIndex];
            /**
             * @dev ensure that sender is currently valid backup operator
             */
            require(fallbackOperator == msg.sender, "HOLOGRAPH: invalid fallback");
          }
        }
        /**
         * @dev time to reward the current operator
         */
        uint256 amount = _getBaseBondAmount(pod);
        /**
         * @dev select operator that failed to do the job, is slashed the pod base fee
         */
        _bondedAmounts[job.operator] -= amount;
        /**
         * @dev the slashed amount is sent to current operator
         */
        _bondedAmounts[msg.sender] += amount;
        /**
         * @dev check if slashed operator has enough tokens bonded to stay
         */
        if (_bondedAmounts[job.operator] >= amount) {
          /**
           * @dev enough bond amount leftover, put operator back in
           */
          _operatorPods[pod].push(job.operator);
          _operatorPodIndex[job.operator] = _operatorPods[pod].length - 1;
          _bondedOperators[job.operator] = job.pod;
        } else {
          /**
           * @dev slashed operator does not have enough tokens bonded, return remaining tokens only
           */
          uint256 leftovers = _bondedAmounts[job.operator];
          if (leftovers > 0) {
            _bondedAmounts[job.operator] = 0;
            _utilityToken().transfer(job.operator, leftovers);
          }
        }
      } else {
        /**
         * @dev the selected operator is executing the job
         */
        _operatorPods[pod].push(msg.sender);
        _operatorPodIndex[job.operator] = _operatorPods[pod].length - 1;
        _bondedOperators[msg.sender] = job.pod;
      }
    }
    /**
     * @dev ensure that there is enough has left for the job
     */
    require(gasleft() > gasLimit, "HOLOGRAPH: not enough gas left");
    /**
     * @dev execute the job
     */
    try
      HolographOperatorInterface(address(this)).nonRevertingBridgeCall{value: msg.value}(
        msg.sender,
        bridgeInRequestPayload
      )
    {
      /// @dev do nothing
    } catch {
      _failedJobs[hash] = true;
      emit FailedOperatorJob(hash);
    }
    /**
     * @dev every executed job (even if failed) increments total message counter by one
     */
    ++_inboundMessageCounter;
    /**
     * @dev reward operator (with HLG) for executing the job
     * @dev this is out of scope and is purposefully omitted from code
     */
    ////  _bondedOperators[msg.sender] += reward;
  }

  /*
   * @dev Purposefully made to be external so that Operator can call it during executeJob function
   *      Check the executeJob function to understand it's implementation
   */
  function nonRevertingBridgeCall(address msgSender, bytes calldata payload) external payable {
    require(msg.sender == address(this), "HOLOGRAPH: operator only call");
    assembly {
      /**
       * @dev remove gas price from end
       */
      calldatacopy(0, payload.offset, sub(payload.length, 0x20))
      /**
       * @dev hToken recipient is injected right before making the call
       */
      mstore(0x84, msgSender)
      /**
       * @dev make non-reverting call
       */
      let result := call(
        /// @dev gas limit is retrieved from last 32 bytes of payload in-memory value
        mload(sub(payload.length, 0x40)),
        /// @dev destination is bridge contract
        sload(_bridgeSlot),
        /// @dev any value is passed along
        callvalue(),
        /// @dev data is retrieved from 0 index memory position
        0,
        /// @dev everything except for last 32 bytes (gas limit) is sent
        sub(payload.length, 0x40),
        0,
        0
      )
      if eq(result, 0) {
        revert(0, 0)
      }
      return(0, 0)
    }
  }

  /**
   * @notice Receive a cross-chain message
   * @dev This function is restricted for use by Holograph Messaging Module only
   */
  function crossChainMessage(bytes calldata bridgeInRequestPayload) external payable {
    require(msg.sender == address(_messagingModule()), "HOLOGRAPH: messaging only call");
    /**
     * @dev would be a good idea to check payload gas price here and if it is significantly lower than current amount
     *      to set zero address as operator to not lock-up an operator unnecessarily
     */
    unchecked {
      bytes32 jobHash = keccak256(bridgeInRequestPayload);
      /**
       * @dev load and increment operator temp storage in one call
       */
      ++_operatorTempStorageCounter;
      /**
       * @dev use job hash, job nonce, block number, and block timestamp for generating a random number
       */
      uint256 random = uint256(keccak256(abi.encodePacked(jobHash, _jobNonce(), block.number, block.timestamp)));
      /**
       * @dev divide by total number of pods, use modulus/remainder
       */
      uint256 pod = random % _operatorPods.length;
      /**
       * @dev identify the total number of available operators in pod
       */
      uint256 podSize = _operatorPods[pod].length;
      /**
       * @dev select a primary operator
       */
      uint256 operatorIndex = random % podSize;
      /**
       * @dev If operator index is 0, then it's open season! Anyone can execute this job. First come first serve
       *      pop operator to ensure that they cannot be selected for any other job until this one completes
       *      decrease pod size to accomodate popped operator
       */
      _operatorTempStorage[_operatorTempStorageCounter] = _operatorPods[pod][operatorIndex];
      _popOperator(pod, operatorIndex);
      if (podSize > 1) {
        podSize--;
      }
      _operatorJobs[jobHash] = uint256(
        ((pod + 1) << 248) |
          (uint256(_operatorTempStorageCounter) << 216) |
          (block.number << 176) |
          (_randomBlockHash(random, podSize, 1) << 160) |
          (_randomBlockHash(random, podSize, 2) << 144) |
          (_randomBlockHash(random, podSize, 3) << 128) |
          (_randomBlockHash(random, podSize, 4) << 112) |
          (_randomBlockHash(random, podSize, 5) << 96) |
          (block.timestamp << 16) |
          0
      ); // 80 next available bit position && so far 176 bits used with only 128 left
      /**
       * @dev emit event to signal to operators that a job has become available
       */
      emit AvailableOperatorJob(jobHash, bridgeInRequestPayload);
    }
  }

  /**
   * @notice Calculate the amount of gas needed to execute a bridgeInRequest
   * @dev Use this function to estimate the amount of gas that will be used by the bridgeInRequest function
   *      Set a specific gas limit when making this call, subtract return value, to get total gas used
   *      Only use this with a static call
   * @param bridgeInRequestPayload abi encoded bytes making up the bridgeInRequest payload
   * @return the gas amount remaining after the static call is returned
   */
  function jobEstimator(bytes calldata bridgeInRequestPayload) external payable returns (uint256) {
    assembly {
      calldatacopy(0, bridgeInRequestPayload.offset, sub(bridgeInRequestPayload.length, 0x40))
      /**
       * @dev bridgeInRequest doNotRevert is purposefully set to false so a rever would happen
       */
      mstore8(0xE3, 0x00)
      let result := call(gas(), sload(_bridgeSlot), callvalue(), 0, sub(bridgeInRequestPayload.length, 0x40), 0, 0)
      /**
       * @dev if for some reason the call does not revert, it is force reverted
       */
      if eq(result, 1) {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
      /**
       * @dev remaining gas is set as the return value
       */
      mstore(0x00, gas())
      return(0x00, 0x20)
    }
  }

  /**
   * @notice Send cross chain bridge request message
   * @dev This function is restricted to only be callable by Holograph Bridge
   * @param gasLimit maximum amount of gas to spend for executing the beam on destination chain
   * @param gasPrice maximum amount of gas price (in destination chain native gas token) to pay on destination chain
   * @param toChain Holograph Chain ID where the beam is being sent to
   * @param nonce incremented number used to ensure job hashes are unique
   * @param holographableContract address of the contract for which the bridge request is being made
   * @param bridgeOutPayload bytes made up of the bridgeOutRequest payload
   */
  function send(
    uint256 gasLimit,
    uint256 gasPrice,
    uint32 toChain,
    address msgSender,
    uint256 nonce,
    address holographableContract,
    bytes calldata bridgeOutPayload
  ) external payable {
    require(msg.sender == _bridge(), "HOLOGRAPH: bridge only call");
    CrossChainMessageInterface messagingModule = _messagingModule();
    uint256 hlgFee = messagingModule.getHlgFee(toChain, gasLimit, gasPrice);
    address hToken = _registry().getHToken(_holograph().getHolographChainId());
    require(hlgFee < msg.value, "HOLOGRAPH: not enough value");
    payable(hToken).transfer(hlgFee);
    bytes memory encodedData = abi.encodeWithSelector(
      HolographBridgeInterface.bridgeInRequest.selector,
      /**
       * @dev job nonce is an incremented value that is assigned to each bridge request to guarantee unique hashes
       */
      nonce,
      /**
       * @dev including the current holograph chain id (origin chain)
       */
      _holograph().getHolographChainId(),
      /**
       * @dev holographable contract have the same address across all chains, so our destination address will be the same
       */
      holographableContract,
      /**
       * @dev get the current chain's hToken for native gas token
       */
      hToken,
      /**
       * @dev recipient will be defined when operator picks up the job
       */
      address(0),
      /**
       * @dev value is set to zero for now
       */
      hlgFee,
      /**
       * @dev specify that function call should not revert
       */
      true,
      /**
       * @dev attach actual holographableContract function call
       */
      bridgeOutPayload
    );
    /**
     * @dev add gas variables to the back for later extraction
     */
    encodedData = abi.encodePacked(encodedData, gasLimit, gasPrice);
    /**
     * @dev Send the data to the current Holograph Messaging Module
     *      This will be changed to dynamically select which messaging module to use based on destination network
     */
    messagingModule.send{value: msg.value - hlgFee}(
      gasLimit,
      gasPrice,
      toChain,
      msgSender,
      msg.value - hlgFee,
      encodedData
    );
    /**
     * @dev for easy indexing, an event is emitted with the payload hash for status tracking
     */
    emit CrossChainMessageSent(keccak256(encodedData));
  }

  /**
   * @notice Get the fees associated with sending specific payload
   * @dev Will provide exact costs on protocol and message side, combine the two to get total
   * @dev @param toChain holograph chain id of destination chain for payload
   * @dev @param gasLimit amount of gas to provide for executing payload on destination chain
   * @dev @param gasPrice maximum amount to pay for gas price, can be set to 0 and will be chose automatically
   * @dev @param crossChainPayload the entire packet being sent cross-chain
   * @return hlgFee the amount (in wei) of native gas token that will cost for finalizing job on destiantion chain
   * @return msgFee the amount (in wei) of native gas token that will cost for sending message to destiantion chain
   */
  function getMessageFee(
    uint32,
    uint256,
    uint256,
    bytes calldata
  ) external view returns (uint256, uint256) {
    assembly {
      calldatacopy(0, 0, calldatasize())
      let result := staticcall(gas(), sload(_messagingModuleSlot), 0, calldatasize(), 0, 0)
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

  /**
   * @notice Get the details for an available operator job
   * @dev The job hash is a keccak256 hash of the entire job payload
   * @param jobHash keccak256 hash of the job
   * @return an OperatorJob struct with details about a specific job
   */
  function getJobDetails(bytes32 jobHash) public view returns (OperatorJob memory) {
    uint256 packed = _operatorJobs[jobHash];
    /**
     * @dev The job is bitwise packed into a single 32 byte slot, this unpacks it before returning the struct
     */
    return
      OperatorJob(
        uint8(packed >> 248),
        uint16(_blockTime),
        _operatorTempStorage[uint32(packed >> 216)],
        uint40(packed >> 176),
        // TODO: move the bit-shifting around to have it be sequential
        uint64(packed >> 16),
        [
          uint16(packed >> 160),
          uint16(packed >> 144),
          uint16(packed >> 128),
          uint16(packed >> 112),
          uint16(packed >> 96)
        ]
      );
  }

  /**
   * @notice Get number of pods available
   * @dev This returns number of pods that have been opened via bonding
   */
  function getTotalPods() external view returns (uint256 totalPods) {
    return _operatorPods.length;
  }

  /**
   * @notice Get total number of operators in a pod
   * @dev Use in conjunction with paginated getPodOperators function
   * @param pod the pod to query
   * @return total operators in a pod
   */
  function getPodOperatorsLength(uint256 pod) external view returns (uint256) {
    require(_operatorPods.length >= pod, "HOLOGRAPH: pod does not exist");
    return _operatorPods[pod - 1].length;
  }

  /**
   * @notice Get list of operators in a pod
   * @dev Use paginated getPodOperators function instead if list gets too long
   * @param pod the pod to query
   * @return operators array list of operators in a pod
   */
  function getPodOperators(uint256 pod) external view returns (address[] memory operators) {
    require(_operatorPods.length >= pod, "HOLOGRAPH: pod does not exist");
    operators = _operatorPods[pod - 1];
  }

  /**
   * @notice Get paginated list of operators in a pod
   * @dev Use in conjunction with getPodOperatorsLength to know the total length of results
   * @param pod the pod to query
   * @param index the array index to start from
   * @param length the length of result set to be (will be shorter if reached end of array)
   * @return operators a paginated array of operators
   */
  function getPodOperators(
    uint256 pod,
    uint256 index,
    uint256 length
  ) external view returns (address[] memory operators) {
    require(_operatorPods.length >= pod, "HOLOGRAPH: pod does not exist");
    /**
     * @dev if pod 0 is selected, this will create a revert
     */
    pod--;
    /**
     * @dev get total length of pod operators
     */
    uint256 supply = _operatorPods[pod].length;
    /**
     * @dev check if length is out of bounds for this result set
     */
    if (index + length > supply) {
      /**
       * @dev adjust length to return remainder of the results
       */
      length = supply - index;
    }
    /**
     * @dev create in-memory array
     */
    operators = new address[](length);
    /**
     * @dev add operators to result set
     */
    for (uint256 i = 0; i < length; i++) {
      operators[i] = _operatorPods[pod][index + i];
    }
  }

  /**
   * @notice Check the base and current price for bonding to a particular pod
   * @dev Useful for understanding what is required for bonding to a pod
   * @param pod the pod to get bonding amounts for
   * @return base the base bond amount required for a pod
   * @return current the current bond amount required for a pod
   */
  function getPodBondAmounts(uint256 pod) external view returns (uint256 base, uint256 current) {
    base = _getBaseBondAmount(pod - 1);
    current = _getCurrentBondAmount(pod - 1);
  }

  /**
   * @notice Get an operator's currently bonded amount
   * @dev Useful for checking how much an operator has bonded
   * @param operator address of operator to check
   * @return amount total number of utility token bonded
   */
  function getBondedAmount(address operator) external view returns (uint256 amount) {
    return _bondedAmounts[operator];
  }

  /**
   * @notice Get an operator's currently bonded pod
   * @dev Useful for checking if an operator is currently bonded
   * @param operator address of operator to check
   * @return pod number that operator is bonded on, returns zero if not bonded or selected for job
   */
  function getBondedPod(address operator) external view returns (uint256 pod) {
    return _bondedOperators[operator];
  }

  /**
   * @notice Topup a bonded operator with more utility tokens
   * @dev Useful function if an operator got slashed and wants to add a safety buffer to not get unbonded
   *      This function will not work if operator has currently been selected for a job
   * @param operator address of operator to topup
   * @param amount utility token amount to add
   */
  function topupUtilityToken(address operator, uint256 amount) external {
    /**
     * @dev check that an operator is currently bonded
     */
    require(_bondedOperators[operator] != 0, "HOLOGRAPH: operator not bonded");
    unchecked {
      /**
       * @dev add the additional amount to operator
       */
      _bondedAmounts[operator] += amount;
    }
    /**
     * @dev transfer tokens last, to prevent reentrancy attacks
     */
    require(_utilityToken().transferFrom(msg.sender, address(this), amount), "HOLOGRAPH: token transfer failed");
  }

  /**
   * @notice Bond utility tokens and become an operator
   * @dev An operator can only bond to one pod at a time, per network
   * @param operator address of operator to bond (can be an ownable smart contract)
   * @param amount utility token amount to bond (can be greater than minimum)
   * @param pod number of pod to bond to (can be for one that does not exist yet)
   */
  function bondUtilityToken(
    address operator,
    uint256 amount,
    uint256 pod
  ) external {
    /**
     * @dev an operator can only bond to one pod at any give time per network
     */
    require(_bondedOperators[operator] == 0 && _bondedAmounts[operator] == 0, "HOLOGRAPH: operator is bonded");
    unchecked {
      /**
       * @dev get the current bonding minimum for selected pod
       */
      uint256 current = _getCurrentBondAmount(pod - 1);
      require(current <= amount, "HOLOGRAPH: bond amount too small");
      /**
       * @dev check if selected pod is greater than currently existing pods
       */
      if (_operatorPods.length < pod) {
        /**
         * @dev activate pod(s) up until the selected pod
         */
        for (uint256 i = _operatorPods.length; i <= pod; i++) {
          /**
           * @dev add zero address into pod to mitigate empty pod issues
           */
          _operatorPods.push([address(0)]);
        }
      }
      /**
       * @dev prevent bonding to a pod with more than uint16 max value
       */
      require(_operatorPods[pod - 1].length < type(uint16).max, "HOLOGRAPH: too many operators");
      _operatorPods[pod - 1].push(operator);
      _operatorPodIndex[operator] = _operatorPods[pod - 1].length - 1;
      _bondedOperators[operator] = pod;
      _bondedAmounts[operator] = amount;
      /**
       * @dev transfer tokens last, to prevent reentrancy attacks
       */
      require(_utilityToken().transferFrom(msg.sender, address(this), amount), "HOLOGRAPH: token transfer failed");
    }
  }

  /**
   * @notice Unbond HLG utility tokens and stop being an operator
   * @dev A bonded operator selected for a job cannot unbond until they complete the job, or are slashed
   * @param operator address of operator to unbond
   * @param recipient address where to send the bonded tokens
   */
  function unbondUtilityToken(address operator, address recipient) external {
    /**
     * @dev validate that operator is currently bonded
     */
    require(_bondedOperators[operator] != 0, "HOLOGRAPH: operator not bonded");
    /**
     * @dev check if sender is not actual operator
     */
    if (msg.sender != operator) {
      /**
       * @dev check if operator is a smart contract
       */
      require(_isContract(operator), "HOLOGRAPH: operator not contract");
      /**
       * @dev check if smart contract is owned by sender
       */
      require(Ownable(operator).isOwner(msg.sender), "HOLOGRAPH: sender not owner");
    }
    /**
     * @dev get current bonded amount by operator
     */
    uint256 amount = _bondedAmounts[operator];
    /**
     * @dev unset operator bond amount before making a transfer
     */
    _bondedAmounts[operator] = 0;
    /**
     * @dev remove all operator references
     */
    _popOperator(_bondedOperators[operator] - 1, _operatorPodIndex[operator]);
    /**
     * @dev transfer tokens to recipient
     */
    require(_utilityToken().transfer(recipient, amount), "HOLOGRAPH: token transfer failed");
  }

  /**
   * @notice Get the address of the Holograph Bridge module
   * @dev Used for beaming holographable assets cross-chain
   */
  function getBridge() external view returns (address bridge) {
    assembly {
      bridge := sload(_bridgeSlot)
    }
  }

  /**
   * @notice Update the Holograph Bridge module address
   * @param bridge address of the Holograph Bridge smart contract to use
   */
  function setBridge(address bridge) external onlyAdmin {
    assembly {
      sstore(_bridgeSlot, bridge)
    }
  }

  /**
   * @notice Get the Holograph Protocol contract
   * @dev Used for storing a reference to all the primary modules and variables of the protocol
   */
  function getHolograph() external view returns (address holograph) {
    assembly {
      holograph := sload(_holographSlot)
    }
  }

  /**
   * @notice Update the Holograph Protocol contract address
   * @param holograph address of the Holograph Protocol smart contract to use
   */
  function setHolograph(address holograph) external onlyAdmin {
    assembly {
      sstore(_holographSlot, holograph)
    }
  }

  /**
   * @notice Get the address of the Holograph Interfaces module
   * @dev Holograph uses this contract to store data that needs to be accessed by a large portion of the modules
   */
  function getInterfaces() external view returns (address interfaces) {
    assembly {
      interfaces := sload(_interfacesSlot)
    }
  }

  /**
   * @notice Update the Holograph Interfaces module address
   * @param interfaces address of the Holograph Interfaces smart contract to use
   */
  function setInterfaces(address interfaces) external onlyAdmin {
    assembly {
      sstore(_interfacesSlot, interfaces)
    }
  }

  /**
   * @notice Get the address of the Holograph Messaging Module
   * @dev All cross-chain message requests will get forwarded to this adress
   */
  function getMessagingModule() external view returns (address messagingModule) {
    assembly {
      messagingModule := sload(_messagingModuleSlot)
    }
  }

  /**
   * @notice Update the Holograph Messaging Module address
   * @param messagingModule address of the LayerZero Endpoint to use
   */
  function setMessagingModule(address messagingModule) external onlyAdmin {
    assembly {
      sstore(_messagingModuleSlot, messagingModule)
    }
  }

  /**
   * @notice Get the Holograph Registry module
   * @dev This module stores a reference for all deployed holographable smart contracts
   */
  function getRegistry() external view returns (address registry) {
    assembly {
      registry := sload(_registrySlot)
    }
  }

  /**
   * @notice Update the Holograph Registry module address
   * @param registry address of the Holograph Registry smart contract to use
   */
  function setRegistry(address registry) external onlyAdmin {
    assembly {
      sstore(_registrySlot, registry)
    }
  }

  /**
   * @notice Get the Holograph Utility Token address
   * @dev This is the official utility token of the Holograph Protocol
   */
  function getUtilityToken() external view returns (address utilityToken) {
    assembly {
      utilityToken := sload(_utilityTokenSlot)
    }
  }

  /**
   * @notice Update the Holograph Utility Token address
   * @param utilityToken address of the Holograph Utility Token smart contract to use
   */
  function setUtilityToken(address utilityToken) external onlyAdmin {
    assembly {
      sstore(_utilityTokenSlot, utilityToken)
    }
  }

  /**
   * @dev Internal function used for getting the Holograph Bridge Interface
   */
  function _bridge() private view returns (address bridge) {
    assembly {
      bridge := sload(_bridgeSlot)
    }
  }

  /**
   * @dev Internal function used for getting the Holograph Interface
   */
  function _holograph() private view returns (HolographInterface holograph) {
    assembly {
      holograph := sload(_holographSlot)
    }
  }

  /**
   * @dev Internal function used for getting the Holograph Interfaces Interface
   */
  function _interfaces() private view returns (HolographInterfacesInterface interfaces) {
    assembly {
      interfaces := sload(_interfacesSlot)
    }
  }

  /**
   * @dev Internal function used for getting the Holograph Messaging Module Interface
   */
  function _messagingModule() private view returns (CrossChainMessageInterface messagingModule) {
    assembly {
      messagingModule := sload(_messagingModuleSlot)
    }
  }

  /**
   * @dev Internal function used for getting the Holograph Registry Interface
   */
  function _registry() private view returns (HolographRegistryInterface registry) {
    assembly {
      registry := sload(_registrySlot)
    }
  }

  /**
   * @dev Internal function used for getting the Holograph Utility Token Interface
   */
  function _utilityToken() private view returns (HolographERC20Interface utilityToken) {
    assembly {
      utilityToken := sload(_utilityTokenSlot)
    }
  }

  /**
   * @dev Internal nonce, that increments on each call, used for randomness
   */
  function _jobNonce() private returns (uint256 jobNonce) {
    assembly {
      jobNonce := add(sload(_jobNonceSlot), 0x0000000000000000000000000000000000000000000000000000000000000001)
      sstore(_jobNonceSlot, jobNonce)
    }
  }

  /**
   * @dev Internal function used to remove an operator from a particular pod
   */
  function _popOperator(uint256 pod, uint256 operatorIndex) private {
    /**
     * @dev only pop the operator if it's not a zero address
     */
    if (operatorIndex > 0) {
      unchecked {
        address operator = _operatorPods[pod][operatorIndex];
        /**
         * @dev mark operator as no longer bonded
         */
        _bondedOperators[operator] = 0;
        /**
         * @dev remove pod reference for operator
         */
        _operatorPodIndex[operator] = 0;
        uint256 lastIndex = _operatorPods[pod].length - 1;
        if (lastIndex != operatorIndex) {
          /**
           * @dev if operator is not last index, move last index to operator's current index
           */
          _operatorPods[pod][operatorIndex] = _operatorPods[pod][lastIndex];
          _operatorPodIndex[_operatorPods[pod][operatorIndex]] = operatorIndex;
        }
        /**
         * @dev delete last index
         */
        delete _operatorPods[pod][lastIndex];
        /**
         * @dev shorten array length
         */
        _operatorPods[pod].pop();
      }
    }
  }

  /**
   * @dev Internal function used for calculating the base bonding amount for a pod
   */
  function _getBaseBondAmount(uint256 pod) private view returns (uint256) {
    return (_podMultiplier**pod) * _baseBondAmount;
  }

  /**
   * @dev Internal function used for calculating the current bonding amount for a pod
   */
  function _getCurrentBondAmount(uint256 pod) private view returns (uint256) {
    uint256 current = (_podMultiplier**pod) * _baseBondAmount;
    if (pod >= _operatorPods.length) {
      return current;
    }
    uint256 threshold = _operatorThreshold / (2**pod);
    uint256 position = _operatorPods[pod].length;
    if (position > threshold) {
      position -= threshold;
      //       current += (current / _operatorThresholdDivisor) * position;
      current += (current / _operatorThresholdDivisor) * (position / _operatorThresholdStep);
    }
    return current;
  }

  /**
   * @dev Internal function used for generating a random pod operator selection by using previously mined blocks
   */
  function _randomBlockHash(
    uint256 random,
    uint256 podSize,
    uint256 n
  ) private view returns (uint256) {
    unchecked {
      return (random + uint256(blockhash(block.number - n))) % podSize;
    }
  }

  /**
   * @dev Internal function used for checking if a contract has been deployed at address
   */
  function _isContract(address contractAddress) private view returns (bool) {
    bytes32 codehash;
    assembly {
      codehash := extcodehash(contractAddress)
    }
    return (codehash != 0x0 && codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
  }

  /**
   * @dev Purposefully left empty to ensure ether transfers use least amount of gas possible
   */
  receive() external payable {}

  /**
   * @dev Purposefully reverts to prevent any calls to undefined functions
   */
  fallback() external payable {
    revert();
  }
}
