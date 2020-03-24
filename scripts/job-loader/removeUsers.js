const { getUserCollection } = require('./helpers')

async function main() {
  const result = await getUserCollection().get()
  result.docs.forEach(async doc => doc.ref.delete())
}

main().catch(err => console.error(err))
