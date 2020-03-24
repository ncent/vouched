const { getPostCollection } = require('./helpers')
const { firestore } = require('firebase-admin')

async function main() {
  let docRef = getPostCollection().doc()

  docRef.set({
    createdAt: firestore.Timestamp.now(),
    creator: '04LE2UCVOwR2GaLvOmyu65HOSYz1',
    message: 'Test 2',
    private: false,
    subject: 'AWS Developer',
    tags: ['docker', 'aws'],
    userVisibilityMetadata: {},
    visibility: [],
  })
}

main().catch(err => console.error(err))
