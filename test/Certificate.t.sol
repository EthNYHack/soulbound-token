// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Certificate.sol";

contract CertificateTest is Test {
    Certificate cert;
    string name = "Soulbound Certificate";
    string symbol = "CERT";
    string tokenUri = "QmNod6ARXHZt6Wt5Sn3E6PP7YfKZ3xj3fePw9FdewCoDbs";
    address certifier = address(0x1);
    address user1 = address(0x2);
    address user2 = address(0x3);

    function setUp() public {
        cert = new Certificate(name, symbol);
    }

    function testConstructor_ShouldSetCorrectValues_WhenInitialized() public {
        //assert
        assertEq(cert.name(), name);
        assertEq(cert.symbol(), symbol);
    }

    function testMint_ShouldCreateToken_WhenCalled() public {
        //setUp
        vm.startPrank(certifier);
        //execution
        cert.mintTo(user1, tokenUri);
        //assert
        assert(cert.balanceOf(user1) == 1);
        assertEq(cert.tokenURI(1), tokenUri);
        assertEq(cert.emitterToId(1), certifier);
        assert(cert.enabled(1));
    }

    function testMint_ShouldFail_WhenReceiverIsZero() public {
        //setUp
        vm.startPrank(certifier);
        //execution
        vm.expectRevert("INVALID_RECIPIENT");
        cert.mintTo(address(0), tokenUri);
        //assert
    }

    function testBurn_ShouldRemoveTheCertificate_WhenOwnerCalls() public {
        //setUp
        //execution
        //assert
    }

    function testBurn_ShouldFail_WhenNotOwner() public {
        //setUp
        //execution
        //assert
    }

    function testTransfer_ShouldFail_WhenCalled() public {
        //setUp
        vm.prank(certifier);
        cert.mintTo(user1, tokenUri);
        //execution

        vm.expectRevert("Cannot transfer certificate");
        vm.prank(user1);
        cert.transferFrom(user1, user2, 1);
        //assert
        assert(cert.balanceOf(user1) == 1);
    }

    function testSafeTransfer_ShouldFail_WhenCalled() public {
        //setUp
        vm.prank(certifier);
        cert.mintTo(user1, tokenUri);
        //execution

        vm.expectRevert("Cannot transfer certificate");
        vm.prank(user1);
        cert.safeTransferFrom(user1, user2, 1);
        //assert
        assert(cert.balanceOf(user1) == 1);
    }

    function testRevoke_ShouldFail_WhenNotMinter() public {
        //setUp
        vm.prank(certifier);
        cert.mintTo(user1, tokenUri);
        //execution
        vm.expectRevert("Not Certificate Emitter");
        cert.revoke(1);
        //assert
    }

    function testRevoke_ShouldRevoke_WhenCalledByMinter() public {
        //setUp
        vm.startPrank(certifier);
        cert.mintTo(user1, tokenUri);
        //execution
        cert.revoke(1);
        //assert
        assert(!cert.enabled(1));
    }
}
