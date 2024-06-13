import hashlib
import time

class Block:
    def __init__(self, index, previous_hash, timestamp, data, nonce=0):
        self.index = index
        self.previous_hash = previous_hash
        self.timestamp = timestamp
        self.data = data
        self.nonce = nonce
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        value = str(self.index) + str(self.previous_hash) + str(self.timestamp) + str(self.data) + str(self.nonce)
        return hashlib.sha256(value.encode('utf-8')).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [self.create_genesis_block()]
        self.tokens = 0
        self.nfts = 0

    def create_genesis_block(self):
        return Block(0, "0", time.time(), "Genesis Block")

    def get_latest_block(self):
        return self.chain[-1]

    def add_block(self, new_block):
        new_block.previous_hash = self.get_latest_block().hash
        new_block.hash = new_block.calculate_hash()
        self.chain.append(new_block)

    def mine_token(self):
        self.tokens += 1
        if self.tokens % 10 == 0:
            self.mine_nft()

    def mine_nft(self):
        self.nfts += 1
        data = f"Minted NFT #{self.nfts}"
        new_block = Block(len(self.chain), self.get_latest_block().hash, time.time(), data)
        self.add_block(new_block)
        print(data)

    def is_chain_valid(self):
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i-1]
            if current_block.hash != current_block.calculate_hash():
                return False
            if current_block.previous_hash != previous_block.hash:
                return False
        return True

    def print_chain(self):
        for block in self.chain:
            print(f"Index: {block.index}")
            print(f"Previous Hash: {block.previous_hash}")
            print(f"Timestamp: {block.timestamp}")
            print(f"Data: {block.data}")
            print(f"Hash: {block.hash}")
            print("--------------")

# Example usage
blockchain = Blockchain()

# Mine 30 tokens
for _ in range(30):
    blockchain.mine_token()

# Print the blockchain
blockchain.print_chain()

# Validate the blockchain
print(f"Is blockchain valid? {blockchain.is_chain_valid()}")
