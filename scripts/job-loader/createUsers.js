const { getUserCollection } = require('./helpers')
const { firestore } = require('firebase-admin')
const users = require('./users.json')

async function main() {
  users.map(user => {
    const docRef = getUserCollection().doc(user.id)
    const userObj = Object.assign({}, user, {
      createdAt: firestore.Timestamp.now(user.createdAt),
      jobHistories: user.jobHistories.map(jobHistory => {
        return Object.assign({}, jobHistory, {
          startDate: firestore.Timestamp.fromMillis(jobHistory.startDate),
          endDate: firestore.Timestamp.fromMillis(jobHistory.endDate),
        })
      }),
    })
    docRef.set(userObj)
  })
}

main().catch(err => console.error(err))
