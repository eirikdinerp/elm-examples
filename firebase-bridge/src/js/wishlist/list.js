import firebase from 'firebase/app';
import 'firebase/firestore';

const config = {
  apiKey: 'AIzaSyB7rxWbaaxV2FO6xTzEgLNN7lC5AZrD6d0',
  authDomain: 'dinonskeliste.firebaseapp.com',
  databaseURL: 'https://dinonskeliste.firebaseio.com',
  projectId: 'dinonskeliste',
  storageBucket: 'dinonskeliste.appspot.com',
  messagingSenderId: '864290686606'
};
const settings = { timestampsInSnapshots: true };

firebase.initializeApp(config);

const db = firebase.firestore();
db.settings(settings);

export default function list(user) {
  console.log('Listing wishlists!', db);

  //   db.collection('wishlists').get().then(function(res) {
  //     console.log('RESULT:', )
  //   });
  return db.collection('wishlists').get();
}
