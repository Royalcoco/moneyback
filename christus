import os
from PIL import Image
import moviepy.editor as mpy
import qrcode
from web3 import Web3
import ipfshttpclient

class ImageAndVideoGenerator:
    def __init__(self, image_path, audio_path):
        self.image_path = image_path
        self.audio_path = audio_path

    def generate_image(self, output_path):
        # Assuming you have an image of Christ on the cross saved locally
        image = Image.open(self.image_path)
        image.save(output_path)
        print("Image saved to", output_path)

    def generate_video(self, output_path):
        image_clip = mpy.ImageClip(self.image_path).set_duration(120)  # 2 minutes
        audio_clip = mpy.AudioFileClip(self.audio_path)
        video = image_clip.set_audio(audio_clip)
        video.write_videofile(output_path, codec="libx264", audio_codec="aac")
        print("Video saved to", output_path)

def upload_to_ipfs(file_path):
    with ipfshttpclient.connect() as client:
        res = client.add(file_path)
        print("Upload to IPFS:", res['Hash'])
        return res['Hash']

def mint_nft(image_hash, video_hash, contract_address, private_key, account_address):
    w3 = Web3(Web3.HTTPProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'))
    w3.eth.default_account = account_address
    contract_abi = [...]  # Replace with your contract's ABI
    contract = w3.eth.contract(address=contract_address, abi=contract_abi)
    metadata = {
        "image": f"https://ipfs.io/ipfs/{image_hash}",
        "animation_url": f"https://ipfs.io/ipfs/{video_hash}",
        "name": "Christ on the Cross",
        "description": "A representation of Christ on the cross with the last words spoken."
    }
    metadata_hash = upload_to_ipfs(json.dumps(metadata))

    tx = contract.functions.mintNFT(account_address, f"https://ipfs.io/ipfs/{metadata_hash}").buildTransaction({
        'gas': 70000,
        'gasPrice': w3.toWei('1', 'gwei'),
        'nonce': w3.eth.getTransactionCount(account_address),
    })

    signed_tx = w3.eth.account.sign_transaction(tx, private_key)
    tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)
    print(f"Mint NFT transaction sent with hash: {tx_hash.hex()}")

def main():
    # Configuration
    image_path = "christ_on_cross.jpg"
    audio_path = "last_words.mp3"
    output_image_path = "christ_on_cross_output.png"
    output_video_path = "christ_on_cross_video.mp4"
    contract_address = "0xYourContractAddress"
    private_key = "0xYourPrivateKey"
    account_address = "0xYourAccountAddress"

    # Generate image and video
    generator = ImageAndVideoGenerator(image_path, audio_path)
    generator.generate_image(output_image_path)
    generator.generate_video(output_video_path)

    # Upload image and video to IPFS
    image_hash = upload_to_ipfs(output_image_path)
    video_hash = upload_to_ipfs(output_video_path)

    # Mint NFT on Ethereum
    mint_nft(image_hash, video_hash, contract_address, private_key, account_address)

if __name__ == "__main__":
    main()
