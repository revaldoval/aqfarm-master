const functions = require("firebase-functions"); // Mengimpor fungsi Firebase
const admin = require("firebase-admin"); // Mengimpor Admin SDK
admin.initializeApp(); // Menginisialisasi Admin SDK

// Fungsi untuk menangani perubahan pada database Realtime Firebase
exports.ammoniaNotification = functions.database.ref("data/amoniak")
    .onUpdate((change, context) => {
      const after = change.after.val(); // Mengambil nilai setelah update

      // Cek apakah nilai melebihi 100 dan pastikan nilai tersebut valid
      if (typeof after === "number" && after > 100) {
        const payload = {
          notification: {
            title: "Pengurasan Air", // Judul notifikasi
            body: "Level amoniak melebihi batas, segera kuras air!",
          },
          topic: "ammoniaAlert", // Menentukan topik untuk notifikasi
        };

        // Mengirim notifikasi ke topik "ammoniaAlert"
        return admin.messaging().sendToTopic("ammoniaAlert", payload)
            .then(() => {
              console.log("Notifikasi berhasil dikirim.");
            })
            .catch((error) => {
              console.log("Terjadi kesalahan saat mengirim notifikasi:", error);
            });
      }
      return null;
    });
