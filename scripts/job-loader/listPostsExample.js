const { getPostCollection } = require('./helpers')

async function main() {
  const result = await getPostCollection().get()
  const data = result.docs.map(doc => doc.data())
  console.log(data)
}

main().catch(err => console.error(err))
