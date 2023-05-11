import { initializeApp } from "https://www.gstatic.com/firebasejs/9.8.1/firebase-app.js";
import { FIREBASE_API_KEY,
            FIREBASE_AUTH_DOMAIN,
            FIREBASE_PROJECT_ID,
            FIREBASE_STORAGE_BUCKET,
            FIREBASE_DATABASE_URL,
            FIREBASE_MESSAGING_SENDER_ID,
            FIREBASE_APP_ID} from "./env.ts";

import {
  addDoc,
  collection,
  connectFirestoreEmulator,
  deleteDoc,
  doc,
  Firestore,
  getDoc,
  getDocs,
  getFirestore,
  query,
  QuerySnapshot,
  setDoc,
  where,
} from "https://www.gstatic.com/firebasejs/9.8.1/firebase-firestore.js";

import { getAuth } from "https://www.gstatic.com/firebasejs/9.8.1/firebase-auth.js";

const app = initializeApp({
  apiKey: FIREBASE_API_KEY,
  authDomain: FIREBASE_AUTH_DOMAIN,
  databaseURL: FIREBASE_DATABASE_URL,
  projectId: FIREBASE_PROJECT_ID,
  storageBucket: FIREBASE_STORAGE_BUCKET,
  messagingSenderId: FIREBASE_MESSAGING_SENDER_ID,
  appId: FIREBASE_APP_ID,
});
const db = getFirestore(app);
const auth = getAuth(app);

export function testFirebase() {
    console.log("testFirebase");
}

console.log(db);
console.log(auth);