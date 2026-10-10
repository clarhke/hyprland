import QtQuick
import QtQuick.Controls

Rectangle {
    width: 640
    height: 480
    color: "black"

    Column {
        anchors.centerIn: parent
        spacing: 12

        TextField {
            id: user
            width: 260
            text: userModel.lastUser !== "" ? userModel.lastUser : "arch"
            placeholderText: "username"
            onAccepted: pass.forceActiveFocus()
        }

        TextField {
            id: pass
            width: 260
            echoMode: TextInput.Password
            placeholderText: "password"
            onAccepted: sddm.login(user.text, pass.text, sessionModel.lastIndex)
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            pass.text = ""
            pass.forceActiveFocus()
        }
    }

    Component.onCompleted: pass.forceActiveFocus()
}
