const functions = require("firebase-functions"); // Import functions
const admin = require("firebase-admin"); // Import admin SDK
admin.initializeApp();

// Fungsi untuk menangani perubahan pada database Realtime Firebase
exports.ammoniaNotification = functions.database.ref("data/amoniak")
  .onUpdate((change, context) => {
    const after = change.after.val(); // Ambil nilai setelah update

    // Cek apakah nilai melebihi 100
    if (after > 100) {
      const payload = {
        notification: {
          title: "Pengurasan Air", 
          body: "Level amoniak melebihi batas, segera kuras air!"
        },
        topic: "ammoniaAlert"
      };

      // Kirim notifikasi
      return admin.messaging().send(payload)
        .then(() => {
          console.log("Notification sent successfully.");
        })
        .catch((error) => {
          console.log("Error sending notification:", error);
        });
    }
    return null;
  });
