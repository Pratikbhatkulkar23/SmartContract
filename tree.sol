pragma solidity >=0.5.0 <0.9.0;
0x673C9771dbFE554442c983309Bc5Bf9D3Af01065
contract TreeDonation {
    struct doner {
        string name;
        string message;
        uint256 timestamp;
        address from;
    }

    doner[] doners;
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function Dtree(string memory name, string memory message) public payable {
        require(msg.value > 0, "Please pay greater than 0 ether");
        owner.transfer(msg.value);
        doners.push(doner(name, message, block.timestamp, msg.sender));
    }

    function getdoners() public view returns (doner[] memory) {
        return doners;
    }
}