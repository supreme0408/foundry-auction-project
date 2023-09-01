//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Test, console} from "../../lib/forge-std/src/Test.sol";

import {DeployChangingNFT} from "../../script/DeployChangingNFT.s.sol";
import {ChangingNFT} from "../../src/ChangingNFT.sol";

contract ChangingNFTTest is Test {
    ChangingNFT changingNft;
    string public constant IMG1_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjQwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgPCEtLSBSZWN0YW5ndWxhciBjYXJkIGJhY2tncm91bmQgLS0+DQogIDxyZWN0IHg9IjIwIiB5PSIyMCIgd2lkdGg9IjI2MCIgaGVpZ2h0PSIzNjAiIHJ4PSIxMCIgcnk9IjEwIiBmaWxsPSIjZjJmMmYyIiBzdHJva2U9ImJsdWUiIHN0cm9rZS13aWR0aD0iMiIgLz4NCg0KICA8IS0tIFNhbXBsZSBpbWFnZSB1c2luZyBiYXNlNjQgZW5jb2RlZCBVUkwgLS0+DQogIDxpbWFnZSB4PSI5MCIgeT0iNjAiIHdpZHRoPSIxMjAiIGhlaWdodD0iMTIwIiBocmVmPSJodHRwczovL2lwZnMuaW8vaXBmcy9RbWVYZTVzVmlmSHQ0b0d3N2hONE1yVlNXU3l6QnI1SmRuV1Jra1F5M1dQMjJiP2ZpbGVuYW1lPXNxdWlydGxlLnBuZyIvPg0KDQogIDwhLS0gVGV4dCBsaW5lcyAtLT4NCiAgPHRleHQgeD0iMTUwIiB5PSIyMjAiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZvbnQtZmFtaWx5PSJBcmlhbCwgc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNCIgZm9udC13ZWlnaHQ9IjYwMCIgZmlsbD0iIzMzMyI+DQogICAgPHRzcGFuIHg9IjEyMCIgZHk9IjUiIGZvbnQtc3R5bGU9Iml0YWxpYyIgZmlsbD0iIzY2NiI+TmFtZTwvdHNwYW4+DQogICAgPHRzcGFuIHg9IjE4MCIgZHk9IjAiPlNxdWlydGxlPC90c3Bhbj4NCiAgICA8dHNwYW4geD0iMTIwIiBkeT0iMjUiIGZvbnQtc3R5bGU9Iml0YWxpYyIgZmlsbD0iIzY2NiI+VHlwZTwvdHNwYW4+DQogICAgPHRzcGFuIHg9IjE4MCIgZHk9IjAiPldhdGVyPC90c3Bhbj4NCiAgICA8dHNwYW4geD0iMTIwIiBkeT0iMjUiIGZvbnQtc3R5bGU9Iml0YWxpYyIgZmlsbD0iIzY2NiI+SFA8L3RzcGFuPg0KICAgIDx0c3BhbiB4PSIxODAiIGR5PSIwIj40NDwvdHNwYW4+DQogICAgPHRzcGFuIHg9IjEyMCIgZHk9IjI1IiBmb250LXN0eWxlPSJpdGFsaWMiIGZpbGw9IiM2NjYiPkF0dGFjazwvdHNwYW4+DQogICAgPHRzcGFuIHg9IjE4MCIgZHk9IjAiPjQ4PC90c3Bhbj4NCiAgICANCiAgPC90ZXh0Pg0KPC9zdmc+DQo=";
    string public constant IMG2_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjQwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgPCEtLSBSZWN0YW5ndWxhciBjYXJkIGJhY2tncm91bmQgLS0+DQogIDxyZWN0IHg9IjIwIiB5PSIyMCIgd2lkdGg9IjI2MCIgaGVpZ2h0PSIzNjAiIHJ4PSIxMCIgcnk9IjEwIiBmaWxsPSIjZjJmMmYyIiBzdHJva2U9ImJsdWUiIHN0cm9rZS13aWR0aD0iMiIgLz4NCg0KICA8IS0tIFNhbXBsZSBpbWFnZSB1c2luZyBiYXNlNjQgZW5jb2RlZCBVUkwgLS0+DQogIDxpbWFnZSB4PSI5MCIgeT0iNjAiIHdpZHRoPSIxMjAiIGhlaWdodD0iMTIwIiBocmVmPSJodHRwczovL2lwZnMuaW8vaXBmcy9RbVBIM2dVSDZxZnFKejh6VG42QTlINzNHaFB2SERSUmRGZXVCNWsxWVZmcHRBP2ZpbGVuYW1lPXdhcnRvcnRsZS5wbmciLz4NCg0KICA8IS0tIFRleHQgbGluZXMgLS0+DQogIDx0ZXh0IHg9IjE1MCIgeT0iMjIwIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmb250LWZhbWlseT0iQXJpYWwsIHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTQiIGZvbnQtd2VpZ2h0PSI2MDAiIGZpbGw9IiMzMzMiPg0KICAgIDx0c3BhbiB4PSIxMjAiIGR5PSI1IiBmb250LXN0eWxlPSJpdGFsaWMiIGZpbGw9IiM2NjYiPk5hbWU8L3RzcGFuPg0KICAgIDx0c3BhbiB4PSIxODAiIGR5PSIwIj5XYXJ0b3J0bGU8L3RzcGFuPg0KICAgIDx0c3BhbiB4PSIxMjAiIGR5PSIyNSIgZm9udC1zdHlsZT0iaXRhbGljIiBmaWxsPSIjNjY2Ij5UeXBlPC90c3Bhbj4NCiAgICA8dHNwYW4geD0iMTgwIiBkeT0iMCI+V2F0ZXI8L3RzcGFuPg0KICAgIDx0c3BhbiB4PSIxMjAiIGR5PSIyNSIgZm9udC1zdHlsZT0iaXRhbGljIiBmaWxsPSIjNjY2Ij5IUDwvdHNwYW4+DQogICAgPHRzcGFuIHg9IjE4MCIgZHk9IjAiPjU5PC90c3Bhbj4NCiAgICA8dHNwYW4geD0iMTIwIiBkeT0iMjUiIGZvbnQtc3R5bGU9Iml0YWxpYyIgZmlsbD0iIzY2NiI+QXR0YWNrPC90c3Bhbj4NCiAgICA8dHNwYW4geD0iMTgwIiBkeT0iMCI+NjM8L3RzcGFuPg0KICAgIA0KICA8L3RleHQ+DQo8L3N2Zz4NCg==";
    string public constant IMG1_SVG_TOKEN_URI =
        "data:application/json;base64,eyJuYW1lIjoiQ0hBTkdJTkcgTkZUIiwgImRlc2NyaXB0aW9uIjoiQW4gTkZUIHRoYXQgY2hhbmdlcyBhY2NvcmRpbmcgdG8gb3duZXJzIHdpbGwuIiwiYXR0cmlidXRlczpbeyJ0cmFpdF90eXBlIjoiYWJzdHJhY3Qgb2JqZWN0In1dLCJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjNhV1IwYUQwaU16QXdJaUJvWldsbmFIUTlJalF3TUNJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWo0TkNpQWdQQ0V0TFNCU1pXTjBZVzVuZFd4aGNpQmpZWEprSUdKaFkydG5jbTkxYm1RZ0xTMCtEUW9nSUR4eVpXTjBJSGc5SWpJd0lpQjVQU0l5TUNJZ2QybGtkR2c5SWpJMk1DSWdhR1ZwWjJoMFBTSXpOakFpSUhKNFBTSXhNQ0lnY25rOUlqRXdJaUJtYVd4c1BTSWpaakptTW1ZeUlpQnpkSEp2YTJVOUltSnNkV1VpSUhOMGNtOXJaUzEzYVdSMGFEMGlNaUlnTHo0TkNnMEtJQ0E4SVMwdElGTmhiWEJzWlNCcGJXRm5aU0IxYzJsdVp5QmlZWE5sTmpRZ1pXNWpiMlJsWkNCVlVrd2dMUzArRFFvZ0lEeHBiV0ZuWlNCNFBTSTVNQ0lnZVQwaU5qQWlJSGRwWkhSb1BTSXhNakFpSUdobGFXZG9kRDBpTVRJd0lpQm9jbVZtUFNKb2RIUndjem92TDJsd1puTXVhVzh2YVhCbWN5OVJiV1ZZWlRWelZtbG1TSFEwYjBkM04yaE9ORTF5VmxOWFUzbDZRbkkxU21SdVYxSnJhMUY1TTFkUU1qSmlQMlpwYkdWdVlXMWxQWE54ZFdseWRHeGxMbkJ1WnlJdlBnMEtEUW9nSUR3aExTMGdWR1Y0ZENCc2FXNWxjeUF0TFQ0TkNpQWdQSFJsZUhRZ2VEMGlNVFV3SWlCNVBTSXlNakFpSUhSbGVIUXRZVzVqYUc5eVBTSnRhV1JrYkdVaUlHWnZiblF0Wm1GdGFXeDVQU0pCY21saGJDd2djMkZ1Y3kxelpYSnBaaUlnWm05dWRDMXphWHBsUFNJeE5DSWdabTl1ZEMxM1pXbG5hSFE5SWpZd01DSWdabWxzYkQwaUl6TXpNeUkrRFFvZ0lDQWdQSFJ6Y0dGdUlIZzlJakV5TUNJZ1pIazlJalVpSUdadmJuUXRjM1I1YkdVOUltbDBZV3hwWXlJZ1ptbHNiRDBpSXpZMk5pSStUbUZ0WlR3dmRITndZVzQrRFFvZ0lDQWdQSFJ6Y0dGdUlIZzlJakU0TUNJZ1pIazlJakFpUGxOeGRXbHlkR3hsUEM5MGMzQmhiajROQ2lBZ0lDQThkSE53WVc0Z2VEMGlNVEl3SWlCa2VUMGlNalVpSUdadmJuUXRjM1I1YkdVOUltbDBZV3hwWXlJZ1ptbHNiRDBpSXpZMk5pSStWSGx3WlR3dmRITndZVzQrRFFvZ0lDQWdQSFJ6Y0dGdUlIZzlJakU0TUNJZ1pIazlJakFpUGxkaGRHVnlQQzkwYzNCaGJqNE5DaUFnSUNBOGRITndZVzRnZUQwaU1USXdJaUJrZVQwaU1qVWlJR1p2Ym5RdGMzUjViR1U5SW1sMFlXeHBZeUlnWm1sc2JEMGlJelkyTmlJK1NGQThMM1J6Y0dGdVBnMEtJQ0FnSUR4MGMzQmhiaUI0UFNJeE9EQWlJR1I1UFNJd0lqNDBORHd2ZEhOd1lXNCtEUW9nSUNBZ1BIUnpjR0Z1SUhnOUlqRXlNQ0lnWkhrOUlqSTFJaUJtYjI1MExYTjBlV3hsUFNKcGRHRnNhV01pSUdacGJHdzlJaU0yTmpZaVBrRjBkR0ZqYXp3dmRITndZVzQrRFFvZ0lDQWdQSFJ6Y0dGdUlIZzlJakU0TUNJZ1pIazlJakFpUGpRNFBDOTBjM0JoYmo0TkNpQWdJQ0FOQ2lBZ1BDOTBaWGgwUGcwS1BDOXpkbWMrRFFvPSJ9";
    string public constant IMG2_SVG_TOKEN_URI =
        "data:application/json;base64,eyJuYW1lIjoiQ0hBTkdJTkcgTkZUIiwgImRlc2NyaXB0aW9uIjoiQW4gTkZUIHRoYXQgY2hhbmdlcyBhY2NvcmRpbmcgdG8gb3duZXJzIHdpbGwuIiwiYXR0cmlidXRlczpbeyJ0cmFpdF90eXBlIjoiYWJzdHJhY3Qgb2JqZWN0In1dLCJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjNhV1IwYUQwaU16QXdJaUJvWldsbmFIUTlJalF3TUNJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWo0TkNpQWdQQ0V0TFNCU1pXTjBZVzVuZFd4aGNpQmpZWEprSUdKaFkydG5jbTkxYm1RZ0xTMCtEUW9nSUR4eVpXTjBJSGc5SWpJd0lpQjVQU0l5TUNJZ2QybGtkR2c5SWpJMk1DSWdhR1ZwWjJoMFBTSXpOakFpSUhKNFBTSXhNQ0lnY25rOUlqRXdJaUJtYVd4c1BTSWpaakptTW1ZeUlpQnpkSEp2YTJVOUltSnNkV1VpSUhOMGNtOXJaUzEzYVdSMGFEMGlNaUlnTHo0TkNnMEtJQ0E4SVMwdElGTmhiWEJzWlNCcGJXRm5aU0IxYzJsdVp5QmlZWE5sTmpRZ1pXNWpiMlJsWkNCVlVrd2dMUzArRFFvZ0lEeHBiV0ZuWlNCNFBTSTVNQ0lnZVQwaU5qQWlJSGRwWkhSb1BTSXhNakFpSUdobGFXZG9kRDBpTVRJd0lpQm9jbVZtUFNKb2RIUndjem92TDJsd1puTXVhVzh2YVhCbWN5OVJiVkJJTTJkVlNEWnhabkZLZWpoNlZHNDJRVGxJTnpOSGFGQjJTRVJTVW1SR1pYVkNOV3N4V1ZabWNIUkJQMlpwYkdWdVlXMWxQWGRoY25SdmNuUnNaUzV3Ym1jaUx6NE5DZzBLSUNBOElTMHRJRlJsZUhRZ2JHbHVaWE1nTFMwK0RRb2dJRHgwWlhoMElIZzlJakUxTUNJZ2VUMGlNakl3SWlCMFpYaDBMV0Z1WTJodmNqMGliV2xrWkd4bElpQm1iMjUwTFdaaGJXbHNlVDBpUVhKcFlXd3NJSE5oYm5NdGMyVnlhV1lpSUdadmJuUXRjMmw2WlQwaU1UUWlJR1p2Ym5RdGQyVnBaMmgwUFNJMk1EQWlJR1pwYkd3OUlpTXpNek1pUGcwS0lDQWdJRHgwYzNCaGJpQjRQU0l4TWpBaUlHUjVQU0kxSWlCbWIyNTBMWE4wZVd4bFBTSnBkR0ZzYVdNaUlHWnBiR3c5SWlNMk5qWWlQazVoYldVOEwzUnpjR0Z1UGcwS0lDQWdJRHgwYzNCaGJpQjRQU0l4T0RBaUlHUjVQU0l3SWo1WFlYSjBiM0owYkdVOEwzUnpjR0Z1UGcwS0lDQWdJRHgwYzNCaGJpQjRQU0l4TWpBaUlHUjVQU0l5TlNJZ1ptOXVkQzF6ZEhsc1pUMGlhWFJoYkdsaklpQm1hV3hzUFNJak5qWTJJajVVZVhCbFBDOTBjM0JoYmo0TkNpQWdJQ0E4ZEhOd1lXNGdlRDBpTVRnd0lpQmtlVDBpTUNJK1YyRjBaWEk4TDNSemNHRnVQZzBLSUNBZ0lEeDBjM0JoYmlCNFBTSXhNakFpSUdSNVBTSXlOU0lnWm05dWRDMXpkSGxzWlQwaWFYUmhiR2xqSWlCbWFXeHNQU0lqTmpZMklqNUlVRHd2ZEhOd1lXNCtEUW9nSUNBZ1BIUnpjR0Z1SUhnOUlqRTRNQ0lnWkhrOUlqQWlQalU1UEM5MGMzQmhiajROQ2lBZ0lDQThkSE53WVc0Z2VEMGlNVEl3SWlCa2VUMGlNalVpSUdadmJuUXRjM1I1YkdVOUltbDBZV3hwWXlJZ1ptbHNiRDBpSXpZMk5pSStRWFIwWVdOclBDOTBjM0JoYmo0TkNpQWdJQ0E4ZEhOd1lXNGdlRDBpTVRnd0lpQmtlVDBpTUNJK05qTThMM1J6Y0dGdVBnMEtJQ0FnSUEwS0lDQThMM1JsZUhRK0RRbzhMM04yWno0TkNnPT0ifQ==";
    address USER = makeAddr("user");

    DeployChangingNFT deployer;

    function setUp() public {
        deployer = new DeployChangingNFT();
        changingNft = deployer.run();
    }

    function testmintNFT() public {
        vm.prank(USER);
        changingNft.mintNFT();
        console.log(changingNft.tokenURI(0));
    }

    function testIfImg1ImageUriIsCorrect() public {
        string memory expectedUri = IMG1_SVG_IMAGE_URI;
        string memory actualUri = changingNft.getImg1Uri();
        console.log(actualUri);
        assertEq(keccak256(abi.encodePacked(actualUri)), keccak256(abi.encodePacked(expectedUri)));
    }

    function testChangeNftToImg2() public {
        vm.prank(USER);
        changingNft.mintNFT();

        vm.prank(USER);
        changingNft.changeNFT(0);
        assertEq(keccak256(abi.encodePacked(changingNft.tokenURI(0))), keccak256(abi.encodePacked(IMG2_SVG_TOKEN_URI)));
    }

    function testChangeNftToImg2ThenImg1() public {
        vm.prank(USER);
        changingNft.mintNFT();

        vm.prank(USER);
        changingNft.changeNFT(0);
        assertEq(keccak256(abi.encodePacked(changingNft.tokenURI(0))), keccak256(abi.encodePacked(IMG2_SVG_TOKEN_URI)));
        vm.prank(USER);
        changingNft.changeNFT(0);
        assertEq(keccak256(abi.encodePacked(changingNft.tokenURI(0))), keccak256(abi.encodePacked(IMG1_SVG_TOKEN_URI)));
    }

    function testCheckNftOwner() public{
        vm.prank(USER);
        changingNft.mintNFT();
        assertEq(changingNft.getNftOwner(0),USER);
    }

    function testTransferNftToContract() public{
        vm.prank(USER);
        changingNft.mintNFT();

        vm.prank(USER);
        changingNft.transferNFT(address(this),0);
        assertEq(changingNft.getNftOwner(0),address(this));
    }
}
