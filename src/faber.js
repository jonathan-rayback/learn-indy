const indy = require('indy-sdk')

var faber = {
  name: 'Faber College',
  wallet_config: json.dumps({ id: 'faber-college-wallet', storage_config: null, storage_type: 'default' }),
  wallet_credentials: json.dumps({ key: 'faber,college,wallet' })
}

async function openFaberWallet () {
  faber.wallet = await wallet.open_wallet(faber.wallet_config, faber.wallet_credentials)
}

async function writeFaberDID () {
  // (faber['did'], faber['verkey']) = await did.create_and_store_my_did(faber['wallet'], {})
}

openFaberWallet()
writeFaberDID();

console.log(faber);