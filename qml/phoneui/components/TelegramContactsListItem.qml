import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import "listitems"
import "../js/avatar.js" as Avatar
import "../js/time.js" as Time
import "TelegramColors.js" as TelegramColors

ListItemWithActions {
    id: listitem

    property int userId: 0 // to get avatar if thumbnail not set
    property string photo: ""
    property string title: ""
    property string subtitle: ""
    property bool isOnline: false
    property int lastSeen: 0

    width: parent.width
    height: units.gu(8)
    showDivider: true
    color: TelegramColors.page_background

    Avatar {
        id: imageShape
        anchors {
            top: parent.top
            topMargin: units.dp(4)
            left: parent.left
            leftMargin: units.gu(2)
            bottom: parent.bottom
            bottomMargin: units.dp(4)
            rightMargin: units.gu(1)
        }
        width: height

        chatId: listitem.userId
        chatTitle: listitem.title
        chatPhoto: listitem.photo
    }

    Text {
        id: titleText
        width: implicitWidth
        anchors {
            top: parent.top
            topMargin: units.gu(1)
            left: imageShape.right
            leftMargin: units.gu(1.5)
            right: parent.right
            rightMargin: units.gu(1.5)
        }
        verticalAlignment: TextInput.AlignVCenter

        font.pixelSize: FontUtils.sizeToPixels("large")
        color: TelegramColors.black
        elide: Text.ElideRight
        text: title
    }

    Text {
        id: subtitleText
        anchors {
            top: titleText.bottom
            topMargin: units.gu(0.5)
            left: imageShape.right
            leftMargin: units.gu(1.5)
            right: parent.right
            rightMargin: units.gu(1.5)
        }
        horizontalAlignment: TextInput.AlignLeft
        verticalAlignment: TextInput.AlignVCenter

        font.pixelSize: FontUtils.sizeToPixels("medium")
        color: TelegramColors.grey
        elide: Text.ElideRight
        text: subtitle
    }
}
