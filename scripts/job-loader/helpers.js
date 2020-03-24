const admin = require('firebase-admin')
const serviceAccount = require('./serviceAccountKey.json')

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://vouched-1bfc6.firebaseio.com',
})

const db = admin.firestore()

const getPostCollection = () => db.collection('posts')
const getUserCollection = () => db.collection('users')

module.exports = {
  getPostCollection,
  getUserCollection,
}
