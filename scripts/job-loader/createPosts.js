const { getPostCollection } = require('./helpers')
const { firestore } = require('firebase-admin')
const jobs = require('./jobs.json')

async function main() {
  jobs.map(job => {
    const docRef = getPostCollection().doc()
    const jobObj = Object.assign({}, job, {
      createdAt: firestore.Timestamp.now(),
    })
    docRef.set(jobObj)
  })
}

main().catch(err => console.error(err))
