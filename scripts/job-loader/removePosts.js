const { getPostCollection } = require('./helpers')

async function main() {
  const result = await getPostCollection().get()
  result.docs.forEach(async doc => doc.ref.delete())
}

main().catch(err => console.error(err))
