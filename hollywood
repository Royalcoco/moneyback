# Importer les bibliothèques nécessaires
import ipfshttpclient
from web3 import Web3
from solcx import compile_source

# Étape 1: Téléchargez l'image sur IPFS
client = ipfshttpclient.connect('/dns/localhost/tcp/5001/http')
res = client.add('hollywood_image.jpg')
ipfs_hash = res['Hash']
print(f"IPFS Hash: {ipfs_hash}")

# Étape 2: Créer le contrat intelligent en Solidity
contract_source_code = '''
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}
'''

# Compiler le contrat
compiled_sol = compile_source(contract_source_code)
contract_interface = compiled_sol['<stdin>:MyNFT']

# Connexion à un nœud Ethereum (par exemple, Infura)
w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'))

# Déployer le contrat
w3.eth.default_account = w3.eth.accounts[0]
MyNFT = w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])

# Construire la transaction de déploiement
tx_hash = MyNFT.constructor().transact()
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
contract_address = tx_receipt.contractAddress
print(f"Contract deployed at address: {contract_address}")

# Étape 3: Créez le NFT
nft_contract = w3.eth.contract(address=contract_address, abi=contract_interface['abi'])
token_uri = f"ipfs://{ipfs_hash}"

tx_hash = nft_contract.functions.mintNFT(w3.eth.default_account, token_uri).transact()
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print(f"NFT minted. Transaction hash: {tx_hash.hex()}")
