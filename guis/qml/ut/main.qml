import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.PushNotifications 0.1

import 'components'
import 'ui'
import 'ui/pages'

MainView {
	applicationName: "textsecure.nanuc"

	automaticOrientation: false

	anchorToKeyboard: true

	id: root
	objectName: "root"
	property var messagesModel

	visible: true
	width: units.gu(45)
	height: units.gu(80)
	PageStack {
		id: pageStack

		SigninPage {
			id: signinPage
			visible: false
		}

		VerificationCodePage {
			id: verifyCodePage
			visible: false
		}

		Component {
			id: dialogPage
			DialogPage {}
		}

		ChatList {
			id: chatListPage
			visible: false
		}

		Component {
			id: contactsPage
			ContactsPage {}
		}

		Component {
			id: settingsPage
			SettingsPage {}
		}

		Component {
			id: passwordPage
			PasswordPage {}
		}

		Component {
			id: picker
			PickerPage {}
		}

		Component {
			id: previewPage
			PreviewPage {}
		}

		Component {
			id: introPage
			IntroPage {}
		}

		Component.onCompleted: initialize()
	}

	PushClient {
		id: pushClient
		appId: "textsecure.nanuc_textsecure"
		onTokenChanged: {
			//console.log("Push client token is", token)
		}
	}
	//
	function initialize() {
			// if (settingsModel.registered){
			if(settingsModel.encryptDatabase)pageStack.push(passwordPage);
			else{
				if(storeModel.setupDb("")){
					pageStack.clear();
					pageStack.push(chatListPage);
				}
				else {
					settingsModel.encryptDatabase = true
					pageStack.push(passwordPage);
				}
			}
		// }
		// else console.log("Not registered");
	}

	function getPhoneNumber() {
		pageStack.push(signinPage)
	}

	function getVerificationCode() {
		pageStack.push(verifyCodePage)
	}

	function registered() {
		pageStack.push(chatListPage)
	}

	function error(errorMsg) {
		var properties = {'text':errorMsg}
		PopupUtils.open(Qt.resolvedUrl("ui/dialogs/ErrorMessageDialog.qml"), root, properties)
	}

	function openSettings() {
		pageStack.push(settingsPage);
	}

	function openHelp() {
    Qt.openUrlExternally("https://github.com/nanu-c/axolotl/issues")
	}

	function newChat() {
		openContacts(false);
	}

	function newGroupChat() {
		openContacts(true);
	}

	function markAllRead() {
		textsecure.markSessionsRead("")
	}

	function getStoragePassword() {
		pageStack.push(passwordPage)
	}

	function openContacts(groupChatMode) {
		var properties = { groupChatMode: groupChatMode };
		pageStack.push(contactsPage, properties);
	}

	function backToChatListPage() {
		textsecure.leaveChat();
		pageStack.clear();
		pageStack.push(chatListPage);
	}

	function openChatById(chatId, tel, properties) {
		console.log("openChatById")

		if (pageStack.depth > 0 && pageStack.currentPage.objectName === "chatPage") {
			if (pageStack.currentPage.chatId === chatId) return;
		}
		else if(pageStack.depth>1){
			while(pageStack.depth>1){
				pageStack.pop();
			}
		}
		if (typeof properties === "undefined") properties = { };
		// backToChatListPage();
		textsecure.setActiveSessionID(tel)
		textsecure.markSessionsRead(tel)
		messagesModel = sessionsModel.get(tel);
		properties['chatId'] = uid(tel);
		pageStack.push(dialogPage, properties);
	}

	function forwardMessages(messages) {
		var properties = { messagesToForward: messages };
		console.log(messages)
		pageStack.push(chatListPage, properties);
	}

	function uid(tel) {
		return parseInt(tel.substring(3, 10), 16)
	}
	function listApi(){
		console.log(Object.getOwnPropertyNames(textsecure).filter(function (p) {
				return typeof textsecure[p] === 'function';
		}));
	}
	function avatarImage(id) {

		// console.log("get avata: " + id.substring(0, 3));
		return textsecure.getAvatarImage(id)
	}
}
