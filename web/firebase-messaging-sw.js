importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

// Initialize Firebase in the service worker
firebase.initializeApp({
  apiKey: "AIzaSyCzeCeabl58Nu-aa_q-krXQ3feWOU_W0GY",
  projectId: "priticious-51a56",
  messagingSenderId: "628561256399",
  appId: "1:628561256399:web:57ae6c3909d7468ae13cba"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log("Received background message ", payload);
  
  const notificationTitle = payload.notification?.title ?? "Priticious Dry Fruits";
  const notificationOptions = {
    body: payload.notification?.body ?? "New updates from store!",
    icon: "/favicon.png"
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
