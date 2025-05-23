<script type="module" src="./resource/js/firebase/login.js"></script>

<script>
  // Firebase 초기화 (config는 본인 프로젝트 설정으로 대체)
  const firebaseConfig = { 
		  apiKey: "AIzaSyCXibVYVj4ljpocuiJQlXTphlfEk2x57_I",
			authDomain: "capstone-ce8e9.firebaseapp.com",
			databaseURL: "https://capstone-ce8e9-default-rtdb.firebaseio.com",
			projectId: "capstone-ce8e9",
			storageBucket: "capstone-ce8e9.firebasestorage.app",
			messagingSenderId: "489016919077",
			appId: "1:489016919077:web:ecb67ba2bf4d72547debcc"
  };
  const app = firebase.initializeApp(firebaseConfig);
  const auth = firebase.auth();
  const db = firebase.firestore();

  auth.onAuthStateChanged(user => {
    if (user) {
      const uid = user.uid;
      db.collection("users").doc(uid).get()
        .then(doc => {
          if (doc.exists) {
            console.log("User data:", doc.data());
          } else {
            console.log("No user data found");
          }
        });
    } else {
      console.log("User not logged in");
    }
  });
</script>
